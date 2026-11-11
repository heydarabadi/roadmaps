# Filter

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 22

## هدف این درس
در این مبحث، Filter را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Filter context شرط‌های بولی را بدون امتیاز relevance اجرا می‌کند. term، range، exists و محدودیت‌های دسترسی غالباً در filter قرار می‌گیرند. Elasticsearch بعضی filterها را می‌تواند cache کند، اما روی این فرض که هر filter همیشه cache می‌شود یا بدون هزینه است برنامه‌ریزی نکن.

~~~http
POST /products-v1/_search
{"query":{"bool":{"filter":[{"term":{"available":true}},{"range":{"price":{"gte":1000000,"lte":5000000}}}]}}}
~~~
تمرین: شرط title را به must و قیمت را به filter بگذار؛ score و hitها را با هر دو در must مقایسه کن. ACL نیز باید در filter باشد و هرگز به کنترل سمت UI بسنده نکن.

## خودآزمایی
1. filter context score می‌سازد؟ پاسخ: نه؛ فقط match/no-match است و برای eligibility ساخت‌یافته مناسب است.
2. filter همیشه رایگان است؟ پاسخ: نه؛ هزینهٔ اجرا دارد؛ فقط relevance score را محاسبه نمی‌کند و cache نیز تضمین عمومی نیست.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Filter)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


