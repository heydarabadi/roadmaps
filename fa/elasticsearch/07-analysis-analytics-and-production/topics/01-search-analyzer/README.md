# Search Analyzer

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/01-search-analyzer/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 01

## هدف این درس
در این مبحث، Search Analyzer را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Analyzer سمت جست‌وجو ورودی کاربر را به tokenهایی تبدیل می‌کند که با indexشده‌ها تطبیق‌پذیر باشند. می‌توان analyzer زمان index و search را جدا تعیین کرد؛ مثلاً هنگام index stemming و هنگام search synonym. اگر قواعد ناسازگار باشند query ممکن است واژه‌ای را جست‌وجو کند که اصلاً در index نیست.

~~~json
{"properties":{"title":{"type":"text","analyzer":"standard","search_analyzer":"standard"}}}
~~~
تمرین: title فارسی را با Analyze API در هر دو مسیر بررسی و جست‌وجوی «کتاب‌ها» را با دادهٔ نماینده بسنج. analyzer فیلد موجود را بی‌هزینه عوض نمی‌کند؛ تغییر index-time معمولاً reindex می‌خواهد.

## خودآزمایی
1. search_analyzer روی چه چیزی اجرا می‌شود؟ پاسخ: متن query در زمان search؛ باید با tokenهای ساخته‌شده در زمان index سازگار باشد.
2. چرا قبل از تغییر آن آزمون می‌سازیم؟ پاسخ: تغییر tokenization می‌تواند recall/precision را عوض کند؛ Analyze API و queryهای واقعی را مقایسه می‌کنیم.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Search%20Analyzer)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


