# Range and Date Range Aggregations

> Chapter 07: Analysis, Analytics, and Production · Lesson 13

[Read the Persian version](README.md)

## Learning goals

- Bucket numeric and date values into explicit intervals.
- Define boundaries so values are not accidentally double-counted or omitted.
- Apply timezone and interval semantics to time-based reporting.

## Explicit intervals

Range aggregation groups numeric values into buckets whose lower and upper bounds you define. Date range aggregation does the same for timestamps. Boundary rules matter: a bucket is typically lower-inclusive and upper-exclusive. Design adjacent ranges so an exact boundary belongs to one bucket, and account for the units and date format.

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"revenue_bands":{"range":{"field":"total","ranges":[
  {"to":1000},{"from":1000,"to":5000},{"from":5000}
]}}}
~~~

For dates, decide whether reporting uses UTC or a local business timezone and handle daylight-saving transitions where relevant. Query ranges and aggregation ranges answer related but different questions: a query selects the overall population, while aggregation ranges partition that population into buckets.

## Exercise

Create values below, at, and above each numeric boundary. Confirm every record lands in exactly the intended bucket. Repeat with a date range around midnight in a local timezone and explain the UTC instants used.

## Quiz with answers

1. **What does a range aggregation do?** Creates buckets for values in configured intervals.
2. **Why check exact boundary values?** To prevent overlap or gaps between adjacent buckets.
3. **What affects date bucket interpretation?** Timezone, format, and interval definitions.
4. **How does the outer query relate to these buckets?** It selects the document population that the aggregation then divides.

## References and further reading

- [Range aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-range-aggregation) — numeric range buckets.
- [Date range aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-daterange-aggregation) — timestamp ranges.
- [Date histogram aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-datehistogram-aggregation) — calendar and fixed intervals.
- [Date field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date) — timestamp parsing.
- Persian discovery search (not a verified article): [Persian tutorials for range and date-range aggregations](https://www.google.com/search?q=Elasticsearch+date_range+aggregation+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

