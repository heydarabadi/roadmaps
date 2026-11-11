# Rollover Policies

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 33

## هدف این درس
در این مبحث، Rollover Policies را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Rollover وقتی شرط‌هایی مانند max_primary_shard_size، age یا docs برقرار شود index write تازه ایجاد می‌کند. معمولاً از write alias یا data stream استفاده می‌شود؛ index قدیمی read-only/غیرفعال‌تر می‌شود و write alias به نسل تازه منتقل می‌گردد.

~~~http
POST /events-write/_rollover
{"conditions":{"max_primary_shard_size":"50gb","max_age":"30d"}}
~~~
آستانه صرفاً نمونه است؛ shard و workload را benchmark کن. تمرین: نام نسل‌های backing index را پس از rollover و alias write را بررسی کن. ILM می‌تواند rollover را خودکار کند. shard خیلی کوچک shard sprawl و خیلی بزرگ recovery طولانی می‌آورد.

## خودآزمایی
1. rollover چه می‌کند؟ پاسخ: write target را به backing index تازه می‌چرخاند تا index فعال رشد بی‌حد نکند.
2. age از کجا سنجیده می‌شود؟ پاسخ: معمولاً از زمان rollover index؛ policy و شرایط را با API explain بررسی کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/index-lifecycle-actions/ilm-rollover)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Rollover%20Policies)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


