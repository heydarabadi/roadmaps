<div dir="rtl" align="right">

# ارتقا، failover و Disaster Recovery برای Redis

> English edition: [Redis Upgrades, Failover, and Disaster Recovery](README.en.md)

> مسیر: فصل ۹ · سطح: پیشرفته · زمان درس و tabletop: ۹۰ تا ۱۴۰ دقیقه
>
> این فایل چارچوب runbook می‌دهد؛ فرمان‌های upgrade و restore را با version, topology و provider واقعی هماهنگ کن.

## هدف یادگیری

- Upgrade, failover و disaster recovery را به عنوان عملیات متفاوت برنامه‌ریزی کنی.
- قبل از ارتقا release note، client/module compatibility، persistence، topology و backup را بررسی کنی.
- RPO/RTO و owner/rollback/cutover را در runbook واضح کنی.
- failure modeهای network partition, replica lag, retry storm, data loss و slow restore را تمرین کنی.
- restore drill را با application correctness بسنجی، نه فقط بالا آمدن Redis.

## سه عملیات متفاوت

| عملیات | هدف | داده چه می‌شود؟ |
| --- | --- | --- |
| Upgrade | تغییر Redis binaries/protocol/config با ریسک کنترل‌شده | باید سازگاری persistence, modules, client و commands حفظ/آزموده شود |
| Failover | ادامهٔ سرویس پس از primary/zone failure | replica می‌تواند lag داشته باشد؛ loss/duplicate window را حساب کن |
| Disaster recovery | بازسازی در خرابی بزرگ، حذف/فساد یا از دست رفتن region | backup/time point, replay/reconcile و cutover لازم است |

Failover معمولاً سرویس را سریع‌تر برمی‌گرداند؛ DR نقطهٔ بازیابی مستقل می‌دهد. یک failover به‌تنهایی corruption یا حذف منطقی را درست نمی‌کند.

## ۱. Preflight ارتقا

- نسخهٔ فعلی/هدف، release notes، security fixes و supported upgrade path را ثبت کن.
- نوع topology را معلوم کن: standalone, Sentinel, Cluster, Redis Software/Cloud.
- client library, language runtime, TLS, ACL, proxy, exporter و automation را validate کن.
- modules/commands/data types را بررسی کن؛ Redis 8 برخی Stack modules را integrated کرده، اما data/version compatibility را هنوز باید آزمایش کرد.
- RDB/AOF format, backups, restore path, free disk/RAM, fork headroom و full-sync time را حساب کن.
- replication lag و load baseline را قبل از شروع ثبت کن.
- test restore و rollback image/package را در staging انجام بده.
- maintenance window, approval roles, stop criteria و customer communication را مشخص کن.

## ۲. rollout مرحله‌ای

در Sentinel/Cluster، Redis docs معمولاً upgrade را با replicaها مرحله‌به‌مرحله توضیح می‌دهند؛ سپس failover به replicaٔ upgraded و ارتقای nodeهای باقی‌مانده انجام می‌شود. ترتیب دقیق و commandها در نسخه/topology فرق دارد؛ official procedure را دنبال کن.

الگوی کنترل:

1. یک replica/canary را upgrade کن.
2. health, memory, errors, command compatibility, replication link/lag و application latency را مشاهده کن.
3. اگر سلامت درست است، replicaهای بعدی را با ظرفیت sync کنترل‌شده upgrade کن.
4. manual/managed failover را فقط طبق runbook انجام بده و write availability/data gap را اندازه بگیر.
5. primary سابق و باقی nodeها را بعد از برگشت به role صحیح upgrade کن.
6. client connection/pool و SLO را تا پایان window پایش کن.

در standalone، node restart و downtime/cold recovery باید preapproved باشد؛ topology را فرض نکن. Managed service upgrades ممکن است provider انجام دهد، اما app compatibility & restore readiness همچنان تیم را درگیر می‌کند.

## ۳. Incident triage تا DR

**تشخیص:** آیا Redis node down است، network partition وجود دارد، storage fail شده، memory full است یا credential/TLS expire شده؟

**Containment:** retry storm را محدود، write path را محافظت، health state را اطلاع‌رسانی و خطر split-brain/data corruption را ارزیابی کن.

**Recovery path:**

- node failure ولی replica سالم: failover طبق Sentinel/Cluster runbook.
- Redis down ولی persistence سالم: restart/load و validation.
- data حذف/فساد یا disk/region lost: backup مستقل restore در endpoint ایزوله.
- application schema/config incompatible: rollback/forward-fix طبق data format compatibility.

**Validation و cutover:** key/value sample، TTL، Stream group/PEL، ACL, replica/cluster health، source-of-truth comparisons و business transaction check؛ سپس traffic را مرحله‌ای منتقل کن.

## ۴. RPO/RTO باید قابل‌اندازه‌گیری باشد

RPO می‌گوید چه مقدار write از دست‌رفته پذیرفتنی است. RTO از alert تا user-facing service healthy را حساب می‌کند و شامل decision, restore transfer/load, validation, DNS/client reconnect, warm cache و traffic ramp است. هدف `RTO=15m` بدون restore تمرینی صرفاً wish است.

برای هر test ثبت کن:

- آخرین write acknowledged و موجود بودنش بعد recovery.
- timestamp/age backup، data gap، duplicated events و reconcile.
- زمان کشف، تصمیم، restore, validation و کامل‌شدن cutover.
- user-visible errors، success rate و dependency load.

## ۵. تجربهٔ واقعی: GitLab outage و backup fail

GitLab در postmortem outage database 2017 نوشت backupهای مورد انتظار به‌علت اجرای `pg_dump` ناسازگار با نسخه fail شده بودند و alert ایمیلی هم به گیرنده نرسید؛ recovery مجبور شد از snapshot قدیمی‌تر استفاده کند. این رخداد PostgreSQL است، نه Redis، اما به‌وضوح نشان می‌دهد backup configuration بدون observed success و restore practice کافی نیست. برای Redis همین کنترل‌ها را با `INFO persistence`, logs, alert, artifact checksum و restore drill برقرار کن. [GitLab database outage postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

## Tabletop: منطقه از دسترس خارج شد

فرض: region اصلی down است، clients reconnect storm دارند، replica region دوم ۳ ثانیه lag داشته، آخرین backup ۲ ساعت قبل است.

1. چه کسی active region را انتخاب می‌کند؟
2. آیا writeهای ۳ ثانیهٔ آخر را می‌توان بازسازی/تأیید کرد؟
3. clientها چطور endpoint و credentials جدید می‌گیرند؟
4. به چه اندازه traffic ابتدا برمی‌گردد تا dependency overload نشود؟
5. cache را warm می‌کنی یا خالی شروع می‌کنی؟ origin DB چطور محافظت می‌شود؟
6. برای failback به region اصلی چه data reconciliation می‌خواهی؟

## Runbook template

```text
Service / cluster:
Current / target Redis version:
Owner / decision maker / on-call:
RPO / RTO:
Primary, replicas, Sentinels/Cluster/provider:
Last validated backup + checksum + restore location:
First read-only diagnostics:
Stop criteria / rollback trigger:
Failover / restore sequence:
ACL, TLS, DNS, client config and secrets:
Data validation checks / source-of-truth reconciliation:
Traffic ramp and rollback:
Incident metrics and timestamps:
```

## دام‌ها

- **همهٔ nodeها را با هم upgrade می‌کنی:** هیچ canary یا replica باقی نمی‌ماند.
- **RDB/AOF load را در مقصد آزمایش نکرده‌ای:** backup artifact ممکن است خراب/ناسازگار باشد.
- **healthcheck فقط `PING` است:** application flow یا data completeness تأیید نشده.
- **retry storm restart را تشدید می‌کند:** exponential backoff/jitter, connection limits و circuit breaker لازم است.
- **replication lag نادیده گرفته می‌شود:** acknowledged write بعد failover ممکن است جا افتاده باشد.
- **rollback با data write بعد migration ناسازگار است:** schema/data compatibility و forward fix plan را بررسی کن.
- **failback خودکار است:** دو جهت write/merge ممکن است conflict بسازد؛ برنامهٔ جابجایی state لازم است.

## کوییز

### ۱. Failover با DR چه تفاوتی دارد؟

<details><summary>پاسخ</summary>

Failover به replica موجود سوئیچ می‌کند؛ DR از backup/time point و reconcile در خرابی بزرگ/حذف/فساد استفاده می‌کند.

</details>

### ۲. RTO از کجا شروع می‌شود و کجا تمام؟

<details><summary>پاسخ</summary>

از تشخیص/اعلام incident تا سرویس واقعی و validation شده با traffic سالم.

</details>

### ۳. چرا upgrade را مرحله‌ای می‌کنیم؟

<details><summary>پاسخ</summary>

برای کشف incompatibility با دامنهٔ کم و حفظ capacity/rollback options.

</details>

### ۴. backup job موفق یعنی restore موفق؟

<details><summary>پاسخ</summary>

خیر؛ باید load, data check, application behavior و زمان را تمرین کرد.

</details>

### ۵. lag replica هنگام failover چه خطری دارد؟

<details><summary>پاسخ</summary>

write پذیرفته‌شدهٔ اخیر ممکن است روی replica نباشد.

</details>

### ۶. در outage چرا retry باید محدود شود؟

<details><summary>پاسخ</summary>

retry storm می‌تواند Redis/DB را در recovery دوباره overload کند.

</details>

## منابع

### انگلیسی و رسمی

- [Redis upgrade guide](https://redis.io/docs/latest/operate/oss_and_stack/install/upgrade/)
- [Upgrade Redis Cluster](https://redis.io/docs/latest/operate/oss_and_stack/install/upgrade/cluster/)
- [Redis administration and rolling upgrade considerations](https://redis.io/docs/latest/operate/oss_and_stack/management/admin/)
- [Redis persistence and backup](https://redis.io/docs/latest/management/persistence/)
- [GitLab outage postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

### فارسی

- [مرور فارسی persistence و ساختار Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی Redis Disaster Recovery](https://www.google.com/search?q=آموزش+فارسی+Redis+Disaster+Recovery+upgrade)

مستند فارسی عملیاتی دربارهٔ upgrade/DR کم‌پوشش است؛ template و tabletop این درس هستهٔ runbook را می‌دهد. برای اجرای واقعی release-specific procedure و provider console runbook را بررسی کن.

</div>
