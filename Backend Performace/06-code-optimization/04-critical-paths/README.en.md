# 6.4 — Identifying Critical Paths and High-Volume Endpoints

**Language:** English | [فارسی](README.md)

A request's critical path is the dependency chain that determines when the response finishes. A hot path is code that runs frequently or consumes substantial resources. They may overlap, but are not the same: CPU-heavy background work is not necessarily on the response path, although resource contention can slow requests indirectly.

**Learning goal:** draw dependencies, calculate serial/parallel time, prioritize cost versus latency, and estimate the upper bound of a change. Prerequisites: traces and latency percentiles; see [Profiling](../02-application-profiling/README.en.md) for the definitions used here. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

A trace shows related stages of a request; a span is one operation or interval within it. p95 is a duration by which roughly 95% of observations have finished. A hot path is work that is frequent or expensive; a critical path is a chain of required dependencies that determines response completion. One path can be one without being the other.

## Mental model and selection method

| Question | Data needed | Likely decision |
| --- | --- | --- |
| Why did this request finish late? | Trace including queues and dependencies | Shorten the determining chain |
| Which route consumes the most CPU? | Request rate × CPU per request | Reduce frequent work |
| Why is only p99 bad? | Slow samples, contention, and input distribution | Inspect tail behavior and subgroups |
| Which required work need not delay the response? | Correctness contract and user experience | Remove or move a commitment to the background |

[OpenTelemetry Traces](https://opentelemetry.io/docs/concepts/signals/traces/) explains spans and a request view. A parent span includes its child's time, so adding all span durations does not yield response time. Unsynchronized clocks across machines and insufficient sampling can impair interpretation. Measure queues before the handler too; otherwise the trace may look healthy while the client experience is slow.

1. Choose a clear target such as checkout p95 and a representative load; routes can have different targets.
2. Draw required work and data dependencies; only independent work can safely run in parallel.
3. Examine real fast and slow traces; do not assume there is always one obvious critical branch.
4. Estimate the improvable share and compare it with change cost.
5. Find the path again after the change; the bottleneck may move. Bound concurrency by downstream capacity.

## Worked example

The following scenario is **hypothetical**. Authorization takes 10 ms. Inventory and pricing are then independent and both are required. Encoding at the end takes 10 ms. Times are fixed, with no queueing or parallel-execution overhead.

~~~mermaid
flowchart LR
    A[Authorize: 10 ms] --> B[Inventory: 40 ms]
    A --> C[Price: 120 ms]
    B --> D[Join and encode: 10 ms]
    C --> D
    D --> E[Response]
~~~

~~~text
serial_time   = 10 + 40 + 120 + 10 = 180 ms
parallel_time = 10 + max(40, 120) + 10 = 140 ms
~~~

With parallel work, halving inventory from 40 to 20 ms does not reduce the 140 ms response; price remains the longer branch. Halving price to 60 ms reduces the model to 80 ms. If price depends on inventory results, this parallelization is invalid.

For a simple speedup bound, if 20% of time can be improved and that portion is twice as fast, speedup is <code>1/(0.8+0.2/2) ≈ 1.11</code>. Removing that portion completely would give at most <code>1/0.8 = 1.25</code>. This fixed-share model does not represent queueing, changing load, or tail behavior; measure those effects.

An additional hypothetical comparison: Route A at 1,000 requests/s and 2 ms CPU/request consumes about 2 CPU-seconds/s. Route B at 10 requests/s and 50 ms consumes about 0.5 CPU-seconds/s. A matters more for capacity; B may have a stricter latency objective. Consider rate, product importance, and cost together.

## Exercise with worked solution

Recalculate the example with price at 30 ms and inventory at 40 ms. Then add an 80 ms shared queue before both branches.

**Solution:** after 10 ms authorization, inventory at 40 ms is longer than price at 30 ms, so the response is <span dir="ltr">10 + max(40, 30) + 10 = 60 ms</span>. With the shared queue, total time becomes <span dir="ltr">80 + 60 = 140 ms</span>. Queueing now dominates, so optimizing one computation has a limited effect. In a trace, mark overlapping spans and the chain that determines response completion rather than summing all spans. Do not confuse queue time with time inside the handler.

## Firsthand operational evidence

The **2026** [Discord Voice report](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge) describes a receive loop starving output flush. Adding a time budget for flushing solved part of the issue; infrastructure contention was fixed separately. This is evidence about output scheduling, not a reason to reuse that system's time budget for an HTTP API.

## Costs and failure modes

| Decision/failure | Risk or signal | What to check |
| --- | --- | --- |
| Parallelize every call | Pool saturation and worse p99 | Bound concurrency, queues, and cancellation |
| Move required work to background | Fast response but lost commitment | Acceptance contract, durable storage, and recovery |
| Use averages only | A small group of users is very slow | Percentiles by route, input size, and region |
| Sum all span durations | Estimated time exceeds response time | Overlap and parent/child relationships |
| Remove correctness or authorization checks | Fast but invalid result | Preserve correctness and security requirements |

### Operational checklist

- [ ] Measurement boundary includes queueing and client-visible time.
- [ ] Fast, slow, and large-input traces have been reviewed.
- [ ] Hot-path cost and critical-path latency are prioritized separately.
- [ ] Data dependencies are confirmed before parallelizing.
- [ ] Potential benefit, errors, and resource costs are estimated.
- [ ] After a change, check p99 and whether the bottleneck moved.

## Quiz

1. Is the most CPU-intensive function always on the latency critical path?
2. Why is the time for two required parallel branches usually modeled with their maximum?
3. In the 140 ms example, how much does halving inventory reduce latency?
4. What changes if price depends on inventory?
5. In the fixed-share model, what is the maximum speedup from removing a 20% portion?
6. Why can higher concurrency make the response slower?

### Explained answers

1. No. Work may be frequent or background; a response may wait mainly on I/O.
2. The join must wait for the slowest branch. Under assumptions of simultaneous start and no contention, that branch determines completion.
3. Zero in the fixed model; price at 120 ms remains the longer branch.
4. The steps become serial; pricing cannot start before its inventory input exists.
5. <code>1/0.8 = 1.25</code> times; the remaining 80% still exists. This is only a simple-model bound.
6. CPU, locks, connections, and downstream systems can contend and queue; parallelism does not create unlimited capacity.

## Summary

For latency, use traces to find the chain that determines response completion and its waits. For capacity, inspect high-volume routes and CPU per successful unit. Parallelize only truly independent work, then find the new bottleneck after the change.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and technical provenance.

- **Persian, complementary:** [Distributed tracing](https://pro-nee.net/terms/distributed-tracing/). Introduces traces/spans and following a request path; it is not the source of this lesson's calculations.
- **English, official OpenTelemetry documentation:** [Traces](https://opentelemetry.io/docs/concepts/signals/traces/). Trace and span concepts and request relationships.
- **English, official Google Cloud documentation:** [Traces and spans](https://docs.cloud.google.com/trace/docs/traces-and-spans). A product-specific trace model and request latency view; Cloud Trace is an example implementation, not a requirement.
- **English, Azure Well-Architected guidance:** [Optimize code](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure). Finding hot paths and choosing changes using data.
- **English, firsthand engineering report:** [Discord Voice at the Edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge). A real report about scheduling and starvation.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Previous: Algorithms](../03-algorithms-and-data-structures/README.en.md) · [Next: Language and Runtime](../05-language-and-runtime-choices/README.en.md)

**Related lessons:** [Background jobs](../../03-asynchronism/01-background-jobs/README.en.md) · [Timeouts and retries](../07-timeouts-and-retries/README.en.md) · [Performance testing](../../09-performance-testing/README.en.md)
