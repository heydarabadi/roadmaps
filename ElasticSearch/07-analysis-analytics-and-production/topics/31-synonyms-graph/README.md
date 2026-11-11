# Synonyms Graph

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 31

## هدف این درس
در این مبحث، Synonyms Graph را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Synonym graph token filter می‌تواند یک واژه را به چندمعادل و حتی عبارت چندواژه‌ای گسترش دهد و position graph را حفظ کند؛ برای search analyzer مناسب است. ترتیب با stop filter و stemming مهم است؛ قوانین نامعتبر یا مجموعهٔ خیلی بزرگ می‌تواند reload/حافظه را مختل کند.

~~~json
{"filter":{"synonyms_graph":{"type":"synonym_graph","synonyms":["laptop, notebook","هدفون, هدست"]}}}
~~~
بخش filter باید در analyzer settings تعریف شود. تمرین: query یک معادل را روی سندی با واژهٔ دیگر بیازمای و false positive را بررسی کن. تغییر synonym set را نسخه‌بندی و با query set واقعی ارزیابی کن.

## خودآزمایی
1. synonym graph چرا به کار می‌رود؟ پاسخ: نگاشت هم‌معنی و چندواژه‌ای را در جست‌وجو با حفظ مسیرهای token درست مدیریت کند.
2. چرا غالباً در search analyzer استفاده می‌شود؟ پاسخ: می‌توان قوانین را تغییر داد بی‌آنکه همهٔ سندها دوباره index شوند؛ اما عملکرد و version را بررسی کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/solutions/search/full-text/search-with-synonyms)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Synonyms%20Graph)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


