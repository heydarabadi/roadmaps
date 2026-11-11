# Chapter 6 — Code Optimization

**Language:** English | [فارسی](../../../fa/backend-performance/06-code-optimization/README.md)

Optimization means producing correct behavior with appropriate time, memory, and cost for the real workload. This chapter focuses on finding unnecessary work and limiting resource use. Shorter code or a language change alone is not success; user experience, error rate, and cost per operation should improve.

**Prerequisites:** the HTTP request lifecycle, CPU and memory, I/O, latency percentiles, and introductory data structures. Sources reviewed: **2026-11-10**. Topics follow the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). Numerical examples are instructional; they are not local execution or production results.

## Study order and decision method

Folder numbers match the roadmap. For a real performance investigation, begin with lessons **6.2** and **6.4**. Establish a measurement boundary and baseline, identify the bottleneck type, then choose one small, reversible change. Each guide teaches its prerequisites, mechanism, worked example, exercise, and answers on the page. Links are optional further reading or technical provenance; they are not required to understand a lesson or continue the sequence. Microsoft's [code optimization guidance](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure) is additional support for measuring and identifying expensive paths first.

| Lesson | Main question | Learning outcome |
| --- | --- | --- |
| [6.1 Streaming large bodies](01-streaming-large-bodies/README.md) | Must all data be in memory before it can be sent? | Bounded streams, cancellation, and backpressure |
| [6.2 Application profiling](02-application-profiling/README.md) | Where is time actually spent? | Select CPU/heap/wait profiles and read evidence |
| [6.3 Algorithms and data structures](03-algorithms-and-data-structures/README.md) | How does cost grow with input size? | Remove unnecessary scans and sorting while accounting for memory |
| [6.4 Critical paths](04-critical-paths/README.md) | Which dependency determines request completion? | Separate frequent or CPU-heavy work from latency-critical work |
| [6.5 Language and runtime choices](05-language-and-runtime-choices/README.md) | Is the current limit attributable to the runtime? | Compare fairly and account for migration and team costs |
| [6.6 Service decomposition](06-service-decomposition/README.md) | Which constraint would separation solve? | Weigh independent scaling against distributed-system overhead |
| [6.7 Timeouts and retries](07-timeouts-and-retries/README.md) | When should waiting or retrying stop? | Deadline budgets, jitter, and safe retries |
| [6.8 Batching and round trips](08-batching-and-round-trips/README.md) | What fixed cost is paid per call? | Bounded batches with time, byte, and partial-failure limits |

## Chapter-wide scenario

At peak load, a hypothetical reporting service slows down its list endpoint and uses a great deal of memory during export. Before rewriting, a profile shows that the report buffers every row and makes one serial call per identifier. A trace shows that price lookup is the main dependency on the interactive response path.

1. Record separate baselines for the list and export: p50/p95/p99, errors, accepted and completed throughput, peak memory, and CPU per successful request.
2. For export, assess streaming with bounded buffers and cancellation when the client disconnects. For lookups, compare a data-structure change or batching on the same inputs.
3. Draw the request path, run independent work with bounded concurrency, remove unnecessary work, and move deferrable work to the background only when the product contract permits it.
4. Set a shared deadline and bounded retries; extra attempts must not consume capacity during overload.
5. Build a limited language-change or service-extraction experiment only if the remaining evidence points to a runtime limit or a need for independent scaling.
6. Compare under the same load and roll back if errors, cost, or p99 worsen. Lower CPU alongside fewer successful results is not an improvement.

## Connections to other chapters

- [Performance testing](../09-performance-testing/README.md): establish baselines, compare changes, and detect regressions; a microbenchmark cannot replace representative load.
- [Network](../10-network/README.md): locality and connection reuse; batching reduces trips, but physical distance still matters.
- [Monitoring and logging](../07-monitoring-and-logging/README.md): metrics show trends, traces show request paths, and profiles show in-process costs.
- [Databases](../04-databases/README.md): if the time is in the database, an application algorithm alone is not enough.
- [Asynchronism](../03-asynchronism/README.md): moving work out of the response path requires a completion contract, queue, and recovery plan.

## Chapter review checklist

- [ ] State the problem with a route, input type, workload, and measurable target.
- [ ] Profile and identify the critical path before rewriting.
- [ ] Examine memory, CPU, wait time, and call count separately.
- [ ] Account for growing input, slow clients, partial failures, and cancellation.
- [ ] Keep timeouts, retries, and batching within a bounded budget.
- [ ] Tie Go/Rust or microservices proposals to evidence and migration cost.
- [ ] Distinguish instructional examples, operational documentation, and company reports.
- [ ] Evaluate results under representative load using correctness, errors, and cost.

**Navigation:** [Course index](../README.md) · [Previous: Load Balancing and Scaling](../05-load-balancing-and-scaling/README.md) · [Next: Monitoring and Logging](../07-monitoring-and-logging/README.md)
