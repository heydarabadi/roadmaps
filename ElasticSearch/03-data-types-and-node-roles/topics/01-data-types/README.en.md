# Data Types

> Chapter 03: Data Types and Node Roles · Lesson 01

[Read the Persian version](README.md)

## Learning goals

- Select an Elasticsearch field type from the operations the application needs.
- Distinguish analyzed text and exact values.
- Treat type and format decisions as part of the index contract.

## Design the field for its query

For each field, ask what the product needs to do. Does it search natural-language terms and rank the matching documents? Use `text` with a suitable analyzer. Does it compare the entire value, sort, or create facets? Use `keyword`. Does it need a numeric range or sum? Choose an appropriate numeric type. Use `date` for time, `boolean` for a true-or-false state, and `geo_point` for a point location. Arrays do not have a separate type, but their values must be compatible with the field mapping.

~~~http
PUT /shops-v1
{"mappings":{"properties":{
  "name":{"type":"text","fields":{"keyword":{"type":"keyword"}}},
  "price":{"type":"long"},
  "open":{"type":"boolean"},
  "location":{"type":"geo_point"},
  "updated_at":{"type":"date"}
}}}

POST /shops-v1/_search
{"query":{"geo_distance":{"distance":"5km","location":{"lat":35.70,"lon":51.40}}}}
~~~

For a geo point expressed as an array, use `[longitude, latitude]`; an object with named `lat` and `lon` keys is easier to review. Store money using a documented currency and precision convention. A wrong type or analyzer is rarely fixed by editing old indexed values in place; plan a new index and reindex.

## Exercise

Model an event with a searchable message, exact service name, duration in milliseconds, success flag, timestamp, and host location. For each field, name the query type it supports and one invalid or ambiguous producer value to reject or normalize.

## Quiz with answers

1. **How can one name be searchable and sortable?** Map a `text` field with a `keyword` multi-field.
2. **What is the order of geo coordinates in an array?** Longitude first, latitude second.
3. **Why store money with an explicit unit and precision?** Numeric representation alone does not define whether a value is dollars, cents, or another currency.
4. **What should guide type selection?** Query, sorting, aggregation, precision, and validation requirements.

## References and further reading

- [Field data types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types) — overview of mappings.
- [Text fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text) and [keyword fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — analyzed and exact-value semantics.
- [Numeric fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number) — range, precision, and numeric mapping choices.
- [Date fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date) — accepted date representations.
- [Geo point fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/geo-point) — coordinates and supported operations.
- Persian discovery search (not a verified article): its [topic-focused Persian article search](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C+Elasticsearch+field+types).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


