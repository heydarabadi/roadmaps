# Sharding, Scaling, and Tuning

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/05-reliability/sharding-scaling/README.md).

> **Learning goal:** Decide when horizontal partitioning is justified and evaluate shard keys against distribution and query routing.

## Sharded-cluster components

Sharding distributes a collection's data across shards. Each shard is commonly a replica set; config servers store cluster metadata; and `mongos` routes client operations to the relevant shard or shards. Applications should connect through the router, not directly to an individual shard.

## Design the shard key

A useful shard key needs:

- Enough distinct values to distribute data.
- A distribution that avoids overloaded values and hot spots.
- Alignment with common filters so queries can target a small number of shards.
- Write distribution appropriate to the rate and shape of new data.
- A path for growth and future shard-key refinement or resharding when supported.

Range-based sharding preserves locality and can help range queries, but a monotonically increasing key may direct all new writes to a hot range. Hashed sharding can distribute keys more evenly, but a range query may touch many shards. Tenant-based keys can target tenant queries but a very large tenant may become skewed. No key is universally best.

## Prove need before adding complexity

1. Inspect slow queries and `explain()`.
2. Improve the schema, indexes, and query shapes.
3. Measure CPU, memory, cache, disk I/O, and network.
4. Compare vertical scaling, archival, and workload separation.
5. Estimate data and throughput growth.
6. Model candidate shard keys against actual cardinality, skew, and query routing.
7. Test on representative data and failure scenarios.

Sharding adds routing, balancing, backup, migration, and troubleshooting complexity. Do not shard just because it sounds future-proof; also do not wait until a hot spot or capacity limit makes a key migration urgent.

## Example shell command

~~~javascript
// Educational shape only: select a key after workload analysis.
sh.shardCollection("shop.orders", { tenantId: 1, orderId: 1 })
~~~

Verify required indexes and collection state for the target server version before using a command in a real cluster.

## Customer examples: Bazaarvoice and Coinbase

MongoDB's Bazaarvoice story reports that the team exhausted vertical-scaling options and then grouped retailer data so common queries could target a shard. The design lesson is to connect key distribution with query locality. The reported performance figures are customer/vendor claims, not independent benchmarks. [Bazaarvoice story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)

The Coinbase story describes forecasting traffic and reducing cluster scaling time; it presents sharding as a later consideration after vertical-scale limits. This is a useful example of capacity automation before adding sharding complexity. The account is customer/vendor-published. [Coinbase story](https://www.mongodb.com/solutions/customer-case-studies/coinbase)

## Tuning discipline

Record a baseline, form one hypothesis, change one setting or index at a time, and keep a rollback plan. Monitor p95/p99, CPU, memory, disk latency, connections, replication lag, and fan-out. Atlas and self-managed deployments expose different tuning controls; verify current guidance before changing parameters.

## Common mistakes

- Sharding before showing a capacity or throughput need.
- Choosing a low-cardinality or skewed key.
- Using a monotonically increasing range key without addressing hot writes.
- Hashing a key without considering range-query scatter.
- Connecting the application to a shard instead of `mongos`.
- Changing many tuning variables without a baseline.

## Exercises

1. Score three candidate keys for a multi-tenant orders collection.
2. Identify which queries become targeted and which become scatter/gather.
3. List evidence that would justify vertical scaling versus sharding.

## Quiz and answer key

1. **What is `mongos`?** A router that directs operations to the appropriate shard or shards.
2. **What does the shard key influence?** Data distribution and query routing.
3. **What is a potential benefit of a hashed key?** More even distribution across key values.
4. **Why avoid sharding before proving a need?** It adds operational complexity; a poor key can skew data and make queries fan out.
5. **Applied task: score candidate keys.** Compare cardinality, value frequency, write hotspots, query targeting, growth, and migration options with representative data.
6. **What is one benefit of ranged keys?** Locality and some range-query support.
7. **What is one cost of hashed keys?** Range queries may touch many shards.
8. **How can a tenant key fail?** A very large or hot tenant may overload one shard.
9. **What should happen before choosing a key?** Measure query patterns, skew, and capacity on actual data.
10. **Why tune one change at a time?** It helps attribute effects and retain a safe rollback.

## Further reading

- [Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Choose a Shard Key](https://www.mongodb.com/docs/manual/core/sharding-choose-a-shard-key/)
- [Shard Key Indexes](https://www.mongodb.com/docs/manual/core/sharding-shard-key/)
- [Hashed Sharding](https://www.mongodb.com/docs/manual/core/hashed-sharding/)
- [Production Notes](https://www.mongodb.com/docs/manual/administration/production-notes/)
- [Bazaarvoice customer story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)
- [Coinbase customer story](https://www.mongodb.com/solutions/customer-case-studies/coinbase)
- [Persian sharding guide — Urhoba](https://www.urhoba.net/fa/post/sharding-mongodb)
- [Curated reference library: sharding and scale](../../reference-library.md#reliability-sharding)

---
Sources reviewed: 2026-11-11. Shard-key and scaling capabilities change across MongoDB versions.
