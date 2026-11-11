# Get Document

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/13-get-document/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 13

## هدف این درس
در این مبحث، Get Document را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Get Document رکورد را با index و `_id` می‌خواند؛ برای lookup مستقیم مناسب است اما query روی فیلدها را نمی‌سنجد. `_source` سند اصلی است؛ با includes/excludes payload را محدود کن. نتیجهٔ 404 می‌تواند ناشی از index، ID یا routing نادرست باشد.

~~~http
GET /products-v1/_doc/sku-100?_source_includes=product_id,title,price
~~~
تمرین: سندی را index، با Get بخوان و بلافاصله با Search جست‌وجو کن؛ تفاوت visibility را بررسی کن. endpoint عمومی را به همهٔ فیلدهای `_source` باز نکن؛ مجوز و داده‌های حساس را در نظر بگیر.

## خودآزمایی
1. Get by ID با Search چه فرقی دارد؟ پاسخ: Get با شناسه مستقیم و realtime می‌خواند؛ Search query را بر نمای near-real-time اجرا می‌کند.
2. چرا source filtering مهم است؟ پاسخ: payload را کم و نشت فیلد داخلی/غیرلازم را محدود می‌کند.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Get%20Document)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


