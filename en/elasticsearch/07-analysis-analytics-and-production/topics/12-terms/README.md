# Terms Aggregation

> Chapter 07: Analysis, Analytics, and Production · Lesson 12

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/12-terms/README.md)

## Learning goals

- Group documents by field values and inspect bucket counts.
- Use a keyword-like field and choose a sensible top-bucket size.
- Understand distributed top-N and high-cardinality limits.

## Top values and bucket counts

The terms aggregation creates a bucket for each field term and reports how many documents belong to each bucket. It is commonly used for facets such as product brand or category. String fields should generally be mapped as `keyword` for this purpose. The `size` parameter controls how many top buckets are returned; it does not imply that every distinct value is returned.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"brands":{"terms":{"field":"brand","size":10}}}}
~~~

Because shards collect local candidates before the coordinator merges them, distributed top-N accuracy can depend on `shard_size` and data distribution. A high-cardinality field can create many buckets and consume resources. For enumerating all values, use composite aggregation with `after` pagination rather than trying to return an unbounded number of terms in one response.

## Exercise

Create a dataset where a brand is common on one shard but less common globally. Compare terms results with different `shard_size` values. Then page through all distinct brand values with composite aggregation and an `after_key`.

## Quiz with answers

1. **What does each terms bucket's `doc_count` count?** Documents containing the corresponding term in the aggregation scope.
2. **Does `size: 10` return every value?** No, it returns a limited set of top buckets.
3. **Why can shard distribution affect top buckets?** Each shard sends candidate buckets for distributed reduction.
4. **How can high-cardinality terms be enumerated?** Use composite aggregation with `after` pagination.

## References and further reading

- [Terms aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-terms-aggregation) — bucket selection and distributed accuracy.
- [Composite aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-composite-aggregation) — paginate across many buckets.
- [Keyword field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — exact aggregation values.
- [Aggregations overview](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations) — bucket and metric composition.
- Persian discovery search (not a verified article): [Persian Elasticsearch terms aggregation articles](https://www.google.com/search?q=Elasticsearch+terms+aggregation+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

