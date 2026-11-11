<div dir="rtl" align="right">

# فصل ۱۰ — ساختارهای جدید و تکمیلی Redis

> English edition: [Chapter 10 — Modern Redis data types](./README.en.md)

> این فصل بخشی از PDF roadmap کلاسیک را به‌روزرسانی می‌کند. قابلیت‌ها را بر اساس نسخهٔ endpoint بررسی کن؛ «latest docs» تضمین نمی‌کند سرویس تو همین نسخه را اجرا کند. زمان پیشنهادی: ۴ تا ۶ ساعت.

## موضوع‌ها

1. [Redis JSON](./json/README.md): سندهای تو‌در‌تو، JSONPath، field update، schema و indexing.
2. [Time Series و ساختارهای احتمالی](./timeseries-probabilistic/README.md): timestamp/retention/aggregation و approximation/خطا.
3. [Vector Sets و Arrays](./vectors-arrays/README.md): similarity search، embedding، index و آرایه‌های Redis 8.8.

## نقشهٔ انتخاب

| داده/سؤال | نوع محتمل برای بررسی |
| --- | --- |
| سند JSON nested و update path | JSON |
| مقدار عددی timestampدار با range/retention | Time Series |
| عضویت احتمالی، شمارش/رتبه تقریبی | Bloom/Cuckoo/CMS/Top-K/t-digest/HLL |
| شبیه‌ترین embeddingها با فیلتر سبک | Vector Set |
| similarity + متن و filterهای غنی | Redis Query Engine روی Hash/JSON |
| collection مرتب با index تصادفی/ring buffer | Array (Redis 8.8+) |

## نسخه و packaging

Redis 8 خانوادهٔ data typeهای JSON، Time Series، Search و probabilistic را در Open Source یکپارچه کرده است؛ Redis 8.0 نیز Vector Sets را اضافه کرد. Redis 8.8 Array را معرفی کرد. روی نسخه‌های قدیمی ممکن است module/Redis Stack لازم باشد یا فرمان وجود نداشته باشد. Feature set در Cloud/Software و SDKها هم ممکن است متفاوت باشد. قبل از migration، نسخه، edition، command availability، backup/restore و client library را در CI/staging بررسی کن.

## مرور مفهومی

نوع دادهٔ تخصصی وقتی مفید است که query/عملیات آن را واقعاً لازم داشته باشی. JSON لزوماً validation schema نیست؛ Time Series بدون retention بی‌نهایت رشد می‌کند؛ probabilistic type منبع exact نیست؛ vector similarity relevance را تضمین نمی‌کند؛ Array نیز queue durable نیست. هر درس یک لَب، تمرین پاسخ‌دار و ریسک عملیاتی دارد.

## پرسش فصل

1. برای billing دقیق کدام نوع احتمالی را به‌عنوان تنها منبع قرار نمی‌دهی؟ چرا؟
2. چرا نمرهٔ vector search تضمین کیفیت پاسخ مدل نیست؟
3. برای dashboard latency، چه چیزی در کنار timestamp خام می‌خواهی؟
4. چه وقت List از Array مناسب‌تر است؟

<details><summary>پاسخ راهنما</summary>

هیچ sketch تقریبی را منبع قطعی صورتحساب نگذار؛ شمارش/نتیجه exact باید authoritative باشد. score فقط فاصله/رتبهٔ embedding است؛ مدل و مجموعهٔ ارزیابی کیفیت را تعیین می‌کنند. dashboard به retention، aggregation درست (مثل p95/max)، label محدود و gap handling نیاز دارد. queue با push/pop و semantics صف معمولاً List یا Streams/Broker است؛ Array برای index/range/ring buffer بهتر است.

</details>

## منابع

- [What's new in Redis 8.0](https://redis.io/docs/latest/develop/whats-new/8-0/)
- [What's new in Redis 8.8](https://redis.io/docs/latest/develop/whats-new/8-8/)
- [Data type comparison](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [PDF رسمی roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf)

</div>
