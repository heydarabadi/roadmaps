<div dir="rtl" align="right">

# پروژهٔ ۲ — پردازش رویداد سفارش با Redis Streams

> English edition: [Project 2 — Order Event Processing with Redis Streams](README.en.md)

> سطح: میانی · زمان: ۱۲۰ تا ۱۸۰ دقیقه · همهٔ کلیدها `lab:` دارند و فقط در Redis محلی تمرین می‌شوند.

## مسئله

سرویس سفارش پس از ثبت order، رویداد `created` منتشر می‌کند. workerهای مختلف آن را برای reservation، ایمیل یا گزارش می‌خوانند. مصرف‌کننده ممکن است crash کند؛ event باید برای گروه قابل‌پیگیری باشد، pending بماند و پس از موفقیت acknowledge شود. پیام ممکن است دوباره پردازش شود، پس side-effect باید idempotent باشد.

Streams در این پروژه log پیام و consumer group را فراهم می‌کنند؛ به‌تنهایی تضمین «دقیقاً یک بار اجرای side-effect در DB» نمی‌دهند. اگر business event حیاتی است، transactional outbox در DB یا broker مناسب را با معماری واقعی مقایسه کن.

## واژه‌ها و flow

- **Stream entry:** شناسهٔ مرتب و فیلد/مقدارهای یک event.
- **Consumer group:** چند worker که کارها را درون همان group تقسیم می‌کنند.
- **PEL (Pending Entries List):** پیام تحویل‌شده ولی ack نشده.
- **XACK:** اعلام اتمام برای group؛ باعث حذف خودکار event از stream نمی‌شود.
- **Claim/recovery:** انتقال pending قدیمی از consumer مرده به consumer زنده.
- **Idempotency:** اجرای دوبارهٔ یک event نتیجهٔ منطقی مضاعف نسازد.

```text
producer --XADD--> stream --> consumer group --> worker
                                       |            |
                                       |        side effect idempotent
                                       +--pending--XACK after success
```

## گام ۱ — ساخت stream و consumer group

از `0` برای خواندن از پیام‌های موجود شروع کن. اگر می‌خواهی group فقط پیام‌های آینده را بگیرد، `$` را هنگام ساخت به‌کار می‌بردی؛ در lab این انتخاب را آگاهانه کن.

```text
DEL lab:orders:events lab:orders:dead
XGROUP CREATE lab:orders:events order-workers 0 MKSTREAM
XINFO GROUPS lab:orders:events
```

اگر group از قبل وجود داشته باشد، `BUSYGROUP` می‌گیری. در پروژهٔ واقعی group را هر بار کورکورانه حذف/دوباره‌سازی نکن؛ حذف group cursor و pending را از بین می‌برد.

## گام ۲ — تولید رویداد

```text
XADD lab:orders:events * event_id evt-1001 order_id 1001 type order.created schema 1 customer_id 7
XADD lab:orders:events * event_id evt-1002 order_id 1002 type order.created schema 1 customer_id 8
XRANGE lab:orders:events - +
XLEN lab:orders:events
```

شناسهٔ stream با `*` ساخته می‌شود؛ `event_id` مستقل از stream ID برای dedupe کاربرد دارد. payload را version کن، secret/اطلاعات غیرلازم را در event نگذار و با فیلدهای کوچک و روشن شروع کن.

## گام ۳ — دریافت با group

```text
XREADGROUP GROUP order-workers worker-1 COUNT 10 STREAMS lab:orders:events >
XPENDING lab:orders:events order-workers
XINFO CONSUMERS lab:orders:events order-workers
```

`>` یعنی entryهای جدیدی که هنوز به این group تحویل نشده‌اند. پس از دریافت، entry برای consumer pending است تا `XACK` شود. اگر worker دوباره `>` بخواند، pending قبلی خودکار بازپخش نمی‌شود؛ pending را جدا می‌بینی و reclaim/retry طراحی می‌کنی.

## گام ۴ — شبیه‌سازی موفقیت و ack

از خروجی `XREADGROUP` شناسهٔ واقعی پیام را بردار (شبیه `1794384000000-0`) و به‌جای placeholder در فرمان زیر بگذار:

```text
XACK lab:orders:events order-workers <STREAM-ID-FROM-OUTPUT>
XPENDING lab:orders:events order-workers
```

پس از ack، pending آن پیام برای group کم می‌شود، اما پیام همچنان در stream می‌ماند. Ack را **بعد از** اتمام side-effect بزن. اگر پیش از ذخیرهٔ نتیجه ack کنی و worker crash شود، group دیگر پیام را pending نمی‌بیند ولی side-effect انجام نشده است.

## گام ۵ — crash، pending و claim

پیام جدید درج و worker-1 بخواند ولی ack نکند:

```text
XADD lab:orders:events * event_id evt-1003 order_id 1003 type order.created schema 1 customer_id 9
XREADGROUP GROUP order-workers worker-1 COUNT 10 STREAMS lab:orders:events >
XPENDING lab:orders:events order-workers
```

در application، اگر consumer-1 از کار افتاد، consumer سالم بعد از مدت idle مناسب پیام را reclaim می‌کند. در CLI syntax نسخه را چک کن؛ `XAUTOCLAIM` در نسخه‌های پشتیبان‌شده به شکل زیر است:

```text
XAUTOCLAIM lab:orders:events order-workers worker-2 60000 0-0 COUNT 10
```

عدد `60000` حداقل idle time به میلی‌ثانیه است. اگر هنوز worker-1 فعال باشد و processing طول بکشد، claim زودهنگام دوگانه‌کاری می‌سازد؛ timeout را از p99 processing، pause و heartbeat انتخاب کن.

## گام ۶ — idempotent processing

برای هر event یک شناسهٔ ثابت بساز. برنامه پیش از side-effect بررسی می‌کند `processed:<event_id>` قبلاً ثبت نشده باشد. در یک Redis ساده، تغییر state و marker را می‌توان در script کوتاه اتمیک کرد (cluster deployment: keyهای اسکریپت را هم‌slot کن):

```lua
-- KEYS[1] = lab:order:1001
-- KEYS[2] = lab:processed:evt-1001
-- ARGV[1] = new status; ARGV[2] = stream event ID
if redis.call('EXISTS', KEYS[2]) == 1 then
  return 0
end
redis.call('HSET', KEYS[1], 'status', ARGV[1], 'last_event_id', ARGV[2])
redis.call('SET', KEYS[2], '1', 'EX', 604800)
return 1
```

نمایش در `redis-cli` با جایگذاری دقیق مقادیر:

```text
HSET lab:order:1001 status accepted
EVAL "if redis.call('EXISTS',KEYS[2]) == 1 then return 0 end; redis.call('HSET',KEYS[1],'status',ARGV[1],'last_event_id',ARGV[2]); redis.call('SET',KEYS[2],'1','EX',604800); return 1" 2 lab:order:1001 lab:processed:evt-1001 accepted 1794384000000-0
HGETALL lab:order:1001
GET lab:processed:evt-1001
```

این script فقط یک simulation در Redis است؛ برای پرداخت خارجی، ایمیل یا DB دیگر، script Redis نمی‌تواند transaction بین سیستم‌ها بسازد. از idempotency key در مقصد/API، outbox/inbox یا workflow جبرانی استفاده کن. Redis Lua در صورت runtime error rollback تراکنش SQL نمی‌کند؛ فرمان‌ها را prevalidate کن.

پس از side-effect موفق و ثبت marker، `XACK` کن. اگر worker بعد از script و قبل از ack crash کند، پیام دوباره می‌آید ولی marker جلوی تکرار تغییر را می‌گیرد؛ سپس همان event را ack کن.

## گام ۷ — retry و dead letter

برای retry سیاست شفاف بساز:

1. خطای موقت (مثلاً timeout dependency) را با backoff و سقف تلاش retry کن.
2. پیام pending را بی‌نهایت با `XAUTOCLAIM` دور نزن؛ retry counter/آخرین خطا را پایش کن.
3. پس از threshold، علت و event id را در `lab:orders:dead` بنویس، سپس پیام اصلی را ack کن تا worker سالم بماند.
4. dead letter را دستی/کنترل‌شده replay کن؛ قبل از replay idempotency و schema را بررسی کن.
5. ثبت dead-letter و ack اگر در دو فرمان جدا انجام شود بینشان crash ممکن است؛ برای production Lua یا consumer workflow با dedupe و reconciliation طراحی کن.

نمونهٔ dead letter آموزشی (ابتدا شناسهٔ پیام واقعی را جایگزین کن):

```text
XADD lab:orders:dead * original_stream lab:orders:events original_id <STREAM-ID> reason dependency-timeout event_id evt-1003
```

## گام ۸ — retention و trim

Stream رشد می‌کند. `XTRIM` با MAXLEN/MINID اندازه/سن entry را محدود می‌کند؛ trim کردن پیام pending/قدیمی پیش از مصرف یا replay می‌تواند قابلیت recovery را از بین ببرد. retention را با outage طولانی، سرعت ورود، بزرگ‌ترین consumer lag، audit requirement و replay window هماهنگ کن. اول consumer group lag/pending را بررسی کن، بعد trim policy بساز. `XDEL` هم فقط entry را حذف می‌کند و حذف از PEL/group semantics جداگانه دارد.

## عیب‌یابی

| نشانه | تفسیر و اقدام |
| --- | --- |
| `NOGROUP` | group ساخته نشده/نام اشتباه است؛ group lifecycle را کنترل کن. |
| پیام‌ها تکراری‌اند | retry/claim یا crash قبل از ack؛ side-effect را idempotent کن. |
| PEL رشد می‌کند | worker خطا/کندی دارد یا ack نمی‌زند؛ `XPENDING`, `XINFO CONSUMERS`, dependency و processing time را بررسی کن. |
| worker جدید چیزی نمی‌گیرد | cursor `>` فقط entry جدید می‌گیرد؛ pending قدیمی را با pending-read/claim مدیریت کن. |
| پیام ناپدید شده | trim/delete یا start cursor؛ stream history و retention را بررسی کن. |
| دوباره‌کاری side-effect | marker ID ندارید، marker TTL زود تمام می‌شود یا event_id غیرثابت است. |
| یک event دائماً retry می‌شود | poison message؛ سقف تلاش، dead-letter، هشدار و مسیر replay تعریف کن. |

## پاسخ نمونهٔ طراحی

- رویداد order با `XADD`, event id immutable, schema version و producer idempotency.
- consumer group به ازای هر نقش مستقل (fulfillment, analytics)؛ replica consumerهای همان role در یک group.
- ack فقط پس از side-effect ثبت‌شده؛ pending idle timeout از latency/backoff استخراج.
- dedupe در هر handler بر اساس event_id؛ side-effect خارجی idempotency token خودش را دارد.
- retry محدود، dead-letter queue، alert روی PEL و oldest pending age.
- trimming بعد از retention طولانی‌تر از outage و replay window.
- backup/persistence و source of truth مطابق اهمیت سفارش؛ stream cache transient را با event log ماندگار اشتباه نمی‌گیریم.

## تحویل و Rubric (۱۲ امتیاز)

1. topology producer/group/consumer و دلیل تعداد groupها: ۲
2. pending/ack/crash/reclaim: ۲
3. dedupe و idempotency واقعی: ۲
4. retry/dead letter و poison-message handling: ۲
5. retention/trim و observability: ۲
6. مرز تضمین Redis و external DB/payment: ۲

## پاک‌سازی lab

```text
DEL lab:orders:events lab:orders:dead lab:order:1001 lab:processed:evt-1001
```

این cleanup فقط همین نام‌های آموزشی را هدف می‌گیرد؛ groupها همراه حذف stream حذف می‌شوند. هیچ‌وقت برای پاک‌کردن پروژه از `FLUSHDB` یا `FLUSHALL` استفاده نکن.

## منابع تکمیلی

- [Redis Streams](https://redis.io/docs/latest/develop/data-types/streams/)
- [`XREADGROUP`](https://redis.io/docs/latest/commands/xreadgroup/), [`XPENDING`](https://redis.io/docs/latest/commands/xpending/), [`XACK`](https://redis.io/docs/latest/commands/xack/), [`XAUTOCLAIM`](https://redis.io/docs/latest/commands/xautoclaim/)
- [Transactional Outbox pattern — Microsoft](https://learn.microsoft.com/azure/architecture/databases/guide/transactional-out-box-cosmos)
- [ویدئوی فارسی Redis Streams](https://www.youtube.com/watch?v=_IcgS_NuV-k)
- برای نمونهٔ طراحی WAL/Kafka، [مقالهٔ Netflix](https://netflixtechblog.com/building-a-resilient-data-platform-with-write-ahead-log-at-netflix-127b6712359a) را با دقت بخوان: آن case از Kafka استفاده می‌کند، نه Redis Streams.

</div>
