# Cardinality Aggregation

> Chapter 07: Analysis, Analytics, and Production · Lesson 10

[Read the Persian version](README.md)

## Learning goals

- Estimate the number of distinct values in a field.
- Understand the memory and accuracy trade-off of approximate counting.
- Avoid using cardinality as an exact accounting count.

## Approximate distinct counts

The cardinality aggregation estimates the number of distinct values for a field. It uses HyperLogLog++ to balance accuracy and resource cost rather than retaining every distinct value in an exact in-memory set. `precision_threshold` adjusts the trade-off within supported bounds, but does not promise exact counts for every cardinality and workload.

~~~http
POST /events-v1/_search
{"size":0,"aggs":{"unique_users":{"cardinality":{
  "field":"user.id","precision_threshold":3000
}}}}
~~~

This can be useful for dashboards such as approximate unique visitors. It is not suitable as the sole source for exact billing, financial reconciliation, or legal counts. Compare its estimate with an exact calculation on representative samples and document acceptable error. Field type, shard distribution, cardinality, and precision settings influence resource use.

## Exercise

For a small test index, calculate exact unique user IDs outside Elasticsearch and compare the cardinality aggregation at several precision thresholds. Record both estimation error and latency. Identify a dashboard use and a financial use that should not rely on the estimate alone.

## Quiz with answers

1. **What does cardinality measure?** The number of distinct field values, generally as an estimate.
2. **Which algorithm does Elasticsearch use?** HyperLogLog++.
3. **What does `precision_threshold` affect?** The accuracy/resource trade-off for estimation within the supported range.
4. **Should it be used as an exact financial count?** No; use an authoritative exact process for financial or other exact requirements.

## References and further reading

- [Cardinality aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-cardinality-aggregation) — precision and memory considerations.
- [Metric aggregations](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics) — cardinality among other metrics.
- [HyperLogLog++ paper](https://static.googleusercontent.com/media/research.google.com/en//pubs/archive/40671.pdf) — algorithm background.
- [Aggregations overview](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations) — aggregation design.
- Persian discovery search (not a verified article): [Persian Elasticsearch cardinality and HyperLogLog articles](https://www.google.com/search?q=Elasticsearch+cardinality+HyperLogLog+++%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

