<div dir="ltr" align="left">

[فارسی](README.md) · English

# Chapter 04 — Database Performance

A slow order page may be waiting for a connection, making hundreds of ORM round-trips, reading too many rows, or blocked on locks or disk. This chapter helps separate those causes and choose a proportional change. The goal is to reduce work while returning the correct answer; more connections, indexes, or replicas are not success measures by themselves.

This chapter covers the twelve Database items in the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). Initial research was checked on **2026-11-10**; the lesson work and added-reference checks were completed on **2026-11-11**. At the initial review, PostgreSQL current documentation referred to version 18. Check the documentation for your installed version before running anything. SQL and exercise values are educational and have not been executed in this course.

**Every lesson teaches its concepts in the page itself; links to references are optional further reading or sources for engine details, not prerequisites for understanding or completing a lesson.**

## Prerequisites and diagnostic route

You should recognize SELECT, WHERE, JOIN, primary/foreign keys, transactions, and latency percentiles. PostgreSQL is only the example engine; the concepts do not require a particular programming language. Do exercises in a separate test database. Index builds, maintenance, and configuration changes need privileges and an operational plan.

| Lesson | Topic | Diagnostic question |
| --- | --- | --- |
| 1. [Connection pooling](01-connection-pooling/README.en.md) | Pool sizing and capacity | Is time spent waiting for a connection or running SQL? |
| 2. [Indexes](02-indexes/README.en.md) | Supporting query paths | How much data is read to return a few rows? |
| 3. [ORM fetching](03-orm-fetch-strategies/README.en.md) | Lazy, eager, and batch | How many SQL statements run for one request? |
| 4. [Database pagination](04-efficient-database-pagination/README.en.md) | OFFSET and keyset | What extra work do deep pages cause? |
| 5. [Projection](05-select-only-needed-columns/README.en.md) | Only needed columns | What do row width and object creation cost? |
| 6. [Read-heavy denormalization](06-denormalization-for-read-heavy-workloads/README.en.md) | Derived read models | Is repeated computation worth the cost of maintaining a read model? |
| 7. [Join optimization](07-join-optimization/README.en.md) | Meaning and cardinality | Are the relationship semantics and row estimates correct? |
| 8. [Database maintenance](08-database-maintenance/README.en.md) | Statistics and vacuum | Are planner statistics or cleanup of old versions delayed? |
| 9. [Slow-query logging](09-slow-query-logging/README.en.md) | Individual slow executions | Which execution was slow, and when? |
| 10. [Replication](10-replication/README.en.md) | Read freshness and failover | Which reads can tolerate stale data? |
| 11. [Sharding](11-sharding/README.en.md) | Distributed ownership | Does the bottleneck exceed one node after simpler fixes? |
| 12. [Database profiling](12-database-profiling/README.en.md) | Aggregate and plan evidence | Which query family has the greatest total cost? |

For a sequential study, start with lesson 1. To diagnose a real slowdown, read lessons 12 and 9 for a baseline, then follow the observed cause: request time → pool wait → SQL count → costly query family → plan → smallest change → compare outcomes and write cost. Consider replication and sharding only after this path.

## Chapter-long example

An educational store shows one customer’s order list. First record pool time and SQL count per request. Use a bounded pool with reliable release; consider an index for the customer filter and time order. Batch customer names, omit receipt bodies from the list projection, and measure deep navigation with keyset pagination. Define a rebuild time for a daily report read model. Then inspect statistics, VACUUM, and locks. Add a replica only if remaining read load and freshness budget justify it; before sharding, examine tenant access patterns and a hot tenant.

This scenario is hypothetical. Discord’s [2023 engineering report](https://discord.com/blog/how-discord-stores-trillions-of-messages) is real public evidence of access patterns and hot partitions, but does not establish that the same storage choice fits another store.

## Connections to other chapters

- [Caching](../01-caching/README.en.md): database offload needs freshness, invalidation, and recovery rules.
- [API pagination](../02-api-response/03-efficient-pagination/README.en.md): cursor shape and user experience belong to the API; seek mechanics and indexes belong here.
- [Scaling and load balancing](../05-load-balancing-and-scaling/README.en.md): more service instances can make the sum of their pools exceed the database budget.
- [Batching and round-trips](../06-code-optimization/08-batching-and-round-trips/README.en.md): N+1 is one form of round-trip cost.
- [Monitoring](../07-monitoring-and-logging/README.en.md) and [performance testing](../09-performance-testing/README.en.md): compare baselines with similar data, concurrency, and windows.

## End-of-chapter checklist

- [ ] Separate connection-queue time, SQL execution, and end-to-end response.
- [ ] Sum pool limits across all application instances and operational reserves.
- [ ] Evaluate indexes with a query plan and their write cost.
- [ ] Inspect ORM-generated SQL, query count, and result size.
- [ ] Use deterministic pagination and project required columns.
- [ ] Give each read model an owner, freshness budget, replay, and reconciliation.
- [ ] Preserve join meaning/cardinality and monitor VACUUM and ANALYZE.
- [ ] Protect sensitive information in logs; define profiling windows and resets.
- [ ] Treat replicas as distinct from backups; design lag, failover, and read-after-write.
- [ ] Before sharding, state routing, hotspot, transaction, and migration costs.

**Navigation:** [Course index, English](../README.en.md) · [Start at connection pooling](01-connection-pooling/README.en.md) · [Next chapter: Scaling and load balancing](../05-load-balancing-and-scaling/README.en.md)

</div>
