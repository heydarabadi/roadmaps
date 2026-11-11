<div dir="rtl" align="right">

# مسیر یادگیری Redis — فارسی

> نسخهٔ انگلیسی: [Redis Learning Path](../../en/redis/README.md)

این پوشه محتوای آموزشی بازنویسی‌شده بر پایهٔ [Redis Roadmap](https://roadmap.sh/redis) و [PDF سرفصل‌های roadmap.sh](https://roadmap.sh/pdfs/roadmaps/redis.pdf) است. صفحهٔ وب، نمودار تعاملی را به‌صورت متن کامل عرضه نمی‌کند؛ PDF مرجع استخراج موضوع‌هاست. محتوای این پوشه کپی نقشه نیست و برای هر موضوع آموزش، مثال، تمرین، کوییز پاسخ‌دار و منبع فراهم می‌کند.

## این مسیر را چطور بخوانی

این مجموعه برای یادگیری Redis از صفر نوشته شده است. برای فهم درس‌های اصلی لازم نیست ابتدا مقاله یا دورهٔ دیگری بخوانی. لینک‌های بیرونی برای راستی‌آزمایی نسخه، دیدن مستند رسمی یا مطالعهٔ بیشتر هستند؛ آن‌ها جای توضیح‌های داخل فایل‌ها را نمی‌گیرند.

۱. [درس صفر: راه‌اندازی و روش مطالعه](00-start-here/README.md) را کامل کن.
۲. سه درس مبانی را بخوان و تفاوت cache، دیتابیس و broker را با مثال خودت توضیح بده.
۳. در فصل شروع کار، server را بالا بیاور، با cli وصل شو، key بساز، TTL ببین و محیط را پاک‌سازی کن.
۴. هر ساختار داده را با اجرای مثال و توضیح خروجی یاد بگیر؛ حفظ‌کردن نام فرمان‌ها به‌تنهایی کافی نیست.
۵. قابلیت‌های پیشرفته و عملیات تولید را بخوان و برای هرکدام failure mode و روش پایش بنویس.
۶. سه [پروژهٔ پایانی](projects/README.md) را اجرا و برای خودت طراحی کن.
۷. برای مرور از [واژه‌نامه](GLOSSARY.md) و [برگهٔ مرور سریع](QUICK-REFERENCE.md) کمک بگیر.

هر درس شامل هدف یادگیری، توضیح قدم‌به‌قدم، مثال، تمرین، کوییز و پاسخ تشریحی است. اول پاسخ کوییز را باز نکن. فرمان‌ها را فقط روی لَب محلی فصل صفر اجرا کن.

## مسیر یادگیری و معیار عبور

- **مبانی:** بتوانی با زبان ساده توضیح بدهی Redis چه نوع سرویسی است و چرا آن را کنار پایگاه دادهٔ اصلی می‌گذاریم.
- **شروع کار:** خودت Redis را اجرا، وصل، بررسی و متوقف کنی؛ SET، GET، TTL، TYPE، DEL و SCAN را توضیح بدهی.
- **ساختارها:** برای یک نیاز، نوع داده را انتخاب کنی و دلیل، عملیات پرتکرار و محدودیتش را بگویی.
- **قابلیت‌های پیشرفته:** Pub/Sub و Streams، transaction و Lua را از نظر تحویل پیام، اتمیک بودن و هزینه مقایسه کنی.
- **عملیات:** برای state موردنظر RPO/RTO، persistence، حافظه، ACL/TLS، backup، restore و مانیتورینگ را تعیین کنی.
- **پایانی:** یک سیستم کوچک را end-to-end طراحی و با failure آزمایشی توضیح بدهی.

## نسخه و دامنه

مثال‌های پایه روی Redis Open Source 8.x نوشته می‌شوند. Redis 8.8 قابلیت‌های تازه‌ای مانند Array و NACK در Streams دارد؛ درس نوع‌های جدید این ویژگی‌ها را با نسخه برچسب می‌زند. شمارهٔ patch و قابلیت یک سرویس مدیریت‌شده ممکن است تغییر کند؛ هر درس نسخه‌حساس این موضوع را می‌گوید. [اعلان رسمی Redis 8.8](https://redis.io/blog/announcing-redis-8-8/)

## فهرست

### [مبانی و شناخت Redis](01-foundations/README.md)

- [Redis چیست؟](01-foundations/redis-overview/README.md)
- [کاربردها و انتخاب الگو](01-foundations/use-cases/README.md)
- [Redis در برابر SQL و NoSQL](01-foundations/choose-datastore/README.md)
### [نصب و شروع کار](02-getting-started/README.md)

- [نصب، اجرا و اتصال](02-getting-started/install-run/README.md)
- [redis-cli، دستورها، کلیدها و TTL](02-getting-started/cli-keys-ttl/README.md)
### [ساختارهای دادهٔ اصلی](03-core-data-structures/README.md)

- [String، شمارنده و Bitmap](03-core-data-structures/strings-bitmaps/README.md)
- [List و صف ساده](03-core-data-structures/lists-queues/README.md)
- [Set و عملیات عضویت](03-core-data-structures/sets/README.md)
- [Hash و مدل رکورد](03-core-data-structures/hashes/README.md)
- [Sorted Set و رتبه‌بندی](03-core-data-structures/sorted-sets/README.md)
### [قابلیت‌های پیشرفته](04-advanced-features/README.md)

- [HyperLogLog](04-advanced-features/hyperloglog/README.md)
- [Streams و consumer groups](04-advanced-features/streams/README.md)
- [Geospatial و جست‌وجوی نزدیک](04-advanced-features/geospatial/README.md)
- [Transactions، WATCH و optimistic lock](04-advanced-features/transactions-watch/README.md)
- [Lua scripting](04-advanced-features/lua-scripting/README.md)
- [Pub/Sub](04-advanced-features/pubsub/README.md)
### [ماندگاری و بازیابی](05-persistence-recovery/README.md)

- [حالت‌های persistence](05-persistence-recovery/persistence-modes/README.md)
- [RDB و Snapshot](05-persistence-recovery/rdb/README.md)
- [AOF، fsync و rewrite](05-persistence-recovery/aof/README.md)
- [Backup، recovery و runbook](05-persistence-recovery/backup-restore/README.md)
### [دسترس‌پذیری و مقیاس](06-high-availability-scaling/README.md)

- [Replication و Replica](06-high-availability-scaling/replication/README.md)
- [Sentinel و failover](06-high-availability-scaling/sentinel/README.md)
- [Redis Cluster، shard و slot](06-high-availability-scaling/cluster/README.md)
### [امنیت](07-security/README.md)

- [Authentication و ACL](07-security/acl-auth/README.md)
- [شبکه، bind و TLS](07-security/network-tls/README.md)
### [پایش و بهینه‌سازی](08-operations-performance/README.md)

- [RAM، maxmemory و eviction](08-operations-performance/memory-eviction/README.md)
- [Latency، Pipeline و Benchmark](08-operations-performance/latency-benchmark/README.md)
- [INFO، SLOWLOG، MONITOR و Insight](08-operations-performance/monitoring-tools/README.md)
- [redis.conf و تنظیمات production](08-operations-performance/redis-conf/README.md)
### [تولید و Enterprise](09-production-enterprise/README.md)

- [ارتقا و Disaster Recovery](09-production-enterprise/upgrade-dr/README.md)
- [Redis Enterprise و انتخاب محصول](09-production-enterprise/enterprise/README.md)
- [Active-Active و Redis on Flash](09-production-enterprise/active-active-flash/README.md)
### [ساختارهای جدید و تکمیلی](10-modern-data-types/README.md)

- [Redis JSON](10-modern-data-types/json/README.md)
- [Time Series و ساختارهای احتمالی](10-modern-data-types/timeseries-probabilistic/README.md)
- [Vector Sets و Arrays](10-modern-data-types/vectors-arrays/README.md)

## پروژه‌های پایانی

- [Cache محصول](projects/01-product-cache/README.md)
- [جریان رویداد سفارش با Streams](projects/02-order-stream/README.md)
- [آمادگی Redis برای محیط عملیاتی](projects/03-production-readiness/README.md)

## کیس‌های واقعی منتخب

- [فروشگاه خرده‌فروشی آمریکای شمالی](https://redis.io/customers/retail-na/): گزارش Redis دربارهٔ cache و رویدادهای موجودی.
- [DBS Bank](https://aws.amazon.com/solutions/case-studies/dbs-bank-case-study/): گزارش AWS دربارهٔ استفاده از ElastiCache for Redis در workload قیمت‌گذاری.
- [Etermax](https://redis.io/customers/etermax/): گزارش Redis دربارهٔ رشد و استفاده از autoscaling/auto-sharding.

این‌ها case studyهای منتشرشده توسط فروشنده/ارائه‌دهنده‌اند؛ اعداد و نتایج را تضمین عمومی تلقی نکن. مثال‌های دیگر در فصل‌ها سناریوهای آموزشی‌اند، نه ادعای تجربهٔ یک شرکت خاص.

## منابع فارسی منتخب

- [DNTips — بررسی اجمالی Redis (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [Virgool — مزایا و دلایل استفاده از Redis](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)
- [ویدئوی فارسی: String، INCR و atomic بودن](https://www.youtube.com/watch?v=e5Q_RUwviaE)
- [ویدئوی فارسی: Pipeline و Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc)
- [ویدئوی فارسی: Redis Streams و consumer group](https://www.youtube.com/watch?v=_IcgS_NuV-k)
- [مقالهٔ فارسی: Replication و Cluster](https://azarsys.com/blog/setup-redis-replication-cluster/)
- [مقالهٔ فارسی: Persistence و Snapshot](https://www.urhoba.net/fa/post/redis-persistence-snapshot)
- [مقالهٔ فارسی: نصب و امن‌سازی Redis](https://www.ariaservice.net/blog/%D8%B1%D8%A7%D9%87-%D8%A7%D9%86%D8%AF%D8%A7%D8%B2%DB%8C-%D9%88-%D8%A7%D9%85%D9%86-%D8%B3%D8%A7%D8%B2%DB%8C-redis-%D8%B1%D9%88%DB%8C-%D8%B3%D8%B1%D9%88%D8%B1-%D9%85%D8%AC%D8%A7%D8%B2%DB%8C-%D9%88-%D8%A7%D8%AE%D8%AA%D8%B5%D8%A7%D8%B5%DB%8C)

بعضی ساختارهای تخصصی منابع فارسی مستقل و قابل‌اتکای کمی دارند. در این دوره، مفهوم و مثال همان‌جا به فارسی آموزش داده می‌شود؛ لینک مقالهٔ فارسی فقط منبع تکمیلی است. مستند رسمی نسخه‌ای برای بررسی جزئیات تغییرپذیر commandها آورده شده، نه به‌عنوان پیش‌نیاز یادگیری پایه.

## ایمنی و روش سنجش

- فرمان‌های FLUSHDB، FLUSHALL، CONFIG و تغییر persistence می‌توانند داده یا سرویس را تغییر دهند؛ فقط در محیط آزمایشی اجرا کن.
- port Redis را به اینترنت عمومی باز نکن.
- Benchmark روی لپ‌تاپ ظرفیت production را پیش‌بینی نمی‌کند.
- در پایان هر فصل، یک طرح کوچک بنویس: key schema، ساختار داده، TTL، maxmemory policy، persistence، failure behavior، backup، metric و trade-off.
- هیچ بخش آموزشی جای اجرای تمرین را نمی‌گیرد؛ فرمان‌ها روی Redis لَب اجرا می‌شوند و هیچ نتیجه‌ای به‌عنوان benchmark یا تجربهٔ production تأییدشده معرفی نشده است.

</div>
