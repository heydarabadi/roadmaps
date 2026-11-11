# Data Nodes

> Chapter 03: Data Types and Node Roles · Lesson 03

[Read the Persian version](../../../../../fa/elasticsearch/03-data-types-and-node-roles/topics/03-data-nodes/README.md)

## Learning goals

- Explain how data nodes host shard copies and perform indexing and search work.
- Identify the resources that commonly limit a data node.
- Understand how replicas, disk, and shard placement affect capacity and availability.

## Storage and query work

Data nodes host primary and replica shards. They execute much of the indexing and search work against those shards, so their CPU, memory, storage, and network capacity matter. Search requests can fan out across multiple shards and data nodes; writes route to a primary shard and are replicated as configured. A node's available capacity is not only disk space: heap pressure, filesystem cache, I/O latency, CPU, network, and concurrent work all affect performance.

~~~http
GET /_cat/nodes?v&h=name,roles,heap.percent,cpu,disk.used_percent
GET /_cat/shards?v
~~~

Adding data nodes may allow shard allocation to spread and provide more resources, but only if the index layout, allocation rules, and available replicas permit it. A hot shard can remain a bottleneck even when total cluster capacity looks healthy. Monitor rejected tasks, indexing and search latency, disk watermarks, recovery progress, and shard balance. Before adding capacity, reproduce the production query and ingest mix and identify the constrained resource.

## Exercise

Index a modest test dataset, inspect where its shards are allocated, and compare search latency as the number of concurrent requests changes. Note whether CPU, heap, disk, or thread-pool rejections move with latency. Explain whether another data node would address the measured constraint.

## Quiz with answers

1. **What does a data node host?** Shard copies that contain Lucene index data.
2. **Which work does it perform?** Indexing and search operations on its shards, plus storage and recovery work.
3. **Why might adding a node have no effect on one slow query?** Routing, hot shards, insufficient replicas, or an inefficient query can prevent the workload from using new capacity.
4. **Name four data-node signals to monitor.** CPU, heap and garbage collection, filesystem or disk latency, network, rejections, and shard distribution are examples.

## References and further reading

- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles) — data-node responsibilities.
- [Nodes and shards](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards) — placement and distribution.
- [Node stats API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-nodes-stats) — detailed resource and operation statistics.
- [Shard sizing guidance](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — balance shard count and size.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — broader capacity practices.


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

