# CAT APIs

> Chapter 07: Analysis, Analytics, and Production · Lesson 23

[Read the Persian version](README.md)

## Learning goals

- Use CAT APIs for quick human-readable inspection.
- Choose a JSON stats API for automation and monitoring.
- Understand that a CAT response is a snapshot, not a trend.

## Fast operational inspection

CAT APIs return compact, tabular output that is convenient in a terminal. Operators can inspect indices, shards, nodes, allocation, segments, and tasks without parsing a large JSON response.

~~~http
GET /_cat/indices?v&s=store.size:desc
GET /_cat/shards?v
GET /_cat/nodes?v
~~~

CAT is intended primarily for humans. Its text formatting can change and is less suitable as a stable programmatic contract. For automation and monitoring, use the corresponding JSON APIs such as cluster stats, node stats, or index stats. CAT output is only a point-in-time view; trend metrics for heap, latency, rejections, and data freshness belong in a monitoring system.

## Exercise

Find the largest indices and one unassigned shard using CAT output. Then retrieve node statistics through the JSON API and identify one trend you would alert on over time.

## Quiz with answers

1. **Who benefits most from CAT output?** Operators reading a quick summary in a terminal.
2. **Should automation parse CAT tables?** Usually use JSON stats APIs with structured response fields instead.
3. **Does one CAT snapshot show a trend?** No; monitoring should collect time-series data.
4. **What are useful checks?** Index size, shard placement, node roles, and operational triage.

## References and further reading

- [CAT APIs](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-cat) — human-readable cluster views.
- [CAT indices API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-indices)
- [CAT shards API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-shards)
- [Node stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-stats) — structured operational metrics.
- [Cluster stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-stats) — cluster-level JSON metrics.
- Persian discovery search (not a verified article): [Persian Elasticsearch CAT API tutorials](https://www.google.com/search?q=Elasticsearch+CAT+API+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

