# Document ID (Primary-Key Analogy)

> Chapter 02: Mappings and Data Modeling · Lesson 09

[Read the Persian version](../../../../../fa/elasticsearch/02-mappings-and-data-model/topics/09-id-primary-key/README.md)

## Learning goals

- Choose a stable `_id` for retry-safe document indexing.
- Understand that `_id` is unique only within an index.
- Avoid using `_id` as a substitute for a business field needed for sorting or aggregation.

## Stable identity and retries

The `_id` identifies a document within its index and is used by direct Get, Update, and Delete operations. If it comes from a stable source key, repeating an index request targets the same logical record. If each retry generates a new random ID, duplicate records can accumulate. If Elasticsearch generates the ID, the application must save the returned value for later direct operations.

~~~http
PUT /products-v1/_doc/sku-100
{"sku":"sku-100","title":"Mechanical keyboard","price":89.99}

GET /products-v1/_doc/sku-100
~~~

An ID can be the source database key or a deterministic key derived from a stable business identity. For events, use the event identifier or a deliberate composite key. IDs with random or timestamp-only components need a clear deduplication plan. The same `_id` can exist in multiple indices. Changing an ID is generally a create-new-and-delete-old operation, not a normal field update.

If the application needs to sort or aggregate by the business identifier, map a separate `keyword` field such as `sku`. `_id` has special handling and is not a general-purpose substitute for indexed business data.

## Exercise

Design an ID strategy for a product feed that can replay yesterday's batch. Replay the same row twice and describe the result. Then explain how a product rename should affect the ID and which field should be used for exact SKU searches.

## Quiz with answers

1. **What can happen if every retry uses a new random ID?** Each retry may create another document rather than replacing the same logical record.
2. **Is `_id` globally unique across the cluster?** No. It is unique within a given index.
3. **Should a product name be the ID?** Usually not if it can change; use a stable key and keep mutable names as fields.
4. **Why map a separate `sku` field?** A keyword field supports exact query behavior and can be designed for sorting or aggregation needs.

## References and further reading

- [Document metadata fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/document-metadata-fields) — `_id` and related metadata.
- [Index a document](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index) — explicit or generated IDs.
- [Get a document](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get) — direct retrieval by ID.
- [Optimistic concurrency control](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/optimistic-concurrency-control) — coordinate concurrent updates.
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk) — batch operations and per-item outcomes.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

