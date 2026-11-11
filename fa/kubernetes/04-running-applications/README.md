<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/04-running-applications/README.md) · [کتابخانهٔ منابع](../references/README.md#04-running-applications)

# فصل 04: اجرای برنامه‌ها و Workloadها

## هدف‌های فصل

- Pod را از container متمایز کنید.
- بدانید Deployment چگونه ReplicaSet و Podها را مدیریت می‌کند.
- برای سرویس stateless، دادهٔ stateful و کار پایان‌پذیر منبع مناسب انتخاب کنید.
- rollout، readiness و شکست workload را از روی وضعیت و رویدادها عیب‌یابی کنید.

## مدل ذهنی

~~~text
Deployment → ReplicaSet → Pod → Container
StatefulSet → Podهای دارای هویت + PVC
Job → Podهای کار پایان‌پذیر
~~~

Pod کوچک‌ترین واحدی است که scheduler زمان‌بندی می‌کند؛ container process برنامه درون Pod است. Deployment تعداد Podها و نسخهٔ stateless را مدیریت می‌کند. ReplicaSet تعداد Pod مطابق selector را نگه می‌دارد. StatefulSet هویت ordinal و volume claim را به replica می‌بندد. Job تا پایان کار batch را دنبال می‌کند. این منابع جای هم نیستند.

## چه چیزی را انتخاب کنم؟

| نوع کار | منبع پیشنهادی | نکته |
| --- | --- | --- |
| API یا worker همیشه‌فعال و قابل‌تکثیر | Deployment | readiness، rollout و منابع را تعریف کنید |
| replica با هویت یا دیسک اختصاصی | StatefulSet | replication و backup را خود برنامه/عملیات طراحی می‌کند |
| migration یا پردازش پایان‌پذیر | Job | retry و side effect را ایمن کنید |
| زمان‌بندی batch | CronJob که Job می‌سازد | overlap و concurrency را کنترل کنید |
| Pod موقت برای آزمایش | Pod مستقیم | حذف آن را هیچ controller جبران نمی‌کند |

## نمونهٔ Deployment

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: example.invalid/shop/api:v1
        ports:
        - name: http
          containerPort: 8080
        readinessProbe:
          httpGet:
            path: /ready
            port: http
        resources:
          requests:
            cpu: 200m
            memory: 256Mi
~~~

selector در Deployment باید با labelهای Pod template یکی باشد. نام image نمونه‌ای است و باید با image واقعی جایگزین شود. maxUnavailable صفر می‌تواند rollout را در ظرفیت کم متوقف کند، چون نسخهٔ جدید باید آماده شود پیش از حذف قبلی.

## کنترل انتشار و مشاهده

~~~sh
kubectl rollout status deployment/api
kubectl rollout history deployment/api
kubectl describe deployment/api
kubectl get deploy,rs,pods
~~~

تغییر Pod template، مثلاً image، revision جدید می‌سازد. تغییر تعداد replica معمولاً فقط scale می‌کند. Readiness مشخص می‌کند Pod به ترافیک وارد شود؛ liveness می‌تواند container گیرکرده را restart کند. هر دو باید رفتار واقعی برنامه را منعکس کنند. probe اشتباه می‌تواند rollout سالم را متوقف یا Pod خراب را زنده نگه دارد.

Rollback، template قبلی را برمی‌گرداند؛ تغییر دیتابیس، پیام صف یا side effect خارجی را برنمی‌گرداند. برای rollout بدون downtime، دو نسخه باید مدتی با هم کار کنند؛ migration دیتابیس را سازگار طراحی کنید.

## سناریوی عملی: فروشگاه اینترنتی

API سفارش را با Deployment منتشر کنید. worker صف را جدا مقیاس دهید. migration را به Job تبدیل کنید و اجرای تکراری آن را بی‌خطر سازید. دیتابیس را StatefulSet فقط وقتی انتخاب کنید که تیم توان backup، restore، quorum، upgrade و alerting داشته باشد؛ سرویس دیتابیس managed نیز گزینهٔ معتبر است.

## خطایابی

1. get وضعیت Deployment، ReplicaSet و Pod را نشان می‌دهد.
2. describe condition و event زمان‌بندی، image و probe را آشکار می‌کند.
3. logs و logs قبلی خطای process را نشان می‌دهند.
4. selector و labelها را بررسی کنید.
5. برای StatefulSet، وضعیت PVC و storage را هم بخوانید.
6. برای Job، retry، exit code، deadline و idempotency را بسنجید.

## کوییز و پاسخ

1. حذف Pod تحت Deployment با حذف Pod دستی چه تفاوتی دارد؟ — Deployment replica را بازمی‌سازد؛ Pod دستی owner ندارد.
2. چه موقع StatefulSet لازم است؟ — وقتی هویت پایدار، ترتیب یا volume اختصاصی لازم است؛ نه صرفاً هر برنامهٔ دیتابیس.
3. چرا Job باید idempotent باشد؟ — شکست و retry می‌تواند اثر خارجی را تکرار کند.
4. آیا rollout undo migration را برمی‌گرداند؟ — خیر؛ کد و داده چرخهٔ تغییر جدا دارند.

## تجربهٔ واقعی و منابع

Netflix تجربهٔ batch در Kubernetes را در [مقالهٔ Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c) توضیح می‌دهد. نکتهٔ قابل‌انتقال، نیاز به ظرفیت، صف‌بندی و عدالت میان tenantهاست؛ معماری Netflix را بدون سنجش مقیاس کپی نکنید.

- [Workloads رسمی Kubernetes](https://kubernetes.io/docs/concepts/workloads/)
- [مدیریت Workloadها](https://kubernetes.io/docs/concepts/workloads/management/)
- [دورهٔ فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
- [کارگاه فارسی workload](https://www.youtube.com/watch?v=eDbCM6sbcXY)

</div>