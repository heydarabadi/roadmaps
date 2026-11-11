<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/09-monitoring-logging/topics/resource-health/README.md) · [کتابخانهٔ منابع](../../../references/README.md#09-monitoring-logging-and-tracing)

# سلامت Pod و منابع کلاستر

**فصل:** [Monitoring و Logging](../../README.md)

## Probes و معنی آن‌ها

Startup probe فرصت راه‌اندازی طولانی را می‌دهد. تا موفق نشود، liveness و readiness اجرا نمی‌شوند. Liveness شکست فرایند گیرکرده را می‌تواند با restart درمان کند. Readiness شکست را به معنی ناآمادگی برای traffic می‌گیرد و endpoint سرویس را تغییر می‌دهد. هر endpoint باید همین معنی را داشته باشد؛ probe وابسته به database اگر database قطع است، ممکن است کل برنامه را بی‌جهت restart کند.

~~~yaml
startupProbe:
  httpGet:
    path: /startup
    port: 8080
  failureThreshold: 30
  periodSeconds: 5
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  periodSeconds: 5
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  periodSeconds: 10
~~~

## دید کلاستر

Conditionهای node، restart، Pending، eviction، quota، error rate و saturation را با سلامت user-facing کنار هم ببینید. Event موقتی و با retention محدود است؛ برای رخدادهای مهم باید alert و timeline داشته باشید. PDB روی برخی disruption داوطلبانه اثر می‌گذارد اما node crash را منع نمی‌کند.

## کوییز

1. Readiness failure چه اثری دارد؟ — Pod از endpoint آماده خارج می‌شود.
2. Liveness failure چه می‌کند؟ — kubelet می‌تواند container را restart کند.
3. چرا endpoint health را به وابستگی remote وصل نکنیم؟ — قطعی dependency می‌تواند همهٔ Podها را هم‌زمان restart کند.
4. Running بودن Pod سلامت کاربر را ثابت می‌کند؟ — نه؛ probe، Service و درخواست واقعی را بررسی کنید.

## منابع

- [Liveness، Readiness و Startup Probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
- [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Node Conditions](https://kubernetes.io/docs/concepts/architecture/nodes/)

</div>