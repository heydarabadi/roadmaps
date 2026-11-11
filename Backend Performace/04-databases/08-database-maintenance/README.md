<div dir="rtl" align="right">

# نگهداری دیتابیس — آمار، VACUUM و ظرفیت

**زبان:** فارسی · [English version](README.en.md)


**هدف یادگیری:** کار ANALYZE و VACUUM را جدا کنید، عقب‌افتادگی نگهداری را از روی سیگنال‌ها ببینید و پیش از عملیات سنگین قفل/فضا را ارزیابی کنید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ مثال مشخصاً PostgreSQL است و اجرا نشده است. موتورهای دیگر چرخه بازیافت و نگهداری متفاوت دارند.

## مدل ذهنی

در MVCC، UPDATE/DELETE می‌تواند نسخه قدیمی ردیف باقی بگذارد. VACUUM فضای نسخه‌های قابل پاک‌سازی را برای استفاده دوباره آماده می‌کند؛ ANALYZE آمار توزیع داده برای planner می‌گیرد. Autovacuum بسیاری از این کارها را خودکار انجام می‌دهد، اما نرخ تغییر و اندازه جدول ممکن است تنظیم متناسب بخواهد. تراکنش طولانی می‌تواند پاک‌سازی برخی نسخه‌های قدیمی را عقب بیندازد.

| عملیات PostgreSQL | هدف | نکته عملیاتی |
| --- | --- | --- |
| ANALYZE | آمار planner | آمار تخمین است، نه شمارش دقیق کل |
| VACUUM معمولی | بازیافت نسخه‌های مرده، visibility | معمولاً فضای داخلی را قابل reuse می‌کند |
| VACUUM FULL | بازنویسی و فشرده‌سازی جدول | قفل سنگین و فضای موقت اضافی |
| Backup/restore drill | امکان بازیابی | جایگزین VACUUM نیست |

[راهنمای Routine vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html) علاوه بر فضا، visibility map و جلوگیری از transaction ID wraparound را نیز مطرح می‌کند. خاموش‌کردن نگهداری برای ساکت‌شدن نمودار، بدهی عملیاتی می‌سازد.

## کاربرد و مصالحه

نگهداری برنامه‌ای دائمی است. workload پرتغییر به پایش جدول‌محور نیاز دارد؛ تقویم یکسان برای همه جدول‌ها کافی نیست. VACUUM/ANALYZE هم I/O و CPU دارند؛ بودجه آن‌ها باید با بار تولید هماهنگ باشد. VACUUM FULL برنامه روزمره کاهش latency نیست و با VACUUM معمولی یکسان نیست. Reindex، بازنویسی و حذف index باید علت، قفل، فضا و راه بازگشت مشخص داشته باشند.

## مثال حل‌شده

برای جدول آزمایشی موجود `orders`، ابتدا تخمین و زمان نگهداری را بخوانید:

<div dir="ltr" align="left">

```sql
SELECT relname, n_live_tup, n_dead_tup,
       last_autovacuum, last_autoanalyze
FROM pg_stat_user_tables
WHERE relname = 'orders';

ANALYZE orders;
-- Standalone command, not inside BEGIN/COMMIT:
VACUUM (ANALYZE) orders;
```

</div>

`n_dead_tup` تخمین است و تنها مدرک bloat نیست. آخرین زمان، مدت و میزان کار را کامل نشان نمی‌دهد. در production، نبود timestamp تازه را با نرخ تغییر، workerها، progress و تراکنش‌های طولانی بررسی کنید؛ یک query به‌تنهایی دستور VACUUM FULL نیست. [مرجع VACUUM](https://www.postgresql.org/docs/current/sql-vacuum.html) محدودیت تراکنش و قفل‌ها را شرح می‌دهد.

## تمرین و مشاهده مورد انتظار

در دیتابیس موقت، جدولی با ۱۰ هزار ردیف بسازید، بخشی را UPDATE/DELETE کنید، سپس ANALYZE و VACUUM معمولی اجرا کنید. آمار، پلن و اندازه فایل را یادداشت کنید. انتظار: فضای نسخه‌های مرده برای reuse آماده شود؛ فایل الزاماً به همان نسبت کوچک نمی‌شود. آمار با فاصله به‌روز می‌شود و نمونه‌گیری می‌تواند فرق کند. آزمایش دوم را با یک تراکنش طولانی REPEATABLE READ که SELECT اولیه انجام داده و هنوز باز است تحلیل کنید؛ چرا بعضی نسخه‌ها هنوز لازم‌اند؟ این دستورها روی اطلاعات واقعی تمرین نشوند.

## شاهد عمومی و حد شواهد

[مستند رسمی نگهداری PostgreSQL](https://www.postgresql.org/docs/current/routine-vacuuming.html) شاهد عملیاتی این درس است. گزارش یک شرکت با نتیجه عددی مستقیم ارائه نشده؛ سناریوی جدول orders آموزشی است. رفتار compaction در موتورهای LSM یا rebuild در SQL Server را به VACUUM تعمیم ندهید.

## شکست‌ها، سیگنال‌ها و چک‌لیست

رشد disk/WAL، آمار کهنه، dead tuple بالا، تراکنش قدیمی و عقب‌افتادگی workerها را کنار latency بررسی کنید. Replication slot عقب‌مانده نیز می‌تواند WAL نگه دارد؛ حذف آن بدون دانستن مصرف‌کننده خطر دارد. rebuild هم‌زمان چند جدول می‌تواند ظرفیت دیسک را تمام کند.

- [ ] سلامت autovacuum، worker و نرخ تغییر جدول پایش می‌شود.
- [ ] تراکنش‌های قدیمی و idle in transaction قابل مشاهده‌اند.
- [ ] آمار planner و اختلاف estimate/actual بررسی می‌شوند.
- [ ] فضای آزاد، رشد WAL و retention/slotها مالک دارند.
- [ ] عملیات سنگین قفل، فضای موقت، زمان اجرا و راه بازگشت دارد.
- [ ] Backup و بازیابی آزمایشی جدا از نگهداری تأیید می‌شوند.

## پیش‌نیازها و سازوکار نگهداری

در PostgreSQL و MVCC، UPDATE/DELETE می‌تواند نسخه قدیمی باقی بگذارد تا snapshot مجاز هنوز آن را ببیند. VACUUM نسخه‌های قابل پاک‌سازی را پردازش و فضا را معمولاً برای استفاده دوباره درون relation آماده می‌کند؛ ANALYZE نمونه می‌گیرد تا تخمین planner را تازه کند. Autovacuum این کارها را با آستانه‌ها انجام می‌دهد؛ آن را با compact فوری فایل و بازگرداندن همه فضا به سیستم‌عامل یکی نگیرید.

### حل سناریوی تمرین و تشخیص

بعد از ساخت ۱۰هزار ردیف و تغییر/حذف ۲هزار، شمار dead tuple تخمینی است؛ امکان پاک‌سازی به snapshotهای هنوز باز هم بستگی دارد. ANALYZE تازه‌کردن estimate را هدف می‌گیرد؛ VACUUM معمولی نسخه‌های قابل حذف و visibility را پردازش می‌کند. فایل الزاماً به نسبت ۲هزار ردیف کوچک نمی‌شود، چون فضای داخلی می‌تواند برای درج‌های بعدی reuse شود. تراکنش REPEATABLE READ قدیمی ممکن است نسخه پیشین را لازم داشته باشد.

اگر dead tuple یا disk رو به رشد است، روند و نرخ تغییر چند بازه را ببینید؛ بعد آخرین autovacuum/autoanalyze، worker و تراکنش طولانی را بررسی کنید. mismatch estimate/actual به آمار مربوط است؛ cleanup عقب‌افتاده به VACUUM و snapshotها. فضای دیسک و WAL را جدا بسنجید، از جمله replication slot عقب‌مانده. n_dead_tup به‌تنهایی مجوز VACUUM FULL نیست؛ قفل، فضای موقت، پنجره کار و برگشت را ارزیابی کنید.

## جمع‌بندی

ANALYZE تخمین planner را تازه می‌کند؛ VACUUM چرخه نسخه‌های قدیمی و reuse را پیش می‌برد. موتور و علت رشد را پیش از عملیات سنگین مشخص کنید.

## خودآزمایی

۱. تفاوت VACUUM و ANALYZE چیست؟

۲. آیا VACUUM معمولی باید اندازه فایل را نصف کند؟

۳. چرا تراکنش طولانی می‌تواند مانع پاک‌سازی شود؟

۴. چرا VACUUM FULL نباید برنامه پیش‌فرض هر شب باشد؟

۵. آیا `n_dead_tup` عدد دقیق و دستور قطعی بازنویسی است؟

### پاسخ‌نامه با دلیل

۱. اولی نسخه‌های قابل پاک‌سازی/فضا را مدیریت می‌کند؛ دومی آمار planner را می‌گیرد. ترکیبشان نیز ممکن است.

۲. خیر؛ reuse داخلی هدف معمول است و بازگرداندن فضا به OS تضمین هم‌اندازه نیست.

۳. snapshot قدیمی ممکن است هنوز نسخه‌ها را لازم داشته باشد؛ حذف زودهنگام صحت خواندن را خراب می‌کند.

۴. جدول را بازنویسی می‌کند، قفل سنگین و فضای اضافی می‌خواهد؛ باید علت و پنجره عملیاتی داشته باشد.

۵. خیر؛ تخمین است و باید همراه روند، اندازه، نرخ تغییر و نوع workload تفسیر شود.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- انگلیسی: [Routine vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html)؛ چرخه MVCC، autovacuum و wraparound.
- انگلیسی: [Vacuum configuration](https://www.postgresql.org/docs/current/runtime-config-vacuum.html)؛ تنظیمات آستانه، scale factor و workerهای autovacuum در PostgreSQL؛ مقدار مناسب به اندازه و نرخ تغییر جدول وابسته است.
- انگلیسی: [VACUUM command](https://www.postgresql.org/docs/current/sql-vacuum.html) و [Monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html)؛ رفتار دستور و معنای viewها.
- فارسی: منبع مستقیم مناسب برای نگهداری PostgreSQL نسخه جاری در این بررسی تأیید نشد؛ شرح فارسی این صفحه ارائه شده است. ادعاهای موتور را با منبع رسمی نسخه خود تطبیق دهید.

- English, official: [PostgreSQL ANALYZE](https://www.postgresql.org/docs/current/sql-analyze.html) documents how statistics are collected and how sampling affects estimates.
- English, official: [PostgreSQL monitoring statistics](https://www.postgresql.org/docs/current/monitoring-stats.html) describes table statistics and monitoring views.
- English, official: [PostgreSQL transaction ID wraparound protection](https://www.postgresql.org/docs/current/routine-vacuuming.html#VACUUM-FOR-WRAPAROUND) explains why vacuum maintenance is also a correctness safeguard.
- Persian-source gap: no trustworthy Persian reference specific to current PostgreSQL vacuum operations was verified for this review; this page provides the Persian explanation.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [قبلی: Join](../07-join-optimization/README.md) · [بعدی: Slow logs](../09-slow-query-logging/README.md) · [Replication](../10-replication/README.md)

</div>


