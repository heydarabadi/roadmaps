# Document (Row Analogy)

> Chapter 02: Mappings and Data Modeling · Lesson 08

[Read the Persian version](README.md)

## Learning goals

- Model a document around a retrieval use case rather than copying a relational row structure blindly.
- Distinguish the original `_source` from the inverted index and other internal structures.
- Explain denormalization benefits and synchronization costs.

## A document represents a searchable record

An Elasticsearch document is a JSON object indexed under an `_id`. It may represent a product, an event, or a search-oriented view of an entity. Mappings determine how the document's fields are indexed. Model it for the response and queries the application needs: fields to retrieve, filter, sort, aggregate, or use for relevance.

~~~http
PUT /products-v1/_doc/sku-100
{"sku":"sku-100","title":"Mechanical keyboard","brand":"Example","price":89.99}
~~~

Search-oriented documents are often denormalized. A product result card may include the brand name and category labels so the search request can return a useful page without a join. The trade-off is that a brand rename may require updating many documents or rebuilding the projection. Very large documents, unbounded arrays, or deeply nested structures can increase storage and query costs.

The `_source` stores the original JSON payload by default, while the inverted index and doc values are separate structures built for retrieval, sorting, and analytics. They serve different purposes. Storing a value in `_source` does not by itself make it efficiently searchable or aggregatable.

## Exercise

Design a search document for a product list page. Include all fields the UI must show and those needed for search and filtering. Identify a piece of related data you would duplicate and how a change to that related data would propagate.

## Quiz with answers

1. **Should a document blindly mirror a relational row?** No. Shape it around search and retrieval requirements, while preserving an authoritative source elsewhere where needed.
2. **What is `_source`?** The stored JSON source for a document, distinct from internal search structures.
3. **Why denormalize a brand name into product documents?** It can make search responses simpler and avoid a join, at the cost of fan-out updates or rebuilds.
4. **Does having a field in `_source` mean it can be sorted or aggregated efficiently?** No. Mapping and indexed field structures determine those capabilities.

## References and further reading

- [Document APIs](https://www.elastic.co/docs/manage-data/data-store/document-apis) — index, retrieve, update, and delete documents.
- [Mapping](https://www.elastic.co/docs/manage-data/data-store/mapping) — define field indexing behavior.
- [`_source` field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/mapping-source-field) — source storage and retrieval.
- [Doc values](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values) — column-oriented structures for sorting and aggregations.
- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — documents and index internals.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

