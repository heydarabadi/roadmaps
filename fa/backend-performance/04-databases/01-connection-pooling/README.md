<div dir="rtl" align="right">

# استخر اتصال — Connection Pooling

**زبان:** فارسی · [English version](../../../../en/backend-performance/04-databases/01-connection-pooling/README.md)


**هدف یادگیری:** بتوانید بازاستفاده از اتصال را از کش داده جدا کنید، اندازه Pool را با ظرفیت دیتابیس تنظیم کنید و علت انتظار گرفتن اتصال را تشخیص دهید. **بررسی منابع: ۲۰۲۶-۱۱-۱۰**؛ مثال‌ها آموزشی و اجرا‌نشده‌اند.

## مدل ذهنی و سازوکار

ساخت اتصال شامل شبکه، احراز هویت و ایجاد نشست است. Pool اتصال‌های باز را نگه می‌دارد؛ درخواست اتصال را قرض می‌گیرد، کار کوتاه خود را انجام می‌دهد و در مسیر موفقیت یا خطا پس می‌دهد. Pool محدود، هم‌زمانی ورود به دیتابیس را کنترل می‌کند؛ ظرفیت اجرای SQL نامحدود نمی‌شود.

| مرحله | زمان قابل اندازه‌گیری | علت احتمالی کندی |
| --- | --- | --- |
| گرفتن اتصال | acquire wait | Pool اشباع، نشت، تراکنش طولانی |
| اجرای SQL | execution/lock wait | پلن، قفل، I/O یا CPU |
| آزادسازی | hold duration | نگه‌داشتن اتصال حین تماس با سرویس دیگر |

Pool در driver و Pooler بیرونی دو لایه متفاوت‌اند. در [PgBouncer](https://www.pgbouncer.org/config)، حالت session اتصال سرور را تا قطع کلاینت، transaction تا پایان تراکنش، و statement تا پایان statement نگه می‌دارد؛ حالت آخر تراکنش چنددستوری را نمی‌پذیرد. این تفاوت روی state نشست اثر دارد.

## کاربرد و مصالحه

برای درخواست‌های کوتاه پرتکرار مفید است. تراکنش طولانی یا session state مانند temp table و SET پایدار نیازمند بررسی سازگاری حالت Pooler است. پشتیبانی prepared statement به نسخه، driver، پروتکل و تنظیم وابسته است؛ PgBouncer با `max_prepared_statements` غیرصفر برخی prepared statementهای نام‌دار در سطح پروتکل را مدیریت می‌کند، اما SQL-level PREPARE همان رفتار را ندارد. عدد تنظیم را از مستند نسخه خود بردارید.

Pool بزرگ‌تر صف را موقتاً کم می‌کند، ولی می‌تواند رقابت CPU، حافظه و قفل را بیشتر کند. timeout گرفتن اتصال، deadline درخواست و سیاست رد بار را هماهنگ کنید؛ retry بی‌وقفه صف جدید می‌سازد.

## مثال حل‌شده

فرض آموزشی: ۴ نمونه برنامه، هرکدام Pool حداکثر ۲۰ اتصال؛ مجموع بالقوه ۸۰ اتصال است. اگر بودجه توافق‌شده این سرویس در دیتابیس ۶۰ باشد، تنظیم قابل قبول نیست؛ حتی اگر هر نمونه جداگانه سالم به نظر برسد. رزرو admin، worker و سرویس‌های دیگر نیز باید جدا حساب شود.

<div dir="ltr" align="left">

```text
connection = pool.acquire(timeout = remaining_request_budget)
try:
    begin(connection)
    rows = query(connection, parameterized_sql)
    commit(connection)
    return rows
catch error:
    rollback_if_needed(connection)
    raise error
finally:
    pool.release_or_discard_broken(connection)
```

</div>

تماس HTTP یا پردازش تصویر را پیش از گرفتن اتصال یا پس از آزادسازی انجام دهید، مگر نیاز تراکنشی مشخصی وجود داشته باشد. rollback خطادار یا اتصال خراب نباید بدون پاک‌سازی به مصرف‌کننده بعد برسد.

## تمرین کوچک و مشاهده مورد انتظار

در یک محیط آزمایشی ۱۰ درخواست هم‌زمان را با Pool دواتصالی اجرا کنید؛ هر query را عمداً ۱۰۰ میلی‌ثانیه شبیه‌سازی کنید و acquire wait/hold time را جدا بنویسید. سپس یک درخواست را در مسیر خطا قرار دهید و آزادسازی را بررسی کنید. انتظار: درخواست‌ها در چند موج سرویس می‌گیرند؛ زمان SQL ثابت می‌ماند ولی انتظار Pool رشد می‌کند. پس از خطا، ظرفیت باید به دو برگردد. این آزمایش throughput واقعی موتور را ثابت نمی‌کند.

## شاهد عمومی و حد شواهد

[مستند عملیاتی PgBouncer](https://www.pgbouncer.org/config) چرخه آزادسازی و محدودیت‌های حالت‌ها را مستند می‌کند. این شاهد رفتار ابزار است؛ مطالعه موردی عمومی با درصد بهبود قابل تعمیم برای مثال این درس ارائه نشده است. اندازه ۲۰ در مثال، گزارش شرکت یا توصیه پیش‌فرض نیست.

## شکست‌ها، سیگنال‌ها و چک‌لیست عملیاتی

نشت اتصال با busy ثابت و رشد acquire timeout دیده می‌شود. `idle in transaction` می‌تواند قفل/نسخه قدیمی نگه دارد. Scale-out برنامه، failover یا بازسازی هم‌زمان Poolها نیز می‌تواند هجوم اتصال بسازد. شمارش waiters را کنار CPU و active transaction ببینید.

- [ ] سقف تجمعی تمام نمونه‌ها، workerها و کاربران Pooler معلوم است.
- [ ] acquire timeout و deadline سراسری محدودند؛ صف نامحدود نیست.
- [ ] finally/cleanup و rollback در مسیر خطا وجود دارد.
- [ ] سازگاری session state و prepared statement برای نسخه واقعی بررسی شده است.
- [ ] acquire wait، hold time، busy/idle، timeouts و DB saturation ثبت می‌شوند.
- [ ] رفتار failover، اتصال شکسته و بازاتصال تدریجی مشخص است.

## پیش‌نیازها، چرخه اتصال و تشخیص صف

هم‌زمانی یعنی تعداد کارهایی که در یک بازه منتظر یا درحال اجرا هستند؛ نشست، وضعیت موقتی سمت دیتابیسِ یک اتصال است؛ و زمان نگه‌داری از قرض‌گرفتن تا بازگرداندن اتصال حساب می‌شود. Pool اتصال را بازاستفاده می‌کند، نه نتیجه query را.

۱. برنامه از Pool اتصال با مهلتِ باقی‌مانده درخواست می‌کند.
۲. پس از دریافت، تراکنش را فقط دور کار دیتابیسی لازم باز نگه می‌دارد.
۳. در پایان commit یا rollback می‌کند؛ اتصال خراب کنار گذاشته و اتصال سالم آزاد می‌شود.
۴. زمان acquire، اجرای SQL و hold time را جدا ثبت می‌کند؛ این سه محل ازدحام متفاوتی نشان می‌دهند.

### حل محاسبه Pool دواتصالی

اگر ۱۰ کار هم‌زمان هرکدام اتصال را دقیقاً ۱۰۰ms نگه دارند، در مدل بدون سربار ۵ موج لازم است. دو درخواست اول انتظار ندارند؛ موج دوم حدود ۱۰۰ms و موج پنجم حدود ۴۰۰ms منتظر می‌ماند. میانگین انتظار (۰+۰+۱۰۰+۱۰۰+۲۰۰+۲۰۰+۳۰۰+۳۰۰+۴۰۰+۴۰۰)÷۱۰ = ۲۰۰ms است؛ زمان SQL هنوز ۱۰۰ms است. این محاسبه صف را توضیح می‌دهد و benchmark دیتابیس نیست.

### مسیر عیب‌یابی و حل تمرین

اگر acquire wait بالا و SQL time پایین است، busy/idle و تعداد منتظران را ببینید؛ سپس تراکنش‌های باز، مسیرهای خطا و مدت hold را بررسی کنید. اگر hold طولانی ولی SQL کوتاه است، تماس شبکه‌ای یا کار برنامه را داخل بازه اتصال پیدا کنید. اگر SQL و قفل کندند، به پلن و انتظار دیتابیس بروید. در تمرین، پنج موجِ دواتصالی هرکدام ۱۰۰ms طول می‌کشد، پس آخرین موج در ۵۰۰ms تمام می‌شود. اگر خطا اتصال را آزاد نکند، منتظران ادامه می‌یابند؛ پس از پاک‌سازی خطا باید دو اتصال دوباره قابل استفاده باشند.

## جمع‌بندی

Pool تعداد اتصال‌های هم‌زمان را محدود و هزینه ساخت اتصال را بازاستفاده می‌کند. اندازه آن از بودجه تجمعی و توان دیتابیس می‌آید؛ صف اتصال و زمان اجرای query را جدا تشخیص دهید.

## خودآزمایی

۱. آیا Pool نتیجه SELECT را ذخیره می‌کند؟

۲. با سه نمونه برنامه و سقف ۳۰، بودجه بالقوه اتصال چند است؟

۳. SQL سریع است ولی acquire wait زیاد؛ اولین بررسی چیست؟

۴. چرا HTTP call داخل تراکنش می‌تواند ظرفیت را کم کند؟

۵. آیا transaction pooling همیشه با state نشست سازگار است؟

### پاسخ‌نامه با دلیل

۱. خیر؛ اتصال را بازاستفاده می‌کند. کش نتیجه سازوکار جدا با قواعد تازگی است.

۲. ۹۰؛ سقف هر فرایند در تعداد نمونه‌ها ضرب می‌شود و مصرف‌کننده‌های دیگر جدا افزوده می‌شوند.

۳. busy/idle، زمان نگه‌داشتن و مسیر آزادسازی؛ کندی صف الزاماً کندی query نیست.

۴. اتصال و احتمالاً قفل تا پایان تماس اشغال می‌مانند و درخواست‌های دیگر منتظر می‌شوند.

۵. خیر؛ اتصال سرور پس از تراکنش عوض می‌شود، پس وابستگی به state پایدار باید صریح بررسی شود.

## منابع اختیاری برای مطالعه بیشتر

پیوندهای این بخش برای مطالعه تکمیلی و بررسی جزئیات نسخه/محصول‌اند؛ برای فهم سازوکار و انجام تمرین لازم نیستند.

- فارسی: [مدیریت Connection Pooling و DbContext Pooling](https://dntips.ir/www.dntips.ir-posts-3725.html)؛ برای تفکیک Pool اتصال از بازاستفاده شیء ORM در .NET، نه نسخه تنظیمات همه driverها.
- انگلیسی: [PgBouncer configuration](https://www.pgbouncer.org/config)؛ مرجع حالت‌ها، صف و محدودیت‌های نسخه نصب‌شده.

- English, official: [Microsoft SQL Server connection pooling](https://learn.microsoft.com/en-us/sql/connect/ado-net/sql-server-connection-pooling?view=sql-server-ver17) explains client-side pool reuse and exhaustion behavior; its defaults are provider-specific.
- English, official: [Amazon RDS Proxy concepts](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy.howitworks.html) distinguishes client and database connections and describes multiplexing.
- English, official: [RDS Proxy connection considerations](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/rds-proxy-connections.html) covers pool limits, borrow waits, and metrics for that service.
- English, official: [PgBouncer FAQ](https://www.pgbouncer.org/faq.html) describes prepared-statement compatibility by version and client protocol.

[فهرست فصل](../README.md) · [فهرست مجموعه](../../README.md) · [درس بعد: ایندکس](../02-indexes/README.md) · [Scaling](../../05-load-balancing-and-scaling/README.md)

</div>


