# Data Nodes

[English version](README.en.md)


> فصل 03: نوع داده و نقش نودها · درس 03

## هدف این درس
Data node shardها و عملیات خواندن/نوشتن را میزبانی می‌کند؛ CPU، heap، disk و شبکه را متناسب workload سایز کن.
## تدریس عمیق

### Data node و shardها
Data node shardها را نگه می‌دارد و indexing، search و aggregation را اجرا می‌کند. توان آن به CPU، حافظه، storage، disk I/O، network و تعداد shardها وابسته است. افزایش node فقط وقتی کمک می‌کند که shardها امکان allocation داشته باشند و bottleneck واقعاً ظرفیت data باشد.
برای بررسی، disk watermarks، heap pressure، file-system cache، thread pool rejection، indexing/search latency و shard allocation را کنار هم ببین. Heap را کورکورانه بالا نبر؛ heap بسیار بزرگ می‌تواند cache سیستم‌عامل را کوچک کند و خواندن segmentها را کند سازد.
کار عملی: query و ingest را در peak بررسی و مصرف nodeها را مقایسه کن. اگر یک shard یا node دائماً داغ است، علت می‌تواند skew داده، routing یا shard sizing باشد، نه کمبود تعداد node به‌تنهایی.

## خودآزمایی
1. data node چه منابعی می‌خواهد؟ پاسخ: دیسک و I/O، heap، CPU و شبکه برای shard/query/indexing.
2. افزودن data node همیشه latency را کم می‌کند؟ پاسخ: نه؛ allocation، shard design، query و bottleneck باید بررسی شود.
## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Data%20Nodes)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



