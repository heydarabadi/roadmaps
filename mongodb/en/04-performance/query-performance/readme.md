# Explain Plans and Query Tuning

> **Persian edition:** [Read this lesson in Persian](../../../04-performance/query-performance/readme.md).

> **Learning goal:** Read execution statistics, identify query work, and improve a measured bottleneck one step at a time.

## What `explain()` shows

Use `explain("executionStats")` to inspect a query's selected plan and observed work. The exact output structure can change across server versions, but these ideas remain useful:

- **`winningPlan`:** the plan the query planner selected.
- **`COLLSCAN`:** collection scan; documents are examined directly.
- **`IXSCAN`:** index keys are scanned.
- **`FETCH`:** matching documents are read after an index scan.
- **`SORT`:** results are sorted in memory or by an explicit sort stage rather than fully from index order.
- **`nReturned`:** documents returned.
- **`totalDocsExamined`:** documents examined.
- **`totalKeysExamined`:** index keys examined.

~~~javascript
db.orders.find(
  { customerId: "C-100", status: "paid" },
  { createdAt: 1, total: 1 }
).sort({ createdAt: -1 }).limit(20)
 .explain("executionStats")
~~~

If 20 records are returned after examining thousands, the filter may be unselective or the index may be mismatched. If documents examined are close to results returned, that is encouraging but does not prove the whole endpoint is fast: network, document size, contention, disk, pool wait, and concurrency also matter. A collection scan on a tiny collection is not automatically a problem.

## A production tuning loop

1. Confirm the slowdown against a baseline or SLO.
2. Identify slow query shapes from logs, profiler, or Atlas metrics.
3. Collect the full filter, sort, projection, limit, and representative data distribution.
4. Read explain output and create one hypothesis: index, query rewrite, projection, pagination, or model.
5. Change one thing and compare latency percentiles and work metrics under realistic load.
6. Check the write cost and resource usage of the new index or design.
7. Keep a rollback option and monitor after deployment.

`executionTimeMillis` from one small run is not a benchmark. Cache state, dataset size, concurrency, disk, and network change the result. `hint()` can help test a candidate plan, but pinning a plan permanently requires evidence and ongoing review.

## Additional signals

Pair query plans with p50/p95/p99 latency, connection-pool wait, CPU, memory/cache pressure, disk I/O, replication lag, and result size. If the plan looks efficient but tail latency remains high, the bottleneck may be resource contention or the application path rather than the filter.

## Exercises

1. Explain the difference between `totalDocsExamined` and `nReturned`.
2. For 20 returned documents and 200,000 examined documents, suggest three investigations.
3. Describe why an index scan can still be slow.

## Common mistakes

- Assuming `IXSCAN` always means an efficient query.
- Drawing a conclusion from one small or warm-cache run.
- Adding an index without measuring write amplification.
- Hiding a bad query shape behind a permanent `hint()`.
- Ignoring application latency when database execution time is low.

## Quiz and answer key

1. **What is `COLLSCAN`?** A scan through collection documents to find results.
2. **What does `IXSCAN` prove?** The plan scanned an index; it does not prove the entire operation was cheap.
3. **Why is one `executionTimeMillis` value insufficient?** It depends on cache, data size, load, and resource conditions.
4. **Why avoid conclusions from one tiny run?** It may have warm cache, too little data, or an unrealistic distribution; repeat with representative data and concurrency.
5. **Applied task: interpret many examined documents.** Review selectivity and index fit, rewrite the filter if possible, then compare representative executions and latency percentiles.
6. **What is `nReturned`?** The number of result documents returned by the plan.
7. **Does `IXSCAN` alone establish good performance?** No. Inspect keys/documents examined, sort work, and latency.
8. **Why monitor p99?** It reveals slow-tail requests that a mean can hide.
9. **When should `hint()` be permanent?** Only with a clear, tested operational reason and monitoring; it is usually a diagnostic tool.
10. **What else can make a fast plan's endpoint slow?** Pool waits, network, large results, disk/CPU contention, replication, or application processing.

## Further reading

- [Analyze Query Plan](https://www.mongodb.com/docs/manual/tutorial/analyze-query-plan/)
- [Query Plans](https://www.mongodb.com/docs/manual/core/query-plans/)
- [Query Optimization](https://www.mongodb.com/docs/manual/core/query-optimization/)
- [Troubleshoot Slow Queries in Production](https://www.mongodb.com/docs/manual/troubleshooting/slow-queries-in-production/)
- [Performance Tuning](https://www.mongodb.com/docs/manual/administration/performance-tuning/)
- [Atlas Query Profiler](https://www.mongodb.com/docs/atlas/tutorial/query-profiler/)
- [Performance best practices — MongoDB](https://www.mongodb.com/resources/products/capabilities/performance-best-practices)
- [Persian query performance guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-3)
- [Curated reference library: performance](../../reference-library.md#performance-indexes)

---
Sources reviewed: 2026-11-11. Explain output and planner behavior depend on server version.
