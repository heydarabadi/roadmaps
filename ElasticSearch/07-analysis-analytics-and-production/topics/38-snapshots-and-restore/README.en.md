# Snapshots and Restore

> Chapter 07: Analysis, Analytics, and Production · Lesson 38

[Read the Persian version](README.md)

## Learning goals

- Store snapshots in a registered repository outside the live cluster.
- Distinguish snapshots from replicas and reindexing.
- Prove recoverability with a restore drill and recovery objectives.

## Back up and restore

Snapshots capture indices, data streams, and supported cluster or feature state into a repository outside the cluster. They are incremental in the repository and do not require stopping the cluster for a full offline copy. Repository setup and supported options vary by deployment. Never manually edit repository contents; use the snapshot APIs.

~~~http
PUT /_snapshot/backup-repo
{"type":"fs","settings":{"location":"/mnt/es-backups"}}

POST /_snapshot/backup-repo/snapshot-2026-11-11?wait_for_completion=true
~~~

The filesystem repository is illustrative for a self-managed lab; production commonly uses supported shared or cloud storage. Verify repository access from all relevant nodes, restrict credentials and network paths, and record source and target versions. A successful snapshot is not proof of recovery. Restore into a separate target or controlled environment, verify indices and application behavior, and measure recovery time and data loss against RTO and RPO.

## Exercise

Create a lab repository, take a snapshot, remove a disposable index, and restore it in an isolated test. Verify document counts and mappings. Record the time taken and identify what would need adjustment for production security and storage.

## Quiz with answers

1. **Where are snapshots stored?** In a registered repository outside the live cluster's ordinary shard copies.
2. **Are snapshots the same as replicas?** No; replicas protect shard copies within a cluster, while snapshots provide recoverable backup state.
3. **How is snapshot success proven?** By regularly restoring and validating the data and application behavior.
4. **What are RPO and RTO?** Acceptable data-loss window and recovery-time objective.

## References and further reading

- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — repository and snapshot workflow.
- [Register a snapshot repository](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-create-repository) — repository configuration.
- [Verify repository API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-verify-repository) — check node access.
- [Restore from snapshot guide](https://www.elastic.co/docs/troubleshoot/elasticsearch/restore-from-snapshot) — recovery steps.
- [Snapshot status API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-status) — inspect running snapshots.
- Persian discovery search (not a verified article): [Persian Elasticsearch snapshot and restore articles](https://www.google.com/search?q=Elasticsearch+snapshot+restore+%D8%A8%D8%A7%D8%B2%DB%8C%D8%A7%D8%A8%DB%8C+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

