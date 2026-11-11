<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/14-advanced-topics/topics/custom-schedulers/README.md) · [کتابخانهٔ منابع](../../../references/README.md#14-advanced-topics-and-extensibility)

# Custom Scheduler و Scheduling Framework

**فصل:** [موضوعات پیشرفته](../../README.md)

## ابتدا نیاز را ثابت کنید

بیشتر placement با request، node affinity، taints/tolerations، topology spread و PriorityClass انجام می‌شود. پیش از ساخت scheduler جدید، این ابزارها را مدل کنید. scheduler سفارشی یعنی تیم شما باید سازگاری نسخه، policy، leader, telemetry و failure آن را اداره کند.

Scheduling Framework برای افزودن plugin به مراحل scheduling طراحی شده است؛ plugin می‌تواند node را فیلتر یا رتبه‌بندی کند. extender webhook نیز در مستند رسمی محدودیت دارد و فقط filter/priority را تغییر می‌دهد. ساخت scheduler جدا ممکن است رفتار scheduling و تعارض چند scheduler را پیچیده کند.

## مثال

فرض کنید Pod باید روی node دارای accelerator خاص با حداقل حافظهٔ محلی قرار گیرد. ابتدا resource/device plugin، node label و affinity را بررسی کنید. اگر constraint با APIهای موجود بیان‌پذیر است، scheduler جدید فقط هزینه می‌افزاید. اگر policy پیچیده و پایدار واقعاً لازم است، plugin محدود و قابل‌اندازه‌گیری طراحی کنید.

## کوییز

1. اولین گزینه برای placement خاص چیست؟ — APIهای موجود مانند affinity، taint و topology.
2. plugin framework چه مزیتی نسبت به fork scheduler دارد؟ — extension point رسمی با نگهداری سازگارتر.
3. scheduler extender طبق مستند چه محدوده‌ای دارد؟ — filtering و prioritization node.
4. چه چیزی برای تولید لازم است؟ — HA، metrics، failure fallback و آزمون upgrade.

## منابع

- [Scheduling Framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)
- [Extending Kubernetes: Scheduling](https://kubernetes.io/docs/concepts/extend-kubernetes/)
- [Scheduler Configuration](https://kubernetes.io/docs/reference/scheduling/config/)

</div>