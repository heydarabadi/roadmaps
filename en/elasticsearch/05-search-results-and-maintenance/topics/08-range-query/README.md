# Range Query

> Chapter 05: Search Results and Maintenance · Lesson 08

[Read the Persian version](../../../../../fa/elasticsearch/05-search-results-and-maintenance/topics/08-range-query/README.md)

## Learning goals

- Express numeric and date intervals with inclusive or exclusive boundaries.
- Choose field mappings that support ordered comparisons.
- Make timezone and unit semantics explicit.

## Define the interval precisely

The range query uses `gt`, `gte`, `lt`, and `lte` to express lower and upper bounds. `gt` and `lt` are exclusive; `gte` and `lte` include the boundary. Range queries are appropriate for numeric, date, and other ordered fields. A text representation of a number does not have the intended numeric semantics.

~~~http
POST /orders-v1/_search
{"query":{"range":{"created_at":{
  "gte":"2026-01-01T00:00:00Z",
  "lt":"2026-02-01T00:00:00Z"
}}}}
~~~

This is a half-open interval for January in UTC. Half-open intervals avoid counting an event at a shared boundary twice when adjacent windows are queried. For local business days, calculate the correct start and end instants using the intended timezone, including daylight-saving transitions where relevant. For prices, state currency and unit conventions and use values whose precision matches the business model.

## Exercise

Create events at the exact start, just before the end, and exactly at the end boundary. Run the half-open range and explain which events match. Repeat for a Tehran local calendar day by converting its boundaries to UTC.

## Quiz with answers

1. **What does `gte` mean?** Greater than or equal to the given boundary.
2. **Why use `lt` for the next month's start?** It creates a half-open period and prevents overlap with the next interval.
3. **Why include timezone information?** It defines the instant represented and prevents ambiguous local-time boundaries.
4. **Which mapping should support price ranges?** An appropriate numeric field.

## References and further reading

- [Range query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-range-query) — operators and field support.
- [Date field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date) — formats and timezone parsing.
- [Date math](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/common-options#date-math) — relative date expressions.
- [Numeric field types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number) — numeric ranges and precision.
- Persian discovery search (not a verified article): [Persian range-query and date-boundary articles](https://www.google.com/search?q=Elasticsearch+range+query+date+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

