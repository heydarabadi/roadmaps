# Leaf vs Compound Queries

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/01-leaf-vs-compound-queries/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 01

## هدف این درس
در این مبحث، Leaf vs Compound Queries را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Leaf query یک واحد قابل ترکیب است: match متن را تحلیل می‌کند، term مقدار دقیق را می‌سنجد و range بازه را بررسی می‌کند. Compound query رفتار چند query را کنترل می‌کند؛ bool مهم‌ترین نمونه است و must، should، filter و must_not دارد. برای هر clause مشخص کن باید سند را حذف کند یا فقط رتبه را تغییر دهد.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"هدفون"}}],"filter":[{"range":{"price":{"lte":5000000}}}]}}}
~~~
عنوان relevance می‌سازد و قیمت eligibility را محدود می‌کند. تمرین: شرط برند ترجیحی به should اضافه و minimum_should_match را صریح کن. دام رایج: term روی text؛ برای متن زبان طبیعی match و برای مقدار دقیق keyword+term را انتخاب کن.

## خودآزمایی
1. تفاوت leaf و compound چیست؟ پاسخ: leaf مانند match/range یک شرط را می‌سنجد؛ compound مانند bool چند شرط و منطق ترکیبشان را تعیین می‌کند.
2. قیمت را کجا قرار می‌دهی؟ پاسخ: range در filter، چون شرط eligibility است و نباید relevance متن را بسازد.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Leaf%20vs%20Compound%20Queries)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


