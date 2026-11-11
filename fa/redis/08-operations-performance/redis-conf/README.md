<div dir="rtl" align="right">

# redis.conf، config as code و rollout امن

> English edition: [redis.conf, Configuration as Code, and Safe Rollouts](../../../../en/redis/08-operations-performance/redis-conf/README.md)

> مسیر: فصل ۸ · سطح: میانی · زمان درس و lab: ۷۰ تا ۱۰۰ دقیقه
>
> نمونهٔ config زیر فقط template لَب است؛ برای production مستقیم کپی نکن. اندازه و network را براساس محیط محاسبه کن.

## هدف یادگیری

- فرق فایل config، runtime value و تنظیمات managed service را توضیح دهی.
- config را قابل‌بازتولید، version-controlled و secret-safe نگه داری.
- اثر تنظیم‌های network, persistence, maxmemory, ACL/TLS و cluster را به‌هم مرتبط کنی.
- تغییر را با precheck, rollout, metrics, restart plan و rollback اجرا کنی.
- با `CONFIG GET`, `CONFIG SET`, `CONFIG REWRITE` فرق داشته باشی.

## مدل config

Redis معمولاً با فایل config شروع می‌شود؛ CLI option، environment/entrypoint یا managed control plane هم می‌تواند بخشی از رفتار را تعیین کند. `CONFIG GET` runtime را می‌خواند. `CONFIG SET` برخی پارامترهای قابل‌تغییر را موقت در process تغییر می‌دهد؛ این تضمین نمی‌کند فایل یا IaC به‌روز شده باشد. `CONFIG REWRITE` تلاش می‌کند runtime config را در فایل بنویسد، اما می‌تواند با config management، فایل read-only یا deployment provider تداخل کند.

پس برای هر field روشن کن: منبع نهایی کدام است؟ runtime یا file؟ restart می‌خواهد؟ secret کجا می‌آید؟ تغییر بین nodeها چطور منتشر می‌شود؟

## ۱. نمونهٔ config آزمایشی

این نمونه در پوشهٔ `redis` شما به عنوان فایل lesson تولید نشده؛ آن را فقط در لَب خودت بنویس و values را بررسی کن:

```conf
port 6379
protected-mode yes
dir /data
dbfilename dump.rdb
save 60 1
appendonly yes
appendfsync everysec
maxmemory 256mb
maxmemory-policy allkeys-lru
loglevel notice
```

نکات:

- هم‌زمان‌بودن RDB و AOF مصرف disk/CPU/RAM بیشتری دارد؛ برای یادگیری هر کدام را جدا تحلیل کن.
- `256mb` نباید مساوی container limit باشد؛ process overhead, buffers, fork headroom و OS نیاز به فضای اضافه دارند.
- `allkeys-lru` فقط برای cacheای است که حذف key در آن قابل‌قبول است.
- `protected-mode yes` را نگه دار؛ host port را local-only map کن.
- secret را به این فایل یا repo نچسبان؛ ACL/secret file را جدا و با permission محدود مدیریت کن.

### اجرای لَب Docker روی PowerShell

پس از ساخت فایل `lab.redis.conf` در مسیر mount و پوشهٔ `data`:

```powershell
docker run -d --name redis-config-lab `
  -p 127.0.0.1:6379:6379 `
  -v ${PWD}/lab.redis.conf:/usr/local/etc/redis/redis.conf:ro `
  -v ${PWD}/data:/data `
  redis:8 redis-server /usr/local/etc/redis/redis.conf
docker exec redis-config-lab redis-cli CONFIG GET maxmemory
docker exec redis-config-lab redis-cli CONFIG GET appendonly
docker exec redis-config-lab redis-cli INFO persistence
```

tag `redis:8` در این sample برای آموزش خانوادهٔ نسخه است، نه pin production. برای deployment، tag/digest مشخص، patch policy و rollback image انتخاب کن. پورت local-only است؛ برای server public port را مستقیم باز نکن.

## ۲. runtime config و persistence

قبل از تغییر read-only inspect:

```text
CONFIG GET maxmemory
CONFIG GET maxmemory-policy
CONFIG GET appendonly
CONFIG GET appendfsync
INFO persistence
```

اگر پشتیبانی می‌شود، `CONFIG SET` یک پارامتر runtime را عوض می‌کند. پس از command وضعیت actual را بخوان و بدانی بعد از restart برمی‌گردد یا نه. `CONFIG REWRITE` را در محیط IaC/read-only اجرا نکن؛ source file را در git/secret manager تغییر بده و rollout استاندارد را انجام بده.

بعضی configها بدون restart قابل تغییرند و بعضی به startup options/restart یا provider workflow وابسته‌اند. رفتار exact در نسخه و سرویس managed فرق می‌کند؛ مستند رسمی/hosting contract را بخوان.

## ۳. گروه‌بندی و نگهداری config

- **base config:** پارامترهای مشترک و امن.
- **environment overlay:** ظرفیت، endpoint، feature و source of truth مخصوص dev/staging/prod.
- **secret material:** ACL credential, TLS key, password در secret manager/secure mount، نه git.
- **node role:** primary/replica, Sentinel, Cluster topology ممکن است config جدا بخواهد.
- **config history:** owner, date, intent, rollback, version و change approval طبق workflow تیم.
- **drift detection:** runtime را با desired config compare کن.

همهٔ nodeها را دستی جدا تغییر نده؛ automated rollout و validation مانع drift می‌شوند. Cluster slot/topology و Sentinel state را با config ساده یکی نگیر.

## ۴. ماتریس تغییر config

| دسته | نمونه | بررسی قبل/بعد |
| --- | --- | --- |
| Memory | `maxmemory`, policy | RSS/host headroom, evictions, write errors |
| Persistence | `save`, AOF/fsync | RPO, disk, status, restart/restore time |
| Network | bind/port/TLS | client/replica/Sentinel/Cluster connectivity |
| ACL | user/key/channel rules | `NOPERM`, access path, break-glass login |
| Latency | timeout/slowlog/latency monitor | app p95, CPU, overhead, alert noise |
| Replication/HA | role, backlog, Sentinel | lag, failover time, data loss test |

## ۵. real-world incident lesson

GitLab دربارهٔ outage دیتابیس توضیح داد که backup job به علت نسخهٔ ناسازگار binary error می‌شد و email alert دیده نمی‌شد؛ مشکل config صرف نبود بلکه drift بین environment و monitor عملیات بود. این رویداد PostgreSQL بود، نه Redis؛ برای Redis نیز version pin, startup config, logs, alerting و recovery test را به‌عنوان یک زنجیره بررسی کن. [Postmortem GitLab](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

## rollout runbook

1. مقصد و version را تأیید کن.
2. config فعلی/runtime را export/ثبت و diff را مرور کن.
3. اثر بر durability, memory, security, clients و restart را مستند کن.
4. staging با data/workload نماینده را run کن.
5. یک node/replica را مرحله‌ای تغییر بده؛ health و errorها را ببین.
6. از read/write, p95, memory, replication, persistence و TLS/ACL smoke check بگیر.
7. ادامه بده یا rollback کن؛ از تغییر چند طبقه هم‌زمان پرهیز کن.
8. desired config و runbook را به‌روز کن تا drift برگشت نکند.

## دام‌ها و عیب‌یابی

- **`CONFIG SET` را پایدار فرض می‌کنی:** restart ممکن است مقدار را برگرداند.
- **`CONFIG REWRITE` فایل Git را تغییر می‌دهد/overwrite می‌کند:** source of truth و read-only mode را بشناس.
- **ظرفیت `maxmemory` تا container limit پر شده:** headroom host/process باقی نگذاشته‌ای.
- **password در redis.conf/command history است:** secret rotation و secure mount لازم است.
- **تنظیم primary تغییر کرده ولی replica نه:** drift یا Sentinel/Cluster reconfiguration را بررسی کن.
- **reload ناگهانی client را قطع کرد:** restart/config compatibility و connection drain را plan کن.
- **config روی سرور اعمال شده اما manifest عوض نشده:** next deploy آن را undo می‌کند.

## تمرین

1. یک lab config برای cache و یکی برای Stream/queue بساز؛ maxmemory/persistence چرا فرق می‌کند؟
2. قبل از تغییر `appendfsync` یک rollback plan بنویس.
3. هر setting را به یکی از کلاس‌های runtime, restart, secret/provider-controlled تقسیم کن.
4. یک config drift detection report طرح کن.

## کوییز

### ۱. `CONFIG SET` حتماً فایل را پایدار می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ runtime را تغییر می‌دهد و persistence آن به workflow/config وابسته است.

</details>

### ۲. چه وقت `CONFIG REWRITE` را اجتناب می‌کنی؟

<details><summary>پاسخ</summary>

وقتی provider/IaC فایل را مدیریت می‌کند یا فایل read-only/managed است.

</details>

### ۳. چرا secret را در repo نمی‌گذاری؟

<details><summary>پاسخ</summary>

history و artifactها می‌توانند آن را برای مدت طولانی افشا کنند؛ secret manager/secure mount و rotation لازم است.

</details>

### ۴. چرا maxmemory را برابر RAM نگذاریم؟

<details><summary>پاسخ</summary>

process overhead, buffers, fork و OS به RAM نیاز دارند.

</details>

### ۵. موفقیت rollout را چگونه می‌سنجی؟

<details><summary>پاسخ</summary>

desired config در runtime، health/application checks، SLO، persistence/replication و امکان rollback.

</details>

## منابع

### انگلیسی و رسمی

- [Redis configuration](https://redis.io/docs/latest/operate/oss_and_stack/management/config/)
- [CONFIG GET](https://redis.io/docs/latest/commands/config-get/)
- [CONFIG SET](https://redis.io/docs/latest/commands/config-set/)
- [Redis security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [GitLab backup operational postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

### فارسی

- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی redis.conf](https://www.google.com/search?q=آموزش+فارسی+redis.conf+پیکربندی+Redis)

راهنماهای فارسی برای پیکربندی امن و IaC coverage کمتری دارند؛ این درس چارچوب rollout را کامل توضیح می‌دهد. configهای managed و version-specific را با provider document چک کن.

</div>
