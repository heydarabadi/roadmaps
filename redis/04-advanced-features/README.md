<div dir="rtl" align="right">

# فصل ۴ — قابلیت‌های پیشرفته و انتخاب تضمین

> English edition: [Chapter 4 — Advanced features](./README.en.md)

> این فصل از membership تقریبی تا پردازش پیام و اتمیک‌کردن تغییرات را پوشش می‌دهد. زمان پیشنهادی: ۵ تا ۷ ساعت. پیش از استفاده، تضمین هر primitive را دقیق بنویس.

## مسیر درس‌ها

1. [HyperLogLog](./hyperloglog/README.md): شمارش distinct با حافظهٔ کم و خطای تقریبی.
2. [Streams و consumer groups](./streams/README.md): log پیام، pending entry، ack، claim و retry.
3. [Geospatial](./geospatial/README.md): ثبت مکان، radius search و محدودیت‌های هندسی/تازگی.
4. [Transactions و WATCH](./transactions-watch/README.md): اجرای command group، optimistic concurrency و نبود rollback خودکار.
5. [Lua scripting](./lua-scripting/README.md): منطق server-side اتمیک، KEYS/ARGV و حدهای script.
6. [Pub/Sub](./pubsub/README.md): پیام زندهٔ best-effort که subscriber آفلاین از دست می‌دهد.

## تصمیم مهم: پیام زنده است یا دادهٔ قابل‌بازیابی؟

| نیاز | primitive برای بررسی | تضمین/محدودیت اصلی |
| --- | --- | --- |
| اطلاع‌رسانی زنده به subscriber آنلاین | Pub/Sub | پیام تاریخی و ack per consumer ندارد؛ reconnect باید state را refresh کند. |
| رویداد پایدارتر با چند consumer | Streams | entry در stream می‌ماند تا حذف/trim؛ group pending/ack دارد، ولی retention، durability و duplicate handling را خودت طراحی می‌کنی. |
| شمارش distinct | HyperLogLog | تخمین؛ اعضا قابل فهرست نیستند. |
| جست‌وجوی فاصله از مکان | Geo commands | مختصات/دادهٔ تازه لازم؛ جایگزین GIS کامل نیست. |
| چند تغییر مشروط در keyها | WATCH/MULTI یا Lua | atomic execution ≠ rollback کامل/transaction SQL. |

## تمرین طراحی

برای پرداخت سفارش فرضی، «پرداخت شد»، «ارسال شد» و «پنل زنده به‌روز شود» را جدا طراحی کن. کدام رخداد باید قابل replay باشد؟ کدام update نیازمند idempotency است؟ Pub/Sub را برای اعلان UI استفاده کن ولی منبع رویداد مهم را در Stream یا broker/storage مناسب نگه دار. برای هر تغییر conditional، race دو worker را تصور کن و از transaction/WATCH یا script استفاده کن.

## بررسی فهم

1. چرا Pub/Sub به تنهایی مناسب سفارش‌هایی که consumer ممکن است آفلاین شود نیست؟
2. آیا `EXEC` خطای اجرای یکی از commandها را با rollback کل مجموعه جبران می‌کند؟
3. چرا consumer group هم نیاز به idempotency و مدیریت pending دارد؟
4. کدام عملیات از HLL مناسب و کدام نامناسب است؟

<details><summary>پاسخ راهنما</summary>

Pub/Sub history نگه نمی‌دارد؛ پیام حین disconnect از دست می‌رود. Redis transaction commandها را پشت‌سرهم و بدون interleaving اجرا می‌کند ولی SQL rollback تمام فرمان‌های runtime failure را تضمین نمی‌کند. Stream message ممکن است دوباره پردازش شود و pending entry باید ack/reclaim/retry شود؛ side-effect را idempotent بساز. HLL برای distinct count مناسب، ولی نام اعضا یا exact set difference مناسب نیست.

</details>

## منابع

- [مقایسهٔ Data Types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Transactions](https://redis.io/docs/latest/develop/using-commands/transactions/)
- [Streams](https://redis.io/docs/latest/develop/data-types/streams/)
- [Pub/Sub](https://redis.io/docs/latest/develop/pubsub/)
- [ساختارهای احتمالی](https://redis.io/docs/latest/develop/data-types/probabilistic/)

</div>
