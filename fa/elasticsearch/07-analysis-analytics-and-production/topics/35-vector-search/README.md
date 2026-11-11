# Vector Search

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/35-vector-search/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 35

## هدف این درس
در این مبحث، Vector Search را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Vector search نزدیک‌ترین بردارها را با similarity تعریف‌شده می‌یابد. ابتدا متن/داده را با یک embedding model تبدیل کن؛ همان model/version/preprocessing و ابعاد را برای query حفظ کن. Dense vector mapping باید dims و similarity سازگار داشته باشد. approximate kNN سریع‌تر مقیاس می‌گیرد اما recall به candidate count و index parameters وابسته است.

~~~http
POST /products-v1/_search
{"knn":{"field":"embedding","query_vector":[0.12,0.08,0.31],"k":10,"num_candidates":100}}
~~~
بردار سه‌بعدی صرفاً شماتیک است؛ ابعاد واقعی از مدل می‌آید. تمرین: recall@10 را با candidateهای متفاوت و query set قضاوت‌شده مقایسه کن. filter، هزینهٔ embedding و مدل فارسی را نیز در سنجش production لحاظ کن.

## خودآزمایی
1. چرا ابعاد embedding باید منطبق باشد؟ پاسخ: بردار query و فیلد باید فضای یکسان و طول ثابت داشته باشند.
2. num_candidates چه trade-offی دارد؟ پاسخ: افزایشش recall احتمالی را بهتر ولی زمان/منابع را بیشتر می‌کند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/solutions/search/vector)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Vector%20Search)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


