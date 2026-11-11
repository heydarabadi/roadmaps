# پوشش موردبه‌مورد MongoDB roadmap.sh

> **نسخهٔ انگلیسی:** [English edition](../../en/mongodb/roadmap-coverage.md).

مبنای این نقشه [مسیر MongoDB](https://roadmap.sh/mongodb) و فهرست منتشرشده در [PDF roadmap](https://roadmap.sh/pdfs/roadmaps/mongodb.pdf) است. هر ردیف به درس اصلی در همین مجموعه اشاره می‌کند.

| موضوع در نقشه | درس این دوره |
|---|---|
| What is MongoDB، SQL vs NoSQL، When to use | [انتخاب MongoDB](01-foundations/what-is-mongodb/README.md) |
| MongoDB Basics، Terminology، Collections & Methods | [مبانی](01-foundations/README.md)، [CRUD](02-operations/crud/README.md) |
| What is MongoDB Atlas و Developer Tools | [Atlas و محیط](01-foundations/atlas-tools/README.md)، [ابزارها](07-ecosystem/developer-tools/README.md) |
| BSON vs JSON، Embedded Objects & Arrays | [BSON](01-foundations/bson-documents/README.md)، [مدل‌سازی](03-modeling/modeling/README.md) |
| ObjectId، String، Double، Array، Object، Binary، Boolean | [BSON](01-foundations/bson-documents/README.md) |
| Undefined، Symbol، Int32، Int64/Long، Timestamp، Decimal128، MinKey/MaxKey، Null، Date | [BSON](01-foundations/bson-documents/README.md)؛ نوع‌های deprecated نیز مشخص شده‌اند |
| insert، find، update، delete و bulkWrite | [CRUD](02-operations/crud/README.md)، [Update و bulkWrite](02-operations/updates-validation/README.md) |
| validate و schema | [Schema Validation](03-modeling/schema-validation/README.md) |
| Counting Documents و Cursors | [Cursor و count](02-operations/cursor-count-concerns/README.md) |
| Regular Expression، comparison، logical، element operators | [فیلتر و Query](02-operations/queries-cursors/README.md) |
| Projection، $slice، include/exclude | [فیلتر و Query](02-operations/queries-cursors/README.md) |
| Read/Write Concerns و Retryable Reads/Writes | [Concernها](05-reliability/transactions-concerns/README.md)، [Cursor](02-operations/cursor-count-concerns/README.md) |
| Single-field، compound، text، TTL، geospatial index | [Indexها](04-performance/indexes/README.md) |
| Atlas Search Indexes | [Atlas Search](04-performance/atlas-search/README.md) |
| Performance Optimization و Query Optimization | [Explain و بهینه‌سازی](04-performance/query-performance/README.md) |
| Aggregation Pipeline و stages: match/group/sort/project/skip/limit/unwind/lookup/sum | [Aggregation](04-performance/aggregation/README.md) |
| Transactions | [Transaction](05-reliability/transactions/README.md)، [Atomicity و Concern](05-reliability/transactions-concerns/README.md) |
| Language Drivers | [Driver و Pool](07-ecosystem/language-drivers/README.md) |
| MongoDB Connectors | [Connectorها](07-ecosystem/connectors-detail/README.md) |
| Kafka، Spark، Elasticsearch | [Connectorها](07-ecosystem/connectors-detail/README.md) |
| Replica Sets | [Replication](05-reliability/replication/README.md) |
| Backup & Recovery، mongodump، mongorestore | [Backup](05-reliability/backup-recovery/README.md) |
| Sharded Clusters، Scaling، Tuning Configuration | [Sharding و scaling](05-reliability/sharding-scaling/README.md) |
| Role-based Access Control | [Auth و RBAC](06-security/authentication-rbac/README.md) |
| X.509، Kerberos، LDAP | [Auth سازمانی](06-security/enterprise-auth/README.md) |
| Encryption at Rest، TLS/SSL، Client-Side Field Level، Queryable Encryption | [رمزنگاری](06-security/encryption-detail/README.md) |
| MongoDB Audit | [Audit](06-security/audit-detail/README.md) |

Change Streams و مبانی تکامل schema به عنوان آموزش تکمیلی افزوده شده‌اند. لینک‌های رسمی در هر درس برای بررسی نسخه‌اند؛ توضیح و تمرین اصلی در همین پوشه قرار دارد.
