# Segment Merging

> Chapter 07: Analysis, Analytics, and Production · Lesson 24

[Read the Persian version](README.md)

## Learning goals

- Explain why Lucene segments are immutable and created by refresh and flush activity.
- Understand how merges consolidate segments and reclaim deleted-document space.
- Avoid routine force merge on actively written indices.

## Immutable segments and background work

Each shard is a Lucene index composed of immutable segments. Refresh makes newly indexed changes searchable by opening new segments. Background merging combines smaller segments into larger ones and drops documents marked as deleted. More segments can increase search overhead; merging consumes CPU and I/O and may need temporary disk space. The cluster balances that work over time.

~~~http
GET /_cat/segments/products-v1?v
~~~

Observe segment count and merge activity around indexing and refresh changes. Force merge can be useful for an index that is no longer receiving writes, such as a read-only historical index, but it can be resource-intensive and create large temporary space requirements. It is not a routine fix for every slow query or a substitute for sensible refresh and indexing strategy.

## Exercise

Bulk-load a disposable index and inspect segment counts. Compare normal refresh settings with a longer refresh interval during initial load. Then delete some documents and observe how their storage is reclaimed after merges.

## Quiz with answers

1. **Why does Elasticsearch merge segments?** To reduce segment overhead and reclaim space associated with deleted documents.
2. **Are Lucene segments mutable?** No; updates create new indexed versions and old documents are later removed by merging.
3. **Why can force merge be risky?** It consumes CPU, I/O, and temporary disk and can interfere with active indexing.
4. **When can force merge be considered?** For a mostly read-only index under a planned capacity window.

## References and further reading

- [Merge settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/merge) — merge policy and controls.
- [CAT segments API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-segments) — inspect segment layout.
- [Force merge API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-forcemerge) — constraints and operational caution.
- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — Lucene shard storage model.
- [Lucene documentation](https://lucene.apache.org/core/) — segment and indexing library resources.
- Persian discovery search (not a verified article): [Persian Elasticsearch segment-merge articles](https://www.google.com/search?q=Elasticsearch+segment+merge+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

