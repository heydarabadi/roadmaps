# کتابخانهٔ رفرنس و مقاله‌های MongoDB

> **نسخهٔ انگلیسی:** [English edition](en/reference-library.md).

این کتابخانه مسیر مطالعهٔ تکمیلی را بر اساس موضوع درس‌ها دسته‌بندی می‌کند. برای هر موضوع ابتدا مستندات رسمی را برای syntax و نسخه بخوانید، سپس از مقاله‌ها و تجربه‌های پیاده‌سازی برای مقایسهٔ تصمیم‌های طراحی استفاده کنید. مطالعه‌های موردی MongoDB معمولاً به‌قلم خود شرکت یا فروشنده‌اند؛ اعداد و نتایج آن‌ها را مستقل از workload خودتان فرض نکنید.

## فصل ۱ — مبانی و سندها

<a id="foundations-choice"></a>
### انتخاب MongoDB و واژه‌های پایه
- [MongoDB Manual](https://www.mongodb.com/docs/manual/) — مرجع اصلی مفاهیم و عملیات.
- [Development Documentation](https://www.mongodb.com/docs/development/) — نقطهٔ شروع برای سند، collection، CRUD، مدل‌سازی و aggregation.
- [MongoDB چیست؟ — Pars.host](https://pars.host/blog/what-is-mongodb/) — معرفی فارسی پایگاه سندگرا.
- [راهنمای فارسی MongoDB — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi) — مجموعه درس‌های مقدماتی و عملی.
- [Forbes Customer Story](https://www.mongodb.com/solutions/customer-case-studies/forbes) — نمونهٔ منتشرشده از نوسازی CMS و محیط توسعه؛ روایت مشتری/فروشنده.

<a id="foundations-bson"></a>
### BSON، سند و نوع‌های داده
- [Documents](https://www.mongodb.com/docs/manual/core/document/) — ساختار و محدودیت‌های سند.
- [BSON Types](https://www.mongodb.com/docs/manual/reference/bson-types/) — فهرست نوع‌ها، اندازه‌ها و semantics.
- [Limits and Thresholds](https://www.mongodb.com/docs/manual/reference/limits/) — سقف اندازهٔ سند و محدودیت‌های دیگر.
- [Extended JSON](https://www.mongodb.com/docs/manual/reference/mongodb-extended-json/) — نمایش متنی نوع‌های خاص BSON.
- [BSON specification](https://bsonspec.org/spec.html) — مشخصات قالب BSON.
- [مفاهیم BSON در فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-11)

<a id="foundations-tools"></a>
### Atlas و ابزارهای توسعه
- [Atlas Get Started](https://www.mongodb.com/docs/atlas/getting-started/)
- [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/)
- [MongoDB Compass](https://www.mongodb.com/docs/compass/current/)
- [MongoDB Database Tools](https://www.mongodb.com/docs/database-tools/)
- [MongoDB University](https://learn.mongodb.com/) — دوره‌ها و مسیرهای آموزشی رسمی.

## فصل ۲ — CRUD، Query و عملیات

<a id="operations-crud"></a>
### CRUD، Update، Bulk و اعتبارسنجی
- [CRUD Operations](https://www.mongodb.com/docs/manual/crud/)
- [Insert Documents](https://www.mongodb.com/docs/manual/tutorial/insert-documents/)
- [Query Documents](https://www.mongodb.com/docs/manual/tutorial/query-documents/)
- [Update Documents](https://www.mongodb.com/docs/manual/tutorial/update-documents/)
- [Delete Documents](https://www.mongodb.com/docs/manual/tutorial/remove-documents/)
- [Bulk Write Operations](https://www.mongodb.com/docs/manual/core/bulk-write-operations/)
- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [عملیات CRUD در فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-9)

<a id="operations-query"></a>
### فیلتر، آرایه، Projection و Cursor
- [Query and Projection Operators](https://www.mongodb.com/docs/manual/reference/operator/query/)
- [Query Arrays](https://www.mongodb.com/docs/manual/tutorial/query-arrays/)
- [Query Embedded Documents](https://www.mongodb.com/docs/manual/tutorial/query-embedded-documents/)
- [Project Fields from Query Results](https://www.mongodb.com/docs/manual/tutorial/project-fields-from-query-results/)
- [Cursors](https://www.mongodb.com/docs/manual/core/cursors/)
- [Count Documents](https://www.mongodb.com/docs/manual/reference/method/db.collection.countDocuments/)
- [Null or Missing Fields](https://www.mongodb.com/docs/manual/tutorial/query-for-null-fields/)
- [Regex Operator](https://www.mongodb.com/docs/manual/reference/operator/query/regex/)
- [Cursor و query به فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-11)

<a id="operations-concerns"></a>
### Read/Write Concern و Retry
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Read Preference](https://www.mongodb.com/docs/manual/core/read-preference/)
- [Retryable Writes](https://www.mongodb.com/docs/manual/core/retryable-writes/)
- [Retryable Reads](https://www.mongodb.com/docs/manual/core/retryable-reads/)
- [تراکنش و consistency به فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-acid)

## فصل ۳ — مدل‌سازی و Schema

<a id="modeling-schema"></a>
### طراحی مدل و تکامل Schema
- [Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [Embedded Data](https://www.mongodb.com/docs/manual/data-modeling/embedding/)
- [References](https://www.mongodb.com/docs/manual/data-modeling/referencing/)
- [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [Schema Versioning Pattern](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/schema-versioning/)
- [Schema Design Patterns — MongoDB University](https://learn.mongodb.com/courses/schema-design-patterns)
- [Advanced Schema Design Patterns — MongoDB University](https://learn.mongodb.com/courses/advanced-schema-design-patterns)
- [Data Modeling Concepts — MongoDB](https://www.mongodb.com/resources/basics/databases/data-modeling)
- [Performance Best Practices: Data Modeling and Memory Sizing — MongoDB Engineering](https://www.mongodb.com/company/blog/technical/performance-best-practices-mongodb-data-modeling-and-memory-sizing) — ارتباط الگوی دسترسی با شکل سند و working set؛ مقاله قدیمی‌تر است، پس نکته‌های نسخه‌ای را با مستندات امروز تطبیق دهید.
- [مفاهیم مدل‌سازی — Urhoba](https://www.urhoba.net/fa/post/mongodb-7)
- [Victoria’s Secret Customer Story](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret) — تجربهٔ منتشرشده دربارهٔ migration و دادهٔ چندمنبعی؛ منبع مستقل نیست.

## فصل ۴ — Index، کارایی، Aggregation و Search

<a id="performance-indexes"></a>
### Index و Query Performance
- [Indexes](https://www.mongodb.com/docs/manual/indexes/)
- [Index Types](https://www.mongodb.com/docs/manual/core/indexes/index-types/)
- [Compound Indexes](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-compound/)
- [Indexing Strategies](https://www.mongodb.com/docs/manual/applications/indexes/)
- [Equality, Sort, Range (ESR) Guideline](https://www.mongodb.com/docs/manual/tutorial/equality-sort-range-guideline/)
- [Analyze Query Plan](https://www.mongodb.com/docs/manual/tutorial/analyze-query-plan/)
- [Query Optimization](https://www.mongodb.com/docs/manual/core/query-optimization/)
- [Slow Queries in Production](https://www.mongodb.com/docs/manual/troubleshooting/slow-queries-in-production/)
- [Performance Tuning](https://www.mongodb.com/docs/manual/administration/performance-tuning/)
- [Atlas Query Profiler](https://www.mongodb.com/docs/atlas/tutorial/query-profiler/)
- [Performance Best Practices — MongoDB](https://www.mongodb.com/resources/products/capabilities/performance-best-practices)
- [Performance Best Practices: Indexing — MongoDB engineering blog](https://www.mongodb.com/company/blog/performance-best-practices-indexing)
- [Indexing Design Fundamentals — MongoDB University](https://learn.mongodb.com/learn/course/indexing-design-fundamentals/indexing-design-fundamentals/index-key-order)
- [MongoDB Indexes Explained — Percona](https://www.percona.com/blog/want-mongodb-performance-you-will-need-to-add-and-remove-indexes/) — نگاه عملیاتی به سود ایندکس و هزینهٔ over-indexing؛ این مقاله در فوریهٔ ۲۰۲۵ به‌روزرسانی شده است.
- [MongoDB query-optimizer evaluation — research paper](https://arxiv.org/abs/2409.16544) — advanced research; its findings apply to the versions and benchmarks studied in the paper.
- [ایندکس و کارایی — Urhoba](https://www.urhoba.net/fa/post/mongodb-5)

<a id="performance-aggregation"></a>
### Aggregation
- [Aggregation Operations](https://www.mongodb.com/docs/manual/aggregation/)
- [Aggregation Pipeline Stages](https://www.mongodb.com/docs/manual/reference/operator/aggregation-pipeline/)
- [Aggregation Pipeline Optimization](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-optimization/)
- [Aggregation Accumulators](https://www.mongodb.com/docs/manual/reference/operator/aggregation/)
- [MongoDB Aggregation Pipeline Performance Across Versions and Scales — Information](https://www.mdpi.com/2078-2489/17/5/488) — پژوهش پیشرفته با دادهٔ مصنوعی و چند نسخهٔ مشخص؛ نتیجه‌ها را به workload خود تعمیم ندهید.
- [دورهٔ فارسی Aggregation — Darsman](https://darsman.com/course/aggregation-operations-in-mongodb/)

<a id="performance-search"></a>
### Atlas Search
- [Atlas Search Overview](https://www.mongodb.com/docs/atlas/atlas-search/)
- [Create a Search Index](https://www.mongodb.com/docs/atlas/atlas-search/create-index/)
- [Analyzers](https://www.mongodb.com/docs/atlas/atlas-search/analyzers/)
- [Text Operator](https://www.mongodb.com/docs/atlas/atlas-search/text/)
- [Autocomplete Operator](https://www.mongodb.com/docs/atlas/atlas-search/autocomplete/)
- [Search Facets](https://www.mongodb.com/docs/atlas/atlas-search/facet/)
- [Bazaarvoice Customer Story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice) — تجربهٔ کاتالوگ و Search همراه رشد و sharding؛ گزارش فروشنده/مشتری.
- [جست‌وجو و aggregation به فارسی — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)

## فصل ۵ — Transaction، Replication، Backup و Scale

<a id="reliability-transactions"></a>
### Transactions و Durability
- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Transactions in Applications](https://www.mongodb.com/docs/manual/core/transactions-in-applications/)
- [Transaction Production Considerations](https://www.mongodb.com/docs/manual/core/transactions-production-consideration/)
- [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/)
- [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/)
- [Retryable Writes](https://www.mongodb.com/docs/manual/core/retryable-writes/)
- [تراکنش ACID به فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-acid)
- [Wells Fargo Customer Story](https://www.mongodb.com/solutions/customer-case-studies/wells-fargo) — گزارش operational data store و پلتفرم پرداخت؛ ارقام از روایت منتشرشدهٔ شرکت آمده‌اند.

<a id="reliability-replication"></a>
### Replica Set، Backup و Restore
- [Replication](https://www.mongodb.com/docs/manual/replication/)
- [Replica Set Elections](https://www.mongodb.com/docs/manual/core/replica-set-elections/)
- [Replica Set Read and Write Semantics](https://www.mongodb.com/docs/manual/applications/replication/)
- [Backup and Restore with MongoDB Tools](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/)
- [mongodump](https://www.mongodb.com/docs/database-tools/mongodump/)
- [mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/)
- [Atlas Backup](https://www.mongodb.com/docs/atlas/backup/cloud-backup/overview/)
- [Percona Backup for MongoDB (PBM) documentation](https://docs.percona.com/percona-backup-mongodb/index.html) — گزینهٔ متن‌باز برای backup هماهنگ و point-in-time restore؛ نسخه‌های پشتیبانی‌شده را با MongoDB خود تطبیق دهید.
- [Victoria’s Secret Customer Story](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret) — تجربهٔ منتشرشده از خودکارسازی عملیات Atlas و backup.
- [Replica Set به فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-6)

<a id="reliability-sharding"></a>
### Sharding و Scaling
- [Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Choose a Shard Key](https://www.mongodb.com/docs/manual/core/sharding-choose-a-shard-key/)
- [Shard Key Indexes](https://www.mongodb.com/docs/manual/core/sharding-shard-key/)
- [Hashed Sharding](https://www.mongodb.com/docs/manual/core/hashed-sharding/)
- [Production Notes](https://www.mongodb.com/docs/manual/administration/production-notes/)
- [Bazaarvoice Customer Story](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice) — گزارش تقسیم دادهٔ مشتریان برای targeted query.
- [Coinbase Customer Story](https://www.mongodb.com/solutions/customer-case-studies/coinbase) — گزارش پیش‌بینی ترافیک و کوتاه‌کردن زمان scale؛ شرکت sharding را به‌عنوان مسیر بعدی مطرح کرده است.
- [Performance Best Practices: Sharding — MongoDB Engineering](https://www.mongodb.com/company/blog/mongodb/performance-best-practices-sharding) — دربارهٔ توزیع کلید، targeted query و هزینهٔ scatter-gather.
- [Demystifying Sharding with MongoDB — MongoDB Engineering](https://www.mongodb.com/company/blog/technical/demystifying-sharding-mongodb) — توضیح مفهومی اجزای sharded cluster و پیامدهای routing.
- [راهنمای sharding فارسی — Urhoba](https://www.urhoba.net/fa/post/sharding-mongodb)

## فصل ۶ — امنیت و دسترسی

<a id="security-auth"></a>
### Authentication، RBAC و روش‌های سازمانی
- [Security](https://www.mongodb.com/docs/manual/security/)
- [Authentication](https://www.mongodb.com/docs/manual/core/authentication/)
- [Security Checklist for Self-Managed Deployments](https://www.mongodb.com/docs/manual/administration/security-checklist/) — چک‌لیست رسمی برای مرحلهٔ پیش از production و بازبینی مستمر؛ آن را با threat model پروژه تکمیل کنید.
- [Role-Based Access Control](https://www.mongodb.com/docs/manual/core/authorization/)
- [Built-in Roles](https://www.mongodb.com/docs/manual/reference/built-in-roles/)
- [LDAP Deprecation](https://www.mongodb.com/docs/manual/core/security-ldap-external/)
- [TLS/SSL Configuration](https://www.mongodb.com/docs/manual/core/security-transport-encryption/)
- [Authentication به فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-2)

<a id="security-encryption"></a>
### Encryption و Audit
- [Data Encryption](https://www.mongodb.com/docs/manual/core/security-data-encryption/)
- [Encryption at Rest](https://www.mongodb.com/docs/manual/core/security-encryption-at-rest/)
- [Client-Side Field Level Encryption](https://www.mongodb.com/docs/manual/core/csfle/)
- [Queryable Encryption](https://www.mongodb.com/docs/manual/core/queryable-encryption/)
- [Queryable Encryption Features and Limitations](https://www.mongodb.com/docs/manual/core/queryable-encryption/features/)
- [Auditing](https://www.mongodb.com/docs/manual/core/auditing/)
- [Auditing System Events](https://www.mongodb.com/docs/manual/reference/audit-events/)
- [Guidance for Atlas Data Encryption](https://www.mongodb.com/docs/atlas/architecture/current/data-encryption/)
- [رمزنگاری و امنیت به فارسی — Urhoba](https://www.urhoba.net/fa/post/mongodb-2)

## فصل ۷ — Driver، Connector و Change Stream

<a id="ecosystem-drivers"></a>
### Drivers و Pool
- [MongoDB Drivers](https://www.mongodb.com/docs/drivers/)
- [Node.js Driver](https://www.mongodb.com/docs/drivers/node/current/)
- [Connection Pools — Node.js](https://www.mongodb.com/docs/drivers/node/current/connect/connection-options/connection-pools/)
- [Java Driver](https://www.mongodb.com/docs/drivers/java/sync/current/)
- [Python Driver](https://www.mongodb.com/docs/languages/python/pymongo-driver/current/)
- [Go Driver](https://www.mongodb.com/docs/drivers/go/current/)

<a id="ecosystem-streams"></a>
### Change Streams و Connectors
- [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)
- [Resume a Change Stream](https://www.mongodb.com/docs/manual/changeStreams/#resume-a-change-stream)
- [MongoDB Kafka Connector](https://www.mongodb.com/docs/kafka-connector/current/)
- [Kafka Connector Change Stream Source](https://www.mongodb.com/docs/kafka-connector/current/source-connector/fundamentals/change-streams/)
- [MongoDB Spark Connector](https://www.mongodb.com/docs/spark-connector/current/)
- [Elastic MongoDB Connector](https://www.elastic.co/docs/reference/search-connectors/)
- [MongoDB Connector Integrations](https://www.mongodb.com/products/integrations/connectors)
- [An Introduction to Change Streams — MongoDB Engineering](https://www.mongodb.com/company/blog/technical/an-introduction-to-change-streams) — مقالهٔ مفهومی دربارهٔ مصرف تغییرات و resume؛ semantics و محدودیت‌ها را با Manual جاری بررسی کنید.
- [Ada Customer Story](https://www.mongodb.com/solutions/customer-case-studies/ada) — گزارش استفاده از Change Streams برای جریان داده و تحلیل؛ روایت منتشرشدهٔ MongoDB.
- [مجموعهٔ Change Streams به فارسی — Urhoba](https://www.urhoba.net/fa/post/change-streams-mongodb)

## یادداشت دربارهٔ کیفیت و تازگی منبع

- مستندات رسمی برای syntax، compatibility، محدودیت deployment و رفتار نسخه‌ای اولویت دارند.
- مقالهٔ فنی و course برای توضیح و مسیر یادگیری مفید است؛ پیش از کپی دستور production نسخه‌اش را بسنجید.
- تجربهٔ مشتری نمونهٔ یک طراحی است، نه توصیهٔ عمومی یا benchmark مستقل.
- منابع فارسی پوشش مفیدی می‌دهند؛ اگر با مستندات جاری تفاوت داشتند، رفتار نسخهٔ نصب‌شده و مستندات رسمی را ملاک قرار دهید.

بازبینی لینک‌ها و منابع: 2026-11-11.
