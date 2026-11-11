# Rollover Policies

> Chapter 07: Analysis, Analytics, and Production · Lesson 33

[Read the Persian version](README.md)

## Learning goals

- Rotate the write target to a new backing index when configured conditions are met.
- Use a write alias or data stream as the stable write target.
- Choose rollover thresholds from shard sizing and workload data.

## Keep the active index bounded

Rollover creates a new index and moves the write target when conditions such as maximum age, document count, or primary-shard size are met. The write target is commonly a data stream or an alias marked as the write index. Older indices remain available for search and can be managed by ILM.

~~~http
POST /events-write/_rollover
{"conditions":{"max_primary_shard_size":"50gb","max_age":"30d"}}
~~~

These thresholds are examples, not universal recommendations. Measure shard size, indexing rate, search pattern, recovery time, and retention. An overly small threshold can create many small shards; an overly large index can slow recovery and relocation. Verify the new generation, write alias, and template after rollover. ILM can automate rollover, while a manual rollover is useful for testing or operator-controlled transitions.

## Exercise

Create a write alias for a disposable time-series index, add a rollover condition, and trigger a lab rollover. Confirm the new index name, alias write flag, and shard sizes. Explain how ILM would continue moving older indices through retention phases.

## Quiz with answers

1. **What does rollover change?** The active write target changes to a new index.
2. **What can trigger rollover?** Age, document count, or primary-shard size conditions, among others.
3. **Where does a stable application write name come from?** A write alias or data stream.
4. **What is the risk of overly small rollover thresholds?** Shard sprawl and extra cluster overhead.

## References and further reading

- [ILM rollover action](https://www.elastic.co/docs/reference/elasticsearch/index-lifecycle-actions/ilm-rollover) — configure conditions.
- [Rollover API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-rollover) — manual rollover behavior.
- [Data streams](https://www.elastic.co/docs/manage-data/data-store/data-streams) — time-series write target model.
- [Index aliases](https://www.elastic.co/docs/manage-data/data-store/aliases) — write alias behavior.
- [Shard sizing](https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/size-shards) — choose thresholds by evidence.
- Persian discovery search (not a verified article): [Persian Elasticsearch rollover and ILM articles](https://www.google.com/search?q=Elasticsearch+rollover+ILM+%D9%85%D9%82%D8%A7%D9%84%D9%87+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

