<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#09-monitoring-logging-and-tracing)

# Distributed Tracing

**فصل:** [Monitoring و Logging](../../README.md)

## Span و Trace

Trace زنجیره‌ای از spanهاست که یک درخواست را در چند سرویس دنبال می‌کند. هر span زمان، عملیات، parent و attribute دارد. context propagation باید از gateway تا backend، queue و سرویس بیرونی ادامه یابد. اگر trace ID منتقل نشود، مشاهده‌ها به trace جدا شکسته می‌شوند.

~~~
درخواست checkout
  ├── API: 40ms
  ├── inventory: 12ms
  └── payment: 870ms
~~~

در مثال، trace نشان می‌دهد کندی بیشتر از payment آمده؛ افزایش CPU API احتمالاً علت نیست. Sampling برای کنترل هزینه لازم است: نرخ ثابت همهٔ درخواست‌ها را نمی‌گیرد و tail-based sampling می‌تواند traceهای خطادار را حفظ کند، اما به collector و منابع مناسب نیاز دارد.

## OpenTelemetry

OpenTelemetry ابزار و پروتکل instrumentation برای تولید و انتقال telemetry است؛ به‌تنهایی backend جست‌وجو نیست. Collector می‌تواند دریافت، پردازش و export را انجام دهد. attributeها را محدود و بدون secret یا اطلاعات شخصی طراحی کنید.

## کوییز

1. Span چیست؟ — بازه/عملیات مشخص درون trace.
2. چرا context propagation لازم است؟ — parent-child رابطهٔ سرویس‌های مختلف را حفظ می‌کند.
3. trace کند چه چیزی را پیدا می‌کند؟ — span و dependency bottleneck در مسیر درخواست.
4. Sampling چرا استفاده می‌شود؟ — حجم و هزینهٔ telemetry را کنترل می‌کند.

## منابع

- [OpenTelemetry Traces](https://opentelemetry.io/docs/concepts/signals/traces/)
- [OpenTelemetry Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/)
- [Context Propagation](https://opentelemetry.io/docs/concepts/context-propagation/)

</div>