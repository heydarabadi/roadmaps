# Boosting Queries

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/28-boosting-queries/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 28

## هدف این درس
در این مبحث، Boosting Queries را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Boost وزن relative یک clause را در score تغییر می‌دهد. عنوان را ممکن است از توضیح مهم‌تر بخواهی؛ مقدارها را از کم شروع و با relevance judgments تنظیم کن. boost برای filter فایدهٔ رتبه‌ای ندارد، چون filter score نمی‌سازد.

~~~http
POST /products-v1/_search
{"query":{"multi_match":{"query":"هدفون بی‌سیم","fields":["title^3","description"]}}}
~~~
عنوان 3 برابر اهمیت داده شده، نه اینکه score دقیقاً همیشه سه برابر شود. تمرین: top-k را پیش/پس مقایسه و queryهایی که بدتر شدند ثبت کن.

## خودآزمایی
1. boost چه اثری دارد؟ پاسخ: سهم score یک query/field را در رتبه تغییر می‌دهد؛ تضمین نتیجهٔ بالاتر نیست.
2. چطور boost را انتخاب می‌کنی؟ پاسخ: روی مجموعهٔ query و نتیجهٔ مورد انتظار مقایسه می‌کنم، نه با حدس یک query.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Boosting%20Queries)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


