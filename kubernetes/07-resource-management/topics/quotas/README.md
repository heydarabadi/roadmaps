<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#07-resource-management)

# Quota و LimitRange در Namespace

**فصل:** [مدیریت منابع](../../README.md)

## مصرف چندتیمی

ResourceQuota مقدار تجمعی resource یا تعداد objectهای namespace را محدود می‌کند. LimitRange بازه یا مقدار پیش‌فرض container/Pod را تعیین می‌کند. این دو با هم از مصرف بی‌حد جلوگیری می‌کنند، اما جایگزین capacity planning یا هزینه‌سنجی نیستند.

~~~yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-budget
  namespace: team-a
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "30"
~~~

اعداد نمونه هستند. مقدارهای واقعی را با ظرفیت کلاستر، تعداد تیم و سطح سرویس هماهنگ کنید. اگر quota پر باشد، API شیء جدید را رد می‌کند؛ اگر quota افزایش یابد ولی node جا نداشته باشد، Pod ممکن است بعداً Pending شود.

## عیب‌یابی و طراحی

وضعیت quota، event درخواست ردشده، request و limit workload و مصرف موجود namespace را کنار هم بررسی کنید. LimitRange پیش‌فرض را مستند کنید؛ مقدار پیش‌فرض نامناسب می‌تواند برنامه را throttle یا OOM کند. quota را طوری تقسیم کنید که burst و workload اضطراری را هم در نظر بگیرد.

## کوییز

1. Quota در چه سطحی معمولاً اعمال می‌شود؟ — Namespace.
2. آیا quota ظرفیت واقعی node تولید می‌کند؟ — خیر؛ پذیرش/مصرف را محدود می‌کند.
3. پس از افزایش quota چه چیزی را بسنجیم؟ — ظرفیت node و اثر مالی.
4. LimitRange چه کاربردی دارد؟ — اعمال default و بازهٔ منابع در objectهای جدید.

## منابع

- [ResourceQuota رسمی](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [LimitRange رسمی](https://kubernetes.io/docs/concepts/policy/limit-range/)
- [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

</div>