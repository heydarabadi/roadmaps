# Chapter 04: Indexing and Query Languages

[Read the Persian chapter guide](../../../fa/elasticsearch/04-indexing-and-query-languages/README.md)

## Learning goals

- Build indexes and model simple, nested, and flexible data structures.
- Perform document create, index, get, update, and delete operations safely.
- Compose Query DSL searches from leaf and compound clauses.
- Choose between Query DSL, ES|QL, EQL, SQL, KQL, and Lucene query-string syntax.
- Bulk index data and tune throughput using observed cluster behavior.

## Chapter thesis

Elasticsearch combines a distributed shard model with several query languages and document APIs. Understand how an operation behaves before composing it into an application: a document write, direct Get, search, partial update, and delete each have different semantics. Choose query clauses that reflect product intent: text matching can rank results; filters define eligibility; exact values require compatible mappings. Bulk APIs reduce request overhead but return per-item outcomes, so error handling, idempotency, and backpressure are part of the design.

## Concept map

~~~text
Index settings + mapping -> document APIs -> primary shards / replicas
                                   |
                    Bulk NDJSON + per-item results

Leaf queries -> bool clauses (must / should / filter / must_not)
      |                     |
      +-> Query DSL          +-> score vs eligibility

Search language choice: Query DSL | ES|QL | EQL | SQL | KQL | query string
~~~

## Study sequence

1. [Leaf vs. Compound Queries](topics/01-leaf-vs-compound-queries/README.en.md)
2. [Primary Shards](topics/02-primary-shards/README.en.md)
3. [Replica Shards](topics/03-replica-shards/README.en.md)
4. [The Split-Brain Problem](topics/04-the-split-brain-problem/README.en.md)
5. [Text](topics/05-text/README.en.md)
6. [Keyword](topics/06-keyword/README.en.md)
7. [Object](topics/07-object/README.en.md)
8. [Nested](topics/08-nested/README.en.md)
9. [Flattened](topics/09-flattened/README.en.md)
10. [Create Index](topics/10-create-index/README.en.md)
11. [Delete Index](topics/11-delete-index/README.en.md)
12. [Index Document](topics/12-index-document/README.en.md)
13. [Get Document](topics/13-get-document/README.en.md)
14. [Update Document](topics/14-update-document/README.en.md)
15. [Delete Documents](topics/15-delete-documents/README.en.md)
16. [Query DSL](topics/query-dsl/README.en.md)
17. [ES|QL](topics/16-es-ql/README.en.md)
18. [EQL](topics/17-eql/README.en.md)
19. [Elasticsearch SQL](topics/18-sql/README.en.md)
20. [Kibana Query Language](topics/19-kql/README.en.md)
21. [Lucene Query String](topics/20-lucene/README.en.md)
22. [Query Context](topics/21-query/README.en.md)
23. [Filter Context](topics/22-filter/README.en.md)
24. [Bulk Indexing](topics/23-bulk-index/README.en.md)
25. [Optimizing Bulk Indexing](topics/24-optimizing-bulk-indexing/README.en.md)

## End-to-end lab

Create a disposable catalog index with explicit mappings, then bulk-index ten products using stable IDs. Verify item-level bulk results. Retrieve one item by ID and compare it with a search request. Build a text query with an availability and price filter, update one product, and delete one test document. Finally, submit a deliberately invalid bulk item and handle only that item's failure. Record which steps are near real-time and which require search refresh.

## Design choices and common pitfalls

| Decision | Good use | Risk to control |
| --- | --- | --- |
| Primary shard count | Set from data size, growth, workload, and recovery goals | Too many shards add overhead; too few or very large shards constrain recovery and parallelism |
| Replica count | Availability and optional read capacity | Replicas consume disk and are not backups |
| `text` plus `keyword` multi-field | Full text and exact operations on the same value | Duplicated index structures and storage |
| `nested` | Conditions must belong to the same object-array element | Higher index and query cost |
| Query DSL | Application-controlled, structured search behavior | Mapping mismatch or incorrect bool semantics |
| Query context vs filter | Rank useful text while constraining eligibility | Putting every clause in scoring context can distort relevance |
| Bulk requests | High-throughput ingestion | A successful HTTP status can contain failed items; oversized batches can overload the cluster |

Do not copy legacy split-brain configuration into modern clusters. Do not run Delete Index or broad Delete by Query outside a verified sandbox without an approved operational procedure. Do not assume GET and Search have identical visibility semantics, or that all query languages can express the same operations.

## Chapter quiz

1. For product title, availability, and price, which condition usually contributes score and which conditions belong in filters?
2. Why can increasing the number of primary shards affect future migration options?
3. What can replicas do, and what can they not replace?
4. Why does Bulk API require per-item result parsing?
5. When should `nested` be used instead of a regular object array?
6. How do Query DSL, KQL, and ES|QL differ in purpose?
7. What is the safe response to repeated 429 responses during bulk indexing?

**Answer key:** (1) Title text can contribute score; availability and price normally constrain eligibility. (2) Primary-shard count is generally fixed at index creation, so changing it usually needs a new index and data movement. (3) Replicas support availability and can serve searches; they do not provide an independent backup. (4) Each action can succeed or fail independently. (5) When multiple conditions must match the same nested object. (6) Query DSL is the JSON API language, KQL is a Kibana filter language, and ES|QL is a piped data transformation/query language. (7) Apply bounded backoff with jitter, reduce concurrency, and investigate capacity or throttling.

## References

- [Query DSL](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)
- [Tune for indexing speed](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/indexing-speed)
- [Shard sizing guidance](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards)
- [Improve relevance with boolean queries](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries)
- [Anyone.com search migration case study](https://www.elastic.co/customers/anyone)
