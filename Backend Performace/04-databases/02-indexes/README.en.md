<div dir="ltr" align="left">

[فارسی](README.md) · English

# Indexes — Shortening the Search Path

**Learning goal:** Propose an index from a query’s filters and ordering, verify whether it is used, and account for write cost. Sources were checked on 2026-11-10; educational PostgreSQL SQL examples were completed and link-checked on 2026-11-11. The SQL has not been executed.

## Mental model

An index is a supporting structure for locating rows; it does not help every query. A sequential scan can be the right choice when the table is tiny or most of it is needed. Composite-index column order depends on the filter, sort, and database engine; do not assume every engine or version behaves alike.

| Access pattern | Candidate to consider | Cost |
| --- | --- | --- |
| Equality on customer and time ordering | Composite B-tree | more write work and storage |
| Fixed subset condition | Partial index, if supported | predicate must match/usefully apply |
| Spatial data | GiST/PostGIS for the operator | needs the right type and operator class |
| Return a limited set of columns | Covering index | wider index and maintenance cost |

Start with real SQL and representative parameters. Refresh statistics, inspect the plan and buffers, make one change, then compare reads and writes under similar load. PostgreSQL’s index-usage guide emphasizes representative data and statistics.

## Prerequisites, choice process, and reading results

Selectivity is the share of rows retained by a condition. A plan is the execution path selected by the database. An index is an auxiliary structure that may make finding a row range or required order cheaper. Write down the query, filter, order, and output size first; then assess an index candidate and its write cost on representative workload. Column order depends on workload and engine.

## Use and trade-offs

Indexes help for selective searches or compatible ordering. Low-cardinality columns can still help in an appropriate composite index, so a column’s name alone is not enough. Inserts, updates, and deletes may add index maintenance and WAL work. A function or cast on a column can change whether an ordinary index applies. Do not delete an apparently unused index before checking the full workload window and whether it enforces a constraint.

## Worked example

Assume orders has id, customer_id, created_at, and total. To list the latest orders for one customer:

~~~sql
CREATE INDEX orders_customer_time_idx
    ON orders(customer_id, created_at DESC, id DESC);

EXPLAIN (ANALYZE, BUFFERS)
SELECT id, created_at, total
FROM orders
WHERE customer_id = 42
ORDER BY created_at DESC, id DESC
LIMIT 20;
~~~

Equality on the customer plus the matching order makes an index scan with early stopping a candidate; it does not guarantee the plan or a particular duration. The id column makes ties on the timestamp deterministic. EXPLAIN ANALYZE runs the query and creates load even for a SELECT.

For this pattern, the customer key narrows the range; the ordered timestamp and id can provide the output order and stop after 20 rows. If that customer owns a large share of the table, or the table is tiny, a different scan can still be cheaper. So the sound claim is “candidate index,” not “the planner must use it.”

## Worked exercise

In a lab, create 100,000 orders for 100 customers with a skewed distribution. Compare the query for a low-volume and a high-volume customer before and after creating the index and running ANALYZE orders. Record rows, sort, buffer hits/reads, and time; then compare an identical insert batch.

The low-volume customer may benefit; the high-volume customer may get a different plan. There is no deterministic timing to infer from this teaching dataset. A complete answer records the plan, rows, sort, buffers, and time for both queries and measures the write batch too. If estimated and actual rows differ, investigate statistics, skew, and column correlation. If reads improve but write latency or WAL grows, judge that cost against the workload goal.

## Troubleshooting path

Capture a slow query and representative parameter; inspect its plan and statistics; investigate estimation errors, buffers, and sort; make one index change; and repeat with similar read/write load. Before removing a low-use index, check constraints, infrequent but important queries, and a sufficiently long workload window.

## Evidence and limits

The official PostgreSQL guide is the operational basis for examining index use. The Persian PostGIS article reports a public spatial-plan example, but its measurements were not independently reproduced and should not be generalized from GiST to B-tree. Do not interpret “concurrent build” as “no locks or restrictions”; check the installed engine’s documented procedure.

## Self-check

1. Is a sequential scan always a problem?
2. Why add id to the timestamp ordering?
3. What does an index on every column cost?
4. If estimated rows differ greatly from actual rows, what do you inspect?
5. Is a faster SELECT enough to approve an index?

### Answers with reasoning

1. No. It can be cheapest for a small table or a query needing a large share of rows.
2. It breaks timestamp ties and creates deterministic ordering, which pagination needs.
3. Storage, memory, WAL, and extra work for writes; unnecessary indexes create ongoing cost.
4. Statistics freshness, column correlation, skew, and the actual parameter; bad estimates can change plan choice.
5. No. Also compare write latency, throughput, storage, and index-build locks.

## Optional further reading

The lesson is self-contained. These links are optional enrichment and engine-specific technical provenance.

- Persian: [Database indexing](https://pro-nee.net/terms/indexing/) introduces index concepts and costs; explanations of clustered and nonclustered indexes vary by engine.
- Persian, supplemental: [PostGIS and EXPLAIN example](https://asnegar.ir/blog/postgis-optimization/) is a spatial example with the evidence limits noted above.
- English, official: [Examining index usage](https://www.postgresql.org/docs/current/indexes-examine.html) covers testing with real data and statistics.
- English, official: [PostgreSQL multicolumn indexes](https://www.postgresql.org/docs/current/indexes-multicolumn.html) describes leading-column behavior.
- English, official: [PostgreSQL index types](https://www.postgresql.org/docs/current/indexes-types.html) compares access methods and operator classes.
- English, official: [PostgreSQL CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html) documents build costs and concurrent-build restrictions.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Connection pooling](../01-connection-pooling/README.en.md) · [Next: ORM fetching](../03-orm-fetch-strategies/README.en.md) · [Profiling](../12-database-profiling/README.en.md)

</div>
