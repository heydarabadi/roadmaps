<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/07-resource-management/topics/requests-limits/README.md) · [کتابخانهٔ منابع](../../../references/README.md#07-resource-management)

# Resource Requests و Limits

**فصل:** [مدیریت منابع](../../README.md)

## CPU در برابر حافظه

Request مقدار منبع موردنیاز برای زمان‌بندی است. مجموع requestها در ظرفیت قابل‌زمان‌بندی node سنجیده می‌شود؛ مصرف بالاتر لحظه‌ای می‌تواند رقابت بسازد. Limit سقف container است: CPU معمولاً throttle می‌شود، درحالی‌که عبور حافظه از limit می‌تواند OOM kill ایجاد کند.

~~~yaml
resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: "1"
    memory: 512Mi
~~~

200m یعنی 0.2 CPU منطقی. Mi مقدار binary است. مقدارهای مثال را کپی production نکنید؛ با اندازه‌گیری سرویس خود تنظیم کنید.

## تنظیم عملی

- startup و peak را جدا از مصرف متوسط ببینید.
- memory request را با رشد cache و heap بسنجید.
- CPU limit تنگ ممکن است tail latency را بدتر کند.
- ظرفیت allocatable node را در نظر بگیرید.
- ephemeral storage و حجم log را نیز پایش کنید.

## نشانه‌های خطا

Pod Pending با پیام Insufficient CPU/memory به request، ظرفیت و قید زمان‌بندی اشاره می‌کند. OOMKilled را در وضعیت container و eventها ببینید. CPU throttling ممکن است بدون restart، پاسخ را کند کند. log به‌تنهایی کافی نیست؛ metric و latency را کنار هم بگذارید.

## کوییز تشریحی

1. Request و limit چه تفاوتی دارند؟ — اولی در scheduling و محاسبهٔ ظرفیت مؤثر است؛ دومی سقف مصرف را اعمال می‌کند.
2. چرا CPU request و limit می‌توانند متفاوت باشند؟ — request برای رزرو/جایابی است؛ limit رفتار سقف را کنترل می‌کند.
3. OOMKilled را کجا می‌یابید؟ — last state و eventهای Pod.
4. چرا نمونهٔ یک‌باره برای تعیین request کافی نیست؟ — peak، دوره‌های بار و رفتار startup را نشان نمی‌دهد.

## منابع

- [مدیریت منابع رسمی](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [QoS Pod](https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/)
- [رزرو منابع Node](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/)

</div>