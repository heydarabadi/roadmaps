# Mappings

> Chapter 02: Mappings and Data Modeling · Lesson 01

[Read the Persian version](../../../../../fa/elasticsearch/02-mappings-and-data-model/topics/01-mappings/README.md)

## Learning goals

- Treat a mapping as an index contract that determines how every field is stored and queried.
- Choose field behavior from actual product queries: full text, exact match, range, sort, or aggregation.
- Plan an index migration when an existing field's type or analysis behavior must change.

## What a mapping controls

A mapping defines field types and indexing behavior. It is more than input validation: it decides whether a value can participate in full-text retrieval, exact term matching, sorting, aggregations, range comparisons, or geospatial queries. A common catalog mapping uses `text` for analyzed titles, `keyword` for identifiers and categories, numeric fields for price, `date` for creation time, and `geo_point` for a location. Analyzed text and exact matching are different access patterns.

~~~http
PUT /products-v1
{"mappings":{"properties":{
  "sku":{"type":"keyword"},
  "title":{"type":"text","fields":{"raw":{"type":"keyword"}}},
  "price":{"type":"scaled_float","scaling_factor":100},
  "created_at":{"type":"date"}
}}}
~~~

The title multi-field stores a searchable representation plus an exact-value representation for operations such as sorting or terms aggregation. Before mapping a field, list the real queries and the allowed value shapes. If a field is never searched, filtered, sorted, or aggregated, indexing it may be unnecessary. Avoid mapping based only on a field name; document and producer behavior matter.

Mappings can usually gain new fields, but an indexed field's type or analyzer generally cannot be changed in place. Build a new versioned index with the corrected contract, reindex or replay data, compare results, and switch an alias after validation. Treat schema changes as a migration.

## Exercise

Design mappings for products with title, SKU, brand, price, tags, seller location, and seller-supplied attributes. For each field, state the query operations it must support. Decide whether a title needs a keyword multi-field and whether arbitrary attributes should be dynamically mapped.

## Quiz with answers

1. **Why is mapping part of query design?** It determines which operations are supported and how values are interpreted and indexed.
2. **How can one title support full-text search and exact sorting?** Map it as `text` with a `keyword` multi-field.
3. **Why is an in-place type change usually not the right migration?** Existing index structures were built using the old type; a corrected index and reindex are normally required.
4. **Should every source field be indexed?** No. Index fields needed by retrieval or analysis; keeping a value in `_source` alone may be enough for some fields.

## References and further reading

- [Mapping in Elasticsearch](https://www.elastic.co/docs/manage-data/data-store/mapping) — field definitions and management.
- [Field data types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types) — choose from supported types.
- [Explicit mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/explicit-mapping) — define field behavior deliberately.
- [Text fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text) and [keyword fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword) — two common, distinct search models.
- [Elasticsearch index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — settings, mappings, and shard design.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

