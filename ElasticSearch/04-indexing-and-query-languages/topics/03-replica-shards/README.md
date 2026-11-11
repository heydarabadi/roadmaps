# Replica Shards

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 03

## هدف این درس
در این مبحث، Replica Shards را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Replica کپی primary shard است که روی node واجد شرایط دیگری تخصیص می‌شود. با از دست رفتن primary، replica همگام می‌تواند promote شود؛ برخی searchها نیز روی copyهای shard توزیع می‌شوند. write همچنان از مسیر primary هماهنگ می‌شود. افزایش replica ذخیره‌سازی و شبکه می‌خواهد و به‌تنهایی تضمین latency نیست.

~~~http
PUT /products-v1/_settings
{"index":{"number_of_replicas":1}}
~~~
بعد از تغییر allocation و سلامت shardها را ببین. تمرین: توضیح بده با قطع node دارای primary، کدام copy جایگزین می‌شود و چرا single-node با replica=1 زرد می‌ماند. replica صفر فقط برای آزمایش محلی قابل‌قبول است، نه default تولیدی.

## خودآزمایی
1. replica چه ارزشی می‌دهد؟ پاسخ: کپی برای تحمل خرابی node و امکان توزیع بخشی از خواندن‌ها؛ در برابر هزینهٔ دیسک و replication.
2. replica backup است؟ پاسخ: خیر؛ حذف/فساد منطقی به replica هم می‌رسد؛ snapshot مستقل و restore آزموده لازم است.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Replica%20Shards)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


