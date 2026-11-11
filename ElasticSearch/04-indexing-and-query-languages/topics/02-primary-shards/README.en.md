# Primary Shards

> Chapter 04: Indexing and Query Languages · Lesson 02

[Read the Persian version](README.md)

## Learning goals

- Explain why Elasticsearch divides an index into primary shards.
- Understand document routing and the operational impact of shard count.
- Make an initial shard estimate and validate it with representative benchmarks.

## Shards divide an index

An index is split into primary shards. Each primary shard is an independent Lucene index that stores part of the index's documents. Elasticsearch routes a document to a shard using its routing value, which defaults to a hash of the document ID. Searches fan out to the shards that may contain matches. More shards can increase parallelism but also create extra metadata, file handles, heap work, coordination, and recovery overhead.

~~~http
PUT /events-v1
{"settings":{"number_of_shards":3,"number_of_replicas":1}}
~~~

The value `3` is an example, not a universal recommendation. Estimate from expected primary data size, growth, document count, query concurrency, and failure-recovery objectives. Too many tiny shards can be expensive; very large shards can make relocation and recovery slow. Current Elastic guidance gives broad shard-size ranges, but the right answer depends on workload, hardware, and operational constraints. Benchmark the same representative data and query/indexing load you expect in production.

The number of primary shards is fixed when an index is created in the ordinary case. Changing it usually means creating a new index and reindexing, or using a supported split/shrink operation with its prerequisites. Primary shards alone do not provide node-failure tolerance; replicas are separate copies.

## Exercise

Assume a dataset will reach 300 GB of primary data over six months. Propose a starting number of shards using a target shard size, then document the assumptions. Compare the estimate with a benchmark and a recovery-time target. Explain what you would change if the data grows twice as quickly.

## Quiz with answers

1. **What is a primary shard?** A partition of the index's data, implemented as a Lucene index and used for routing and shard-level operations.
2. **Why not create as many shards as possible?** Each shard has overhead, and searches must coordinate shard-level work.
3. **Why not use one enormous shard for everything?** Large shards can constrain parallelism and make recovery or relocation slower.
4. **How is primary shard count changed later?** Usually by creating a new index and reindexing or by a supported split/shrink workflow.

## References and further reading

- [Size your Elasticsearch shards](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — current sizing guidance and benchmark recommendations.
- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics) — shard and index model.
- [Reading and writing documents](https://www.elastic.co/docs/deploy-manage/distributed-architecture/reading-and-writing-documents) — routing and shard-level behavior.
- [Split an index](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-split) and [shrink an index](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-shrink) — supported shard-count changes.
- [Indexing-speed guidance](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/indexing-speed) — ingestion workload considerations.
- Persian discovery search (not a verified article): [Search Persian shard-sizing articles](https://www.google.com/search?q=Elasticsearch+shard+sizing+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

