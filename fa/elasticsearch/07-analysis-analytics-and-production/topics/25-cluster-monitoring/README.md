# Cluster Monitoring

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/25-cluster-monitoring/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 25

## هدف این درس
در این مبحث، Cluster Monitoring را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Monitoring روند و هشدار می‌دهد، نه فقط وضعیت یک لحظه. حداقل latency p95/p99، error/timeout، rejected thread-pool، heap/GC، disk، shard count/relocation، indexing throughput، query rate، snapshot age و CCR lag را دنبال کن. آستانه را بر SLO و baseline سرویس تنظیم کن.

~~~http
GET /_cluster/health
GET /_nodes/stats/jvm,fs,thread_pool,indices
~~~
تمرین: برای یک workload spike داشبورد بساز و تعیین کن چه threshold عملیاتی هشدار می‌دهد. Cat API برای triage انسان خوب است؛ telemetry و alert رسمی را برای روند نگه‌دار.

## خودآزمایی
1. سبز بودن cluster یعنی کاربر latency خوب دارد؟ پاسخ: نه؛ health بیشتر وضعیت shard allocation را می‌گوید، نه کیفیت/سرعت end-to-end.
2. کدام شاخص‌ها را پایش می‌کنی؟ پاسخ: latency صدکی، error/rejection، heap/GC، disk watermark، shard allocation و indexing lag.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/rest-apis)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Cluster%20Monitoring)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


