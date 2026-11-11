# IDs Query

> Chapter 05: Search Results and Maintenance · Lesson 10

[Read the Persian version](README.md)

## Learning goals

- Search for a bounded set of documents by `_id`.
- Understand the distinction between `_id` metadata and a business identifier field.
- Choose a retrieval API appropriate for the number of IDs.

## Match a set of known IDs

The `ids` query finds documents whose `_id` is one of the supplied values in the target index or indices. It is useful for a small, bounded list of known IDs.

~~~http
POST /products-v1/_search
{"query":{"ids":{"values":["sku-100","sku-200"]}}}
~~~

`_id` is document metadata rather than a regular field designed for every operation. If the application needs to sort or aggregate on a business key, store it separately in a `keyword` field. A very large IDs array creates a large request and can stress query parsing and coordination; use chunking or a multi-get request when the goal is direct retrieval of many known documents. Keep each batch within measured request and response limits.

## Exercise

Search for two IDs with the `ids` query, then retrieve the same documents with multi-get. Compare response shape and behavior for an unknown ID. Decide which approach suits an API that needs exact retrieval of hundreds of IDs.

## Quiz with answers

1. **What does the `ids` query match?** Document `_id` values in the targeted indices.
2. **Is `_id` the same as an indexed business field?** No. Use a separate mapped field for business sorting or aggregation.
3. **Is one request with an extremely large ID list always ideal?** No. Chunking or multi-get may be more appropriate.
4. **Which API directly retrieves multiple known IDs?** Multi-get.

## References and further reading

- [IDs query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-ids-query) — match document IDs.
- [Multi-get API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-mget) — direct retrieval of multiple IDs.
- [Get document API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get) — direct single-ID retrieval.
- [Document metadata fields](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/document-metadata-fields) — special fields including `_id`.
- Persian discovery search (not a verified article): [Persian tutorials about Elasticsearch IDs queries](https://www.google.com/search?q=Elasticsearch+ids+query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

