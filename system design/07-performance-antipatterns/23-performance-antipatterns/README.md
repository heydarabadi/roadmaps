<div dir="rtl" align="right">
[English version](../../en/07-performance-antipatterns/23-performance-antipatterns/README.md)


# Performance Antipatterns

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

ضدالگوها نشانهٔ انتخاب نادرست داده، I/O یا concurrency هستند؛ علت را در trace/metric پیدا کن، نه حدس.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

موارد roadmap: نمونه‌سازی نامناسب، persistence یکپارچه، noisy neighbor، I/O همگام، fetch اضافی، DB شلوغ، frontend شلوغ، chatty I/O، retry storm و نبود cache. N+1 در trace، connection pool اشباع، payload بزرگ، JS حجیم یا query بدون index نشانه‌های قابل‌اندازه‌گیری‌اند. درمان بسته به مورد batch، pagination، async I/O، pool جدا، index یا حذف کار اضافی است.

## درس گام‌به‌گام: تشخیص ده ضدالگو

ضدالگو را از روی نمودار حدس نزن؛ برای هرکدام نشانه، علت، اثر و سنجش داشته باش. یک مشکل می‌تواند چند علت هم‌زمان داشته باشد: مثلاً connection pool کوچک، query کند و retry نامحدود همگی latency را بالا می‌برند. قبل از تغییر، trace، query plan، resource saturation و توزیع بار را ثبت کن.

### ۱. Improper Instantiation

ساختن object، client، thread یا connection پرهزینه در هر درخواست می‌تواند allocation، GC، handshake و contention ایجاد کند. نمونه: ساخت HTTP client برای هر call و از دست‌دادن connection reuse. objectهای immutable و safe-to-share را به‌درستی reuse کن؛ pool را با عمر resource و shutdown هماهنگ کن. Pool بی‌سقف خودش می‌تواند منابع را تمام کند.

### ۲. Monolithic Persistence

یک storage/schema بزرگ برای دامنه‌های نامرتبط باعث coupling، migration پرریسک، رقابت منابع و مالکیت مبهم می‌شود. در عین حال جداکردن دیتابیس هر جدول الزاماً بهتر نیست؛ queryها و transactionهای مشترک را هم می‌شکند. با مرز ماژول و ownership روشن شروع کن و تنها برای نیاز استقلال/بار/امنیت واقعی data store را جدا کن.

### ۳. Noisy Neighbor

یک tenant یا job پرمصرف CPU، I/O، connection یا cache را می‌گیرد و latency دیگران را بالا می‌برد. برای تشخیص، metric را بر tenant/workload دسته‌بندی کن (با cardinality کنترل‌شده)، quota/limit، concurrency cap، priority و pool جدا بگذار. جداسازی کامل هزینه دارد؛ tenantهای کم‌خطر می‌توانند منابع مشترک داشته باشند.

### ۴. Synchronous I/O

Thread هنگام انتظار برای شبکه یا دیسک بیکار می‌ماند ولی ظرفیت اشغال می‌کند. async I/O می‌تواند thread را آزاد کند، اما اگر dependency کند باشد صف taskها همچنان رشد می‌کند. async را با bounded concurrency، timeout، backpressure و cancellation همراه کن؛ تبدیل بی‌رویهٔ همه‌چیز به async بدون محدودیت ظرفیت درمان نیست.

### ۵. Extraneous Fetching

برنامه دادهٔ بیشتر از نیاز می‌خواند یا همان داده را چندبار fetch می‌کند: N+1 query، payload عظیم، فیلدهای اضافی، pagination نامحدود. query shape، index و endpoint را با نیاز صفحه هماهنگ کن؛ batch، projection، cursor pagination و cache در جای درست کمک می‌کنند. fetch کردن «همهٔ داده‌ها برای آینده» memory و شبکه را هدر می‌دهد.

### ۶. Busy Database

DB از queryهای پرهزینه، index زیاد، lock، connection زیاد یا burst نوشتن اشباع می‌شود. query plan، slow query log، lock wait، buffer/cache، IOPS و connection pool را بررسی کن. اصلاح index/query، کاهش transaction طولانی، read replica یا partition می‌تواند کمک کند، ولی replica نوشتن را سبک نمی‌کند و query نامناسب را درمان نمی‌کند.

### ۷. Busy Frontend

محاسبه و asset حجیم در browser زمان بارگذاری/رندر را زیاد می‌کند و دستگاه ضعیف را تحت فشار می‌گذارد. bundle analysis، long task، Core Web Vitals، lazy loading، code splitting، image size و hydration را بسنج. کوچک‌کردن bundle نباید دسترس‌پذیری یا تجربهٔ offline را خراب کند.

### ۸. Chatty I/O

تعداد زیادی round trip کوچک به سرویس یا DB هزینهٔ latency هر مرحله را روی هم جمع می‌کند. N+1 بین microserviceها نیز همین الگو را دارد. batch API، bulk operation یا ترکیب queryها را با نیاز atomicity و payload مقایسه کن؛ batch بزرگ ممکن است memory، timeout و retry سنگین بسازد.

### ۹. Retry Storm

پس از outage، clientهای زیادی هم‌زمان retry می‌کنند و سرویس recovery را غرق می‌کنند. retry باید برای خطای transient، محدود، با exponential backoff و jitter باشد؛ deadline و retry budget داشته باشد و تنها یک لایه مالک retry باشد. Circuit breaker، rate limit و load shedding کمک می‌کنند، اما باید از retry پنهان SDK/LB هم آگاه باشی.

### ۱۰. No Caching

دادهٔ پرتکرار، پایدار و کم‌حساسیت برای هر خواندن دوباره از منبع گران گرفته می‌شود. cache می‌تواند latency و load را کم کند، ولی invalidate، TTL، security و stale behavior نیاز دارد. برای دادهٔ شخصی یا حیاتی cache مشترک ناامن/قدیمی نساز. گاهی index یا query بهتر از اضافه‌کردن cache است.

## روند عیب‌یابی

1. کندی را به endpoint، tenant، payload و percentile محدود کن.
2. از trace و query plan علت غالب را پیدا کن.
3. یک فرض قابل‌ردشدن بنویس؛ مثلاً «80% زمان در query N+1 است».
4. کوچک‌ترین تغییر را روی همان workload بسنج.
5. latency، خطا، هزینه و correctness را بعد از تغییر مقایسه کن؛ rollback criterion هم داشته باش.

## مرور همهٔ ریزموضوع‌های roadmap

- Improper Instantiation: ساخت مکرر object/connection پرهزینه؛ reuse یا pool با عمر درست.
- Monolithic Persistence: یک schema/DB برای همهٔ دامنه‌ها باعث coupling و رقابت می‌شود.
- Noisy Neighbor: workload پرمصرف منابع مشترک دیگران را می‌گیرد.
- Synchronous I/O: thread در انتظار I/O می‌ماند و ظرفیت هم‌زمانی را می‌سوزاند.
- Extraneous Fetching: دادهٔ بیش از نیاز یا N+1 round trip.
- Busy Database: query، index، lock یا connection بیش از ظرفیت DB.
- Busy Frontend: محاسبه و asset زیاد در مرورگر؛ بودجهٔ JS و rendering لازم است.
- Chatty I/O: رفت‌وبرگشت‌های کوچک و مکرر؛ batch یا API مناسب‌تر.
- Retry Storm: retry هماهنگ و بی‌سقف بار را تشدید می‌کند.
- No Caching: خواندن پرتکرار دادهٔ پایدار بی‌نیاز به منبع اصلی می‌رود.

## مثال عملی

صفحهٔ سفارش برای هر ردیف یک query دارد؛ با صد ردیف round-trip زیاد می‌شود. batching و سقف صفحه را بسنج.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

تغییر را با SLO و دادهٔ قبل/بعد بسنج؛ micro-optimization بی‌مدرک را عقب بینداز.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- درمان با cache پیش از fix query؛ pool بی‌حد؛ retry برای هر کندی؛ بهینه‌سازی فقط میانگین.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. N+1 به کدام ضدالگو نزدیک است؟
2. retry storm چطور شکل می‌گیرد؟
3. برای noisy neighbor چه جداسازی‌ای مفید است؟

### پاسخ‌نامهٔ فشرده

1. N+1 یا fetch کردن دادهٔ بی‌نیاز باعث رفت‌وآمد اضافه به DB/سرویس می‌شود.
2. همهٔ clientها پس از یک اختلال هم‌زمان retry می‌کنند و بار روی سرویس آسیب‌دیده موج جدید می‌سازد.
3. محدودیت نرخ/هم‌زمانی و pool جدا به تفکیک tenant، با سهم منصفانه و بودجهٔ ظرفیت.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

ضدالگوها نشانهٔ انتخاب نادرست داده، I/O یا concurrency هستند؛ علت را در trace/metric پیدا کن، نه حدس. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [معماری وب و اجزای یک سامانه](https://virgool.io/Quera-Mag/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%88%D8%A8-%D8%A2%D8%B4%D9%86%D8%A7%DB%8C%DB%8C-%D9%85%D9%81%D8%A7%D9%87%DB%8C%D9%85-%D9%BE%D8%A7%DB%8C%D9%87-ofbcud4oao0c)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure: Performance antipatterns](https://learn.microsoft.com/en-us/azure/architecture/antipatterns/)
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

