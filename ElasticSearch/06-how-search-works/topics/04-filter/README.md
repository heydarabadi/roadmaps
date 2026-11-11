# filter

[English version](README.en.md)


> فصل 06: چگونه جست‌وجو کار می‌کند · درس 04

## هدف این درس
در این مبحث، filter را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
filter context شروط بولی بدون relevance score است؛ range قیمت، term وضعیت و مجوزهای دسترسی نمونه‌اند. cache ممکن است مفید شود ولی هر filter را cacheشده فرض نکن. قرار دادن ACL در UI کافی نیست؛ دسترسی باید در query سمت سرور محدود شود.

~~~http
POST /products-v1/_search
{"query":{"bool":{"filter":[{"term":{"available":true}},{"term":{"tenant_id":"t-42"}}]}}}
~~~
تمرین: با دادهٔ دو tenant مطمئن شو یک کاربر نمی‌تواند ID tenant دیگر را درخواست کند. filter فقط بخشی از authorization است؛ نقش/مجوز و بررسی همهٔ endpointها همچنان لازم است.

## خودآزمایی
1. filter score می‌سازد؟ پاسخ: نه؛ match/no-match تعیین می‌کند.
2. query یا filter برای ACL؟ پاسخ: filter، اما باید server-side و بدون امکان دورزدن در همهٔ مسیرهای درخواست اعمال شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20filter)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


