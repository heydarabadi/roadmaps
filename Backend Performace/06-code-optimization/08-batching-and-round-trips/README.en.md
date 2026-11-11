# 6.8 — Batching and Reducing Round Trips

**Language:** English | [فارسی](README.md)

Batching groups compatible, independent operations into one call so fixed costs such as connection handling, headers, dispatch, or a network round trip are shared. It does not necessarily reduce the actual computation. A larger batch can improve throughput while worsening wait latency, memory use, or the scope of a failure.

**Learning goal:** calculate round-trip cost, distinguish batching from coalescing and concurrency, set count/byte/time bounds, and recover from partial failures. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

A round trip is the time for a request to travel to a destination and for a response or acknowledgment to return; network delay and dispatch costs add to the actual work. A batch carries several operations in one request. Coalescing turns concurrent work for the same key into one shared computation. Concurrency runs separate work at the same time. A partial failure means some batch members succeed while others fail.

## Mental model and selection

| Method | What changes? | Cost or limit |
| --- | --- | --- |
| Multiple serial calls | Each operation has a separate round trip | Accumulated latency |
| Bounded parallel calls | Round trips overlap | Work count and downstream pressure remain |
| Batch | Several operations share one envelope | Batch-fill wait, payload size, partial failures |
| Request coalescing | Concurrent requests for the same data share work | Key/authorization matching and subscriber management |
| Connection reuse | The connection is not recreated | Request count is not necessarily reduced |

The [Azure Chatty I/O guidance](https://learn.microsoft.com/en-us/azure/architecture/antipatterns/chatty-io/) describes the cumulative overhead of many small calls. HTTP/2 or persistent connections change setup and overlap costs, but each query and dispatch can still cost something. For databases, evaluate a batch or join against result size and query shape; a huge <code>IN</code> clause or join over several large relations can increase load.

### Design process

1. Measure calls/request, bytes, and fixed time per call. If computation dominates, round-trip savings are limited.
2. Group operations only within the correct authorization and semantic boundaries. A batch must not expose data across tenants.
3. Flush at whichever occurs first: count limit, byte limit, maximum wait, or proximity to the deadline.
4. Return an independent result and identifier for each item; either guarantee ordering or let callers restore it by identifier. Define atomicity explicitly.
5. Retry only failed, retryable members. Re-sending successful writes requires idempotency.
6. Tune size and wait time against p99, successful throughput, and downstream pressure, not just a lower call count.

## Worked example

**Hypothetical model:** there are 20 independent lookups. Each serial round trip costs 15 ms and processing each item costs 1 ms; transfer and queueing are omitted for simplicity.

~~~text
20 serial calls:       20 * (15 + 1) = 320 ms
1 batch of 20 items:   15 + 20 * 1   = 35 ms
2 serial batches/10:   2 * (15 + 10) = 50 ms
~~~

35 ms is not guaranteed in a real implementation. A batch implementation might still do serial calls internally and the larger payload may create more queueing. If we wait up to 10 ms to form a batch, the first item can wait roughly 10 extra milliseconds. At low load, a batch that waits indefinitely for 20 items may never complete; use a timer.

An instructional response contract:

~~~json
{
  "results": [
    {"request_id": "r1", "status": "ok", "value": 42},
    {"request_id": "r2", "status": "retryable_error", "code": "TEMPORARY"},
    {"request_id": "r3", "status": "not_found"}
  ]
}
~~~

Under this contract, success of the envelope does not mean every member succeeded. Only <code>r2</code> is a retry candidate, and only with a budget and safe-repeat guarantee. In this example, <code>not_found</code> is final. If the whole envelope has no response, all member outcomes may be unknown; writes need idempotency or a way to check status.

## Exercise with worked solution

Consider a batch limited to 10 items, 64 KiB, and 5 ms of wait. Three 1 KiB items arrive at 0, 1, and 2 ms; then a single 70 KiB item arrives.

**Solution:** at 5 ms, only <span dir="ltr">3 KiB</span> of the byte limit and <span dir="ltr">3/10</span> of the count limit are used. The max-wait timer still flushes the batch, so it does not wait indefinitely under light load. The 70 KiB item is larger than the 64 KiB limit and must be rejected, safely split, or routed separately under the contract; meaningless splitting of JSON is not a solution. If two of ten members fail retryably and eight succeed, resend only the two failed identifiers. If the whole envelope has no response, use idempotency or a status lookup for the unknown outcome.

## Firsthand operational evidence

In the **August 17, 2020** report [Meta Async](https://engineering.fb.com/2020/08/17/production-engineering/async/), multiple jobs were combined into a mega-job to reduce queue and dispatcher/worker round trips; the worker still performed each member's work. The article also considers delay tolerance. That experience is about a job system and does not prove that the same waiting time fits an interactive API.

In **2023**, [Discord](https://discord.com/blog/how-discord-stores-trillions-of-messages) also connected simultaneous requests for the same row to one shared query. This is **coalescing**, distinct from batching different identifiers and from a persistent result cache.

## Failures and signals

| Failure | Signal | Action |
| --- | --- | --- |
| Waiting only for a full batch | High latency at low load | Add max-wait and flush near deadline |
| Count limit only | One large item breaks RSS | Add byte limit and a large-single-item policy |
| One slow member holds the batch | High tail latency and group deadline | Bound size and define partial results |
| Retry the whole batch | Repeated side effects or cost | Return per-member result and use idempotency |
| Mixed tenants share authorization | Data disclosure | Check context and authorization per member |
| Fewer calls but heavier database work | More CPU, locks, or rows read | Inspect query plan and result volume |

### Operational checklist

- [ ] Fixed call cost and per-item work are measured separately.
- [ ] Maximum count, bytes, wait time, and concurrency are defined.
- [ ] Deadline and cancellation semantics for an item and a batch are clear.
- [ ] Authorization, order, atomicity, and partial failure are defined.
- [ ] Retry does not resend successful members without a safe contract.
- [ ] Batch size, fill ratio, queue wait, bytes, p99, and per-item failures are monitored.

## Quiz

1. Which part of cost does batching target?
2. Why is a maximum of 100 items not sufficient?
3. In the 20-item example, what is the ideal time for one batch without waiting?
4. What is the difference between coalescing and batching different keys?
5. If two members fail, why might retrying the whole batch be wrong?
6. Does connection reuse automatically reduce the number of application queries?

### Explained answers

1. It shares fixed call/round-trip cost; it does not necessarily remove the actual member work.
2. At low load it may never fill, and one large item can exceed memory. Bound time and bytes too.
3. 35 ms in the hypothetical model: 15 ms fixed plus 20 ms of item processing, excluding queue, transfer, and other overhead.
4. Coalescing shares work for the same key; a batch carries different operations in one envelope.
5. Successful members might repeat side effects and cost. Track each member's result and retry safely.
6. No. The same connection is reused, but the application may still send the same number of requests or queries.

## Summary

Batching spreads fixed round-trip cost across operations, but does not remove actual work or downstream pressure. Bound batches by count, bytes, and wait time. Define each member's result, authorization, ordering, and atomicity. For partial retry, resend only failed safe members within a shared budget.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and technical provenance.

- **Persian, complementary glossary:** [Batch requests](https://pro-nee.net/terms/batch-requests/). Introduces batching and partial failure; the page could not be fully fetched during the earlier review, so it is not normative.
- **English, Azure architecture guidance:** [Chatty I/O](https://learn.microsoft.com/en-us/azure/architecture/antipatterns/chatty-io/). Cost of frequent calls and batching trade-offs.
- **English, Redis documentation:** [Pipelining](https://redis.io/docs/latest/develop/using-commands/pipelining/). Round-trip and batch-size effects; see its warning about server memory used for queued replies.
- **English, GraphQL reference implementation:** [DataLoader](https://github.com/graphql/dataloader). A reference for batching and per-request caching; create it according to each request's authorization context and cache lifetime.
- **English, firsthand engineering report:** [Meta Async](https://engineering.fb.com/2020/08/17/production-engineering/async/). Batching background jobs while considering delay tolerance.
- **English, firsthand engineering report:** [Discord message storage](https://discord.com/blog/how-discord-stores-trillions-of-messages). Same-key request coalescing and routing, a mechanism distinct from batching.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Previous: Timeouts and Retries](../07-timeouts-and-retries/README.en.md)

**Related lessons:** [ORM fetching](../../04-databases/03-orm-fetch-strategies/README.en.md) · [Connection reuse](../../10-network/02-connection-reuse/README.en.md) · [Critical paths](../04-critical-paths/README.en.md) · [Performance testing](../../09-performance-testing/README.en.md)
