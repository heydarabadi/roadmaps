<div dir="rtl" align="right">
[English version](../../en/08-observability/24-monitoring/README.md)


# Monitoring، Instrumentation و SLO

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

مانیتورینگ باید سلامت کاربر را نشان دهد؛ metrics، logs و traces پرسش‌های متفاوت و مکمل دارند.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Health برای readiness/liveness است؛ availability/performance را با SLI/SLO اندازه بگیر؛ usage و security نیز audit می‌خواهند. correlation id مسیر سرویس‌ها را به هم وصل می‌کند. metric cardinality را کنترل کن و alert را بر symptom یا error budget بساز. Dashboard باید مالک، runbook و تصمیم بعدی داشته باشد.

## درس گام‌به‌گام

### Monitoring و observability

Monitoring نمودارها و alertهای ازپیش‌تعریف‌شده را برای پرسش‌های معلوم فراهم می‌کند. Observability از telemetry کمک می‌گیرد تا پرسش‌های تازه دربارهٔ رفتار داخل سیستم پاسخ داده شود. Metrics معمولاً شمارنده/زمان/توزیع عددی‌اند؛ logs رویدادهای جزئی؛ traces رابطه و زمان spanها بین سرویس‌ها را نشان می‌دهند. هیچ signal به‌تنهایی کافی نیست: metric کاهش موفقیت را می‌بیند، trace dependency کند را پیدا می‌کند، log خطای خاص را شرح می‌دهد.

### چهار سیگنال طلایی و USE

برای سرویس درخواست‌محور، چهار سیگنال Google SRE عبارت‌اند از latency، traffic، errors و saturation. latency را موفق و ناموفق جدا ببین؛ timeout نباید از نمونه حذف شود. Traffic نرخ درخواست یا job را می‌سنجد. Errors خطاهای صریح/ضمنی‌اند. Saturation نشان می‌دهد منبعی مثل CPU، queue، disk یا connection pool چقدر پر است. روش USE برای هر resource می‌پرسد utilization، saturation و errors چیست.

### SLI، SLO و alert

SLI تعریف دقیق اندازه‌گیری است: مثلاً درخواست معتبر checkout که با پاسخ موفق و زیر یک deadline پایان یافته تقسیم بر کل درخواست‌های معتبر. SLO هدف و بازه را مشخص می‌کند. Alert باید نشان دهد کاربر تحت تأثیر است یا error budget با سرعت خطرناک مصرف می‌شود. هشدار صرفاً CPU بالا ممکن است noise باشد؛ CPU اشباع همراه افزایش latency/خطا اقدام‌پذیرتر است. برای هر alert owner، runbook و سطح urgency تعیین کن.

### هفت دستهٔ Monitoring در roadmap

- Health monitoring: liveness، readiness و وضعیت dependency لازم؛ probe نباید خرابی مشترک بسازد.
- Availability monitoring: موفقیت درخواست در زمان/منطقه و رعایت SLO.
- Performance monitoring: latency percentiles، throughput، queue و saturation.
- Security monitoring: ورود ناموفق، تغییر privilege، policy violation و رخداد audit.
- Usage monitoring: مصرف feature و الگوی بار برای ظرفیت/محصول؛ دادهٔ شخصی را بی‌نیاز جمع نکن.
- Instrumentation: ایجاد metric/log/trace، context propagation و correlation id.
- Visualization & alerts: نمودار خوانا، threshold معنادار، مالک و دستور واکنش.

### Instrumentation درست

برای trace از trace/span id استفاده کن تا درخواست میان serviceها قابل دنبال‌کردن باشد؛ headerها را با کنترل اعتماد منتقل کن. Metric label با user id یا URL دلخواه cardinality را منفجر می‌کند؛ از labelهای محدود مانند route template، status class و region استفاده کن. Log باید timestamp، severity، service/version و context داشته باشد ولی token، password و اطلاعات حساس را حذف/ماسک کند. ساعت سیستم‌ها را sync و retention را تعیین کن.

### Dashboard و visualization

Dashboard پاسخ یک سؤال عملیاتی بدهد: آیا کاربر موفق است؟ کدام مسیر کند است؟ کدام dependency خراب است؟ نمودارها باید واحد، بازه، percentile و annotation انتشار داشته باشند. dashboard عمومی با صدها metric کمک نمی‌کند. نماهای service overview، dependency، capacity و incident detail جدا باشند. alert باید روی همان نمودارها قابل بررسی باشد.

### امنیت و حریم خصوصی telemetry

Telemetry ممکن است دادهٔ مشتری، شناسهٔ session یا payload داشته باشد. جمع‌آوری حداقلی، redaction در مرز، دسترسی نقش‌محور، encryption، retention و audit لازم است. sampling در trace هزینه را کم می‌کند، ولی خطاهای نادر را حذف نکند؛ tail-based sampling می‌تواند traceهای کند/ناموفق را نگه دارد. برای امنیت، alert باید به incident workflow امن و قابل ممیزی متصل باشد.

### از مشاهده تا اقدام

هر هشدار پاسخ دهد چه اتفاقی افتاده، چه کسی را متأثر می‌کند، از چه زمانی، مالک اقدام کیست و گام امن بعدی چیست. برای incident، timeline و trace نمونه ثبت کن، mitigation را جدا از root-cause fix نگه‌دار و پس از رفع، SLO و alert را براساس یادگیری بازبینی کن.

## مرور همهٔ ریزموضوع‌های roadmap

- Health: liveness/readiness و سلامت وابستگی‌های لازم.
- Availability: نسبت عملیات قابل‌استفاده در بازه و SLO.
- Performance: latency، throughput، saturation و tail.
- Security: auth failure، policy violation و رویدادهای مشکوک.
- Usage: تعداد/الگوی قابلیت‌های واقعی برای ظرفیت و محصول.
- Instrumentation: تولید metric، log و trace با شناسهٔ هم‌بستگی.
- Visualization & Alerts: نمودار/هشدار اقدام‌پذیر، مالک و runbook.

## مثال عملی

در شکست checkout، trace باید زمان API، inventory، payment و broker را جدا کند تا علت پیدا شود.

## نمونهٔ قرارداد / شبه‌کد

~~~text
SLO نمونهٔ آموزشی: 99.9% checkout موفق و p95 زیر 800ms طی 30 روز؛ عدد واقعی باید از نیاز محصول بیاید.
~~~

## تجربهٔ موردی واقعی منتشرشده

[Uber Engineering: telemetry، داشبورد و واکنش به metric](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Netflix TechBlog](https://netflixtechblog.com/)

Metrics روند و alert؛ logs جزئیات؛ traces مسیر توزیع‌شده. OpenTelemetry انتقال بین vendorها را ساده می‌کند؛ PII را redact کن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- alert روی هر نوسان؛ dashboard بی‌مالک؛ cardinality بالا؛ log کردن token؛ readiness=liveness.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. سه telemetry signal چه چیزی را پاسخ می‌دهند؟
2. چرا error budget alert کاربردی است؟
3. readiness و liveness چه تفاوتی دارند؟

### پاسخ‌نامهٔ فشرده

1. metrics روند/شمارش، logs شرح رخداد، traces سفر یک درخواست بین سرویس‌ها را نشان می‌دهند.
2. به‌جای مشکل داخلی بی‌اثر، مصرف سریع budget یعنی کیفیت تجربهٔ کاربر در حال نقض است.
3. readiness یعنی اجازهٔ گرفتن ترافیک؛ liveness یعنی process گیر کرده و باید restart شود.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

مانیتورینگ باید سلامت کاربر را نشان دهد؛ metrics، logs و traces پرسش‌های متفاوت و مکمل دارند. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [معماری وب و اجزای یک سامانه](https://virgool.io/Quera-Mag/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%88%D8%A8-%D8%A2%D8%B4%D9%86%D8%A7%DB%8C%DB%8C-%D9%85%D9%81%D8%A7%D9%87%DB%8C%D9%85-%D9%BE%D8%A7%DB%8C%D9%87-ofbcud4oao0c)

### منابع انگلیسی و تجربه‌های مهندسی

- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)
- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/)
- [Netflix TechBlog](https://netflixtechblog.com/)

</div>

