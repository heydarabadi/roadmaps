# Cross-cluster Replication

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/26-cross-cluster-replication/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 26

## هدف این درس
در این مبحث، Cross-cluster Replication را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
CCR برای تکثیر leader index به follower در cluster دیگر است؛ کاربردهایی مانند local read، انتقال/بازیابی با تأخیر وابسته به شبکه دارد. remote cluster connection، privilege/API key و نسخه/feature سازگار لازم است. follower ممکن است عقب باشد؛ replication async است و آخرین write فوراً در مقصد نیست.

~~~http
GET /_ccr/stats
~~~
تمرین: replication lag و follower status را در زمان قطع شبکه مشاهده کن. CCR را با snapshot/restore برای disaster recovery مقایسه کن؛ RPO/RTO، promotion، failback، مجوزها و هزینهٔ دو cluster را مستند کن.

## خودآزمایی
1. CCR چه می‌کند؟ پاسخ: تغییرات leader index را به follower cluster replicate می‌کند.
2. CCR با replica یا snapshot یکی است؟ پاسخ: نه؛ به‌ترتیب کپی محلی shard و backup قابل restore مفاهیم جدا هستند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/tools/cross-cluster-replication)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Cross-cluster%20Replication)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


