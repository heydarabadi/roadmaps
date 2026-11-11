<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/04-databases/11-sharding/README.md) · English

# Sharding — Distributing Data Ownership Across Nodes

**Learning goal:** Choose a shard key from access patterns, detect hotspots and cross-shard queries, and account for data-movement costs before adopting the design. Sources were checked on 2026-11-10; the conceptual example was completed and link-checked on 2026-11-11. It was not executed.

## Mental model

Sharding divides data across independent databases or node groups; each shard owns a subset. A replica copies the same subset. Partitioning a table inside one database does not necessarily create multiple independent servers. PostgreSQL’s native partitioning is not by itself a distributed sharding system.

| Method | Benefit | Risk |
| --- | --- | --- |
| Range, such as time ranges | locality and range scans | newest range may become hot |
| Hash of a key | often distributes data more evenly | range queries and a hot tenant remain difficult |
| Directory or lookup | tenants can move flexibly | routing map is a critical dependency |

A suitable key should appear in common queries, make ownership clear, and distribute load appropriately. High cardinality does not guarantee even traffic: one tenant among millions can generate most requests. Smaller row counts per shard do not automatically fix a hot key.

## Prerequisites and key selection

A shard key routes a request to an owner. Cardinality is the number of distinct values; it does not measure request balance. A directory maps tenant to shard. An epoch is a version of ownership that helps reject a stale route during movement.

## Use and trade-offs

Consider sharding when a single node’s storage/write capacity or operational limits remain inadequate after query improvements, suitable scale-up, and replicas. For a small service or many global queries, routing, joins, transactions, schema changes, and operations may outweigh the benefit. A global report may need fan-out and merging or a separate analytics system. Every shard also needs backup, monitoring, and schema updates.

## Worked example

In a hypothetical multi-tenant store where most orders are queried by tenant, a directory locates the tenant’s owner. Keep an order and its items on the same shard so the transaction can stay local:

~~~text
route = directory.lookup(tenant_id)  # shard_id and ownership epoch
database = connect_to(route.shard_id)
assert database.accepts(tenant_id, route.epoch)
database.execute(
  "SELECT id, total FROM orders WHERE tenant_id = ? AND id = ?",
  [tenant_id, order_id]
)
~~~

An epoch helps detect writes using an old map; it is not a complete migration algorithm. Movement needs an initial copy, capture of concurrent changes, reconciliation, a cutover that prevents two writers, and a rollback plan. Changing N in hash(key) modulo N moves many keys; do not change N without migration and versioned routing. Global identifiers also need an explicit policy such as a composite key or UUID.

## Worked exercise

On paper, distribute 10 tenants with load shares 50, 10, 8, 7, 6, 5, 4, 4, 3, 3 percent across three shards. Add the load for each shard; then put the first tenant alone on a shard.

**Worked solution:** The shares total 100%. One possible initial three-shard placement is `50+3=53`, `10+8+7=25`, and `6+5+4+4+3=22`. The largest tenant shares its first shard with one small tenant. A possible four-shard placement that isolates it is `50`, then `10+7=17`, `8+6+3=17`, and `5+4+4+3=16`. The remaining tenants are rearranged as well as adding a shard. The hot tenant still drives 50% of all traffic; isolation avoids sharing its shard but does not divide that tenant’s work. Splitting it further may help but can complicate its transactions and queries. A global sales report now fans out to shards and merges results; it is no longer a direct one-shard query.

## Evidence: Discord message storage

Discord’s 2023 first-party engineering report describes message partitions by channel and time bucket becoming hot under skewed traffic. Its team used a data service, request coalescing, and routing to reduce pressure and also migrated its storage engine. The lesson is that data distribution alone does not control concurrency on a hot key. Its Cassandra/ScyllaDB choices do not transfer directly to a SQL store.

## Troubleshooting and checklist

A healthy cluster average can hide one saturated shard. Inspect load, data size, and tail latency per shard. A stale routing map, partial dual-write, missing tenant predicate, duplicate ID, or stalled migration can break correctness. Cross-shard requests need a deadline and fan-out budget.

- [ ] Measure a single-node bottleneck and assess simpler options first.
- [ ] Choose the shard key from real queries and load distribution.
- [ ] Design local and cross-shard transactions, joins, and global reports.
- [ ] Version routing and make write ownership during cutover explicit.
- [ ] Exercise movement, reconciliation, rollback, and schema migration.
- [ ] Monitor skew, hot keys, and each shard separately.

If many tenants exist but one shard has high p99 or queue depth, compare request and data distribution per shard and identify the busiest tenants. During migration, check current owner and epoch; order initial copy, concurrent changes, reconciliation, controlled writes, and cutover. Treat a change to hash modulo N as a broad key migration, not a free setting change.

## Self-check

1. Why may adding a replica not solve primary write capacity?
2. Does a large number of tenants guarantee even load?
3. Why might tenant be a candidate shard key?
4. What is the danger of directly changing N in hash(key) modulo N?
5. Why is write ownership important during movement?

### Answers with reasoning

1. A replica copies changes; sharding distributes write ownership over subsets.
2. No. Traffic or data can be skewed and one key can stay hot.
3. Frequent tenant-scoped queries can route to one shard; a very large tenant still needs separate analysis.
4. Many keys move, so data and routing can disagree unless migration is designed.
5. Two writers or old routes can conflict; cutover needs one clear owner.

## Optional further reading

The lesson includes the key, placement, and migration concepts. These links are optional and specific to their systems.

- Persian: [Introductory NoSQL concepts](https://dntips.ir/www.dntips.ir-posts-1472.html) introduces sharding vocabulary; it is an older primer, not current cluster setup guidance.
- English, first-party case: [Discord: How Discord stores trillions of messages](https://discord.com/blog/how-discord-stores-trillions-of-messages) discusses hot partitions and request control in Discord’s system.
- English, official: [PostgreSQL table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html) helps distinguish local table partitions from distributed sharding.
- English, official: [Azure sharding pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/sharding) covers key choice, routing, and cross-shard limits.
- English, official: [Citus data modeling](https://docs.citusdata.com/en/stable/sharding/data_modeling.html) explains distribution-column choices and co-location for its PostgreSQL extension.
- English, official: [MongoDB sharding](https://www.mongodb.com/docs/manual/sharding/) documents shard keys and targeted versus scatter/gather queries for MongoDB.

**Navigation:** [Database chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Replication](../10-replication/README.en.md) · [Next: Profiling](../12-database-profiling/README.en.md) · [Scaling](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.en.md) · [Cache stampede](../../01-caching/04-invalidation-and-freshness/README.en.md)

</div>
