# Filter Aggregations

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 15

## هدف این درس
در این مبحث، Filter Aggregations را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Filter aggregation یک bucket تک‌گروهی می‌سازد که فرزندهایش فقط روی سندهای مطابق اجرا می‌شوند. برای مقایسهٔ کل فروش با فروش کالاهای موجود یا دورهٔ خاص مفید است؛ برای چند دستهٔ ثابت filters aggregation مناسب‌تر است.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"available":{"filter":{"term":{"available":true}},"aggs":{"avg_price":{"avg":{"field":"price"}}}}}}
~~~
query بیرونی می‌تواند تمام محصول‌ها را نگه دارد و این agg زیرمجموعه را تحلیل کند. تمرین: دو filter agg برای موجود و ناموجود بساز؛ مطمئن شو جمعیت هرکدام روشن است.

## خودآزمایی
1. filter aggregation چه می‌کند؟ پاسخ: یک aggregation فرزند را فقط روی سندهای مطابق filter اجرا می‌کند.
2. فرق query filter و filter aggregation چیست؟ پاسخ: query population اصلی Search را محدود می‌کند؛ filter aggregation زیرجمعیت جدا را در همان پاسخ می‌سازد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Filter%20Aggregations)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


