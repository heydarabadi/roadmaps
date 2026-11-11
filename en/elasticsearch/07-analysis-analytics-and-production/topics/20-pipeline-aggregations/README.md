# Pipeline Aggregations

> Chapter 07: Analysis, Analytics, and Production · Lesson 20

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/20-pipeline-aggregations/README.md)

## Learning goals

- Use aggregation output as input to a subsequent calculation.
- Understand bucket paths and parent/sibling pipeline scope.
- Handle empty buckets and first-bucket behavior.

## Calculate from aggregation results

Pipeline aggregations operate on the output of other aggregations rather than reading raw documents again. They can calculate a derivative, cumulative sum, moving function, or bucket selection. The aggregation tree and `buckets_path` must point to the intended metric and bucket level.

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"by_day":{"date_histogram":{"field":"created_at","calendar_interval":"day"},
  "aggs":{"sales":{"sum":{"field":"total"}},
          "daily_change":{"derivative":{"buckets_path":"sales"}}}}}}
~~~

The first derivative bucket does not have a prior bucket for comparison, and empty or missing buckets affect interpretation. A pipeline aggregation does not re-query the source records; it computes over the aggregation results. Check response paths and errors when metrics are nested or bucket layouts change.

## Exercise

Calculate daily sales and derivative over a week containing one day without sales. Compare output with a manual series. Decide how missing buckets should be represented and whether a moving average would answer the product question better.

## Quiz with answers

1. **What does a pipeline aggregation consume?** Metrics or buckets produced by other aggregations.
2. **What does `buckets_path` specify?** The aggregation result path used as pipeline input.
3. **Why may the first derivative be empty?** It has no previous bucket for comparison.
4. **Does the pipeline aggregation re-run the source query?** No, it calculates over aggregation results.

## References and further reading

- [Pipeline aggregations](https://www.elastic.co/docs/reference/aggregations/pipeline) — types and scope.
- [Derivative aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-pipeline-derivative-aggregation) — change between buckets.
- [Moving function aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-pipeline-moving-function-aggregation) — rolling calculations.
- [Bucket selector aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-pipeline-bucket-selector-aggregation) — filter buckets using metrics.
- Persian discovery search (not a verified article): [Persian Elasticsearch pipeline aggregation tutorials](https://www.google.com/search?q=Elasticsearch+pipeline+aggregation+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

