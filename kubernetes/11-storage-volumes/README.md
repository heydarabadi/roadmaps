<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../references/README.md#11-storage-and-volumes)

# فصل 11: Storage و Volume

## هدف‌های فصل

- تفاوت volume موقت، PV، PVC و StorageClass را توضیح دهید.
- مسیر provisioning تا mount را در CSI دنبال کنید.
- برای stateful workload، ماندگاری را با backup و recovery اشتباه نگیرید.
- اثر topology، access mode و reclaim policy را پیش از حذف resource بسنجید.

## چرا filesystem container کافی نیست؟

فایل‌سیستم لایهٔ writable container معمولاً با حذف و جایگزینی Pod از بین می‌رود. Volume می‌تواند lifecycle داده را از container جدا کند. emptyDir در عمر Pod وجود دارد ولی با حذف Pod پاک می‌شود؛ PVC به storage بیرونی یا local متصل می‌شود و ممکن است داده را فراتر از Pod نگه دارد.

## مدل درخواست تا دیسک

- **PVC:** درخواست storage در namespace برنامه.
- **PV:** منبع ذخیره‌سازی کلاستر که claim را تأمین می‌کند.
- **StorageClass:** نوع و سیاست provisioning پویا.
- **CSI driver:** رابط به provider یا سامانهٔ storage برای provision/attach/mount.
- **Snapshot/backup:** راه بازیابی؛ خود volume مساوی backup نیست.

~~~yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: standard
~~~

StorageClass باید در کلاستر موجود باشد. access mode صرفاً نحوهٔ اتصال را توصیف می‌کند؛ RWO معمولاً read-write از یک node است، نه الزاماً یک Pod. رفتار واقعی به driver وابسته است.

## Lifecycle و داده

Reclaim policy می‌تواند هنگام حذف claim رفتار PV را تعیین کند؛ Retain و Delete پیامدهای متفاوت دارند. قبل از پاک‌کردن PVC، PV، snapshot، replication و policy داده را بخوانید. حذف Pod معمولاً claim را حذف نمی‌کند، ولی این تضمین backup نیست.

## عیب‌یابی و تمرین

اگر PVC Pending ماند، event، StorageClass، provisioner، quota، topology و CSI controller را بررسی کنید. اگر Pod در ContainerCreating ماند، eventهای attach/mount و دسترسی node را ببینید. برای تمرین، PVC بسازید، Pod را حذف و دوباره بسازید، سپس داده را بخوانید؛ بعد snapshot/restore را در کلاستر آموزشی تمرین کنید.

## تجربهٔ عملی

یک دیسک پایدار فقط در failureهای مشخص داده را نگه می‌دارد. حذف region، خطای کاربر، فساد داده یا حذف اشتباه ممکن است volume را نیز از بین ببرد. برای سامانهٔ مالی، snapshot، نسخهٔ خارج از cluster، رمزنگاری، RPO/RTO و restore drill را جداگانه طراحی کنید.

## کوییز

1. PVC و PV چه تفاوتی دارند؟ — PVC درخواست؛ PV منبع تأمین‌کننده.
2. StorageClass چه نقشی دارد؟ — نوع و روش provisioning را تعیین می‌کند.
3. آیا RWO یعنی فقط یک Pod در کل می‌تواند volume را mount کند؟ — الزاماً نه؛ تعریف آن node-oriented است و driver/پیاده‌سازی مؤثر است.
4. آیا volume پایدار برابر backup است؟ — خیر؛ backup مستقل و restore آزموده‌شده لازم است.
5. PVC Pending است؛ اولین سرنخ چیست؟ — eventهای claim و StorageClass/provisioner.

## منابع

- [Storage مفاهیم رسمی](https://kubernetes.io/docs/concepts/storage/)
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/)
- [Volume Snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>