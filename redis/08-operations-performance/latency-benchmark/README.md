<div dir="rtl" align="right">

# Latency، pipeline و benchmark در Redis

> English edition: [Redis Latency, Pipelining, and Benchmarking](README.en.md)

> مسیر: فصل ۸، عملیات و کارایی · سطح: میانی · زمان: ۷۰ تا ۱۱۰ دقیقه
>
> benchmark را روی Redis آزمایشی یا staging اختصاصی اجرا کن؛ load test سرور مشترک می‌تواند سرویس دیگران را مختل کند.

## هدف یادگیری

- latency یک فرمان، round-trip شبکه و latency کامل درخواست برنامه را از هم جدا کنی.
- pipeline را برای کاهش RTT استفاده کنی و محدودیت atomicity/batch size آن را بدانی.
- `redis-benchmark`, `redis-cli --latency` و آزمون workload واقعی را مقایسه کنی.
- p50/p95/p99, throughput, concurrency و saturation را درست بخوانی.
- یک benchmark قابل‌تکرار و قابل‌مقایسه بنویسی.

## latency کجا صرف می‌شود؟

```text
Application -> pool/serialize -> network RTT -> Redis queue/command -> network -> parse -> app logic
```

Fast بودن server-side command به معنی latency کم برای درخواست end-to-end نیست. pool exhaustion, DNS/TLS, RTT, packet loss, صف server, slow command, CPU, persistence/eviction و client serialization هم دخیل‌اند. Average latency ممکن است دم سنگین را پنهان کند؛ p95 و p99 بخشی از تجربهٔ کاربر را بهتر نشان می‌دهند.

## ۱. Pipeline و round-trip

اگر ۱۰۰ دستور را یکی‌یکی بفرستی، client برای هرکدام رفت‌وبرگشت دارد. Pipeline چند فرمان را پشت‌سرهم ارسال می‌کند و بعد پاسخ‌ها را دریافت می‌کند؛ هزینهٔ RTT به ازای هر command کم می‌شود. Redis هنوز آن فرمان‌ها را اجرا می‌کند و client پاسخ‌ها را buffer می‌کند.

```text
SET lab:pipeline:a 1
INCR lab:pipeline:a
GET lab:pipeline:a
```

با client library این سه را در یک pipeline ارسال کن؛ در `redis-cli` هر خط جداگانه round-trip است. Pipeline **atomic نیست** و سایر clientها ممکن است بین فرمان‌ها اجرا شوند. اگر command semantics atomic لازم دارد، فرمانی مثل `INCR`, `MGET` یا Lua/transaction را بررسی کن.

### اندازهٔ batch

- batch کوچک: RTT savings کم‌تر، memory کم‌تر و tail latency کنترل‌شده.
- batch بزرگ: throughput بهتر تا حدی، ولی پاسخ‌ها buffer می‌شوند، memory/CPU بالا می‌رود و batch ممکن است latency یک درخواست را بیشتر کند.
- به جای pipeline بی‌نهایت، batch size، max outstanding bytes، timeout و backpressure تعیین کن.

## ۲. Benchmark ابزار و محدودیت‌ها

در محیط محلی و با توجه به نسخهٔ نصب‌شده:

```text
redis-benchmark -t set,get -n 100000 -c 50 -P 16 --csv
redis-cli --latency
```

گزینهٔ `-t` workload فرمانی، `-n` تعداد request، `-c` concurrency و `-P` تعداد request pipeline در client benchmark را تعیین می‌کند. جزئیات فلگ در نسخهٔ `redis-benchmark --help` را بخوان. Benchmark synthetic است؛ key size, value size, hit ratio, TLS, persistence, eviction, data type, geographic RTT و production client را کامل مدل نمی‌کند.

Benchmark مهندسی‌شده:

1. baseline را با همان Redis version, CPU/memory, network/TLS, config ثبت کن.
2. read/write mix, payload bytes, key distribution/hot keys, TTL و data type را شبیه‌سازی کن.
3. از concurrency پایین شروع و مرحله‌به‌مرحله افزایش بده.
4. throughput (ops/s) را در برابر p50/p95/p99 latency رسم/ثبت کن.
5. CPU, memory/RSS, evictions, persistence, replication lag و network را هم جمع کن.
6. هر بار یک عامل را تغییر بده و چند بار اجرا کن.
7. load را کم/متوقف کن و سلامت/پاک‌سازی lab dataset را بررسی کن.

حداکثر ops/s به‌تنهایی هدف خوب نیست؛ latency زیر حد SLO در workload واقعی هدف است.

## ۳. End-to-end measurement

`redis-cli --latency` نمونه‌برداری از مسیر client/server را نشان می‌دهد، اما metric کامل app نیست. در application histogram بگذار:

- زمان گرفتن connection از pool.
- زمان request/response Redis.
- command name/operation class، نه payload یا secret.
- timeout, error, retry count.
- endpoint/business operation total duration.

SLOWLOG زمان server-side اجرای command را ثبت می‌کند و latency شبکه/صف client/connection pool را نمی‌بیند. پس SLOWLOG پاک بودن به معنی endpoint سریع بودن نیست؛ برعکس end-to-end کند و SLOWLOG پایین می‌تواند مشکل network/client باشد.

## تجربهٔ واقعی: GitLab و eviction-driven latency

در مقالهٔ فنی GitLab، latency burstهای یک ثانیه‌ای Redis با رسیدن حافظه به `maxmemory` و burstهای eviction همبستگی داشت. تیم با ابزار BPF رفتار را تحلیل کرد و فهمید تعداد زیادی eviction کوچک در کنار feedback loop به throughput فشار می‌آورد؛ این رخداد نتیجهٔ benchmark `redis-benchmark` نبود، بلکه مثال واقعیِ اهمیت بررسی سیستم زیر بار، eviction، latency tail و queueing است. [تحلیل فنی GitLab با BPF](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

## عیب‌یابی مرحله‌ای

1. تأیید کن bottleneck Redis است یا pool/network/application.
2. p95/p99 را با SLOWLOG و `LATENCY` مقایسه کن.
3. `INFO stats`, `INFO memory`, `INFO persistence`, `INFO replication` را در همان بازه بررسی کن.
4. command complexity و حجم collectionها را برای big key/big result بسنج.
5. concurrency/retry storm و head-of-line blocking را ببین.
6. تغییر را روی workload ثابت آزمایش کن؛ latency improvement را با error rate و durability cost معامله نکن.

## تمرین

1. دو benchmark با `-P 1` و `-P 16` اجرا و latency و throughput را مقایسه کن.
2. average را با p95/p99 مقایسه کن؛ چه تعداد کاربر tail را حس می‌کنند؟
3. اثر payload کوچک/بزرگ و concurrency را در محیط lab بررسی کن.
4. یک گزارش بنویس که شامل environment, commands, version, config, throughput, p50/p95/p99, CPU/RSS, eviction و نتیجهٔ محدود باشد.

**معیار پاسخ:** فقط یک عدد ops/s نیست؛ تنظیمات، percentile، operation mix، منابع و محیط اجرای تکرارپذیر باید ذکر شوند.

## دام‌ها

- **نتیجهٔ laptop را ظرفیت production می‌گیری:** hardware, network, TLS, payload و concurrency فرق دارد.
- **average را تنها می‌بینی:** tail latency و error rate ممکن است خراب باشند.
- **pipeline را atomic می‌پنداری:** آن فقط RTT را کم می‌کند.
- **pipeline خیلی بزرگ:** memory buffer و tail latency بدتر می‌شود.
- **benchmark در ساعت peak:** باعث تداخل و نتیجهٔ آلوده می‌شود.
- **تغییر چند config هم‌زمان:** علت بهبود/بدترشدن معلوم نیست.
- **SLOWLOG را end-to-end می‌خوانی:** زمان شبکه/queue/app در آن نیست.

## کوییز

### ۱. Pipeline چه چیزی را معمولاً کم می‌کند؟

<details><summary>پاسخ</summary>

تعداد round-trip network به ازای commandها.

</details>

### ۲. آیا pipeline atomic است؟

<details><summary>پاسخ</summary>

خیر؛ commandهای clientهای دیگر ممکن است بین آن‌ها اجرا شوند.

</details>

### ۳. چرا p95/p99 را می‌سنجی؟

<details><summary>پاسخ</summary>

tail latency را می‌بینی که average پنهان می‌کند.

</details>

### ۴. آیا ops/s بالا اثبات می‌کند production آماده است؟

<details><summary>پاسخ</summary>

خیر؛ workload، error rate، latency هدف، منابع، failure و deployment مشابه لازم است.

</details>

### ۵. SLOWLOG چه چیزی را نمی‌بیند؟

<details><summary>پاسخ</summary>

network RTT، client pool wait و کل زمان endpoint.

</details>

### ۶. چرا GitLab مقاله را می‌خوانیم؟

<details><summary>پاسخ</summary>

برای نمونهٔ واقعی که eviction burst و latency می‌توانند تحت workload تولیدی مرتبط شوند؛ نه برای کپی‌کردن benchmark عددی.

</details>

## منابع

### انگلیسی و رسمی

- [Redis pipelining](https://redis.io/docs/latest/develop/using-commands/pipelining/)
- [Redis benchmark methodology/tools](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/benchmarks/)
- [Diagnosing latency](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/latency/)
- [GitLab: Redis latency spikes diagnosed with BPF](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

### فارسی

- [ویدئوی فارسی Pipeline و Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

منابع فارسی برای benchmark قابل‌تکرار محدودند؛ لَب و معیارها در این فایل توضیح داده شده. نسخهٔ ابزار و config را در خروجی آزمایش خودت ثبت کن.

</div>
