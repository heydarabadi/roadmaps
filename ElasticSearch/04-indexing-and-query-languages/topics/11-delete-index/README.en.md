# Delete an Index

> Chapter 04: Indexing and Query Languages · Lesson 11

[Read the Persian version](README.md)

## Learning goals

- Distinguish deleting an index from deleting one document or removing an alias.
- Verify dependencies and recovery options before a destructive operation.
- Avoid broad wildcard deletion.

## A destructive operation

Deleting an index removes the index resource, its mappings, settings, and documents. This is different from deleting one document or removing an alias. It is not an ordinary way to change a mapping. Use a versioned replacement index and alias cutover when the schema must change.

~~~http
DELETE /products-sandbox-v1
~~~

Before deletion, identify the active cluster, exact index name, aliases and data streams that depend on it, the owner, retention policy, and any snapshot or rebuild source. Avoid wildcard targets unless the operation is explicitly reviewed and supported by a runbook. A safeguard such as requiring explicit names can reduce accidents, but does not replace verification. A snapshot is useful only if it can be restored; test the restore procedure and confirm recovery meets requirements.

In production, deletion can also have legal and compliance implications. Determine whether related copies in snapshots, downstream systems, or external stores have separate retention rules. Do not execute destructive commands on a production system just to complete a learning exercise.

## Exercise

In a sandbox, create an index and an alias pointing to it. Inspect both, then remove the alias and compare that effect with deleting the backing index. Write a pre-delete checklist for a production index without executing the production command.

## Quiz with answers

1. **What does Delete Index remove?** The whole index and its data and metadata.
2. **Is deleting an index the same as deleting its alias?** No. Removing an alias changes a name reference; deleting the index removes the underlying resource.
3. **What should be confirmed before deletion?** Exact name and cluster, dependencies, ownership, retention, and recovery path.
4. **Does a successful snapshot guarantee recoverability?** No. Restore must be tested.

## References and further reading

- [Delete index API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-delete) — endpoint behavior.
- [Aliases](https://www.elastic.co/docs/manage-data/data-store/aliases) — remove or switch aliases without confusing them with indices.
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — recoverable snapshots and restore operations.
- [Index lifecycle management](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management) — automate retention and deletion policies.
- [Elasticsearch REST APIs](https://www.elastic.co/docs/reference/elasticsearch/rest-apis) — common API safety and request conventions.
- Persian discovery search (not a verified article): [Persian tutorials about deleting Elasticsearch indices](https://www.google.com/search?q=Elasticsearch+delete+index+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

