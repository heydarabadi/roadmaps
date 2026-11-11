# NoSQL Databases and Data Modeling

## Learning goals

- Distinguish key-value, document, wide-column, graph, and search-oriented stores.
- Choose a data model from access patterns and consistency requirements.
- Recognize partitioning, replication, hot keys, and operational trade-offs.

## Core idea

NoSQL is a family of storage models, not one database design and not a synonym for “more scalable.” Start from the operations the product must perform, then choose a store whose data model and consistency behavior fit those operations.

## Common models

- **Key-value:** retrieve a value by key; useful for sessions, caches, and simple lookups. Cross-key queries may be limited.
- **Document:** store an aggregate as a JSON-like document; useful when an application reads and updates a cohesive object. Duplicated data requires an update strategy.
- **Wide-column:** partitioned rows and column families support high-volume, known query patterns. Partition-key design and data distribution are central.
- **Graph:** nodes and edges make relationship traversal explicit, useful for social, fraud, and recommendation problems.
- **Search index:** optimized for text search and relevance, usually a derived view rather than the authoritative transaction record.

Relational and NoSQL systems can coexist. A relational database can be the source of truth while a search index and cache serve specialized queries. Every derived copy adds lag, repair, and ownership questions.

## Partitioning and consistency

Horizontal partitioning distributes data by a partition key. A poor key can create hot partitions: for example, every write to one celebrity account or one global counter lands on the same shard. Randomizing or bucketing keys spreads load but makes reads and aggregation more involved.

Replication improves availability and read capacity, but replicas can lag. The application must decide whether a read can be stale, whether read-after-write is required, and how conflicts are resolved. Quorum settings are not a universal guarantee of serializable transactions; understand the database's documented guarantees.

Model around aggregate boundaries: keep data that must be read and updated together together, but do not embed an unbounded history into one document. Define maximum size, write contention, and retention policy. TTL expiration is useful for ephemeral records but should not substitute for a retention and deletion policy.

## Worked example: product catalog

The product detail page needs a fast read of product attributes and variants. A document may fit that aggregate. Inventory reservation needs atomic conditional updates and auditable transactions; a relational store may remain the source of truth. Search facets and relevance may be served by a search engine that is rebuilt from events or change data capture. A single product therefore has different representations for different access patterns.

## Decision guide

Choose a NoSQL store when its operational model and access pattern are a strong match, the team understands its consistency and repair behavior, and the benefit justifies added complexity. Do not choose it only because a vendor advertises scale or because the schema might change.

## Self-check quiz

1. What does the phrase “NoSQL database” tell you about query capability? Very little; inspect the specific model and query language.
2. What is a hot partition? A key range or partition receiving disproportionate traffic and becoming a bottleneck.
3. Why is a search index usually not the source of truth? It is optimized and often asynchronously updated for search, with its own rebuild and consistency lifecycle.
4. What does denormalization cost? It introduces duplicated facts, synchronization work, and possible temporary inconsistency.
5. Why inspect consistency guarantees before design? They determine which user-visible states and recovery strategies are possible.

## Exercise

For product details, inventory reservations, and full-text search, select stores and define how updates propagate and how each derived representation is rebuilt.

### Sample answer

Keep authoritative product and inventory data in a transactional store unless measured needs justify otherwise. Publish committed changes through an outbox or change-data-capture pipeline. Update the search index asynchronously, track lag, and provide a replay/rebuild procedure. Cache product reads with an explicit invalidation or short staleness window; never use a cache as the authority for stock decrements.

## Further reading

- First-hand case: [Meta's TAO graph data service](https://engineering.fb.com/2013/06/25/core-infra/tao-the-power-of-the-graph/) shows how the data model and access patterns shaped a specialized distributed store.
- English: [Microsoft: Non-relational data](https://learn.microsoft.com/en-us/azure/architecture/data-guide/big-data/non-relational-data), [AWS: Choosing a database](https://docs.aws.amazon.com/decision-guides/latest/databases-on-aws-how-to-choose/databases-on-aws-how-to-choose.html), [MongoDB data modeling](https://www.mongodb.com/docs/manual/data-modeling/), [Apache Cassandra data modeling](https://cassandra.apache.org/doc/latest/cassandra/developing/data-modeling/intro.html), [Dynamo: Amazon's highly available key-value store paper](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf), [Martin Fowler: Polyglot Persistence](https://martinfowler.com/bliki/PolyglotPersistence.html)
- Persian: [Quera: NoSQL concepts](https://quera.org/college/landpage/1134/nosql-course), [DNTips technical articles](https://www.dntips.ir/)
