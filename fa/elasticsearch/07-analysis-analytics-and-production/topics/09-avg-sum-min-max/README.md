# Avg / Sum / Min / Max

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/09-avg-sum-min-max/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 09

## هدف این درس
در این مبحث، Avg / Sum / Min / Max را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Sum/avg/min/max metric aggregationها روی عددها محاسبه می‌شوند. قبل از تفسیر مشخص کن query کدام cohort را انتخاب کرده، field missing/null را چگونه دارد و واحد پول/اندازه چیست. avg میانگین valueهای موجود است؛ برای arrays، چند value از یک سند می‌تواند سهم داشته باشد.

~~~http
POST /orders-v1/_search
{"size":0,"query":{"term":{"status":"paid"}},"aggs":{"revenue":{"sum":{"field":"total"}},"mean":{"avg":{"field":"total"}},"min":{"min":{"field":"total"}},"max":{"max":{"field":"total"}}}}
~~~
تمرین: نتیجه را با جمع مستقل روی چند سند مقایسه کن. برای گزارش مالی rounding و currency conversion را بیرون از فرض aggregation تعریف کن.

## خودآزمایی
1. avg چه مقدارهایی را لحاظ می‌کند؟ پاسخ: valueهای عددی موجود روی اسناد matchشده؛ missingها میانگین را عوض می‌کنند چون حذف می‌شوند.
2. sum=0 لزوماً یعنی داده صفر است؟ پاسخ: خیر؛ ممکن است هیچ مقدار قابل‌جمعی وجود نداشته باشد؛ count/exists را هم بخوان.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Avg%20%2F%20Sum%20%2F%20Min%20%2F%20Max)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


