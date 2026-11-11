<div dir="rtl" align="right">

# RAM، maxmemory و eviction policy

> English edition: [RAM, maxmemory, and Eviction Policies](../../../../en/redis/08-operations-performance/memory-eviction/README.md)

> مسیر: فصل ۸ · سطح: میانی · زمان: ۷۰ تا ۱۰۰ دقیقه
>
> آزمایش `CONFIG SET` یا سیاست eviction را فقط روی Redis disposable انجام بده؛ حذف key در حافظه ممکن است دادهٔ برگشت‌ناپذیر را از بین ببرد.

## هدف یادگیری

- dataset memory را از RSS کل process و حافظهٔ host جدا کنی.
- `maxmemory`, policy و sampling را بر اساس نوع داده انتخاب کنی.
- `evicted_keys`, hit/miss و fragmentation را کنار هم پایش کنی.
- cold cache, stampede, background save و replication buffer را در capacity لحاظ کنی.
- بدانی eviction برای cache چه زمانی مفید و برای state اصلی چه زمانی خطرناک است.

## ایدهٔ مرکزی

Redis دادهٔ زیادی را در RAM نگه می‌دارد، ولی حافظه فقط member/value نیست: key/object metadata, allocator fragmentation, client buffers, replication/AOF buffers, fork copy-on-write و page cache هم دخیل‌اند. `maxmemory` حد رفتاری eviction را تنظیم می‌کند؛ این عدد را مساوی تمام RAM ماشین نگذار.

```text
Host RAM budget
├── Redis dataset + internal overhead
├── client/replication/persistence buffers
├── fork/copy-on-write headroom
└── OS + sidecars + safety reserve
```

## ۱. اندازه‌گیری حافظه

```text
INFO memory
INFO stats
MEMORY STATS
MEMORY DOCTOR
MEMORY USAGE cache:product:501
```

به `used_memory`, `used_memory_rss`, peak, fragmentation, `maxmemory` و fragmentation توجه کن. `used_memory_rss` از RAM resident process می‌گوید؛ `used_memory` از تخصیص‌های Redis. fragmentation بالا الزاماً leak نیست، اما رشد RSS بی‌تناسب با dataset باید تحلیل شود. `MEMORY USAGE` تخمین هزینهٔ key مشخص می‌دهد؛ آن را به تعداد key ضرب کن و با نمونه/واقعیت validate کن.

پیش از maxmemory، هزینهٔ value serialization، تعداد fieldهای Hash، TTL keyهای cache، growth rate، replica/AOF buffer و save peak را در capacity plan بیاور.

## ۲. policyها

| Policy | دامنهٔ candidate | انتخاب |
| --- | --- | --- |
| `noeviction` | key خودکار حذف نمی‌شود | writeای که حافظهٔ بیشتر می‌خواهد error می‌دهد |
| `allkeys-lru` | هر key | حذف approximate least-recently-used |
| `allkeys-lfu` | هر key | حذف approximate least-frequently-used |
| `allkeys-random` | هر key | انتخاب تصادفی |
| `volatile-lru` | فقط keyهای دارای TTL | LRU تقریبی میان keyهای expireدار |
| `volatile-lfu` | فقط keyهای دارای TTL | LFU تقریبی میان keyهای expireدار |
| `volatile-random` | فقط TTLدارها | تصادفی از همان زیرمجموعه |
| `volatile-ttl` | فقط TTLدارها | key با TTL کوتاه‌تر را ترجیح می‌دهد |

نام/جزئیات سیاست را با نسخه چک کن. LRU/LFU Redis با نگهداری exact access history عمل نمی‌کند؛ نمونه‌برداری/algorithm آن approximate است. Policyهای `volatile-*` اگر key بدون TTL قابل evict کافی نداشته باشند، رفتار رد write شبیه noeviction می‌تواند رخ دهد.

### تصمیم سریع

- cache خالص با TTL اختیاری: `allkeys-lru` یا `allkeys-lfu` را با workload compare کن.
- همهٔ keyها منقضی‌شونده‌اند و persistent state در همان DB هست: `volatile-*` ممکن است بخشی از طراحی باشد، اما domain separation بهتر می‌تواند واضح‌تر باشد.
- state اصلی/queue که حذفش مجاز نیست: eviction خودکار را برای keyspace آن نپذیر؛ حافظه/پارتیشن و `noeviction`/capacity را با error handling برنامه طراحی کن.

از یک Redis instance برای cache و durable queue استفاده کنی، eviction همان keyspace می‌تواند پیام یا state مهم حذف کند؛ workloadها را جدا یا eviction boundary را واضح کن.

## ۳. رفتار کلیدی `maxmemory`

هنگام write که حافظه بالاتر می‌رود، Redis policy را برای آزادکردن حافظه اعمال می‌کند. در `noeviction` writeهایی که حافظه اضافه لازم دارند error می‌شوند؛ خواندن ادامه دارد. این خطا باید application-level کنترل شود. خطاهای `OOM command not allowed...` را با alert ببین.

```text
CONFIG GET maxmemory
CONFIG GET maxmemory-policy
INFO stats
```

`evicted_keys` افزایش eviction را نشان می‌دهد. Hit ratio را در طول زمان با hit/miss app و Redis تطبیق بده؛ یک نرخ eviction بالا می‌تواند hit rate را پایین آورد و database را overload کند. Sample size policy را فقط پس از اندازه‌گیری تغییر بده؛ دقت بیشتر می‌تواند CPU و فشار latency را تغییر دهد.

## ۴. تجربهٔ واقعی: burst eviction و GitLab

تیم GitLab در تحلیل Redis تولیدی‌اش نشان داد زمانی که cache به `maxmemory` رسید، evictionها در burst اتفاق می‌افتادند و requestهای بسیار کند با آن هم‌زمان بودند. مقاله حتی شرح می‌دهد تعداد زیادی کار کوچک، نه یک عملیات منفرد بزرگ، throughput را کم می‌کرد. نتیجهٔ عملی این است که انتخاب policy پایان کار نیست: memory growth, hit/miss, eviction rate, p95/p99 و load دیتابیس پشت cache را همزمان پایش کن. [مقالهٔ BPF و Redis latency در GitLab](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

## ۵. cache miss و stampede

اگر چندین درخواست هم‌زمان با TTL مشترک expire شوند، همه می‌توانند به database بروند. eviction هم cache hit را کم و این burst را تشدید می‌کند. راهکارها:

- TTL jitter برای پخش‌کردن expiryها.
- single-flight/locking محدود برای یک key داغ، با timeout و fencing/idempotency.
- stale-while-revalidate یا soft/hard TTL، اگر نیاز محصول اجازه دهد.
- rate-limit/circuit breaker و محدودیت concurrency برای origin database.
- warmup کنترل‌شده و cache miss observability.

هیچ lock ساده‌ای جای correctness منبع داده را نمی‌گیرد. fallback اگر بی‌سقف باشد می‌تواند outage Redis را به outage دیتابیس تبدیل کند.

## ۶. Lab و دام‌ها

در lab و با dataset ساختگی، مقدار کم `maxmemory` و policy را فقط با container جدا تست کن. مشاهده کن چه وقت `evicted_keys` زیاد می‌شود یا `noeviction` خطا می‌دهد. بعد تنظیم را به حالت اولیه برگردان. این فایل command تغییر policy را برای Redis واقعی توصیه نمی‌کند.

- **`maxmemory` برابر RAM host:** برای OS, fork, sidecars و buffers headroom نمی‌ماند.
- **eviction به معنی expire دانسته شده:** TTL زمان حذف را تعیین می‌کند؛ eviction می‌تواند قبل از TTL key را حذف کند.
- **noeviction به معنی «بدون ریسک» است:** write fail می‌شود و application باید handle کند.
- **memory fragmentation را با leak یکی می‌گیری:** trend, allocator, RSS و workload را تحلیل کن.
- **فقط `used_memory` را می‌بینی:** RSS و peak هنگام background operation را هم ببین.
- **policy LFU/LRU دقیق فرض می‌شود:** الگوریتم approximate و sampling دارد.
- **Cache outage را ساده فرض می‌کنی:** DB rate limit/circuit breaker و recovery load لازم است.

## تمرین با پاسخ

1. برای cache قابل‌بازسازی، queue و session policy جدا تعیین کن.
2. اگر `evicted_keys` بالا و hit ratio پایین می‌رود چه metricهای بعدی را می‌سنجی؟
3. چرا `volatile-lru` اگر بعضی keyهای مهم TTL ندارند خطرناک است؟
4. یک postmortem hypothetical بنویس: cache cold بعد از failover، DB pool پر شده؛ چه safeguardهایی لازم بود؟

**راهنمای پاسخ:** workloadهای مختلف را از هم جدا کن؛ memory growth, RSS, free RAM, fork, key size, access distribution, traffic origin و error rate را مقایسه کن. volatile policy فقط TTLدارها را می‌تواند حذف کند، پس candidate تهی یا key اشتباه سبب write error/دادهٔ حفظ‌نشدن می‌شود.

## کوییز

### ۱. `allkeys-lru` چه چیزی را بررسی می‌کند؟

<details><summary>پاسخ</summary>

هر key می‌تواند candidate باشد؛ استفادهٔ اخیر با LRU تقریبی تخمین می‌شود.

</details>

### ۲. `volatile-lru` چه فرقی دارد؟

<details><summary>پاسخ</summary>

تنها keyهایی که TTL دارند در candidate set هستند.

</details>

### ۳. `noeviction` چه می‌کند؟

<details><summary>پاسخ</summary>

key را حذف نمی‌کند؛ write نیازمند RAM جدید ممکن است رد شود.

</details>

### ۴. چرا `maxmemory` نباید تمام RAM باشد؟

<details><summary>پاسخ</summary>

process/OS overhead، bufferها، fork و سایر سرویس‌ها memory می‌خواهند.

</details>

### ۵. آیا eviction تنها می‌تواند latency را افزایش دهد؟

<details><summary>پاسخ</summary>

eviction هزینه دارد و cache hit را کاهش می‌دهد؛ origin DB ممکن است دچار burst شود و tail latency بدتر شود.

</details>

### ۶. GitLab case چه درس عملی دارد؟

<details><summary>پاسخ</summary>

memory threshold و burst eviction را همراه latency و downstream load بررسی کن؛ از یک عدد maxmemory نتیجه نگیری.

</details>

## منابع

### انگلیسی و رسمی

- [Redis eviction](https://redis.io/docs/latest/develop/reference/eviction/)
- [Memory optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/)
- [Memory usage and INFO](https://redis.io/docs/latest/commands/info/)
- [Cache patterns and stampede concepts](https://redis.io/docs/latest/develop/use-cases/cache-aside/)
- [GitLab Redis latency and eviction study](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

### فارسی

- [مرور فارسی memory و ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [آموزش Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی دربارهٔ Redis eviction و maxmemory](https://www.google.com/search?q=Redis+maxmemory+eviction+آموزش+فارسی)

منابع فارسی فنی eviction کم‌اند؛ سیاست‌ها و trade-offهای این درس برای انتخاب اولیه کافی‌اند. ظرفیت production را با load شبیه واقعی، نسخه و provider خودت اندازه بگیر.

</div>
