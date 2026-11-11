<div dir="rtl" align="right">
[English version](../../../../en/system-design/10-reliability-security/29-high-availability-patterns/README.md)


# High Availability Patterns

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

Availability با حذف نقطهٔ تک‌خرابی و جداسازی منابع بالا می‌رود؛ quorum، ظرفیت افزونه و تمرین بازیابی هم لازم‌اند.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Bulkhead poolها را جدا می‌کند تا یک dependency همهٔ connectionها را نبلعد. Circuit Breaker پس از خطاهای متوالی فراخوانی را متوقف و recovery را می‌آزماید. Health endpoint، Deployment Stamps و Geodes مرز سلامت و منطقه ایجاد می‌کنند. Breaker جای timeout و retry محدود نیست؛ حالت‌ها و metric باید آشکار باشند.

## درس گام‌به‌گام

### Bulkhead

در کشتی دیواره‌های جدا جلوی غرق‌شدن کل بخش‌ها را می‌گیرند؛ در سرویس، thread pool، semaphore، connection pool یا quota جدا همین کار را می‌کند. اگر partner API کند شد، فقط pool تماس با partner پر شود، نه pool checkout. Bulkhead ظرفیت کل را افزایش نمی‌دهد؛ سهمیه می‌گذارد تا یک dependency کل سیستم را نبلعد. اندازهٔ pool باید با ظرفیت downstream تنظیم شود و رد شدن درخواست با metric/response مناسب همراه باشد.

### Circuit Breaker

سه حالت متداول دارد: Closed درخواست را عبور می‌دهد و failure را می‌شمارد؛ Open سریع fail می‌کند؛ Half-open تعداد کمی probe می‌فرستد تا recovery را امتحان کند. threshold ثابت برای هر endpoint مناسب نیست؛ پنجرهٔ زمانی، درصد خطا، حداقل نمونه و نوع خطا را انتخاب کن. خطای validation کاربر نباید dependency را خراب فرض کند. Breaker نمی‌گوید درخواست fail شد یا side effect رخ داد؛ outcome مبهم همچنان idempotency لازم دارد.

### Health monitoring

Readiness ورودی ترافیک را کنترل می‌کند و liveness restart را؛ استفادهٔ اشتباه از آن‌ها می‌تواند همهٔ instanceها را هم‌زمان restart کند. Health endpoint سطح‌های محلی، dependency و end-to-end را تفکیک کند. یک dependency اختیاری ممکن است degraded mode داشته باشد و نباید کل سرویس را unready کند.

### Deployment Stamps و Geodes در HA

Stampها tenant/workload را جدا و blast radius را محدود می‌کنند؛ geodeها ظرفیت و route را در چند region پخش می‌کنند. Availability واقعی به ظرفیت failover، دادهٔ لازم در مقصد، identity/control-plane و DNS/LB وابسته است. Multi-region بدون تمرین promote و restore بیشتر پیچیدگی است تا قابلیت اطمینان.

### طراحی رفتار ترکیبی

برای call به payment provider: timeout کوتاه و deadline؛ retry محدود فقط برای failure مناسب؛ breaker پس از failureهای متوالی؛ pool اختصاصی برای bulkhead؛ SLI و trace برای مشاهده؛ status/ reconciliation برای outcome نامعلوم. retry را در client، gateway، SDK و worker هم‌زمان روشن نکن؛ تعداد callها ضرب می‌شود.

### چگونه انتخاب کنیم؟

اگر failure یک dependency می‌تواند threadهای کل سرویس را اشغال کند، bulkhead را بررسی کن. اگر dependency مدت‌دار خراب می‌ماند، breaker مانع تلاش بی‌فایده می‌شود. اگر نمونهٔ سالم از دید LB معلوم نیست، readiness/health مهم است. اگر قطعی منطقه‌ای در threat model است، stamp/geo و capacity بازیابی را تمرین کن. هر الگو بدون SLO و runbook کامل نیست.

## مرور همهٔ ریزموضوع‌های roadmap

- Deployment Stamps: failure domain مستقل.
- Geodes: چند ناحیه با سیاست داده/routing روشن.
- Bulkhead: جداسازی pool و ظرفیت.
- Health Endpoint Monitoring: تشخیص سلامت قابل‌استفاده.
- Circuit Breaker: قطع موقت فراخوانی ناموفق و probe کنترل‌شده.

## مثال عملی

گزارش‌گیری کند نباید thread pool پرداخت را پر کند؛ برای مسیرها pool و سقف جدا بگذار.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Netflix TechBlog](https://netflixtechblog.com/)

Bulkhead برای منابع مشترک؛ breaker برای dependency ناپایدار. خطای ورودی کاربر را با breaker مدیریت نکن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- breaker بدون timeout؛ retry هماهنگ‌نشده؛ probe زیاد در half-open؛ pool جدا بدون ظرفیت‌سنجی.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Bulkhead چه چیزی را ایزوله می‌کند؟
2. حالت‌های Circuit Breaker چیست؟
3. چرا retry باید با breaker هماهنگ شود؟

### پاسخ‌نامهٔ فشرده

1. connection/thread/worker pool مستقل می‌سازد تا یک dependency منابع کل سامانه را نبلعد.
2. Closed عبور می‌دهد، Open سریع رد می‌کند، Half-open تعداد کمی درخواست آزمایشی می‌فرستد.
3. retry باید timeout و سقف داشته باشد؛ breaker روی failure مکرر جلوی retryهای بی‌فایده را می‌گیرد.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

Availability با حذف نقطهٔ تک‌خرابی و جداسازی منابع بالا می‌رود؛ quorum، ظرفیت افزونه و تمرین بازیابی هم لازم‌اند. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [Saga و تراکنش توزیع‌شده](https://www.dntips.ir/post/3525)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure Architecture Center: Resiliency](https://learn.microsoft.com/en-us/azure/architecture/framework/resiliency/)
- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)
- [Netflix TechBlog](https://netflixtechblog.com/)

</div>

