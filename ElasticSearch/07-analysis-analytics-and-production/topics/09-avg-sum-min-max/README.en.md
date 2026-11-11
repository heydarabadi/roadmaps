# Average, Sum, Minimum, and Maximum

> Chapter 07: Analysis, Analytics, and Production · Lesson 09

[Read the Persian version](README.md)

## Learning goals

- Use metric aggregations for numeric summaries.
- Interpret averages in the presence of missing and multi-valued fields.
- Define units and cohort filters before reporting results.

## Summarize the selected population

`sum`, `avg`, `min`, and `max` calculate metrics over numeric values in the documents matched by the query. The aggregation result is only meaningful when you understand the selected cohort, units, missing values, and whether fields can have multiple values. An average is usually over existing numeric values, not necessarily every document. An array-valued field may contribute several values from one document.

~~~http
POST /orders-v1/_search
{"size":0,"query":{"term":{"status":"paid"}},
 "aggs":{"revenue":{"sum":{"field":"total"}},
         "mean":{"avg":{"field":"total"}},
         "minimum":{"min":{"field":"total"}},
         "maximum":{"max":{"field":"total"}}}}
~~~

The query restricts the population to paid orders. The example still needs a documented currency and precision convention. A zero sum can also mean no numeric values were present, so read the count and existence information. For financial reporting, define rounding, refunds, currency conversion, and authoritative accounting rules rather than assuming an aggregation handles those policies.

## Exercise

Compute average and total for a small set of orders with one missing total and one multi-valued test field. Compare Elasticsearch output with a manual calculation, then explain which business definition is intended.

## Quiz with answers

1. **Which documents are summarized?** Those matched by the query or aggregation scope.
2. **How is `avg` affected by missing values?** Missing values are generally omitted from the average.
3. **Can a sum of zero prove records had numeric zero values?** No; there may have been no values, so inspect counts and filters.
4. **What must accompany a monetary metric?** Currency, unit, precision, rounding, and population definitions.

## References and further reading

- [Sum aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-sum-aggregation)
- [Average aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-avg-aggregation)
- [Min aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-min-aggregation)
- [Max aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-max-aggregation)
- [Metric aggregations](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics) — definitions and related metrics.
- Persian discovery search (not a verified article): [Persian metric-aggregation articles](https://www.google.com/search?q=Elasticsearch+avg+sum+aggregation+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


