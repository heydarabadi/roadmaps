# Data Management Patterns

[فارسی](../../../../fa/system-design/05-data-and-caching/18-data-patterns/README.md)

## Learning goals

- Explain the problems sharding, materialized views, CQRS, and event sourcing address.
- Distinguish the CQRS pattern from event sourcing.
- Design access to object storage with limited credentials.
- Identify freshness and rebuild responsibilities for derived data.

## Central idea

Data patterns can improve read speed or separate workloads, but they introduce derived copies, eventual consistency, and synchronization work.

## Concept map

Source of truth → partition or projection → query/write model → asynchronous update → lag, rebuild, and authorization.

## Detailed lesson and pattern review

### Sharding

Sharding distributes data among partitions by a shard key. The key should support frequent queries and distribute load. A user ID may work for a user's inbox but not for a query across all events in the last hour. A time-based key can send every current write to one hot partition.

Hash and range partitioning, virtual nodes, and rebalancing have different trade-offs. Before sharding, evaluate indexes, query shape, caching, and vertical scaling. Moving existing data between shards can be expensive and disruptive.

### Materialized views and index tables

A materialized view stores a result of joins or aggregation so repeated reads can be fast. It needs updates from source changes, a version or offset, and visibility into projection lag.

An index table adds a derived lookup path. Writes must update the source and index together or use an outbox/eventually consistent workflow. If the view diverges from its source, define how to rebuild and reconcile it.

### CQRS

The command model validates and records changes. The query model is shaped for reads and can use a different schema or datastore. CQRS can optimize read and write workloads separately, but adds projections, versioning, consistency lag, and debugging work.

CQRS does not require two physical databases and does not imply event sourcing. If an application is simple CRUD, a single model is usually easier to maintain.

### Event sourcing

Instead of overwriting current state, event sourcing appends domain events such as OrderPlaced, PaymentCaptured, or OrderCancelled. The current state is reconstructed by replaying events or loading a snapshot and applying later events.

The event history can support audit and reconstruction. The system must version event schemas, keep events immutable, make consumers idempotent, and control replay. A domain event is not just a technical log record; its name and meaning should match the business vocabulary.

Erasing or correcting personal data also needs legal and product policy. “Immutable history” does not remove privacy obligations.

### Cache-aside

The application reads the cache first. On a miss it reads the source and fills the cache with a TTL or version. A source update can invalidate the key or publish a new version.

Invalidating a key alone does not prevent an in-flight request from writing an older value back into the cache. Consider versions, fencing, or a stale-while-revalidate policy.

### Valet key and static content hosting

A valet key is a signed, constrained URL or token that allows direct access to object storage. Limit it to one object and one action, give it a short expiration, and validate owner, content type, and size after upload.

Static content hosting moves public, versioned files away from application compute. A CDN can serve them from edge locations. Private files must not be published under public URLs or shared cache keys.

### Choose the pattern from the requirement

| Need | Possible pattern | Hard question |
| --- | --- | --- |
| Repeated expensive read query | Materialized view or index table | How is lag monitored and the view rebuilt? |
| Data exceeds one node's storage or write capacity | Sharding | What is the shard key and hot-partition risk? |
| Audit history or state reconstruction is valuable | Event sourcing | How will event schema and retention evolve? |
| Read and write models have different needs | CQRS | What projection lag and operational cost are acceptable? |
| Client transfers a large object | Valet key and object storage | Where are authorization and expiry enforced? |

## Worked example

Store an invoice PDF as an object in object storage and store its metadata in a relational database. Give the client a short-lived signed URL scoped to a single object and operation. Keep an authorization check before issuing the URL and verify the uploaded file after receipt.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| CQRS | Read and write workloads need substantially different models | Projection lag and duplicated models increase complexity |
| Sharding | A measured capacity boundary exceeds one node | Hot keys, cross-shard queries, and rebalancing |
| Event sourcing | Reconstructable business history has real value | Event versioning, replay, and data-retention obligations |
| Valet key | A client can transfer a large object directly and securely | Long-lived or over-scoped credentials expose data |

## Common pitfalls

- Reading from a projection without tracking its lag.
- Changing an event schema without versioning consumers.
- Creating a hot shard from a skewed key.
- Using an unbounded or permanent signed URL.
- Treating CQRS as synonymous with event sourcing.
- Adding a complex pattern to a simple CRUD workload.

## Short quiz

1. How does CQRS differ from event sourcing?
2. What happens when a shard key is highly skewed?
3. What constraints should a valet key have?
4. Why does a materialized view need a rebuild strategy?

### Answer key

1. CQRS separates command and query models; event sourcing stores the change history as the source of truth. They can be used separately.
2. One partition receives disproportionate traffic and becomes a hot spot.
3. Specific object, allowed operation, short expiry, and limits on size/content or tenant scope.
4. It is derived data and can become incomplete or inconsistent after missed events or processing failure.

## Exercise

Design a product search projection and invoice upload flow. For the projection, state source, event, ordering, lag, and rebuild method. For the upload, define authorization, signed URL scope/expiry, validation, storage, and audit data.

## Summary

Data patterns create useful access paths or histories by adding derived data and asynchronous work. Choose them for a measured need, then specify freshness, conflict handling, recovery, and security.

## Further reading

- [Azure CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs) — when and how to separate reads and writes.
- [Azure Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing) — event history, projection, and trade-offs.
- [Martin Fowler: Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — concept and design considerations.
- [microservices.io: Transactional Outbox](https://microservices.io/patterns/data/transactional-outbox.html) — reliable event publication from a database transaction.
- [AWS: Database sharding](https://docs.aws.amazon.com/whitepapers/latest/database-caching-strategies-using-redis/sharding.html) — partitioning and sharding considerations.
- [AWS: Prescriptive design patterns](https://docs.aws.amazon.com/pdfs/prescriptive-guidance/latest/cloud-design-patterns/cloud-design-patterns.pdf) — architecture patterns across data and messaging.
