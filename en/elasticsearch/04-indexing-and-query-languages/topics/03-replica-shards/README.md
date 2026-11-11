# Replica Shards

> Chapter 04: Indexing and Query Languages · Lesson 03

[Read the Persian version](../../../../../fa/elasticsearch/04-indexing-and-query-languages/topics/03-replica-shards/README.md)

## Learning goals

- Explain what a replica shard copies and how it can help availability.
- Understand why replicas must be allocated separately from their primaries.
- Distinguish replicas from backups and identify their resource cost.

## Redundancy and read capacity

A replica shard is a copy of a primary shard. It is normally allocated to a different eligible node. If a primary's node fails, an in-sync replica can be promoted. Search requests may also be served by either a primary or replica copy, depending on routing and workload. Writes are coordinated through the primary and replicated to copies according to the configured durability behavior.

~~~http
PUT /products-v1/_settings
{"index":{"number_of_replicas":1}}

GET /_cat/shards/products-v1?v
~~~

More replicas increase storage consumption and replication traffic. They can improve resilience and may add read capacity, but they do not guarantee lower latency. If only one node is available, a replica cannot be allocated alongside its primary, so the index can remain yellow. Verify shard placement and the cluster's failure-domain design rather than counting replica settings alone.

A replica is not a backup. A mistaken delete, logical corruption, or bad update can affect both primary and replica. Backups require snapshots in a repository and a tested restore path. Set replica counts to meet availability requirements and available capacity; a zero-replica configuration is generally only acceptable for disposable local experiments.

## Exercise

Create a two-node lab index with one replica. Inspect where each primary and replica is allocated. Simulate loss of the node holding one primary and observe promotion and recovery. Then explain what a snapshot protects that replicas do not.

## Quiz with answers

1. **What does a replica provide?** A copy that can help tolerate node failure and can serve some searches.
2. **Why must the replica be on another node from its primary?** A single-node failure should not remove both copies of the same shard.
3. **Is a replica a backup?** No. It mirrors current logical changes and deletions; snapshots provide a separate recovery mechanism.
4. **What does yellow health often mean in a single-node lab with one replica?** Primaries are allocated, but replicas cannot be placed on the same node.

## References and further reading

- [Configure index replicas](https://www.elastic.co/docs/reference/elasticsearch/index-settings/index-modules) — index-level replication settings.
- [Nodes and shards](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards) — primary and replica allocation.
- [Cluster health API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-health) — health state and unassigned copies.
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — independent backup and recovery.
- [Shard sizing and distribution](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — capacity and allocation guidance.
- Persian discovery search (not a verified article): [Persian tutorials about Elasticsearch replicas and snapshots](https://www.google.com/search?q=Elasticsearch+replica+snapshot+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

