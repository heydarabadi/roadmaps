<div dir="ltr" align="left">

[فارسی](README.md) · English

# Database Profiling — From Total Cost to an Expensive Plan Node

**Learning goal:** Find costly queries over a comparable window, interpret EXPLAIN, and verify an optimization with repeatable observations. Sources were checked on 2026-11-10; examples for PostgreSQL 18 were completed and link-checked on 2026-11-11. They were not executed.

## Mental model and work order

Profiling measures and attributes cost to a path. First divide request latency into pool wait, SQL execution, network, and application work. Rank query families by count, total time, and I/O. Then inspect a representative execution, its plan, lock waits, and representative data/parameters. Without a baseline, a change cannot be attributed.

| PostgreSQL tool | Use | Limitation |
| --- | --- | --- |
| pg_stat_activity and wait events | current execution and waiting | snapshot, not complete history |
| pg_stat_statements | query-family aggregates | resets and window matter; no true p99 |
| EXPLAIN | estimated plan | does not measure a real execution |
| EXPLAIN ANALYZE with BUFFERS | actual rows/time/buffers | executes the query with added overhead |
| System tools and traces | CPU, disk, network, correlation | attribution needs context |

Buffer hits are not free: CPU, locks, and mapping still cost time. PostgreSQL monitoring documentation treats internal and system tools as complementary.

## Prerequisites and query-cost calculation

Profiling attributes cost to a path or query family. Calls are the number of executions; mean is average duration; total is summed duration over the same interval. EXPLAIN cost is a planner unit, not milliseconds. EXPLAIN ANALYZE runs the query. Compare counters at two times using the full query identity and a stable reset window.

## Use and trade-offs

Before adding an index or changing a schema, rank frequent queries by total cost. A rare slow execution can still matter to an SLO and user experience; one ranking is not sufficient. pg_stat_statements must be enabled in shared_preload_libraries, requiring a restart for initial setup, then extension creation and privileges. Do not overwrite an existing preload configuration with only one new entry. The module guide explains normalization, limitations, and planning overhead.

## Worked example

On a system where the extension is already enabled, this query ranks accumulated counts and times since the last reset. For a test window, take two counter snapshots and calculate differences. Match rows using the full tuple of database ID, user ID, top-level status, and query ID, since one query ID may appear in separate rows by database, user, or top-level status. Do not reset shared production counters for a personal experiment. If an entry is reset or removed between snapshots, the comparison is invalid.

~~~sql
SELECT dbid, userid, toplevel, queryid, calls, total_exec_time, mean_exec_time,
       rows, shared_blks_hit, shared_blks_read
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT id, total
FROM orders
WHERE customer_id = 42
ORDER BY created_at DESC, id DESC
LIMIT 20;
~~~

Assume the orders table has these columns and parameter 42 represents the real distribution. In the plan, inspect estimated/actual rows, loops, sort, and buffers. Planner cost is not milliseconds. At a node with loops, actual time/rows are generally reported per execution. A parent’s time includes its children, so do not sum node times. The official EXPLAIN guide explains how to read these numbers.

## Worked exercise

Suppose family A runs 10,000 times at 2ms and family B 10 times at 200ms. A totals 20s; B totals 2s. A is ten times the aggregate execution time and is the first capacity candidate, while B may still matter to an SLO or tail latency. After changing only A, compare in a similar window with comparable call volume, data, and cache state. Label cold and warm runs; never clear a production cache just to create a cold experiment.

## Troubleshooting and checklist

Unusual parameters, statistics resets, changed traffic, or a warm-cache-only benchmark can mislead comparisons. Aggregates are not percentiles; do not label a mean as p95. EXPLAIN ANALYZE on a write performs the write, and ROLLBACK does not undo every external trigger or sequence effect. Query text and plans also need data-sensitive retention rules.

- [ ] Comparison window, reset, call count, and traffic are recorded.
- [ ] Pool, SQL, network, and mapping time are separated.
- [ ] Ranking considers aggregate cost and SLO impact.
- [ ] Estimated/actual rows, loops, buffers, and spill are checked.
- [ ] Measure one change with equivalent output and representative data.
- [ ] Control instrumentation overhead, privileges, and SQL/plan access.
- [ ] Confirm endpoint latency and write cost after the change.

## Evidence and limits

The PostgreSQL pg_stat_statements example demonstrates aggregate time and buffers on a test workload; it is not a company production report. A Persian PostGIS example shows EXPLAIN use but its measurements were not independently reproduced and are not a source for all PostgreSQL details.

## Self-check

1. Is EXPLAIN cost measured in milliseconds?
2. Is mean_exec_time the same as p99?
3. Why can fast but frequent queries matter?
4. How does EXPLAIN differ from EXPLAIN ANALYZE?
5. Why should you not sum every plan-node duration?
6. If total_exec_time falls by half but calls also fall by half, what can you conclude?

### Answers with reasoning

1. No. It is an estimated planner cost unit.
2. No. It is a mean; percentiles need a distribution or suitable histogram/trace.
3. A large count can dominate aggregate cost, CPU, and round-trips.
4. The first estimates a plan; the second executes and measures it with possible overhead and effects.
5. Parent time includes children; summing double-counts work and loops need interpretation.
6. Improvement is not established. Load volume and mix changed; compare per-call cost and equivalent windows.

## Optional further reading

This lesson explains the workflow and plan limits. The links are optional technical sources.

- Persian: [EXPLAIN and PostGIS optimization](https://asnegar.ir/blog/postgis-optimization/) is a related public example; its measurements were not independently reproduced and are not universal PostgreSQL guidance.
- English, official: [PostgreSQL Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html) explains plans and measurement caveats.
- English, official: [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) documents aggregation and query identity.
- English, official: [PostgreSQL monitoring](https://www.postgresql.org/docs/current/monitoring.html) covers internal and system observations.
- English, official: [auto_explain](https://www.postgresql.org/docs/current/auto-explain.html) documents logging plans for slow statements and instrumentation overhead.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Sharding](../11-sharding/README.en.md) · [Restart at pooling](../01-connection-pooling/README.en.md) · [Slow logs](../09-slow-query-logging/README.en.md) · [Application profiling](../../06-code-optimization/02-application-profiling/README.en.md) · [Performance testing](../../09-performance-testing/README.en.md)

</div>
