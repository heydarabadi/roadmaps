# Topic-by-Topic Coverage of the MongoDB Roadmap

> **Persian edition:** [Read the Persian version](../roadmap-coverage.md).

This map follows the [MongoDB roadmap](https://roadmap.sh/mongodb) and its published [PDF](https://roadmap.sh/pdfs/roadmaps/mongodb.pdf). Each item points to the main lesson in this course.

| Roadmap topic | Course lesson |
|---|---|
| What MongoDB is, SQL vs NoSQL, when to use it | [Choosing MongoDB](./01-foundations/what-is-mongodb/readme.md) |
| MongoDB basics, terminology, collections, and methods | [Chapter 1 overview](./01-foundations/readme.md), [CRUD](./02-operations/crud/readme.md) |
| MongoDB Atlas and developer tools | [Atlas and setup](./01-foundations/atlas-tools/readme.md), [Developer tools](./07-ecosystem/developer-tools/readme.md) |
| BSON vs JSON; embedded objects and arrays | [BSON documents](./01-foundations/bson-documents/readme.md), [Data modeling](./03-modeling/modeling/readme.md) |
| ObjectId, String, Double, Array, Object, Binary, Boolean | [BSON types](./01-foundations/bson-documents/readme.md) |
| Undefined, Symbol, Int32, Int64/Long, Timestamp, Decimal128, MinKey/MaxKey, Null, Date | [BSON types](./01-foundations/bson-documents/readme.md), including deprecated types |
| Insert, find, update, delete, and bulkWrite | [CRUD](./02-operations/crud/readme.md), [Updates and bulkWrite](./02-operations/updates-validation/readme.md) |
| Validation and schema | [Schema validation](./03-modeling/schema-validation/readme.md) |
| Counting documents and cursors | [Cursors and counts](./02-operations/cursor-count-concerns/readme.md) |
| Regex, comparison, logical, and element operators | [Filters and operators](./02-operations/queries-cursors/readme.md) |
| Projection, `$slice`, include/exclude | [Filters and projection](./02-operations/queries-cursors/readme.md) |
| Read/write concerns and retryable reads/writes | [Concerns and retries](./05-reliability/transactions-concerns/readme.md), [Cursors and counts](./02-operations/cursor-count-concerns/readme.md) |
| Single-field, compound, text, TTL, and geospatial indexes | [Indexes](./04-performance/indexes/readme.md) |
| Atlas Search indexes | [Atlas Search](./04-performance/atlas-search/readme.md) |
| Performance and query optimization | [Explain and query tuning](./04-performance/query-performance/readme.md) |
| Aggregation stages: match/group/sort/project/skip/limit/unwind/lookup/sum | [Aggregation pipeline](./04-performance/aggregation/readme.md) |
| Transactions | [Transactions](./05-reliability/transactions/readme.md), [Atomicity and concerns](./05-reliability/transactions-concerns/readme.md) |
| Language drivers | [Language drivers and pools](./07-ecosystem/language-drivers/readme.md) |
| MongoDB connectors | [Connectors](./07-ecosystem/connectors-detail/readme.md) |
| Kafka, Spark, and Elasticsearch | [Kafka, Spark, Elasticsearch](./07-ecosystem/connectors-detail/readme.md) |
| Replica sets | [Replication](./05-reliability/replication/readme.md) |
| Backup and recovery; mongodump/mongorestore | [Backup and recovery](./05-reliability/backup-recovery/readme.md) |
| Sharded clusters, scaling, and tuning | [Sharding and scaling](./05-reliability/sharding-scaling/readme.md) |
| Role-based access control | [Authentication and RBAC](./06-security/authentication-rbac/readme.md) |
| X.509, Kerberos, and LDAP | [Enterprise authentication](./06-security/enterprise-auth/readme.md) |
| Encryption at rest, TLS/SSL, CSFLE, Queryable Encryption | [Encryption](./06-security/encryption-detail/readme.md) |
| MongoDB Audit | [Auditing](./06-security/audit-detail/readme.md) |

Change Streams and schema evolution are additional topics in this course. The lessons contain the teaching and practice; external documentation links are retained for version checks and additional reading.
