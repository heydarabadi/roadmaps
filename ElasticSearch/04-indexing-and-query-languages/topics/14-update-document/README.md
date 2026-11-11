# Update Document

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 14

## هدف این درس
در این مبحث، Update Document را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Update API در نهایت سند جدیدی برای همان ID می‌سازد؛ partial update به معنای ویرایش in-place روی Lucene نیست. برای یک فیلد از doc استفاده کن، و برای تغییر شرطی/افزایشی script کنترل‌شده. اگر سند را کامل از منبع داری، index کامل اغلب ساده‌تر و idempotentتر است.

~~~http
POST /products-v1/_update/sku-100
{"doc":{"price":3990000}}
~~~
نتیجه و version را بررسی کن. تمرین: update را دوبار اجرا کن و ببین عملیات set با increment چه تفاوت تکرارپذیری دارد. برای چند نویسنده دربارهٔ optimistic concurrency و retry با version conflict تصمیم بگیر.

## خودآزمایی
1. partial update با index کامل چه تفاوتی دارد؟ پاسخ: update فقط doc/script مشخص را تغییر می‌دهد، index سند کامل را جایگزین می‌کند.
2. update بدون محدودیت نرخ چه خطری دارد؟ پاسخ: هر تغییر سند هزینهٔ reindex همان سند دارد و رقابت/نسخه‌تعارض ایجاد می‌شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Update%20Document)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


