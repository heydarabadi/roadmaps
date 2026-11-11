# Segment Merging

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/24-segment-merging/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 24

## هدف این درس
در این مبحث، Segment Merging را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
هر shard مجموعه‌ای از segmentهای immutable دارد. Refresh segment قابل‌جست‌وجو می‌سازد؛ merge پس‌زمینه segmentها را ادغام و tombstone حذف‌شده‌ها را آزاد می‌کند. تعداد زیاد segment هزینهٔ search را بالا می‌برد ولی merge هم CPU و I/O مصرف می‌کند؛ refresh و ingest نرخ را تنظیم کن.

~~~http
GET /_cat/segments/products-v1?v
~~~
تمرین: تعداد segment و merge activity را قبل/بعد از bulk و refresh interval بلندتر ببین. Force merge را برای index عمدتاً read-only و با برنامهٔ ظرفیت بررسی کن، نه به‌عنوان درمان هر latency.

## خودآزمایی
1. چرا segment merge می‌شود؟ پاسخ: تعداد segment را کم و فضای سندهای حذف‌شده را قابل‌بازیابی می‌کند.
2. چرا force merge روتین خطر دارد؟ پاسخ: I/O و فضای موقت/منابع سنگین مصرف می‌کند و برای index در حال نوشتن می‌تواند زیان‌بار باشد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Segment%20Merging)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


