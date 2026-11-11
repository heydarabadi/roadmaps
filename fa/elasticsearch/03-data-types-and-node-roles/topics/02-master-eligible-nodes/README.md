# Master-Eligible Nodes

[English version](../../../../../en/elasticsearch/03-data-types-and-node-roles/topics/02-master-eligible-nodes/README.md)


> فصل 03: نوع داده و نقش نودها · درس 02

## هدف این درس
Master-eligible node در انتخاب master شرکت می‌کند و control plane/cluster state را مدیریت می‌کند؛ ظرفیت و quorum اهمیت دارد.
## تدریس عمیق

### Master-eligible node و انتخاب master
Master-eligible node عضو بالقوه‌ی فرایند انتخاب master است. Master منتخب cluster state را هماهنگ می‌کند: عضویت nodeها، metadata index و تغییرهای تخصیص shard. این role برای مدیریت control plane است، نه اجرای queryهای سنگین به عنوان هدف اصلی.
چند node واجد انتخاب برای تحمل خرابی لازم است؛ شمار و تنظیم دقیق را با راهنمای نسخه‌ی مستقر هماهنگ کن. مسئله‌ی quorum را با تنظیم‌های قدیمی و منسوخ حل نکن. اگر master-eligibleها نتوانند quorum بسازند، تغییر cluster state متوقف یا cluster ناپایدار می‌شود.
برای عیب‌یابی، master منتخب، logs election، ارتباط شبکه و بار CPU/heap را بررسی کن. خطای رایج، قرار دادن nodeهای master پرمصرف یا نداشتن ظرفیت برای از دست‌رفتن یک node است.

## خودآزمایی
1. master منتخب چه کار می‌کند؟ پاسخ: cluster state و metadata/allocation را هماهنگ می‌کند.
2. چرا چند node واجد election لازم‌اند؟ پاسخ: برای quorum و تداوم مدیریت با خرابی node؛ تعداد/تنظیم را از docs همان نسخه بگیر.
## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Master-Eligible%20Nodes)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



