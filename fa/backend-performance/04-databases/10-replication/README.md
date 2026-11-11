<div dir="rtl" align="right">

# Replication — کپی داده با قرارداد سازگاری

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/10-replication/README.md)


**هدف یادگیری:** Read replica را از Backup و Shard جدا کنید، lag و read-after-write را در طراحی وارد کنید و هزینه synchronous replication را توضیح دهید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ بخش SQL نمونه PostgreSQL و اجرا‌نشده است.

## مدل ذهنی

Replication کپی داده/تغییرات را روی نود دیگری نگه می‌دارد. در معماری single-primary، write به Primary می‌رود و بعضی readها به Replica. ظرفیت خواندن ممکن است بیشتر شود؛ ظرفیت write اولیه لزوماً بیشتر نمی‌شود، چون تغییر باید تولید و به کپی‌ها اعمال شود. Replication هم‌زمان یا ناهم‌زمان است؛ physical و logical نیز مدل‌های متفاوت با قابلیت‌های متفاوت‌اند.

| انتخاب | سود | هزینه/ریسک |
| --- | --- | --- |
| Async replica | read جدا و commit مستقل از انتظار کپی | lag و احتمال از دست‌رفتن write تأییدشده در failover |
| Sync replica | تضمین قوی‌تر طبق سطح تأیید | latency شبکه و وابستگی availability به quorum/config |
| Read روی Primary | مشاهده تازه‌تر پس از commit | مصرف ظرفیت اصلی |

در PostgreSQL، سطح تأیید synchronous commit اهمیت دارد: دریافت/flush روی standby با replay و قابل‌دیدن‌شدن برای query یکی نیست. `remote_apply` برای انتظار اعمال رفتار قوی‌تری دارد. [راهنمای standby و replication](https://www.postgresql.org/docs/current/warm-standby.html) مرجع این تفاوت‌هاست.

## کاربرد و مصالحه

برای گزارش یا کاتالوگ با بودجه کهنگی مشخص، replica می‌تواند مناسب باشد. برای بلافاصله دیدن سفارش ثبت‌شده، خواندن Primary، انتظار تا موقعیت مشخص replication یا routing مبتنی بر session از گزینه‌های طراحی است. «همیشه چند ثانیه صبر کن» تضمین نیست؛ lag تحت اختلال تغییر می‌کند. Replica نیز هزینه CPU، دیسک، شبکه، پایش و failover دارد.

## مثال حل‌شده

سناریوی فرضی: سفارش روی Primary در `t=0` commit می‌شود و Replica در `t=2s` آن را replay می‌کند. خواندن فهرست از Replica در `t=0.2s` می‌تواند سفارش را نبیند. مسیر پیشنهادی برای قرارداد read-after-write:

<div dir="ltr" align="left">

```text
write_result = primary.commit_order(command)
return write_result.order

on subsequent order detail read:
    if consistency requires read_after_write:
        read primary
    else:
        read eligible replica within freshness budget
```

```sql
-- On a PostgreSQL standby; privileges/version matter:
SELECT pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn();
```

</div>

موقعیت دریافت و replay برای تشخیص فاصله مراحل مفید است؛ مقدار NULL/متوقف نیازمند تفسیر وضعیت recovery است. اختلاف LSN اندازه بایت است، نه تضمین مدت کهنگی. lag را با وضعیت اتصال، نرخ write و زمان/موقعیت اعمال تفسیر کنید. [توابع recovery](https://www.postgresql.org/docs/current/functions-admin.html) رفتار توابع را مشخص می‌کند.

## تمرین و مشاهده مورد انتظار

روی کاغذ timeline با commit در ثانیه صفر، قطع شبکه تا ثانیه ۱۰ و دو read در ثانیه ۱ و ۵ رسم کنید. برای «نمایش سفارش خود کاربر» و «آمار دیروز» مسیر read را جدا انتخاب کنید. انتظار: نیاز اول بدون Primary یا انتظار مبتنی بر پیشرفت تضمین نمی‌شود؛ نیاز دوم می‌تواند با بودجه کهنگی پذیرفته شود. سپس failure هنگام failover را تحلیل کنید: کدام write در async ممکن است به Replica نرسیده باشد؟

## شاهد عمومی و حد شواهد

[مستند رسمی Hot standby](https://www.postgresql.org/docs/current/hot-standby.html) تعارض queryهای خواندن طولانی با replay را شرح می‌دهد؛ بسته به تنظیم، query ممکن است لغو شود یا replay عقب بیفتد. این شاهد عملیاتی معتبر است؛ سناریوی زمان‌های بالا فرضی است و نتیجه تولیدی یک شرکت نیست. فعال‌کردن feedback نیز هزینه احتمالی نگهداری نسخه‌ها در Primary دارد.

## شکست‌ها، سیگنال‌ها و چک‌لیست

Replica جای Backup نیست: delete اشتباه نیز تکثیر می‌شود. Failover بدون fencing می‌تواند دو Primary فعال بسازد. lag پنهان، WAL نگه‌داشته‌شده در slot و query لغوشده standby را پایش کنید. [آمار replication](https://www.postgresql.org/docs/current/monitoring-stats.html) را با بازه و نسخه واقعی تفسیر کنید؛ NULL در lag الزاماً صفر نیست.

- [ ] readها بر اساس تازگی و read-after-write طبقه‌بندی شده‌اند.
- [ ] mode تأیید commit و رفتار هنگام نبود standby مشخص است.
- [ ] lag، replay progress، conflict و WAL retention پایش می‌شود.
- [ ] eligibility، fallback و جلوگیری از بار ناگهانی روی Primary طراحی شده است.
- [ ] failover، fencing، reconnect و RPO/RTO تمرین می‌شوند.
- [ ] Backup جدا و بازیابی آزموده‌شده وجود دارد.

## پیش‌نیازها، مسیر تکثیر و سازگاری خواندن

Primary مقصد نوشتن در این مدل است؛ Replica نسخه‌ای است که تغییر را دریافت و اعمال می‌کند. در replication ناهم‌زمان، commit می‌تواند پیش از replay روی Replica برگردد؛ receive position یعنی دریافت WAL و replay position یعنی اعمالی که برای query قابل مشاهده می‌شود. Backup نسخه‌ای برای بازیابی است و replica خطای منطقی را هم تکثیر می‌کند.

### حل timeline مثال و تمرین

در فرض درس، Primary در t=0 سفارش را commit می‌کند و Replica تا t=2s آن را replay نمی‌کند. خواندن در t=0.2s از Replica ممکن است سفارش را نبیند؛ تکرار read در t=1s تضمینی ایجاد نمی‌کند چون lag زمان ثابت ندارد. برای «سفارش همین کاربر را نشان بده»، پاسخ write را برگردانید یا read را موقتاً از Primary انجام دهید؛ آمار دیروز را Replica تا وقتی lag در freshness budget است می‌تواند بدهد. LSN دریافت و replay فاصله موقعیت را می‌سنجد، نه ثانیه کهنگی.

در قطعی ۱۰ثانیه‌ای شبکه، readهای t=1 و t=5 از Replica عقب‌افتاده‌اند؛ برای read-your-write باید Primary یا انتظار مبتنی بر پیشرفت مشخص انتخاب شود. گزارش دیروز ممکن است بودجه کهنگی داشته باشد. اگر Primary در این فاصله failover کند، تغییرهای commitشده‌ای که به Replica async نرسیده‌اند ممکن است حاضر نباشند؛ RPO باید این ریسک را بپذیرد یا mode تأیید مناسب شود.

### مسیر عیب‌یابی

اگر کاربر نوشته‌اش را نمی‌بیند، routing، receive/replay position، نرخ WAL و سلامت ارتباط را ببینید؛ سپس freshness budget و fallback همان نوع read را بررسی کنید. اگر query standby لغو می‌شود، conflict و مدت query را کنار replay بسنجید. Failover هم به fencing و مالکیت روشن Primary نیاز دارد؛ عدد lag به‌تنهایی آزمون بازیابی نیست.

## جمع‌بندی

Replica ظرفیت خواندن را تغییر می‌دهد اما lag و هزینه failover دارد و Backup نیست. مسیر read را با نیاز تازگی هر کار تطبیق دهید.

## خودآزمایی

۱. Replica چه تفاوتی با Shard دارد؟

۲. چرا commit موفق async تضمین مشاهده فوری در Replica نیست؟

۳. آیا هر synchronous commit یعنی read فوراً داده را روی standby می‌بیند؟

۴. چرا replica جای Backup را نمی‌گیرد؟

۵. query طولانی روی hot standby چه اثری می‌تواند داشته باشد؟

### پاسخ‌نامه با دلیل

۱. Replica کپی همان داده است؛ Shard مالک بخش متفاوتی از مجموعه داده است.

۲. انتقال و replay جدا و با تأخیرند؛ commit اصلی منتظر آن‌ها نمی‌ماند.

۳. خیر؛ سطح تأیید دریافت/flush با replay تفاوت دارد و تنظیم تعیین‌کننده است.

۴. خطای منطقی مانند حذف اشتباه تکثیر می‌شود؛ بازیابی به نقطه سالم مسیر دیگری می‌خواهد.

۵. با replay تعارض می‌کند؛ ممکن است query لغو یا اعمال عقب بیفتد، طبق تنظیم.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [Warm standby/replication](https://www.postgresql.org/docs/current/warm-standby.html)، [Hot standby](https://www.postgresql.org/docs/current/hot-standby.html)؛ modeها و تعارض‌ها.
- انگلیسی: [Recovery functions](https://www.postgresql.org/docs/current/functions-admin.html)؛ موقعیت WAL و معنای توابع.
- فارسی: [مروری بر مفاهیم مقدماتی NoSQL](https://dntips.ir/www.dntips.ir-posts-1472.html)؛ بخش تکثیر و تفاوت با تقسیم داده، منبع مقدماتی قدیمی است. تعمیم‌های آن درباره همه NoSQLها مبنای این درس نیست و تنظیم PostgreSQL را پوشش نمی‌دهد.

- English, official: [PostgreSQL synchronous replication](https://www.postgresql.org/docs/current/warm-standby.html#SYNCHRONOUS-REPLICATION) explains standby acknowledgments and synchronous commit modes.
- English, official: [PostgreSQL synchronous_commit](https://www.postgresql.org/docs/current/runtime-config-wal.html#GUC-SYNCHRONOUS-COMMIT) documents which standby stage a commit waits for.
- English, official: [PostgreSQL monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html) documents replication status and lag-related views.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Slow logs](../09-slow-query-logging/README.md) · [بعدی: Sharding](../11-sharding/README.md) · [تازگی کش](../../01-caching/04-invalidation-and-freshness/README.md)

</div>


