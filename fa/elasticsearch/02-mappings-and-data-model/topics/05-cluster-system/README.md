# Cluster (System)

[English version](../../../../../en/elasticsearch/02-mappings-and-data-model/topics/05-cluster-system/README.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 05

## هدف این درس
Cluster مجموعهٔ nodeهای هماهنگ و state توزیع‌شده است؛ health، node roles، shard allocation و capacity را ببین.
## Cluster و وضعیت توزیع‌شده

### Cluster و وضعیت توزیع‌شده
Cluster چند Elasticsearch node است که با discovery همدیگر را پیدا می‌کنند و cluster state مشترک دارند. Cluster state شامل metadata مربوط به index، mapping، nodeها و تخصیص shardها است. Master منتخب تغییرهای این وضعیت را هماهنگ می‌کند؛ data nodeها shardها و queryها را اجرا می‌کنند.
برای دیدن وضعیت پایه، health را بخوان: green یعنی primary و replica shardها تخصیص یافته‌اند؛ yellow یعنی primaryها حاضرند اما بعضی replicaها تخصیص نیافته‌اند؛ red یعنی دست‌کم یک primary در دسترس نیست. رنگ به‌تنهایی علت را نمی‌گوید؛ allocation explain و log nodeها را بررسی کن.
~~~http
GET /_cluster/health?pretty
GET /_cat/nodes?v
~~~
برای محیط توسعه single-node قابل‌قبول است؛ production نیازمند خرابی‌پذیری، quorum و طراحی ظرفیت است. نام cluster را بین محیط‌هایی که شبکه‌ی مشترک دارند تکرار نکن تا node اشتباه به cluster نپیوندد. خطای رایج آن است که yellow را بدون بررسی نادیده بگیرند، درحالی‌که خرابی بعدی می‌تواند داده را غیرقابل‌دسترسی کند.

## خودآزمایی
1. cluster yellow چه می‌گوید؟ پاسخ: primaryها فعال‌اند ولی یک یا چند replica تخصیص نیافته‌اند.
2. green به‌تنهایی سلامت سرویس را تضمین می‌کند؟ پاسخ: نه؛ latency، خطا و کیفیت query جداگانه پایش می‌شوند.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Cluster%20(System))
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



