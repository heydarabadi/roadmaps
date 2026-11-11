# Cluster (System)

> Chapter 02: Mappings and Data Modeling · Lesson 05

[Read the Persian version](../../../../../fa/elasticsearch/02-mappings-and-data-model/topics/05-cluster-system/README.md)

## Learning goals

- Describe a cluster as a coordinated group of Elasticsearch nodes with shared cluster state.
- Interpret the main meanings of green, yellow, and red cluster health.
- Investigate shard allocation and capacity instead of inferring root cause from a color alone.

## Cluster state and health

An Elasticsearch cluster is a group of nodes that discover one another and coordinate work. Cluster state contains metadata such as node membership, index mappings and settings, and shard allocation. An elected master node coordinates state changes; data nodes host shard copies and execute data operations. A cluster can be small for a lab or distributed across fault domains for production.

~~~http
GET /_cluster/health?pretty
GET /_cat/nodes?v
GET /_cat/shards?v
~~~

Green means all primary and replica shards are allocated. Yellow means primaries are available but at least one replica is unassigned. Red means at least one primary shard is unavailable, so some indexed data or operations may be unavailable. Health is a summary, not a diagnosis. Use shard allocation explanations, node logs, disk watermarks, and capacity metrics to find why a shard is unassigned.

Production design considers node and zone failures, quorum for master-eligible nodes, replica placement, disk headroom, recovery time, and load. A single-node development cluster can be yellow if replicas cannot be allocated to another node; that is not equivalent to a resilient production topology. Avoid accidental node discovery across unrelated environments by configuring names and network boundaries carefully.

## Exercise

Create a lab index with a replica, inspect health on one node, then add another eligible node or adjust the lab configuration. Observe how shard allocation changes. For each state, record which data copies are active and what failure the topology can tolerate.

## Quiz with answers

1. **What does yellow health indicate?** Primaries are allocated, but one or more replicas are not.
2. **Does green health prove the service is healthy?** No. It says shard copies are allocated; latency, errors, saturation, correctness, and search quality need separate monitoring.
3. **What should you inspect after seeing an unassigned shard?** Allocation explain output, node and disk capacity, routing constraints, and logs.
4. **Why can one-node labs show yellow health?** A replica cannot be allocated to the same node as its primary, and there is no second node available.

## References and further reading

- [Cluster health API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-health) — health status and indicators.
- [Cluster architecture](https://www.elastic.co/docs/deploy-manage/distributed-architecture) — nodes, roles, shards, and coordination.
- [Nodes and shards](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards) — core distributed concepts.
- [Cluster allocation explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-allocation-explain) — why a shard is or is not allocated.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — operational sizing and reliability practices.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

