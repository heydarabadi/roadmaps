# Nested

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/08-nested/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 08

## هدف این درس
در این مبحث، Nested را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
nested هر عضو آرایه را در Lucene جدا index می‌کند تا رابطهٔ فیلدهایش حفظ شود. mapping را از ابتدا nested بساز؛ تبدیل object به nested برای index موجود معمولاً reindex می‌خواهد. برای آرایه‌هایی با هم‌عضوی مهم از nested و در غیر این صورت object استفاده کن.

~~~http
POST /products-v1/_search
{"query":{"nested":{"path":"offers","query":{"bool":{"must":[{"term":{"offers.seller":"A"}},{"range":{"offers.price":{"lte":100}}}]}}}}}
~~~
این query فروشنده و قیمت را در یک offer می‌سنجد. تمرین: offer اول seller=A ولی قیمت 150 و offer دوم price=80 ولی seller=B باشد؛ nested نباید کالا را برگرداند. برای نمایش عضو match شده از inner_hits استفاده کن.

## خودآزمایی
1. nested چه تضمینی می‌دهد؟ پاسخ: چند شرط query داخل یک nested query روی یک عضو child واحد ارزیابی می‌شوند.
2. trade-off چیست؟ پاسخ: هر nested object سند داخلی جدا می‌افزاید و index، query و aggregation را پرهزینه‌تر می‌کند.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Nested)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


