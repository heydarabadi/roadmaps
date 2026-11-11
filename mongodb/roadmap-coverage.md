# پوشش موردبه‌مورد MongoDB roadmap.sh

> **نسخهٔ انگلیسی:** [English edition](en/roadmap-coverage.md).

مبنای این نقشه [مسیر MongoDB](https://roadmap.sh/mongodb) و فهرست منتشرشده در [PDF roadmap](https://roadmap.sh/pdfs/roadmaps/mongodb.pdf) است. هر ردیف به درس اصلی در همین مجموعه اشاره می‌کند.

| موضوع در نقشه | درس این دوره |
|---|---|
| What is MongoDB، SQL vs NoSQL، When to use | [انتخاب MongoDB](./01-foundations/what-is-mongodb/readme.md) |
| MongoDB Basics، Terminology، Collections & Methods | [مبانی](./01-foundations/readme.md)، [CRUD](./02-operations/crud/readme.md) |
| What is MongoDB Atlas و Developer Tools | [Atlas و محیط](./01-foundations/atlas-tools/readme.md)، [ابزارها](./07-ecosystem/developer-tools/readme.md) |
| BSON vs JSON، Embedded Objects & Arrays | [BSON](./01-foundations/bson-documents/readme.md)، [مدل‌سازی](./03-modeling/modeling/readme.md) |
| ObjectId، String، Double، Array، Object، Binary، Boolean | [BSON](./01-foundations/bson-documents/readme.md) |
| Undefined، Symbol، Int32، Int64/Long، Timestamp، Decimal128، MinKey/MaxKey، Null، Date | [BSON](./01-foundations/bson-documents/readme.md)؛ نوع‌های deprecated نیز مشخص شده‌اند |
| insert، find، update، delete و bulkWrite | [CRUD](./02-operations/crud/readme.md)، [Update و bulkWrite](./02-operations/updates-validation/readme.md) |
| validate و schema | [Schema Validation](./03-modeling/schema-validation/readme.md) |
| Counting Documents و Cursors | [Cursor و count](./02-operations/cursor-count-concerns/readme.md) |
| Regular Expression، comparison، logical، element operators | [فیلتر و Query](./02-operations/queries-cursors/readme.md) |
| Projection، $slice، include/exclude | [فیلتر و Query](./02-operations/queries-cursors/readme.md) |
| Read/Write Concerns و Retryable Reads/Writes | [Concernها](./05-reliability/transactions-concerns/readme.md)، [Cursor](./02-operations/cursor-count-concerns/readme.md) |
| Single-field، compound، text، TTL، geospatial index | [Indexها](./04-performance/indexes/readme.md) |
| Atlas Search Indexes | [Atlas Search](./04-performance/atlas-search/readme.md) |
| Performance Optimization و Query Optimization | [Explain و بهینه‌سازی](./04-performance/query-performance/readme.md) |
| Aggregation Pipeline و stages: match/group/sort/project/skip/limit/unwind/lookup/sum | [Aggregation](./04-performance/aggregation/readme.md) |
| Transactions | [Transaction](./05-reliability/transactions/readme.md)، [Atomicity و Concern](./05-reliability/transactions-concerns/readme.md) |
| Language Drivers | [Driver و Pool](./07-ecosystem/language-drivers/readme.md) |
| MongoDB Connectors | [Connectorها](./07-ecosystem/connectors-detail/readme.md) |
| Kafka، Spark، Elasticsearch | [Connectorها](./07-ecosystem/connectors-detail/readme.md) |
| Replica Sets | [Replication](./05-reliability/replication/readme.md) |
| Backup & Recovery، mongodump، mongorestore | [Backup](./05-reliability/backup-recovery/readme.md) |
| Sharded Clusters، Scaling، Tuning Configuration | [Sharding و scaling](./05-reliability/sharding-scaling/readme.md) |
| Role-based Access Control | [Auth و RBAC](./06-security/authentication-rbac/readme.md) |
| X.509، Kerberos، LDAP | [Auth سازمانی](./06-security/enterprise-auth/readme.md) |
| Encryption at Rest، TLS/SSL، Client-Side Field Level، Queryable Encryption | [رمزنگاری](./06-security/encryption-detail/readme.md) |
| MongoDB Audit | [Audit](./06-security/audit-detail/readme.md) |

Change Streams و مبانی تکامل schema به عنوان آموزش تکمیلی افزوده شده‌اند. لینک‌های رسمی در هر درس برای بررسی نسخه‌اند؛ توضیح و تمرین اصلی در همین پوشه قرار دارد.
