# Master-Eligible Nodes

> Chapter 03: Data Types and Node Roles · Lesson 02

[Read the Persian version](../../../../../fa/elasticsearch/03-data-types-and-node-roles/topics/02-master-eligible-nodes/README.md)

## Learning goals

- Explain what it means for a node to be master-eligible.
- Distinguish an eligible node from the currently elected master.
- Understand why stable master coordination matters to the whole cluster.

## Eligibility and election

A master-eligible node is allowed to participate in the election for the cluster's master. The elected master coordinates cluster-state changes such as index creation, mapping updates, and shard allocation. It is not the node that must perform every application search or indexing request. Other nodes can serve those requests, while master coordination keeps the cluster's shared metadata consistent.

~~~http
GET /_cat/nodes?v&h=name,roles,master
GET /_cluster/health?pretty
~~~

Production topologies use an appropriate number and placement of master-eligible nodes across failure domains so the cluster can maintain quorum through expected failures. Do not treat a configured eligible node as an additional master; only one master is elected at a time. Avoid saturating master-focused nodes with expensive workloads when role separation is part of the design. A lab may combine roles, but production needs failure and recovery planning.

Investigate cluster instability through logs, master election events, cluster-state update queues, network partitions, and resource pressure. Restarting nodes blindly can worsen a coordination incident. Follow official recovery guidance for the exact cluster state and version.

## Exercise

Inspect the roles and master flag on a lab cluster. Draw which nodes can participate in an election and which node is currently master. Describe what happens to cluster coordination if the elected master process fails and another eligible node remains available.

## Quiz with answers

1. **What does master-eligible mean?** The node can participate in the election for the cluster's master.
2. **Is every master-eligible node the master?** No. One master is elected at a time.
3. **What does the elected master coordinate?** Shared cluster state and metadata changes, including shard allocation decisions.
4. **Why are master-eligible nodes spread across failure domains?** To preserve the ability to form a quorum through expected node or zone failures.

## References and further reading

- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles) — master and other node roles.
- [Cluster coordination](https://www.elastic.co/docs/deploy-manage/distributed-architecture/discovery-cluster-formation/cluster-formation) — discovery and formation concepts.
- [Cluster health API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-health) — summary of cluster status.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — deployment and resiliency practices.
- Persian discovery search (not a verified article): [Focused search for Persian Elasticsearch master-node lessons](https://www.google.com/search?q=%D9%86%D9%88%D8%AF+%D9%85%D8%B3%D8%AA%D8%B1+Elasticsearch+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

