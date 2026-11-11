# Source Filtering

[English version](../../../../../en/elasticsearch/05-search-results-and-maintenance/topics/04-source-filtering/README.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 04

## هدف این درس
در این مبحث، Source Filtering را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
`_source` متن/ساختار اصلی سند است که معمولاً در hit برمی‌گردد. source filtering با includes/excludes payload را کاهش می‌دهد و انتقال/serialization را کمتر می‌کند، اما معادل حذف field از index یا کنترل دسترسی نیست.

~~~http
POST /products-v1/_search
{"_source":["product_id","title","price"],"query":{"term":{"available":true}}}
~~~
فهرست فیلدهای لازم response را از نیاز client بساز؛ از wildcard گسترده که فیلد داخلی را برگرداند دوری کن. تمرین: response کامل و محدود را مقایسه و حجم را ثبت کن. اگر محرمانه‌بودن حیاتی است field/document-level security و API boundary را پیاده کن.

## خودآزمایی
1. source filtering چه می‌کند؟ پاسخ: فیلدهای بازگشتی از `_source` را محدود می‌کند، نه اینکه mapping را تغییر دهد.
2. آیا محرمانگی را تضمین می‌کند؟ پاسخ: خیر؛ مجوز document/field و کنترل API همچنان لازم است.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Source%20Filtering)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


