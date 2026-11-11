# Sorting

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 03

## هدف این درس
در این مبحث، Sorting را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Sort می‌تواند روی عدد، تاریخ، keyword یا `_score` باشد. هر shard نتیجهٔ محلی را مرتب می‌کند و coordinator merge می‌کند؛ نوع field و missing value در نتیجه مهم است. sort روی فیلدها ممکن است score را بی‌استفاده کند، پس `_score` را در اولویت مناسب قرار بده.

~~~http
POST /products-v1/_search
{"query":{"match":{"title":"هدفون"}},"sort":[{"_score":"desc"},{"price":"asc"},{"product_id":"asc"}]}
~~~
ترتیب: relevance، سپس قیمت، سپس ID برای tie. تمرین: محصول بدون price وارد کن و `missing` را مشخص کن. sort فیلدهای متعدد می‌تواند هزینهٔ doc values و حافظه داشته باشد؛ فقط نیاز UI را sort کن.

## خودآزمایی
1. چرا sort روی text مشکل دارد؟ پاسخ: text full-text field است و معمولاً doc values ندارد؛ keyword multi-field برای sort مناسب است.
2. score برابر چه می‌شود؟ پاسخ: ترتیب tie-breaker باید پایدار و ترجیحاً یکتا تعیین شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Sorting)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


