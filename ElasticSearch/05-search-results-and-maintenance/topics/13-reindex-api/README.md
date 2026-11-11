# Reindex API

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 13

## هدف این درس
در این مبحث، Reindex API را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Reindex برای تغییر mapping/settings، انتقال index یا بازسازی داده به مقصد جدید است. مقصد را قبلش بساز؛ API سندها را از source می‌خواند و در dest می‌نویسد. پاسخ را از نظر total، created/updated، failures و version conflict بررسی کن. بزرگ‌بودن کار نیازمند slicing/throttle و پایش task است.

~~~http
POST /_reindex?wait_for_completion=false
{"source":{"index":"products-v1"},"dest":{"index":"products-v2"}}
~~~
async response task ID می‌دهد؛ task را poll/cancel کن. تمرین: schema را اصلاح و alias را بعد از count/query smoke comparison منتقل کن. تغییرات جاری source را رها نکن؛ reindex خودکار sync نیست و rollback plan لازم است.

## خودآزمایی
1. _reindex چه می‌کند؟ پاسخ: اسناد منبع را از طریق search خوانده و در مقصد index می‌کند.
2. آیا تغییرهای پس از شروع را sync می‌کند؟ پاسخ: خیر؛ dual-write/replay یا پنجرهٔ قطع و برنامهٔ cutover لازم است.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/reindex-indices)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Reindex%20API)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


