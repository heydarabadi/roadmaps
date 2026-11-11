# Primary Shards

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/02-primary-shards/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 02

## هدف این درس
در این مبحث، Primary Shards را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Index به چند primary shard تقسیم می‌شود؛ هر shard یک index مستقل Lucene است و هر سند با routing به shard می‌رود. تعداد shardها parallelism، توزیع دیسک/CPU و fan-out جست‌وجو را تعیین می‌کند. shard خیلی بزرگ recovery/relocation را طولانی می‌کند؛ shard خیلی کوچک metadata و هزینهٔ عملیات را بالا می‌برد. اندازهٔ داده، رشد و نرخ query را با benchmark بسنج.

~~~http
PUT /events-v1
{"settings":{"number_of_shards":3,"number_of_replicas":1}}
~~~
عددها نمونه‌اند، نه توصیهٔ همگانی. تمرین: با فرض 300GB داده، رشد ماهانه و هدف اندازهٔ shard، تخمین اولیه بساز. primary تنها تحمل خرابی node را نمی‌دهد؛ replica روی node واجد شرایط لازم است.

## خودآزمایی
1. primary shard چه می‌کند؟ پاسخ: بخشی از دادهٔ index را نگه می‌دارد و مسیر اولیهٔ نوشتن/بازیابی آن shard است.
2. چرا تعداد primary را زود طراحی می‌کنیم؟ پاسخ: تغییر آن معمولاً به reindex یا عملیات split/shrink با پیش‌شرط نیاز دارد؛ مثل replica آزادانه تغییرپذیر نیست.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Primary%20Shards)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


