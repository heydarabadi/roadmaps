# Transform API

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/18-transform-api/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 18

## هدف این درس
در این مبحث، Transform API را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Transform API نمای خلاصهٔ قابل query برای dashboard و entity analysis می‌سازد. Pivot چندگروهی و aggregationها را خلاصه می‌کند؛ latest آخرین سند هر کلید را می‌سازد. Continuous mode دادهٔ تازه را در checkpointهای متوالی وارد می‌کند.

~~~http
GET _transform/_stats
~~~
آمار checkpoint، documents processed/indexed و failure را بخوان. تمرین: transform را با aggregation مستقیم مقایسه کن و هدفی برای acceptable lag بگذار. دسترسی، destination mapping، retention و توقف/تغییر transform را مستند کن؛ backing data را حذف نکن.

## خودآزمایی
1. Transform API چه هدفی دارد؟ پاسخ: ساخت و نگهداری entity-centric summary index از دادهٔ خام.
2. continuous transform چگونه پیش می‌رود؟ پاسخ: checkpointهای دوره‌ای را پردازش و تغییرهای جدید را sync می‌کند؛ lag و failure را باید دید.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Transform%20API)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


