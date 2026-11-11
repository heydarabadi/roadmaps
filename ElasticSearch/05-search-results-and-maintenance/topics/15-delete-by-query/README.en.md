# Delete by Query

> Chapter 05: Search Results and Maintenance · Lesson 15

[Read the Persian version](README.md)

## Learning goals

- Remove documents matching a defined query.
- Preview the target set and guard against an overly broad predicate.
- Monitor task progress, throttling, and failures.

## Review before removing many records

Delete by Query applies a predicate across matching documents and can generate substantial write, tombstone, and merge activity. First run the exact same predicate as a search. Review sample IDs, counts, the target index or data stream, and the retention policy. For large jobs, run asynchronously, throttle to protect the cluster, monitor the task, and examine its failures and deleted count.

~~~http
POST /events-v1/_delete_by_query?wait_for_completion=false&requests_per_second=200
{"query":{"range":{"@timestamp":{"lt":"2025-01-01T00:00:00Z"}}}}
~~~

This example is only appropriate after the retention boundary and index target have been confirmed. Avoid wildcard targets. A broad or incorrectly zoned date condition can remove current records. Deletion is not an immediate physical erase: Lucene reclaims space later during merges. If the requirement is legal or privacy deletion, account for snapshots, replicas, exports, and downstream copies according to the applicable retention process.

## Exercise

In a sandbox, search for events older than a test cutoff and compare the count with an independently calculated expected value. Run Delete by Query, poll the task, and verify remaining events. Document how you would recover if the selected cutoff were wrong.

## Quiz with answers

1. **Why run a search before Delete by Query?** To verify the predicate, target records, and expected count before an irreversible bulk delete.
2. **Can it run asynchronously?** Yes; the task API can be used to monitor or cancel long-running work.
3. **Does deletion reclaim disk immediately?** No. Deleted records are removed logically and segment space is reclaimed later.
4. **Does deleting from the live index erase snapshots?** No. Snapshot retention and other copies require separate handling.

## References and further reading

- [Delete by Query API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/delete-by-query-api) — API behavior, conflicts, and throttling.
- [Task management APIs](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-tasks) — monitor or cancel long-running tasks.
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — manage retained backups.
- [Segment merging](https://www.elastic.co/docs/reference/elasticsearch/index-settings/merge) — physical cleanup of deleted documents.
- [Index lifecycle management](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management) — automate retention.
- Persian discovery search (not a verified article): [Persian Delete by Query tutorials](https://www.google.com/search?q=Elasticsearch+delete_by_query+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

