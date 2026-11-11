# Coordinating Nodes

[English version](README.en.md)


> فصل 03: نوع داده و نقش نودها · درس 04

## هدف این درس
Coordinating node درخواست را route و نتیجهٔ shardها را merge می‌کند؛ aggregation و responseهای بزرگ به حافظه/CPU نیاز دارند.
## تدریس عمیق

### Coordinating node و مرحله‌ی reduce
هر node می‌تواند درخواست را دریافت کند و نقش coordinating داشته باشد. این node درخواست search را به shardهای لازم می‌فرستد، پاسخ‌های جزئی را جمع می‌کند، reduce و مرتب‌سازی نهایی را انجام می‌دهد و پاسخ را به client می‌دهد.
در queryهای fan-out، پاسخ بزرگ، aggregation پرbucket یا page بزرگ، مرحله‌ی reduce می‌تواند CPU و heap مصرف کند. جداکردن coordinating-only node در کلاستر بزرگ گاهی فشار را کنترل می‌کند، اما در کلاستر کوچک ممکن است منابع بی‌دلیل مصرف کند.
برای بررسی، زمان درخواست، تعداد shardهای مشارکت‌کننده، حجم پاسخ و rejected در thread pool را بسنج. خطای رایج این است که تاخیر coordinator را به یک shard نسبت بدهند یا size و aggregation نامحدود درخواست کنند.

## خودآزمایی
1. coordinator چه نقشی دارد؟ پاسخ: fan-out درخواست به shardها و جمع/مرتب‌سازی پاسخ.
2. آیا هر cluster به dedicated coordinator نیاز دارد؟ پاسخ: وابسته به workload؛ ابتدا bottleneck را اندازه بگیر.
## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Coordinating%20Nodes)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



