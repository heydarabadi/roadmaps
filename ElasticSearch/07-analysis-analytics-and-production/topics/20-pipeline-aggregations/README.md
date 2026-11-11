# Pipeline Aggregations

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 20

## هدف این درس
در این مبحث، Pipeline Aggregations را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Pipeline aggregation از خروجی aggregationهای sibling/parent استفاده می‌کند تا derivative، moving function یا bucket selector بسازد. ترتیب و مسیر metric باید درست باشد؛ این عملیات سندهای تازه را دوباره query نمی‌کنند.

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"by_day":{"date_histogram":{"field":"created_at","calendar_interval":"day"},"aggs":{"sales":{"sum":{"field":"total"}},"daily_change":{"derivative":{"buckets_path":"sales"}}}}}}
~~~
تمرین: فروش روزانه و تغییر روزبه‌روز را روی چند روز تست کن؛ اولین bucket derivative ندارد. مسیر اشتباه یا bucket خالی را در پاسخ و خطا بررسی کن.

## خودآزمایی
1. pipeline aggregation روی چه چیزی کار می‌کند؟ پاسخ: bucket/value خروجی aggregationهای دیگر، نه مجموعهٔ خام سندها.
2. چرا مسیر aggregation مهم است؟ پاسخ: pipeline باید parent/child bucket و metric path درست را دریافت کند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/aggregations/pipeline)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Pipeline%20Aggregations)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


