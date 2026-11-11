# فصل 04: عملیات سند و زبان‌های Query / Leaf vs Compound Queries

[English version](../../../en/elasticsearch/04-indexing-and-query-languages/README.md)


## درس فصل
Create Index mapping/settings می‌سازد؛ حذف index مخرب است. APIهای سند با ID پایدار کار می‌کنند. Bulk چند عملیات NDJSON می‌فرستد، اما نتیجه‌ی هر item را جدا بررسی کنید. Primary shard داده‌ی اصلی و replica کپی برای افزونگی/خواندن است، نه backup. Leaf query یک field و compound چند شرط را می‌سنجد. Query DSL زبان JSON-native، ES|QL زبان pipe-based، EQL برای توالی رخداد، SQL رابط SQL-like و KQL فیلتر Kibana است. Lucene syntax متنی با DSL یکی نیست. object، nested و flattened را بر اساس رابطه‌ی داده انتخاب کنید.

## تمرین فصل
Index آزمایشی بساز، اسناد bulk کن، query ترکیبی بنویس و خطای یک item را مدیریت کن.

## موضوع‌های این فصل
- [Leaf vs Compound Queries](topics/01-leaf-vs-compound-queries/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/01-leaf-vs-compound-queries/README.md)
- [Primary Shards](topics/02-primary-shards/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/02-primary-shards/README.md)
- [Replica Shards](topics/03-replica-shards/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/03-replica-shards/README.md)
- [The "Split Brain" Problem](topics/04-the-split-brain-problem/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/04-the-split-brain-problem/README.md)
- [Text](topics/05-text/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/05-text/README.md)
- [Keyword](topics/06-keyword/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/06-keyword/README.md)
- [Object](topics/07-object/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/07-object/README.md)
- [Nested](topics/08-nested/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/08-nested/README.md)
- [Flattened](topics/09-flattened/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/09-flattened/README.md)
- [Create Index](topics/10-create-index/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/10-create-index/README.md)
- [Delete Index](topics/11-delete-index/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/11-delete-index/README.md)
- [Index Document](topics/12-index-document/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/12-index-document/README.md)
- [Get Document](topics/13-get-document/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/13-get-document/README.md)
- [Update Document](topics/14-update-document/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/14-update-document/README.md)
- [Delete Documents](topics/15-delete-documents/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/15-delete-documents/README.md)
- [Query DSL](topics/query-dsl/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/query-dsl/README.md)
- [ES|QL](topics/16-es-ql/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/16-es-ql/README.md)
- [EQL](topics/17-eql/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/17-eql/README.md)
- [SQL](topics/18-sql/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/18-sql/README.md)
- [KQL](topics/19-kql/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/19-kql/README.md)
- [Lucene](topics/20-lucene/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/20-lucene/README.md)
- [Query](topics/21-query/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/21-query/README.md)
- [Filter](topics/22-filter/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/22-filter/README.md)
- [Bulk index](topics/23-bulk-index/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/23-bulk-index/README.md)
- [Optimizing Bulk Indexing](topics/24-optimizing-bulk-indexing/README.md) · [English](../../../en/elasticsearch/04-indexing-and-query-languages/topics/24-optimizing-bulk-indexing/README.md)

## منابع
- [مستند رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- [Reference کامل Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Roadmap](https://roadmap.sh/elasticsearch)

## تدریس کامل فصل: از سند تا query

### ساختار عملیات سند

Create Index را برای تعیین mapping و settings پیش از ingest به‌کار ببر. Index Document با ID مشخص سند را ایجاد یا جایگزین می‌کند؛ Get Document سند را با ID مستقیم می‌خواند؛ Update Document تغییر جزئی یا script را اجرا می‌کند؛ Delete Documents سند را حذف می‌کند. شناسه‌ی پایدار، retry و sync را قابل‌پیش‌بینی می‌کند. Delete Index کل index را حذف می‌کند و برای تغییر schema راهکار معمول نیست.

~~~http
PUT /products-v1/_doc/sku-100
{"title":"کیبورد مکانیکی","price":4200000,"available":true}
GET /products-v1/_doc/sku-100
POST /products-v1/_update/sku-100
{"doc":{"price":4000000}}
~~~

توجه کن index کردن سند کامل و update جزئی را با هم اشتباه نگیری. عملیات نوشتن سند را دوباره در search آزمایش کن؛ near real-time بودن باعث می‌شود Get مستقیم و Search همیشه در همان لحظه یک مسیر مشاهده نباشند.

### Query DSL و ترکیب شرط‌ها

Query DSL درخواست JSON است. Leaf query یک field را بررسی می‌کند؛ Bool query آن‌ها را در must، should، filter و must_not جمع می‌کند. must و should می‌توانند score بسازند؛ filter شرط بولی بدون relevance score است. برای شرط ساخت‌یافته مثل قیمت یا موجودی، filter معمولاً روشن‌تر و کم‌هزینه‌تر است.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"کیبورد مکانیکی"}}],"filter":[{"term":{"available":true}},{"range":{"price":{"lte":8000000}}}],"must_not":[{"term":{"status":"hidden"}}]}}}
~~~

متن عنوان را match کن تا analyzer سمت query کار کند؛ برای SKU دقیق از term روی keyword استفاده کن. اگر شروط چند فیلد باید روی همان عنصر آرایه برقرار باشند، nested query لازم است. Query را ابتدا روی چند سند کوچک اجرا کن و بعد روی داده‌ی نماینده evaluate کن.

### زبان‌های مختلف چه زمانی مفیدند؟

Query DSL بیشترین کنترل APIای را برای برنامه می‌دهد. ES|QL زبان pipe-based برای جست‌وجو و transform است و باید با قابلیت‌های همان نسخه مقایسه شود. EQL برای الگوها و sequence رخدادهای زمانی مناسب است. Elasticsearch SQL syntax آشنای SQL-like می‌دهد، ولی پایگاه رابطه‌ای با همه‌ی تراکنش‌ها و joinهای آن نیست. KQL زبان filter در Kibana است؛ Lucene query string هم syntax متنی جداست. این زبان‌ها قابل‌جایگزینی کامل نیستند.

### Shard، replica و کار انبوه

Primary shard بخشی از داده‌ی اصلی index را نگه می‌دارد. Replica کپی primary برای تحمل خرابی و افزایش read capacity است؛ backup نیست. Election/quorum مدرن از دو master متعارض جلوگیری می‌کند. برای بارگذاری حجیم، Bulk API چند عملیات NDJSON را در یک درخواست می‌فرستد، اما پاسخ هر item و فیلد errors را بررسی کن. Batch را آن‌قدر بزرگ نکن که memory، latency یا timeout بالا برود؛ throughput و خطا را با batch کوچک تا بزرگ اندازه‌گیری کن.

### تمرین پایان فصل

یک index آزمایشی بساز، ۱۰ کالا با Bulk وارد کن، query ترکیبی بنویس، پاسخ Get و Search را مقایسه کن، یک سند را update و یک مورد را delete کن. بعد پاسخ bulk را عمداً با یک سند نامعتبر آزمایش کن و item شکست‌خورده را از item موفق جدا کن.

