# Node (Instance)

[English version](../../../../../en/elasticsearch/02-mappings-and-data-model/topics/06-node-instance/README.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 06

## هدف این درس
Node process اجرایی عضو cluster است که role، منابع و shardها را میزبانی می‌کند؛ node را با index/shard اشتباه نگیر.
## Node چیست و چه نقشی دارد؟

### Node چیست و چه نقشی دارد؟
Node یک process در حال اجرای Elasticsearch است. هر node نام و تنظیمات دارد و با roleها مشخص می‌شود در مدیریت cluster، نگهداری داده، ingest یا جست‌وجو چه نقشی ایفا کند. در deployment کوچک یک node می‌تواند چند نقش داشته باشد؛ در بار بزرگ‌تر جداسازی نقش‌ها برای ظرفیت و پایداری مفید است.
Node باید به cluster درست join شود. بررسی node list، heap، CPU، disk، thread pool و rejected requests کمک می‌کند ببینی فشار از کدام بخش می‌آید. بالا بردن heap بدون توجه به حافظه‌ی سیستم‌عامل می‌تواند file-system cache را کم کند و search را کندتر کند.
~~~http
GET /_cat/nodes?v&h=name,roles,heap.percent,ram.percent,cpu,disk.used_percent
~~~
قبل از افزودن node جدید، مشخص کن چه منابعی کم است و آیا shard allocation اجازه‌ی توزیع می‌دهد. خطای رایج، افزودن node برای رفع هر مشکل بدون تشخیص bottleneck یا استفاده از node مدیریت برای queryهای پرهزینه است.

## خودآزمایی
1. node و shard چه تفاوتی دارند؟ پاسخ: node instance اجراست؛ shard بخش داده/ایندکس Lucene است که روی node میزبانی می‌شود.
2. یک node از دست برود چه چیزی تعیین‌کننده است؟ پاسخ: replicaهای تخصیص‌یافته، quorum/cluster state و ظرفیت باقی‌مانده.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Node%20(Instance))
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



