# Stats / Extended Stats

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/11-stats-extended-stats/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 11

## هدف این درس
در این مبحث، Stats / Extended Stats را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Stats مجموعه‌ای از metricهای پایه را در یک aggregation می‌دهد؛ Extended stats شاخص‌های پراکندگی مانند variance و standard deviation را اضافه می‌کند. همه بر valueهای موجود جمعیت query محاسبه می‌شوند، پس cohort و missingness مهم‌اند.

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"order_totals":{"extended_stats":{"field":"total"}}}}
~~~
تمرین: avg، min/max و standard deviation را روی دادهٔ عادی و دادهٔ دارای outlier مقایسه کن. این شاخص‌ها علت تغییر یا distribution کامل را توضیح نمی‌دهند؛ histogram/percentile و تحلیل domain را هم ببین.

## خودآزمایی
1. stats چه می‌دهد؟ پاسخ: count، min، max، avg و sum؛ extended_stats شاخص‌هایی مثل variance و standard deviation نیز می‌دهد.
2. انحراف معیار به‌تنهایی چه چیزی نمی‌گوید؟ پاسخ: شکل توزیع/علت را کامل نمی‌کند؛ outlier و skew را جدا تحلیل کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Stats%20%2F%20Extended%20Stats)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


