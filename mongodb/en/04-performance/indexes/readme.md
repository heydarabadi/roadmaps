# Indexes: Single-Field, Compound, TTL, and Geospatial

> **Persian edition:** [Read this lesson in Persian](../../../04-performance/indexes/readme.md).

> **Learning goal:** Derive indexes from real query shapes and measure their effect on reads, writes, and storage.

## Why an index helps—and what it costs

Without a useful index, MongoDB may examine many or all documents to find matches. An index stores an ordered structure of keys and record locations so the server can narrow a search or return results in order. Indexes consume storage and memory and must be maintained during inserts, updates, and deletes. Too many indexes can slow writes and compete for cache.

## Common index types

- **Single-field:** filter or sort on one field.
- **Compound:** index several fields in a specific order; prefixes matter.
- **Multikey:** index array values; one document may produce multiple keys.
- **Unique:** enforce uniqueness; existing duplicates block creation.
- **Partial:** index only documents that match a filter; queries must be compatible with it.
- **TTL:** remove expired documents asynchronously based on a date field; removal is not exact to the second.
- **Geospatial:** query GeoJSON locations or legacy coordinate pairs.
- **Text:** basic language-oriented text search in a collection; it is not the same as Atlas Search.

## Compound indexes and ESR

For a query with equality fields, sort fields, and range conditions, **Equality → Sort → Range (ESR)** is a useful starting heuristic. It is not a law. Consider selectivity, sort direction, field cardinality, optional filters, and the actual query mix. The leftmost prefixes of a compound index can support some queries; later keys cannot usually replace missing leading keys.

~~~javascript
db.orders.createIndex({ customerId: 1, status: 1, createdAt: -1, _id: -1 })
~~~

This candidate may support equality on `customerId` and `status` with a recent-first sort. If `status` is optional, the query shape may need a different index. Check the plan rather than assuming that a compound index covers every combination.

## Example: TTL index

~~~javascript
db.sessions.createIndex({ expiresAt: 1 }, { expireAfterSeconds: 0 })
~~~

The expiry field must be a BSON Date. TTL cleanup is performed in the background; do not use it as a precise job scheduler or as the only guarantee that an expired credential is rejected.

## Design a query index step by step

1. Capture a frequent filter, sort, and projection from a real request.
2. Note equality, range, array, and ordering conditions.
3. Propose the smallest useful index and document the intended query shapes.
4. Use `explain("executionStats")` on representative data.
5. Measure latency, examined keys/documents, storage, and write impact.
6. Revisit unused indexes only after observing them over a representative period.

A covered query may return needed values from the index without fetching the full document. This can reduce document reads, but a wider index has greater storage and write cost.

## Common mistakes

- Adding an index to every field without considering write overhead.
- Forgetting compound-key order and index prefixes.
- Expecting TTL deletion at an exact timestamp.
- Confusing a classic text index with Atlas Search.
- Creating a unique index before checking old duplicates.
- Choosing a compound index without matching the real filter and sort.

## Exercises

1. Propose an index for `{customerId}` equality plus descending `{createdAt, _id}` ordering.
2. Compare a TTL index with an application cleanup job and a hard authorization expiry check.
3. Explain how adding three indexes might affect a write-heavy collection.

## Quiz and answer key

1. **What is an index trade-off?** Faster or more selective reads in exchange for storage and write-maintenance cost.
2. **Why does compound-key order matter?** It affects prefixes and whether a filter/sort can use the index.
3. **Does TTL delete exactly at expiration time?** No. Background cleanup may happen later.
4. **Why not index every field?** Unneeded indexes use storage/cache and add work to every relevant write.
5. **Applied task: index customer order history.** Try `{customerId: 1, createdAt: -1, _id: -1}` and verify filter/sort support with explain.
6. **What is a unique index for?** Enforcing uniqueness for the indexed key pattern.
7. **What is a multikey index for?** Fields containing array values.
8. **What does a partial index store?** Only documents that satisfy its partial filter.
9. **Does an IXSCAN prove the query is cheap?** No; inspect examined keys/documents, sort work, latency, and workload.
10. **Why does an index affect writes?** A document change may require index keys to be added, changed, or removed.

## Further reading

- [Indexes](https://www.mongodb.com/docs/manual/indexes/)
- [Index Types](https://www.mongodb.com/docs/manual/core/indexes/index-types/)
- [Compound Indexes](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-compound/)
- [Equality, Sort, Range (ESR) Guideline](https://www.mongodb.com/docs/manual/tutorial/equality-sort-range-guideline/)
- [Indexing Strategies](https://www.mongodb.com/docs/manual/applications/indexes/)
- [Performance Best Practices: Indexing — MongoDB engineering blog](https://www.mongodb.com/company/blog/performance-best-practices-indexing)
- [Indexing Design Fundamentals — MongoDB University](https://learn.mongodb.com/learn/course/indexing-design-fundamentals/indexing-design-fundamentals/index-key-order)
- [TTL Indexes](https://www.mongodb.com/docs/manual/core/index-ttl/)
- [Geospatial Queries](https://www.mongodb.com/docs/manual/geospatial-queries/)
- [Index and performance guide in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-5)
- [Curated reference library: indexes](../../reference-library.md#performance-indexes)

---
Sources reviewed: 2026-11-11.
