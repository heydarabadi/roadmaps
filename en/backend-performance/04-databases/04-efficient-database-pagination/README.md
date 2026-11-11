<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/04-efficient-database-pagination/README.md) · English

# Efficient Database Pagination

**Learning goal:** Separate OFFSET cost from page size, write keyset pagination with deterministic ordering, and reason about concurrent changes. Sources were checked on 2026-11-10; the PostgreSQL teaching example was completed and link-checked on 2026-11-11. It was not executed.

## Mental model

OFFSET says how many result rows to skip; the database still traverses the path to that point. LIMIT only caps the output size. Keyset pagination starts from the last sort key of the previous page; with a compatible index it can avoid walking discarded rows. Ordering must be deterministic: a timestamp alone is insufficient if timestamps can tie. PostgreSQL documents the cost of a large offset and the need for predictable ordering.

| Method | Benefit | Limitation |
| --- | --- | --- |
| OFFSET | jump to a numbered page | deeper pages do more work; inserts/deletes shift rows |
| Keyset | continue from a key | arbitrary page jumps are difficult; depends on sort |
| Fixed snapshot | stable result set | snapshot/version retention has operational cost |

Keyset does not guarantee a snapshot. A changed sort value can cause repeated or missed rows. Define a snapshot or high-water mark for an exact export.

## Prerequisites and cursor boundaries

Pagination splits an ordered result into bounded portions. An offset discards prior result rows; a cursor carries the sort key of the last delivered row; a tie-breaker adds a unique key when the primary sort value ties. Filters, sort columns, and directions must remain clear and consistent.

## Use and trade-offs

Keyset is suitable for large sequential feeds. Shallow pages with arbitrary page-number jumps may justify OFFSET. Price exact COUNT separately; counting all rows may cost more than fetching a page. NULLs, mixed sort directions, and multiple tenants make seek predicates more complex. The example assumes non-NULL columns and the same direction for both sort keys.

## Worked example

Assume an orders table with primary key id and non-NULL customer_id and created_at. The first page has no cursor condition. The next page uses the last (created_at,id) pair from the previous page:

~~~sql
CREATE INDEX orders_page_idx
ON orders(customer_id, created_at DESC, id DESC);

SELECT id, created_at
FROM orders
WHERE customer_id = 42
  AND (created_at, id) < (TIMESTAMP '2026-10-01 12:00:00', 9001)
ORDER BY created_at DESC, id DESC
LIMIT 21;
~~~

The display page size is 20; row 21 only tells the caller whether another page exists. Build the next cursor from row 20, not row 21. Repeat the customer filter on each page and do not treat the cursor as authorization. Bind real values. This example teaches database seeking; API cursor encoding and error handling are covered in the [API pagination lesson](../../02-api-response/03-efficient-pagination/README.en.md).

The tuple condition compares the same-direction descending sort keys lexicographically: after a cursor pair, the next pair is smaller. The matching composite index is a candidate, not a guaranteed plan.

## Worked exercise

In a lab, create 100,000 rows with tied timestamps. Compare LIMIT 20 OFFSET 80000 with the equivalent seek query using EXPLAIN (ANALYZE, BUFFERS). Then insert a row before the boundary between page requests.

The offset path ordinarily has to pass 80,020 result rows to reach the page; that is not a promise of physical I/O because plans and cache matter. Keyset starts at the boundary instead of counting the previous 80,000. A row inserted before that boundary will not appear on the continuation page, so keyset is not a full snapshot. An offset page can repeat or miss a row after a preceding insert. Compare actual rows and buffers; do not expect a fixed speedup.

## Troubleshooting path

If latency rises with page depth, inspect the plan, rows traversed versus returned, sort, and buffers. For duplicates or gaps, check the unique tie-breaker, comparator direction, NULL handling, and unchanged filters; then look for mutable sort values. Define a snapshot or high-water mark for a stable export. Mixed directions and NULLs need an explicit seek condition and boundary cases.

## Evidence and limits

GitLab’s engineering documentation shows keyset pagination in a real product. It documents implementation practice, not an independent benchmark for this example; index and sort limits must be measured on the local workload.

## Self-check

1. Why does a small LIMIT not necessarily make a large OFFSET cheap?
2. In the descending example, is the next-page condition < or >?
3. What is needed when multiple rows have the same timestamp?
4. Does keyset pagination read all data from one snapshot?
5. Why is the cursor built from row 20?

### Answers with reasoning

1. The database may still traverse or compute rows before the offset; a small output is not necessarily little work.
2. <, assuming the same descending direction for both columns.
3. A unique tie-breaker such as id, so the page boundary is unambiguous.
4. No. A snapshot is a separate consistency requirement.
5. It is the last delivered row. Using the extra row would skip it.

## Optional further reading

This lesson is self-contained. These links are optional technical references and product-specific examples.

- Persian: [Oracle pagination, continuation key, and stable snapshot](https://www.brserp.com/knowledge/erp-oracle-pagination-offset-seek-stable-order-snapshot-guide) discusses unique ordering and changing data; do not assume Oracle syntax or behavior matches PostgreSQL.
- English, official: [PostgreSQL LIMIT and OFFSET](https://www.postgresql.org/docs/current/queries-limit.html) explains ordering and offset behavior.
- English, official: [GitLab keyset pagination](https://docs.gitlab.com/development/database/keyset_pagination/) describes implementation and limitations.
- English, official: [GitLab pagination performance guidelines](https://docs.gitlab.com/development/database/pagination_performance_guidelines/) discusses sort/index requirements for both approaches.
- English, official: [EF Core pagination](https://learn.microsoft.com/en-us/ef/core/querying/pagination) compares offset and keyset navigation.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: ORM fetching](../03-orm-fetch-strategies/README.en.md) · [Next: Projection](../05-select-only-needed-columns/README.en.md) · [Indexes](../02-indexes/README.en.md)

</div>
