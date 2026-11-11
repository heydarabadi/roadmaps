# Data Tiers

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/34-data-tiers/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 34

## هدف این درس
در این مبحث، Data Tiers را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Data tiers گروهی از nodeها با هدف performance/cost و الگوی دسترسی‌اند، مانند hot برای ingest و query فعال‌تر و warm/cold/frozen برای دادهٔ کم‌دسترسی‌تر در topologyهای پشتیبانی‌شده. ILM و allocation policy index را میان tierها می‌برند.

~~~http
GET /_cat/nodes?v&h=name,node.role,disk.used_percent
~~~
تمرین: query ماه اخیر را روی hot و ماه قدیمی را روی tier ارزان‌تر طراحی و latency/retention را بسنج. اسم tier به‌تنهایی تضمین storage و latency نیست؛ نسخه، sizing، replicas و searchable snapshots را بررسی کن.

## خودآزمایی
1. data tiering بر چه اساسی است؟ پاسخ: الگوی دسترسی/کارکرد و هزینهٔ storage/compute در tierهای متفاوت.
2. انتقال به cold یعنی دسترسی فوری هم‌سطح hot؟ پاسخ: نه؛ latency، replica/searchable snapshot و قابلیت پلتفرم trade-off دارند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/manage-data/lifecycle/data-tiers)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Data%20Tiers)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


