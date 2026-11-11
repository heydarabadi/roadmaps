<div dir="ltr" align="left">

[فارسی](README.md) · English

# Join Optimization While Preserving Meaning

**Learning goal:** Predict result cardinality, distinguish join syntax from the physical plan, and inspect estimates, loops, and spill in a query plan. Sources were checked on 2026-11-10; the PostgreSQL example was completed and link-checked on 2026-11-11. SQL was not executed.

## Mental model

A join combines rows according to a condition. First establish the relationship: one-to-one, one-to-many, or many-to-many. Then estimate input and output sizes. Nested loop, hash join, and merge join are physical choices; no algorithm name is automatically good or bad. A small outer input with indexed lookups may suit a nested loop. A large input with bad estimates can make those repeated lookups expensive.

| Plan observation | Next question |
| --- | --- |
| Actual rows far above estimate | Are statistics, skew, or column dependencies wrong? |
| Many loops for a lookup | Is the outer input larger than expected? |
| Temp reads/writes or many hash batches | Did volume exceed available memory? |
| Output many times larger than parents | Is the relationship many-to-many or the condition incomplete? |

The planner can reorder many inner joins; changing their written order does not guarantee a changed physical order. Outer joins have semantic constraints.

## Prerequisites and cardinality

Cardinality is the row count at a join stage. A one-to-many relation gives a parent multiple children; two independent collections can produce multiplicative output. Define the grain of the intended result: should each row represent a customer, an order, or an order/payment pair? Then define join keys and inner/outer semantics. The planner selects a physical algorithm after the meaning and statistics are known.

## Use and trade-offs

Joins suit combining data near its source and can replace multiple round-trips. For very large outputs or multiple collections, batching may transfer less data. An index on join keys is a candidate, but a hash or sequential scan may be correct when much of the table is needed. Query memory multiplies under concurrency; a very large work_mem value is not a general cure for spilling.

## Worked example

Assume customers(id, name) and orders(id, customer_id, total, status). The result must include every customer, even one with no paid orders:

~~~sql
SELECT c.id, c.name, COALESCE(p.amount, 0) AS paid_amount
FROM customers AS c
LEFT JOIN (
    SELECT customer_id, SUM(total) AS amount
    FROM orders
    WHERE status = 'paid'
    GROUP BY customer_id
) AS p ON p.customer_id = c.id;
~~~

Pre-aggregation reduces orders to one row per customer and prevents an aggregate from multiplying in a later join. It may be more expensive if the result needs only a few customers, because it aggregates all paid orders. Moving a right-side predicate into WHERE can remove NULL-extended rows and change LEFT JOIN semantics.

## Worked exercise

Create two customers; give one two paid orders and three related payment rows, and give the other no orders. Compare a raw join of both collections and SUM with pre-aggregating each relation. Then inspect the plan.

For independent customer-scoped collections, two orders multiplied by three payment rows make six joined rows. If each order total is repeated across those three rows, a SUM inflates it. Aggregate each collection to the intended grain before joining. If payments belong to a particular order, join on that order key; the correct keys come from the data model. Verify the result is semantically equal before comparing plans.

## Troubleshooting path

Compare actual rows with estimates and investigate large gaps through statistics and skew. For many inner lookup loops, multiply per-loop work by the outer-row count. Investigate temp I/O and hash batches as potential spill. Check full tenant and relationship keys if cardinality is unexpectedly high. Do not use DISTINCT to hide an incorrect join.

- [ ] Relationship cardinality and aggregation grain are known.
- [ ] Join type and predicate location preserve the intended result.
- [ ] Estimated/actual rows, loops, buffers, and temporary I/O are checked.
- [ ] Join-key types and indexes are compatible.
- [ ] Tenant isolation and complete relationship keys are in the condition.
- [ ] Before/after output and memory under concurrency are compared.

## Evidence and limits

PostgreSQL documentation on explicit joins shows how relation count and outer-join semantics affect planner choices. The customer/payment example is illustrative, not a company production report.

## Self-check

1. Is a nested loop always bad?
2. Why can joining two collections corrupt a SUM?
3. What can a right-side predicate in WHERE do after a LEFT JOIN?
4. Why does reordering written inner joins not guarantee a new plan?
5. What do you measure before sharply increasing query memory?

### Answers with reasoning

1. No. A small input and effective lookup can make it inexpensive.
2. Many-to-many combinations repeat rows, and the aggregate sums those duplicates.
3. It may remove NULL rows and change outer-join semantics.
4. The planner may reorder equivalent inner joins; written order is not physical order.
5. Actual volume, skew, statistics, spill, and concurrent query count; memory use can accumulate.

## Optional further reading

This lesson is self-contained. The links are optional sources for particular engines and plan behavior.

- Persian: [Debunking “filter early, join later,” PDF](https://www.dntips.ir/exports/news/www.dntips.ir-news-20517.pdf) discusses written query order versus optimizer decisions. The PDF could not be opened directly during the research check; PostgreSQL behavior here is based on its official manual.
- English, official: [PostgreSQL explicit JOIN clauses](https://www.postgresql.org/docs/current/explicit-joins.html) explains join-order constraints and outer joins.
- English, official: [PostgreSQL Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html) explains plan trees, rows, and loops.
- English, official: [MySQL EXPLAIN](https://dev.mysql.com/doc/refman/8.4/en/explain.html) describes plan inspection in MySQL; plan operators are engine-specific.
- English, official: [SQL Server joins](https://learn.microsoft.com/en-us/sql/relational-databases/performance/joins?view=sql-server-ver17) describes nested-loop, merge, and hash joins for SQL Server.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Denormalization](../06-denormalization-for-read-heavy-workloads/README.en.md) · [Next: Maintenance](../08-database-maintenance/README.en.md) · [ORM](../03-orm-fetch-strategies/README.en.md)

</div>
