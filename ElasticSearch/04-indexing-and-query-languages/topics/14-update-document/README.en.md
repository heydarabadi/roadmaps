# Update a Document

> Chapter 04: Indexing and Query Languages · Lesson 14

[Read the Persian version](README.md)

## Learning goals

- Distinguish a partial update from indexing a full replacement document.
- Understand that an update still rewrites document data in Lucene's immutable segments.
- Choose an idempotent update or a concurrency strategy deliberately.

## Partial fields and scripts

The Update API lets a caller provide a partial `doc` object or a script for a conditional change. It does not edit bytes in place inside a Lucene segment: Elasticsearch retrieves the current document, applies the change, and indexes a new version. For high-frequency updates, this has cost and can create contention. If the application already has the full authoritative record, indexing the full document may be simpler.

~~~http
POST /products-v1/_update/sku-100
{"doc":{"price":69.00}}
~~~

Setting a value to 69.00 is idempotent when repeated; incrementing a counter is not idempotent unless guarded by an event ID or version strategy. Multiple writers can race, so use optimistic concurrency controls when lost updates matter. Treat `retry_on_conflict` as a retry policy, not as proof that every update is semantically safe.

## Exercise

Update a product's price using a partial `doc`, then repeat the same request. Compare it with a scripted increment run twice. Add a concurrency condition or deduplication mechanism for a business event that must be applied exactly once.

## Quiz with answers

1. **What is the difference between indexing and partial update?** Index writes a full document; update applies a partial document or script to the existing document.
2. **Does update modify Lucene data in place?** No. It results in a new indexed document version and marks the prior version for later cleanup.
3. **Which operation is idempotent: set price to 69 or add 1 to quantity?** Setting is idempotent under repetition; addition changes state on every retry.
4. **How do you protect concurrent writers?** Use optimistic concurrency, version checks, or application-level sequencing appropriate to the workflow.

## References and further reading

- [Update document API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update) — partial and scripted updates.
- [Optimistic concurrency control](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/optimistic-concurrency-control) — sequence numbers and primary terms.
- [Index a document](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index) — full replacement semantics.
- [Document APIs](https://www.elastic.co/docs/manage-data/data-store/document-apis) — document operation overview.
- [Segment merging](https://www.elastic.co/docs/reference/elasticsearch/index-settings/merge) — background reclamation of deleted versions.
- Persian discovery search (not a verified article): [Persian Elasticsearch update API articles](https://www.google.com/search?q=Elasticsearch+update+document+API+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

