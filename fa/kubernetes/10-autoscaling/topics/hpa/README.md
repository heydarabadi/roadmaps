<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/10-autoscaling/topics/hpa/README.md) · [کتابخانهٔ منابع](../../../references/README.md#10-autoscaling)

# Horizontal Pod Autoscaler

**فصل:** [Autoscaling](../../README.md)

## حلقهٔ کنترل HPA

HPA metric هدف را دوره‌ای می‌خواند و تعداد replica را برای رسیدن به target تغییر می‌دهد. اگر CPU utilization هدف باشد، requestهای CPU مبنای درصدند. HPA تنها وقتی عمل می‌کند که metrics API حاضر، workload قابل‌مقیاس و metric به‌روز باشد.

~~~yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 60
~~~

برای custom metric باید API/adapter و واحد metric درست باشد. در production رفتار scale up/down و stabilization را هم تنظیم و با بار آزمایش کنید.

## دام‌ها

- request تعریف نشده یا غیرواقعی است.
- metric stale یا unavailable است.
- برنامه bottleneck CPU نیست؛ replica بیشتر مشکل DB را بدتر می‌کند.
- startup طولانی است و HPA دیر اثر می‌گذارد.
- scale-down زودهنگام نوسان می‌سازد.
- maxReplicas از ظرفیت یا بودجه بیشتر است.

## کوییز

1. HPA روی چه چیزی اثر می‌گذارد؟ — replica count هدف.
2. CPU utilization از چه چیزی درصد می‌شود؟ — CPU request.
3. replica بالا می‌رود ولی Pod Pending است؛ چه چیزی کم است؟ — ظرفیت node یا constraint مناسب.
4. آیا metric بیشتر همیشه راه‌حل است؟ — خیر؛ bottleneck و اثر بر dependency را تشخیص دهید.

## منابع

- [HPA رسمی Kubernetes](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Autoscaling concepts](https://kubernetes.io/docs/concepts/workloads/autoscaling/)
- [Metrics pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [EasyEnv فارسی](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>