<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/07-resource-management/topics/optimize/README.md) · [کتابخانهٔ منابع](../../../references/README.md#07-resource-management)

# پایش و بهینه‌سازی منابع

**فصل:** [مدیریت منابع](../../README.md)

## از اندازه‌گیری تا تنظیم

رفتار برنامه در startup، بار معمول، peak و خرابی dependency متفاوت است. CPU، memory، restart، OOM، throttling، latency و saturation را در طول زمان ببینید. اگر فقط CPU را پایش کنید، مشکل شبکه یا storage را اشتباه resource bottleneck تشخیص می‌دهید.

## روال بهینه‌سازی

1. SLO و بار مورد انتظار را مشخص کنید.
2. baseline و peak را با بار معتبر اندازه بگیرید.
3. usage را کنار request/limit و تعداد replica ببینید.
4. یک مقدار را تغییر دهید و latency و ظرفیت را دوباره بسنجید.
5. نمودار، alert و runbook را به‌روز کنید.

فرمان top snapshot است، نه سامانهٔ تاریخچه. برای روند بلندمدت metrics pipeline و داشبورد لازم است. افزایش limit برای پنهان‌کردن memory leak راه‌حل نیست؛ restart مکرر یا نمودار رشد حافظه را تا علت دنبال کنید.

## مثال

API بیشتر روز CPU کمی دارد اما در peak پاسخ صدکی بالا و throttling دارد. هم‌زمان concurrency، تعداد replica، CPU request/limit و HPA را بررسی کنید. اگر حافظه آرام‌آرام رشد می‌کند، heap، cache و تعداد درخواست‌های فعال را کنار metric container ببینید.

## کوییز

1. برای tuning چه چیزهایی را کنار هم تحلیل می‌کنید؟ — usage، latency، restart/throttling، SLO و ظرفیت.
2. چرا average به‌تنهایی کافی نیست؟ — peak و دوره‌های نوسان را پنهان می‌کند.
3. چه زمانی افزایش limit اشتباه است؟ — وقتی نشتی یا الگوریتم نامناسب علت رشد حافظه است.
4. چرا تغییر تدریجی بهتر است؟ — علت و اثر روشن‌تر و rollback آسان‌تر است.

## منابع

- [Resource Metrics Pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [مفاهیم Observability](https://kubernetes.io/docs/concepts/cluster-administration/observability/)

</div>