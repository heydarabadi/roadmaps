# دورهٔ خودآموز MongoDB — فارسی

> **نسخهٔ انگلیسی:** [English edition](en/readme.md).

این دوره از مبانی تا نگهداری سامانهٔ production پیش می‌رود. هر درس موضوعی پوشهٔ مستقل دارد و شامل تدریس مرحله‌به‌مرحله، مثال، سناریو یا تجربهٔ موردی، تمرین، آزمون ده‌سؤالی پاسخ‌دار و لینک‌های فارسی و انگلیسی است. هدف این است که برای فهم مفاهیم اصلی نیازی به منبع بیرونی نداشته باشید؛ لینک‌ها برای بررسی جزئیات نسخه/محصول و مطالعهٔ بیشترند.

## از کجا شروع کنم؟

1. [راهنمای دوره و روش مطالعه](./course-overview.md) را بخوانید.
2. [نقشهٔ پوشش موردبه‌مورد roadmap.sh](./roadmap-coverage.md) را برای یافتن هر موضوع ببینید.
3. فصل‌ها را به ترتیب بخوانید، مثال‌ها را در دیتابیس آزمایشی اجرا کنید و پاسخ تمرین‌ها را قبل از دیدن پاسخ‌نامه بنویسید.
4. برای جمع‌بندی، [پروژهٔ پایانی فروشگاه آنلاین](./projects/marketplace-capstone/readme.md) را انجام دهید.

## منابع کمک‌درسی داخل پوشه

- [کتابخانهٔ رفرنس‌ها و مقاله‌های موضوعی](./reference-library.md)
- [واژه‌نامهٔ MongoDB](./glossary.md)
- [آزمایشگاه CRUD، query، update و cursor](./labs/02-operations/readme.md)
- [کارگاه مدل‌سازی و schema validation](./labs/03-modeling/readme.md)
- [نقشهٔ پوشش roadmap.sh](./roadmap-coverage.md)

## فصل‌ها و درس‌ها

### فصل ۱ — مبانی MongoDB

- [نمای کلی فصل](./01-foundations/readme.md)
- [MongoDB چیست و چه وقت انتخاب مناسبی است؟](./01-foundations/what-is-mongodb/readme.md)
- [سند، BSON و انواع داده](./01-foundations/bson-documents/readme.md)
- [Atlas، نصب و محیط کاری](./01-foundations/atlas-tools/readme.md)

### فصل ۲ — عملیات و پرس‌وجو

- [نمای کلی فصل](./02-operations/readme.md)
- [CRUD و نوشتن گروهی](./02-operations/crud/readme.md)
- [فیلتر، Operator، Projection و Cursor](./02-operations/queries-cursors/readme.md)
- [Update، آرایه، bulkWrite و validation](./02-operations/updates-validation/readme.md)
- [Cursor، شمارش و Read/Write Concern](./02-operations/cursor-count-concerns/readme.md)

### فصل ۳ — مدل‌سازی داده

- [نمای کلی فصل](./03-modeling/readme.md)
- [مدل‌سازی: Embed یا Reference](./03-modeling/modeling/readme.md)
- [Schema Validation و versioning](./03-modeling/schema-validation/readme.md)

### فصل ۴ — تحلیل، جست‌وجو و کارایی

- [نمای کلی فصل](./04-performance/readme.md)
- [Indexها: single، compound، TTL و geospatial](./04-performance/indexes/readme.md)
- [Explain، Query Plan و بهینه‌سازی](./04-performance/query-performance/readme.md)
- [Aggregation Pipeline](./04-performance/aggregation/readme.md)
- [Atlas Search](./04-performance/atlas-search/readme.md)

### فصل ۵ — قابلیت اتکا و مقیاس

- [نمای کلی فصل](./05-reliability/readme.md)
- [Transaction، Atomicity و Read/Write Concern](./05-reliability/transactions-concerns/readme.md)
- [Transactions چندسندی](./05-reliability/transactions/readme.md)
- [Replica Set و failover](./05-reliability/replication/readme.md)
- [Backup و Recovery](./05-reliability/backup-recovery/readme.md)
- [Sharding، Scaling و Tuning](./05-reliability/sharding-scaling/readme.md)

### فصل ۶ — امنیت

- [نمای کلی فصل](./06-security/readme.md)
- [امنیت لایه‌ای MongoDB](./06-security/security/readme.md)
- [Authentication و RBAC](./06-security/authentication-rbac/readme.md)
- [X.509، Kerberos و LDAP سازمانی](./06-security/enterprise-auth/readme.md)
- [TLS، Encryption at Rest و Field-Level Encryption](./06-security/encryption-detail/readme.md)
- [MongoDB Audit و logهای امنیتی](./06-security/audit-detail/readme.md)

### فصل ۷ — ابزارها و اکوسیستم

- [نمای کلی فصل](./07-ecosystem/readme.md)
- [Language Drivers و Connection Pool](./07-ecosystem/language-drivers/readme.md)
- [Driverها و Connectorها](./07-ecosystem/drivers-connectors/readme.md)
- [Connectorهای Kafka، Spark و Elasticsearch](./07-ecosystem/connectors-detail/readme.md)
- [Change Streams و معماری رویدادمحور](./07-ecosystem/change-streams/readme.md)
- [Developer Tools: mongosh، Compass و Database Tools](./07-ecosystem/developer-tools/readme.md)

## تجربه‌های منتشرشدهٔ شرکت‌ها

این گزارش‌ها برای دیدن تصمیم‌های واقعی مفیدند، اما اغلب از سوی MongoDB یا مشتری همان راهکار منتشر شده‌اند؛ معیار مستقل و تضمین نتیجه برای workload شما نیستند.

- [Forbes — نوسازی CMS و محیط توسعه](https://www.mongodb.com/solutions/customer-case-studies/forbes)
- [Victoria’s Secret — مدل داده، replication و backup](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret)
- [Bazaarvoice — shard کردن catalog در مقیاس بزرگ](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)
- [Coinbase — آمادگی برای جهش ترافیک و scale](https://www.mongodb.com/solutions/customer-case-studies/coinbase)
- [Ada — جریان رخداد با Change Streams](https://www.mongodb.com/solutions/customer-case-studies/ada)
- [Wells Fargo — operational data store برای پرداخت کارتی](https://www.mongodb.com/solutions/customer-case-studies/wells-fargo)

## منابع پایه

- [MongoDB roadmap](https://roadmap.sh/mongodb)
- [PDF نقشهٔ MongoDB](https://roadmap.sh/pdfs/roadmaps/mongodb.pdf)
- [MongoDB Manual](https://www.mongodb.com/docs/manual/)
- [راهنمای فارسی MongoDB در Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [MongoDB چیست؟ در Pars.host](https://pars.host/blog/what-is-mongodb/)
- [دورهٔ فارسی aggregation در Darsman](https://darsman.com/course/aggregation-operations-in-mongodb/)

قابلیت‌های Atlas، Enterprise و driverها ممکن است نسخه‌محور باشند. محتوای دوره مبانی و روش تصمیم‌گیری را آموزش می‌دهد؛ پیش از اعمال تنظیمات production، مرجع رسمی همان نسخه را بازبینی کنید. منابع این دوره از مرور هدفمند مستندات و مطالب منتشرشده انتخاب شده‌اند؛ ادعای پوشش لفظی تمام اینترنت را نمی‌کنند.

بازبینی منابع: 2026-11-11.
