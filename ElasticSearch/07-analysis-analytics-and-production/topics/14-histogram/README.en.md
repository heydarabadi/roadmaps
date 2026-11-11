# Histogram Aggregations

> Chapter 07: Analysis, Analytics, and Production · Lesson 14

[Read the Persian version](README.md)

## Learning goals

- Bucket numeric values at a fixed interval.
- Distinguish numeric histogram from calendar-based date histogram.
- Choose a bucket width that communicates a useful business pattern.

## Fixed-width buckets

A histogram aggregation divides numeric values into evenly spaced buckets. A date histogram groups dates using fixed or calendar intervals. Calendar intervals follow calendar units such as months or days, while fixed intervals represent a constant duration. Choose based on the question: “last 24 hours in fixed windows” differs from “daily totals by local calendar day.”

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"price_hist":{"histogram":{
  "field":"total","interval":1000,"min_doc_count":0
}}}}
~~~

The interval must use the field's unit. Too-small intervals can produce many noisy buckets and a large response; too-large intervals can hide useful structure. `min_doc_count: 0` can request empty buckets between bounds, which is useful for continuous charts but can expand output. Set `extended_bounds` only when the chart needs a defined range beyond observed values.

## Exercise

Build histograms with three bucket widths for the same order totals. Compare bucket count and readability. Create a date histogram with fixed and calendar intervals and explain which one matches a local daily business report.

## Quiz with answers

1. **What does a numeric histogram do?** Groups numeric values into buckets with a constant interval.
2. **How does a calendar interval differ from a fixed interval?** Calendar intervals follow calendar boundaries; fixed intervals use constant durations.
3. **What can `min_doc_count: 0` do?** Include empty buckets, potentially increasing response size.
4. **How should interval width be chosen?** Based on units, audience, noise, and the number of readable buckets.

## References and further reading

- [Histogram aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-histogram-aggregation) — numeric fixed buckets.
- [Date histogram aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-datehistogram-aggregation) — fixed versus calendar intervals and timezones.
- [Range aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-range-aggregation) — explicit non-uniform ranges.
- [Aggregations overview](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations) — build charts and summaries.
- Persian discovery search (not a verified article): [Persian Elasticsearch histogram and date-histogram articles](https://www.google.com/search?q=Elasticsearch+histogram+date_histogram+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

