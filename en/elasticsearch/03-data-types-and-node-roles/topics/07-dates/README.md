# Date Fields

> Chapter 03: Data Types and Node Roles · Lesson 07

[Read the Persian version](../../../../../fa/elasticsearch/03-data-types-and-node-roles/topics/07-dates/README.md)

## Learning goals

- Represent timestamps in a consistent format and timezone.
- Use date fields for range filters, sorting, and time-based aggregations.
- Distinguish an instant from a local wall-clock time.

## Make time unambiguous

A date field stores a timestamp that Elasticsearch can parse and use for time operations. Prefer a consistent machine-readable format, commonly ISO 8601 with an explicit UTC marker or offset. If events originate in local time, convert them to an instant using the correct timezone before indexing. A timestamp such as `2026-11-11 09:00` is ambiguous without a timezone and may represent different instants across systems.

~~~http
PUT /events-v1
{"mappings":{"properties":{"@timestamp":{"type":"date"}}}}

POST /events-v1/_search
{"query":{"range":{"@timestamp":{"gte":"2026-11-01T00:00:00Z","lt":"2026-12-01T00:00:00Z"}}},
 "sort":[{"@timestamp":"desc"}]}
~~~

Use a half-open interval such as `[start, end)` for adjacent time windows so an event at the boundary is counted once. Specify formats deliberately if a producer sends a nonstandard format. For dashboards, understand the Kibana time zone and the date field selected as the time field. Avoid mixing epoch seconds, epoch milliseconds, and strings without a normalization contract.

## Exercise

Index two events, one near midnight UTC and one near local midnight in Tehran. Convert both to UTC instants, then run a date range query. Explain which calendar day each event belongs to in UTC and in the local user interface.

## Quiz with answers

1. **Why include a timezone or normalize to UTC?** It identifies the actual instant rather than relying on an ambiguous local clock value.
2. **Why use a half-open interval?** Neighboring windows meet without double-counting an event at the shared boundary.
3. **What operations does a date mapping enable?** Range queries, sorting, and date histogram or other time aggregations.
4. **What is the danger of mixing epoch seconds and milliseconds?** Values represent very different dates and can be parsed into incorrect time ranges.

## References and further reading

- [Date field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date) — date formats and parsing.
- [Date math](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/common-options#date-math) — relative date expressions.
- [Range query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-range-query) — filter by time intervals.
- [Date histogram aggregation](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-datehistogram-aggregation) — group events over time.
- Persian discovery search (not a verified article): [Search Persian tutorials on Elasticsearch date mapping and timezone](https://www.google.com/search?q=Elasticsearch+date+timezone+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C+mapping).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

