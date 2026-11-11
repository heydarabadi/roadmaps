# Index (Database)

[English version](../../../../../en/elasticsearch/02-mappings-and-data-model/topics/07-index-database/README.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 07

## هدف این درس
Index مجموعهٔ منطقی اسناد با mapping/settings و shardهاست؛ alias/data stream می‌تواند نام پایدار برنامه باشد.
## Index را با جدول اشتباه نگیر

### Index را با جدول اشتباه نگیر
Index نام و ظرف منطقی سندهای هم‌خانواده با mapping/settings مشترک است. این مفهوم برای طراحی و query شبیه table به نظر می‌رسد، اما مدل تراکنش، join و schema relational را ندارد. هر index به shardهای Lucene تقسیم می‌شود و تعداد shard اولیه روی معماری داده اثر دارد.
از نام versioned مثل products-v1 استفاده کن و نام پایدار برنامه را با alias نگه دار. بعداً می‌توانی products alias را از v1 به v2 منتقل کنی، بدون آنکه برنامه نام فیزیکی index را بداند. Data stream برای داده‌ی زمان‌دار و append-oriented مناسب است.
~~~http
PUT /products-v1
{"mappings":{"properties":{"sku":{"type":"keyword"},"title":{"type":"text"}}}}
PUT /_alias/products
{"actions":[{"add":{"index":"products-v1","alias":"products"}}]}
~~~
حذف index تمام داده و mapping آن را حذف می‌کند. قبل از delete مقصد، environment و backup را بررسی کن. خطای رایج این است که index را به‌عنوان منبع حقیقت غیرقابل‌بازسازی نگه دارند.

## خودآزمایی
1. index و relational database چه تفاوتی دارند؟ پاسخ: index namespace/search collection است، نه تراکنشی با همهٔ قابلیت‌های DB.
2. چرا alias مفید است؟ پاسخ: cutover بین index versionها را بدون تغییر نام client ممکن می‌کند.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Index%20(Database))
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



