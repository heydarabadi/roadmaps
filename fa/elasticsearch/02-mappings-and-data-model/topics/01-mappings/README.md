# Mappings

[English version](../../../../../en/elasticsearch/02-mappings-and-data-model/topics/01-mappings/README.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 01

## هدف این درس
Mapping قرارداد type، تحلیل، exact matching و قابلیت aggregation را تعریف می‌کند؛ queryها را پیش از ingest به طراحی schema وصل کن.
## Mapping در عمل

### Mapping در عمل
هر field در mapping دست‌کم سه پرسش را پاسخ می‌دهد: مقدار چه نوعی است، متن چگونه تحلیل شود و چه عملیات‌هایی روی آن لازم است؟ Mapping فقط validation نیست. Keyword برای مقایسه‌ی exact، sort و bucket؛ text برای full-text؛ عدد برای range/sum؛ date برای بازه‌ی زمانی و geo_point برای query مکانی انتخاب می‌شود.
قبل از ساخت index، queryهای محصول را فهرست کن. اگر title را هم متن‌جست‌وجو و هم sort می‌کنی، multi-field بساز. اگر فیلدی هیچ query یا aggregation لازم ندارد، بررسی کن آیا index شدن آن ارزش هزینه‌ی ذخیره و ساخت را دارد.
~~~http
PUT /products-v1
{"mappings":{"properties":{"title":{"type":"text","fields":{"raw":{"type":"keyword"}}},"price":{"type":"scaled_float","scaling_factor":100},"created_at":{"type":"date"}}}}
~~~
Mapping را با چند سند واقعی بررسی کن و خروجی GET /products-v1/_mapping را نگه دار. تغییر analyzer یا نوع فیلد را migration بدان. افزودن property جدید معمولاً ممکن است؛ تغییر معنای bytes indexشده با update ساده انجام نمی‌شود.
خطای رایج این است که mapping را بعد از ingestهای زیاد طراحی کنند یا همه‌چیز را به dynamic واگذار کنند. پیشگیری: schema را در code review بررسی، templateها را version کن و برای تغییر ناسازگار index جدید بساز.

## خودآزمایی
1. title هم جست‌وجو و هم sort می‌شود؛ چه mappingی می‌سازی؟ پاسخ: text با multi-field keyword.
2. چه وقت reindex لازم است؟ پاسخ: تغییر ناسازگار type/analyzer یا بازسازی ساختار index.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Mappings)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



