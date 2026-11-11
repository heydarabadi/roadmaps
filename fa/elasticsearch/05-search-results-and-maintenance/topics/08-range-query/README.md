# Range Query

[English version](../../../../../en/elasticsearch/05-search-results-and-maintenance/topics/08-range-query/README.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 08

## هدف این درس
در این مبحث، Range Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Range query شرط‌های gt/gte/lt/lte روی فیلد عددی یا تاریخی را اعمال می‌کند. دقت کن inclusive بودن (gte/lte) یا exclusive بودن (gt/lt) مرز را تعیین می‌کند. تاریخ را با timezone و بازهٔ مطلوب محصول تعریف کن؛ ساعت محلی مبهم خطای مرزی می‌سازد.

~~~http
POST /orders-v1/_search
{"query":{"range":{"created_at":{"gte":"2026-01-01T00:00:00Z","lt":"2026-02-01T00:00:00Z"}}}
~~~
این بازه ژانویهٔ UTC را می‌گیرد. تمرین: midnight و timezone محلی را تست کن و سند مرزی را یک‌بار در query بینداز. برای قیمت هم واحد پول و scale را مشخص کن.

## خودآزمایی
1. range روی چه نوعی است؟ پاسخ: عدد و تاریخ/زمان؛ فیلد باید mapping سازگار داشته باشد.
2. چرا واحد زمان مهم است؟ پاسخ: timezone و قالب date می‌تواند مرز بازه را جابه‌جا کند؛ ورودی ISO-8601 و timezone روشن به‌کار ببر.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Range%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


