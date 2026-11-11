# Coordinating Nodes

> Chapter 03: Data Types and Node Roles · Lesson 04

[Read the Persian version](README.md)

## Learning goals

- Trace a search request from its coordinating node to shard-level work and back.
- Explain fan-out and reduction costs.
- Know when a dedicated coordinating role is justified.

## Fan-out and merge

Every Elasticsearch node can act as a coordinating node for requests it receives. A coordinating node parses the request, routes work to relevant shard copies, collects shard responses, reduces them into a final result, and returns it to the client. For a search across many shards, each shard produces local candidates; the coordinator merges and orders them. This makes coordination CPU, memory, network, and response size relevant to overall latency.

~~~text
client -> coordinating node -> shard copies on data nodes
       <- reduce/merge     <- local shard hits and aggregations
~~~

A dedicated coordinating-only node can isolate fan-out and reduction work in a larger cluster, but it adds infrastructure and traffic. It does not store shard data or replace data-node capacity. Small clusters often let data and master-eligible nodes coordinate requests too. Measure the incoming request mix, response size, shard fan-out, and coordinator resource use before separating this role.

Avoid broad searches that touch many indices or shards without a reason, large result windows, and enormous aggregation responses. Reducing unnecessary fan-out can help more than adding coordinators. Place coordinating nodes behind an application load balancer only when the deployment and client behavior are designed for it.

## Exercise

Run a search against one index and a second search spanning many indices. Compare request latency and coordinating-node statistics. Record how result size and aggregation complexity affect reduction cost.

## Quiz with answers

1. **What does a coordinating node do?** Routes work to shard copies and combines shard-level results.
2. **Are coordinating-only nodes required?** No. Every node can coordinate; a dedicated role is an isolation choice for measured workloads.
3. **What can make coordination expensive?** High shard fan-out, large result sets, heavy aggregations, and network or merge pressure.
4. **Does adding coordinators repair an overloaded data shard?** No. The shard's own work and placement must be addressed.

## References and further reading

- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles) — coordinating-only role and role combinations.
- [Reading and writing documents](https://www.elastic.co/docs/deploy-manage/distributed-architecture/reading-and-writing-documents) — coordinating operations.
- [Search API](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search) — search request behavior and options.
- [Size your shards](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — shard count and fan-out considerations.
- Persian discovery search (not a verified article): [Persian Elasticsearch coordinating-node articles](https://www.google.com/search?q=Elasticsearch+coordinating+node+%D9%86%D9%88%D8%AF+%D9%87%D9%85%D8%A7%D9%87%D9%86%DA%AF%E2%80%8C%DA%A9%D9%86%D9%86%D8%AF%D9%87).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

