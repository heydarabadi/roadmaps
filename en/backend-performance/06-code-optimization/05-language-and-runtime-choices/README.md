# 6.5 — Choosing a Language and Runtime with Measurements

**Language:** English | [فارسی](../../../../fa/backend-performance/06-code-optimization/05-language-and-runtime-choices/README.md)

Language and runtime choices affect memory management, scheduling, libraries, and development cost. They are engineering decisions for a particular workload. **Go and Rust are options**, not universal recommendations for making every backend faster. First profile the workload and critical path, then check which limits can actually be attributed to the runtime.

**Learning goal:** separate CPU/GC/I/O limits, design a fair comparison, account for migration cost, and choose a limited experiment. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

A runtime executes and manages a program. Garbage collection (GC) reclaims memory from objects that are no longer reachable. A just-in-time compiler (JIT) optimizes code while it runs and may need warm-up. In an ownership model, each value has an owner and defined borrowing rules; this can prevent some memory errors before execution, but it does not remove CPU work or I/O waits. CPU time is processor time; wall time is elapsed request time. Waiting on a database does not count as the same amount of CPU time. This distinction is essential when deciding which cost a runtime change targets.

## What evidence would justify a change?

| Evidence | Hypothesis to test | Options before rewriting |
| --- | --- | --- |
| CPU in an algorithm or serialization | Code or an implementation is expensive | Algorithm, library, or remove repeated conversion |
| Significant allocation and GC | Temporary objects are costly | Reduce allocation, review object lifetime, tune carefully |
| Database waiting dominates | The runtime is a small part of elapsed time | Query, pool, batching, locality |
| Event loop is saturated | CPU work or scheduling is unsuitable | Bound work, use workers, improve fairness |
| Need for specific memory/latency control | The current memory model may be unsuitable | A limited prototype on the proven path |

In Go, GC consumes CPU and memory and tuning creates trade-offs; the official [Go GC guide](https://go.dev/doc/gc-guide) explains why allocation and live memory matter. Do not copy another team's default or values to a different workload. In Rust, ownership provides memory-safety guarantees without a tracing GC; the [Rust book](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html) describes the model. No GC does not mean no allocation, lock, queue, or bad latency.

JIT runtimes may be sensitive to warm-up; a development build and release build do not behave identically. A concurrency model alone does not guarantee throughput: CPU work still consumes limited capacity, and async organizes waiting rather than removing required work.

## Worked example: bound the migration benefit

For a **hypothetical** 250 ms request, application work takes 25 ms and dependency waiting takes 225 ms. If a rewritten sample reduces the same work to 5 ms and all other costs stay fixed, total time is 230 ms: only a 20 ms reduction, or about 8%. Making the computation five times faster does not make the whole service five times faster.

If the objective is CPU cost, the same reduction may matter at a high request rate. For 1,000 requests/s, saving 20 ms of CPU time per request would save 20 CPU-seconds/s in the ideal model; this is valid only if 25 and 5 ms are actually **CPU time**, not wall time. Subtract network cost at the new boundary, library work, and serialization.

### Fair comparison plan

~~~text
same input distribution + same output semantics
same CPU/memory quota + comparable optimized builds
record: runtime/compiler version, warmup, dependency versions
measure: successful throughput, p50/p95/p99, CPU/request, peak RSS
also compare: errors, cancellations, numerical/Unicode correctness
~~~

Compare the existing version with reasonable settings for that version. Benchmarking different hashes, removing validation, or returning incomplete data is not a language comparison. Use representative small/large input, cold/warm cache, contention, and long-running work. A microbenchmark is evidence only for the function it measures.

## Exercise with worked solution

For the example, compare two proposals: reduce application work from 25 to 5 ms, or reduce dependency waiting from 225 to 150 ms. Estimate person-days and contract risk for each.

**Solution:** the first proposal removes <span dir="ltr">25 − 5 = 20 ms</span> from 250 ms, leaving 230 ms. The second removes <span dir="ltr">225 − 150 = 75 ms</span>, leaving 175 ms. For latency, the second yields 55 ms more modeled benefit. If the 25 and 5 ms values are CPU time, the first saves 20 CPU-ms per request. If they are wall time, that CPU saving cannot be inferred. Write a short decision note with the hypothesis, success metric, experiment scope, and rollback condition.

## Firsthand evidence and limits

In the **2023** report [How Discord stores trillions of messages](https://discord.com/blog/how-discord-stores-trillions-of-messages), Rust was selected for data services, but the change also involved architecture, traffic control, and request coalescing. The total result cannot be attributed to language alone. The **2026** [Discord Voice report](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge) also describes starvation in a Rust service; a sound language choice does not replace scheduling analysis.

## Fit and decision costs

Go may meet a team's needs with its tools and execution model; Rust may fit paths requiring memory control. Team expertise, drivers, protocol libraries, observability, build time, on-call support, and hiring are part of the cost. Keeping the current stack can be the evidence-based decision. If one bounded computation kernel is the limitation, compare optimizing or replacing just that part with rewriting the entire service; FFI or a separate service adds its own cost.

| Failure | Signal | Action |
| --- | --- | --- |
| Blaming database waiting on language | Low CPU, unchanged latency | Investigate wait path first |
| Unequal benchmark | Different output, authorization, or precision | Match semantics and conditions |
| Removing GC but retaining objects indefinitely | RSS still grows | Inspect object lifetime, cache, and queues |
| Large rewrite without a rollback path | Regression and risky rollout | Limit scope, canary, preserve prior version |
| Team unfamiliar with runtime | Long incident recovery | Plan training, tools, and ownership |

### Operational checklist

- [ ] A profile shows which cost is attributable to the runtime.
- [ ] Algorithm, I/O, and repeated work were checked before migration.
- [ ] Correctness, quota, build, and warm-up are comparable.
- [ ] CPU, RSS, tail latency, errors, and cost per successful unit are measured.
- [ ] Library, training, maintenance, and on-call costs are estimated.
- [ ] A limited experiment and rollback path exist; evidence decides the language.

## Quiz

1. Why does making 10% of request time five times faster not make the whole request five times faster?
2. What does the absence of GC fail to guarantee?
3. Why should a development build not be compared with another language's optimized build?
4. In a service with 90% database waiting, what should be investigated first?
5. Does lower latency always mean lower CPU cost?
6. What claim about Rust cannot be made from the Discord reports?

### Explained answers

1. The other 90% is unchanged; in the fixed model the new fraction is <code>0.9 + 0.1/5 = 0.92</code> of the original.
2. It does not guarantee no allocations, contention, retention, or starvation; those are separate problems.
3. Compiler settings and diagnostic tooling have large effects, so an unequal comparison misattributes results to the language.
4. Trace waiting, query, pool, round trips, and locality. Migration targets only a small part unless other evidence exists.
5. No. Waiting can increase wall time without proportional CPU use; parallelism can also use more resources.
6. That Rust alone caused every improvement or is a universal backend cure; several changes and specific conditions were involved.

## Summary

Before changing languages, use a profile to attribute the limit to CPU, memory, I/O, or scheduling; also inspect algorithms and repeated work. Compare equivalent output, load, quota, and build. Decide using latency, CPU, errors, and the cost of maintaining the stack, not the language's name.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and technical provenance.

- **Persian, Go profiling course:** [Profiling in Go](https://book.gofarsi.ir/chapter-4/profiling/). Discusses allocation, GC, and scheduling for Go; article percentages should not be treated as fixed values for every Go program, and it is not a direct language comparison.
- **English, official Go documentation:** [A Guide to the Go Garbage Collector](https://go.dev/doc/gc-guide). Memory/CPU trade-offs and Go GC behavior.
- **English, official Rust book:** [Understanding Ownership](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html). Defines Rust's memory model without making a universal performance claim.
- **English, official Oracle documentation:** [HotSpot Garbage Collection Tuning Guide](https://docs.oracle.com/en/java/javase/26/gctuning/index.html). GC choices and objectives in Java 26; do not generalize its options to other runtimes.
- **English, official Microsoft documentation:** [C# performance: allocations and copies](https://learn.microsoft.com/en-us/dotnet/csharp/advanced-topics/performance/). Measurement and allocation guidance specific to C#/.NET.
- **English, firsthand engineering report:** [Discord message storage](https://discord.com/blog/how-discord-stores-trillions-of-messages). A contextual Rust choice accompanied by architectural changes.
- **English, firsthand engineering report:** [Discord Voice at the Edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge). A reminder that runtime selection does not eliminate scheduling problems.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Previous: Critical Paths](../04-critical-paths/README.en.md) · [Next: Service Decomposition](../06-service-decomposition/README.en.md)

**Related lessons:** [Scaling](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.en.md) · [Profiling](../02-application-profiling/README.en.md) · [Performance testing](../../09-performance-testing/README.en.md)
