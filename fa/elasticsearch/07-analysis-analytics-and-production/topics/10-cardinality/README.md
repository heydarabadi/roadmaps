# Cardinality

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/10-cardinality/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 10

## هدف این درس
در این مبحث، Cardinality را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Cardinality aggregation تعداد مقدار یکتا را تخمین می‌زند. روش تقریبی حافظه و زمان کمتری از نگه‌داشتن set کامل می‌خواهد؛ `precision_threshold` دقت/مصرف را کنترل می‌کند و تضمین exact نیست.

~~~http
POST /events-v1/_search
{"size":0,"aggs":{"unique_users":{"cardinality":{"field":"user.id","precision_threshold":3000}}}}
~~~
مقدار تنظیمی را بر اساس cardinality و حافظه بسنج. تمرین: روی sample کوچک مقدار exact را جدا محاسبه و تخمین Elasticsearch را مقایسه کن؛ dashboard شمارش کاربران یکتا مناسب است، صورت‌حساب مالی نه.

## خودآزمایی
1. cardinality چیست؟ پاسخ: تعداد مقدارهای یکتای field؛ در Elasticsearch اغلب تخمینی با HyperLogLog++ است.
2. برای حسابداری دقیق مناسب است؟ پاسخ: خیر؛ خطای برآورد و هزینه را با نیاز بسنج و منبع حقیقت دقیق داشته باش.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-cardinality-aggregation)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Cardinality)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


