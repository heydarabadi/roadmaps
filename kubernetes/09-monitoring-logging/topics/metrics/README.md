<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#09-monitoring-logging-and-tracing)

# Metrics

**فصل:** [Monitoring و Logging](../../README.md)

## نوع metric و کاربرد

Counter فقط افزایش می‌یابد و برای محاسبهٔ rate درخواست/خطا مفید است. Gauge می‌تواند بالا و پایین برود، مانند تعداد اتصال فعال. Histogram توزیع latency یا اندازه را در bucketها ثبت می‌کند. برای HTTP service، نرخ درخواست، نرخ خطا، latency صدکی و saturation نقطهٔ شروع‌اند.

~~~text
RPS = تعداد درخواست‌های جدید در بازهٔ زمانی
Error rate = پاسخ‌های ناموفق / کل پاسخ‌ها
Latency = زمان پاسخ با توزیع و percentile
Saturation = نزدیک‌شدن منبع گلوگاهی به ظرفیت
~~~

Prometheus-style labels امکان تفکیک نسخه یا سرویس را می‌دهند، اما label با مقدار پرتنوع مثل user ID cardinality را منفجر می‌کند. برچسب‌ها را محدود و معنادار نگه دارید.

## از metric تا alert

Metrics Server metric لحظه‌ای CPU/memory را برای ابزارهایی مانند top یا HPA فراهم می‌کند. برای تاریخچه، query، alert و داشبورد به پایپ‌لاین metrics پایدار نیاز دارید. Alert را براساس مدت و آستانه تنظیم کنید؛ alert کوتاه و بی‌اثر موجب خستگی on-call می‌شود.

## تمرین

یک داشبورد آزمایشی برای نرخ خطا و latency بسازید. نسخهٔ جدید را با خطای کنترل‌شده deploy کنید و تعیین کنید چه آستانه و مدت زمانی باید alert بدهد. metric را با log و event همان زمان مقایسه کنید.

## کوییز

1. Counter و Gauge چه تفاوتی دارند؟ — counter افزایش یکنواخت؛ gauge مقدار بالا/پایین‌شونده.
2. چرا histogram برای latency بهتر از average است؟ — tail و توزیع را آشکار می‌کند.
3. cardinality بالا چه می‌کند؟ — حافظه و هزینهٔ پایگاه metric را زیاد می‌کند.
4. Metrics Server چه چیزی نیست؟ — سامانهٔ تاریخچه و observability کامل.

## منابع

- [Resource Metrics Pipeline رسمی](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [Metrics API](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [OpenTelemetry Metrics](https://opentelemetry.io/docs/specs/otel/metrics/)
- [Prometheus concepts](https://prometheus.io/docs/concepts/)

</div>