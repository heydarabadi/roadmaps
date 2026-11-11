# MongoDB Self-Study Course — English

This parallel English course follows the same seven chapters and 28 independent lessons as the Persian edition. Each lesson includes step-by-step teaching, examples, practical scenarios, exercises, a ten-item answer key, and further reading. The core explanations are written here; external links help verify version-specific behavior and explore topics further.

## Start here

1. Read the [course guide and study method](course-overview.md).
2. Use the [roadmap.sh coverage map](roadmap-coverage.md) to locate every roadmap item.
3. Read chapters in order and run examples only in a learning database.
4. Complete the [online marketplace capstone](projects/marketplace-capstone/README.md).

## Course resources

- [MongoDB glossary](glossary.md)
- [Curated reference library](reference-library.md)
- [Operations lab](labs/02-operations/README.md)
- [Data-modeling workshop](labs/03-modeling/README.md)
- [Roadmap coverage](roadmap-coverage.md)

## Chapters and lessons

### Chapter 1 — MongoDB Foundations

- [Chapter overview](01-foundations/README.md)
- [What MongoDB is and when to choose it](01-foundations/what-is-mongodb/README.md)
- [Documents, BSON, and data types](01-foundations/bson-documents/README.md)
- [Atlas, installation, and tools](01-foundations/atlas-tools/README.md)

### Chapter 2 — Operations and Queries

- [Chapter overview](02-operations/README.md)
- [CRUD and bulk writes](02-operations/crud/README.md)
- [Filters, operators, projections, and cursors](02-operations/queries-cursors/README.md)
- [Updates, arrays, bulkWrite, and validation](02-operations/updates-validation/README.md)
- [Cursors, counts, and read/write concerns](02-operations/cursor-count-concerns/README.md)

### Chapter 3 — Data Modeling

- [Chapter overview](03-modeling/README.md)
- [Data modeling: embed or reference](03-modeling/modeling/README.md)
- [Schema validation and versioning](03-modeling/schema-validation/README.md)

### Chapter 4 — Aggregation, Search, and Performance

- [Chapter overview](04-performance/README.md)
- [Indexes: single-field, compound, TTL, and geospatial](04-performance/indexes/README.md)
- [Explain plans and query tuning](04-performance/query-performance/README.md)
- [Aggregation pipelines](04-performance/aggregation/README.md)
- [Atlas Search](04-performance/atlas-search/README.md)

### Chapter 5 — Reliability and Scale

- [Chapter overview](05-reliability/README.md)
- [Transactions, atomicity, and read/write concerns](05-reliability/transactions-concerns/README.md)
- [Multi-document transactions](05-reliability/transactions/README.md)
- [Replica sets and failover](05-reliability/replication/README.md)
- [Backup and recovery](05-reliability/backup-recovery/README.md)
- [Sharding, scaling, and tuning](05-reliability/sharding-scaling/README.md)

### Chapter 6 — Security

- [Chapter overview](06-security/README.md)
- [MongoDB security in layers](06-security/security/README.md)
- [Authentication and RBAC](06-security/authentication-rbac/README.md)
- [Enterprise authentication: X.509, Kerberos, and LDAP](06-security/enterprise-auth/README.md)
- [TLS, encryption at rest, and field-level encryption](06-security/encryption-detail/README.md)
- [MongoDB auditing and security logs](06-security/audit-detail/README.md)

### Chapter 7 — Tools and Ecosystem

- [Chapter overview](07-ecosystem/README.md)
- [Language drivers and connection pools](07-ecosystem/language-drivers/README.md)
- [Drivers and connectors](07-ecosystem/drivers-connectors/README.md)
- [Kafka, Spark, and Elasticsearch connectors](07-ecosystem/connectors-detail/README.md)
- [Change Streams and event-driven systems](07-ecosystem/change-streams/README.md)
- [Developer tools: mongosh, Compass, and Database Tools](07-ecosystem/developer-tools/README.md)

## Published customer stories

These are useful to study design decisions in context. Most are published by MongoDB or its customers and are not independent benchmarks.

- [Forbes: CMS and developer-environment modernization](https://www.mongodb.com/solutions/customer-case-studies/forbes)
- [Victoria’s Secret: data modeling, replication, and backup](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret)
- [Bazaarvoice: sharding a large product catalog](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)
- [Coinbase: scaling for volatile traffic](https://www.mongodb.com/solutions/customer-case-studies/coinbase)
- [Ada: event processing with Change Streams](https://www.mongodb.com/solutions/customer-case-studies/ada)
- [Wells Fargo: an operational data store for card payments](https://www.mongodb.com/solutions/customer-case-studies/wells-fargo)

## Foundational resources

- [MongoDB roadmap](https://roadmap.sh/mongodb)
- [MongoDB roadmap PDF](https://roadmap.sh/pdfs/roadmaps/mongodb.pdf)
- [MongoDB Manual](https://www.mongodb.com/docs/manual/)
- [MongoDB University](https://learn.mongodb.com/)
- [Curated reference library](reference-library.md)

The course teaches stable concepts and decision methods. Atlas, Enterprise features, drivers, and server behavior can vary by version and deployment, so consult the official documentation for the exact production version before applying settings. The bibliography is a focused, curated selection; it does not claim to enumerate the entire Internet.

Sources reviewed: 2026-11-11.
