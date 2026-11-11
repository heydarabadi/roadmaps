<div dir="rtl" align="right">

# RDB: snapshot نقطه‌ای Redis

> English edition: [RDB: Point-in-Time Redis Snapshots](../../../../en/redis/05-persistence-recovery/rdb/README.md)

> مسیر: فصل ۵، ماندگاری و بازیابی · سطح: میانی · زمان درس و لَب: ۶۰ تا ۹۰ دقیقه
>
> نام و فایل config در image/serviceهای مختلف فرق می‌کند. لَب را روی Redis محلی انجام بده و فایل فعال production را تغییر نده.

## هدف یادگیری

- بدانـی snapshot چیست و چه زمانی از dataset تصویر می‌گیرد.
- `BGSAVE`, `LASTSAVE`, `INFO persistence` و تنظیم‌های `save` را تفسیر کنی.
- trade-off مصرف RAM/CPU/disk، فاصلهٔ snapshot و RPO را بسنجی.
- بین فایل RDB و backup خارج از host/restore واقعی تفاوت بگذاری.

## مدل ذهنی

RDB تصویر dataset را در یک لحظه می‌نویسد. هنگام restart Redis فایل snapshot را load می‌کند؛ writeهایی که بعد از زمان snapshot تا شکست رخ داده‌اند ممکن است در آن تصویر نباشند. برای cache بازسازی‌پذیر یا backup دوره‌ای این مدل ساده و مناسب است؛ برای writeهایی که باید تازه‌ترین حالتشان حفظ شود، به RDB تنها تکیه نکن.

```text
زمان:   ---- write ---- write ---- [fork/snapshot point] ---- write ---- crash
RDB:                              |<--- همین نقطه بازیابی می‌شود --->|
پس write بعد از نقطهٔ snapshot ممکن است بازیابی نشود.
```

## ۱. snapshot زمان‌بندی‌شده و دستی

`save` config می‌گوید در بازه‌ای از ثانیه، اگر تعداد تغییرها از آستانه بگذرد snapshot خودکار انجام شود. این تنظیم‌ها به‌تنهایی «هر X ثانیه دقیقاً snapshot» نمی‌دهند؛ ترافیک، خطای ذخیره و مشغول‌بودن عملیات هم اثر دارند.

```text
CONFIG GET save
INFO persistence
LASTSAVE
```

`BGSAVE` snapshot پس‌زمینه را شروع می‌کند:

```text
BGSAVE
INFO persistence
```

به `rdb_bgsave_in_progress`, `rdb_last_bgsave_status` و `rdb_last_save_time` توجه کن. `BGSAVE` معمولاً فرایند فرزند می‌سازد تا snapshot را بنویسد؛ ایجاد child با `fork()` و copy-on-write هزینه دارد. هنگام تغییر زیاد، صفحه‌های تغییرکردهٔ حافظه کپی می‌شوند و RSS/فشار حافظه بالا می‌رود؛ disk کند هم زمان عملیات را زیاد می‌کند.

`SAVE` شکل synchronous است و تا پایان کار main server را متوقف می‌کند. برای آزمایش قابل‌شناسایی مفید است، اما روی دیتاست production اجرای دستی آن را بدون runbook انجام نده.

## ۲. فایل snapshot کجا است؟

برای کشف محل configشده:

```text
CONFIG GET dir
CONFIG GET dbfilename
```

در نصب‌های رایج نام فایل `dump.rdb` است، اما path واقعی را از runtime/config بگیر. در Docker یا managed Redis مسیر host، volume، snapshot policy و مجوزها فرق می‌کند. فایل را وسط نوشتن کپی نکن؛ Redis فایل جدید را با نام موقت می‌نویسد و پس از کامل‌شدن نهایی می‌کند. مسیر backup رسمی یا snapshot filesystem را مطابق مستندات همان محیط استفاده کن.

اگر AOF و RDB با هم روشن باشند، در راه‌اندازی مجدد Redis AOF را برای بازسازی dataset انتخاب می‌کند چون معمولاً تازه‌تر/کامل‌تر است. پس «وجود dump.rdb» اثبات نمی‌کند Redis همان فایل را در restart استفاده خواهد کرد.

## ۳. ظرفیت و محدودیت

پیش از انتخاب snapshot این موارد را اندازه بگیر:

- حجم واقعی dataset و serialization، نه فقط عدد `used_memory`.
- headroom RAM برای fork/copy-on-write در peak write workload.
- CPU مصرفی برای ساخت snapshot و disk throughput/space.
- زمان ساخت، انتقال، load و validation فایل.
- تعداد snapshotها، RPO قابل‌قبول و هزینهٔ نگهداری بیرون از host.

اگر RDB هر ساعت موفق ذخیره شود، این به معنی تضمین صفر از‌دست‌رفتن writeها در یک ساعت نیست؛ failure ممکن است در هر لحظه رخ دهد و آخرین snapshot شاید قدیمی‌تر از بازهٔ اسمی باشد. `rdb_last_bgsave_status:err` یا هشدارهای ذخیره را فوراً بررسی کن.

## ۴. تجربهٔ عملی منتشرشده

GitLab در شرح فنی GitLab Geo، از نسل اولیهٔ notification/job queue می‌گوید retryهای زیاد هنگام در دسترس نبودن مقصد می‌توانستند disk Redis را پر کنند و در بعضی شرایط نیاز به resync ایجاد شود؛ تیم در نسل بعدی بخشی از event queue و cursor پایدار را در PostgreSQL طراحی کرد تا با log پایدار و transactionها، retry/restore قابل‌مدیریت‌تر باشد. این مقاله گزارش RDB خاص نیست؛ برای این درس نشان می‌دهد snapshot به‌تنهایی یک طراحی durable event log یا disaster recovery کامل نمی‌سازد. [مقالهٔ GitLab Geo](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## لَب امن

این لَب key آزمایشی می‌سازد و فقط وضعیت persistence را می‌خواند:

```text
SET lab:rdb:message "before snapshot"
BGSAVE
INFO persistence
LASTSAVE
```

تا زمانی که `rdb_bgsave_in_progress` صفر و `rdb_last_bgsave_status:ok` نشده، نتیجه را موفق اعلام نکن. برای بررسی restore فایل را روی یک instance جدا و directory آزمایشی load کن. در این لَب server را متوقف نمی‌کنیم و فایل live را جابه‌جا/overwrite نمی‌کنیم.

## دام‌ها و عیب‌یابی

- **فکر می‌کنی snapshot آخرین write را دارد:** `rdb_last_save_time` و RPO را کنترل کن.
- **`BGSAVE` شکست خورده:** `INFO persistence`, server log, free disk, directory permissions و خطای fork/OS را بررسی کن.
- **سرور با `MISCONF` نوشتن را متوقف می‌کند:** persistence failure را حل کن؛ `stop-writes-on-bgsave-error no` را صرفاً برای خاموش‌کردن هشدار اعمال نکن.
- **RAM هنگام snapshot بالا می‌رود:** copy-on-write و peak mutation را اندازه بگیر؛ headroom و زمان‌بندی را اصلاح کن.
- **backup فقط روی همان volume است:** failure دیسک/host می‌تواند هم live data و هم backup را از بین ببرد.
- **replica را backup می‌گیری:** خطای منطقی، `DEL` یا flush می‌تواند replicate شود؛ backup مستقل و restore drill لازم است.
- **`SAVE` را در peak اجرا می‌کنی:** synchronous stop-the-world را در نظر بگیر؛ از روی سرور production به‌صورت بداهه اجرا نکن.

## تمرین

1. `CONFIG GET save` را بخوان و هر جفت threshold را با زبان خود توضیح بده.
2. `BGSAVE` را روی لَب اجرا کن و metricهای persistence قبل/بعد را ثبت کن.
3. RPO یک cache قابل‌بازسازی و یک session مهم را جدا تعیین کن.
4. برای backup روزانه، نسخه‌گذاری، checksum، انتقال خارج از host، retention و restore-test برنامه بنویس.

**معیار پاسخ:** باید زمان آخرین snapshot موفق، ریسک writeهای پس از آن، headroom منابع، مکان مستقل backup و زمان بازیابی سنجیده شود.

## کوییز

### ۱. RDB چه چیزی می‌سازد؟

<details><summary>پاسخ</summary>

نمای نقطه‌ای از dataset در زمان snapshot.

</details>

### ۲. مزیت `BGSAVE` نسبت به `SAVE` چیست؟

<details><summary>پاسخ</summary>

ساخت snapshot در background انجام می‌شود؛ `SAVE` server را تا پایان block می‌کند.

</details>

### ۳. چرا RDB تنها ممکن است writeهای تازه را از دست بدهد؟

<details><summary>پاسخ</summary>

فایل، تصویر snapshot اخیر است و writeهای پس از آن در آن نیستند.

</details>

### ۴. copy-on-write چه هزینه‌ای ممکن است داشته باشد؟

<details><summary>پاسخ</summary>

فشار حافظه و CPU بیشتر هنگام snapshot، به‌خصوص با mutation بالا.

</details>

### ۵. آیا فایل در همان دیسک به‌تنهایی backup کافی است؟

<details><summary>پاسخ</summary>

خیر؛ باید نسخهٔ خارج از failure domain و آزمون restore داشته باشی.

</details>

### ۶. از کجا می‌فهمی آخرین BGSAVE موفق بود؟

<details><summary>پاسخ</summary>

`INFO persistence` و فیلدهایی مثل `rdb_last_bgsave_status` و زمان آخرین save را بررسی می‌کنی.

</details>

## منابع

### انگلیسی و رسمی

- [مستند persistence در Redis Open Source](https://redis.io/docs/latest/management/persistence/)
- [BGSAVE](https://redis.io/docs/latest/commands/bgsave/)
- [INFO persistence](https://redis.io/docs/latest/commands/info/)
- [MISCONF و troubleshooting snapshot failure](https://redis.io/docs/latest/develop/reference/errors/common/misconf/)
- [مقالهٔ فنی GitLab Geo](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

### فارسی

- [مرور فارسی RDB و AOF در Urhoba](https://www.urhoba.net/fa/post/redis-persistence-snapshot)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

مقاله‌های فارسی در جزئیات copy-on-write و failure محدودند؛ درس این صفحه برای فهم و آزمایش پایه مستقل است. پارامترهای عملی را با نسخه، سیستم‌عامل و محیط managed خود تطبیق بده.

</div>
