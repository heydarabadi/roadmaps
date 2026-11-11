<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/10-autoscaling/topics/cluster-autoscaling/README.md) · [کتابخانهٔ منابع](../../../references/README.md#10-autoscaling)

# Cluster Autoscaling

**فصل:** [Autoscaling](../../README.md)

## فرق مقیاس Pod و Node

HPA تعداد Pod را افزایش می‌دهد. Cluster Autoscaler یا سازوکار node provisioning زمانی ظرفیت اضافه می‌کند که Podها به علت نبود node مناسب قابل‌زمان‌بندی نباشند. Node جدید ممکن است زمان بخواهد تا ساخته، join، آماده و imageها را pull کند.

کاهش node نیز ساده نیست: Podها باید جا‌به‌جا شوند. PDB، local storage، taint، PVC topology، daemon workload و نبود ظرفیت جایگزین می‌تواند scale-down را متوقف کند. quota provider و سقف node را در نظر بگیرید.

## عیب‌یابی

~~~sh
kubectl get pods -A --field-selector=status.phase=Pending
kubectl describe pod POD_NAME
kubectl get nodes
kubectl get events -A --sort-by=.metadata.creationTimestamp
~~~

علت Pending را از event بخوانید. Insufficient CPU، selector/taint نامناسب، PVC، quota cloud و image pull هر کدام علت جدا دارند. ساخت node فقط مشکل ظرفیت را رفع می‌کند، نه selector نادرست یا image ناموجود.

## کوییز

1. HPA با cluster autoscaler چه فرقی دارد؟ — اولی replica، دومی node capacity را تغییر می‌دهد.
2. چرا scale-up فوری نیست؟ — provisioning، boot، join و آماده‌شدن node زمان می‌برد.
3. چه چیزی scale-down را مسدود می‌کند؟ — PDB، volume، constraint یا نبود مقصد مناسب برای Pod.
4. node اضافه شد ولی Pod هنوز Pending است؛ چرا؟ — علت ممکن است غیر از ظرفیت باشد؛ event را بررسی کنید.

## منابع

- [Cluster Autoscaler project](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)
- [Scheduling و Pending Pods](https://kubernetes.io/docs/concepts/scheduling-eviction/)
- [Autoscaling concepts](https://kubernetes.io/docs/concepts/workloads/autoscaling/)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>