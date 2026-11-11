# Standard Analyzer

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/06-standard-analyzer/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 06

## هدف این درس
در این مبحث، Standard Analyzer را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Standard analyzer نقطهٔ شروع عمومی است: متن را به token می‌شکند و normalizationهای معمول اعمال می‌کند. separatorهای Unicode و قواعد حرف/عدد بر مرز token اثر دارند؛ زبان و domain خاص ممکن است به تنظیم بیشتر نیاز داشته باشند.

~~~http
POST /_analyze
{"analyzer":"standard","text":"Elasticsearch در جست‌وجوی متن"}
~~~
خروجی را مشاهده کن و با queryهای واقعی بسنج. تمرین: یک عبارت فارسی دارای نیم‌فاصله و واژهٔ لاتین را analyze کن؛ نتیجه را نه بر اساس حدس، بلکه با معیار recall/precision محصول تصمیم بگیر.

## خودآزمایی
1. standard analyzer از چه اجزایی ساخته شده؟ پاسخ: tokenizer استاندارد و filterهایی مانند lowercase، با قواعد متناسب با نسخه.
2. آیا برای فارسی بهترین انتخاب قطعی است؟ پاسخ: خیر؛ با corpus و انتظار زبان خودت ارزیابی کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/text-analysis/analysis-standard-analyzer)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Standard%20Analyzer)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


