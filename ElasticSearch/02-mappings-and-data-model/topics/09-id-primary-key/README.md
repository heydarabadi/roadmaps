# ID (Primary Key)

[English version](README.en.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 09

## هدف این درس
ID یکتا هویت سند است؛ ID پایدار retry و sync را idempotent می‌کند اما باید shard/routing و business key را لحاظ کرد.
## ID پایدار و idempotency

### ID پایدار و idempotency
_id شناسه‌ی سند در index است. Get، Update و Delete مستقیم از آن استفاده می‌کنند. اگر ID از کلید پایدار منبع اصلی بیاید، ارسال دوباره‌ی همان سند می‌تواند همان رکورد را به‌روز کند؛ این retry را idempotent می‌سازد. ID تصادفی تازه برای هر retry، duplicate تولید می‌کند.
اگر ID را خود Elasticsearch بسازد، پاسخ index آن ID را برمی‌گرداند و برنامه باید آن را برای عملیات بعد نگه دارد. در داده‌ی event، شناسه‌ی event یا کلید ترکیبی پایدار انتخاب کن. ID فقط در محدوده‌ی index یکتا است؛ دو index می‌توانند ID مشابه داشته باشند.
~~~http
PUT /products-v1/_doc/sku-100
{"title":"کیبورد مکانیکی","price":4200000}
GET /products-v1/_doc/sku-100
~~~
تغییر ID یک update ساده نیست؛ معمولاً سند جدید می‌نویسی و قدیمی را حذف می‌کنی. خطای رایج، تولید شناسه با timestamp یا random در هر retry است.


## خودآزمایی
1. ID تصادفی در retry چه مشکلی می‌سازد؟ پاسخ: سند تکراری با ID تازه ایجاد می‌شود.
2. چرا `_id` را فیلد business جایگزین نکنیم؟ پاسخ: sort/aggregation روی `_id` محدودیت دارد؛ فیلد keyword جداگانه map کن.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20ID%20(Primary%20Key))
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



