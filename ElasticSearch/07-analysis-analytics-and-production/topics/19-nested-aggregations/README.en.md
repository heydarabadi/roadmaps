# Nested Aggregations

> Chapter 07: Analysis, Analytics, and Production · Lesson 19

[Read the Persian version](README.md)

## Learning goals

- Aggregate values inside a nested path.
- Distinguish nested child counts from parent-document counts.
- Return to the parent level with `reverse_nested` when needed.

## Aggregate child records

When a field is mapped as `nested`, its objects are separate hidden Lucene documents associated with a parent. A nested aggregation enters the configured path so child-level terms and metrics run over nested objects. A nested bucket's `doc_count` counts child objects, not necessarily product parent documents. Use `reverse_nested` to return to the parent scope for parent-level counts or metrics.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"offers":{"nested":{"path":"offers"},
  "aggs":{"by_seller":{"terms":{"field":"offers.seller"}}}}}}
~~~

Use a nested query to select parent documents by child conditions and a nested aggregation to analyze child values. These are different parts of the request. Validate aggregation counts against a small dataset with multiple offers per product so child-versus-parent interpretation is clear.

## Exercise

Create two products with three offers. Aggregate offer counts by seller, then add a reverse-nested aggregation to count parent products per seller. Compare each count to a manual calculation.

## Quiz with answers

1. **Where does a nested aggregation begin?** At the nested field path in child-object scope.
2. **What does nested `doc_count` count?** Nested child documents, not necessarily parent products.
3. **How do you return to parent scope?** Use a `reverse_nested` aggregation.
4. **Is a nested query the same as a nested aggregation?** No; the query filters matches while the aggregation groups and summarizes nested values.

## References and further reading

- [Nested aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-nested-aggregation) — enter nested document scope.
- [Reverse nested aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-reverse-nested-aggregation) — return to parent scope.
- [Nested query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-nested-query) — filter documents by nested children.
- [Nested field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/nested) — mapping behavior and costs.
- Persian discovery search (not a verified article): [Persian Elasticsearch nested-aggregation articles](https://www.google.com/search?q=Elasticsearch+nested+aggregation+reverse_nested+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

