<div dir="rtl" align="right">

# فصل ۸ — عملیات، پایش و کارایی

> English edition: [Chapter 8 — Operations and performance](./README.en.md)

> «سریع» را با اندازه‌گیری تعریف کن. این فصل شاخص‌های حافظه، latency، instrumentation و تنظیم امن را به runbook تبدیل می‌کند. زمان پیشنهادی: ۴ تا ۶ ساعت.

## مسیر یادگیری

1. [حافظه و eviction](./memory-eviction/README.md): `used_memory`, RSS, overhead, `maxmemory` و policy.
2. [Latency و benchmark](./latency-benchmark/README.md): RTT، pipeline، throughput، p95/p99 و آزمون بار.
3. [Monitoring tools](./monitoring-tools/README.md): `INFO`, `SLOWLOG`, `LATENCY`, `MONITOR` و ابزار بصری.
4. [redis.conf](./redis-conf/README.md): تفاوت config پایدار و runtime، rollout، اعتبارسنجی و rollback.

## چارچوب بررسی incident

وقتی API کند می‌شود، در یک خط نتیجه‌گیری نکن. زمان‌بندی incident، تغییر تازه، command latency، network RTT، CPU/event loop، memory/eviction، replication lag و dependencyهای app را هم‌زمان بررسی کن. `SLOWLOG` زمان اجرای server-side command را ثبت می‌کند و لزوماً انتظار شبکه/کلاینت را نشان نمی‌دهد؛ بنابراین آن را با latency end-to-end و telemetry کلاینت مقایسه کن.

`MONITOR` می‌تواند حجم بسیار زیادی از فرمان‌ها و دادهٔ حساس را نمایش دهد؛ برای عیب‌یابی محدود و کوتاه‌مدت در محیط امن استفاده کن، نه داشبورد دائمی. `INFO` هم snapshotهای مختلف دارد؛ آمار را در بازه مقایسه کن و `used_memory` را با RSS یکی نگیر.

## شاخص‌های کلیدی

| شاخص | سؤال پاسخ‌داده‌شده |
| --- | --- |
| p95/p99 command + client latency | کندی چه وقت به کاربر می‌رسد و tail از کجاست؟ |
| memory used/RSS/maxmemory | فشار داده/fragmentation چقدر است؟ |
| evicted_keys / expired_keys | داده به‌علت policy حذف می‌شود یا TTL پایان می‌گیرد؟ |
| rejected_connections / connected_clients | connection pressure داریم؟ |
| hit ratio در application | cache ارزشمند است یا miss/load روی DB زیاد شده؟ |
| replication lag/offset | replica چقدر عقب است؟ |
| ops/sec و command mix | بار از کدام عملیات/سرویس آمده؟ |

برای هر alert مالک، آستانه، زمان ماندگاری، dashboard و runbook تعیین کن. alert روی یک snapshot پرش کاذب می‌سازد؛ روند و baseline را هم در نظر بگیر.

## سناریوی تمرینی

پس از deploy، p99 بالا رفته و eviction افزایش یافته است. مراحل: timestamp deployment را تطبیق بده؛ `INFO memory`, `INFO stats`, `SLOWLOG GET` و client metrics بگیر؛ commandهای بزرگ/اسکن، رشد key cardinality و TTL distribution را بررسی کن؛ maxmemory policy را بررسی کن؛ در صورت نیاز rollback تغییر را با ظرفیت و اثرش بسنج. صرفاً `maxmemory` را زیاد نکن؛ host RSS و system memory headroom لازم است.

## آزمون عبور

1. چرا pipeline ممکن است latency را کم کند ولی کار server را زیاد کند؟
2. تفاوت `used_memory` با RSS چیست؟
3. چرا SLOWLOG کم‌بودن latency کاربر را ثابت نمی‌کند؟
4. چرا MONITOR را دائم روشن نمی‌گذاریم؟

<details><summary>پاسخ راهنما</summary>

Pipeline round tripها را کم می‌کند، اما تعداد operationها/پاسخ buffer و burst load را حذف نمی‌کند. RSS حافظهٔ process از دید سیستم‌عامل است و allocator/fragmentation/overhead را هم شامل می‌شود. SLOWLOG server command time را می‌سنجد، نه تمام مسیر client/network/queueing. MONITOR بسیار پرحجم است و می‌تواند دادهٔ حساس/overhead ایجاد کند.

</details>

## منابع

- [Monitoring Redis](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/benchmarks/)
- [Latency troubleshooting](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/latency/)
- [Memory optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/)
- [مقالهٔ تجربهٔ GitLab دربارهٔ Redis latency spikes](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

</div>
