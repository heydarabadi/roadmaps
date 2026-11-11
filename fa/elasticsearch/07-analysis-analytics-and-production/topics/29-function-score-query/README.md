# Function Score Query

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/29-function-score-query/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 29

## هدف این درس
در این مبحث، Function Score Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Function score score پایهٔ query را با functionهایی مانند field_value_factor، decay یا random_score تعدیل می‌کند. `boost_mode` نحوهٔ ترکیب scoreها و `score_mode` ترکیب چند function را تعیین می‌کند؛ `max_boost`/min_score می‌تواند حد بگذارد.

~~~http
POST /products-v1/_search
{"query":{"function_score":{"query":{"match":{"title":"هدفون"}},"field_value_factor":{"field":"popularity","modifier":"log1p","missing":0},"boost_mode":"sum","max_boost":5}}}
~~~
تمرین: محصول پربازدید ولی نامرتبط را بساز و بررسی کن signal تجاری آن را به صدر نبرد. popularity را normalize و با offline ranking evaluation تنظیم کن.

## خودآزمایی
1. function_score چه زمانی به‌کار می‌رود؟ پاسخ: ترکیب score متنی با signalهایی مانند popularity، تازگی یا distance.
2. چرا decay function را محدود می‌کنی؟ پاسخ: signal نباید relevance اصلی را کاملاً بپوشاند یا با مقدار missing رفتار نامعلوم داشته باشد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-function-score-query)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Function%20Score%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


