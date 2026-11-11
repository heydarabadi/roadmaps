# Index a Document

> Chapter 04: Indexing and Query Languages · Lesson 12

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/12-index-document/README.md)

## Learning goals

- Index or replace a complete document with a chosen ID.
- Use a create-only endpoint when an existing ID should be rejected.
- Separate write acknowledgement from search visibility.

## Complete-document writes

The Index Document API writes a full document. With a chosen `_id`, `PUT /index/_doc/id` creates the document if it is new and replaces its indexed source if the ID already exists. The create-only endpoint, `PUT /index/_create/id`, returns a conflict if that ID already exists. Choose between them based on whether replacement or duplicate prevention is desired.

~~~http
PUT /products-v1/_doc/sku-100
{"product_id":"sku-100","title":"Wireless headphones","price":79.00}
~~~

Use a stable source identifier so retries are predictable. Read the response's result and version information. A successful write acknowledgement does not necessarily mean the document is already visible to a search; search visibility follows refresh. Get-by-ID is near real time and can observe the latest operation more directly. Use `refresh=wait_for` only when the workflow needs search visibility before continuing, not as a blanket setting on every write.

## Exercise

Index a document with an explicit ID, then index it again with a changed title. Compare the result and document contents. Repeat using `_create` and observe the conflict. Explain which operation is appropriate for an idempotent feed replay.

## Quiz with answers

1. **What does indexing a full document do when the ID already exists?** It replaces the document contents for that ID.
2. **What is the purpose of `_create`?** Create only if the ID does not already exist; otherwise return a conflict.
3. **Why use a stable ID?** Replays and retries target the same logical document instead of creating duplicates.
4. **Does a successful write guarantee immediate search visibility?** No. Search normally sees it after refresh.

## References and further reading

- [Index a document API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index) — full-document indexing.
- [Create a document API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-create) — create-only semantics.
- [Refresh parameter](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/refresh-parameter) — visibility controls.
- [Document APIs](https://www.elastic.co/docs/manage-data/data-store/document-apis) — write and retrieval overview.
- [Optimistic concurrency control](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/optimistic-concurrency-control) — protect updates from overwrite races.
- Persian discovery search (not a verified article): [Persian articles on Elasticsearch document indexing](https://www.google.com/search?q=Elasticsearch+index+document+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

