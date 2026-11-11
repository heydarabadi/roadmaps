# Chapter 9 — Performance Testing

**Language:** English · [فارسی](README.md)

Performance testing examines how a system completes correct work under a **defined load, dataset, environment, and time window**. The question is not only “how many requests did it answer?” Correctness, user-visible latency, errors, queues, cost, and recovery also matter. One capacity test does not guarantee the product’s capacity forever.

**Sources reviewed: 2026-11-10; lesson completion: 2026-11-11.** This chapter covers the Performance Testing section of the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). Terms, scenario design, and result interpretation are explained in the chapter; links are optional reading or tool references. All numbers in examples and exercises are illustrative; no load test or benchmark was run while preparing this text. k6 and other tools are examples, not a required language or stack.

## Prerequisites and study path

Basic familiarity with HTTP requests and what it means for work to finish is enough. Percentiles, error rate, goodput, warm-up, and arrival models are defined in the lesson. [Monitoring signals](../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md), [profiling](../06-code-optimization/02-application-profiling/README.en.md), and [critical paths](../06-code-optimization/04-critical-paths/README.en.md) are optional follow-up study, not prerequisites for understanding this chapter.

| Lesson | What you will learn |
| --- | --- |
| [9.1 — Load testing, baselines, and regressions](01-load-testing-and-regression-benchmarks/README.en.md) | Differences among Load, Stress, Spike, and Soak; workload design; baselines, noise, and repeatability; valid thresholds; and version comparisons |

## From user needs to acceptance criteria

1. **Define the unit of work and timing boundary.** A fast acknowledgement that accepts a job is not the same as completing the job successfully. Specify the correct result, start/end events, and how errors or unfinished work are counted.
2. **Build a representative load and environment.** Record arrival rate and pattern, operation mix, data size and distribution, permissions, cache state, dependencies, and execution resources. “100 users” without a behavior model does not specify a request rate.
3. **Record a repeatable baseline.** Run the same plan several times on a reference version under recorded conditions; separate noise from a persistent change. A baseline describes current behavior; it does not by itself define what is acceptable for the product.
4. **Then finalize thresholds before comparing a new version.** Consider user-experience needs, baseline behavior, and measurement variation together. Do not loosen the product target to make a test green. If the reference version also misses the target, report that gap.
5. **Check run validity before Pass/Fail.** If the load generator did not reach the target rate or the scenario data is wrong, the result is invalid or inconclusive for that target. Zero errors with zero work is not success.
6. **Separate comparison from diagnosis.** A benchmark reveals a regression; metrics, traces, profiles, and query plans help investigate its cause.

The [official k6 guide to automated performance testing](https://grafana.com/docs/k6/latest/testing-guides/automated-performance-testing/) emphasizes a defined scenario and workload, comparable runs, and keeping baselines. A tool cannot decide for the team whether the workload represents reality or what the product needs.

## Connecting scenario

A new store version responds faster in a manual request, but lookup counts and cache usage have changed. The team first defines the mix of list, detail, and reservation operations and the distribution of hot products, then measures a baseline in a fixed environment. A Load test for normal demand, a Spike test for a campaign launch, and a Soak test for memory growth answer different questions.

If the new version rejects requests early, average latency may improve while less correct work is completed. If the load generator sends fewer requests as responses slow down, its graph may also hide the actual campaign pressure. This chapter shows how to distinguish these failures from a real improvement.

## Chapter review checklist

- [ ] User goal, unit of work, population, correctness, and timing boundary are clear.
- [ ] Each test type addresses a question; Smoke, Load, Stress, Spike, and Soak are not conflated.
- [ ] Representative load and baseline are established before final thresholds.
- [ ] Version, environment, data, cache, network, and arrival pattern can be reproduced.
- [ ] Scheduled, started, successfully completed, failed, and unfinished rates are tracked separately.
- [ ] Sample count, run repetitions, and noise are considered in the conclusion.
- [ ] Stop conditions, recovery, queue growth, and load-generator resources are checked.
- [ ] Conclusions are limited to the tested scenario and environment, with reference data retained.

**Related:** [Code Optimization](../06-code-optimization/README.en.md) · [Monitoring & Logging](../07-monitoring-and-logging/README.en.md) · [Scaling](../05-load-balancing-and-scaling/README.en.md) · [Connection Pooling](../04-databases/01-connection-pooling/README.en.md)

**Navigation:** [Package index](../README.en.md) · [Previous chapter: Security](../08-security/README.en.md) · [Chapter lesson](01-load-testing-and-regression-benchmarks/README.en.md)
