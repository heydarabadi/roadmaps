# Reindex API

> Chapter 05: Search Results and Maintenance · Lesson 13

[Read the Persian version](../../../../../fa/elasticsearch/05-search-results-and-maintenance/topics/13-reindex-api/README.md)

## Learning goals

- Copy documents into a destination index with a new mapping or settings.
- Monitor asynchronous reindex work and examine failures and conflicts.
- Plan for writes that continue while the source is copied.

## Rebuild into a new index

The Reindex API reads documents from a source index and writes them to a destination index. Create the destination first with its intended settings, mappings, and aliases. Reindex is commonly used for schema changes, data cleanup, and moving documents between indices. It does not automatically follow future writes to the source.

~~~http
POST /_reindex?wait_for_completion=false
{"source":{"index":"products-v1"},
 "dest":{"index":"products-v2"}}
~~~

The asynchronous request returns a task ID. Poll the task, monitor throttling, failures and version conflicts, and cancel if needed. Validate document counts, mapping, representative records, and business queries. If writes continue during the copy, use a controlled write pause, dual-write, or event replay to catch up. Only then switch an alias. Keep rollback available until the new index is proven healthy.

## Exercise

Create `products-v2` with a corrected mapping, reindex a test source, and compare counts and query results. Add one source update while reindex is running and demonstrate why it may not appear in the destination without a replay or cutover strategy.

## Quiz with answers

1. **What does Reindex do?** Reads source documents and indexes them into a destination index.
2. **Does it keep the destination synchronized with later source writes?** No.
3. **What should be validated before cutover?** Counts, mapping, failures, representative documents, query behavior, and ongoing writes.
4. **Why run asynchronously for large jobs?** It allows task monitoring, throttling, and cancellation.

## References and further reading

- [Reindex API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/reindex-indices) — source/destination behavior and options.
- [Task management](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks) — monitor and cancel long-running reindex tasks.
- [Aliases](https://www.elastic.co/docs/manage-data/data-store/aliases) — stable application name and cutover.
- [Create index API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-create) — prepare destination schema first.
- [Optimistic concurrency control](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/optimistic-concurrency-control) — protect concurrent changes.
- [Anyone.com search migration](https://www.elastic.co/customers/anyone) — vendor-reported production search migration case study.
- Persian discovery search (not a verified article): [Persian Elasticsearch reindex guides](https://www.google.com/search?q=Elasticsearch+reindex+API+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

