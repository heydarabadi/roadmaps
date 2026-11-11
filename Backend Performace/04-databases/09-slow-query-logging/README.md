<div dir="rtl" align="right">

# ثبت کوئری‌های کند — Slow-query Logging

**زبان:** فارسی · [English version](README.en.md)


**هدف یادگیری:** لاگ یک اجرای کند را از آمار تجمیعی جدا کنید، آستانه و نمونه‌برداری را آگاهانه انتخاب کنید و اطلاعات حساس را در طراحی ثبت لحاظ کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ تنظیم‌ها مخصوص PostgreSQL و اجرا‌نشده‌اند.

## مدل ذهنی

Slow log رخداد یک اجرای مشخص را ثبت می‌کند: چه زمان، چه statement و با چه مدت؟ آمار تجمیعی می‌گوید خانواده query در یک بازه چه هزینه‌ای داشته است. query پرتکرار ۱۰ میلی‌ثانیه‌ای شاید هزینه کل بیشتری از query نادر ۲ثانیه‌ای داشته باشد، هرچند از آستانه slow log عبور نکند. لاگ query نیز زمان انتظار گرفتن اتصال در برنامه را نشان نمی‌دهد.

| ابزار/شاخص | پاسخ | محدودیت |
| --- | --- | --- |
| Slow log | کدام اجرای کند و چه زمانی؟ | حجم، هزینه و داده حساس |
| pg_stat_statements | خانواده پرتکرار و هزینه مجموع | رخداد تک‌اجرا و p99 نمی‌دهد |
| App trace | مسیر درخواست و وابستگی‌ها | نیاز به instrumentation و sampling |

در [مرجع Logging PostgreSQL](https://www.postgresql.org/docs/current/runtime-config-logging.html)، `log_min_duration_statement` آستانه ثبت statement تمام‌شده است؛ `-1` غیرفعال و `0` ثبت همه مدت‌هاست. این آستانه timeout یا لغو query نیست. نمونه‌برداری مدت‌محور با تنظیم‌های جدا وجود دارد؛ نام و تعاملشان را برای نسخه خود بخوانید.

## کاربرد و مصالحه

برای تشخیص رخدادهای پراکنده و هم‌بستگی با lock/I/O مفید است. ثبت همه queryها برای همیشه ممکن است هزینه CPU، دیسک و انتقال زیادی داشته باشد. آستانه را از SLO و هزینه ثبت انتخاب کنید؛ عدد نمونه زیر توصیه عمومی نیست. query text، literal و bind parameter می‌توانند داده شخصی یا secret داشته باشند؛ محدودکردن پارامترهای لاگ، literal داخل متن SQL را لزوماً پاک نمی‌کند. دسترسی، retention و redaction پایین‌دست را طراحی کنید.

## مثال حل‌شده

در session آزمایشی با مجوز لازم، فقط برای دیدن رفتار آستانه:

<div dir="ltr" align="left">

```sql
SHOW log_min_duration_statement;
SET log_min_duration_statement = '250ms';
SELECT pg_sleep(0.05);
SELECT pg_sleep(0.30);
RESET log_min_duration_statement;
```

</div>

با دسترسی به مقصد لاگ، انتظار می‌رود statement دوم ثبت شود و اولی در شرایط معمول زیر آستانه بماند. load واقعی می‌تواند زمان را تغییر دهد. محل لاگ و مجوز SET به نصب و سرویس managed بستگی دارد. RESET به مقدار session پیشینِ سفارشی لزوماً برنمی‌گردد؛ در آزمایش session جدا باز کنید یا مقدار قبلی را ثبت و صریح بازگردانید. در پروتکل extended، مرحله‌های parse/bind/execute جزئیات ثبت خاص خود را دارند.

## تمرین و مشاهده مورد انتظار

سناریوی بالا را در محیط موقت اجرا و ساعت، session و مدت را با log مقایسه کنید. سپس روی کاغذ دو workload را رتبه‌بندی کنید: A با ۱۰۰۰ اجرای ۱۰ms و B با یک اجرای ۲s. انتظار: B در آستانه ۲۵۰ms دیده می‌شود، اما مجموع زمان A برابر ۱۰s و B برابر ۲s است. برای A باید آمار تجمیعی هم داشت. این جمع زمان، مدت تقویمی در اجرای هم‌زمان نیست.

## شاهد عمومی و حد شواهد

[مستند رسمی Error Reporting and Logging](https://www.postgresql.org/docs/current/runtime-config-logging.html) شاهد عملیاتی آستانه‌ها و هزینه/جزئیات ثبت است. این درس گزارش incident یا بهبود عددی یک شرکت ندارد؛ `pg_sleep` عمداً آزمایش آستانه است و benchmark query واقعی نیست.

## شکست‌ها، سیگنال‌ها و چک‌لیست

نبود log همیشه به معنی سریع‌بودن سیستم نیست: مقصد اشتباه، sampling یا انتظار Pool می‌تواند توضیح باشد. حجم لاگ و dropped logs را پایش کنید. ثبت query کامل در ticket عمومی و metric label با SQL خام هم می‌تواند نشت داده و cardinality بالا ایجاد کند.

- [ ] آستانه، sampling و بازه فعال‌بودن ثبت مشخص است.
- [ ] مقصد، rotation، retention و فضای دیسک پایش می‌شود.
- [ ] مجوز دسترسی و مدیریت literal/parameter حساس تعریف شده است.
- [ ] timestamp، DB/user/session و شناسه هم‌بستگی مناسب وجود دارد.
- [ ] slow log با آمار تجمیعی و trace درخواست تکمیل می‌شود.
- [ ] تنظیم آزمایشی و مسیر بازگرداندن آن ثبت شده است.

## پیش‌نیازها، محاسبه و واکنش به لاگ

آستانه ثبت تعیین می‌کند کدام اجرای statement وارد log شود؛ timeout حد اجرای مجاز را محدود و ممکن است query را لغو کند. آمار تجمیعی اجرای یک خانواده query را در بازه خلاصه می‌کند. بنابراین یک رخداد کند و بیشترین مصرف‌کننده ظرفیت دو پرسش متفاوت‌اند.

### حل محاسبه تمرین

خانواده A هزار اجرا × ۱۰ms = ۱۰٬۰۰۰ms = ۱۰s زمان اجرای جمع‌شده دارد. خانواده B یک اجرا × ۲٬۰۰۰ms = ۲s دارد. با آستانه ۲۵۰ms، B در slow log ظاهر می‌شود و A نه؛ بااین‌حال A پنج برابر زمان جمع‌شده مصرف کرده است. این جمع، زمان تقویمی نیست چون اجراها می‌توانند هم‌زمان باشند. Log را برای رخداد منفرد و آمار/trace را برای سهم خانواده در بار به‌کار ببرید.

### حل تمرین و تشخیص

در سناریوی pg_sleep، ۵۰ms زیر آستانه و ۳۰۰ms بالاتر است، پس اجرای دوم انتظار می‌رود ثبت شود؛ سربار محیط مدت را تغییر می‌دهد. اگر کاربر کندی می‌بیند ولی slow log خالی است، Pool، شبکه و برنامه را بررسی کنید، سپس sampling، threshold، مقصد log و افت/rotation را کنترل کنید. پیش از پایین‌آوردن آستانه، نرخ لاگ، فضای retention و privacy متن query را برآورد کنید. حذف bind parameter همه داده حساس داخل متن SQL را پاک نمی‌کند.

## جمع‌بندی

Slow log رخداد را پیدا می‌کند؛ آمار تجمیعی هزینه پرتکرار را. ثبت، مشاهده‌پذیری است و جای timeout یا trace انتهابه‌انتها را نمی‌گیرد.

## خودآزمایی

۱. تفاوت آستانه slow log و statement timeout چیست؟

۲. چرا هزار query سریع ممکن است مهم‌تر از یک query کند باشد؟

۳. آیا محدودکردن bind parameter همه داده حساس را حذف می‌کند؟

۴. چرا درخواست کند ممکن است هیچ slow SQL نداشته باشد؟

۵. چرا صفرکردن آستانه برای همیشه نیازمند ارزیابی است؟

### پاسخ‌نامه با دلیل

۱. اولی ثبت می‌کند؛ دومی می‌تواند اجرا را لغو کند. ابزار مشاهده و کنترل یکی نیستند.

۲. هزینه مجموع حاصل تعداد و مدت است؛ query زیر آستانه هم ظرفیت مصرف می‌کند.

۳. خیر؛ literal داخل SQL یا metadata نیز می‌تواند حساس باشد و سیاست مستقل بخواهد.

۴. زمان ممکن است در Pool، شبکه، برنامه یا چند query کوتاه صرف شده باشد.

۵. همه statementها لاگ می‌شوند؛ CPU، I/O، انتقال و retention می‌توانند پرهزینه شوند.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [PostgreSQL logging configuration](https://www.postgresql.org/docs/current/runtime-config-logging.html)؛ آستانه، نمونه‌برداری و پارامترها.
- انگلیسی تکمیلی: [Monitoring database activity](https://www.postgresql.org/docs/current/monitoring.html)؛ جایگاه log کنار ابزارهای دیگر.
- فارسی: [شناسایی کوئری‌های کند پایگاه داده](https://pro-nee.net/terms/slow-queries/)؛ مقدمه Slow query log، APM و EXPLAIN. تنظیم دقیق PostgreSQL، محرمانگی و نمونه‌برداری را از مرجع رسمی بالا بگیرید؛ هیچ بازنویسی Join/CTE را بدون سنجش بهتر فرض نکنید.

- English, official: [pg_stat_statements](https://www.postgresql.org/docs/current/pgstatstatements.html) documents query-family aggregates, resets, and planning/execution statistics.
- English, official: [PostgreSQL monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html) describes activity views alongside persistent query aggregates.
- English, official: [PostgreSQL logging configuration](https://www.postgresql.org/docs/current/runtime-config-logging.html) is the authoritative reference for duration thresholds, sampling, and logging controls.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: نگهداری](../08-database-maintenance/README.md) · [بعدی: Replication](../10-replication/README.md) · [Profiling](../12-database-profiling/README.md) · [پایش](../../07-monitoring-and-logging/README.md)

</div>


