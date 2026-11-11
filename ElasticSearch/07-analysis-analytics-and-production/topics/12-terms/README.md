# Terms

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 12

## هدف این درس
در این مبحث، Terms را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Terms aggregation مقدارهای field را گروه‌بندی و برای هر مقدار bucket می‌سازد. برای string عموماً keyword استفاده می‌شود؛ text به fielddata وابسته می‌شود و معمولاً انتخاب اشتباه است. size تعداد bucketهای خروجی را محدود می‌کند؛ shard_size و distributed top-N بر صحت bucketهای مرزی اثر دارند.

~~~http
POST /products-v1/_search
{"size":0,"aggs":{"brands":{"terms":{"field":"brand","size":10}}}}
~~~
تمرین: brandهای متعدد را وارد و doc_count را با dataset مقایسه کن. برای شمارش کامل همهٔ valueها از composite aggregation با after_key بررسی کن؛ bucket بی‌نهایت در یک پاسخ نمی‌آید.

## خودآزمایی
1. terms aggregation چه می‌سازد؟ پاسخ: bucket برای مقدارهای پرتکرار field و doc_count هر bucket.
2. آیا همهٔ bucketها برمی‌گردند؟ پاسخ: خیر؛ size و توزیع shardها روی top bucket مؤثرند و cardinality بالا نیازمند احتیاط است.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Terms)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


