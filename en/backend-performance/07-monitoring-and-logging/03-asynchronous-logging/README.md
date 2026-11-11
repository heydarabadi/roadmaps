# 7.3 — Asynchronous Logging

**Language:** English | [فارسی](../../../../fa/backend-performance/07-monitoring-and-logging/03-asynchronous-logging/README.md)

Asynchronous logging separates delivery to a slow destination from the direct request path: the request gives an event to a buffer and a consumer writes it later. **Returning from a logging call usually means accepted into a buffer, not delivered to storage or durable after a crash.** This can reduce request waiting, but it does not remove serialization, memory, or I/O work.

**Sources reviewed: <span dir="ltr">2026-11-10</span>.** Numbers and pseudocode are instructional assumptions; the official operational example names Apache Log4j. The example is language-neutral.

## Prerequisites defined here

With synchronous logging, the request path is involved until the write or destination wait finishes. With asynchronous logging, the request puts a message in a queue and a separate writer sends it. A bounded queue has a defined capacity. An ACK or acknowledgment from a destination means an agreed acceptance boundary has been reached; without a durability and recovery definition, that alone does not mean the event survives a crash. This lesson explains the boundaries step by step.

## Learning outcomes

- Explain the difference between log acceptance time, search availability, and durability boundary.
- Estimate queue capacity and time to full from production and consumption rates.
- Choose explicit behavior for queue full, crash, shutdown, and destination outage.
- Keep instrumentation overhead, context, and writer failures observable.

## Mental model: what leaves the request path?

| Stage | May still be in request path? | Cost/contract |
| --- | --- | --- |
| Check level and select fields | Yes | Prefer doing this before expensive message creation |
| Snapshot context and permitted data | Yes | Copying, size, and sensitive-data removal |
| Construct/encode message | Depends on implementation | Async may not move this CPU work |
| Enqueue | Yes | Lock/contention, time cap, and full-queue behavior |
| Write and batch-send | Usually on a separate writer | Disk/network, retry, destination error |
| Index and search | At the destination | Delay until event is searchable |

Even writing to <code>stdout</code> can block when its output buffer fills; printing is not automatically fast or durable delivery. A writer on the same machine also shares CPU, disk, and memory with the application. On a single-core machine, moving work to another thread does not necessarily help.

## Define the contract before adding a queue

1. **Separate diagnostic logs from essential history.** Ordinary logs may be dropped under a defined policy. A business event needed for order correctness or audit needs a durable acceptance boundary and failure handling; do not put it in a discardable memory queue. Synchronous writing without a flush, storage, and ACK contract does not provide absolute durability either. Coordinating essential history with a business update may need a transactional record and later delivery; the [jobs and outbox lesson](../../03-asynchronism/01-background-jobs/README.md) describes the boundary between two writes.
2. **Use a bounded queue.** Bound both event count and bytes; a thousand one-kilobyte messages are not equivalent to a thousand large stack traces. Actual memory includes objects, context, queue structure, and batch buffers. Set caps on event size, fields, and stack traces.
3. **Define queue-full behavior.** The choice must fit the event's importance and request latency budget; no option creates unlimited capacity.

| Policy | Benefit | Cost and limit |
| --- | --- | --- |
| Controlled drop or sampling | Protects request and memory budgets | Loses detail; count drops |
| Bounded wait, then explicit decision | Absorbs a short burst | Adds latency; may still fail/drop after the wait |
| Block until capacity opens | Propagates pressure to producer | A slow destination can hold a request indefinitely |
| Durable path with limited capacity | Better crash recovery | More I/O, disk space, ACK, and operations |

Higher-severity events can have quotas or a separate path, but ERROR severity does not guarantee capacity or durability. A synchronous fallback during destination failure can move the same incident into the request path. Define a time limit and failure behavior for that fallback.

4. **Freeze data before crossing the async boundary.** Request context can be cleared after return or reused for another request. Snapshot allowed fields, event time, trace ID, and, if needed, a local sequence number. Do not rely on mutable objects or thread-local data. Remove tokens and personal data before enqueue, not only at display time.
5. **Bound batches and retries.** A larger batch reduces writes but increases delay, memory, and the amount of data exposed to a failure. Flush on count/byte limits and time. Bound retries by backoff, time, and buffer size. A lost ACK can cause resend; do not claim end-to-end ordering or Exactly Once without a destination contract.

## Pseudocode: operational logging with observable drops

This example models diagnostic logs with a **drop-on-full** policy. It is not for audit or essential business events. Queue primitives and the writer implementation are omitted. Each buffer, including a detached batch, has a separate bounded budget.

The background worker repeatedly calls <code>write_one_batch(deadline)</code>. During shutdown, after new input stops, it keeps going only until the queue is drained and the current batch finishes or the shutdown deadline arrives. The worker creates a new monotonic-clock deadline for each call and, while draining, limits it to the remaining shutdown time. Queue wait and sending consume that same budget. Anything still pending at the deadline is not counted as delivered.

~~~text
log_operational(level, context, fields):
    if not level_enabled(level):
        return FILTERED
    event = snapshot_allowlisted_bounded_fields(level, context, fields)
    if not queue.try_enqueue_atomically(event, count_limit, byte_limit):
        dropped_total.increment(reason="queue_capacity")
        return DROPPED
    return ACCEPTED_IN_MEMORY

write_one_batch(deadline):
    batch = queue.take_bounded_batch(max_events, max_bytes, min(max_wait, remaining(deadline)))
    if batch.is_empty:
        return
    result = send_with_bounded_retry(batch, deadline)
    if result.acknowledged:
        delivered_total.add(batch.count)
    else:
        undelivered_total.add(batch.count)
        record_export_failure_via_independent_bounded_signal()
~~~

Counters have bounded labels and do not use the same log queue. Reporting a writer failure through that logger can create a feedback loop. <code>undelivered_total</code> means delivery was not acknowledged within the budget; the destination may have accepted some events. Even an ACK only describes that destination's defined boundary. In this example, a failed batch is not retained after the budget ends, so data may be lost; another durability need requires a different policy.

## Worked example: how long does the queue buy?

Assume production of 5,000 events/s, steady consumption of 4,000 events/s, a queue capacity of 20,000 events, and a fixed decimal 1 kB payload. The queue starts empty; event sizes are equal and the writer runs continuously. Retry and batch details are omitted from this approximation.

~~~text
growth = 5000 - 4000 = 1000 events/s
time_to_full = 20000 / 1000 = 20 s
queued_payload_at_full = 20000 * 1000 = 20,000,000 bytes
after input falls to 2000/s: net drain = 4000 - 2000 = 2000/s
drain_time_from_full = 20000 / 2000 = 10 s
~~~

20 MB is payload only; actual memory is larger. At a steady load after the queue fills, drop policy loses about 1,000 events/s. Blocking slows the producer, so observed production may fall. A larger queue does not increase consumption; it only delays the decision.

With FIFO and constant consumption at 4,000/s, an event accepted near the end of a full queue waits about five seconds to begin service. Fast log acceptance and fast log searchability are different. An API latency graph can look good while high log age delays incident diagnosis.

For a separate request-cost comparison, assume two synchronous sends each wait 3 ms; in an asynchronous model, two enqueues each take 0.05 ms into a queue with capacity. Direct wait falls from about 6 to 0.1 ms in that model, a hypothetical 5.9 ms reduction. That is not measured CPU saving and does not eliminate sending. Serialization or a full queue can reduce or reverse the gain.

## Crash, shutdown, and ordering

For a controlled shutdown, first stop new work and ordinary event production, then let the writer flush with a defined deadline and report completion/remainder. Coordinate that deadline with the process's actual termination window. A timed-out flush may be incomplete; a crash, power loss, or forced kill does not allow shutdown flushing. A disk buffer can reduce risk, but define what stage is durable and how to recover it after restart.

Multiple writers, batches, and retries can change observed order. Store event time separately from receive time. Use trace IDs and event relationships to analyze one request. Do not call destination arrival order a guaranteed global order across machines.

## Official operational evidence and limits

> The [Apache Log4j Async Loggers guide](https://logging.apache.org/log4j/2.x/manual/async.html) explains that sustained load above Appender capacity fills the queue and makes write-error reporting harder from the request path. In that product, the default full-queue behavior blocks the caller, and a discard policy exists for selected levels. Do not generalize those settings to every logger.
>
> The guide also warns about mutable-message snapshots and choosing synchronous handling for audit. This is official operational documentation; it is not a production study for this lesson's assumed load or a broadly reusable performance number. The pseudocode above uses a different instructional drop policy and is not Log4j's default.

## When async logging fits or is a poor choice

Async logging can fit when destination wait costs the critical path and a short delay or bounded loss of diagnostic detail is acceptable. If the current logger has negligible cost, an extra thread, queue, and shutdown contract may be needless complexity. If production continuously exceeds consumption, the main remedy is reducing data, choosing a suitable destination, or increasing actual capacity. For essential loss-intolerant records, solve the durability and failure protocol first; the word “async” does not define it.

## Exercise with worked solution

Assume production of 3,000 events/s, consumption of 2,000/s, and an empty queue with capacity 10,000. Calculate time to full. Then model a total destination outage, with consumption zero, from an empty queue. For each case, describe drop, block, and bounded durable-queue behavior. Finally, suppose 400 in-memory events remain when the process suddenly crashes.

**Solution:** under normal load, net queue growth is <span dir="ltr">3000 − 2000 = 1000</span> events/s, so <span dir="ltr">10,000 ÷ 1,000 = 10</span> seconds to full. During a total destination outage, growth is <span dir="ltr">3,000</span> events/s, so <span dir="ltr">10,000 ÷ 3,000 ≈ 3.33</span> seconds to full. Drop keeps memory bounded by losing events; block moves waiting/pressure to the request; a durable queue helps only within its capacity and ACK contract. The 400 memory-resident events may be lost in a crash. Flushing on controlled shutdown does not prove crash durability. This exercise does not run a real outage or measure performance.

| Failure | Signal | What to inspect |
| --- | --- | --- |
| Unbounded queue | Rising RAM, GC, and OOM | Count/byte cap and event-size cap |
| Silent drop | Complaints with too few logs | Independent drop counter and data age |
| Unbounded retry to unavailable destination | Old queue and full disk | Retry budget and terminal policy |
| Logger reports its own failure through itself | Repeated errors and CPU growth | Independent, bounded error path |
| Mutable object after enqueue | Wrong context or another request's data | Safe snapshot before async boundary |
| Unlimited synchronous fallback | p99 spike during incident | Wait cap and queue-full contract |
| Relying on shutdown for durability | Last events missing after crash | Durable boundary/recovery; separate audit contract |

### Operational checklist

- [ ] In-memory acceptance, destination ACK, and durable storage are distinct.
- [ ] Diagnostic logs and essential history have appropriate contracts.
- [ ] Queue and batch have count/byte bounds; messages and context are bounded too.
- [ ] Queue-full, retry, and terminal-failure policies are observable.
- [ ] Drops, queue, event age, writer failures, and API time are visible together.
- [ ] Sensitive data and mutable objects are controlled before enqueue.
- [ ] Shutdown, crash, destination outage, and ordering are reviewed.
- [ ] Async benefit is measured with representative load and CPU/memory costs.

## Review quiz

1. Does <code>ACCEPTED_IN_MEMORY</code> mean a log can be recovered after a crash?
2. With 5,000 inputs/s, 4,000 outputs/s, and capacity 20,000, when does the queue fill?
3. Does doubling the queue solve a production rate that is always higher than consumption?
4. Why does an ERROR level not guarantee delivery?
5. Why snapshot context before crossing the async boundary?
6. Is “we flush on shutdown” sufficient durability for audit?
7. Does a send timeout prove that the destination received nothing?
8. Why should drops and writer errors not be reported only through the same logger?

### Explained answers

1. **No.** It means only that an in-memory queue accepted the event; a crash can lose it before sending.
2. **About 20 seconds.** Net growth is 1,000 events/s; assume an empty queue and constant rates.
3. **No.** It delays filling but does not remove the rate difference; change production, consumption, or admission policy.
4. **Severity is not storage, capacity, or durability.** Even a separate path has limits; define queue-full and ACK/durability contracts.
5. **Context lifetime or value can change.** A bounded immutable snapshot avoids swapped IDs and concurrency bugs.
6. **No.** A crash may prevent shutdown and flush may time out; essential audit needs a durable boundary and failure handling.
7. **No.** Receipt or ACK may be unknown; retry can duplicate. <code>undelivered</code> means no confirmation within budget, not proof of no receipt.
8. **A failed path cannot be its only witness.** A full queue could drop its own drop message or create an error loop; use an independent bounded counter/path.

## Summary

Asynchronous logging separates destination wait from requests, but message construction, memory, and sending remain. For a bounded queue, monitor production/consumption and event age, and define full-queue behavior. Do not confuse diagnostic logs with audit history. If delivery or durability is essential, design acceptance, ACK, retry, and recovery as a separate contract.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and implementation-specific operational documentation.

- **Persian source gap:** no directly relevant, reviewable Persian article about bounded application log queues, Queue Full, and async durability was identified in the source review. This page explains those distinctions directly; database transaction logs and delayed durability are not substitutes.
- **English, official Apache documentation:** [Log4j Async Loggers](https://logging.apache.org/log4j/2.x/manual/async.html). Queue trade-offs, full-queue policy, mutable messages, and audit; an implementation example, not a Java/Log4j requirement.
- **English, official Python documentation:** [QueueHandler and QueueListener](https://docs.python.org/3/library/logging.handlers.html#queuehandler). Moves handler work to a separate thread; queue type and full-queue behavior still need a policy.
- **English, Serilog implementation documentation:** [Async sink wrapper](https://github.com/serilog/serilog-sinks-async). Bounded queue, drops, and shutdown flushing; an example implementation, not a general durability guarantee.
- **English, Pino implementation documentation:** [Asynchronous logging](https://github.com/pinojs/pino/blob/main/docs/asynchronous.md). Buffering and possible loss of recent events during a crash; Lambda and flush behavior are specific to that runtime/transport.
- **English, official OpenTelemetry operational documentation:** [Collector resiliency](https://opentelemetry.io/docs/collector/resiliency/). Downstream export queue and data-loss boundaries. A Collector is not the application logger; inspect both boundaries separately.

**Navigation:** [Chapter index](../README.en.md) · [Course index](../../README.en.md) · [Previous: Monitoring Toolchain](../02-monitoring-toolchain/README.en.md) · [Signals and instrumentation cost](../01-metrics-logs-and-traces/README.en.md) · [Background jobs and durable acceptance](../../03-asynchronism/01-background-jobs/README.en.md)
