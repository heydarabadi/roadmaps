<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/03-orm-fetch-strategies/README.md) · English

# ORM Fetch Strategies — Lazy, Eager, and Batch

**Learning goal:** Identify N+1 from SQL, choose between joins and batching, and compare query count with result size. Sources were checked on 2026-11-10; the language-neutral example and lesson were completed on 2026-11-11. Examples were not executed.

## Mental model

Lazy loading reads a relationship when code accesses it. Eager loading fetches it earlier, either through a join or a separate query. Batch/select-in gathers identifiers and loads related rows together. “Eager” does not necessarily mean exactly one SQL statement.

| Strategy | Shape of work | Risk |
| --- | --- | --- |
| Lazy | base query, then per-item reads | N+1 and hidden I/O in serialization |
| Joined eager | one join with repeated parent data | row multiplication across collections |
| Batch/select-in | parents, then children for their IDs | parameter limit, memory, multiple snapshots |

With 20 orders and a customer query for each order, the simple pattern is 1+20. An ORM identity map or cache may reduce this, so count the actual SQL. SQLAlchemy 2.0 documents these choices and ways to prevent unwanted lazy loading; check the API of the ORM in use.

## Prerequisites and choosing a strategy

A single-valued relationship, such as an order’s customer, has at most one related row. A collection contains multiple children. A round-trip is an application-to-database exchange; an identity map reuses the same in-session object identity. Lazy loading runs its query at access time, and a serializer can trigger that query unexpectedly.

Start with the endpoint: how many parents are needed, and which relationships are used? For a small single-valued relation, compare a join with a batch. For collections, compare duplicated join rows and bytes with the extra round-trips of batching. Parameter limits may split a batch into chunks. If both queries must see one snapshot, choose a suitable transaction isolation level too.

## Use and trade-offs

A join can suit one small single-valued relationship. Two collections with 10 and 5 children can produce 50 combined rows for one parent; batching may move fewer bytes and use less memory, though it adds a round-trip. Lazy loading can be acceptable for relationships that are rarely used. Do not eagerly fetch unbounded lists. Under ordinary isolation, separate reads may observe concurrent changes; choose transaction isolation if a stable snapshot is required.

## Worked example

Assume an orders table with (id, customer_id) and a customers table with (id, name). A list needs only order IDs and customer names. Batch the customer lookup:

~~~sql
SELECT id, customer_id FROM orders ORDER BY id DESC LIMIT 20;
-- The application collects unique customer_id values, e.g. 7, 9, 12.
SELECT id, name FROM customers WHERE id IN (7, 9, 12);
-- Map customer_id to name, then build the response.
~~~

Bind values in a real query; do not concatenate them into SQL text. The count is usually two queries, but chunking to meet a parameter limit adds more. A join is also a candidate for this specific need; “two” is not a universal target.

With 20 orders and three unique customer IDs, simple lazy loading may issue one parent query and up to 20 customer queries: 21 round-trips. Batching usually uses two queries and three IDs. Joined loading for a single-valued relation can return 20 rows with the names. Two collections of 10 and 5 children instead can create 10×5=50 combinations. Actual counts depend on ORM behavior and data.

## Worked exercise

Create 20 orders with shared customers. Compare lazy, joined, and batched versions for the same output: query count, returned rows, bytes, and time. Then add two collections to each order and compare again.

Lazy loading can grow round-trips with parent count. A join across multiple collections can multiply rows; batching keeps each relationship result separate. Record actual SQL, rows, and bytes for the same output; do not declare victory from a lower query count if it returns many more rows.

## Troubleshooting and checklist

Serializers, templates, and logging can accidentally access lazy relationships. Joining a collection can change pagination over parents unless the ORM rewrites it correctly. Lazy access after the session closes may fail. Query count that grows with the number of parents suggests N+1.

- [ ] Record SQL and statement count for a representative request.
- [ ] Limit collections and measure result size.
- [ ] Compare lazy, join, and batch with equivalent output and semantics.
- [ ] Respect IN limits, chunking, and parameter binding.
- [ ] Define snapshot requirements and what happens after session close.
- [ ] Make unexpected relationship access observable or disallow it.

For diagnosis, count SQL during the base query and serialization separately. Query growth proportional to parent count suggests N+1; few queries but many rows/bytes and high memory suggest a joined collection expansion. Compare all strategies with the same inputs.

## Evidence and limits

SQLAlchemy’s official guide is the technical source for its loading strategies. This page does not report a company production result or a universal improvement percentage; the store example is illustrative. Choose from emitted SQL and result size, not the strategy name.

## Self-check

1. Does eager loading always use one SQL statement?
2. What pattern does one extra query for each of 30 parents create?
3. Why can joining two collections be worse?
4. Why might batching use more than two queries?
5. If query count falls but latency rises, what do you measure?

### Answers with reasoning

1. No. Preloading can use a join or separate queries.
2. Usually 1+30; confirm the actual count because cache or identity-map behavior varies.
3. Child counts multiply, repeating parent rows and increasing transfer and object construction.
4. Chunking, parameter limits, or multiple relationships can add queries.
5. Rows, bytes, memory, plan, and sort; round-trip count is only one factor.

## Optional further reading

This lesson includes the concepts and worked exercise. The links are optional and include ORM-specific behavior.

- Persian: [Django ORM optimization and N+1 prevention](https://mixins.ir/article/django-orm-query-optimization-performance/) covers select_related and prefetch_related; its full text could not be retrieved during the initial check, so it is not the basis for technical claims here.
- English, official: [SQLAlchemy Relationship Loading](https://docs.sqlalchemy.org/en/20/orm/queryguide/relationships.html) documents joined, select-in, and lazy loading for SQLAlchemy 2.0.
- English, official: [EF Core efficient querying](https://learn.microsoft.com/en-us/ef/core/performance/efficient-querying) demonstrates N+1, eager loading, projections, and trade-offs.
- English, official: [EF Core single versus split queries](https://learn.microsoft.com/en-us/ef/core/querying/single-split-queries) explains duplicated rows and cartesian expansion.
- English, official: [Django database optimization](https://docs.djangoproject.com/en/stable/topics/db/optimization/) distinguishes select_related and prefetch_related by relationship shape.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Indexes](../02-indexes/README.en.md) · [Next: Database pagination](../04-efficient-database-pagination/README.en.md) · [Join optimization](../07-join-optimization/README.en.md)

</div>
