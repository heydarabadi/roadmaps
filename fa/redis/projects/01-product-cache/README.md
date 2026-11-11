<div dir="rtl" align="right">

# پروژهٔ ۱ — Cache-aside برای کاتالوگ محصول

> English edition: [Project 1 — Cache-Aside for a Product Catalog](../../../../en/redis/projects/01-product-cache/README.md)

> سطح: مقدماتی تا میانی · زمان: ۹۰ تا ۱۵۰ دقیقه · محیط: Redis محلی فصل صفر

## مسئله و نتیجهٔ مطلوب

فروشگاه اطلاعات محصول را در پایگاه دادهٔ اصلی نگه می‌دارد. خواندن‌های پرتکرار از Redis cache می‌شوند تا بار و latency دیتابیس اصلی کم شود. پاسخ cache ممکن است کوتاه‌مدت stale باشد؛ حذف Redis نباید منبع اصلی محصول را نابود کند.

در پایان باید بتوانی cache miss، outage، expire، invalidation، stampede و دادهٔ کهنه را با یک flow توضیح دهی. CLI این پروژه فقط رفتار را شبیه‌سازی می‌کند؛ کلید `lab:source:*` یک دیتابیس واقعی نیست.

## نیازمندی‌ها و قراردادها

- `product_id` کلید منبع اصلی است.
- پاسخ محصول تا ۵ دقیقه در cache بماند؛ در production TTL با jitter تصادفی شود.
- تغییر قیمت/وضعیت باید cache را invalidate یا نسخه‌بندی کند.
- Redis unavailable: برای محصول ضروری fallback به دیتابیس؛ برای صفحهٔ کم‌اهمیت می‌توان stale/fallback محدود داشت.
- cache hit/miss، DB fallback، error و latency را اندازه بگیر.
- Redis منبع حقیقت قیمت نیست؛ سفارش نهایی قیمت/موجودی را از منبع معتبر دوباره بررسی می‌کند.

## طراحی key/value

| کلید | محتوا | نقش |
| --- | --- | --- |
| `lab:source:product:42` | JSON شبیه رکورد DB (فقط simulation) | منبع شبیه‌سازی‌شده |
| `lab:cache:product:42` | payload cache | مقدار کوتاه‌عمر Redis |
| `lab:lock:product:42` | token موقت | قفل اختیاری برای کاهش هم‌زمانی rebuild |

در سرویس واقعی prefix و tenant boundary را استاندارد کن. value باید نسخهٔ schema داشته باشد اگر deployهای مختلف هم‌زمان آن را می‌خوانند.

## گام ۱ — ساخت دادهٔ مرجع شبیه‌سازی‌شده

در redis-cli:

```text
DEL lab:source:product:42 lab:cache:product:42 lab:lock:product:42
SET lab:source:product:42 '{"id":42,"name":"کیبورد","price":125000,"active":true,"schema":1}'
GET lab:source:product:42
```

`lab:source` صرفاً برای تمرین است. در برنامه واقعی DB اصلی خوانده می‌شود؛ دو نسخهٔ مستقل Redis که اینجا ساخته‌ای را source of truth فرض نکن.

## گام ۲ — Cache-aside با miss

منطق برنامه:

```text
1. value = GET cache-key
2. اگر value موجود بود: hit را ثبت کن و پاسخ بده
3. اگر نبود: miss را ثبت کن
4. value = read authoritative database
5. اگر محصول نبود: سیاست not-found/negative cache را اعمال کن
6. SET cache-key value EX ttl
7. پاسخ بده
```

اجرای دستی flow:

```text
GET lab:cache:product:42
GET lab:source:product:42
SET lab:cache:product:42 '{"id":42,"name":"کیبورد","price":125000,"active":true,"schema":1}' EX 300
TTL lab:cache:product:42
GET lab:cache:product:42
```

اولین GET cache باید nil بدهد؛ سپس برنامه از source می‌خواند و cache را پر می‌کند. `SET ... EX 300` هم write و TTL را در یک فرمان اعمال می‌کند، پس حالت «value ثبت شد اما TTL فراموش شد» کمتر می‌شود.

## گام ۳ — مشاهدهٔ hit، expire و miss

```text
GET lab:cache:product:42
PTTL lab:cache:product:42
```

GET مقدار را می‌دهد و `PTTL` میلی‌ثانیهٔ باقی‌مانده را نشان می‌دهد. برای دیدن expire بدون انتظار ۵ دقیقه، در lab مقدار کوتاه بگذار:

```text
SET lab:cache:short demo EX 3
TTL lab:cache:short
```

چند ثانیه بعد `GET lab:cache:short` را بزن. expire را با `DEL` دستی اشتباه نگیر؛ TTL پایان عمر خودکار key را مشخص می‌کند.

## گام ۴ — Update و invalidation

در سرویس واقعی ترتیب ساده این است: تراکنش DB commit شود، سپس cache key حذف شود؛ cache-aside بعدی مقدار جدید را از DB پر می‌کند.

```text
SET lab:source:product:42 '{"id":42,"name":"کیبورد","price":119000,"active":true,"schema":1}'
DEL lab:cache:product:42
GET lab:cache:product:42
```

آخرین GET باید miss باشد. برنامه سپس DB را می‌خواند و cache جدید می‌سازد. **Race:** اگر درخواست A قبل از commit مقدار قدیمی را از DB خوانده باشد ولی بعد از invalidation درخواست B cache تازه را بنویسد، A ممکن است stale payload را دوباره داخل cache بگذارد. راهکارهای متداول شامل versioned key، validation/retry، transactional outbox/event، compare version یا short TTL است؛ حذف ساده به‌تنهایی تمام raceهای cross-system را حل نمی‌کند.

## گام ۵ — Negative caching و stampede

برای ID ناموجود، هر miss می‌تواند فشار DB بسازد. می‌توان «not found» را برای TTL کوتاه cache کرد؛ هنگام ساخته‌شدن محصول باید همان negative entry invalidate شود. TTL طولانی باعث می‌شود محصول تازه ایجادشده پنهان بماند.

هنگام expire یک محصول داغ، هزاران درخواست می‌توانند هم‌زمان به DB بروند (**cache stampede**). ابزارهای طراحی:

- single-flight در هر application process، تا فقط یک درخواست rebuild کند.
- TTL jitter تا کلیدهای پرتعداد هم‌زمان expire نشوند.
- stale-while-revalidate برای پاسخ موقت کهنه، اگر نیاز کسب‌وکار اجازه دهد.
- lock کوتاه با token یکتا و unlock شرطی؛ lock برای correctness و تضمین انحصار مطلق کافی نیست، و lease/timeout/fencing باید بررسی شود.
- محدودکردن هم‌زمانی و محافظت circuit breaker برای DB.

مثال شبه‌کد lock:

```text
token = random unique value
if SET lock-key token NX PX 5000 succeeds:
    load DB; update cache; release lock only if stored token still equals token
else:
    wait briefly, read cache again, or use permitted stale value
```

unlock بی‌شرط `DEL lock-key` خطرناک است: lease اول expire می‌شود و worker دیگری lock جدید می‌گیرد؛ worker اول با DEL ممکن است lock worker دوم را پاک کند. برای unlock از compare-and-delete اتمیک با Lua یا primitive مناسب استفاده کن.

## گام ۶ — Outage و انتخاب محصول

اگر Redis از دسترس خارج شود، کل برنامه نباید بی‌محابا DB را flood کند. تصمیم بگیر: feature کم‌اهمیت fail open می‌شود؟ DB capacity چند read اضافه را تحمل می‌کند؟ timeout کوتاه، circuit breaker، concurrency limit و degraded response چیست؟ اگر قیمت/order از DB منبع اصلی می‌آید، cache فقط acceleration است. اگر session یا تصمیم risk-critical در Redis است، فقدان Redis ممکن است semantics سرویس را تغییر دهد و باید durability/HA جداگانه طراحی شود.

## ابزارهای مشاهده

در lab:

```text
INFO stats
INFO memory
MEMORY USAGE lab:cache:product:42
TTL lab:cache:product:42
```

در برنامه، این metricها را با label کم‌cardinality ثبت کن: `cache_hits_total`, `cache_misses_total`, `cache_errors_total`, `db_fallback_total`, `cache_fill_duration`, `redis_client_latency`. شناسهٔ کاربر/محصول را label metric نکن؛ cardinality metric store می‌تواند منفجر شود.

## تست سناریوها با جدول ذهنی

| سناریو | نتیجهٔ مطلوب | چیزی که پایش می‌کنی |
| --- | --- | --- |
| cache hit | پاسخ Redis بدون DB query | hit ratio و p95 |
| cache miss | DB read و cache fill | miss rate و DB fallback latency |
| محصول حذف‌شده | پاسخ not-found با negative TTL کوتاه | حذف منبع و invalidate |
| قیمت update | invalidate/version bump پس از DB commit | stale read window |
| Redis outage | timeout/fallback کنترل‌شده | error rate، DB saturation |
| کلید داغ expire | یک rebuild و کنترل concurrency | lock contention، DB QPS |
| Redis eviction | cache miss مجدد، منبع محفوظ | evicted_keys و DB capacity |

## ایرادهای رایج

- TTL را نمی‌گذاری یا روی key دیگری می‌گذاری.
- نتیجهٔ cache را قیمت قطعی checkout فرض می‌کنی.
- key قدیمی را invalidate نمی‌کنی یا invalidation را قبل از commit انجام می‌دهی.
- negative cache را طولانی می‌گذاری.
- cache outage را به‌صورت درخواست بی‌محدود DB ترجمه می‌کنی.
- برای جلوگیری از هر race یک lock توزیع‌شده اضافه می‌کنی بی‌آنکه lease/fencing و failure را بفهمی.
- eviction را شکست Redis می‌دانی؛ شاید policy `maxmemory` عمداً cache key را حذف کرده باشد.

## تحویل پروژه

یک صفحه بنویس: key schema، TTL/jitter، source of truth، invalidate flow، stale tolerance، outage fallback، stampede protection و metric. سپس به این سؤال‌ها پاسخ بده:

1. اگر Redis پاک شود، کدام داده را می‌توان از DB بازساخت؟
2. چه کسی قیمت checkout را تأیید می‌کند؟
3. حداکثر stale window قابل‌قبول چند است و از کجا آمده؟
4. در cache miss هم‌زمان چه سقفی برای DB concurrency داری؟
5. کدام metric باعث page/on-call می‌شود؟

### Rubric (۱۰ امتیاز)

- منبع authoritative و مرز cache: ۲
- TTL، key و invalidation: ۲
- Race/stampede/outage: ۲
- metric و fallback: ۲
- پاسخ به stale/consistency و محدودیت‌ها: ۲

## پاک‌سازی امن لَب

فقط keyهای دارای prefix همین پروژه را حذف کن:

```text
SCAN 0 MATCH lab:* COUNT 100
DEL lab:source:product:42 lab:cache:product:42 lab:lock:product:42 lab:cache:short
```

در دیتابیس مشترک `DEL lab:*` معتبر نیست؛ wildcard را به `DEL` نده و `FLUSHDB/FLUSHALL` را اجرا نکن.

## منابع تکمیلی

- [Cache-aside pattern — Microsoft](https://learn.microsoft.com/azure/architecture/patterns/cache-aside)
- [Redis caching patterns](https://redis.io/docs/latest/develop/use/patterns/)
- [TTL/EXPIRE](https://redis.io/docs/latest/commands/expire/)
- [مقالهٔ فارسی Redis در SalamLang](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی مزایای Redis](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)

</div>
