<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/09-monitoring-logging/README.md) · [کتابخانهٔ منابع](../references/README.md#09-monitoring-logging-and-tracing)

# فصل 09: Monitoring، Logging و Observability

## هدف‌های فصل

- لاگ، metric و trace را از هم تفکیک و به هم مرتبط کنید.
- سلامت Pod، node و سرویس را از دید اجرای برنامه و کاربر بسنجید.
- telemetry را جمع‌آوری، ذخیره، جست‌وجو و به alert قابل‌اقدام تبدیل کنید.
- برای production سؤال عملیاتی تعریف کنید؛ صرف نصب dashboard کافی نیست.

## سه ستون داده

- **Logs:** رخدادهای منفرد و جزئیات خطا؛ مثلاً چرا پرداخت 500 شد.
- **Metrics:** اندازه‌گیری عددی در طول زمان؛ مثلاً نرخ خطا، latency و اشباع.
- **Traces:** مسیر یک درخواست میان سرویس‌ها؛ برای پیدا کردن span کند و مرز شکست.

هر نوع داده سؤال متفاوتی را جواب می‌دهد. trace به log و metric context می‌دهد؛ request ID و trace ID را در برنامه propagate کنید. دادهٔ telemetry می‌تواند حساس باشد؛ secret و اطلاعات شناسایی را حذف یا محدود کنید.

## از health تا SLO

Readiness تعیین می‌کند Pod endpoint قابل‌استفاده باشد. Liveness برنامهٔ گیرکرده را می‌تواند restart کند. Startup برای برنامه‌هایی با آغاز طولانی است تا liveness زود فعال نشود. Node condition، restart count، pending، eviction و saturation را نیز ببینید. این conditionها به‌تنهایی تجربهٔ کاربر را ثابت نمی‌کنند.

SLO هدفی برای رفتار خدمت است؛ alert را تا حد امکان به user impact و بودجهٔ خطا وصل کنید. هشدار روی CPU بالای کوتاه‌مدت ممکن است noisy باشد؛ هشدار روی خطای مداوم و latency کاربر معمولاً actionableتر است.

## جریان telemetry

~~~text
Application / kubelet / node
→ agents و exporters
→ collector یا storage
→ query و dashboard
→ alert
→ runbook و اقدام
~~~

Kubernetes همهٔ log و metric تاریخی برنامه را به‌صورت کامل نگه نمی‌دارد. retention، sampling، cardinality، دسترسی و هزینه را از ابتدا طراحی کنید. Metrics Server برای برخی metricهای لحظه‌ای و autoscaling کاربرد دارد؛ جایگزین سامانهٔ تاریخچهٔ جامع نیست.

## عیب‌یابی با هم‌بستگی

در لحظهٔ خطا بازهٔ زمانی را از alert بگیرید، metric خطا را ببینید، trace کند را پیدا کنید، سپس log همان request را جست‌وجو کنید. بعد event rollout و وضعیت Pod را با زمان رخداد تطبیق دهید. clock sync، برچسب محیط/نسخه و correlation ID اهمیت دارند.

## تجربهٔ عملی

در استقرار checkout، نرخ خطای API ممکن است طبیعی به نظر برسد، اما trace نشان دهد همهٔ کندی از یک سرویس پرداخت بیرونی آمده است. اگر فقط metric کلاستر را ببینید، ممکن است node اضافه کنید و هزینه بالا ببرید بدون اینکه علت را رفع کنید. dashboard باید هم سلامت برنامه و هم dependencyها را نشان دهد.

## کوییز

1. برای علت یک درخواست خاص کدام داده مناسب‌تر است؟ — Trace همراه log هم‌بسته.
2. برای روند نرخ خطا در یک ساعت؟ — Metric counter/rate.
3. چرا log Pod کافی نیست؟ — Pod ممکن است حذف شود و log محلی retention متمرکز ندارد.
4. liveness و readiness یکسان‌اند؟ — خیر؛ restart و ورود به ترافیک دو هدف مختلف‌اند.
5. Alert خوب چه ویژگی دارد؟ — user impact را نشان می‌دهد و اقدام/runbook روشن دارد.

## منابع

- [Observability مفاهیم رسمی](https://kubernetes.io/docs/concepts/cluster-administration/observability/)
- [Logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
- [Probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
- [OpenTelemetry Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/)
- [منبع فارسی EnginDevOps](https://enginedevops.com/)

</div>