<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/04-running-applications/topics/statefulsets/README.md) · [کتابخانهٔ منابع](../../../references/README.md#04-running-applications)

# StatefulSet

**فصل:** [اجرای برنامه‌ها و Workloadها](../../README.md)

## چه چیزی پایدار است؟

StatefulSet به replicaها هویت ترتیبی و شبکه‌ای قابل‌شناسایی و در صورت تعریف claim اختصاصی می‌دهد. Pod با نامی مانند db-0 اگر جایگزین شود، همان هویت ordinalی را دارد و PVC متناظر دوباره mount می‌شود. Headless Service معمولاً DNS هر replica را مشخص می‌کند.

این پایداری، دیتابیس را خودکار replicated یا highly available نمی‌کند. برنامه باید consistency، election، quorum و failover را پیاده کند. backup و restore نیز وظیفهٔ جداگانه‌اند. برای بارکاری حساس، database managed ممکن است ریسک عملیاتی کمتری داشته باشد.

## الگوی ساخت

~~~yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db
spec:
  serviceName: db
  replicas: 2
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - name: database
        image: example.invalid/database:v1
        volumeMounts:
        - name: data
          mountPath: /var/lib/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
~~~

این نمونه اسکلت API است، نه دیتابیس آماده. image، security، credential، probe، StorageClass، replication و recovery دستورالعمل جدا می‌خواهند.

## عملیات امن

- پیش از upgrade تعداد healthy member و quorum را بدانید.
- volume topology را با node و zone هماهنگ کنید.
- StatefulSet و PVC چرخهٔ عمر متفاوت دارند؛ حذف workload ممکن است داده را باقی بگذارد.
- PDB باید با quorum واقعی هماهنگ باشد؛ constraint بیش از حد سخت drain را متوقف می‌کند.
- restore را دوره‌ای از backup جدا تمرین کنید.

## کوییز تشریحی

1. چه چیزی بعد از جایگزینی Pod حفظ می‌شود؟ — نام/ordinal و claim اختصاصی، نه لزوماً دادهٔ سالم یا quorum.
2. آیا StatefulSet به‌تنهایی HA ایجاد می‌کند؟ — خیر؛ نرم‌افزار باید replication و انتخاب leader داشته باشد.
3. حذف StatefulSet چه زمانی داده را پاک می‌کند؟ — وابسته به PVC/PV و reclaim policy است؛ پیش از حذف بررسی کنید.
4. قبل از node upgrade چه می‌سنجید؟ — quorum، PDB، ظرفیت جایگزین، وضعیت volume و بازیابی.

## منابع

- [StatefulSets رسمی](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [اجرای برنامهٔ stateful تکثیرشده](https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/)
- [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>