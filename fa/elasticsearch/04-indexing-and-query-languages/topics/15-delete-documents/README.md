# Delete Documents

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/15-delete-documents/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 15

## هدف این درس
در این مبحث، Delete Documents را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
حذف سند با `_id` برای حذف رکورد معلوم مناسب است. حذف منطقی/فیزیکی را با نیاز retention و audit بسنج؛ در Lucene حذف، tombstone می‌سازد و پاک‌شدن فضا فوری نیست. برای حذف گروهی Delete by Query شرط دقیق، dry-run با search، تعداد مورد انتظار و پایش task می‌خواهد.

~~~http
DELETE /products-v1/_doc/sku-100
~~~
تمرین: ابتدا سند هدف را با query بخوان، سپس تعداد hit را با برآورد کسب‌وکاری تطبیق بده و بعد حذف کن. برای دادهٔ شخصی، سیاست قانونی نگهداری و حذف backupها را هم در نظر بگیر.

## خودآزمایی
1. حذف سند با ID در برابر Delete by Query چه تفاوتی دارد؟ پاسخ: اولی دقیق و مستقیم است؛ دومی چند سند مطابق predicate را taskوار حذف می‌کند.
2. حذف فیزیکی لحظه‌ای است؟ پاسخ: نه، سند حذف‌شده علامت می‌خورد و فضای segment بعداً با merge آزاد می‌شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Delete%20Documents)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


