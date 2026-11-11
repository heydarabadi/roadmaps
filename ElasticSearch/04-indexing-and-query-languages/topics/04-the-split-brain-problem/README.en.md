# The “Split Brain” Problem

> Chapter 04: Indexing and Query Languages · Lesson 04

[Read the Persian version](README.md)

## Learning goals

- Describe how a network partition can isolate nodes from one another.
- Understand why modern Elasticsearch uses cluster coordination and quorum-based elections.
- Avoid applying obsolete pre-7.x master settings to current releases.

## Partition, quorum, and safe leadership

A network partition can divide a cluster so some nodes cannot communicate with others. In an unsafe design, both sides might accept leadership and make conflicting cluster-state decisions. This is the split-brain failure mode. Modern Elasticsearch uses cluster coordination and voting configurations so only a side that can form a quorum elects a master. Nodes without a valid elected master cannot continue making independent cluster-state changes as though they were a separate healthy cluster.

~~~http
GET /_cat/nodes?v&h=name,roles,master
GET /_cluster/health?pretty
~~~

These APIs show the cluster view observed by the node you contacted; they do not prove that the network is healthy or that all clients see the same path. Investigate election logs, discovery and network settings, node reachability, voting configuration, and version-specific guidance. Do not copy historical `minimum_master_nodes` instructions into a modern cluster. Likewise, do not delete data paths or manually alter cluster metadata to “fix” a partition; that can cause data loss.

Plan the number and placement of master-eligible nodes across failure domains, keep versions and discovery configuration consistent, and monitor cluster coordination. Test fault behavior only in an isolated lab and follow a documented chaos-testing plan.

## Exercise

On an isolated multi-node lab, review master-eligible nodes and election logs. Draw which nodes can form the voting majority after one node or one zone becomes unreachable. Explain why a client-side timeout alone cannot tell you which side has a valid master.

## Quiz with answers

1. **What is split brain?** Multiple isolated parts behave as independently authoritative leaders and can diverge.
2. **What protects modern clusters from this mode?** Cluster coordination and quorum-based voting for master election.
3. **Should modern operators set `minimum_master_nodes`?** No; that is legacy guidance and should not be applied to modern versions.
4. **Why are status APIs not enough to diagnose a partition?** They report the view of one contacted node and may not reveal connectivity on every path.

## References and further reading

- [Cluster formation and coordination](https://www.elastic.co/docs/deploy-manage/distributed-architecture/discovery-cluster-formation) — current discovery and election design.
- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles) — master-eligible responsibilities.
- [Cluster coordination](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-quorums.html) — quorum and voting concepts; check version notes.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — availability and operational planning.
- Persian discovery search (not a verified article): [Persian articles about Elasticsearch split brain and quorum](https://www.google.com/search?q=Elasticsearch+split+brain+quorum+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

