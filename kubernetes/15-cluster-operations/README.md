<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../references/README.md#15-cluster-operations)

# فصل 15: عملیات کلاستر

## هدف‌های یادگیری

- هزینه و مسئولیت self-managed را با managed مقایسه کنید.
- نقش و ارتقای control plane، etcd و worker node را توضیح دهید.
- drain، upgrade و backup/restore را با برنامهٔ disruption اجرا کنید.
- چندکلاستری را به‌عنوان مرز عملیات بسنجید، نه صرفاً عددی بیشتر از یک.

## مسئولیت روزانه

کلاستر تولیدی فقط API server نیست. تیم باید نسخه و patch، certificate، etcd، control plane HA، node pool، CNI/CSI، DNS، identity، admission، observability، backup، capacity، on-call و disaster recovery را مدیریت کند. Managed service بخشی از control plane را می‌گیرد؛ پاسخ‌گویی workload و داده باقی است.

## چرخهٔ upgrade

Upgrade را با release note، skew policy و سازگاری CNI/CSI/extensionها برنامه‌ریزی کنید. ابتدا backup و restore را تأیید، کلاستر غیرتولیدی را ارتقا، سپس control plane و nodeها را طبق ابزار/provider مرحله‌ای به‌روز کنید. node را cordon/drain کنید، PDB و ظرفیت جایگزین را رعایت و پس از upgrade readiness و add-onها را بررسی کنید.

## etcd و بازیابی

etcd وضعیت API را نگه می‌دارد. backup نامعتبر یا restore تمرین‌نشده بحران را حل نمی‌کند. snapshot، encryption، دسترسی محدود، محل ذخیرهٔ جدا و runbook بازیابی لازم است. دیتابیس‌های workload و PVها backup مستقل می‌خواهند؛ etcd شامل همهٔ دادهٔ volume نیست.

## چندکلاستری

چند cluster می‌تواند محیط، region یا failure domain را جدا کند؛ در عوض identity، DNS، policy، observability، upgrade و replication داده چندگانه می‌شود. context اشتباه هم می‌تواند تغییر را به cluster نامناسب بفرستد. هر cluster باید owner، purpose، version، recovery path و هزینهٔ روشن داشته باشد.

## تجربهٔ واقعی

گزارش سالانهٔ CNCF از 441 برنامه در 62 کلاستر ابری و on-prem برای Michelin می‌گوید؛ صفحهٔ مطالعهٔ موردی CNCF تعداد برنامه‌ها را حدود 450 گزارش می‌کند. هر دو منبع 62 کلاستر را ذکر می‌کنند. این نمونه اهمیت platform engineering و استانداردسازی را نشان می‌دهد؛ برای انتخاب تعداد کلاستر تیم خود، topology و ظرفیت عملیاتی خودتان را مبنا بگیرید.

## کوییز

1. kubeadm چه چیزی را انجام نمی‌دهد؟ — همهٔ provisioning ماشین‌ها و addonها را خودکار مدیریت نمی‌کند.
2. قبل از upgrade چه چیزهایی لازم است؟ — release note، compatibility، backup، staging، drain و rollback plan.
3. چرا etcd snapshot کافی نیست؟ — restore تمرین‌نشده و دادهٔ volume/app را پوشش نمی‌دهد.
4. چند cluster چه پیچیدگی‌هایی می‌آورد؟ — هویت، شبکه، policy، telemetry، upgrade و داده.
5. چرا context را پیش از فرمان بررسی می‌کنیم؟ — تا تغییر به cluster اشتباه اعمال نشود.

## منابع

- [Cluster Administration](https://kubernetes.io/docs/concepts/cluster-administration/)
- [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
- [Upgrade Cluster](https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/)
- [CNCF Annual Report 2025](https://www.cncf.io/wp-content/uploads/2026/03/cncf_ar25_033126a.pdf)

</div>