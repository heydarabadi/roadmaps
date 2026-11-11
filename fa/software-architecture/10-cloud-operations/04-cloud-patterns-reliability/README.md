<div dir="rtl" align="right">

# الگوهای ابری، قابلیت اطمینان و مشاهده‌پذیری

الگوهایی مانند retry با backoff، circuit breaker، bulkhead، queue-based load leveling، cache-aside، health endpoint، deployment stamps و strangler fig به مسئله‌های شناخته‌شده پاسخ می‌دهند. هر pattern فرض‌ها و failure mode دارد؛ افزودن circuit breaker اگر timeout و recovery نامعلوم باشد می‌تواند خطا را فقط پیچیده‌تر کند.

Reliability با هدف سطح خدمت تعریف می‌شود: SLI دادهٔ سنجش است، SLO هدف تیم و SLA توافق بیرونی است. error budget نرخ مجاز نقض SLO را برای تصمیم release و کار reliability به زبان مشترک تبدیل می‌کند. Observability با metrics، logs و traces کمک می‌کند علت رفتار ناشناخته را بفهمیم؛ dashboard به‌تنهایی مشاهده‌پذیری نیست.

## مثال صنعتی

Google SRE به‌جای تعقیب «صددرصد uptime»، SLO و error budget را برای توازن سرعت تغییر و پایداری به‌کار می‌گیرد. این رویه نشان می‌دهد reliability بخشی از تصمیم محصول و انتشار است؛ عدد SLO باید از تجربهٔ مشتری و هزینه بیاید.

## طراحی SLI و SLO برای checkout

۱. **خدمت را از دید کاربر تعریف کن:** تلاش معتبر checkout از آغاز تا پاسخ نهایی.
۲. **SLI انتخاب کن:** نسبت checkoutهای موفق و latency صدک ۹۵ یا ۹۹ در پنجرهٔ زمانی؛ خطای client قابل‌اصلاح را از server failure جدا کن.
۳. **SLO واقع‌گرایانه تعیین کن:** هدف بر مبنای انتظار مشتری، هزینهٔ خرابی و توان عملیاتی باشد؛ 100% هدف معمولاً بودجهٔ تغییر و بازیابی را حذف می‌کند.
۴. **error budget مصرف را پیگیری کن:** نقض SLO اقدام reliability می‌خواهد؛ در budget سالم می‌توان سرعت تغییر را حفظ کرد.
۵. **alert بر اثر مشتری باشد:** paging فقط برای مشکلی که نیاز به اقدام فوری دارد؛ trend کندتر ticket یا dashboard می‌خواهد.

## الگوها و مرز استفاده

Retry با exponential backoff و jitter برای خطای موقت است، نه خطای validation. Circuit breaker تماس را پس از شکست متوقف می‌کند؛ recovery probe و half-open لازم است. Bulkhead منابع را میان وابستگی‌ها جدا می‌کند. Queue-based leveling burst را جذب می‌کند، اما lag و timeout کسب‌وکار را تغییر می‌دهد. Cache-aside دادهٔ stale و invalidation می‌آورد. هر pattern باید timeout، owner، metric و failure mode داشته باشد.

## مشاهده‌پذیری و incident

Metric روند و نرخ را می‌دهد، log رخداد و زمینهٔ جزئی را، trace مسیر یک درخواست را میان سرویس‌ها نشان می‌دهد. correlation ID را منتقل کن و secret/PII را حذف کن. dashboard باید latency، traffic، errors و saturation را به مسیر کسب‌وکار وصل کند. runbook برای alert، owner، تشخیص، rollback و escalation داشته باش.

تمرین incident مسیر تصمیم را پیش از خرابی می‌سنجد: چه کسی فرماندهی می‌کند؟ چه چیزی کاربر را محافظت می‌کند؟ feature را خاموش می‌کنیم، بار را محدود می‌کنیم یا failover؟ پس از incident، action item باید owner و موعد داشته باشد.

## fallback را دقیق تعریف کن

وقتی توصیهٔ کالا از دسترس خارج است، نمایش کاتالوگ بدون توصیه شاید درست باشد. وقتی وضعیت پرداخت نامعلوم است، نمایش «سفارش کامل شد» fallback امن نیست. fallback را با invariant دامنه بسنج، نه صرفاً جلوگیری از خطای صفحه.

## آزمون

۱. Circuit breaker چه زمانی باز می‌شود؟ **پاسخ:** پس از failureهای تعریف‌شده، تماس را موقتاً قطع می‌کند تا وابستگی recovery کند.
۲. SLI و SLO چه تفاوتی دارند؟ **پاسخ:** SLI اندازه‌گیری است؛ SLO هدف برای آن اندازه‌گیری.
۳. چرا retry باید backoff داشته باشد؟ **پاسخ:** بار هم‌زمان درخواست‌های مجدد را کم می‌کند.
۴. log، metric و trace چه تفاوتی دارند؟ **پاسخ:** رویداد جزئی، روند عددی و مسیر درخواست در اجزای متعدد را نشان می‌دهند.

## تمرین

برای checkout یک SLI/SLO با پنجره، خطای مجاز، alert و رفتار release تعریف کن؛ سپس یک failure را با trace و log دنبال کن.

## پاسخ نمونهٔ تمرین

SLI: نسبت checkout موفق و latency صدک ۹۵ در پنجرهٔ دقیقه‌ای/روزانه، با تعریف denominator و خطای client. SLO بر مبنای انتظار مشتری تعیین می‌شود و error budget سیاست release را هدایت می‌کند. برای failure یک trace correlation ID را از edge تا payment دنبال می‌کند؛ log ساختاریافته وضعیت dependency را می‌دهد؛ alert روی burn rate/اثر مشتری paging می‌کند.

## منابع

- فارسی: [DevDocs: پایداری، CI/CD و observability](https://devdocs.ir/)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [Google SRE: SLOs](https://sre.google/sre-book/service-level-objectives/)، [AWS Cloud Design Patterns](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/introduction.html)، [Google Cloud Well-Architected](https://docs.cloud.google.com/architecture/framework)

</div>
