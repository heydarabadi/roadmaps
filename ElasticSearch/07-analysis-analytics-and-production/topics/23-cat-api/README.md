# CAT API

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 23

## هدف این درس
در این مبحث، CAT API را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
CAT API خروجی جدولی از وضعیت index، shard، node و task ارائه می‌دهد و برای اپراتور در terminal سریع و خواناست. خروجی متنی آن برای parser برنامه‌نویسی شکننده‌تر از JSON API است؛ برای automation و monitoring از Cluster Stats، Nodes Stats یا Index Stats استفاده کن.

~~~http
GET /_cat/indices?v&s=store.size:desc
GET /_cat/shards?v
~~~
تمرین: indexهای بزرگ را پیدا و وضعیت shard را بررسی کن. CAT فقط نمای نقطه‌ای است؛ trend heap/latency/rejection را از monitoring time series بگیر.

## خودآزمایی
1. CAT API برای چه کسی مفید است؟ پاسخ: مشاهدهٔ سریع انسان‌خوان در ترمینال.
2. برای automation پایدار انتخاب اول است؟ پاسخ: معمولاً خیر؛ APIهای JSON با schema مناسب برنامه‌نویسی را به‌کار ببر.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/rest-apis)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20CAT%20API)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


