<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/14-advanced-topics/topics/custom-controllers/README.md) · [کتابخانهٔ منابع](../../../references/README.md#14-advanced-topics-and-extensibility)

# ساخت Custom Controller

**فصل:** [موضوعات پیشرفته](../../README.md)

## حلقهٔ reconcile

Controller clientای از Kubernetes API است. شیءهای مرتبط را watch می‌کند؛ هنگام تغییر، key را به صف می‌فرستد، وضعیت را از API می‌خواند، وضعیت واقعی را مشاهده و اختلاف را اصلاح می‌کند. event ممکن است تکراری یا هم‌زمان برسد، پس controller باید idempotent باشد و بر پایهٔ وضعیت کنونی کار کند، نه ترتیب eventهای گذشته.

~~~text
read desired spec → inspect actual state → perform one safe action
→ update status → retry/reconcile until converged
~~~

برای مثال، Custom Resource از نوع BackupPolicy می‌تواند Job و Secret reference تعریف کند؛ controller وضعیت backup را در status ثبت کند. policy باید مشخص کند Secret مورد استفاده چیست و credential را افشا نکند.

## قواعد طراحی

- reconcile را کوتاه و قابل‌تکرار نگه دارید.
- side effect بیرونی را با idempotency یا state ثبت‌شده محافظت کنید.
- finalizer را برای پاک‌سازی منبع بیرونی با مسیر retry بسازید.
- status condition و observedGeneration را به‌روزرسانی کنید.
- RBAC فقط resourceهای لازم را بخواند/بنویسد.
- metric، event و log برای queue، error و latency داشته باشید.
- برای restart process و API unavailable رفتار تعریف کنید.

Kubebuilder و Operator SDK scaffolding می‌دهند؛ scaffold درست‌بودن منطق را تضمین نمی‌کند. unit/envtest و تست کلاستر برای چرخهٔ lifecycle لازم‌اند.

## کوییز

1. Controller رویداد را اجرا می‌کند یا وضعیت را reconcile؟ — وضعیت را با بررسی API دوباره reconcile می‌کند.
2. finalizer چه زمانی لازم است؟ — پیش از حذف نهایی، cleanup خارجی قابل retry انجام شود.
3. چرا event تکراری مهم نیست؟ — reconcile idempotent باید همان وضعیت مطلوب را پایدار نگه دارد.
4. خطای dependency بیرونی را کجا ثبت می‌کنید؟ — status condition، metric و log با retry مشخص.

## منابع

- [Controller Pattern](https://kubernetes.io/docs/concepts/architecture/controller/)
- [Extending Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/)
- [Kubebuilder Book](https://book.kubebuilder.io/)

</div>