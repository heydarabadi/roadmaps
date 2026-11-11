# MongoDB Self-Study Course — English

This parallel English course follows the same seven chapters and 28 independent lessons as the Persian edition. Each lesson includes step-by-step teaching, examples, practical scenarios, exercises, a ten-item answer key, and further reading. The core explanations are written here; external links help verify version-specific behavior and explore topics further.

## Start here

1. Read the [course guide and study method](./course-overview.md).
2. Use the [roadmap.sh coverage map](./roadmap-coverage.md) to locate every roadmap item.
3. Read chapters in order and run examples only in a learning database.
4. Complete the [online marketplace capstone](./projects/marketplace-capstone/readme.md).

## Course resources

- [MongoDB glossary](./glossary.md)
- [Curated reference library](./reference-library.md)
- [Operations lab](./labs/02-operations/readme.md)
- [Data-modeling workshop](./labs/03-modeling/readme.md)
- [Roadmap coverage](./roadmap-coverage.md)

## Chapters and lessons

### Chapter 1 — MongoDB Foundations

- [Chapter overview](./01-foundations/readme.md)
- [What MongoDB is and when to choose it](./01-foundations/what-is-mongodb/readme.md)
- [Documents, BSON, and data types](./01-foundations/bson-documents/readme.md)
- [Atlas, installation, and tools](./01-foundations/atlas-tools/readme.md)

### Chapter 2 — Operations and Queries

- [Chapter overview](./02-operations/readme.md)
- [CRUD and bulk writes](./02-operations/crud/readme.md)
- [Filters, operators, projections, and cursors](./02-operations/queries-cursors/readme.md)
- [Updates, arrays, bulkWrite, and validation](./02-operations/updates-validation/readme.md)
- [Cursors, counts, and read/write concerns](./02-operations/cursor-count-concerns/readme.md)

### Chapter 3 — Data Modeling

- [Chapter overview](./03-modeling/readme.md)
- [Data modeling: embed or reference](./03-modeling/modeling/readme.md)
- [Schema validation and versioning](./03-modeling/schema-validation/readme.md)

### Chapter 4 — Aggregation, Search, and Performance

- [Chapter overview](./04-performance/readme.md)
- [Indexes: single-field, compound, TTL, and geospatial](./04-performance/indexes/readme.md)
- [Explain plans and query tuning](./04-performance/query-performance/readme.md)
- [Aggregation pipelines](./04-performance/aggregation/readme.md)
- [Atlas Search](./04-performance/atlas-search/readme.md)

### Chapter 5 — Reliability and Scale

- [Chapter overview](./05-reliability/readme.md)
- [Transactions, atomicity, and read/write concerns](./05-reliability/transactions-concerns/readme.md)
- [Multi-document transactions](./05-reliability/transactions/readme.md)
- [Replica sets and failover](./05-reliability/replication/readme.md)
- [Backup and recovery](./05-reliability/backup-recovery/readme.md)
- [Sharding, scaling, and tuning](./05-reliability/sharding-scaling/readme.md)

### Chapter 6 — Security

- [Chapter overview](./06-security/readme.md)
- [MongoDB security in layers](./06-security/security/readme.md)
- [Authentication and RBAC](./06-security/authentication-rbac/readme.md)
- [Enterprise authentication: X.509, Kerberos, and LDAP](./06-security/enterprise-auth/readme.md)
- [TLS, encryption at rest, and field-level encryption](./06-security/encryption-detail/readme.md)
- [MongoDB auditing and security logs](./06-security/audit-detail/readme.md)

### Chapter 7 — Tools and Ecosystem

- [Chapter overview](./07-ecosystem/readme.md)
- [Language drivers and connection pools](./07-ecosystem/language-drivers/readme.md)
- [Drivers and connectors](./07-ecosystem/drivers-connectors/readme.md)
- [Kafka, Spark, and Elasticsearch connectors](./07-ecosystem/connectors-detail/readme.md)
- [Change Streams and event-driven systems](./07-ecosystem/change-streams/readme.md)
- [Developer tools: mongosh, Compass, and Database Tools](./07-ecosystem/developer-tools/readme.md)

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
- [Curated reference library](./reference-library.md)

The course teaches stable concepts and decision methods. Atlas, Enterprise features, drivers, and server behavior can vary by version and deployment, so consult the official documentation for the exact production version before applying settings. The bibliography is a focused, curated selection; it does not claim to enumerate the entire Internet.

Sources reviewed: 2026-11-11.
