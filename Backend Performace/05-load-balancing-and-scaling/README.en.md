<div dir="ltr" align="left">

[فارسی](README.md) · English

# Chapter 05 — Load Balancing and Scaling

Adding resources helps user experience when they address the actual constraint. This chapter first compares the capacity of one instance with multiple instances, then explains how requests are assigned among ready destinations. **Scaling changes capacity; load balancing chooses where existing capacity is used.** Neither alone fixes a database lock, local session state, or duplicate work caused by retries.

The initial source review was on **2026-11-10**; lesson work and added-link checks were completed on **2026-11-11**. This chapter follows the Load Balancing & Scaling section of the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices); its example numbers are educational.

**Both lessons teach their prerequisites, worked examples, and exercises in-page; external references are optional further reading and are not needed to understand either lesson.**

## Prerequisites and study order

You need a basic understanding of HTTP requests, CPU/RAM, databases, sessions, throughput, error rate, and response-time percentiles. If those signals are unfamiliar, see [Measurements and signals](../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md).

| Order | Lesson | Practical outcome |
| --- | --- | --- |
| 1 | [Horizontal and vertical scaling](01-horizontal-and-vertical-scaling/README.en.md) | Choose a larger instance or more instances using capacity, failure headroom, and state constraints |
| 2 | [Load balancing](02-load-balancing/README.en.md) | Choose an algorithm, health checks, session handling, and draining to use capacity correctly |

Decision path: define response-time and error targets; find the bottleneck; estimate usable capacity; choose the smallest suitable change; clarify where state lives; add ready destinations to load distribution; and evaluate failure and reduced capacity. If the database is the limit, counting API instances is not a success metric.

## Chapter-long example

Suppose an educational reservation API has measured stable capacity of 100 requests per second per instance and is preparing for 180 requests per second. Two instances may handle normal demand, but losing one leaves capacity of 100. To preserve the same demand after losing one equally capable instance, at least three are needed, subject to dependency capacity and uneven load.

If reservation session state exists only in instance one’s memory, sending the next request to instance two can break the user flow. If every instance also opens a pool of up to 60 database connections, three instances can create 180 potential connections. Capacity decisions therefore include session storage, connection budget, and distribution. The first lesson calculates these constraints; the second explains destination selection, arrival, and departure.

## Connections to other chapters

- [Connection pooling](../04-databases/01-connection-pooling/README.en.md): the sum of all instance pools must fit the database budget.
- [Replication](../04-databases/10-replication/README.en.md): a read replica adds possible read capacity, not generic write capacity, and has replication lag.
- [Sharding](../04-databases/11-sharding/README.en.md): data distribution needs a key, movement plan, and hot-partition controls.
- [Service decomposition](../06-code-optimization/06-service-decomposition/README.en.md): separate components with different growth patterns only when it enables useful independent scaling.
- [Timeouts and retries](../06-code-optimization/07-timeouts-and-retries/README.en.md) and [background jobs](../03-asynchronism/01-background-jobs/README.en.md): include retries, queue length, and dependency limits in capacity.
- [Performance testing](../09-performance-testing/01-load-testing-and-regression-benchmarks/README.en.md): measure sustainable capacity under a stated load from the client’s perspective.

## Chapter review checklist

- [ ] Explain Scale Up/Down and Scale Out/In with distinct examples.
- [ ] Know why more APIs do not remove a shared database or network limit.
- [ ] Identify where session, state, files, and job ownership live across instances.
- [ ] Calculate normal and single-instance-failure capacity and startup delay.
- [ ] Match the load algorithm to connection type, request cost, and destination capacity.
- [ ] Define readiness, process health, draining, and all-destinations-unhealthy behavior.
- [ ] Measure successful work within deadline, cost, and dependency use alongside instance count.

**Navigation:** [Course index, English](../README.en.md) · [Previous chapter: Databases](../04-databases/README.en.md) · [Next chapter: Code optimization](../06-code-optimization/README.en.md) · [First lesson](01-horizontal-and-vertical-scaling/README.en.md)

</div>
