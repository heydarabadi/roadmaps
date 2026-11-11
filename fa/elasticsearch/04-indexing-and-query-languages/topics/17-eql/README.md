# EQL

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/17-eql/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 17

## هدف این درس
در این مبحث، EQL را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
EQL برای eventهای دارای زمان و توالی رخدادها مناسب است؛ می‌توان مثلاً دید process اجرا شده و سپس اتصال شبکه رخ داده است. این با جست‌وجوی متن آزاد یا aggregation عادی فرق دارد: event category، timestamp، شناسهٔ میزبان/کاربر و window زمانی باید درست باشند.

~~~text
sequence by host.id with maxspan=5m [process where process.name == "powershell.exe"] [network where destination.port == 443]
~~~
نمونهٔ مفهومی است و نیاز به schema/نسخهٔ مناسب دارد. تمرین: دو event آزمایشی با timestamp و host یکسان بساز و شرط sequence را توضیح بده. دادهٔ خارج از پنجره، timestamp بد یا فیلد keyword نامناسب باعث false negative می‌شود.

## خودآزمایی
1. EQL برای چه چیزی ساخته شده؟ پاسخ: یافتن الگو و ترتیب رویدادها/sequence در دادهٔ زمانی، به‌ویژه تشخیص رفتار امنیتی.
2. چه پیش‌نیاز مهمی دارد؟ پاسخ: timestamp و category/event fields با mapping/data semantics درست و ترتیب زمانی مورد اتکا.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/eql)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20EQL)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


