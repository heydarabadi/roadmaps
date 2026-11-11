# Value Count Aggregation

> Chapter 07: Analysis, Analytics, and Production · Lesson 08

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/08-value-count/README.md)

## Learning goals

- Count field values across the documents matched by a query.
- Distinguish value count from document count.
- Account for arrays and missing values.

## Count values, not necessarily documents

The `value_count` metric aggregation counts values of a field in the matching document set. A document with a multi-valued field can contribute more than one value. Missing values generally contribute none. Therefore, `value_count` can differ from a bucket's `doc_count` or the number of matching documents.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"brand_values":{"value_count":{"field":"brand"}}}}
~~~

This counts indexed brand values for matched documents. If the business question is “how many products have a brand?” use an existence filter or another metric aligned to documents. If the question is “how many brand entries exist?”, `value_count` may be appropriate. Explain handling of arrays, nulls, and missing fields in the report definition.

## Exercise

Index one document with one brand, one with two brand values, and one with no brand. Compare `value_count`, `exists`-filtered document count, and total hits. State which metric answers each of three business questions.

## Quiz with answers

1. **What does `value_count` count?** Field values across the matched documents.
2. **Can one document contribute multiple values?** Yes, if the field is multi-valued.
3. **Is it always the same as `doc_count`?** No. `doc_count` counts documents, while `value_count` counts values.
4. **Do missing values count?** No indexed value means no contribution, unless mapping or data design changes that behavior.

## References and further reading

- [Value count aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-valuecount-aggregation) — semantics and examples.
- [Metric aggregations](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics) — other numeric summaries.
- [Exists query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-exists-query) — select documents with indexed values.
- [Aggregations overview](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations) — aggregation structure and response.
- Persian discovery search (not a verified article): [Persian Elasticsearch value-count articles](https://www.google.com/search?q=Elasticsearch+value_count+aggregation+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

