# Delete Documents

> Chapter 04: Indexing and Query Languages · Lesson 15

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/15-delete-documents/README.md)

## Learning goals

- Delete one known document by ID or delete a set of matching documents by query.
- Preview and bound a bulk deletion before execution.
- Understand soft deletion and later segment cleanup.

## Two deletion scopes

Use Delete by ID when the document identifier is known. Delete by Query removes all documents matching a query and runs as a potentially long-running task. Before a query-based delete, run the same predicate as a search, review sample hits and total counts, confirm the index target, and define an expected maximum. Monitor the task and handle failures. A broad or malformed predicate can remove far more data than intended.

~~~http
DELETE /products-v1/_doc/sku-100
~~~

Elasticsearch marks deleted documents so searches stop returning them, but the physical space is reclaimed later when Lucene segments merge. Deletion is not an undoable transaction. For privacy or regulatory deletion, understand copies in snapshots, downstream systems, replicas, and exports; a delete from the live index alone may not satisfy every retention obligation. Back up or retain data only according to approved policy.

## Exercise

In a sandbox, search for documents matching a test condition and inspect the IDs and count. Delete one known ID, then use Delete by Query for a narrow status condition. Compare the live search results and later disk usage. Never use an unrestricted delete query in a shared cluster.

## Quiz with answers

1. **How does Delete by ID differ from Delete by Query?** It targets one known ID directly; Delete by Query evaluates a predicate across matching documents.
2. **Why preview a Delete by Query with search?** To verify its scope and expected result count before an irreversible operation.
3. **Is disk space reclaimed immediately?** No. Deleted documents are removed from search results and their space is reclaimed through segment merging.
4. **Does live deletion necessarily erase every copy?** No. Snapshots and downstream systems have separate retention and deletion behavior.

## References and further reading

- [Delete document API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete) — delete one document by ID.
- [Delete by Query API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-by-query) — task behavior, throttling, and conflicts.
- [Task management APIs](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks) — monitor long-running tasks.
- [Segment merging](https://www.elastic.co/docs/reference/elasticsearch/index-settings/merge) — reclaim deleted space.
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — snapshots and retained copies.
- Persian discovery search (not a verified article): [Persian articles on Elasticsearch delete-by-query](https://www.google.com/search?q=Elasticsearch+delete+by+query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

