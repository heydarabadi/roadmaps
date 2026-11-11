# Range / Date Range

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/13-range-date-range/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 13

## هدف این درس
در این مبحث، Range / Date Range را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Range و date_range aggregation bucketهای با مرز مشخص می‌سازند؛ برای طبقه‌بندی قیمت، سن یا بازهٔ زمانی مفیدند. بازه‌ها معمولاً from را شامل و to را مستثنا می‌گیرند؛ مرزهای پیوسته/هم‌پوشان را آگاهانه تعریف کن. timezone و date format بر گروه زمانی اثر دارد.

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"revenue_bands":{"range":{"field":"total","ranges":[{"to":1000000},{"from":1000000,"to":5000000},{"from":5000000}]}}}}
~~~
تمرین: هر سند مرزی را دقیقاً در یک bucket قرار بده و countها را با کل cohort جمع بزن. بازهٔ تاریخ برای تقویم محلی نیاز به calendar/timezone درست دارد.

## خودآزمایی
1. range aggregation چه می‌کند؟ پاسخ: مقدارها را در bucketهای مرزی که تعیین کرده‌ای گروه‌بندی می‌کند.
2. مرزهای بازه را چطور تعریف می‌کنی؟ پاسخ: inclusive/exclusive بودن و timezone را بر اساس هدف گزارش صریح می‌کنم.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Range%20%2F%20Date%20Range)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


