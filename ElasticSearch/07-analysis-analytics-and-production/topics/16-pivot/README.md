# Pivot

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 16

## هدف این درس
در این مبحث، Pivot را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Pivot دادهٔ رویداد یا تراکنش را بر اساس کلیدهای group-by به سندهای خلاصه تبدیل می‌کند، مثلاً مجموع فروش بر اساس روز و برند. Transform این view را در destination index نگه می‌دارد؛ تعریف fieldها، destination، sync و retention را طراحی کن.

~~~json
{"group_by":{"brand":{"terms":{"field":"brand"}}},"aggregations":{"total_sales":{"sum":{"field":"price"}}}}
~~~
این بخش پیکربندی مفهومی pivot است؛ ساخت transform کامل از API/نسخه پیروی می‌کند. تمرین: خروجی را با aggregation مستقیم برای یک بازه تطبیق بده و اختلاف checkpoint/lag را توضیح بده.

## خودآزمایی
1. pivot transform چه خروجی می‌سازد؟ پاسخ: سندهای خلاصه‌شده با group-by field و metricها.
2. چرا خروجی را منبع حقیقت تلقی نمی‌کنیم؟ پاسخ: مشتق‌شده و وابسته به checkpoint/source است؛ lag و صحت transform باید پایش شود.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Pivot)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


