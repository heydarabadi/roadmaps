# Optimizing Bulk Indexing

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 24

## هدف این درس
در این مبحث، Optimizing Bulk Indexing را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
بهینه‌سازی bulk توازن throughput و فشار cluster است. از batch کوچک شروع کن، تعداد byte و سند را اندازه بگیر، parallel workerها را کم‌کم بالا ببر و indexing latency، heap، disk، merge و rejectedها را ثبت کن. آستانهٔ اندازهٔ واحد برای همهٔ سندها وجود ندارد؛ payload حجیم و mapping پیچیده رفتار متفاوت دارند.

~~~http
PUT /products-v1/_settings
{"index":{"refresh_interval":"30s"}}
~~~
در بارگذاری اولیه می‌توان refresh interval را موقتاً افزایش داد و پس از ingest به مقدار سرویس برگرداند؛ replica را فقط با برنامهٔ بازیابی تغییر بده. تمرین: throughput را در چند batch اندازه بگیر و نقطهٔ برگشت را با افزایش rejection/latency تعیین کن. خطای هر item را مستقل مدیریت کن.

## خودآزمایی
1. batch را تا کجا بزرگ می‌کنی؟ پاسخ: با benchmark تا نقطهٔ throughput مناسب، پیش از بالا رفتن latency/heap/timeout.
2. برای 429 چه می‌کنی؟ پاسخ: retry محدود با exponential backoff و jitter، نه retry storm.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Optimizing%20Bulk%20Indexing)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


