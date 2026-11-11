<div dir="rtl" align="right">

# پایش Redis: INFO، SLOWLOG، LATENCY و ابزارها

> English edition: [Monitoring Redis: INFO, SLOWLOG, LATENCY, and Tools](../../../../en/redis/08-operations-performance/monitoring-tools/README.md)

> مسیر: فصل ۸ · سطح: میانی · زمان درس و lab: ۷۰ تا ۱۰۰ دقیقه
>
> `MONITOR`, `CLIENT LIST` و خروجی command ممکن است payload/secret حساس داشته باشند؛ کوتاه و محدود از آن‌ها استفاده کن.

## هدف یادگیری

- با `INFO` وضعیت memory, ops, persistence, replication و keyspace را ببینی.
- فرق server command time با end-to-end latency را بدانی.
- `SLOWLOG`, `LATENCY`, `CLIENT LIST`, `redis-cli --stat` را متناسب با سؤال انتخاب کنی.
- برای production metric، alert و dashboard کم‌خطر طراحی کنی.
- بدانی Redis Insight ابزار مشاهده است؛ جای observability و policy امنیتی را نمی‌گیرد.

## مدل مشاهده‌پذیری

```text
Application SLI       Redis server metrics          Infrastructure
request p95/error  +  latency/ops/memory/eviction + CPU/RAM/network/disk
             \                |                 /
              -> time-correlated incident view <-
```

اول سؤال incident را مشخص کن: «کاربر کند است؟»، «Redis command کند است؟»، «pool connection بسته است؟»، «eviction رخ داده؟» یا «replica عقب افتاده؟». ابزار مناسب با سؤال فرق می‌کند.

## ۱. `INFO` و metricهای کلیدی

```text
INFO server
INFO clients
INFO memory
INFO stats
INFO persistence
INFO replication
INFO keyspace
```

| Metric/section | چه چیزی را نشان می‌دهد | سؤال عملی |
| --- | --- | --- |
| `connected_clients`, `blocked_clients` | connection و commandهای blocking | pool زیاد/worker گیرکرده؟ |
| `used_memory`, `used_memory_rss`, fragmentation | حافظهٔ Redis و process | headroom و fragmentation مناسب است؟ |
| `keyspace_hits`, `keyspace_misses` | درخواست lookup موفق/ناموفق | cache hit rate در حال افت است؟ |
| `evicted_keys`, `expired_keys` | key removal | maxmemory یا TTL چه اثری دارد؟ |
| `instantaneous_ops_per_sec`, `total_commands_processed` | بار فرمان‌ها | traffic اوج گرفته؟ |
| `rejected_connections`, error counters | بخشی از failureهای connection | limit یا resource مشکل دارد؟ |
| `aof_last_write_status`, `rdb_last_bgsave_status` | وضعیت persistence | آخرین save/write موفق است؟ |
| replication offsets/link | عقب‌ماندگی replica | read stale یا full sync risk وجود دارد؟ |
| keyspace per database | تعداد key و expiry per DB | data growth یا key distribution تغییر کرده؟ |

نام fieldها با نسخه تغییر می‌کند. Metricها را trend کن؛ snapshot لحظه‌ای کم‌تر از نرخ رشد و correlation با latency می‌گوید.

## ۲. latency و SLOWLOG

```text
SLOWLOG LEN
SLOWLOG GET 10
LATENCY LATEST
LATENCY DOCTOR
```

SLOWLOG زمان اجرای command در server-side را ثبت می‌کند، نه network round-trip, client pool wait و application time. آستانه و طول log قابل‌پیکربندی‌اند؛ payload یا command arguments در بعضی خروجی‌ها می‌آیند، پس read access محدود و retention کنترل‌شده باشد.

Latency monitor eventهای خاص را در صورت فعال‌بودن monitor threshold ثبت می‌کند. `LATENCY DOCTOR` توضیح اولیه می‌دهد، نه root cause قطعی. `redis-cli --latency` برای نمونه‌برداری سادهٔ client/server مناسب است؛ برنامه را با histogramهای endpoint مقایسه کن.

## ۳. ابزارها و خطرها

- **`MONITOR`:** جریان commandهای جاری را می‌بیند؛ سربار سنگین و احتمال مشاهدهٔ payload دارد. فقط brief, lab/staging, محدود و با خاموش‌کردن فوری.
- **`CLIENT LIST`:** برای پیدا کردن clientهای blocked/idle؛ address/name/command metadata حساس است.
- **`redis-cli --stat`:** آمار خلاصهٔ متنی برای مشاهدهٔ سریع.
- **`redis-cli --bigkeys`:** پیمایش keyspace و نمونه‌گیری بزرگ‌ترین keyها؛ روی production پرترافیک هزینه/بار و duplicate/scan semantics را در نظر بگیر.
- **Redis Insight:** GUI برای data exploration, command execution, profiling/metrics حسب نسخه؛ admin access محدود و browser remote access امن نگه دار.
- **Prometheus exporter/managed monitoring:** metric ingestion؛ label cardinality, credential, TLS, scraping rate را کنترل کن.

## ۴. Alert design

Alert روی symptom و trend بگذار، نه روی یک عدد مطلق که workload تغییر می‌دهد:

- application p95/p99, timeout/error, connection pool wait.
- Redis server latency spike/SLOWLOG events.
- memory vs maxmemory, RSS/host headroom, eviction rate, hit ratio.
- AOF/RDB failure, disk free space, persistence rewrite/child status.
- replica lag/link, full sync count.
- stream group lag / PEL oldest idle / pending count (اگر Streams داری).
- connected client count, rejected connection, blocked clients.

هر alert باید runbook: کدام command read-only ابتدا، کدام team owner، و چه کارهایی high-risk‌اند را داشته باشد. خود metric exporter نباید secret یا keyspace value را collect کند.

## تجربهٔ واقعی: از همبستگی تا root cause

GitLab دربارهٔ latency Redis یک مقاله منتشر کرد که با BPF و بررسی مسیر داخلی eviction نشان داد memory cap/eviction bursts با requestهای بسیار کند هم‌زمان می‌شوند. نکتهٔ عملی این است که `INFO` یک تکه از پازل است؛ correlation زمانی application p99, memory, eviction, CPU و system-level evidence لازم است. [GitLab engineering write-up](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

## Runbook تشخیص کندی

1. زمان/اثر و endpoint، Redis endpoint و version را ثبت کن.
2. app pool wait، Redis request duration و total endpoint duration را جدا کن.
3. در بازهٔ همان incident `INFO clients/stats/memory/persistence/replication` جمع کن.
4. SLOWLOG/LATENCY را بخوان؛ اگر empty بود، network/client pool را حذف‌شده فرض نکن.
5. `evicted_keys`, `keyspace_hits/misses`, CPU, disk, fork و replica sync را correlate کن.
6. از `MONITOR` به‌عنوان راه اول استفاده نکن؛ اگر لازم است فقط کوتاه و مجاز.
7. تغییر کوچک انجام بده و اثر را با قبل/بعد بسنج.

## عیب‌یابی

- **SLOWLOG خالی ولی API کند:** pool, TLS, network RTT, client serialization, DNS, retries را بررسی کن.
- **hit ratio افتاده:** TTL, eviction, cache key versioning و deploy behavior را بررسی کن.
- **RSS بالا ولی used_memory ثابت:** fragmentation, buffer, child fork و OS page/allocator usage را بررسی کن.
- **replica lag دارد:** network, full sync, disk, write burst و backlog را ببین.
- **MONITOR همه‌چیز را کند کرده:** مانیتور را فوراً ببند و از metric/SLOWLOG کم‌هزینه‌تر استفاده کن.
- **Grafana پر از سری:** label را روی key/user/payload با cardinality بالا نگذار.

## تمرین

1. خروجی `INFO` بخش memory/stats/keyspace را در lab جمع و ۵ field را توضیح بده.
2. SLOWLOG را بخوان و مشخص کن چه چیزی در آن اندازه‌گیری نشده است.
3. داشبورد cache طراحی کن: hits/misses/evictions + app p95 + DB load.
4. برای `MONITOR` یک policy بنویس که duration, approval role, redaction و stop condition داشته باشد.

**معیار پاسخ:** metricهای app + Redis + host، latency percentile، alert action/runbook و حفاظت از payload.

## کوییز

### ۱. SLOWLOG زمان چه چیزی را ثبت می‌کند؟

<details><summary>پاسخ</summary>

زمان server-side commandهایی که از threshold بگذرند؛ نه latency کامل برنامه.

</details>

### ۲. آیا SLOWLOG خالی مشکل network را رد می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ SLOWLOG network/client queue را نمی‌بیند.

</details>

### ۳. چرا MONITOR پرخطر است؟

<details><summary>پاسخ</summary>

سربار دارد و می‌تواند command/payload حساس را افشا کند.

</details>

### ۴. hit ratio را به چه metricهایی مرتبط می‌کنی؟

<details><summary>پاسخ</summary>

eviction/expiry، application cache hit، downstream DB QPS و latency.

</details>

### ۵. INFO را چطور استفاده می‌کنی؟

<details><summary>پاسخ</summary>

برای جمع‌آوری sectionهای مشخص و trend/correlation، نه تشخیص قطعی از یک snapshot.

</details>

### ۶. Redis Insight جای alert production است؟

<details><summary>پاسخ</summary>

خیر؛ ابزار مشاهده/مدیریت است، ولی metric pipeline, alert و runbook همچنان لازم‌اند.

</details>

## منابع

### انگلیسی و رسمی

- [Redis INFO](https://redis.io/docs/latest/commands/info/)
- [SLOWLOG](https://redis.io/docs/latest/commands/slowlog/)
- [Latency monitoring](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/latency/)
- [Redis Insight](https://redis.io/insight/)
- [Observability playbook](https://redis.io/tutorials/redis-software-observability-playbook/)
- [GitLab Redis latency incident investigation](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ابزارها و ساختار Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی فارسی Redis Insight و مانیتورینگ](https://www.google.com/search?q=Redis+Insight+مانیتورینگ+آموزش+فارسی)

پوشش فارسی monitoring کم است؛ runbook و map metricها در این صفحه کامل توضیح داده شده. alert threshold را با baseline workload و SLO خودت تنظیم کن.

</div>
