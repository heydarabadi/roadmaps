<div dir="rtl" align="right">
[English version](../../en/10-reliability-security/30-resiliency-patterns/README.md)


# Resiliency Patterns

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

تاب‌آوری یعنی ادامهٔ کنترل‌شده یا بازیابی امن پس از خرابی جزئی؛ retry، جبران و انتخاب رهبر باید محدود و قابل مشاهده باشند.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Retry با exponential backoff و jitter خطای گذرا را تکرار می‌کند؛ Circuit Breaker از تلاش بی‌فایده می‌کاهد؛ Bulkhead ظرفیت را جدا می‌کند. Compensating Transaction اثر قبلی workflow را جبران می‌کند، نه اینکه زمان را عقب ببرد. Leader Election مالک را تعیین می‌کند و به fencing نیاز دارد. Health، Queue Leveling و Scheduler-Agent-Supervisor نیز جزو الگوهای roadmap هستند.

## درس گام‌به‌گام

### Retry، timeout و deadline

Retry را فقط برای خطای احتمالاً گذرا به کار ببر؛ validation و permission failure با تکرار درست نمی‌شوند. exponential backoff فاصله را زیاد می‌کند و jitter درخواست‌ها را در زمان پخش می‌کند. سقف تلاش و deadline مجموع را تنظیم کن. اگر call اصلی ممکن است side effect کرده باشد، همان idempotency key را نگه دار. Retry روی retry در چند لایه می‌تواند یک درخواست را ده‌ها برابر کند.

### Bulkhead و Circuit Breaker

Bulkhead تعداد منابعی را که یک dependency مصرف می‌کند محدود می‌کند. Circuit breaker پس از failureهای تکراری مسیر را باز می‌کند تا سیستم سریع fail و برای recovery probe کند. این دو با timeout و admission control ترکیب می‌شوند. مدار باز را با fallback بی‌هزینهٔ فرضی جایگزین نکن؛ fallback ممکن است خودش از همان dependency استفاده کند یا دادهٔ قدیمی خطرناک بدهد.

### Compensating Transaction و Saga

در یک workflow چندمرحله‌ای، هر مرحله ممکن است side effect پایدار داشته باشد. اگر ادامه fail شد، compensation یک action دامنه‌ای می‌سازد: آزادکردن رزرو، refund یا لغو ارسال. Compensation ممکن است fail یا دیر شود و همیشه عمل اصلی را دقیقاً برنمی‌گرداند. مراحل، correlation id، state machine، retry و صف دستی برای جبران شکست‌خورده را ثبت کن.

### Leader Election و fencing

انتخاب leader برای scheduler، partition owner یا writer واحد لازم است. Lease می‌تواند به علت network pause منقضی شود درحالی‌که leader قدیمی هنوز کار می‌کند. هر بار election یک fencing token بزرگ‌تر تولید کن و storage مقصد فقط token تازه‌تر را قبول کند. lock توزیع‌شده بدون expiry/ownership/recovery تضمین تک‌نویسنده نمی‌دهد.

### Health، Queue Leveling و Scheduler-Agent-Supervisor

Health endpoint آمادگی و liveness را ازهم جدا می‌کند. Queue-leveling burst را در ظرفیت محدودی نگه می‌دارد و نیازمند oldest age، backpressure و DLQ است. Scheduler-Agent-Supervisor زمان اجرا، worker و recovery کار طولانی را هماهنگ می‌کند؛ checkpoint و idempotency لازم‌اند تا restart نتیجهٔ تکراری نسازد.

### طرح resilience برای یک جریان

برای سفارش: API با deadline و idempotency key سفارش را ثبت می‌کند؛ outbox رویداد durable می‌سازد؛ worker با retry محدود payment provider را صدا می‌زند؛ breaker و bulkhead اثر کندی provider را محدود می‌کنند؛ status endpoint نتیجهٔ مبهم را نشان می‌دهد؛ reconciliation اختلاف ledger را پیدا می‌کند؛ compensation در شکست قطعی رزرو را آزاد می‌کند. هر مرحله metric و alert خودش را دارد.

### تمرین بازیابی

برای هر وابستگی مهم failure mode بنویس: slow, unavailable, partial response, duplicate, stale, full queue. سپس یک سناریو را به شکل tabletop یا failure injection کنترل‌شده اجرا کن؛ recovery واقعی را ثبت کن، نه فقط این‌که کد exception دارد. هدف، رفتار قابل پیش‌بینی و قابل بازگشت است.

## مرور همهٔ ریزموضوع‌های roadmap

- Bulkhead: ایزوله‌کردن منابع.
- Circuit Breaker: fail-fast در اختلال تکراری.
- Compensating Transaction: عمل دامنه‌ای برای جبران مرحلهٔ قبلی.
- Health Endpoint Monitoring: تصمیم readiness و بازیابی.
- Leader Election: انتخاب هماهنگ‌کننده با fencing.
- Queue-Based Load Leveling: جذب بار تا حد ظرفیت.
- Retry: تلاش دوبارهٔ محدود با backoff/jitter.
- Scheduler-Agent-Supervisor: زمان‌بندی و پایش کارهای طولانی.

## مثال عملی

رزرو موجودی انجام و پرداخت رد می‌شود؛ saga رزرو را آزاد می‌کند و اگر آزادسازی شکست خورد کار را برای پیگیری durable می‌فرستد.

## نمونهٔ قرارداد / شبه‌کد

~~~text
delay=min(cap, base*2^attempt)+random_jitter؛ پس از سقف تلاش، DLQ/رسیدگی.
~~~

## تجربهٔ موردی واقعی منتشرشده

[AWS Architecture Blog: exponential backoff و jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

retry برای خطای گذرا و عملیات امن؛ compensation برای workflow؛ leader انتخابی وقتی مالک نوشتن لازم است.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- retry storm؛ جبران غیرا idempotent؛ split-brain؛ recovery بی checkpoint؛ retry بی‌نهایت.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Jitter چرا لازم است؟
2. compensation با rollback تراکنشی چه فرقی دارد؟
3. fencing token از چه چیزی جلوگیری می‌کند؟

### پاسخ‌نامهٔ فشرده

1. زمان retryها را تصادفی می‌کند تا clientها هم‌زمان دوباره هجوم نیاورند.
2. جبران یک عمل کسب‌وکاری تازه مثل آزادکردن رزرو است؛ rollback دیتابیس بخشی از همان تراکنش را اتمیک برمی‌گرداند.
3. رهبر قدیمیِ دیررس با token قدیمی دیگر اجازهٔ نوشتن نمی‌گیرد.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

تاب‌آوری یعنی ادامهٔ کنترل‌شده یا بازیابی امن پس از خرابی جزئی؛ retry، جبران و انتخاب رهبر باید محدود و قابل مشاهده باشند. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [Saga و تراکنش توزیع‌شده](https://www.dntips.ir/post/3525)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure Architecture Center: Resiliency](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

