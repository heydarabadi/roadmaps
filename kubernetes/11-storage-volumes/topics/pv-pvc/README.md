<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#11-storage-and-volumes)

# Volume، PersistentVolume و PVC

**فصل:** [Storage و Volume](../../README.md)

## انواع storage

emptyDir برای scratch یا اشتراک موقت بین containerهای یک Pod است و با حذف Pod از بین می‌رود. PersistentVolumeClaim درخواست مستقل برای storage است. Pod PVC را mount می‌کند؛ lifecycle claim از lifecycle یک container جدا می‌شود. ConfigMap/Secret هم می‌توانند volume شوند اما storage عمومی پایدار نیستند.

## Provisioning

~~~yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: uploads
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: standard
~~~

اگر StorageClass پویا باشد، provisioner یک PV می‌سازد و claim را bind می‌کند. اگر کلاس یا ظرفیت مناسب نباشد، claim Pending می‌ماند. ظرفیت درخواستی، access mode، topology zone و reclaim policy را در eventها دنبال کنید.

ReadWriteOnce یعنی volume read-write از یک node mount شود؛ چند Pod روی همان node ممکن است رفتار قابل‌قبولی داشته باشند، بسته به driver. ReadWriteMany یا ReadWriteOncePod نیز semantics جدا دارند. access mode را مساوی قفل داده یا replication نگیرید.

## داده و پاک‌سازی

~~~sh
kubectl get pvc,pv
kubectl describe pvc uploads
kubectl get storageclass
~~~

PVC را پیش از حذف بررسی کنید. reclaim policy می‌تواند volume زیرین را حذف یا نگه دارد. برای بازیابی، backup/snapshot و restore را آزمایش کنید. volume سالم از خطای منطقی، ransomware یا حذف کاربر حفاظت کامل نمی‌کند.

## کوییز

1. emptyDir چه زمانی حذف می‌شود؟ — با حذف Pod.
2. PVC را چه کسی مصرف می‌کند؟ — Pod از طریق volume mount.
3. claim Pending؛ علت‌های محتمل؟ — StorageClass، ظرفیت، permission، topology یا CSI.
4. آیا access mode سیاست backup است؟ — خیر.
5. پیش از حذف claim چه بررسی می‌کنید؟ — مالک داده، snapshot، reclaim policy و نیاز retention.

## منابع

- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Volume](https://kubernetes.io/docs/concepts/storage/volumes/)
- [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/)

</div>