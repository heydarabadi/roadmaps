<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/15-cluster-operations/topics/multi-cluster/README.md) · [کتابخانهٔ منابع](../../../references/README.md#15-cluster-operations)

# مدیریت چندکلاستری

**فصل:** [عملیات کلاستر](../../README.md)

## چرا چند cluster؟

تیم‌ها cluster جدا برای production و development، region، tenancy یا failure isolation می‌سازند. مرز cluster سطح جداسازی قوی‌تری نسبت به namespace دارد، اما بار هویت، شبکه، GitOps، observability، policy، certificate، upgrade و داده را چند برابر می‌کند.

## طراحی ناوگان

برای هر cluster purpose، owner، region، version، add-on، backup و SLO ثبت کنید. contextها را نام‌گذاری کنید و قبل از فرمان تغییردهنده current-context را ببینید. template مشترک بسازید اما تفاوت محیط را واضح و نسخه‌بندی‌شده نگه دارید.

چند cluster به‌تنهایی failover نیست. برای بازیابی region باید data replication، DNS/traffic shift، credential و تمرین recovery آماده باشد. dependency مشترک control plane management، Git یا identity می‌تواند failure مشترک ایجاد کند.

## عملیات تکرارپذیر

- policy و baseline security را از یک منبع اعمال کنید.
- version skew و upgrade window را به‌صورت ناوگان برنامه‌ریزی کنید.
- telemetry را با label cluster و region هم‌بسته کنید.
- certificate, secret, image registry access را هر cluster کنترل کنید.
- disaster recovery را failover drill کنید، نه فقط manifest copy.

## کوییز

1. چند cluster چه چیزی را بهبود می‌دهد؟ — isolation/failure domain، اگر dependencyها هم جدا باشند.
2. چرا تعداد cluster زیادتر همیشه بهتر نیست؟ — عملیات، drift و cost افزایش می‌یابد.
3. آیا standby cluster بدون data replication failover است؟ — خیر.
4. مهم‌ترین safety check قبل از kubectl؟ — context و namespace.
5. CNCF/Michelin چه درس عمومی دارد؟ — در مقیاس چندکلاستری، platform و automation مشترک لازم می‌شود؛ معماری باید با نیاز تیم تطبیق یابد.

## منابع

- [CNCF Annual Report و تجربهٔ Michelin](https://www.cncf.io/wp-content/uploads/2026/03/cncf_ar25_033126a.pdf)
- [Cluster Administration](https://kubernetes.io/docs/concepts/cluster-administration/)
- [Multi-cluster SIG](https://github.com/kubernetes/community/tree/master/sig-multicluster)

</div>