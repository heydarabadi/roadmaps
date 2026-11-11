<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#09-monitoring-logging-and-tracing)

# موتورهای Observability

**فصل:** [Monitoring و Logging](../../README.md)

## ابزارها و جای هرکدام

Prometheus برای scrape و query metric، Grafana برای dashboard، Loki یا cloud logging برای log، Jaeger/Tempo برای trace و OpenTelemetry Collector برای دریافت و export نمونه‌های رایج‌اند. Kubernetes خود محصول کامل observability نیست. انتخاب را با حجم داده، نگهداری، حریم خصوصی، مهارت و هزینه بسنجید.

## معماری پایدار

1. instrumentation برنامه و labelهای قابل‌کنترل.
2. جمع‌آوری در node یا application agent.
3. buffer و انتقال قابل‌اعتماد به storage.
4. retention و دسترسی مبتنی بر نقش.
5. dashboard، alert و runbook که یک اقدام را هدایت کند.

Metrics Server برای resource metricهای لحظه‌ای و HPA مفید است؛ Prometheus یا سرویس مشابه history و query فراهم می‌کند. این محصولات نقش یکسان ندارند.

## عملیات

برای backend telemetry هم resource request، storage و backup لازم است. cardinality، ingest rate، retention و sampling هزینه را کنترل می‌کنند. alertها را دوره‌ای پاک‌سازی کنید و برای هر هشدار owner و روش اقدام بگذارید. داشبوردی که کسی هنگام رخداد به آن اعتماد ندارد، observability را کامل نکرده است.

## کوییز

1. OpenTelemetry چه می‌کند؟ — instrument/collect/transfer telemetry؛ لزوماً storage backend نیست.
2. Grafana چه نقشی دارد؟ — query و visualization، وابسته به data source.
3. چرا retention سیاست می‌خواهد؟ — داده، هزینه، privacy و نیاز audit را متعادل می‌کند.
4. چه چیزی metricهای تاریخی را می‌دهد؟ — backend/time-series pipeline، نه صرفاً Metrics Server.

## منابع

- [Observability Kubernetes](https://kubernetes.io/docs/concepts/cluster-administration/observability/)
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
- [Prometheus documentation](https://prometheus.io/docs/introduction/overview/)
- [EnginDevOps فارسی](https://enginedevops.com/)

</div>