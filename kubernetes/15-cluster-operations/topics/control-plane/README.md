<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#15-cluster-operations)

# نصب و نگهداری Control Plane

**فصل:** [عملیات کلاستر](../../README.md)

## اجزا و چرخهٔ نصب

Control plane شامل API Server، etcd، Scheduler و controllerهاست. kubeadm مسیر bootstrap با init و join می‌دهد، اما ماشین‌ها را provision نمی‌کند و همهٔ addonها را نصب/مدیریت نمی‌کند. شبکه، certificate، storage، load balancer و observability را جدا طراحی کنید.

برای production، control plane باید failure node را تحمل کند، etcd از نظر latency و quorum سالم باشد و API با TLS/identity محافظت شود. طراحی HA را با topology، load balancer، DNS و روش restore هماهنگ کنید.

## Backup و upgrade

Snapshot etcd را طبق راهنمای نسخه ذخیره و بازیابی را در محیط جدا تمرین کنید. فایل backup می‌تواند حاوی اطلاعات حساس باشد؛ encryption و دسترسی را اعمال کنید. پیش از upgrade، release note، version skew، CNI/CSI و admission webhook را بررسی کنید. control plane را طبق توالی ابزار نصب مرحله‌ای upgrade کنید.

## کوییز

1. kubeadm ابزار provisioning cloud است؟ — خیر؛ bootstrap می‌کند.
2. کدام دادهٔ cluster را etcd نگه می‌دارد؟ — وضعیت resourceهای API.
3. چرا snapshot را بیرون از node نگه می‌داریم؟ — خرابی node نباید backup را هم نابود کند.
4. پیش از upgrade چه اجزایی را بررسی می‌کنیم؟ — version skew، extension، CNI/CSI، webhook و recovery.

## منابع

- [kubeadm overview](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
- [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)
- [etcd backup and restore](https://etcd.io/docs/)

</div>