# Dates

[English version](README.en.md)


> فصل 03: نوع داده و نقش نودها · درس 07

## هدف این درس
Date مقدار زمانی را parse می‌کند؛ timezone، format، precision و مرز بازه را ثابت و مستند کن.
## تدریس عمیق

### Date، timezone و بازه‌ی زمانی
Date field مقدار زمانی را با قالب قابل‌تفسیر index می‌کند تا range، sort، date histogram و محاسبه‌ی بازه اجرا شوند. فرمت ورودی را ثابت کن و برای سرویس‌ها UTC یا timezone با offset روشن به‌کار ببر.
دو زمان را از هم جدا نگه دار: event time وقتی اتفاق افتاد و ingest time وقتی Elasticsearch آن را دریافت کرد. اختلاف این دو به اندازه‌گیری تأخیر pipeline کمک می‌کند. تاریخ‌های مبهم محلی یا ترکیب timestampهای بدون timezone باعث می‌شود سند در بازه‌ی زمانی نادرست بیفتد.
در query، مرزها را با gte و lt/ lte صریح تعیین کن. بازه‌ی یک روز محلی ممکن است با UTC یکی نباشد؛ timezone گزارش را به نیاز کسب‌وکار وصل کن. خطای رایج، تبدیل خاموش و ناسازگار timezone در producerهاست.

## خودآزمایی
1. چرا ISO-8601 با timezone مناسب است؟ پاسخ: ابهام منطقه/offset را کم و مقایسهٔ زمانی را روشن می‌کند.
2. اگر timezone در timestamp نیاید چه می‌شود؟ پاسخ: معمولاً UTC تفسیر می‌شود؛ اگر producer منظورش ساعت محلی باشد، instant اشتباه می‌شود.
## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Dates)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



