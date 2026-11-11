# Data Tiers

> Chapter 07: Analysis, Analytics, and Production · Lesson 34

[Read the Persian version](README.md)

## Learning goals

- Match data placement to access frequency, performance, and cost.
- Understand hot, warm, cold, and frozen tier trade-offs.
- Combine tiers with lifecycle policy and workload measurement.

## Place data by its use

Data tiers organize nodes or storage profiles around access patterns. Hot data commonly receives active indexing and frequent searches. Warm and cold data is accessed less often and can use lower-cost resources. Frozen data may rely on searchable snapshots where supported. Availability, performance, replica strategy, and cost differ across tiers and deployment types.

~~~text
new / frequently written data -> hot
less active historical data    -> warm or cold
long-retention, rare access   -> frozen/searchable snapshot where supported
~~~

ILM can migrate indices as they age. Validate that the deployment supports the tier behavior you intend, including searchable snapshots, and understand latency during a query across tiers. A tier's name does not guarantee a specific response time or storage cost. Monitor shard allocation, restore behavior, and the query mix. Avoid moving data to a lower tier before recovery and retention requirements are clear.

## Exercise

Design a 90-day log retention plan: recent logs are searched continuously, older logs are queried for investigations, and a subset must be retained longer. Map each age range to a tier, retention action, and expected latency. Verify the setup on the supported deployment type.

## Quiz with answers

1. **What drives data tier design?** Access pattern, performance expectations, retention, availability, and cost.
2. **Does cold storage perform like hot storage?** No; query latency and access characteristics can differ.
3. **How are tier transitions often automated?** Through ILM or the deployment's data lifecycle policy.
4. **What should be checked before relying on frozen data?** Deployment support, searchable snapshot behavior, recovery expectations, and latency.

## References and further reading

- [Data tiers](https://www.elastic.co/docs/manage-data/lifecycle/data-tiers) — tier roles and migration.
- [Index lifecycle management](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management) — transition policies.
- [Searchable snapshots](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/searchable-snapshots) — query snapshot-backed indices.
- [Shard allocation explain](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-allocation-explain) — diagnose placement.
- [Production guidance](https://www.elastic.co/docs/deploy-manage/production-guidance) — capacity and operations.
- Persian discovery search (not a verified article): [Persian Elasticsearch data-tier tutorials](https://www.google.com/search?q=Elasticsearch+data+tiers+%D9%84%D8%A7%DB%8C%D9%87+%D8%A8%D8%A7%D8%B2%DB%8C%D8%A7%D8%A8%DB%8C+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

