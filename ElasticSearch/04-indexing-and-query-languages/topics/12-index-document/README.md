# Index Document

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 12

## هدف این درس
در این مبحث، Index Document را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Index Document سند کامل را می‌نویسد. `_doc/{id}` با ID مشخص ایجاد یا جایگزین می‌کند؛ `_create/{id}` اگر ID تکراری باشد conflict می‌دهد. ID را از کلید پایدار منبع بگیر تا retry سند تکراری نسازد. برای تغییر جزئی API Update معنای متفاوت دارد.

~~~http
PUT /products-v1/_doc/sku-100
{"product_id":"sku-100","title":"هدفون بی‌سیم","price":4200000}
~~~
پاسخ result/version را بخوان؛ موفقیت write با visibility در Search یکی نیست. تمرین: سند را با همان ID دوباره بفرست و اثر جایگزینی را ببین. read-after-write فوری را با refresh=wait_for فقط وقتی نیاز محصول دارد حل کن، نه برای همهٔ writeها.

## خودآزمایی
1. چرا ID ثابت به‌کار می‌بریم؟ پاسخ: retry و sync را قابل‌پیش‌بینی می‌کند؛ همان ID در index می‌تواند سند قبلی را جایگزین کند.
2. write موفق فوراً در Search است؟ پاسخ: نه؛ Search نزدیک‌به‌زمان‌واقعی است و بعد از refresh قابل‌دیدن می‌شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Index%20Document)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


