# Stats and Extended Stats

> Chapter 07: Analysis, Analytics, and Production · Lesson 11

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/11-stats-extended-stats/README.md)

## Learning goals

- Summarize a numeric field with a bundle of metrics.
- Add variance and standard deviation when spread matters.
- Interpret metrics in the context of missing values and outliers.

## Summary metrics

The `stats` aggregation returns count, minimum, maximum, average, and sum for numeric values in the matched document set. `extended_stats` adds measures such as variance and standard deviation. These statistics describe a population of values, but they do not explain why a distribution looks the way it does. Outliers, skew, multi-valued fields, and missing records can change the interpretation.

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"order_totals":{"extended_stats":{"field":"total"}}}}
~~~

Define the query cohort and currency or unit before interpreting the result. Compare average and spread with a histogram or percentile aggregation when the distribution is skewed. A standard deviation by itself does not prove a service is healthy or identify a business cause.

## Exercise

Calculate stats for order totals with and without one unusually large order. Compare average, min, max, and standard deviation. Add a histogram and explain which view helps answer the business question.

## Quiz with answers

1. **What does `stats` return?** Count, min, max, average, and sum.
2. **What does `extended_stats` add?** Measures including variance and standard deviation.
3. **Why inspect the cohort and missingness?** The aggregation only summarizes values available in the selected documents.
4. **Does standard deviation explain the distribution's cause?** No; it is a summary statistic and should be paired with context and other views.

## References and further reading

- [Stats aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-stats-aggregation) — summary metrics.
- [Extended stats aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-extendedstats-aggregation) — dispersion measures.
- [Percentiles aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-percentile-aggregation) — distribution quantiles.
- [Histogram aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-histogram-aggregation) — inspect distribution shape.
- Persian discovery search (not a verified article): [Persian Elasticsearch stats-aggregation articles](https://www.google.com/search?q=Elasticsearch+extended_stats+aggregation+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

