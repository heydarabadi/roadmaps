<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#04-running-applications)

# ReplicaSet

**فصل:** [اجرای برنامه‌ها و Workloadها](../../README.md)

## وظیفهٔ کنترلر

ReplicaSet تعداد مشخصی Pod را با selector نگه می‌دارد. اگر تعداد مشاهده‌شده کمتر از spec.replicas باشد، Pod می‌سازد؛ اگر بیشتر باشد، کم می‌کند. این کنترلر Pod مشخصی را نگه نمی‌دارد؛ replica مطابق الگو را حفظ می‌کند.

در انتشار معمول، Deployment مالک ReplicaSetهاست تا نسخه‌های قدیم و جدید را مدیریت کند. ساخت ReplicaSet دستی ممکن است برای تمرین باشد، اما برای سرویس production معمولاً قابلیت rollout، rollback و تاریخچهٔ Deployment را از دست می‌دهید.

## اجزای selector

selector یک ReplicaSet باید با labelهای Pod template مطابق باشد. اگر selector دو مجموعه را ناخواسته انتخاب کند، کنترلر می‌تواند Podهای نامربوط را به‌عنوان فرزند خود ببیند. labelها را از ابتدا با قرارداد روشن نام‌گذاری کنید.

~~~yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: worker
spec:
  replicas: 2
  selector:
    matchLabels:
      app: worker
  template:
    metadata:
      labels:
        app: worker
    spec:
      containers:
      - name: task
        image: busybox:stable
        command: ["sh", "-c", "sleep 3600"]
~~~

## مشاهدهٔ self-healing

~~~sh
kubectl get rs
kubectl get pods --show-labels
kubectl delete pod -l app=worker
kubectl get rs,pods --watch
~~~

پس از حذف Pod، ReplicaSet اختلاف تعداد را می‌بیند و نمونهٔ تازه می‌سازد. اگر image خراب باشد، همان Pod خراب دوباره ساخته می‌شود؛ کنترلر تعداد را تضمین می‌کند نه صحت منطق برنامه.

## تفاوت با Deployment

Deployment ReplicaSet را تولید و مدیریت می‌کند، Pod template را نسخه‌بندی می‌کند و rollout/rollback را ارائه می‌دهد. هنگام تغییر template، ReplicaSet جدید می‌سازد و قدیمی را تدریجی کم می‌کند. در نتیجه، ReplicaSet را بیشتر از راه مشاهده و عیب‌یابی می‌شناسیم تا ویرایش مستقیم.

## کوییز

1. ReplicaSet چه چیزی را reconcile می‌کند؟ — تعداد Podهای سازگار با selector.
2. آیا حذف یک Pod مشخص همیشه با همان Pod جبران می‌شود؟ — نه؛ ممکن است Pod جدید با هویت دیگری ساخته شود.
3. چرا ReplicaSet روی Deployment ترجیح داده نمی‌شود؟ — تاریخچه و مدیریت انتشار ندارد.
4. replica را زیاد کردید ولی Pod Pending شد؛ علت محتمل؟ — ظرفیت node، quota یا constraint زمان‌بندی کافی نیست.

## منابع

- [ReplicaSet رسمی](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
- [Deployment رسمی](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [دورهٔ فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>