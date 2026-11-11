# Text

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/05-text/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 05

## هدف این درس
در این مبحث، Text را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
فیلد text برای full-text search است. analyzer متن را به token تبدیل می‌کند؛ query از نوع match نیز تحلیل می‌شود تا واژه‌ها تطبیق داده شوند. text برای مقدار دقیق، sort و aggregation معمولاً مناسب نیست. اگر هم جست‌وجوی واژه‌ای و هم sort می‌خواهی، multi-field بساز.

~~~http
PUT /products-v1/_mapping
{"properties":{"title":{"type":"text","fields":{"keyword":{"type":"keyword"}}}}}
~~~
match را روی title و sort را روی title.keyword انجام بده. تمرین: با Analyze API عبارت «کیبورد مکانیکی» را ببین و توضیح بده term روی text چرا ممکن است نتیجه ندهد. تصور اینکه text رشتهٔ ذخیره‌شدهٔ دست‌نخورده است، باعث انتخاب query و mapping نادرست می‌شود.

## خودآزمایی
1. text چگونه جست‌وجو می‌شود؟ پاسخ: analyzer متن را به token تبدیل می‌کند؛ match متن query را نیز تحلیل می‌کند.
2. چطور عنوان را sort می‌کنی؟ پاسخ: multi-field از نوع keyword با doc values؛ fielddata روی text انتخاب عادی نیست.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Text)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


