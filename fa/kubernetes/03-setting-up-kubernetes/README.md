<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/03-setting-up-kubernetes/README.md) · [کتابخانهٔ منابع](../references/README.md#03-setting-up-kubernetes)

# فصل 03: راه‌اندازی Kubernetes

## هدف‌های فصل

- کلاستر محلی بسازید و context را با اطمینان تشخیص دهید.
- اولین برنامه را deploy و service آن را بررسی کنید.
- managed و self-managed را از دید مسئولیت و هزینه مقایسه کنید.
- تفاوت محیط آزمایشی و production را مستند کنید.

## مسیر این فصل

1. نصب kubectl و انتخاب ابزار کلاستر محلی.
2. ساخت کلاستر و بررسی nodeها.
3. اعمال Deployment و Service.
4. مشاهدهٔ status، event، log و endpoint.
5. پاک‌کردن منابع و ثبت محدودیت‌های local cluster.

## context ایمنی عملیاتی

kubectl از kubeconfig، context و namespace استفاده می‌کند. context تعیین می‌کند درخواست به کدام کلاستر و با کدام هویت برود. پیش از هر فرمان تغییردهنده، current-context را بررسی کنید. نام namespace اشتباه یا context production می‌تواند اشتباه را پرهزینه کند.

~~~sh
kubectl config get-contexts
kubectl config current-context
kubectl cluster-info
kubectl get nodes
~~~

## managed یا self-managed؟

| موضوع | Managed | Self-managed |
| --- | --- | --- |
| Control plane | provider بخشی از نگهداری را انجام می‌دهد | تیم نصب، HA، backup و upgrade را می‌گیرد |
| Worker | تیم هنوز pool و workload را مدیریت می‌کند | تیم node OS/runtime و چرخهٔ عمر را هم مدیریت می‌کند |
| یکپارچگی cloud | IAM، LoadBalancer و CSI ممکن است آماده‌تر باشند | انعطاف بیشتر، اتصال‌های بیشتری برای نگهداری |
| مسئولیت مشترک | داده، workload، RBAC، هزینه و recovery هنوز با تیم است | تقریباً همهٔ لایه‌های زیرساخت نیز با تیم است |

این مقایسه را با قابلیت‌های فعلی provider، SLA، region، هویت و قیمت جاری بررسی کنید. برای نرخ روز و امکانات جاری به منبع زندهٔ provider مراجعه کنید؛ در این جزوه قیمت ثابت نمی‌دهم.

## تجربهٔ واقعی

استقرار self-managed نیازمند drill برای بازیابی etcd، گواهی‌ها، upgrade و شبکه است. اگر تیم این چرخه‌ها را تمرین نکرده باشد، «کنترل بیشتر» می‌تواند recovery دشوارتر ایجاد کند. نمونهٔ Michelin در گزارش CNCF نشان می‌دهد در مقیاس چندین کلاستر، platform engineering و الگوی مشترک استقرار اهمیت پیدا می‌کند.

## کوییز با پاسخ

1. **context در kubectl چه چیزی را انتخاب می‌کند؟** — کلاستر و هویتی که درخواست با آن ارسال می‌شود؛ namespace هم می‌تواند در context یا فرمان تعیین شود.
2. **کلاستر local برای production مناسب است؟** — معمولاً برای یادگیری و توسعه است؛ production به برنامهٔ دسترس‌پذیری، امنیت، backup، ظرفیت و پشتیبانی نیاز دارد.
3. **آیا Kubernetes مدیریت‌شده مسئولیت برنامه را حذف می‌کند؟** — خیر؛ رفتار workload، داده، دسترسی، هزینه و recovery برنامه همچنان با تیم است.
4. **پیش از فرمان تغییردهندهٔ kubectl چه چیزی را بررسی می‌کنیم؟** — context فعال و namespace هدف.
5. **می‌توان قابلیت و قیمت provider را از یک راهنمای قدیمی فرض کرد؟** — خیر؛ مستند و قرارداد جاری provider را بررسی کنید.
## منابع

- [محیط رسمی یادگیری Kubernetes](https://kubernetes.io/docs/setup/learning-environment/)
- [نسخهٔ فارسی محیط یادگیری](https://kubernetes.io/fa/docs/setup/learning-environment/)
- [محیط‌های production](https://kubernetes.io/docs/setup/production-environment/)
- [گزارش CNCF و تجربهٔ Michelin](https://www.cncf.io/wp-content/uploads/2026/03/cncf_ar25_033126a.pdf)

</div>