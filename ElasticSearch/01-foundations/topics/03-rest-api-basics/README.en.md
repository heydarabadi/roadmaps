# REST API Basics

> Chapter 01: Foundations · Lesson 03

[Read the Persian version](README.md)

## Learning goals

- Read an Elasticsearch request as an HTTP method, path, parameters, headers, and optional JSON body.
- Distinguish indexing or retrieving a known document from searching an index.
- Diagnose errors by inspecting both the HTTP status and the Elasticsearch response body.

## How a request is shaped

Elasticsearch exposes REST endpoints for creating indices, indexing and retrieving documents, searching, bulk operations, and cluster administration. In Kibana Dev Tools Console, the first line contains the method and path; following lines can contain the JSON body.

~~~http
PUT /products-v1/_doc/sku-100
{"title":"Mechanical keyboard","price":89.99}

GET /products-v1/_doc/sku-100
~~~

The first request indexes a complete document under a known ID. A retry targets the same record, which is easier to reason about than generating a new ID for every attempt. A PUT with a full document replaces its indexed contents; a partial update uses the Update API and has different semantics. The GET request reads a known ID and does not run a relevance query.

## Methods, search, and responses

GET is commonly used to retrieve information. PUT is commonly used for a known resource or document ID. POST is used by many endpoints whose request body carries a search or bulk payload. DELETE removes a resource. Follow the specific endpoint's documentation rather than assuming that one method always means one behavior.

~~~http
POST /products-v1/_search
{"query":{"match":{"title":"mechanical keyboard"}}}
~~~

Search returns matching hits, scores, and metadata. In application code, use a supported Elasticsearch client where possible; configure TLS, authentication, request timeouts, and bounded retries. Never put credentials in source control or logs. A retry is safest when the operation is idempotent or protected by a stable ID and an explicit concurrency strategy.

## Read errors carefully

Check the method, path, index name, ID, and request shape first. Then inspect the HTTP status and the JSON error fields, especially `type` and `reason`. A mapping error differs from an authorization failure or a timeout. Bulk requests need item-level inspection: the overall HTTP response can succeed while individual operations report errors. Record failed items and retry only those that are safe to retry.

## Hands-on exercise

Create one document, retrieve it by ID, update only its price, and find it with a search query. Save the response from each request. Explain which operation uses the document ID directly and which one evaluates a query over the index.

## Quiz with answers

1. **What are the common pieces of an HTTP request?** Method, path, optional query parameters and headers, and an optional body.
2. **Why are GET-by-ID and search not interchangeable?** GET retrieves one known ID; search evaluates a query and can return many ranked matches.
3. **Why is an HTTP success status insufficient for a bulk request?** The body reports the outcome of each bulk item, and some items may fail.
4. **Why can a stable ID help with retries?** It allows a retry to address the same logical document, provided the chosen operation has the intended overwrite or concurrency behavior.

## References and further reading

- [Elasticsearch REST APIs](https://www.elastic.co/docs/reference/elasticsearch/rest-apis) — endpoint conventions and common behavior.
- [Index a document](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index) — index API details.
- [Get a document](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get) — direct retrieval by ID.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — search request and response structure.
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk) — item-level results and bulk request format.
- [Refresh parameter](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/refresh-parameter) — when writes become visible to search.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

