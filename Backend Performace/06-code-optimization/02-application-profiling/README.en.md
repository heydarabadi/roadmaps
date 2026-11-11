# 6.2 — Application Profiling

**Language:** English | [فارسی](README.md)

A profile is a picture of resource use inside an application over a defined interval and workload. It turns “this function is probably slow” into evidence. **Measure first, then choose a change**; rewriting without identifying the limit may only speed up the cheap part.

**Learning goal:** choose a suitable profile, separate CPU from waiting, interpret Self/Total and flame graphs, and compare before/after under equivalent conditions. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

A function is a group of instructions; a call stack is the chain of functions called to do some work. CPU time is time the processor actually spent on the process. Wall-clock time is elapsed time from start to finish and includes network or queue waits. A profile collects resource samples or events over an interval; sampling is a statistical estimate, not a record of every instruction.

## Mental model: four different questions

| Tool | Question | What it does not prove by itself |
| --- | --- | --- |
| CPU profile | Which stacks account for processor samples? | Full time spent waiting on network or queues |
| Allocation/heap profile | Where is memory allocated or retained? | Every allocation is a leak |
| Lock/block/wait profile | Where is work waiting for a resource or coordination? | The root cause without context |
| Request trace | Which dependency or ordering delayed the response? | Details of every internal function |

The official [Go diagnostics guide](https://go.dev/doc/diagnostics) explains choices among profiles, traces, and runtime statistics. Profile names and meanings differ across runtimes; even a heap view may represent live memory at a point in time or cumulative allocation. Check the graph's label.

In a sampling profiler, a high sample count suggests that a stack accounts for a larger share of the measured quantity; it is an estimate. <code>Self</code> is a function's own share; <code>Total/Cumulative</code> includes its children. Summing all Total rows double-counts. In a typical flame graph, width represents sample share; the horizontal axis is usually not a timeline. Check the tool's exact interpretation.

## Method

1. Narrow the problem: route, input, version, load intensity, and symptom. Do not equate response wall time with process CPU time.
2. Capture a representative window that includes slow conditions. Record the optimized build, symbols, and runtime version. Document JIT warm-up and cold/warm caches.
3. Start with a low-overhead tool, then choose CPU, memory, or wait profiling based on the signal. Compare tool overhead with the baseline.
4. Correlate the result with traces and metrics. Low CPU with a long queue can indicate I/O or pool waiting.
5. Choose one testable cause. After changing it, compare the same load and the same definition of a successful result.

## Worked example

The following data is **hypothetical**; one request has three serial stages with no overlap:

| Stage | Wall time | CPU time |
| --- | ---: | ---: |
| Waiting for pool and database | 160 ms | 2 ms |
| Constructing and encoding response | 30 ms | 30 ms |
| Sending and waiting for consumer | 10 ms | 1 ms |

A CPU profile will likely emphasize encoding because it accounts for 30 of 33 ms of CPU time, while the response takes 200 ms. Halving encoding saves 15 ms in this model, yielding a 185 ms response. To meet a 100 ms target, investigate the 160 ms stage using a trace, pool queue, and database instrumentation. Reducing CPU can still improve cost and capacity, but cannot meet the response target on its own.

In a hypothetical heap sample, if each request allocates 2 MiB and only 30 KiB remains after collection, allocation is high. To claim a leak, inspect retained live memory and its growth over a longer interval.

## Exercise with worked reasoning

Split a small handler in any language into repeated computation and a simulated I/O wait. Keep its output unchanged. Increase the wait once, then increase the computation once. If no profiler is available, build a time/CPU table like the one above.

**Expected reasoning:** hold computation at 10 ms and increase the wait from 20 to 100 ms. Wall time grows by 80 ms, but CPU time remains about 10 ms; the CPU profile should not attribute the network wait to the computation. If computation increases from 10 to 20 ms while the wait stays at 20 ms, both wall time and CPU time rise by about 10 ms. Compare several short recordings because nearby percentages can vary with sampling. Do this locally; do not expose a production profiling endpoint publicly.

## Operational evidence

In the **June 9, 2026** report [Discord Voice at the Edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge), the team first used probes to narrow the latency boundary to inside the VM, then used per-thread CPU sampling and a flame graph to identify starvation in a receive loop. The first fix did not resolve every spike; further investigation exposed infrastructure contention. The account shows why profiles should be combined with other evidence; choosing Rust did not prevent starvation.

## Costs, failure modes, and operations

Profilers can alter scheduling, CPU use, or pauses; heap snapshots can be expensive in some runtimes. Limit capture scope and control access because function names, paths, and sometimes memory contents can be sensitive. A profile from small inputs without contention will not show lock behavior under load. CPU percentages cannot be compared directly across different core counts or container quotas; record CPU time per successful unit of work as well.

| Mistake | Signal | Correction |
| --- | --- | --- |
| Profiling without a slow request | No bottleneck is found | Use a representative window and correlate with latency |
| Summing cumulative functions | Shares exceed the total | Separate Self from parent/child relationships |
| Calling allocation a leak | Live heap is stable but allocation is high | Inspect retention and GC trends separately |
| Comparing different builds or loads | Apparent gain accompanies errors or lower output | Hold conditions and success criteria constant |

### Operational checklist

- [ ] Code/runtime version, hardware, CPU quota, and load pattern are recorded.
- [ ] Each metric, trace, and profile answers a distinct question.
- [ ] Tool overhead, capture duration, and sampling rate are known.
- [ ] Symbols, Self/Total, and heap-profile type are understood.
- [ ] Errors, successful throughput, and p99 are compared alongside resource use.
- [ ] Profiles and diagnostic endpoints have limited access and retention.

## Quiz

1. Why is the hottest CPU function not necessarily the largest source of latency?
2. What does a function's Total include, and why can summing Totals mislead?
3. Does a stable heap alongside high allocation prove a leak?
4. What does a frame's width in a typical flame graph mean?
5. What data would you add for a slow request with low CPU use?
6. If the new version uses less CPU but rejects half of requests, has it improved?

### Explained answers

1. CPU time does not fully include database, network, or queue waiting; latency depends on the full path.
2. The function and its children; child time can appear under multiple parents and be counted more than once.
3. No. Temporary objects can be freed. Inspect live-memory growth and retaining references.
4. Share of samples for the selected measurement; horizontal ordering usually is not event time.
5. A trace and durations for pool wait, I/O, locks, and queues. An off-CPU cause is plausible but must be measured.
6. No improvement is established. Fewer requests succeeded; compare cost per success and error rate under acceptable criteria.

## Summary

A CPU profile shows processor use, not all request waiting. Heap/allocation and wait profiles answer separate questions. Connect them to the affected route and interval with traces and metrics, change one supported cause, and remeasure with the same load, successful output, and execution conditions.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve its exercise; they provide additional reading and technical provenance.

- **Persian, official translated Python documentation:** [Sampling profiler](https://docs.python.org/fa/3/library/profiling.sampling.html). Explains statistical sampling; this page documents Python 3.15 APIs and should not be treated as guidance for older Python versions.
- **English, official Go documentation:** [Diagnostics](https://go.dev/doc/diagnostics). Choosing among <code>pprof</code>, CPU/heap profiles, and tracing in Go.
- **English, official .NET documentation:** [.NET profiling tools](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/profilers). CPU, memory, and stack profiling with .NET tools; availability depends on platform and version.
- **English, official Oracle documentation:** [Troubleshoot performance issues using Java Flight Recorder](https://docs.oracle.com/en/java/javase/26/troubleshoot/troubleshoot-performance-issues-using-jfr.html). Distinguishes CPU from I/O, lock waits, and GC events; event coverage and overhead depend on recording settings and JVM version.
- **English, official Node.js guide:** [Profiling Node.js applications](https://nodejs.org/en/learn/getting-started/profiling). An example of diagnosing CPU use in Node; APIs and tooling are version-specific.
- **English, firsthand engineering report:** [Discord Voice at the Edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge). Combines probes, flame graphs, and infrastructure investigation in one reported incident.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Previous: Streaming](../01-streaming-large-bodies/README.en.md) · [Next: Algorithms](../03-algorithms-and-data-structures/README.en.md)

**Related lessons:** [Critical paths](../04-critical-paths/README.en.md) · [Database profiling](../../04-databases/12-database-profiling/README.en.md) · [Metrics, logs, and traces](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md)
