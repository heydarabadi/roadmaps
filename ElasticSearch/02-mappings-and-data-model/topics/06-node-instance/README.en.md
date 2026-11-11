# Node (Instance)

> Chapter 02: Mappings and Data Modeling · Lesson 06

[Read the Persian version](README.md)

## Learning goals

- Distinguish an Elasticsearch node process from an index and a shard.
- Read basic node-level resource signals.
- Diagnose a bottleneck before adding nodes or changing heap settings.

## A node hosts work

A node is a running Elasticsearch process that joins one cluster. Its roles determine which responsibilities it can perform: for example, hosting data shards, coordinating requests, ingesting documents, or participating in master election. Small deployments often combine roles; larger clusters may separate roles to isolate resources and failure modes. The shard is the data/index unit placed on a node; the node is the process that runs the work.

~~~http
GET /_cat/nodes?v&h=name,roles,heap.percent,ram.percent,cpu,disk.used_percent
~~~

This snapshot can help identify a node with high heap, CPU, or disk use, but it is not sufficient for a diagnosis. Correlate it with node statistics, thread-pool rejections, search and indexing latency, garbage collection, shard distribution, and workload timing. Increasing the JVM heap without considering total machine memory can reduce the operating system's filesystem cache, which is valuable for Lucene search.

Before adding a node, identify the constrained resource and confirm the cluster can allocate shards to it. A new node may help capacity or failure tolerance, but it will not fix a poor mapping, expensive query, hot shard, slow storage, or ingestion bottleneck by itself. Master-eligible nodes should be placed and sized for stable cluster-state coordination; do not send large search workloads to a coordinating-only or master-focused node without a design reason.

## Exercise

Capture node and cluster statistics while running a small indexing workload and a search workload. Identify which signal changes most. State one action that would address the observed bottleneck and one action that would not.

## Quiz with answers

1. **What is the difference between a node and a shard?** A node is a running Elasticsearch instance; a shard is a Lucene index copy hosted on a node.
2. **What can a node failure mean for data availability?** It depends on shard replicas, their placement, remaining capacity, and cluster coordination state.
3. **Why can blindly increasing heap hurt search?** It leaves less memory for filesystem cache and may worsen I/O behavior.
4. **Should every performance issue be solved by adding a node?** No. First identify whether CPU, disk, heap, query design, shard distribution, or ingestion is the limiting factor.

## References and further reading

- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles) — assign node responsibilities.
- [Nodes and shards](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards) — how a cluster hosts data.
- [Cat nodes API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-nodes) — human-readable node summary.
- [Node stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-stats) — detailed JVM, filesystem, indexing, and search statistics.
- [Elasticsearch production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — resource and deployment considerations.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

