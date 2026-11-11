<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/glossary/README.md) · [کتابخانهٔ منابع](../references/README.md)

# واژه‌نامهٔ Kubernetes

| English | توضیح فارسی |
| --- | --- |
| Cluster | کلاستر؛ صفحهٔ کنترل به‌همراه گره‌های اجرا |
| Control Plane | مؤلفه‌های API و مدیریت وضعیت کلاستر |
| Node | گرهٔ اجرا؛ ماشین میزبان Pod |
| API Server | درگاه تعامل با منابع Kubernetes |
| etcd | پایگاه ذخیرهٔ وضعیت کلاستر |
| Scheduler | زمان‌بند انتخاب‌کنندهٔ node برای Pod |
| Controller | حلقهٔ اصلاح وضعیت واقعی به مطلوب |
| Reconciliation | همگام‌سازی تکرارشوندهٔ وضعیت‌ها |
| Pod | واحد زمان‌بندی با یک یا چند container |
| Container | فرایند ایزوله با kernel مشترک میزبان |
| Image / Registry | بستهٔ برنامه / مخزن توزیع آن |
| Deployment | مدیریت workload stateless و انتشار |
| ReplicaSet | نگهداری تعداد Pod همسان |
| StatefulSet | workload با هویت یا volume پایدار |
| Job | اجرای کار پایان‌پذیر |
| Service | دسترسی پایدار به endpointها |
| EndpointSlice | فهرست backendهای Service |
| Ingress | مسیریابی HTTP ورودی؛ نیازمند controller |
| CNI / CSI | رابط افزونهٔ شبکه / ذخیره‌سازی |
| ConfigMap / Secret | تنظیم عادی / شیء دادهٔ حساس |
| Namespace | جداسازی منطقی منابع |
| RBAC | مجوزدهی مبتنی بر نقش |
| Request / Limit | منبع موردنیاز / سقف مصرف container |
| Probe | بررسی آمادگی یا سلامت |
| Readiness / Liveness | آمادگی دریافت ترافیک / زنده‌بودن |
| HPA / VPA | مقیاس افقی Pod / اندازهٔ منابع Pod |
| GitOps | همگام‌سازی وضعیت با تعریف نسخه‌بندی‌شده در Git |
| CRD / Operator | نوع API سفارشی / الگوی controller تخصصی |
| Eviction / PDB | تخلیهٔ Pod / محدودکردن disruption داوطلبانه |
| Rollout / Rollback | انتشار نسخه / بازگشت نسخه؛ نه لزوماً داده |
| Observability | فهم سیستم با logs، metrics و traces |

## منابع

- [واژه‌نامهٔ رسمی Kubernetes](https://kubernetes.io/docs/reference/glossary/)
- [مفاهیم رسمی Kubernetes](https://kubernetes.io/docs/concepts/)

</div>