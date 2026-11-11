<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/11-storage-volumes/topics/csi/README.md) · [کتابخانهٔ منابع](../../../references/README.md#11-storage-and-volumes)

# CSI Driver

**فصل:** [Storage و Volume](../../README.md)

## CSI چه می‌کند؟

Container Storage Interface قراردادی است که Kubernetes و storage driver را به هم وصل می‌کند. driver ممکن است volume را ایجاد، attach، mount، detach و snapshot کند. control plane معمولاً external provisioner و node pluginهای driver را اجرا می‌کند. سلامت این اجزا هم برای ساخت volume و هم برای اتصال آن به workload لازم است.

## مسیر volume

1. برنامه PVC می‌سازد.
2. StorageClass provisioner و parameter را مشخص می‌کند.
3. driver volume را در backend ایجاد می‌کند.
4. scheduler topology و node را در نظر می‌گیرد.
5. controller عملیات attach را انجام می‌دهد.
6. node plugin volume را mount می‌کند.
7. kubelet آن را در مسیر Pod می‌گذارد.

## عیب‌یابی

اگر PVC Pending است، event claim و StorageClass را بخوانید. اگر attach/mount شکست خورد، node، CSI controller, node plugin، permission ابر، zone و attachment limit را بررسی کنید. upgrade driver را با workloadهای واقعی و snapshot سازگار آزمایش کنید.

## تصمیم عملی

Driver را با نیاز latency، IOPS، access mode، zone، encryption، snapshot و consistency انتخاب کنید. سرعت provisioning تنها معیار نیست؛ پشتیبانی، هزینه، backup و قابلیت restore هم مهم‌اند. در local cluster ممکن است driver آزمایشی امکانات production را نداشته باشد.

## کوییز

1. CSI کدام مرز را استاندارد می‌کند؟ — ارتباط Kubernetes با پیاده‌سازی storage.
2. PVC Pending اما Pod هنوز ساخته نشده؛ ابتدا؟ — eventهای PVC و provisioner.
3. Pod در mount گیر کرده؛ کدام لایه‌ها را ببینیم؟ — CSI node plugin، node و attachment.
4. Snapshot driver چه نیازی دارد؟ — پشتیبانی و سازگاری driver و سیاست retention/restore.

## منابع

- [CSI در Kubernetes](https://kubernetes.io/docs/concepts/storage/volumes/#csi)
- [CSI specification](https://github.com/container-storage-interface/spec)
- [Volume Snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)

</div>