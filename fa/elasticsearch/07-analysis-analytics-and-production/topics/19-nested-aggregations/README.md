# Nested Aggregations

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/19-nested-aggregations/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 19

## هدف این درس
در این مبحث، Nested Aggregations را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
برای nested field، aggregation باید داخل nested path وارد child documents شود؛ terms و metricهای آن فضا روی nested objectها عمل می‌کنند. خروجی child count الزاماً تعداد parent productها نیست. `reverse_nested` به سطح والد برمی‌گردد.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"offers":{"nested":{"path":"offers"},"aggs":{"by_seller":{"terms":{"field":"offers.seller"}}}}}}
~~~
تمرین: محصولی با چند offer بساز و doc_count را با تعداد کالاهای والد مقایسه کن. ساخت nested query و nested aggregation را با هم قاطی نکن؛ هرکدام جایگاه جدا در بدنهٔ درخواست دارند.

## خودآزمایی
1. nested aggregation از کجا شروع می‌کند؟ پاسخ: از path فیلد nested و فضای child objectها.
2. برای بازگشت به parent چه لازم است؟ پاسخ: reverse_nested aggregation، اگر شمارش/metric والد مدنظر باشد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Nested%20Aggregations)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


