<div dir="rtl" align="right">

# Redis OSS، Managed Redis و Redis Enterprise: انتخاب محصول

> English edition: [Self-Managed Redis, Managed Services, and Redis Enterprise](README.en.md)

> مسیر: فصل ۹ · سطح: پیشرفته · زمان درس و worksheet: ۷۵ تا ۱۱۰ دقیقه
>
> قابلیت‌ها، نسخه‌ها، SLA، قیمت و شرایط مجوز تغییر می‌کنند؛ این فصل چارچوب تصمیم می‌دهد، نه quote یا نظر حقوقی.

## هدف یادگیری

- تفاوت self-managed Redis Open Source، managed Redis و محصول‌های Redis Enterprise/Cloud را از دید مسئولیت و feature تحلیل کنی.
- پشتیبانی command, compatibility, HA, DR, security, data residency و backup را بررسی کنی.
- Total Cost of Ownership را فراتر از قیمت node محاسبه کنی.
- از customer story برای الهام استفاده کنی و marketing claim را به guarantee عمومی تبدیل نکنی.
- migration, portability و vendor exit را از ابتدا برنامه‌ریزی کنی.

## مدل مسئولیت

Self-managed یعنی تیم تو نصب/patch، network, TLS, ACL, topology, monitoring, backups, upgrades, capacity, on-call و restore را اداره می‌کند. Managed service بخشی را اتومات می‌کند، اما application correctness, client behavior, data model, permissions, backup policy, failover behavior, region selection و test را تیم نگه می‌دارد. Enterprise software/cloud ممکن است مدیریت، scaling، proxy, support یا featureهای geo/tiering بیفزاید؛ دقیقاً چه چیزی شامل است از product/version/plan وابسته است.

Redis Open Source نسخهٔ 8 خانوادهٔ JSON, Time Series, Search و probabilistic functionality را در Redis ادغام کرده است؛ نسخه‌های قدیمی ممکن است Redis Stack/Module install بخواهند. با این حال integration در OSS به این معنی نیست که تمام commandها در تمام managed offerings/versions یکسان expose شده‌اند.

## ۱. انتخاب با نیاز، نه برند

برای workload واقعی این پرسش‌ها را پر کن:

1. RPO/RTO و availability SLA چیست؟
2. یک shard کافی است یا sharding لازم است؟
3. cross-region write/active-active لازم است یا cross-region disaster restore کافی است؟
4. چه command/data type/client libraryهایی باید پشتیبانی شوند؟
5. TLS, ACL, audit, encryption at rest, private endpoint و key rotation چه policy دارند؟
6. backup retention, restore region, restore drill و support ساعت outage چیست؟
7. peak throughput/latency در TLS/replication/persistence زیر بار واقعی چقدر است؟
8. data residency، compliance، support response و contract terms چه هستند؟
9. تیم چه مهارت/تعداد on-call برای عملیات self-managed دارد؟
10. اگر provider یا feature حذف/گران شد، چطور data/client را migrate می‌کنیم؟

## ۲. ماتریس مسئولیت نمونه

| مسئولیت | Self-managed | Managed service | تیم application همچنان مسئول |
| --- | --- | --- | --- |
| نصب/infra patch | تیم platform | معمولاً provider بخشی را انجام می‌دهد | client compatibility و rollout |
| ACL/TLS/network | تیم | primitive/setting می‌دهد | user permissions و secret lifecycle |
| HA/failover | توپولوژی باید build شود | ممکن است managed باشد | retry/idempotency و stale read |
| Backup/restore | طراحی و operate | feature/retention plan وابسته به plan | restore validation و data correctness |
| scaling | ظرفیت/reshard عملیاتی | API/console با limits | hot key، key model، performance test |
| monitoring/on-call | زیرساخت کامل | metrics/alerts بخشی ارائه می‌شود | business SLI و end-to-end flow |

«managed» مسئولیت application-data semantics را منتقل نمی‌کند.

## ۳. Total Cost of Ownership

برای بازهٔ ۱۲–۳۶ ماهه این هزینه‌ها را کنار هم مقایسه کن:

```text
TCO = service/license + compute/RAM/flash + network/egress
    + backups/storage/DR region + monitoring/security tooling
    + on-call/engineering time + migration/upgrade/testing
    + outage risk/operational overhead
```

قیمت public/list تنها یک جزء است. اندازهٔ dataset، replicas, persistence, multi-region, traffic, network egress, support tier و retained backups می‌توانند هزینه را تغییر دهند. قبل از تصمیم، quote را با load model و contract همان environment مقایسه کن.

## ۴. Compatibility test قبل از commit

روی نسخهٔ هدف و plan واقعی این موارد را اجرا کن:

- هر command/type/module/search path لازم، و ACL permission آن.
- client library protocol، cluster/sentinel redirection و TLS.
- multi-key/transaction/Lua behavior در Cluster یا Active-Active.
- backup/restore یک dataset آزمایشی همراه نسخهٔ Redis جدید/قدیم.
- failover و retry duplicate semantics.
- max payload, key limits, concurrent connections, per-shard limits.
- monitoring export, audit logs, private networking و credentials rotation.

از یک test matrix کوچک در CI استفاده کن تا تغییر provider/version mismatch را زود پیدا کند. Cloud endpoint با `PING` تنها compatibility test نیست.

## ۵. تجربهٔ مشتری منتشرشده

در case رسمی Redis، شرکت Ekata برای سامانهٔ identity verification خود می‌گوید workload graph/query و dataset بزرگ به latency تک‌رقمی میلی‌ثانیه‌ای نیاز داشت و چند datastore را ارزیابی کرد؛ مقاله Redis Enterprise را راه‌حل انتخاب‌شده توصیف می‌کند. این مطالعه موردی از طرف فروشنده منتشر شده و جزئیات/اعداد را باید با requirement و قرارداد مشابه خودت دوباره اعتبارسنجی کنی. [Ekata customer story](https://redis.io/customers/ekata/)

## ۶. Risk register و portability

| ریسک | mitigation |
| --- | --- |
| API/feature فقط در edition خاص | required-command matrix, version pin و fallback |
| service unavailable/region outage | DR runbook, second region, backup/restore test |
| proprietary feature lock-in | export format, dual-write/read migration plan و exit test |
| compatibility drift | staging integration test با endpoint/version واقعی |
| unexpected cost | usage alarm, quota, key/data retention و load simulation |
| operational incident | support escalation, logs/metrics, access owner و tabletop |

## تمرین

سه گزینهٔ hypothetical بنویس: Redis OSS self-managed، یک cloud-managed Redis، و Redis Enterprise multi-region. برای workload cache + stream سفارش، جدول requirements را پر کن. Trade-off را بر اساس SLA, RPO/RTO, feature, owner, cost و lock-in توضیح بده. برای انتخاب، weighted score بساز، اما وزن‌ها را از محصول/تیم بگیر؛ score خودسرانه جواب قطعی نیست.

**معیار پاسخ:** SLA و data semantics، نه فقط feature list؛ تست compatibility، migration/exit، security، restore، on-call و هزینهٔ کامل.

## دام‌ها

- **feature list را قرارداد می‌خوانی:** price plan, quota, region, availability و support terms را بخوان.
- **managed یعنی بدون on-call:** app retry, data correctness و incident response هنوز لازم‌اند.
- **Redis OSS 8 را با Redis 7 Stack یکی می‌گیری:** feature/module state نسخه را بررسی کن.
- **client protocol را پس از migration نمی‌آزمایی:** topology/TLS/ACL behavior ممکن است فرق کند.
- **case study را benchmark مستقل می‌گیری:** منبع مشتریِ منتشرشده توسط vendor معمولاً context/selection bias دارد.
- **هیچ راه خروجی نداری:** command compatibility، serialization و export/rebuild را از اول برنامه‌ریزی کن.

## کوییز

### ۱. managed service چه مسئولیت‌هایی را منتقل نمی‌کند؟

<details><summary>پاسخ</summary>

data model, application retry/idempotency, key/ACL design و business correctness.

</details>

### ۲. چرا Redis 8 در مقایسهٔ product مهم است؟

<details><summary>پاسخ</summary>

برخی قابلیت‌های Redis Stack/Modules در Open Source 8 integrated شده‌اند؛ versions/managed offerings متفاوت‌اند.

</details>

### ۳. چه چیزی در TCO حساب می‌شود؟

<details><summary>پاسخ</summary>

infra/service، replication/DR/backups، network، on-call، migration، monitoring و risk.

</details>

### ۴. `PING` endpoint سازگاری کامل را ثابت می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ تمام commands/types, ACL, TLS, client routing, restore و failure behavior لازم‌اند.

</details>

### ۵. customer story چگونه استفاده شود؟

<details><summary>پاسخ</summary>

به عنوان evidence یک deployment/شرط خاص، نه guarantee عمومی.

</details>

## منابع

### انگلیسی و رسمی

- [Redis products](https://redis.io/docs/latest/operate/)
- [Redis Open Source, Stack and Enterprise overview](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/)
- [Redis 8.0 release notes](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/release-notes/redisce/redisos-8.0-release-notes/)
- [Redis licenses](https://redis.io/legal/licenses/)
- [Ekata customer story](https://redis.io/customers/ekata/)
- [Customer stories](https://redis.io/customers/)

### فارسی

- [جست‌وجوی فارسی مقایسه Redis OSS و Managed Redis](https://www.google.com/search?q=Redis+OSS+Managed+Redis+مقایسه+فارسی)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

جزئیات حقوقی/plan/pricing در منابع فارسی کامل نیست و تغییر می‌کند؛ نسخهٔ license و contract همان محصول را در تاریخ تصمیم بخوان.

</div>
