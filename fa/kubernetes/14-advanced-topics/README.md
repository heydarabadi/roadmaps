<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/14-advanced-topics/README.md) · [کتابخانهٔ منابع](../references/README.md#14-advanced-topics-and-extensibility)

# فصل 14: Advanced Topics و توسعه‌پذیری

## چه زمانی Kubernetes را گسترش دهیم؟

Kubernetes برای automation طراحی شده است و API را می‌توان با Custom Resource، controller، admission و API aggregation گسترش داد. اما افزونهٔ تازه به کلاستر نقطهٔ خرابی، مجوز، ارتقا و on-call اضافه می‌کند. اول بررسی کنید APIهای داخلی، policyهای موجود یا یک controller ساده مسئله را حل نمی‌کند.

## CRD و Controller

CRD نوع جدیدی از شیء API تعریف می‌کند: schema، نام، scope و version. Controller این object را می‌خواند، وضعیت واقعی را مقایسه و برای رسیدن به desired state اقدام می‌کند. CRD به‌تنهایی رفتار عملیاتی ندارد؛ controller یا operator معمولاً منطق را اجرا می‌کند.

Controller باید idempotent باشد؛ eventها ممکن است تکرار شوند. reconcile کوتاه و قابل retry باشد، خطا را در status و event ثبت کند و برای حذف resource cleanup قابل‌بازیابی داشته باشد.

## Scheduler و API extension

Scheduler plugin یا extender فقط وقتی توجیه دارد که سیاست placement با امکانات فعلی مانند affinity، taint و topology spread بیان نشود. API aggregation برای ساخت API server جداست؛ CRD معمولاً گزینهٔ سبک‌تر برای نوع سفارشی است. Admission webhook درخواست را validate یا mutate می‌کند و اگر unavailable باشد می‌تواند مسیر API را مختل کند.

## طراحی مسئولانه

- owner، upgrade policy و نسخهٔ API را تعیین کنید.
- RBAC افزونه را کمینه کنید.
- metric، log، alert، timeout و failure mode بسازید.
- CRD version conversion و backup/restore را بررسی کنید.
- controller را با retry، restart و delete آزمایش کنید.
- افزونهٔ unused را پاک‌سازی و API migration را مستند کنید.

## کوییز

1. CRD به‌تنهایی resource را operational می‌کند؟ — خیر؛ controller رفتار را reconcile می‌کند.
2. چرا reconcile idempotent باشد؟ — درخواست/رویداد ممکن است چندبار برسد.
3. CRD یا API aggregation؟ — CRD نوع را به API اصلی می‌افزاید؛ aggregation API server مجزا را پشت API server اصلی proxy می‌کند.
4. چرا custom scheduler هزینهٔ بالایی دارد؟ — باید با scheduler، نسخه‌ها، pluginها، امنیت و failure آن نگهداری شود.
5. webhook چه ریسک عملیاتی دارد؟ — خرابی/تاخیرش می‌تواند درخواست‌های API را کند یا متوقف کند.

## منابع

- [Extending Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/)
- [Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- [Admission Webhooks](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)
- [Scheduler Framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)

</div>