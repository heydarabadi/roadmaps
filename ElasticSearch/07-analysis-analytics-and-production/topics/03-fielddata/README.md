# fielddata

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 03

## هدف این درس
در این مبحث، fielddata را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Text برای inverted index ساخته می‌شود و fielddata می‌تواند tokenهای آن را در heap آماده کند تا sort/aggregation ممکن شود. برای متن پرتکرار یا cardinality بالا حافظه‌بر و عامل فشار GC است. بیشتر مواقع multi-field keyword با doc values نیاز را بهتر حل می‌کند.

~~~http
PUT /products-v1/_mapping
{"properties":{"title":{"type":"text","fields":{"keyword":{"type":"keyword"}}}}}
~~~
از `title.keyword` برای terms و sort استفاده کن. تمرین: مصرف heap را پیش و پس از aggregation روی فیلد مناسب اندازه بگیر. fielddata را فقط با ضرورت روشن و کنترل هزینه انتخاب کن.

## خودآزمایی
1. fielddata چیست؟ پاسخ: دادهٔ تحلیلی text که هنگام نیاز به heap بارگذاری می‌شود تا aggregation/sort انجام شود.
2. چرا معمولاً از آن دوری می‌کنیم؟ پاسخ: heap و GC را می‌تواند شدیداً افزایش دهد؛ keyword subfield راه امن‌تر رایج است.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20fielddata)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


