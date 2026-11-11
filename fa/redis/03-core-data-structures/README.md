<div dir="rtl" align="right">

# فصل ۳ — ساختارهای دادهٔ اصلی

> English edition: [Chapter 3 — Core data structures](../../../en/redis/03-core-data-structures/README.md)

> مهم‌ترین مهارت این فصل انتخاب ساختار از روی عملیات و query است. زمان پیشنهادی: ۴ تا ۶ ساعت؛ هر درس را در Redis اجرا کن.

## نقشهٔ درس‌ها

1. [String، counter و bitmap](strings-bitmaps/README.md): مقدار ساده، عملیات اتمیک عددی، bit و محدودیت اندازه.
2. [List و صف ساده](lists-queues/README.md): push/pop دو سر، block، ترتیب، race و فرق صف ساده با queue durable.
3. [Set](sets/README.md): عضویت یکتا، union/intersection/difference و انتخاب بین set دقیق و probabilistic filter.
4. [Hash](hashes/README.md): field/value برای رکورد flat، update یک فیلد و قرارداد key.
5. [Sorted Set](sorted-sets/README.md): score، rank، leaderboard و range.

## چطور نوع مناسب را انتخاب کنیم؟

پیش از انتخاب، فهرست عملیات را بنویس: آیا lookup با نام field است؟ عضو باید یکتا باشد؟ ترتیب بر اساس score لازم است؟ push/pop از صف؟ شمارندهٔ atomic؟ پس از آن ساختار را انتخاب کن. نام داده به‌تنهایی کافی نیست؛ مثلاً «لیست کارها» شاید Sorted Set بر اساس زمان اجرای بعدی بخواهد، نه List ساده.

| سؤال برنامه | انتخاب اولیه برای بررسی |
| --- | --- |
| مقدار متنی/JSON کوچک یا شمارنده | String |
| bitset و وضعیت boolean بسیار فشرده | Bitmap روی String |
| membership دقیق و یکتا | Set |
| fieldهای flat یک object | Hash |
| صف با push/pop ساده | List؛ اگر delivery guarantee لازم است Streams/سامانهٔ broker را بررسی کن |
| رتبه/امتیاز و بازهٔ مرتب | Sorted Set |

این جدول نقطهٔ شروع است. برای هر درس complexity، memory encoding، atomic command، persistence و رفتار under load را بررسی کن. `O(1)` نیز معنای تضمین latency ثابت در کل برنامه نیست؛ شبکه، serialization، payload و contention مهم‌اند.

## لَب مشترک: انتخاب مدل سفارش

بدون اجرای destructive command روی دادهٔ دیگران، از prefix `lab:` استفاده کن:

```text
SET lab:order:42:status created
HSET lab:order:42 customer_id 7 total 125000 status created
SADD lab:order:42:tags fragile express
ZADD lab:orders:by-time 1794384000 42
LPUSH lab:orders:work 42
```

این مثال عمداً چند ساختار را نشان می‌دهد، اما در محصول واقعی قرار نیست همه را duplicate کنی. برای هر access pattern تصمیم بگیر کدام key منبع اصلی همان state است و indexهای مشتق‌شده را چگونه به‌روز/بازسازی می‌کنی. `LPUSH` به‌تنهایی queue reliable با retry/ack نیست؛ [Streams](../04-advanced-features/streams/README.md) و پروژهٔ سفارش را بعداً بخوان.

## تمرین تشخیصی

برای هر requirement، نوع را انتخاب و یک دلیل رد گزینهٔ دوم بنویس:

1. مقدار cache یک صفحه با TTL.
2. شمارش بازدید هر کاربر در یک هفته.
3. فهرست tagهای یکتا برای محصول.
4. ۱۰۰ امتیاز اول leaderboard.
5. وضعیت jobهایی که تا زمان اجرای مجدد باید باقی بمانند و retry/ack می‌خواهند.

<details><summary>پاسخ راهنما</summary>

String با `SET ... EX` برای cache ساده؛ counter String با INCR و expiry دقیقاً مطابق پنجره (باید مرز reset را طراحی کرد)؛ Set برای tag یکتا؛ Sorted Set با score برای leaderboard؛ Streams/consumer group یا broker برای jobهای نیازمند pending/ack/retry، نه List خام. جواب جایگزین ممکن است اگر query/workload متفاوت باشد؛ شرط مهم توضیح trade-off است.

</details>

## معیار عبور از فصل

- برای هر نوع، دو فرمان مهم و یک محدودیت را بدون نگاه‌کردن به سند بگویی.
- عملیات برنامه را به query قابل‌اجرا و type مناسب تبدیل کنی.
- تفاوت value key، hash field و set member را اشتباه نگیری.
- برای indexهای مشتق‌شده، راه consistency/rebuild را مشخص کنی.
- فرمان پاک‌کننده یا سراسری را روی دیتابیس واقعی آزمایش نکنی.

## منابع تکمیلی

- [مقایسهٔ رسمی Data Types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [مستند Data Types](https://redis.io/docs/latest/develop/data-types/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

</div>
