# Dynamic

[English version](../../../../../en/elasticsearch/02-mappings-and-data-model/topics/03-dynamic/README.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 03

## هدف این درس
Dynamic mapping سرعت شروع می‌دهد اما type را از دادهٔ اولیه حدس می‌زند؛ `true`, `false`, `strict` را با نیاز ingest انتخاب کن.
## Dynamic mapping و خطر حدس

### Dynamic mapping و خطر حدس
وقتی سند field ناشناخته دارد، dynamic mapping می‌تواند نوع آن را از مقدارهای رسیده حدس بزند و mapping را خودکار توسعه دهد. این روش برای شروع سریع و کشف شکل داده مناسب است، اما اولین مقدار می‌تواند نوع دائمی نامناسبی انتخاب کند.
فرض کن نخستین price به صورت "4200000" رشته‌ای رسیده و سند بعدی price را عدد می‌فرستد. اکنون query range یا aggregation عددی با mapping رشته‌ای سازگار نیست. همچنین dynamic date detection ممکن است رشته‌ی خاصی را به date تبدیل کند، درحالی‌که producerهای دیگر فرمت دیگری دارند.
Dynamic true همه‌ی fieldهای جدید را وارد mapping می‌کند. Dynamic false fieldهای جدید را index نمی‌کند، هرچند داده‌ی خام ممکن است در _source بماند. Dynamic strict سند تازه با field ناشناخته را رد می‌کند. این سیاست‌ها را با نیاز محصول انتخاب کن.
~~~http
PUT /events-v1
{"mappings":{"dynamic":"false","properties":{"@timestamp":{"type":"date"},"message":{"type":"text"}}}}
~~~
در محیط اکتشاف سند نمونه بفرست، mapping ساخته‌شده را بخوان، سپس mapping صریح یا template تولیدی بساز. خطای رایج، استفاده‌ی طولانی از mapping خودکار در ورودی‌های بدون کنترل است؛ این حالت mapping explosion و تغییر نوع پیش‌بینی‌ناپذیر می‌آورد.

## خودآزمایی
1. dynamic=false چه می‌کند؟ پاسخ: field ناشناخته را به mapping اضافه نمی‌کند؛ داده ممکن است در _source بماند ولی index نشود.
2. dynamic=strict چه رفتاری دارد؟ پاسخ: سند با field ناشناخته را رد می‌کند.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Dynamic)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



