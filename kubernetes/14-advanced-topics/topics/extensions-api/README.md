<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#14-advanced-topics-and-extensibility)

# Extension و Kubernetes API

**فصل:** [موضوعات پیشرفته](../../README.md)

## گزینه‌های توسعه

- **CRD:** API Server اصلی نوع سفارشی را ذخیره و validate می‌کند؛ برای بیشتر APIهای declarative گزینهٔ رایج‌تر.
- **API Aggregation:** API Server درخواست group/version را به extension API server جدا proxy می‌کند؛ برای APIهایی که پیاده‌سازی خاص می‌خواهند.
- **Admission webhook:** درخواست write را پیش از ذخیره mutate یا validate می‌کند؛ به سرویس HTTPS در دسترس وابسته است.
- **Controller:** API را می‌خواند و وضعیت بیرونی/منابع را reconcile می‌کند.

جریان کلی درخواست: authentication، authorization، admission، validation/persistence؛ ترتیب دقیق pluginها را از مستند نسخهٔ مورد استفاده بررسی کنید.

## Webhook باید production-grade باشد

Webhook بدون HA و timeout مناسب می‌تواند API را کند یا مسدود کند. scope را محدود، selector را دقیق، certificate را rotate، logs/metrics را پایش و failurePolicy را آگاهانه انتخاب کنید. Fail-open ممکن است policy را دور بزند؛ fail-closed ممکن است هنگام outage درخواست‌ها را ببندد. هیچ‌کدام را بدون threat model انتخاب نکنید.

## انتخاب

CRD ساده‌تر است اگر نیاز شما resource declarative است. Aggregation زمانی مناسب‌تر است که API server تخصصی لازم باشد. Admission برای policy قبل از ثبت درخواست مناسب است. Controller برای اقدام پس از ایجاد شیء لازم می‌شود. پیش از توسعهٔ افزونه، built-in policy و controllerهای موجود را بررسی کنید.

## کوییز

1. کدام extension type برای mutate/validate درخواست API است؟ — Admission webhook.
2. چه تفاوت CRD و aggregation؟ — CRD در API server اصلی؛ aggregation به API server دیگر proxy می‌کند.
3. webhook در fail-closed قطع شود چه خطر دارد؟ — درخواست‌های منطبق ممکن است رد/مسدود شوند.
4. چرا scope باید محدود باشد؟ — availability و اثر خرابی webhook روی API کمتر می‌شود.

## منابع

- [Extending the Kubernetes API](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/)
- [Dynamic Admission Control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)
- [Admission Webhook Good Practices](https://kubernetes.io/docs/concepts/cluster-administration/admission-webhooks-good-practices/)
- [API Aggregation Layer](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/)

</div>