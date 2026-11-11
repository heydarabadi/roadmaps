<div dir="rtl" align="right">

# Redis Streams: رویداد، گروه مصرف‌کننده و بازیابی

> English edition: [Redis Streams: Events, Consumer Groups, and Recovery](../../../../en/redis/04-advanced-features/streams/README.md)

> مسیر: فصل ۴، قابلیت‌های پیشرفته · سطح: میانی · زمان درس و لَب: ۹۰ تا ۱۵۰ دقیقه
>
> تمام فرمان‌های تغییردهندهٔ داده را فقط در Redis آزمایشی اجرا کن. متن زیر آموزش مفهومی است؛ خروجی‌ها نمونه‌اند و اجرای زنده‌ای ادعا نمی‌شود.

## پیش‌نیازها و هدف یادگیری

پیش از این درس باید key، Hash، TTL، `redis-cli` و تفاوت Redis با پایگاه دادهٔ رابطه‌ای را بشناسی. پس از درس می‌توانی:

- Stream را به‌عنوان log رویداد مرتب‌شده توضیح دهی و آن را با List و Pub/Sub مقایسه کنی.
- producer، consumer، consumer group، شناسهٔ پیام، pending و acknowledgment را از هم جدا کنی.
- یک پیام را بخوانی، پس از پایان کار تأیید کنی و پیام مصرف‌کنندهٔ خراب‌شده را بازیابی کنی.
- retry، تکرار پیام، idempotency، trimming، ظرفیت و سناریوی failover را در طرح خودت لحاظ کنی.

## ایدهٔ مرکزی

Stream یک ساختار append-oriented درون Redis است. هر entry یک شناسهٔ مرتب و مجموعه‌ای از جفت‌های field/value دارد. گروه مصرف‌کننده به چند worker اجازه می‌دهد از یک جریان کار بگیرند و وضعیت تحویل و تأیید را ثبت کند. این قابلیت‌ها تحویل قابل‌بازیابی‌تری از Pub/Sub می‌دهند، اما به‌تنهایی exactly-once، تراکنش سراسری، backup یا تضمین عدم‌اتلاف هنگام هر نوع failover ایجاد نمی‌کنند.

## نقشهٔ مفهومی

```text
Producer --XADD--> Stream (ordered entries)
                         |
                   Consumer Group
                    /           \\
              worker-A         worker-B
                 |                 |
       message enters PEL   message enters PEL
                 |                 |
        side effect succeeds       crash / timeout
                 |                 |
              XACK       XPENDING -> XAUTOCLAIM -> retry
```

`PEL` مخفف Pending Entries List است. این فهرست می‌گوید کدام entry به یک group تحویل شده ولی هنوز تأیید نشده است. PEL رسیدِ تحویل است؛ تضمین نمی‌کند اثر جانبی برنامه در دیتابیس، API پرداخت یا سیستم دیگری کامل شده باشد.

## ۱. ساختار یک Stream و شناسه‌ها

نام کلید، مثل `orders:events`, خود Stream است. `XADD` یک entry اضافه می‌کند؛ پس از نام کلید، می‌توان `*` داد تا Redis شناسه بسازد، سپس تعداد زوج‌های field/value باید کامل باشد.

```text
XADD orders:events * order_id 501 event created
"1731234567890-0"
XLEN orders:events
(integer) 1
XRANGE orders:events - +
1) 1) "1731234567890-0"
   2) 1) "order_id"
      2) "501"
      3) "event"
      4) "created"
```

شناسهٔ خودکار شکل `<زمان-میلی‌ثانیه>-<ترتیب-در-همان-میلی‌ثانیه>` دارد. زمانِ ID به معنی ساعت تجاری دقیق، timestamp مورد اعتماد یا ترتیب سراسری بین چند Stream نیست. برای ID دستی باید از قاعدهٔ افزایشی همان Stream پیروی کنی. `XRANGE` بازه را می‌خواند؛ `XREVRANGE` از انتها می‌خواند.

نام field/value رشتهٔ بایتی است. قرارداد event را خودت تعریف کن: نام نسخه‌دار، شناسهٔ یکتا، زمان رویداد، نسخهٔ schema و اطلاعات لازم برای مصرف‌کننده. از قراردادن دادهٔ حساس یا payload عظیم در هر entry پرهیز کن؛ پیام را کوچک نگه دار و policy نگهداریش را مشخص کن.

## ۲. گروه مصرف‌کننده و تحویل پیام

یک group را از ID `0` بساز تا از ابتدای Stream بخواند. `MKSTREAM` اجازه می‌دهد اگر Stream هنوز وجود ندارد ساخته شود.

```text
XGROUP CREATE orders:events billing 0 MKSTREAM
OK
XADD orders:events * order_id 501 event created
"1731234567890-0"
XREADGROUP GROUP billing worker-1 COUNT 10 STREAMS orders:events >
```

در پاسخ، worker پیام را دریافت می‌کند و Redis همان پیام را در PEL گروه ثبت می‌کند. `>` به معنی entryهای جدیدی است که تا حالا به هیچ مصرف‌کننده‌ای از همین group تحویل نشده‌اند. برای دریافت دوبارهٔ پیام‌های pending متعلق به worker فعلی از شناسهٔ `0` یا شناسهٔ دیگری که از PEL می‌آید استفاده می‌شود؛ `>` پیام pending را دوباره نمی‌خواند.

چند worker با نام‌های یکتا می‌توانند `XREADGROUP` اجرا کنند؛ Redis entryهای جدید را بین آن‌ها تقسیم می‌کند. تقسیم کار دقیقاً به معنای «یک بار پردازش» نیست: worker ممکن است کار را انجام دهد، پیش از `XACK` قطع شود و پیام به worker دیگری برسد.

### تأیید پس از موفقیت

ترتیب معمول برای side effect مستقل چنین است:

1. پیام را بخوان.
2. اعتبارسنجی کن؛ event نامعتبر را طبق سیاست مشخص به dead-letter/قرنطینه بفرست یا با دلیل علامت‌گذاری کن.
3. اثر تجاری را به‌شکل idempotent اجرا کن.
4. فقط پس از موفقیت اثر، `XACK` بزن.

```text
XACK orders:events billing 1731234567890-0
(integer) 1
XPENDING orders:events billing
```

اگر برنامه پس از ثبت سفارش در دیتابیس ولی قبل از `XACK` از کار بیفتد، پیام تکراری می‌آید. مصرف‌کننده باید از `event_id` یکتا استفاده کند؛ مثلاً در دیتابیس، شناسهٔ event را با قید unique ثبت کند یا عملیات را با شرط «اگر قبلاً اعمال نشده» انجام دهد.

اگر اول `XACK` بزنی و بعد دیتابیس را تغییر دهی، crash میان دو عمل می‌تواند پیام را از دید group تمام‌شده جلوه دهد، در حالی که کسب‌وکار هنوز به‌روز نشده است. Redis و دیتابیس بیرونی یک تراکنش مشترک خودکار ندارند.

## ۳. پیدا کردن و بازیابی pendingها

`XPENDING` خلاصهٔ پیام‌های تأییدنشده را نشان می‌دهد. شکل دقیق خروجی با آرگومان‌های فرمان و نسخه فرق می‌کند؛ معنای مهم این است که entry به کدام group/consumer تحویل شده و چه زمانی pending مانده است.

```text
XPENDING orders:events billing
XINFO GROUPS orders:events
XINFO CONSUMERS orders:events billing
```

برای دیدن جزئیات pendingها، از شکل گستردهٔ `XPENDING key group start end count [consumer]` استفاده کن. مصرف‌کننده‌ای که پیام را گرفته و مرده است باید بعد از timeout عملیاتی claim شود. در Redis 6.2 به بعد `XAUTOCLAIM` برای پیمایش و claim کردن پیام‌هایی که idle مانده‌اند در دسترس است؛ `XCLAIM` شکل صریح‌تری دارد.

```text
XAUTOCLAIM orders:events billing recovery-1 60000 0-0 COUNT 20
```

در این مثال ۶۰٬۰۰۰ میلی‌ثانیه حد idle نمونه است، نه مقدار پیشنهادی عمومی. حد را بزرگ‌تر از زمان معمول پردازش و heartbeat انتخاب کن؛ اگر کوتاه باشد پیامِ worker کند را هم‌زمان به worker دیگر می‌دهی و پردازش دوبار انجام می‌شود. اگر بلند باشد، بازیابی واقعی دیر می‌شود. یک سازوکار عملیاتی لازم است تا cursor بازگشتی `XAUTOCLAIM` را ادامه دهد و پیام‌های تکراری را امن پردازش کند.

## ۴. اندازه، retention و trimming

Stream بدون سیاست نگهداری می‌تواند رشد کند. دو روش رایج:

- محدودکردن تقریبی تعداد entryها هنگام نوشتن: `XADD orders:events MAXLEN ~ 100000 * ...`.
- بریدن دستی با `XTRIM` بر اساس طول (`MAXLEN`) یا ID (`MINID`).

علامت `~` trimming را تقریبی و معمولاً ارزان‌تر می‌کند. مقدار ۱۰۰٬۰۰۰ فقط برای لَب است؛ ظرفیت واقعی را از نرخ رویداد، اندازهٔ payload، مدت replay، RAM و SLA بازیابی حساب کن. حذف entry ممکن است دادهٔ لازم برای مصرف‌کنندهٔ عقب‌مانده را از بین ببرد. پیام pending را صرفاً به این دلیل که قدیمی است حذف نکن؛ قبل از trim، lag، PEL، پشتیبان‌گیری، نیاز قانونی و امکان replay را بررسی کن.

وقتی Stream را می‌بری، تصمیم بگیر: مصرف‌کنندهٔ کند متوقف شود، داده در پایگاه دیگری archive شود، ظرفیت بالا برود، یا event از منبع اصلی دوباره تولید شود. `XDEL` می‌تواند entry مشخصی را حذف کند؛ حذف داده درون یک Stream policy حریم خصوصی و audit جداگانه می‌خواهد.

## ۵. Stream در برابر ابزارهای دیگر

| نیاز | گزینهٔ شروع | محدودیت/تصمیم |
| --- | --- | --- |
| اعلان زنده، گم‌شدن پیام قابل‌قبول | Pub/Sub | replay، ack و PEL ندارد |
| کار سادهٔ FIFO و یک مصرف‌کننده | List | visibility timeout و acknowledgment را باید خودت بسازی |
| event log کوچک تا متوسط کنار سرویس Redis | Streams | retention، PEL، retry و failover را طراحی کن |
| replay طولانی، چند consumer مستقل و نگهداری حجیم | Kafka یا سامانهٔ log مشابه را ارزیابی کن | هزینه و پیچیدگی عملیاتی بیشتر؛ Redis Streams و Kafka تضمین‌های یکسان ندارند |

### تجربهٔ منتشرشده

Netflix در مقالهٔ فنی خود دربارهٔ WAL، از Kafka برای مسیر پیام/تکرار بین‌منطقه‌ای و EVCache در لایهٔ key-value یاد می‌کند؛ همچنین توضیح می‌دهد که cache و log پیام نقش‌های متفاوت دارند. این نمونه استفاده از Redis Streams در Netflix را ثابت نمی‌کند؛ ارزشش برای این درس، نمایش جداسازی لایهٔ cache از مسیر durable event و طراحی برای slow consumer و backpressure است. [مقالهٔ Netflix TechBlog](https://netflixtechblog.com/building-a-resilient-data-platform-with-write-ahead-log-at-netflix-127b6712359a)

Redis در مستند رسمی توضیح می‌دهد که Stream و state گروه مصرف‌کننده در RDB/AOF و replicaها نگهداری/منتشر می‌شود، اما replication پیش‌فرض asynchronous است؛ پس failover در بعضی وضعیت‌ها می‌تواند آخرین تغییر را نداشته باشد. `WAIT` احتمال از دست‌رفتن را کاهش می‌دهد، ولی تضمین مطلق failover نیست. برای پیام با اهمیت بالا، policy AOF/fsync، replication، `WAIT`، backup و امکان بازسازی را با هم ارزیابی کن. [راهنمای رسمی ایمنی پیام و replication در Streams](https://redis.io/docs/latest/develop/data-types/streams/)

## لَب راهنمای قدم‌به‌قدم

در دو ترمینال متصل به همان Redis آزمایشی:

**ترمینال A — تولید و group:**

```text
DEL lab:orders
XGROUP CREATE lab:orders workers 0 MKSTREAM
XADD lab:orders * event_id e-1 order_id 501 status created
XADD lab:orders * event_id e-2 order_id 502 status created
```

**ترمینال B — دریافت، بررسی و تأیید:**

```text
XREADGROUP GROUP workers worker-a COUNT 10 BLOCK 1000 STREAMS lab:orders >
XPENDING lab:orders workers
XACK lab:orders workers <ID-پیام-اول>
XPENDING lab:orders workers
```

`<ID-پیام-اول>` را با ID واقعی خروجی خودت جایگزین کن؛ علامت زاویه را عیناً وارد نکن. پیام دوم را pending بگذار و دوباره `XPENDING` را ببین. اگر ID آن را داری، بررسی جزئیات و سپس `XCLAIM`/`XAUTOCLAIM` را آزمایش کن. این لَب دادهٔ قبلیِ کلید `lab:orders` را پاک می‌کند.

## دام‌ها و عیب‌یابی

- `NOGROUP`: ابتدا `XGROUP CREATE` را با نام دقیق stream و group اجرا کن.
- پیام با `>` برنمی‌گردد: شاید همهٔ پیام‌های جدید قبلاً به این گروه تحویل شده‌اند؛ pendingها را با `XPENDING` بررسی کن.
- پیام‌ها تکراری‌اند: رفتار crash بین side effect و `XACK` را بررسی کن؛ idempotency لازم است.
- PEL رشد می‌کند: workerها ack نمی‌زنند، خطا دارند یا پردازششان گیر کرده است؛ oldest idle، تعداد pending و وضعیت مصرف‌کننده را پایش کن.
- حافظه زیاد می‌شود: `XLEN`, نرخ `XADD`, retention, payload و replica/AOF buffer را با هم بررسی کن.
- worker زنده به نظر می‌رسد ولی پیام claim شده: حد idle از زمان پردازش واقعی کوتاه‌تر است یا heartbeat مدل نشده است.
- پیام ناپدید شده: بررسی کن آیا trim/XDEL انجام شده، group از چه ID شروع کرده، و آخرین write پس از failover باقی مانده یا نه.

## تمرین با پاسخ

1. چرا Stream از Pub/Sub بهتر می‌تواند پس از disconnect مصرف‌کننده بازیابی شود؟
2. اگر پیام برای دیتابیس ثبت شد ولی قبل از `XACK` برنامه crash کرد، چه رخ می‌دهد؟
3. چرا کوتاه‌کردن idle timeout ممکن است دوباره‌کاری ایجاد کند؟
4. چه چیزی را باید قبل از `XTRIM` بررسی کرد؟
5. آیا `WAIT 1 100` تضمین می‌کند پیام بعد از هر failover وجود دارد؟
6. طراحی کن برای event سفارش، مصرف‌کنندهٔ billing و analytics هرکدام به تاریخچهٔ مستقل نیاز دارند؛ آیا یک group مشترک جواب می‌دهد؟

<details><summary>پاسخ‌های تشریحی</summary>

1. خود Stream entryها را نگه می‌دارد و group وضعیت تحویل/تأیید را ثبت می‌کند؛ Pub/Sub پیام آفلاین را ذخیره یا replay نمی‌کند.
2. entry هنوز pending است و ممکن است پس از recovery دوباره پردازش شود. این رفتار تحویل حداقل یک‌بار در سطح برنامه ایجاد می‌کند؛ event باید idempotent باشد.
3. کارگر کند ممکن است هنوز کار را انجام دهد، درحالی‌که worker دیگری entry را claim می‌کند. دو worker اکنون اثر هم‌زمان می‌زنند.
4. lag گروه‌ها، pendingها، retention موردنیاز، امکان replay/restore و اینکه پیام از منبع دیگری قابل بازسازی هست یا نه.
5. خیر. `WAIT` انتشار به replica را تقویت می‌کند اما مستند رسمی آن را تضمین absolute برای انتخاب replica در همهٔ شرایط failover نمی‌داند.
6. معمولاً برای هر مصرف‌کنندهٔ منطقی group جدا می‌سازی، چون cursor/ack مستقل لازم است. در عوض هزینهٔ نگهداری Stream و PELها و policy retention را می‌پذیری.

</details>

## آزمون کوتاه

### ۱. `XACK` را چه زمانی می‌زنیم؟

<details><summary>پاسخ</summary>

پس از موفقیت اثر جانبی برنامه، با فرض اینکه اثر جانبی در تکرار امن باشد.

</details>

### ۲. `>` در `XREADGROUP` یعنی چه؟

<details><summary>پاسخ</summary>

entryهایی که هنوز به هیچ مصرف‌کننده‌ای از آن group تحویل نشده‌اند.

</details>

### ۳. پیام pending را چگونه بازیابی می‌کنیم؟

<details><summary>پاسخ</summary>

وضعیت را با `XPENDING` می‌بینیم و پس از تعیین حد idle از `XCLAIM` یا `XAUTOCLAIM` استفاده می‌کنیم.

</details>

### ۴. آیا Streams exactly-once برای اثر بیرونی می‌دهد؟

<details><summary>پاسخ</summary>

خیر؛ اثر بیرونی و ack یک تراکنش مشترک ندارند. idempotency و هماهنگی اپلیکیشن لازم است.

</details>

### ۵. چرا trimming خطرناک است؟

<details><summary>پاسخ</summary>

ممکن است eventی حذف شود که مصرف‌کنندهٔ عقب‌مانده یا فرآیند بازیابی هنوز نیاز دارد.

</details>

### ۶. آیا `WAIT` failover را کاملاً بدون فقدان می‌کند؟

<details><summary>پاسخ</summary>

نه؛ احتمال را پایین می‌آورد، ولی تضمین مطلق نیست.

</details>

## منابع

### انگلیسی و رسمی

- [مستند Redis Streams](https://redis.io/docs/latest/develop/data-types/streams/)
- [راهنمای Streaming و انتخاب Pub/Sub یا Streams](https://redis.io/docs/latest/develop/use-cases/streaming/)
- [فرمان XREADGROUP](https://redis.io/docs/latest/commands/xreadgroup/)
- [فرمان XAUTOCLAIM](https://redis.io/docs/latest/commands/xautoclaim/)
- [مقالهٔ واقعی Netflix دربارهٔ WAL، Kafka و EVCache](https://netflixtechblog.com/building-a-resilient-data-platform-with-write-ahead-log-at-netflix-127b6712359a)

### فارسی

- [آموزش فارسی Redis در زبان سلام؛ آموزش مرحله‌ای و مرجع فرمان‌ها](https://www.salamlang.ir/std/db/redis/)
- [ویدئوی فارسی Redis Streams و consumer group](https://www.youtube.com/watch?v=_IcgS_NuV-k)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

منابع فارسیِ پیدا‌شده برای Streams و state بازیابی پوشش محدودی دارند؛ درس حاضر برای یادگیری این بخش کافی نوشته شده و لینک‌ها مکمل‌اند. رفتار فرمان را برای نسخهٔ واقعی خودت در مستند رسمی همان نسخه دوباره کنترل کن.

</div>
