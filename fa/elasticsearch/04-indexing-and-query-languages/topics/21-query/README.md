# Query

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/21-query/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 21

## هدف این درس
در این مبحث، Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Query context زمانی است که Elasticsearch می‌سنجد سند چقدر به عبارت مربوط است و score محاسبه می‌کند. match/full-text queryها نمونه‌اند. این score برای ترتیب نتایج است، نه احتمال. شرطی مثل «قیمت زیر X» معمولاً معیار ارتباط نیست؛ آن را filter کن تا معنای query روشن بماند.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":{"query":"سفر طولانی","boost":1.5}}}}
~~~
تمرین: title و description را با boostهای مختلف جست‌وجو و رتبهٔ top results را با query set بسنج. boost بزرگ لزوماً کیفیت را بهتر نمی‌کند؛ Explain برای علت رتبهٔ یک سند مناسب است.

## خودآزمایی
1. query context چه می‌کند؟ پاسخ: هم match را تعیین می‌کند و هم می‌تواند relevance score تولید کند.
2. همهٔ شروط را query context می‌گذاری؟ پاسخ: نه؛ شروط eligibility مانند قیمت و موجودی را معمولاً در filter قرار بده.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


