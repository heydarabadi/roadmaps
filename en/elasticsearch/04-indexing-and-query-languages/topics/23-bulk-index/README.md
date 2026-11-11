# Bulk Indexing

> Chapter 04: Indexing and Query Languages · Lesson 23

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/23-bulk-index/README.md)

## Learning goals

- Build a Bulk API request using newline-delimited JSON.
- Understand action metadata and per-item outcomes.
- Retry only failed items with safe, bounded logic.

## NDJSON, not a JSON array

The Bulk API sends multiple actions in one HTTP request to reduce network and request overhead. Its body is newline-delimited JSON: an action-and-metadata line, followed where needed by a document or update body. A delete action needs only its metadata line. The final line must end with a newline. It is not a JSON array.

~~~http
POST /_bulk
{"index":{"_index":"products-v1","_id":"sku-101"}}
{"title":"Wireless mouse","price":29.99}
{"delete":{"_index":"products-v1","_id":"old-1"}}
~~~

Inspect the response's `errors` flag and every item result. An HTTP success does not guarantee all actions succeeded. A mapping failure for one document need not invalidate the rest. Record failed items and retry only those whose operation is safe to repeat. Stable IDs and explicit operation semantics help prevent duplicates. Handle overload responses such as 429 with bounded exponential backoff and jitter to avoid a retry storm.

## Exercise

Send a bulk request with two valid documents and one intentionally invalid field. Parse the response and list each operation's result. Implement a retry plan that only retries transient failures and records permanent mapping errors for correction.

## Quiz with answers

1. **Why use Bulk?** It batches document actions and reduces request overhead.
2. **What body format does it use?** Newline-delimited JSON action lines and optional document lines, not a JSON array.
3. **Does HTTP 200 mean every item succeeded?** No; inspect the `errors` flag and each item response.
4. **What is a safe response to 429?** Bounded retry with exponential backoff and jitter, plus concurrency control.

## References and further reading

- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk) — request format and per-item results.
- [Bulk indexing guidance](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/indexing-speed) — batch and worker tuning.
- [Bulk helpers for clients](https://www.elastic.co/docs/reference/elasticsearch/clients) — official client libraries and helper APIs.
- [Refresh parameter](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/refresh-parameter) — visibility behavior for bulk operations.
- [Anyone.com case study](https://www.elastic.co/customers/anyone) — a real-world high-volume search migration; interpret reported outcomes as workload-specific.
- Persian discovery search (not a verified article): [Persian bulk-index tutorials](https://www.google.com/search?q=Elasticsearch+bulk+indexing+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.


