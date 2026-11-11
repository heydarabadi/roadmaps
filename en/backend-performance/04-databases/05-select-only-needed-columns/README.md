<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/05-select-only-needed-columns/README.md) · English

# Select Only the Needed Columns — Projection

**Learning goal:** Separate row reduction from row-width reduction, write queries that match the response, and understand conditions for index-only scans. Sources were checked on 2026-11-10; PostgreSQL examples were completed and link-checked on 2026-11-11. They were not executed.

## Mental model

WHERE limits rows; SELECT controls the columns returned. SELECT * can fetch large text, JSON, or binary values the consumer does not need. Even if the database reads the same disk pages, it may transfer fewer bytes to the application and do less decoding, object creation, and serialization. A narrower result does not necessarily reduce the number of heap pages read.

| Layer | Possible effect of projection | What to observe |
| --- | --- | --- |
| Database | narrower intermediate rows, possible index coverage | width, plan, buffers |
| DB-to-app network | fewer bytes | driver/network bytes received |
| Application | fewer allocations and less mapping | memory, CPU, mapping time |
| Contract | new or sensitive columns do not leak by default | response schema review |

For PostgreSQL, a covering index is not the only condition for an index-only scan; the visibility map determines whether the heap must be visited.

## Prerequisites and worked calculation

Projection limits result columns; WHERE limits result rows. They are independent. Measure row width and mapping/transfer cost separately from heap pages. Fewer columns do not guarantee fewer disk reads.

Assume each document body is 64 KiB and a list contains 20 documents. SELECT * transfers at least 20×64=1,280 KiB, or 1.25 MiB, of body data, plus the other fields. Selecting id, title, and version for the list excludes those bodies. Actual savings vary with encoding and compression, so this is not a benchmark. If the renderer then loads each body separately, 20 extra queries can erase part of the benefit.

## Use and trade-offs

Projection suits list endpoints and read DTOs. Do not remove fields needed for update concurrency, such as a version value, or keys needed for mapping. A deferred column that is later lazy-loaded can create N+1. An index that includes every output field also costs space and write work; do not include a large column merely to cover a query.

## Worked example

Assume a documents table with (id, tenant_id, title, body, version). A list does not need the body:

~~~sql
-- List endpoint:
SELECT id, title, version
FROM documents
WHERE tenant_id = 7
ORDER BY id DESC
LIMIT 20;

-- Detail endpoint, after authorization:
SELECT id, title, body, version
FROM documents
WHERE tenant_id = 7 AND id = 81;
~~~

Separate list and detail reads so the body is loaded only when needed. Keep tenant_id in both predicates. The version may be needed for an optimistic-concurrency update. A complete query predicate alone does not prove authorization.

## Worked exercise

Create 20 test documents with large bodies. Run SELECT * and the list query above for the same displayed output; compare bytes and allocations. Then access body in a loop after projection and record the query count.

Expect fewer transferred bytes with projection; the plan and buffer counts might remain the same. If later accesses trigger lazy loading, query count can rise. The correct approach keeps a narrow list query and loads details separately under the proper authorization check.

## Troubleshooting and checklist

SQL can be fast while mapping CPU or network bytes remain high, which may indicate unused columns. Removing keys can break relationships; removing version can weaken optimistic concurrency. An index-only scan with many heap fetches may be related to table maintenance as well as projection.

- [ ] Derive the column list from the consumer’s actual needs.
- [ ] Retain keys, tenant, and version values required for mapping or updates.
- [ ] Measure bytes, allocations, and query count alongside database time.
- [ ] Ensure later deferred-field access does not create hidden SQL.
- [ ] Assess covering-index space, write cost, and visibility-map behavior.
- [ ] Ensure new table columns do not silently appear in public responses.

If database time is fine but response bytes, mapping CPU, or DB-to-app traffic is high, list fields actually consumed. After projecting, count lazy/deferred queries again. Preserve tenant and concurrency fields; inspect heap fetches and visibility before expecting an index-only scan.

## Evidence and limits

PostgreSQL’s official index-only-scan guide supports the points about selected columns, visibility, and heap access. No independently controlled company study isolating column removal is cited here; the document-body size and example are assumptions.

## Self-check

1. What is the difference between reducing rows and reducing columns?
2. Does removing body always reduce disk I/O by the same proportion?
3. Why might version be needed in a list response?
4. Is the presence of every column in the index sufficient for an index-only scan?
5. When can removing columns in an ORM cause N+1?

### Answers with reasoning

1. WHERE filters rows, while SELECT/projected columns control result width; they are independent.
2. No. The database may read the same pages even if transfer and object creation decrease.
3. An edit may need optimistic concurrency; removing it can change update semantics.
4. No. In PostgreSQL, row visibility and the visibility map affect heap access.
5. When code later loads each deferred column separately; count SQL after serialization.

## Optional further reading

This page teaches the mechanism and exercise in full. The links are optional deeper reading and engine-specific provenance.

- Persian: [Database security and optimization, basic query optimization](https://shahin.page/persian/article-fa/database-security-and-optimization-access-control-and-indexing-fa) introduces selecting necessary columns instead of SELECT *. Refer to the official PostgreSQL guide for visibility-map details.
- English, official: [PostgreSQL index-only scans and covering indexes](https://www.postgresql.org/docs/current/indexes-index-only-scans.html) describes index coverage and included columns.
- English, official: [EF Core efficient querying](https://learn.microsoft.com/en-us/ef/core/performance/efficient-querying) demonstrates projecting only required properties and its tracking trade-off.
- English, official: [SQLAlchemy column loading](https://docs.sqlalchemy.org/en/20/orm/queryguide/columns.html) documents load_only, deferred fields, and accidental follow-up SQL.
- English, official: [Django database optimization](https://docs.djangoproject.com/en/stable/topics/db/optimization/) covers values, defer, and only.
- English, official: [PostgreSQL visibility map](https://www.postgresql.org/docs/current/storage-vm.html) explains why index-only scans can still consult heap pages.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Pagination](../04-efficient-database-pagination/README.en.md) · [Next: Denormalization](../06-denormalization-for-read-heavy-workloads/README.en.md) · [Maintenance](../08-database-maintenance/README.en.md)

</div>
