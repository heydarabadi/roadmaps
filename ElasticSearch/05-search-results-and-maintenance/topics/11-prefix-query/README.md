# Prefix Query

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 11

## هدف این درس
در این مبحث، Prefix Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Prefix query termهایی را می‌یابد که با prefix داده‌شده آغاز می‌شوند. روی keyword برای autocomplete ساده قابل‌فهم است؛ روی text، prefix به tokenهای indexشده مربوط می‌شود، نه کل متن خام. prefix طولانی معمولاً فضای نامزد را محدودتر می‌کند؛ الگوی بسیار کوتاه می‌تواند پرهزینه شود.

~~~http
POST /products-v1/_search
{"query":{"prefix":{"product_id":"sku-1"}}}
~~~
تمرین: prefixهای 1، 3 و 6 حرفی را روی دادهٔ نماینده اندازه بگیر. برای autocomplete تعاملی، edge n-gram/search_as_you_type یا پیشنهادگر را با UX و هزینه مقایسه کن؛ prefix query به‌تنهایی همیشه کافی نیست.

## خودآزمایی
1. prefix query چه match می‌کند؟ پاسخ: termهایی که با ابتدای ورودی شروع می‌شوند.
2. چرا keyword معمولاً مناسب است؟ پاسخ: رشتهٔ کل مانند termها نمایه می‌شود و prefix معنی دقیق‌تری دارد؛ روی text prefix tokenهاست.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Prefix%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


