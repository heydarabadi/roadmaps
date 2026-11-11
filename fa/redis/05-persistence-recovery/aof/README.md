<div dir="rtl" align="right">

# AOF: ثبت تغییرها، fsync و بازنویسی

> English edition: [AOF: Write Logging, fsync, and Rewrite](../../../../en/redis/05-persistence-recovery/aof/README.md)

> مسیر: فصل ۵ · سطح: میانی · زمان: ۷۰ تا ۱۱۰ دقیقه
>
> فایل فعال AOF را دستی پاک یا ویرایش نکن. تغییر config/repair را با backup و روی نسخهٔ همان Redis انجام بده.

## هدف یادگیری

- بفهمی AOF چگونه writeها را ثبت و هنگام startup replay می‌کند.
- اثر `appendfsync always`, `everysec`, `no` را از نظر دوام/latency مقایسه کنی.
- `BGREWRITEAOF`, AOF چندبخشی Redis 7+, manifest و write status را بشناسی.
- برای دیسک پر، AOF خراب، rewrite ناموفق و restart برنامهٔ عیب‌یابی داشته باشی.

## مدل ذهنی

AOF یک log از عملیات تغییر‌دهنده است. پس از restart Redis فرمان‌های لازم را بازپخش می‌کند تا dataset را بازسازی کند. برای dataset متغیر AOF می‌تواند تازه‌تر از snapshot باشد؛ در ازای آن، حجم فایل، rewrite و مدت recovery را باید اداره کنی.

```text
write --> in-memory dataset
   \\--> AOF buffer --> OS/file cache --> disk (fsync policy)

restart: read AOF records -> replay -> dataset
```

رسیدن فرمان به پاسخ Redis با flush فیزیکی به media یکسان نیست. `fsync` و storage زیرین، برق، controller و filesystem در مرز دوام دخیل‌اند.

## ۱. سه سیاست appendfsync

سیاست config شده را از اینجا بخوان:

```text
CONFIG GET appendonly
CONFIG GET appendfsync
INFO persistence
```

| سیاست | رفتار کلی | هزینه/ریسک |
| --- | --- | --- |
| `always` | تلاش می‌کند هر write را با fsync دوام دهد (Redis می‌تواند writeهای هم‌زمان را گروه کند) | durability بهتر، latency و بار I/O بیشتر |
| `everysec` | flush دوره‌ای حدوداً هر ثانیه | مصالحهٔ رایج؛ آخرین تغییرها در برخی crashهای سیستم/دیسک ممکن است از دست بروند؛ سقف قطعی جهانی فرض نکن |
| `no` | زمان fsync را به OS واگذار می‌کند | بار مستقیم Redis کمتر، اما بازهٔ از دست‌رفتن به رفتار OS/storage وابسته است |

انتخاب براساس RPO و benchmark workload واقعی است. «always یعنی همیشه قابل‌نجات از هر خرابی» فرض غلطی است؛ replication/HA، storage durability، backup و application consistency جداگانه‌اند.

## ۲. بررسی فایل و وضعیت

```text
CONFIG GET dir
CONFIG GET appenddirname
CONFIG GET appendfilename
INFO persistence
```

نام/ساختار فایل به config و نسخه وابسته است. Redis 7 به بعد از multipart AOF با base/incremental files و manifest استفاده می‌کند؛ فایل یکپارچهٔ قدیمی را با ابزارهای shell concatenate یا حذف نکن. در `INFO persistence` وضعیت AOF write/rewrite و counters را دنبال کن؛ فیلدهای دقیق در نسخه‌ها تغییر می‌کنند.

وقتی هم RDB و هم AOF فعال باشند، startup از AOF برای بازسازی state استفاده می‌کند، چون معمولاً تغییرهای تازه‌تری دارد. برای آزمون RDB باید recovery path را مستقل در محیط آزمایشی بررسی کنی؛ وجود هر دو فایل تضمین نمی‌کند هر دو با هم replay شوند.

## ۳. بازنویسی AOF

log با history تغییرها ممکن است بزرگ شود. Rewrite به‌جای نگه‌داشتن تمام تاریخچه، فرمان‌هایی می‌نویسد که برای بازسازی state فعلی کافی‌اند. `BGREWRITEAOF` را در lab اجرا و `INFO persistence` را قبل/بعد نگاه کن:

```text
BGREWRITEAOF
INFO persistence
```

rewrite پس‌زمینه، fork/copy-on-write و disk I/O دارد. در زمان rewrite، writeهای جدید باید هم‌زمان حفظ شوند؛ فضای کافی برای فایل‌های موقت و فایل‌های لازم لازم است. هم‌زمانی snapshot، replica sync و AOF rewrite می‌تواند منابع را به فشار بیندازد. rewrite مکرر خیلی زود بهینه نیست؛ آستانه‌های config را با اندازهٔ AOF و رشد داده تنظیم کن.

## ۴. دیسک، خطا و تعمیر

اگر disk پر شود یا permission نوشتن نباشد، نوشتن AOF ممکن است fail شود و Redis با `MISCONF` writeها را رد کند، بسته به تنظیمات. با `INFO persistence` مقدار `aof_last_write_status` را ببین، log سیستم/Redis و فضای filesystem را بررسی کن و علت زیرساخت را رفع کن. خاموش‌کردن محافظت نوشتن در حالی که persistence خراب است، مسئله را پنهان می‌کند.

اگر startup به‌خاطر AOF ناقص/خراب شکست بخورد، پیش از repair از فایل‌ها snapshot خام و checksum بگیر، نسخهٔ Redis را یادداشت کن و ابزار تعمیر رسمی همان نسخه مانند `redis-check-aof` را فقط روی کپی استفاده کن. گزینهٔ `--fix` ممکن است tail خراب را حذف کند و دادهٔ writeهای انتهایی را از بین ببرد؛ تصمیم repair باید با RPO و مالک داده هماهنگ باشد.

## تجربهٔ واقعی دربارهٔ اعتماد به backup

در postmortem رسمی GitLab دربارهٔ outage دیتابیس در ۲۰۱۷، backupهای PostgreSQL وجود نداشتند چون job پشتیبان با نسخهٔ نادرست ابزار fail می‌شد و alert آن هم به‌درستی دیده نشده بود. این رخداد مربوط به AOF یا Redis نبود؛ نمونهٔ مستند این اصل عملیاتی است که «تنظیم شده» یا «فایل معمولاً ساخته می‌شود» کافی نیست: وضعیت خروجی، هشدار failure و restore را واقعی آزمایش کن. [postmortem GitLab](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

## لَب و محاسبهٔ تصمیم

در لَب می‌توانی فقط تنظیم و وضعیت را بررسی کنی؛ AOF را روی instance جداگانه فعال کن، نه روی production مشترک:

```text
INFO persistence
SET lab:aof:counter 1
INCR lab:aof:counter
INFO persistence
```

از دادهٔ مقایسه‌ای فرضی استفاده کن: اگر در اوج ۲٬۰۰۰ write/ثانیه داری، `everysec` چه پنجره‌ای از داده را از نظر RPO باید در صورت خرابی disk/host تحمل کنی؟ پاسخ، یک عدد سفت بدون آزمایش نیست؛ policy، نوع crash و storage را مستند کن. زمان restart، حجم فایل و مدت load را در dataset واقع‌بینانه اندازه بگیر.

## دام‌ها و عیب‌یابی

- **`appendfsync everysec` را lossless می‌خوانی:** این یک trade-off است، نه تضمین صفر loss.
- **فایل AOF بزرگ است:** rewrite status/threshold, write rate و آزادبودن disk را ببین.
- **`aof_last_write_status:err`:** filesystem، quota، permission و logs را بررسی کن؛ سبب را رفع کن و retry/status را دنبال کن.
- **rewrite روی dataset سنگین در peak:** fork، CPU، I/O و copy-on-write را در ظرفیت لحاظ کن.
- **repair روی فایل اصلی:** ابتدا کپی خام بگیر؛ repair با fix می‌تواند tail را truncate کند.
- **فایل‌های چندبخشی را دستی حذف کرده‌ای:** manifest و atomic rewrite را به‌هم می‌زنی؛ دستورالعمل رسمی version-specific را اجرا کن.
- **AOF را backup دانسته‌ای:** AOF replication خارج از failure domain و restore drill را جایگزین نمی‌کند.

## تمرین با پاسخ

1. `always`, `everysec`, `no` را برای cache، session، queue و منبع مالی مقایسه کن.
2. پس از `BGREWRITEAOF` چه metricهایی را نگاه می‌کنی؟
3. `aof_last_write_status:err` یعنی چه و چه کار خطرناکی را نباید به عنوان «رفع» انجام دهی؟
4. اگر AOF و RDB هر دو فعال باشند، در restart کدام recovery file استفاده می‌شود؟
5. چرا backup همان volume کافی نیست؟

<details><summary>پاسخ‌های راهنما</summary>

1. براساس اهمیت loss، latency، rebuildability و recovery time؛ cache شاید persistence نخواهد، اما دادهٔ عملیاتی یا پیام حیاتی RPO کوچک‌تر و طراحی backup می‌خواهد.
2. وضعیت rewrite، AOF size/growth، free disk، RSS/CPU، latency و زمان restart/load را.
3. نوشتن روی فایل ناموفق است؛ disk/permission/path/log را اصلاح کن، و failure protection را صرفاً خاموش نکن.
4. معمولاً AOF، چون جدیدترین dataset را دارد.
5. خرابی host/volume هم‌زمان live data و backup محلی را از بین می‌برد.

</details>

## کوییز

### ۱. AOF چیست؟

<details><summary>پاسخ</summary>

log عملیات تغییردهنده که در startup replay می‌شود.

</details>

### ۲. `everysec` چه توازنی ایجاد می‌کند؟

<details><summary>پاسخ</summary>

توازن میان دوام و بار fsync؛ در crashهای مشخص ممکن است آخرین تغییرها از دست برود.

</details>

### ۳. Rewrite چه می‌کند؟

<details><summary>پاسخ</summary>

log را به دنباله‌ای فشرده‌تر برای بازسازی state فعلی تبدیل می‌کند.

</details>

### ۴. Redis 7+ چرا manifest دارد؟

<details><summary>پاسخ</summary>

AOF می‌تواند base و چند بخش افزایشی داشته باشد؛ manifest اجزای فعال را مدیریت می‌کند.

</details>

### ۵. اگر AOF خراب باشد، اول چه می‌کنی؟

<details><summary>پاسخ</summary>

از فایل‌ها کپی/حفاظت و backup می‌گیری، نسخه و خطا را ثبت می‌کنی و repair رسمی را روی کپی بررسی می‌کنی.

</details>

### ۶. آیا AOF جای backup دور از سرور را می‌گیرد؟

<details><summary>پاسخ</summary>

خیر؛ AOF بخشی از persistence همان deployment است.

</details>

## منابع

### انگلیسی و رسمی

- [Redis persistence](https://redis.io/docs/latest/management/persistence/)
- [AOF persistence tutorial](https://redis.io/tutorials/operate/redis-at-scale/persistence-and-durability/)
- [BGREWRITEAOF](https://redis.io/docs/latest/commands/bgrewriteaof/)
- [MISCONF troubleshooting](https://redis.io/docs/latest/develop/reference/errors/common/misconf/)
- [GitLab backup postmortem (PostgreSQL; درس عملیاتی، نه Redis)](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

### فارسی

- [راهنمای فارسی persistence در Urhoba](https://www.urhoba.net/fa/post/redis-persistence-snapshot)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

توضیح فارسی عمیق برای multipart AOF محدود است؛ این درس برای مدل و عیب‌یابی پایه خودبسنده است. تنظیم durability نهایی را با مستند نسخه و vendor/storage واقعی تطبیق بده.

</div>
