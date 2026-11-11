# Value Count

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/08-value-count/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 08

## هدف این درس
در این مبحث، Value Count را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Value count metric تعداد valueهای یک field را در جمعیت query می‌شمارد. اگر field آرایه‌ای باشد یک سند ممکن است چند مقدار بدهد؛ null/missing معمولاً count اضافه نمی‌کند. بنابراین metric آن را با تعداد سندها اشتباه نگیر.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"brand_values":{"value_count":{"field":"brand"}}}}
~~~
تمرین: یک سند با دو brand و یکی با brand missing بساز و count را با hits.total مقایسه کن. برای سندهای دارای field از missing/exists یا filter aggregation بر حسب سؤال استفاده کن.

## خودآزمایی
1. value_count چه می‌شمارد؟ پاسخ: تعداد مقدارهای field در سندهای matchشده؛ آرایه می‌تواند چند مقدار از یک سند بدهد.
2. با doc_count یکسان است؟ پاسخ: نه؛ doc_count تعداد سندهای bucket و value_count تعداد field valueهاست.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/aggregations/search-aggregations-metrics-valuecount-aggregation)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Value%20Count)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


