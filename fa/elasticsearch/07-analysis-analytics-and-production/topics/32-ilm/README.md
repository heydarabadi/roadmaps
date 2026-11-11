# ILM

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/32-ilm/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 32

## هدف این درس
در این مبحث، ILM را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Index Lifecycle Management policy مجموعه‌ای از phase و actionهاست: نگهداری روی tier مناسب، rollover/force merge در صورت نیاز، و delete طبق retention. نام و پشتیبانی actionها و tierها وابسته به نسخه/deployment است. Policy به index/data stream از طریق template یا attach متصل می‌شود؛ صرف تعریف policy اجرا را ثابت نمی‌کند.

~~~http
GET /events-*/_ilm/explain
~~~
پاسخ phase/action فعلی و خطا را نشان می‌دهد. تمرین: برای رخدادها retention مشخص بساز، policy را روی data stream آزمایش و transition هر phase را تأیید کن. پیش از delete، backup، نیاز حقوقی و time origin را بازبینی کن.

## خودآزمایی
1. ILM چه چیزی را مدیریت می‌کند؟ پاسخ: انتقال/اقدام‌های چرخهٔ عمر index یا backing index بر پایهٔ policy.
2. policy متصل اما اجرا نشد؛ چه می‌کنی؟ پاسخ: explain، alias/data stream، template و action prerequisites را بررسی می‌کنم.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20ILM)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


