<div dir="rtl" align="right">

# انتخاب حالت‌های persistence در Redis

> English edition: [Choosing Redis Persistence Modes](README.en.md)

> مسیر: فصل ۵ · سطح: میانی · زمان: ۶۰ تا ۹۰ دقیقه
>
> persistence، replication و backup سه مفهوم جدا هستند. این درس راه انتخاب است، نه نسخهٔ آمادهٔ production.

## هدف یادگیری

- حالت بدون persistence، RDB، AOF و ترکیب RDB+AOF را مقایسه کنی.
- برای workload، RPO و RTO را از دید کسب‌وکار تعریف کنی.
- تشخیص دهی چه وقت Redis می‌تواند منبع اصلی داده باشد و چه وقت cache/projection است.
- failure domain، backup و restore را در کنار durability بررسی کنی.

## ایدهٔ مرکزی

Redis معمولاً ابتدا state را در RAM نگه می‌دارد، اما می‌تواند آن را به دیسک بنویسد. durability پاسخِ «پس از restart چه مقدار از تغییرها را بازسازی می‌توانم؟» است. replication پاسخِ «اگر node خراب شد آیا replica در دسترس است؟» است. backup پاسخِ «اگر خرابکاری/حذف/فساد/خرابی منطقه رخ داد، نسخهٔ مستقل قابل‌بازیابی دارم؟» است. یکی جایگزین دیگری نیست.

## واژه‌های تصمیم

- **RPO:** چه مقدار داده یا چه بازه‌ای از writeهای پذیرفته‌شده را کسب‌وکار می‌تواند از دست بدهد؟
- **RTO:** سرویس تا چه زمانی باید دوباره قابل‌استفاده شود؟ زمان کپی، load، بررسی و cutover هم شمرده می‌شود.
- **Failure domain:** سرور، دیسک، zone، credential یا سامانه‌ای که با یک خرابی می‌تواند چند نسخه را هم‌زمان از بین ببرد.
- **Source of truth:** سامانه‌ای که business record نهایی را نگه می‌دارد؛ cache ممکن است از آن دوباره ساخته شود.

## مقایسهٔ حالت‌ها

| حالت | بار عملیاتی | ریسک اصلی | معمولاً برای |
| --- | --- | --- | --- |
| بدون persistence | کم؛ disk I/O نوشتن نداریم | restart/host loss دادهٔ حافظه را از بین می‌برد | cache کاملاً قابل‌بازسازی و کم‌اهمیت |
| RDB | snapshot دوره‌ای و عملیات background | writeهای پس از snapshot اخیر ممکن است در restart نباشند | snapshot/backup، cacheهایی که نقطهٔ بازیابی کافی است |
| AOF | log append، fsync و rewrite | disk، حجم log، recovery طولانی‌تر؛ دوام تابع policy/storage | stateی که replay تغییرها مهم‌تر از snapshot تنهاست |
| RDB + AOF | مصرف منابع و عملیات بیشتر | داشتن دو سازوکار پیچیدگی را بالا می‌برد، تضمین مطلق نیست | وقتی snapshot و recovery از AOF هر دو ارزش دارند |

با هر حالت باید **خارج از host backup** داشته باشی اگر داده را از دست‌دادنی نمی‌دانی. در پیکربندی Redis که هر دو فعال‌اند، هنگام startup AOF معمولاً منبع بازسازی است چون تازه‌تر است.

## مثال تصمیم برای چهار workload

### ۱. cache صفحهٔ محصول

اگر Postgres منبع حقیقت است و cache با یک job قابل‌بازسازی است، ممکن است no persistence انتخاب شود تا هزینهٔ disk persistence را ندهی. اما بعد از restart، cold cache می‌تواند DB را با stampede تحت فشار بگذارد؛ warming، TTL jitter، محدودیت concurrency و حفاظت DB لازم است. «قابل‌بازسازی» به معنی «بی‌هزینهٔ از دست‌رفتن» نیست.

### ۲. session کاربر

حذف session ممکن است کاربر را logout کند؛ مدت اعتبار، رفتار failover و تجربهٔ کاربر را تحلیل کن. اگر این اثر پذیرفتنی نیست، RPO، AOF/RDB/managed persistence، replication و backup را با هم انتخاب کن. secret session را ACL/TLS و encryption-at-rest در محیط پشتیبان محافظت می‌کند.

### ۳. شمارندهٔ analytics تقریبی

اگر منبع event خام وجود دارد و شمارنده از آن بازسازی می‌شود، RPO بزرگ‌تر شاید پذیرفتنی باشد. اگر نه، شمارنده به دادهٔ پایدارتر یا persistence سخت‌تر نیاز دارد. مشخص کن آیا خطای یک پنجرهٔ زمانی مهم است.

### ۴. وضعیت سفارش/ledger

برای ledger مالی، Redis ephemeral cache معمولاً source of truth مناسبی نیست. اگر Redis primary store برای workloadای شده است، persistence, replication, backups, restore, fsync, capacity, durability semantics, audit and recovery design باید product-level SLA را برآورده کنند. دادهٔ مالی را با «سریع است» به Redis منتقل نکن.

## تجربهٔ واقعی منتشرشده: تصمیم GitLab دربارهٔ statistics

GitLab هنگام بررسی ذخیرهٔ آمار تجمیعی namespaceها، راه استفاده از Redis Set را هم بررسی کرد اما در همان مقاله نوشت PostgreSQL در persistence/consistency برای اطلاعاتی که نمی‌توانستند از دست بروند مناسب‌تر است و query آماری در SQL ساده‌تر می‌شد. این نمونه می‌گوید سرعت/سهولت نوشتن تنها criterion نیست؛ نوع query و هزینهٔ بازسازی/از‌دست‌رفتن به datastore وابسته‌اند. مقاله دربارهٔ یک طراحی GitLab است و حکم عمومی نیست. [مطالعهٔ موردی GitLab دربارهٔ namespace statistics](https://about.gitlab.com/blog/database-case-study-store-and-update-namespace-statistics/)

## چهار پرسش قبل از پیکربندی

1. چه زمانی Redis پاسخ «write پذیرفته شد» را برمی‌گرداند و دقیقاً چه چیزی روی دیسک یا replica رسیده؟
2. در process crash، OS crash، disk loss، zone loss و error انسانی چه مقدار loss را می‌پذیری؟
3. چه کسی در زمان restore تصمیم می‌گیرد نسخهٔ backup را انتخاب کند؟
4. با writeهای بعد از backup چه می‌کنی: قبول loss، replay، reconcile یا rebuild؟

اگر پاسخ روشن نیست، config را با عدد تصادفی تعیین نکن؛ ownership و recovery contract را تکمیل کن.

## ماتریس انتخاب نمونه

| داده | بازسازی‌پذیری | نمونهٔ RPO | Persistence را بررسی کن | Backup/restore |
| --- | --- | --- | --- | --- |
| cache قابل بازسازی | بالا | ممکن است نسبتاً بزرگ باشد | خاموش یا RDB/AOF سبک بسته به cold-start | دادهٔ cache شاید نه، اما runbook rebuild لازم است |
| session | متوسط | اثر UX مهم است | RDB/AOF با policy مشخص و HA | export مستقل/managed backup طبق نیاز |
| queue یا Stream | پایین تا متوسط | بر اساس از دست‌رفتن job | AOF/fsync، replica/WAIT و replay semantics | backup سازگار و روش redrive |
| شمارندهٔ مالی | پایین | نزدیک صفرِ کسب‌وکاری | بهتر است source authoritative بررسی شود | backup خارج از failure domain و reconcile |

«نمونهٔ RPO» عدد نسخهٔ آماده نیست؛ تیم محصول باید آن را تعیین و آزمون کند.

## لَب: فکر کن قبل از تغییر config

برای سه کلید خیالی یکی از این ستون‌ها را پر کن: اهمیت، منبع حقیقت، RPO، RTO، persistence، replica، backup، restore check.

```text
catalog:product:501     cache        source=PostgreSQL       rebuild=yes
session:opaque-id       user session source=Redis?            rebuild=no
orders:stream           event log    source=?                 rebuild=?
```

روی Redis واقعی `CONFIG SET` یا restart انجام نده تا policy محیط را ندانی. در lab, `INFO persistence` و `CONFIG GET save` / `appendonly` را فقط بخوان و تفاوت local config با سرویس managed را ثبت کن.

## دام‌ها

- **«Replica یعنی backup»:** حذف ناخواسته/خرابی منطقی ممکن است سریع replicate شود.
- **«AOF یعنی صفر loss»:** policy fsync، kernel، disk, controller, replication و failover هم دخیل‌اند.
- **«RDB هر X دقیقه یعنی RPO دقیق X»:** اجرای snapshot ممکن است fail یا عقب بیفتد.
- **«backup داریم چون config روشن است»:** job ممکن است خطا دهد، فایل منتقل نشود یا restore ناسازگار باشد.
- **«هر داده را می‌توان از log بازسازی کرد»:** source events یا sequence مطمئن شاید وجود نداشته باشد.
- **«RTO فقط زمان PING است»:** reconnect app, recovery validation, repopulation و cutover را هم حساب کن.

## تمرین با پاسخ

1. برای cache قابل‌ساخت از SQL، session و ledger persistence plan جدا بنویس.
2. یک سناریو بساز که replication هست ولی داده به‌خاطر `FLUSHALL` پاک شده؛ چرا backup جدا لازم می‌شود؟
3. RTO از لحظهٔ alert تا تأیید داده را به مراحل ریز بشکن.
4. اگر AOF/RDB performance را بدتر کند، با چه دادهٔ اندازه‌گیری‌شده تصمیم می‌گیری؟

**معیار پاسخ:** تعریف source of truth و business loss، RPO/RTO عدددار، چند failure domain، تست دوره‌ای، و پایش وضعیت persistence باید مشخص باشد.

## کوییز

### ۱. تفاوت persistence و replication؟

<details><summary>پاسخ</summary>

Persistence state را روی storage ثبت می‌کند؛ replication آن را به node دیگری می‌فرستد.

</details>

### ۲. آیا replica مستقل از logical delete است؟

<details><summary>پاسخ</summary>

خیر؛ همان حذف ممکن است به آن هم منتقل شود.

</details>

### ۳. RPO و RTO چیستند؟

<details><summary>پاسخ</summary>

RPO حد داده/بازهٔ قابل‌از‌دست‌رفتن است؛ RTO زمان مجاز بازگشت سرویس است.

</details>

### ۴. چه چیزی برای cache شاید کافی باشد؟

<details><summary>پاسخ</summary>

بدون persistence اگر بازسازی واقعاً ممکن و cold-start فشارپذیر مدیریت شده باشد.

</details>

### ۵. چه زمانی AOF را بررسی می‌کنی؟

<details><summary>پاسخ</summary>

وقتی replay تازه‌تر و پنجرهٔ از دست‌رفتن کوچک‌تر از snapshot-only ارزشش از هزینهٔ I/O/disk بیشتر باشد.

</details>

### ۶. آیا restore روی همون backup volume کافی است؟

<details><summary>پاسخ</summary>

خیر؛ backup باید از خرابی همان volume/host مستقل باشد و بازیابی‌اش تمرین شود.

</details>

## منابع

### انگلیسی و رسمی

- [Persistence در Redis Open Source](https://redis.io/docs/latest/management/persistence/)
- [Replication در Redis](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/)
- [مستند RDB/AOF و durability](https://redis.io/tutorials/operate/redis-at-scale/persistence-and-durability/)
- [مطالعهٔ موردی واقعی GitLab دربارهٔ انتخاب PostgreSQL به‌جای Redis Set برای آمار لازم‌الحفظ](https://about.gitlab.com/blog/database-case-study-store-and-update-namespace-statistics/)

### فارسی

- [مرور فارسی persistence و ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [مقالهٔ فارسی دربارهٔ Redis و کاربردهای آن](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)

مقالهٔ فارسی برای مقایسهٔ دقیق RPO و durability کم‌پوشش است؛ این فایل خودِ مدل تصمیم را توضیح می‌دهد. برای نسخه و سرویس مورد استفاده مستند رسمی/managed provider را ملاک بگیر.

</div>
