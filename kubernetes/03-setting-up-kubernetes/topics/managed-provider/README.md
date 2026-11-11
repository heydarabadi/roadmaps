<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#03-setting-up-kubernetes)

# انتخاب ارائه‌دهندهٔ Managed Kubernetes

**فصل:** [راه‌اندازی Kubernetes](../../README.md)

در Managed Kubernetes، ارائه‌دهنده بخشی از control plane یا عملیات کلاستر را انجام می‌دهد. دامنهٔ این مسئولیت به محصول و حالت انتخابی وابسته است؛ اسم EKS، GKE یا AKS به‌تنهایی نمی‌گوید چه کسی node، network، upgrade، backup یا رخداد را اداره می‌کند. معمولاً تیم برنامه همچنان مالک کد و image، امنیت workload، identity، RBAC، داده، ظرفیت و on-call سرویس است.

## معیارهای مقایسه

1. **Control plane:** دسترس‌پذیری API، SLA، نسخه و مهلت پشتیبانی، patch/upgrade و maintenance window.
2. **Identity:** هویت سازمانی، credential کوتاه‌عمر و جدایی مجوز Cloud IAM از Kubernetes RBAC.
3. **Network:** CNI، IP، DNS، egress/NAT، load balancer، دسترسی خصوصی و network policy.
4. **Storage:** CSI، snapshot، encryption، zone topology، کارایی و reclaim policy.
5. **Node:** node pool یا حالت serverless، autoscaling، سیستم‌عامل، drain، upgrade و GPU.
6. **عملیات:** audit log، metric، alert، پشتیبانی رخداد و مرز مسئولیت.
7. **هزینه:** node، disk، load balancer، IP، ترافیک خروجی، NAT، log، پشتیبانی و زمان تیم.
8. **قابلیت انتقال:** identity، storage، ingress، CNI و مشاهده‌پذیری می‌توانند وابستگی provider بسازند.
9. **انطباق:** region، محل داده، encryption، audit و recovery.

برای مقایسه، یک workload ثابت با تعداد Pod، CPU، حافظه، I/O، egress، log/day، تعداد zone و نیاز backup تعریف کنید. همهٔ providerها را با همان سناریو بسنجید؛ قیمت VM به تنهایی برآورد کل نیست. قیمت و قابلیت منطقه‌ای تغییر می‌کنند، بنابراین در این درس رقم ثابت نمی‌دهیم.

## مثال و چک‌لیست تصمیم

سازمان دارای الزام audit، ابتدا region و دسترسی اپراتور را شرط لازم می‌سازد، سپس هویت، شبکهٔ خصوصی، backup/restore و نگهداری نسخه را مقایسه می‌کند. تیم کوچک می‌تواند control plane را به provider بسپارد، اما باید مالک backup دیتابیس، policy شبکه، alert، upgrade workload و on-call را تعیین کند.

- مسئول خرابی control plane، node، شبکه، برنامه و دیتابیس کیست؟
- API عمومی است یا private؟ admin چطور audit می‌شود؟
- نسخه چه‌وقت پشتیبانی را از دست می‌دهد و upgrade چطور انجام می‌شود؟
- restore واقعی را چه‌وقت آزموده‌ایم؟
- کدام اجزا اختصاصی‌اند و برنامهٔ خروج چیست؟
- هزینهٔ ترافیک خروجی، NAT، LB، disk و نگهداری log چطور حساب می‌شود؟
- چه کسی سلامت workload را هر روز پایش می‌کند؟

## کوییز با پاسخ

1. **Managed یعنی نیازی به SRE نیست؟** خیر؛ workload، داده، شبکه، امنیت و پاسخ incident همچنان owner می‌خواهند.
2. **Kubernetes استاندارد یعنی مهاجرت آسان؟** نه لزوماً؛ هویت، ذخیره‌سازی، load balancer و log ممکن است اختصاصی باشند.
3. **چرا workload مشترک برای قیمت لازم است؟** فرض متفاوت دربارهٔ I/O، egress، log و zone مقایسه را گمراه می‌کند.
4. **چه چیزی دربارهٔ shared responsibility بخوانیم؟** ماتریس مسئولیت، راهنمای عملیاتی رسمی محصول/حالت و سطح پشتیبانی قراردادی.
5. **Provider control plane را نگه می‌دارد؛ آیا دیتابیس هم backup می‌شود؟** نه لزوماً؛ backup کلاستر و دادهٔ برنامه مسئولیت‌های جدا هستند.

## منابع

- [محیط Production Kubernetes](https://kubernetes.io/docs/setup/production-environment/)
- [راهکارهای ابری تأییدشدهٔ Kubernetes](https://kubernetes.io/docs/setup/production-environment/turnkey-solutions/)
- [Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Google Kubernetes Engine](https://docs.cloud.google.com/kubernetes-engine/docs/about)
- [Azure Kubernetes Service](https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts)
- [محیط یادگیری فارسی Kubernetes](https://kubernetes.io/fa/docs/setup/learning-environment/)
- [مسیر یادگیری فارسی Darvag Cloud](https://darvagcloud.com/blog/learning-kubernetes/)

</div>