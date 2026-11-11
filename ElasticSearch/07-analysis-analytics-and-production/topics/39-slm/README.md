# SLM

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 39

## هدف این درس
در این مبحث، SLM را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Snapshot Lifecycle Management policy زمان‌بندی snapshot، نام‌گذاری، repository و retention را خودکار می‌کند. سلامت policy، snapshot success/failure، فضای repository و پاک‌سازی snapshot قدیمی را پایش کن.

~~~http
GET /_slm/status
GET /_slm/policy
~~~
تمرین: policy روزانه و retention متناسب با نیاز RPO بساز و آخرین snapshot موفق را به alert وصل کن. SLM موفقیت گرفتن snapshot را تضمین می‌کند، نه اینکه restore قابل‌استفاده است؛ recovery drill را جدا اجرا کن.

## خودآزمایی
1. SLM چه چیزی زمان‌بندی می‌کند؟ پاسخ: گرفتن و نگهداری snapshotها طبق policy.
2. SLM با ILM چه تفاوتی دارد؟ پاسخ: SLM چرخهٔ snapshot backup؛ ILM چرخهٔ عمر index/data stream را مدیریت می‌کند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20SLM)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


