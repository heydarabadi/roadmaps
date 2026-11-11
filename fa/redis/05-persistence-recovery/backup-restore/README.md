<div dir="rtl" align="right">

# Backup، restore و تمرین Disaster Recovery

> English edition: [Backup, Restore, and Disaster-Recovery Practice](../../../../en/redis/05-persistence-recovery/backup-restore/README.md)

> مسیر: فصل ۵ · سطح: میانی تا پیشرفته · زمان درس و tabletop: ۹۰ تا ۱۵۰ دقیقه
>
> مراحل restore را فقط روی instance ایزوله اجرا کن. هیچ‌وقت فایل backup را روی volume سرویس live کپی نکن.

## هدف یادگیری

- backup را از RDB، AOF، replica و snapshot دیسک تشخیص دهی.
- یک روند قابل‌ممیزی برای ساختن، خارج‌کردن از failure domain، اعتبارسنجی و نگهداری backup بنویسی.
- restore را در Redis جداگانه تمرین و RPO/RTO واقعی را اندازه بگیری.
- data correctness، version/config، ACL/secret، شبکه و بازگردانی برنامه را جزو DR ببینی.

## مفاهیم کلیدی

Backup نسخه‌ای مستقل و قابل‌بازیابی از داده است. Replica برای دسترس‌پذیری و بار خواندن است؛ حذف/خرابی منطقی ممکن است replicate شود. RDB/AOF شکل persistence server هستند، اما backup قابل‌اعتماد باید از host/volume/zone اصلی جدا باشد و کپی/restore آن با ابزار و نسخهٔ سازگار آزمایش شود.

- **RPO:** حداکثر داده‌ای که می‌پذیری از دست برود.
- **RTO:** حداکثر زمان تا برگشت به سرویس قابل‌قبول.
- **Integrity:** آیا فایل کامل، checksum درست و format قابل‌خواندن است؟
- **Recoverability:** آیا بعد از load، داده و رفتار application درست‌اند؟

`PING` شدن Redis به‌تنهایی restore success نیست؛ بررسی schema/کلیدها، pending work، expiration، مجوز، consumer و side effectهای برنامه هم لازم است.

## روند ساخت Backup

1. نوع data file را انتخاب و policy را ثبت کن (RDB، AOF، managed snapshot یا ترکیبی).
2. snapshot را به روش مستند همان deployment بگیر؛ در OSS برای snapshot می‌توان `BGSAVE` را شروع و موفقیت را بررسی کرد.
3. تا پایان save صبر کن؛ `INFO persistence` و log را بخوان، فایل ناقص را backup معتبر ندان.
4. کپی را به storage خارج از host/zone انتقال بده؛ رمزگذاری، ACL، audit و retention اعمال کن.
5. checksum، timestamp، Redis version, config, keyspace, persistence policy و source endpoint metadata را همراه artifact ذخیره کن.
6. alert failure بساز و مالک مشخص کن؛ backup job بدون مشاهده‌پذیری ممکن است بی‌صدا مدت‌ها خراب باشد.
7. در محیط ایزوله، artifact را restore کن و data checks و application smoke flow را انجام بده.
8. هزینه و زمان restore را ثبت و در RPO/RTO بگنجان.

اگر فقط RDB می‌گیری، فایل نهایی کامل و مستقل لازم است. اگر AOF multipart می‌گیری، base/incremental/manifest باید به‌صورت سازگار با هم backup شوند؛ فایل‌ها را جداگانه و در لحظه‌های دلخواه copy نکن. برای سرویس Managed از workflow و consistency guarantee خود provider استفاده کن.

## لَب امن RDB روی Windows + Docker

این مسیر از یک Redis آزمایشی روی پورت 6379 و یک instance restore جدا روی 6380 استفاده می‌کند. آن را اجرا نکرده‌ایم؛ قبل از اجرا نام کانتینر/پورت و پوشهٔ مقصد را با وضعیت سیستم خود تطبیق بده. پورت روی loopback bind شده است.

### الف) دادهٔ نمونه بساز

```powershell
docker run -d --name redis-backup-source -p 127.0.0.1:6379:6379 -v ${PWD}/source-data:/data redis:8 redis-server --dir /data --dbfilename dump.rdb --appendonly no --save 60 1
docker exec redis-backup-source redis-cli SET lab:backup:marker "checkpoint-001"
docker exec redis-backup-source redis-cli HSET lab:backup:profile user_id 42 tier learner
docker exec redis-backup-source redis-cli BGSAVE
docker exec redis-backup-source redis-cli INFO persistence
```

`INFO persistence` را نگاه کن و تا تکمیل موفقیّت BGSAVE صبر کن. در محیط واقعی log و status بررسی می‌شود؛ فوراً فایل temp را کپی نکن.

### ب) artifact را جدا کن و checksum بگیر

```powershell
New-Item -ItemType Directory -Force .\backup-artifacts | Out-Null
docker cp redis-backup-source:/data/dump.rdb .\backup-artifacts\dump.rdb
Get-FileHash .\backup-artifacts\dump.rdb -Algorithm SHA256
```

این فقط یک نمونهٔ local است، نه backup offsite. در production artifact را رمزگذاری کن و به storage جدا منتقل کن.

### ج) restore ایزوله بساز

```powershell
New-Item -ItemType Directory -Force .\restore-data | Out-Null
Copy-Item .\backup-artifacts\dump.rdb .\restore-data\dump.rdb
docker run -d --name redis-restore-lab -p 127.0.0.1:6380:6379 -v ${PWD}/restore-data:/data redis:8 redis-server --dir /data --dbfilename dump.rdb --appendonly no
docker exec redis-restore-lab redis-cli GET lab:backup:marker
docker exec redis-restore-lab redis-cli HGETALL lab:backup:profile
```

خروجی marker باید `checkpoint-001` باشد و Hash باید دو field داشته باشد. اگر با `redis-cli` local host به port 6380 وصل می‌شوی از `redis-cli -p 6380` استفاده کن. restore در اینجا هرگز روی source اجرا نمی‌شود.

### د) اندازه‌گیری

زمان از آغاز restore تا `PING`، زمان تا همهٔ data checks، و زمان تا application آماده را جدا ثبت کن. RTO production برابر مجموع restart، load، validation، secret/network recovery و cutover است، نه فقط سرعت RDB load.

## AOF، managed backup و restore window

برای AOF مهم است که backup تمام اجزای مورد نیاز همان version را شامل شود. manifest و فایل‌های base/incremental را به‌صورت consistent capture کن. snapshotهای cloud یا managed service ممکن است محدودیت retention، encryption، region، consistency و plan داشته باشند؛ مستند provider را به‌عنوان قرارداد بازیابی بخوان و restore را در account/region مجزا امتحان کن.

اگر بعد از backup writeهای جدید آمده‌اند، راهکار reconcile باید روشن باشد: business event replay، پذیرش loss تا RPO، snapshot جدید یا بررسی دستی. backup فساد/حذف را به نقطهٔ زمانی قبل برمی‌گرداند، اما write بعد از آن را خودکار در خود ندارد.

## تجربهٔ واقعی: Backup test نکردن چه معنی دارد؟

در GitLab.com outage سال ۲۰۱۷، backupهای PostgreSQL به دلیل mismatch نسخهٔ `pg_dump` fail می‌شدند و alert failure به‌درستی دیده نشده بود؛ تیم موقع بازیابی با نبود backup مورد انتظار روبه‌رو شد. این حادثه Redis نبود، اما درس مستقیم برای runbook Redis است: هم backup job را monitor کن، هم restore را دوره‌ای تست کن، و کل storage/transfer/restore path را شامل RTO کن. [postmortem رسمی GitLab](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

در GitLab Geo نیز تجربهٔ نسل ابتدایی notification/retry نشان داد ماندگاری jobها، ترتیب رخداد، recovery و resync به طراحی queue و storage وابسته است؛ مقاله دربارهٔ یک محصول و معماری مشخص است، نه benchmark عمومی Redis. [تاریخچهٔ معماری GitLab Geo](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## چک‌لیست Runbook بازیابی

- [ ] چه incidentای restore را فعال می‌کند و چه کسی تصمیم می‌گیرد؟
- [ ] آخرین backup معتبر کدام است؟ timestamp، checksum و version آن چیست؟
- [ ] کلیدها و namespaceهای مهم چه هستند؟ آیا TTLهای کوتاه در زمان restore از قبل expire شده‌اند؟
- [ ] AOF/RDB و modules/data types نسخهٔ مقصد با artifact سازگارند؟
- [ ] مقصد امن و ایزوله است و هیچ worker اثر جانبی ناخواسته اجرا نمی‌کند؟
- [ ] ACL، credential، TLS، DNS، firewall و client config به مقصد می‌رسند؟
- [ ] data sample، counts، Stream PEL/cursors و business invariants بررسی شده‌اند؟
- [ ] چگونه write traffic را cutover یا rollback می‌کنیم؟
- [ ] رفتار writeهای بعد از snapshot چیست؟ reconcile/replay/دادهٔ قابل‌از‌دست‌رفتن مشخص است؟
- [ ] RPO/RTO واقعی و follow-up owner ثبت شده است؟

## دام‌ها

- **backup روی همان host:** failure domain مشترک؛ نسخهٔ مستقل ذخیره کن.
- **replica را archive می‌کنی:** اشتباه منطقی نیز replicate شده؛ backup point-in-time جدا لازم است.
- **کپی قبل از پایان snapshot:** ممکن است artifact ناقص باشد.
- **restore را در production امتحان می‌کنی:** ریسک overwrite/traffic؛ مقصد جدا بساز.
- **تست فقط `PING`:** parse شدن فایل سلامت application را اثبات نمی‌کند.
- **restore قدیمی بدون catch-up:** writeهای پس از checkpoint گم می‌شوند؛ replay/reconcile plan لازم است.
- **backup با credential باز:** دسترسی محدود، encryption-at-rest و audit لازم است.
- **job موفق ولی artifact منتقل نشده:** lifecycle شامل generate, verify, upload, retention و notification است.

## تمرین

1. لَب local را انجام بده و marker/Hash را از restore بخوان.
2. جدول RPO/RTO برای cache و Stream را پر کن.
3. یک failure tabletop: backup آخر ۶ ساعت قدیمی است و primary پاک شده؛ چه تیم‌هایی، secrets و تصمیم‌هایی لازم‌اند؟
4. معیار restore success را بنویس که صرفاً `PING` نباشد.

**معیار پاسخ:** artifact سالم و جدا، زمان‌های دقیق، نسخهٔ سازگار، data checks، app readiness، cutover/rollback و تصمیم روشن دربارهٔ writeهای پس از backup.

## کوییز

### ۱. آیا replica همان backup است؟

<details><summary>پاسخ</summary>

خیر؛ تغییر/حذف اشتباه را ممکن است بلافاصله دریافت کند.

</details>

### ۲. restore success را چه چیزی ثابت می‌کند؟

<details><summary>پاسخ</summary>

بارگذاری artifact به‌علاوهٔ data check، application flow، dependency recovery و cutover در زمان موردنیاز.

</details>

### ۳. RTO شامل چه زمان‌هایی است؟

<details><summary>پاسخ</summary>

انتقال artifact، load، validation، تنظیم دسترسی/شبکه و بازگشت برنامه/traffic.

</details>

### ۴. چرا checksum مفید است؟

<details><summary>پاسخ</summary>

برای تشخیص تغییر یا خرابی فایل در transfer/storage؛ به‌تنهایی صحت معنایی data را اثبات نمی‌کند.

</details>

### ۵. فایل AOF چندبخشی را چطور backup می‌گیری؟

<details><summary>پاسخ</summary>

به‌صورت مجموعهٔ سازگار شامل manifest و اجزای لازم طبق نسخه/workflow رسمی.

</details>

### ۶. بعد از restore قدیمی چه مسئله‌ای می‌ماند؟

<details><summary>پاسخ</summary>

writeهای پس از backup باید replay/reconcile شوند یا loss پذیرفته‌شده و اعلام شود.

</details>

## منابع

### انگلیسی و رسمی

- [راهنمای Redis Persistence/Backup](https://redis.io/docs/latest/management/persistence/)
- [BGSAVE](https://redis.io/docs/latest/commands/bgsave/)
- [Redis backup workflow and recovery](https://redis.io/tutorials/operate/redis-at-scale/persistence-and-durability/)
- [MISCONF troubleshooting](https://redis.io/docs/latest/develop/reference/errors/common/misconf/)
- [GitLab database outage postmortem: backup failure and recovery](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)
- [GitLab Geo and queue/recovery design](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

### فارسی

- [راهنمای فارسی persistence و backup در Urhoba](https://www.urhoba.net/fa/post/redis-persistence-snapshot)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

منابع فارسی دربارهٔ restore drill کمترند؛ runbook و لَب در این فایل مبانی را مستقل پوشش می‌دهد. روش offsite و consistency را مطابق نسخه و سرویس production خودت بررسی کن.

</div>
