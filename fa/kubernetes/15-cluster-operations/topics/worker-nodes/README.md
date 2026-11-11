<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/15-cluster-operations/topics/worker-nodes/README.md) · [کتابخانهٔ منابع](../../../references/README.md#15-cluster-operations)

# افزودن و مدیریت Worker Node

**فصل:** [عملیات کلاستر](../../README.md)

## آماده‌بودن node

Node باید kubelet، runtime، network plugin، ظرفیت allocatable و نسخهٔ سازگار داشته باشد. در managed cluster، node pool بخشی از provider integration است؛ در self-managed، نصب OS، patch، certificate و join token را نیز مدیریت می‌کنید.

Node condition Ready به معنی سلامت همهٔ برنامه‌ها نیست. DiskPressure، MemoryPressure، PIDPressure و network issue را بررسی کنید. node label، taint، topology و device plugin هم بر جایابی اثر دارند.

## تعمیر و upgrade

برای maintenance، ابتدا cordon کنید تا workload تازه نرود؛ سپس drain تا Podهای قابل‌جابجایی منتقل شوند؛ PDB و ظرفیت جایگزین را بررسی کنید. پس از patch/upgrade، runtime و CNI را تأیید و node را uncordon کنید. drain ممکن است به local storage، PDB یا daemonset برخورد کند؛ force delete آخرین راه و پرریسک است.

~~~sh
kubectl cordon NODE_NAME
kubectl drain NODE_NAME --ignore-daemonsets
kubectl get nodes
kubectl uncordon NODE_NAME
~~~

این فرمان‌ها را فقط روی node آزمایشی و با فهم اثر اجرا کنید؛ در محیط واقعی runbook provider و workload را دنبال کنید.

## کوییز

1. cordon چه می‌کند؟ — Pod تازه را از آن node زمان‌بندی نمی‌کند.
2. drain چه می‌کند؟ — Podهای قابل‌تخلیه را خارج می‌کند تا node تعمیر شود.
3. چرا drain گیر می‌کند؟ — PDB، local storage یا نبود ظرفیت.
4. بعد از upgrade چه بررسی می‌کنیم؟ — Ready، version، kubelet/runtime، CNI و workload.

## منابع

- [Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)
- [Drain node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)
- [Upgrade cluster](https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/)
- [kubectl drain reference](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_drain/)

</div>