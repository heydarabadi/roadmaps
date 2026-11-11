<div dir="rtl" align="right">

# پروژهٔ ۳ — طرح آمادگی Redis برای Production

> English edition: [Project 3 — Redis Production Readiness Design](../../../../en/redis/projects/03-production-readiness/README.md)

> سطح: میانی تا پیشرفته · زمان: ۳ تا ۵ ساعت · این پروژهٔ طراحی و tabletop است؛ روی production یا cloud واقعی اجرا نکن.

## سناریو

یک API محصول/سفارش، Redis را برای cache پرتکرار و session استفاده می‌کند. بار در زمان تخفیف ۸ برابر می‌شود، Redis باید private/TLS/ACL باشد، node ممکن است از کار بیفتد، cache قابل بازسازی است ولی session outage بر کاربر اثر می‌گذارد. تیم باید ارتقا و بازیابی را تمرین کند.

هدف: یک design pack بساز که با مشخصات workload تصمیم بگیرد Redis OSS single primary، Sentinel، Cluster یا managed/Enterprise لازم است. در این پروژه هیچ عدد throughput ساختگی ارائه نمی‌کنیم؛ فرض‌ها و دادهٔ لازم برای benchmark را می‌نویسیم.

## گام ۱ — Workload و data classification

| داده | اهمیت | source of truth | از دست‌رفتن Redis چه می‌کند؟ |
| --- | --- | --- | --- |
| صفحهٔ محصول cache | کم، قابل‌ساخت | DB catalog | DB fallback و بار بیشتر |
| session/login state | متوسط/بالا، طبق policy | auth service یا Redis بسته به طراحی | logout/fail-closed یا session recovery |
| limiter/counter | وابسته به کاربرد | application event/DB? | تجاوز از limit یا false block |
| order event | بالا | DB outbox/broker | خطر از دست‌رفتن/duplicate، Redis به‌تنهایی باید ارزیابی شود |

برای هر ردیف retention، PII، TTL، eviction eligibility، persistence، replication، backup، ACL و حذف privacy را مشخص کن. دسته‌بندی «همه cache است» اشتباه عملیاتی می‌سازد.

## گام ۲ — ظرفیت‌سنجی به‌جای حدس

ورودی‌های طراحی را جمع کن:

- تعداد key و توزیع payload size، type، TTL و تعداد field/member.
- baseline و peak ops/sec و command mix، pipeline/batch size و concurrency.
- dataset growth و retention؛ cache hit/miss و stampede behavior.
- memory overhead، allocator fragmentation، copy-on-write هنگام RDB/AOF rewrite، replica memory و host headroom.
- client connection count/pool، network RTT، TLS cost و placement/region.
- replication lag، failover duration، snapshot time، restore time و backup bandwidth.

از sample واقعی و بدون PII benchmark بساز. معیارها: latency end-to-end p50/p95/p99، throughput، hit ratio، eviction, CPU, RSS, replication lag، load/restore duration. baseline قبل از scale-out ثبت کن تا تغییر قابل‌سنجش باشد.

## گام ۳ — topology decision

| نیاز | معماری برای ارزیابی |
| --- | --- |
| cache کوچک، failure window قابل‌تحمل، عملیات ساده | primary + backup; شاید replica برای read/recovery |
| failover خودکار برای primary واحد | Sentinel با چند monitor در failure domain جدا و client سازگار |
| dataset/throughput باید shard شود | Redis Cluster یا service دارای sharding؛ key access و multi-key محدودیت دارد |
| SLA/پشتیبانی/DR/عملیات vendor لازم است | managed/Enterprise را با هزینه و feature matrix مقایسه کن |
| cross-region active writes | Active-Active فقط پس از بررسی consistency/conflict/feature compatibility |

HA، replication و cluster backup نیستند. هر معماری با حذف اشتباه/خرابی منطقی می‌تواند دادهٔ بد را کپی کند. طرح DR باید backup مستقل و restore exercise داشته باشد.

## گام ۴ — امنیت قابل‌بررسی

برای سرویس `catalog-api` user جدا بساز که فقط prefixهای cache مربوط به خودش و commandهای لازم را داشته باشد. password را در config/command history نگذار؛ secret manager، rotation و emergency revocation تعریف کن. اتصال از private network باشد؛ expose عمومی ممنوع. TLS لازم را بین client/service و در صورت نیاز node-to-node فعال کن. ACL برای `orders:*` و `cache:*` را با `ACL DRYRUN` یا test در staging بسنج.

چک‌لیست:

- [ ] public inbound مسدود؛ allowed source network مشخص.
- [ ] ACL per-service با command و key pattern محدود.
- [ ] TLS certificate renewal/expiry alert.
- [ ] secret rotate و revoke drill.
- [ ] backup encrypted، access-logged و retention محدود.
- [ ] monitoring/logging بدون payload/credential حساس.
- [ ] patch/advisory owner و rollout policy.

## گام ۵ — durability و recovery design

برای هر dataset تعیین کن RPO/RTO چه عددی است و چرا. Cache قابل‌ساخت مجدد ممکن است persistence نخواهد؛ session یا event state شاید RDB/AOF/managed durability و backup جدا بخواهد. انتخاب را بر اساس durability واقعی، latency، restore duration، data volume و هزینه بنویس.

Runbook restore حداقل:

1. incident commander scope و زمان آخرین backup قابل‌اعتماد را اعلام می‌کند.
2. Redis بازیابی را در شبکهٔ ایزوله بالا می‌آوری؛ آن را ناگهان به application traffic وصل نمی‌کنی.
3. checksum/format/version/ACL/config را بررسی می‌کنی.
4. key count/type، چند رکورد شناخته‌شده، TTL، stream/group و data consistency را sample می‌کنی.
5. دادهٔ حساس/PII و schema migration را بررسی می‌کنی.
6. application smoke check و load control انجام می‌شود.
7. traffic تدریجی، monitor و rollback/stop condition تعریف می‌شود.
8. زمان واقعی RTO و data loss برآوردی RPO ثبت می‌شود.

## گام ۶ — مشاهده و alert

Dashboard را بر چهار دسته تقسیم کن: health (availability/connection), performance (latency/ops), capacity (memory/eviction/CPU/disk), correctness/recovery (replication lag, pending, backup age, restore drill). برای هر alert حداقل این موارد را ثبت کن: نام، شرط، مدت، شدت، اقدام اول، owner و لینک runbook. `MONITOR` برای مشاهدهٔ دائمی استفاده نشود.

| Alert | پرسش operator |
| --- | --- |
| memory headroom < حد | افزایش داده/fragmentation/replica؟ eviction policy درست است؟ |
| evicted_keys رشد ناگهانی | cache hit/miss و key churn چه تغییری کرده؟ |
| p99 Redis/SDK بالا | server command، network RTT یا client pool bottleneck؟ |
| replica lag بالا | replication buffer/network/heavy command؟ |
| backup age > RPO | job، off-site copy یا permission خراب است؟ |
| stream oldest pending بالا | worker، poison event یا dependency کند است؟ |

## گام ۷ — rollout و upgrade

قبل از ارتقا: release notes و command/encoding compatibility را بخوان؛ backup/rollback verified، load test، canary، client compatibility، persistence format، modules و replica upgrade sequence مشخص کن. در deploy، stop condition مثل error rate/latency/replication lag و owner/decision path داشته باش. عقب‌گرد binary به معنی downgrade data format بدون ریسک نیست؛ نسخهٔ فایل و restore compatibility را بررسی کن.

## گام ۸ — failure tabletop

هر نفر نقش incident commander، DB owner، Redis operator یا app owner را بگیرد. پاسخ و زمان هر قدم را ثبت کن:

1. Primary node خاموش؛ replica چند ثانیه lag داشته است.
2. سرویس Redis در دسترس است ولی memory به سقف رسیده و keyهای cache حذف می‌شوند.
3. backup شب گذشته corrupt یا ناقص است.
4. ACL جدید deploy شده و worker با `NOPERM` مواجه می‌شود.
5. TLS certificate منقضی می‌شود.
6. یک `FLUSHDB` تصادفی روی محیط production رخ داده است.
7. deploy جدید حجم کلید را دو برابر و restore را طولانی می‌کند.

برای هر سناریو: impact، detection، containment، recovery source، data-loss estimate، communication و follow-up action بنویس. هیچ‌کدام را روی سرویس واقعی برای تمرین ایجاد نکن.

## خروجی نهایی (Design Pack)

1. component diagram و data flow.
2. key/type/TTL schema و ownership.
3. topology choice و گزینه‌های ردشده با trade-off.
4. RPO/RTO و persistence/backup/restore plan.
5. network/ACL/TLS/secret model.
6. capacity assumptions و benchmark plan.
7. metric/alert/runbook.
8. upgrade/failback plan و tabletop results.
9. فهرست unknowns با owner/date برای پاسخ.

### Rubric (۲۰ امتیاز)

- نیاز و source of truth برای هر dataset: ۳
- topology با failure و trade-off: ۳
- RPO/RTO، backup و restore: ۳
- ACL/TLS/network/secret: ۳
- capacity/latency/eviction: ۳
- monitoring و runbook قابل‌اقدام: ۳
- rollout/upgrade/DR و unknown register: ۲

هر تصمیمی که فقط با «Redis سریع است» یا «replica داریم» توجیه شود، امتیاز کامل نمی‌گیرد.

## منابع

- [Redis production security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [Persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [Replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/), [Sentinel](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/), [Cluster](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [Monitoring, latency and memory](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/)
- [تجربهٔ Redis latency از GitLab](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/) — گزارش engineering منتشرشده.
- [تجربهٔ انتخاب PostgreSQL برای namespace statistics در GitLab](https://about.gitlab.com/blog/database-case-study-store-and-update-namespace-statistics/) — موردی از تصمیم معماری؛ نه Redis outage.
- [راهنمای فارسی Replication/Cluster](https://azarsys.com/blog/setup-redis-replication-cluster/)

</div>
