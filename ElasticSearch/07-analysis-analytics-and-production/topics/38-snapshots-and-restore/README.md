# Snapshots & restore

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 38

## هدف این درس
در این مبحث، Snapshots & restore را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Snapshot backup کلاستر در حال اجراست و می‌تواند index/data stream و cluster/feature stateهای پشتیبانی‌شده را نگه دارد. Repository باید امن و قابل‌دسترسی باشد؛ snapshot incremental است اما storage repository را دستی دستکاری نکن. snapshot با replica و reindex متفاوت است.

~~~http
PUT /_snapshot/backup-repo
{"type":"fs","settings":{"location":"/mnt/es-backups"}}
POST /_snapshot/backup-repo/snapshot-2026-11-10?wait_for_completion=true
~~~
این repository local فقط مثال self-managed است. تمرین: restore را در محیط جدا، با rename/conflict مناسب اجرا و داده/config را بررسی کن. نسخهٔ source/target، RPO/RTO، رمزنگاری و دسترسی repository را مستند کن.

## خودآزمایی
1. snapshot چه ارزشی دارد؟ پاسخ: backup سازگار برای بازیابی/انتقال از repository ثبت‌شده.
2. موفقیت snapshot را چطور اثبات می‌کنی؟ پاسخ: restore دوره‌ای روی مقصد آزمایش، صحت داده/feature و زمان RTO را اندازه می‌گیرم.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Snapshots%20%26%20restore)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


