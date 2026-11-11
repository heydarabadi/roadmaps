<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/04-running-applications/topics/deployments/README.md) · [کتابخانهٔ منابع](../../../references/README.md#04-running-applications)

# Deployment

**فصل:** [اجرای برنامه‌ها و Workloadها](../../README.md)

## Deployment چه چیزی را مدیریت می‌کند؟

Deployment وضعیت مطلوب برنامهٔ stateless را تعریف می‌کند. Deployment controller یک ReplicaSet برای template می‌سازد؛ ReplicaSet تعداد Podها را نگه می‌دارد. وقتی Pod template تغییر کند، revision تازه‌ای ایجاد می‌شود. وقتی فقط replica تغییر کند، معمولاً همان ReplicaSet تعداد را تنظیم می‌کند.

## انتشار RollingUpdate

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: example.invalid/api:v2
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
~~~

maxSurge تعداد Pod اضافهٔ موقت و maxUnavailable تعداد Podهایی را تعیین می‌کند که اجازه داریم در زمان انتشار unavailable باشند. مقدار تهاجمی ممکن است ظرفیت کم را مصرف یا دسترس‌پذیری را کاهش دهد. readiness موفق باید واقعاً آمادگی پاسخ را نشان دهد.

~~~sh
kubectl rollout status deployment/api
kubectl rollout history deployment/api
kubectl rollout undo deployment/api
kubectl describe deployment/api
~~~

## نسخهٔ برنامه و schema داده

در rollout، نسخهٔ قبلی و جدید ممکن است هم‌زمان اجرا شوند. آن‌ها باید موقتاً با schema و قرارداد API سازگار باشند. روش expand/contract: schema سازگار را اضافه کنید، برنامهٔ جدید را منتشر و مصرف قدیمی را حذف کنید، سپس schema قدیمی را پاک کنید. Rollback کد به‌تنهایی migration یا side effect را معکوس نمی‌کند.

## انتخاب و عیب‌یابی

RollingUpdate معمولاً downtime را کاهش می‌دهد ولی به ظرفیت اضافه نیاز دارد. Recreate ابتدا نسخهٔ قبلی را متوقف می‌کند و ممکن است downtime بسازد. اگر rollout متوقف شد:

1. status و conditionهای Deployment را ببینید.
2. ReplicaSet جدید و Podها را بررسی کنید.
3. event مربوط به image pull، scheduling، quota و probe را بخوانید.
4. log برنامه را بررسی کنید.
5. براساس علت اصلاح کنید یا rollback انجام دهید؛ blind rollback مشکل داده را حل نمی‌کند.

## کوییز و پاسخ

1. چه چیزی revision تازه می‌سازد؟ — تغییر در Pod template مانند image، command یا env.
2. readiness در rollout چه نقشی دارد؟ — نسخهٔ ناآماده را از endpoint و پیشروی انتشار بازمی‌دارد.
3. maxUnavailable=0 چه هزینه‌ای دارد؟ — باید ظرفیت کافی برای Pod تازه باشد پیش از کاهش قبلی.
4. rollback دیتابیس را معکوس می‌کند؟ — خیر؛ migration و داده روش recovery جدا می‌خواهند.

## منابع

- [Deployments رسمی](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [به‌روزرسانی Deployment](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
- [Deployment API](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>