<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#13-deployment-and-delivery)

# Rolling Updates و Rollback

**فصل:** [الگوهای انتشار](../../README.md)

## انتشار مرحله‌ای

Deployment با RollingUpdate نسخهٔ تازه را تدریجی اجرا می‌کند و replicaهای نسخهٔ قبلی را کم می‌کند. maxSurge ظرفیت اضافه و maxUnavailable downtime مجاز را کنترل می‌کند. readiness باید آمادگی واقعی را بسنجد؛ بدون آن Pod ناآماده ممکن است به ترافیک برسد.

~~~yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
~~~

در این تنظیم حداقل تعداد قبلی باید available بماند و یک Pod اضافه موقت مجاز است. اگر ظرفیت node کافی نباشد، rollout می‌تواند منتظر بماند. Recreate deployment قبلی را متوقف می‌کند و ممکن است downtime بسازد.

## rollback

~~~sh
kubectl rollout status deployment/api
kubectl rollout history deployment/api
kubectl rollout undo deployment/api
~~~

undo template قبلی را برمی‌گرداند؛ فایل manifest در Git را نیز اصلاح کنید تا drift ایجاد نشود. rollback باید با معیار تصمیم مثل نرخ خطا یا latency انجام شود، نه صرفاً به‌دلیل یک alert noisy.

## سازگاری هم‌زمان نسخه‌ها

در حین rollout نسخهٔ قدیم و جدید هم‌زمان‌اند. API و schema باید backward-compatible باشند. migration را expand/contract طراحی کنید و مراحل را در محیط staging تمرین کنید. کد برگشتی نمی‌تواند پیام queue، دادهٔ ذخیره‌شده یا اثر پرداخت را حذف کند.

## کوییز

1. maxSurge چه چیزی را کنترل می‌کند؟ — Pod اضافهٔ موقت هنگام rollout.
2. readiness چرا لازم است؟ — فقط Pod آماده را available حساب می‌کند.
3. rollout متوقف شد؛ چه می‌کنید؟ — condition، event، Pod، image، capacity و probe را تحلیل می‌کنید.
4. rollback را کجا همگام می‌کنید؟ — تعریف source of truth مانند Git/manifest را نیز اصلاح می‌کنید.

## منابع

- [RollingUpdate Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [به‌روزرسانی Deployment](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
- [Deployment API](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/)

</div>