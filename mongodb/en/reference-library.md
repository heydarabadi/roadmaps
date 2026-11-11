# MongoDB Reference and Article Library

> **Persian edition:** [Read the Persian version](../reference-library.md).

This library groups further reading by the lessons in this course. Start with official documentation for syntax, compatibility, and version behavior; then use technical articles and customer stories to compare design choices. MongoDB customer stories are usually published by MongoDB or the customer, so treat reported figures as context rather than independent benchmarks.

## Chapter 1 — Foundations and Documents

<a id="foundations-choice"></a>
### Choosing MongoDB and core terminology
- [MongoDB Manual](https://www.mongodb.com/docs/manual/) — primary reference for concepts and operations.
- [Development Documentation](https://www.mongodb.com/docs/development/) — entry point for documents, collections, CRUD, modeling, and aggregation.
- [What is MongoDB? — Pars.host](https://pars.host/blog/what-is-mongodb/) — Persian introduction to document databases.
- [MongoDB Learning Series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi) — Persian introductory and practical lessons.
- [Forbes customer story](https://www.mongodb.com/solutions/customer-case-studies/forbes) — a published CMS and developer-environment modernization story; vendor/customer-authored.

<a id="foundations-bson"></a>
### BSON, documents, and data types
- [Documents](https://www.mongodb.com/docs/manual/core/document/) — document structure and limits.
- [BSON Types](https://www.mongodb.com/docs/manual/reference/bson-types/) — BSON types, sizes, and semantics.
- [Limits and Thresholds](https://www.mongodb.com/docs/manual/reference/limits/) — maximum document size and other thresholds.
- [Extended JSON](https://www.mongodb.com/docs/manual/reference/mongodb-extended-json/) — textual representation of special BSON values.
- [BSON specification](https://bsonspec.org/spec.html) — BSON format specification.
- [BSON fundamentals in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-11)

<a id="foundations-tools"></a>
### Atlas and developer tools
- [Atlas Get Started](https://www.mongodb.com/docs/atlas/getting-started/)
- [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/)
- [MongoDB Compass](https://www.mongodb.com/docs/compass/current/)
- [MongoDB Database Tools](https://www.mongodb.com/docs/database-tools/)
- [MongoDB University](https://learn.mongodb.com/) — official courses and learning paths.

## Chapter 2 — CRUD, Queries, and Operations

<a id="operations-crud"></a>
### CRUD, updates, bulk writes, and validation
- [CRUD Operations](https://www.mongodb.com/docs/manual/crud/)
- [Insert Documents](https://www.mongodb.com/docs/manual/tutorial/insert-documents/)
- [Query Documents](https://www.mongodb.com/docs/manual/tutorial/query-documents/)
- [Update Documents](https://www.mongodb.com/docs/manual/tutorial/update-documents/)
- [Delete Documents](https://www.mongodb.com/docs/manual/tutorial/remove-documents/)
- [Bulk Write Operations](https://www.mongodb.com/docs/manual/core/bulk-write-operations/)
- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [CRUD operations in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-9)

<a id="operations-query"></a>
### Filters, arrays, projection, and cursors
- [Query and Projection Operators](https://www.mongodb.com/docs/manual/reference/operator/query/)
- [Query Arrays](https://www.mongodb.com/docs/manual/tutorial/query-arrays/)
- [Query Embedded Documents](https://www.mongodb.com/docs/manual/tutorial/query-embedded-documents/)
- [Project Fields from Query Results](https://www.mongodb.com/docs/manual/tutorial/project-fields-from-query-results/)
- [Cursors](https://www.mongodb.com/docs/manual/core/cursors/)
- [Count Documents](https://www.mongodb.com/docs/manual/reference/method/db.collection.countDocuments/)
- [Null or Missing Fields](https://www.mongodb.com/docs/manual/tutorial/query-for-null-fields/)
- [Regex Operator](https://www.mongodb.com/docs/manual/reference/operator/query/regex/)
- [Cursor and query concepts in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-11)

<a id="operations-concerns"></a>
### Read/write concerns and retries
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Read Preference](https://www.mongodb.com/docs/manual/core/read-preference/)
- [Retryable Writes](https://www.mongodb.com/docs/manual/core/retryable-writes/)
- [Retryable Reads](https://www.mongodb.com/docs/manual/core/retryable-reads/)
- [Transactions and consistency in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-acid)

## Chapter 3 — Modeling and Schema

<a id="modeling-schema"></a>
### Data modeling and schema evolution
- [Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [Embedded Data](https://www.mongodb.com/docs/manual/data-modeling/embedding/)
- [References](https://www.mongodb.com/docs/manual/data-modeling/referencing/)
- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [Schema Versioning Pattern](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/schema-versioning/)
- [Schema Design Patterns — MongoDB University](https://learn.mongodb.com/courses/schema-design-patterns)
- [Advanced Schema Design Patterns — MongoDB University](https://learn.mongodb.com/courses/advanced-schema-design-patterns)
- [Data Modeling Concepts — MongoDB](https://www.mongodb.com/resources/basics/databases/data-modeling)
- [Performance Best Practices: Data Modeling and Memory Sizing — MongoDB Engineering](https://www.mongodb.com/company/blog/technical/performance-best-practices-mongodb-data-modeling-and-memory-sizing) — connects access patterns to document shape and working-set sizing; this older post's version-specific advice should be checked against current documentation.
- [Modeling concepts in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-7)
- [Victoria’s Secret customer story](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret) — a published migration and multi-source data story; not an independent study.

## Chapter 4 — Indexes, Performance, Aggregation, and Search

<a id="performance-indexes"></a>
### Indexing and query performance
- [Indexes](https://www.mongodb.com/docs/manual/indexes/)
- [Index Types](https://www.mongodb.com/docs/manual/core/indexes/index-types/)
- [Compound Indexes](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-compound/)
- [Indexing Strategies](https://www.mongodb.com/docs/manual/applications/indexes/)
- [Equality, Sort, Range (ESR) Guideline](https://www.mongodb.com/docs/manual/tutorial/equality-sort-range-guideline/)
- [Analyze Query Plan](https://www.mongodb.com/docs/manual/tutorial/analyze-query-plan/)
- [Query Optimization](https://www.mongodb.com/docs/manual/core/query-optimization/)
- [Troubleshoot Slow Queries in Production](https://www.mongodb.com/docs/manual/troubleshooting/slow-queries-in-production/)
- [Performance Tuning](https://www.mongodb.com/docs/manual/administration/performance-tuning/)
- [Atlas Query Profiler](https://www.mongodb.com/docs/atlas/tutorial/query-profiler/)
- [MongoDB Performance Best Practices](https://www.mongodb.com/resources/products/capabilities/performance-best-practices)
- [Performance Best Practices: Indexing — MongoDB engineering blog](https://www.mongodb.com/company/blog/performance-best-practices-indexing)
- [Indexing Design Fundamentals — MongoDB University](https://learn.mongodb.com/learn/course/indexing-design-fundamentals/indexing-design-fundamentals/index-key-order)
- [MongoDB Indexes Explained — Percona](https://www.percona.com/blog/want-mongodb-performance-you-will-need-to-add-and-remove-indexes/) — a practical DBA perspective on index benefits and over-indexing costs; updated in February 2025.
- [Evaluating MongoDB query optimization — research paper](https://arxiv.org/abs/2409.16544) — advanced research; findings are limited to the versions and benchmarks studied.
- [Indexes and performance in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-5)

<a id="performance-aggregation"></a>
### Aggregation
- [Aggregation Operations](https://www.mongodb.com/docs/manual/aggregation/)
- [Aggregation Pipeline Stages](https://www.mongodb.com/docs/manual/reference/operator/aggregation-pipeline/)
- [Aggregation Pipeline Optimization](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-optimization/)
- [Aggregation Accumulators](https://www.mongodb.com/docs/manual/reference/operator/aggregation/)
- [MongoDB Aggregation Pipeline Performance Across Versions and Scales — Information](https://www.mdpi.com/2078-2489/17/5/488) — advanced research using synthetic data and specific versions; do not generalize its results to your workload.
- [Persian aggregation course — Darsman](https://darsman.com/course/aggregation-operations-in-mongodb/)

<a id="performance-search"></a>
### Atlas Search
- [Atlas Search Overview](https://www.mongodb.com/docs/atlas/atlas-search/)
- [Create a Search Index](https://www.mongodb.com/docs/atlas/atlas-search/create-index/)
- [Analyzers](https://www.mongodb.com/docs/atlas/atlas-search/analyzers/)
- [Text Operator](https://www.mongodb.com/docs/atlas/atlas-search/text/)
- [Autocomplete Operator](https://www.mongodb.com/docs/atlas/atlas-search/autocomplete/)
- [Search Facets](https://www.mongodb.com/docs/atlas/atlas-search/facet/)
- [Bazaarvoice customer story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice) — a catalog and Search story during growth and sharding; vendor/customer-reported.
- [Search and aggregation in Persian — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)

## Chapter 5 — Transactions, Replication, Backups, and Scale

<a id="reliability-transactions"></a>
### Transactions and durability
- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Transactions in Applications](https://www.mongodb.com/docs/manual/core/transactions-in-applications/)
- [Transaction Production Considerations](https://www.mongodb.com/docs/manual/core/transactions-production-consideration/)
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Retryable Writes](https://www.mongodb.com/docs/manual/core/retryable-writes/)
- [ACID transactions in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-acid)
- [Wells Fargo customer story](https://www.mongodb.com/solutions/customer-case-studies/wells-fargo) — an operational data store and card-payment platform story; figures come from the published customer account.

<a id="reliability-replication"></a>
### Replica sets, backup, and restore
- [Replication](https://www.mongodb.com/docs/manual/replication/)
- [Replica Set Elections](https://www.mongodb.com/docs/manual/core/replica-set-elections/)
- [Replica Set Read and Write Semantics](https://www.mongodb.com/docs/manual/applications/replication/)
- [Backup and Restore with MongoDB Tools](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/)
- [mongodump](https://www.mongodb.com/docs/database-tools/mongodump/)
- [mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/)
- [Atlas Backup](https://www.mongodb.com/docs/atlas/backup/cloud-backup/overview/)
- [Percona Backup for MongoDB (PBM) documentation](https://docs.percona.com/percona-backup-mongodb/index.html) — an open-source option for consistent backups and point-in-time restores; check its supported versions against your MongoDB deployment.
- [Victoria’s Secret customer story](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret) — a published account of Atlas operations and backups.
- [Replica sets in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-6)

<a id="reliability-sharding"></a>
### Sharding and scaling
- [Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Choose a Shard Key](https://www.mongodb.com/docs/manual/core/sharding-choose-a-shard-key/)
- [Shard Key Indexes](https://www.mongodb.com/docs/manual/core/sharding-shard-key/)
- [Hashed Sharding](https://www.mongodb.com/docs/manual/core/hashed-sharding/)
- [Production Notes](https://www.mongodb.com/docs/manual/administration/production-notes/)
- [Bazaarvoice customer story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice) — a reported approach to keeping customer data together for targeted queries.
- [Coinbase customer story](https://www.mongodb.com/solutions/customer-case-studies/coinbase) — a report about traffic forecasting and faster scaling; the company presents sharding as a later step.
- [Performance Best Practices: Sharding — MongoDB Engineering](https://www.mongodb.com/company/blog/mongodb/performance-best-practices-sharding) — covers shard-key distribution, targeted queries, and scatter-gather costs.
- [Demystifying Sharding with MongoDB — MongoDB Engineering](https://www.mongodb.com/company/blog/technical/demystifying-sharding-mongodb) — a conceptual explanation of sharded-cluster components and routing implications.
- [Sharding guide in Persian — Urhoba](https://www.urhoba.net/fa/post/sharding-mongodb)

## Chapter 6 — Security and Access

<a id="security-auth"></a>
### Authentication, RBAC, and enterprise mechanisms
- [Security](https://www.mongodb.com/docs/manual/security/)
- [Authentication](https://www.mongodb.com/docs/manual/core/authentication/)
- [Security Checklist for Self-Managed Deployments](https://www.mongodb.com/docs/manual/administration/security-checklist/) — an official pre-production and ongoing review checklist; pair it with your project's threat model.
- [Role-Based Access Control](https://www.mongodb.com/docs/manual/core/authorization/)
- [Built-in Roles](https://www.mongodb.com/docs/manual/reference/built-in-roles/)
- [LDAP Deprecation](https://www.mongodb.com/docs/manual/core/security-ldap-external/)
- [TLS/SSL Configuration](https://www.mongodb.com/docs/manual/core/security-transport-encryption/)
- [Authentication in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-2)

<a id="security-encryption"></a>
### Encryption and auditing
- [Data Encryption](https://www.mongodb.com/docs/manual/core/security-data-encryption/)
- [Encryption at Rest](https://www.mongodb.com/docs/manual/core/security-encryption-at-rest/)
- [Client-Side Field Level Encryption](https://www.mongodb.com/docs/manual/core/csfle/)
- [Queryable Encryption](https://www.mongodb.com/docs/manual/core/queryable-encryption/)
- [Queryable Encryption Features and Limitations](https://www.mongodb.com/docs/manual/core/queryable-encryption/features/)
- [Auditing](https://www.mongodb.com/docs/manual/core/auditing/)
- [Auditing System Events](https://www.mongodb.com/docs/manual/reference/audit-events/)
- [Guidance for Atlas Data Encryption](https://www.mongodb.com/docs/atlas/architecture/current/data-encryption/)
- [Encryption and security in Persian — Urhoba](https://www.urhoba.net/fa/post/mongodb-2)

## Chapter 7 — Drivers, Connectors, and Change Streams

<a id="ecosystem-drivers"></a>
### Drivers and connection pools
- [MongoDB Drivers](https://www.mongodb.com/docs/drivers/)
- [Node.js Driver](https://www.mongodb.com/docs/drivers/node/current/)
- [Node.js Connection Pools](https://www.mongodb.com/docs/drivers/node/current/connect/connection-options/connection-pools/)
- [Java Driver](https://www.mongodb.com/docs/drivers/java/sync/current/)
- [Python Driver](https://www.mongodb.com/docs/languages/python/pymongo-driver/current/)
- [Go Driver](https://www.mongodb.com/docs/drivers/go/current/)

<a id="ecosystem-streams"></a>
### Change Streams and connectors
- [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)
- [Resume a Change Stream](https://www.mongodb.com/docs/manual/changeStreams/#resume-a-change-stream)
- [MongoDB Kafka Connector](https://www.mongodb.com/docs/kafka-connector/current/)
- [Kafka Connector Change Stream Source](https://www.mongodb.com/docs/kafka-connector/current/source-connector/fundamentals/change-streams/)
- [MongoDB Spark Connector](https://www.mongodb.com/docs/spark-connector/current/)
- [Elastic MongoDB Connector](https://www.elastic.co/docs/reference/search-connectors/)
- [MongoDB Connector Integrations](https://www.mongodb.com/products/integrations/connectors)
- [An Introduction to Change Streams — MongoDB Engineering](https://www.mongodb.com/company/blog/technical/an-introduction-to-change-streams) — a conceptual article about consuming changes and resuming; check current Manual semantics and limitations.
- [Ada customer story](https://www.mongodb.com/solutions/customer-case-studies/ada) — a published Change Streams and data-processing story from MongoDB.
- [Change Streams in Persian — Urhoba](https://www.urhoba.net/fa/post/change-streams-mongodb)

## Source quality and freshness

- Prefer official documentation for syntax, compatibility, deployment limits, and version behavior.
- Technical articles and courses help explain concepts; verify their versions before using commands in production.
- A customer story is an example of one design, not a general recommendation or independent benchmark.
- Persian resources can be useful introductions. If they disagree with current docs, verify the behavior against your installed version and its official manual.

Links reviewed: 2026-11-11.
