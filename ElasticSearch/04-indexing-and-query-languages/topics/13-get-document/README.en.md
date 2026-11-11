# Get a Document

> Chapter 04: Indexing and Query Languages · Lesson 13

[Read the Persian version](README.md)

## Learning goals

- Retrieve a known document directly by index and `_id`.
- Distinguish Get-by-ID from search.
- Limit returned source fields where payload size or data exposure matters.

## Direct lookup

The Get API retrieves a document by its index and ID. It is designed for a known identifier, not for evaluating a query over fields. A search request runs query logic across shards and returns matching documents. Get is real-time by default, whereas search is near real-time because it observes refreshed search structures. A just-written document can therefore be retrievable by ID before it appears in search.

~~~http
GET /products-v1/_doc/sku-100?_source_includes=product_id,title,price
~~~

The `_source_includes` parameter limits which source fields are returned. Source filtering reduces response size and can help avoid returning internal fields unnecessarily, but it is not an authorization boundary by itself. Apply index and field-level access controls where required. If Get returns not found, check the index, ID, routing value, and whether the document was actually created.

## Exercise

Index a test product. Immediately retrieve it by ID and search for it by title. Repeat the search after refresh. Compare what each endpoint guarantees and try source filtering to return only the fields needed by a product-card API.

## Quiz with answers

1. **What is Get-by-ID for?** Retrieving a known document by its identifier.
2. **How does it differ from search?** Search evaluates a query over indexed fields; Get directly looks up an ID.
3. **Why can Get return a document before search does?** Get is real-time, while search visibility normally follows refresh.
4. **Does source filtering replace access control?** No. It shapes the response but does not replace authorization.

## References and further reading

- [Get document API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get) — retrieve by ID.
- [Multi-get API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-mget) — retrieve multiple known IDs in one request.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — query-based retrieval.
- [Source filtering](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/retrieve-selected-fields) — return selected fields.
- [Refresh parameter](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/refresh-parameter) — distinguish search visibility from write completion.
- Persian discovery search (not a verified article): [Persian guides to Elasticsearch Get and Search APIs](https://www.google.com/search?q=Elasticsearch+get+document+search+API+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

