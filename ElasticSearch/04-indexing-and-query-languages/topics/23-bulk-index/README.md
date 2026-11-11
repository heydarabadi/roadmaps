# Bulk index

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 23

## هدف این درس
در این مبحث، Bulk index را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Bulk API چند action و سند را در قالب NDJSON می‌گیرد: یک خط metadata و برای index/create/update معمولاً خط body؛ delete فقط metadata دارد. بعد از هر action newline بگذار و JSON array نفرست. پاسخ هر item می‌تواند جداگانه موفق یا ناموفق باشد.

~~~http
POST /_bulk
{"index":{"_index":"products-v1","_id":"sku-101"}}
{"title":"ماوس بی‌سیم","price":950000}
{"delete":{"_index":"products-v1","_id":"old-1"}}
~~~
تمرین: یک bulk شامل سند سالم و mapping نادرست بفرست؛ errors و item status را جدا بررسی کن. retry فقط برای itemهای قابل‌تکرار انجام شود و 429 را با backoff مدیریت کن؛ کل batch را بی‌فکر دوباره نفرست.

## خودآزمایی
1. Bulk چه صرفه‌ای دارد؟ پاسخ: چند عملیات را در یک درخواست می‌فرستد و overhead شبکه را کم می‌کند.
2. HTTP 200 تضمین همهٔ itemها است؟ پاسخ: خیر؛ فیلد errors و پاسخ تک‌تک itemها را بررسی و شکست‌ها را retry کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Bulk%20index)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


