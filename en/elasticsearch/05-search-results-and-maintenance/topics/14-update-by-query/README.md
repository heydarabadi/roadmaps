# Update by Query

> Chapter 05: Search Results and Maintenance · Lesson 14

[Read the Persian version](../../../../../fa/elasticsearch/05-search-results-and-maintenance/topics/14-update-by-query/README.md)

## Learning goals

- Update a set of documents matching a query.
- Preview scope and monitor an asynchronous task.
- Handle version conflicts and script idempotency deliberately.

## A multi-document update

Update by Query finds documents using a query and applies a partial document or script to matching records. It can be a long-running operation over many shards, and concurrent document changes can cause version conflicts. Preview with a search using the same predicate, record expected counts and sample IDs, then run with appropriate throttling and task monitoring.

~~~http
POST /products-v1/_update_by_query?wait_for_completion=false&conflicts=proceed
{"query":{"term":{"status":"legacy"}},
 "script":{"source":"ctx._source.status = params.s",
           "params":{"s":"archived"}}}
~~~

`conflicts=proceed` allows processing to continue but does not make conflicts irrelevant; inspect conflict and failure counts. Make scripts safe to retry when possible. A set-value assignment is more idempotent than incrementing a counter. If the field's mapping or indexed form must change, reindexing into a new index may be the better migration. Monitor the task and consider cancellation if it causes unacceptable load.

## Exercise

Search for legacy products and record the count before updating. Run a lab update-by-query to set status, poll the task, and verify the new state. Compare a value assignment with an incrementing script and explain retry behavior.

## Quiz with answers

1. **What does Update by Query target?** Documents matching its query when the operation selects its work.
2. **Why preview the query first?** To confirm the intended scope and approximate count before a large write.
3. **Does `conflicts=proceed` mean conflicts should be ignored?** No. The response must still be inspected and conflicts understood.
4. **Why should scripts be idempotent when possible?** Safe retries do not apply an unintended repeated change.

## References and further reading

- [Update by Query API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/update-by-query-api) — scripts, conflicts, slices, and throttling.
- [Task management](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks) — inspect, cancel, or wait for tasks.
- [Update document API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update) — single-document alternative.
- [Optimistic concurrency control](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/optimistic-concurrency-control) — manage concurrent writes.
- [Reindex API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/reindex-indices) — choose a new-index migration when schema changes.
- Persian discovery search (not a verified article): [Persian Update by Query tutorials](https://www.google.com/search?q=Elasticsearch+update_by_query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

