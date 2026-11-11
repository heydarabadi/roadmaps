# Cloud Data Patterns

[فارسی](../../../09-cloud-design-patterns/26-cloud-data-patterns/README.md)

## Learning goals

- Summarize patterns for source data, read models, files, and caching.
- Explain the operational implications of derived data.
- Choose sharding or event sourcing only when their requirements are real.
- Secure direct object access and public static content.

## Central idea

Data patterns improve query access or separate responsibilities by trading off derived copies, freshness, consistency, and operational work.

## Topic coverage

This chapter groups Valet Key, Static Content Hosting, Sharding, Materialized View, Index Table, Event Sourcing, CQRS, and Cache-Aside. Each is explained in full in [Data Management Patterns](../../05-data-and-caching/18-data-patterns/README.md); this page connects them to cloud architecture decisions.

### One source of truth, multiple read models

A service may have one authoritative order record and several derived views for a feed, report, or search. The source of truth enforces business invariants. Read models update from an event or outbox and can lag.

The API should specify which reads need read-your-writes behavior and which can accept stale data. Version, rebuild, and reconcile every projection.

### Sharding and key selection

Sharding increases storage or write capacity by distributing data. Choose a key that balances load and supports important queries.

Range keys simplify range queries but can concentrate current writes on one partition. Hashing distributes values but makes range scans harder. Tenant, user, and compound keys depend on the actual workload. Before implementation, write a plan for migration, rebalancing, cross-shard queries, and failure recovery.

### Materialized views and index tables

A materialized view stores query or aggregation results ahead of time; an index table supports a secondary lookup. A write must update all models atomically or publish a durable event/outbox and accept lag.

The view needs a rebuild path. If it is corrupted or misses events, replay the source with a versioned projection. Build views for measured queries, not every query that might exist someday.

### CQRS and event sourcing

CQRS separates command and read models. The read side can be denormalized and optimized for query. It adds eventual consistency and more models to operate.

Event sourcing stores domain changes as an append-only event history instead of only the latest state. Audit and replay can be valuable, but event schemas, ordering, idempotent consumers, and retention must be planned. The two patterns are independent. Ordinary CRUD may not benefit from either.

### Cache-aside

On a cache miss, the application loads from the source and stores the result with TTL or a version. On update, invalidate the key, create a new version, or refresh the derived model. Cache only when hit rate, miss cost, and freshness justify it. Tenant-specific data needs tenant-aware keys to prevent leakage.

### Valet key and static hosting

A valet key, such as a signed URL, grants a client limited and temporary access to an object. Restrict object, action, expiration, and size. Validate content type and ownership after upload.

Static hosting serves public, versioned files from object storage or a CDN so application compute handles API and business logic. Keep private objects out of public URLs and shared caches.

## Pattern decision table

| Pattern | Input needed | Important cost |
| --- | --- | --- |
| Sharding | Data size/rate, key, and query profile | Rebalancing and cross-shard queries |
| Materialized view/index table | Expensive repeated query | Lag, rebuild, storage, and write amplification |
| CQRS | Different read/write needs | Projection and eventual consistency |
| Event sourcing | Real audit or replay requirement | Schema evolution and replay complexity |
| Cache-aside | Hit rate and freshness target | Invalidation and stampede handling |
| Valet key/static hosting | Direct file delivery requirement | Authorization, expiry, and cache policy |

## Worked example

Keep an immutable invoice in object storage, metadata in a database, and give the authorized customer a short-lived signed link. Verify the object owner and content after upload.

## Common pitfalls

- Serving a stale projection without exposing its lag.
- Creating an unversioned event format.
- Choosing a shard key that creates a hot partition.
- Issuing permanent or broad-scope signed URLs.
- Caching tenant data without a tenant dimension.
- Introducing event sourcing for a simple CRUD requirement.

## Short quiz

1. Does CQRS require event sourcing?
2. What can a poor shard key cause?
3. What restrictions should a valet key use?
4. What operational capability does a derived view need?

### Answer key

1. No. CQRS separates read and write models; event sourcing stores the event history as truth.
2. Hot partitions, unbalanced capacity, and expensive cross-shard queries.
3. Limited object and action, owner/tenant scope, and short expiration.
4. Lag monitoring, replay or rebuild, and reconciliation with the source of truth.

## Exercise

Design an order-history projection and an invoice download flow. Define event source, ordering, lag and rebuild for the projection. For the file, specify authorization, URL scope and expiry, content validation, storage, and audit trail.

## Summary

Cloud data patterns add optimized read paths and file-delivery options, but their derived data and permissions need clear ownership. Design freshness, replay, authorization, and recovery together.

## Further reading

- [Azure CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) — command/query model trade-offs.
- [Azure Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing) — event history, projections, and replay.
- [Azure Cache-Aside pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cache-aside) — cache behavior and invalidation.
- [Azure Valet Key pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/valet-key) — constrained direct object access.
- [AWS Prescriptive Guidance: Cloud design patterns (PDF)](https://docs.aws.amazon.com/pdfs/prescriptive-guidance/latest/cloud-design-patterns/cloud-design-patterns.pdf) — cloud data and integration patterns.
- [Martin Fowler: Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — event history and state reconstruction.
