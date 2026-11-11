<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#09-monitoring-logging-and-tracing)

# Logs

**فصل:** [Monitoring و Logging](../../README.md)

## چه چیزی را log کنیم؟

لاگ رخدادهای گسسته را شرح می‌دهد. برنامه‌ها بهتر است به stdout/stderr خروجی ساخت‌یافته بدهند تا agent روی node بتواند آن را جمع کند. هر رخداد با timestamp، severity، service، version و request/trace ID قابل‌جست‌وجو شود. لاگ را برای debugging و audit هدفمند نگه دارید، نه اینکه همهٔ متغیرها را چاپ کنید.

~~~sh
kubectl logs deployment/api --since=10m
kubectl logs pod/api-abc -c server
kubectl logs pod/api-abc --previous
~~~

این فرمان‌ها برای بررسی کوتاه مفیدند؛ در production به جمع‌آوری متمرکز، retention، کنترل دسترسی، redaction و ظرفیت ذخیره نیاز است. container restart شده باشد، previous log ممکن است سرنخ آخر را داشته باشد.

## ساختار و حریم خصوصی

Structured JSON جست‌وجوی خطا و فیلتر را آسان می‌کند. token، password، cookie، payload حساس و دادهٔ شخصی را log نکنید. حجم log را محدود کنید؛ stack trace تکراری می‌تواند storage و هزینه را افزایش دهد. sampling را برای رخدادهای بسیار پرتکرار آگاهانه طراحی کنید و errorهای مهم را حذف نکنید.

## جریان جمع‌آوری

معمولاً agent روی node log container را جمع می‌کند و به backend مانند Loki یا cloud logging می‌فرستد. هنگام از دست‌رفتن log، بررسی کنید process خروجی را به stdout/stderr می‌دهد، agent سالم است، disk پر نیست و parser فیلدها را خراب نکرده است. log لزوماً archive بی‌نهایت نیست؛ retention و audit requirement را مشخص کنید.

## کوییز

1. چرا stdout/stderr الگوی مناسبی برای container است؟ — runtime و agent می‌توانند خروجی را جمع‌آوری کنند، بدون فایل log اختصاصی در Pod.
2. چه چیزی را نباید log کرد؟ — credential و دادهٔ حساس غیرضروری.
3. چرا previous log مفید است؟ — خروجی container پیش از restart را نشان می‌دهد.
4. برای production چه چیزی اضافه می‌کنیم؟ — aggregation، retention، access control، alert و redaction.

## منابع

- [Logging معماری Kubernetes](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
- [kubectl logs](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_logs/)
- [OpenTelemetry Logs](https://opentelemetry.io/docs/specs/otel/logs/)
- [منبع فارسی EnginDevOps](https://enginedevops.com/)

</div>