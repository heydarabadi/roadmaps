# The "Split Brain" Problem

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/04-the-split-brain-problem/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 04

## هدف این درس
در این مبحث، The "Split Brain" Problem را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
در network partition، اگر هر سمت بتواند مستقل تغییرات cluster state را ثبت کند، دو رهبر و تاریخچهٔ متعارض پدید می‌آید. Elasticsearch جدید از election مبتنی بر quorum استفاده می‌کند؛ دستورهای نسخه‌های قدیمی دربارهٔ minimum_master_nodes را روی نسخهٔ تازه اجرا نکن. discovery، تعداد master-eligible، شبکهٔ پایدار و پیکربندی یکسان را طبق مستند نسخه تنظیم کن.

~~~http
GET /_cluster/health?pretty
GET /_cat/nodes?v
~~~
این‌ها وضعیت مشاهده‌شده را نشان می‌دهند، نه اثبات کامل سلامت شبکه. تمرین: در محیط آزمایشگاهی partition را شبیه‌سازی و رفتار election را ثبت کن. هیچ‌وقت برای رفع مشکل data path را دستی پاک نکن؛ ممکن است داده از دست برود.

## خودآزمایی
1. split brain چیست؟ پاسخ: دو بخش جداشده از شبکه هرکدام خود را رهبر معتبر بدانند و تاریخچهٔ متعارض بسازند.
2. پیشگیری چگونه است؟ پاسخ: quorum/election امن، discovery و نقش‌های master-eligible متناسب با نسخه؛ تنظیم قدیمی را کورکورانه کپی نکن.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20The%20%22Split%20Brain%22%20Problem)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


