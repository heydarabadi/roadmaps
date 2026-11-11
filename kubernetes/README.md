<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](references/README.md)

# راهنمای جامع و خودآموز Kubernetes

این دوره بر پایهٔ [نقشهٔ راه Kubernetes در roadmap.sh](https://roadmap.sh/kubernetes) است و فهرست فصل‌ها و زیرموضوع‌هایش با [PDF سرفصل‌های نقشهٔ راه](https://roadmap.sh/pdfs/roadmaps/kubernetes.pdf) تطبیق داده شده است. تمام موضوع‌های آن صفحه در این پوشه درس مستقل دارند و به فارسی، همراه با توضیح، مثال، تمرین و کوییز گسترش یافته‌اند. هدف این است که مسیر اصلی یادگیری Kubernetes را از همین‌جا دنبال کنید، مثال‌ها را در کلاستر آزمایشی انجام دهید و برای خطاهای رایج روش عیب‌یابی داشته باشید.

منابع بیرونی انتهای درس‌ها برای مراجعه به مرجع رسمی API، بررسی جزئیات نسخهٔ جاری و مطالعهٔ تکمیلی‌اند. مفهوم و مثال آموزشی در خود درس آمده است. نسخهٔ Kubernetes، رفتار افزونه‌ها و سرویس‌های ابری تغییر می‌کند؛ برای تصمیم وابسته به نسخه، مرجع رسمی همان موضوع را نیز بررسی کنید.

## روش استفاده

1. فصل‌ها را به‌ترتیب بخوانید. فصل‌های 01 تا 03 تصویر کلی، کانتینر و آماده‌سازی کلاستر را پوشش می‌دهند.
2. توضیح و مثال را بخوانید، سپس manifest و فرمان‌ها را در کلاستر آزمایشی اجرا کنید.
3. پیش از هر فرمان تغییردهنده، context و namespace را بررسی کنید.
4. کوییز را بدون نگاه‌کردن به پاسخ حل کنید و دلیل پاسخ را بخوانید.
5. آزمایشگاه پایانی را هم‌زمان انجام دهید؛ رویداد، لاگ و نتیجهٔ کاربر را ثبت کنید.

## فهرست فصل‌ها

| فصل | موضوع | پوشه |
| --- | --- | --- |
| 01 | آشنایی، انگیزه، واژگان و گزینه‌های جایگزین | [01-introduction](01-introduction/README.md) |
| 02 | کانتینرها و پیش‌نیازهای آن‌ها | [02-containers](02-containers/README.md) |
| 03 | راه‌اندازی کلاستر و اولین برنامه | [03-setting-up-kubernetes](03-setting-up-kubernetes/README.md) |
| 04 | اجرای برنامه‌ها و انواع workload | [04-running-applications](04-running-applications/README.md) |
| 05 | سرویس‌ها و شبکه | [05-services-networking](05-services-networking/README.md) |
| 06 | مدیریت پیکربندی و دادهٔ حساس | [06-configuration-management](06-configuration-management/README.md) |
| 07 | درخواست، محدودیت و بهینه‌سازی منابع | [07-resource-management](07-resource-management/README.md) |
| 08 | امنیت کلاستر و workload | [08-security](08-security/README.md) |
| 09 | مشاهده‌پذیری، لاگ، معیار و ردگیری | [09-monitoring-logging](09-monitoring-logging/README.md) |
| 10 | مقیاس‌پذیری افقی، عمودی و کلاستر | [10-autoscaling](10-autoscaling/README.md) |
| 11 | ذخیره‌سازی و workloadهای stateful | [11-storage-volumes](11-storage-volumes/README.md) |
| 12 | زمان‌بندی، اولویت و تخلیهٔ Pod | [12-scheduling](12-scheduling/README.md) |
| 13 | CI/CD، GitOps، Helm و انتشار تدریجی | [13-deployment-patterns](13-deployment-patterns/README.md) |
| 14 | CRD، کنترلر و توسعهٔ Kubernetes | [14-advanced-topics](14-advanced-topics/README.md) |
| 15 | عملیات کلاستر و چندکلاستری | [15-cluster-operations](15-cluster-operations/README.md) |

هر فصل صفحهٔ آموزشی دارد و هر گرهٔ نقشهٔ راه در پوشهٔ topics همان فصل README مستقل خود را دارد.

## پس از مطالعه می‌توانید

- رابطهٔ control plane، node، Pod، controller و API را توضیح دهید و desired state را از وضعیت جاری تشخیص دهید.
- workload را مستقر کنید، به Service وصل کنید و پیکربندی را از image جدا نگه دارید.
- دسترسی و منابع را محدود کنید، ذخیره‌سازی را متصل کنید و autoscaling را بر اساس سیگنال مناسب طراحی کنید.
- با probe، event، log، metric و trace خطاهایی مانند ImagePullBackOff، Pending، CrashLoopBackOff و نبود endpoint را عیب‌یابی کنید.
- انتشار، rollback، GitOps، نگهداری node و upgrade را با توجه به ظرفیت و خطر داده برنامه‌ریزی کنید.
- تشخیص دهید کجا قابلیت native کافی است و چه زمانی افزونه یا provider لازم می‌شود.

## ابزارهای کمک‌مطالعه

- [واژه‌نامهٔ انگلیسی–فارسی](glossary/README.md)
- [آزمایشگاه پایانی قدم‌به‌قدم](labs/capstone/README.md)

## منابع مبنا و تجربه‌های منتشرشده

- [Kubernetes roadmap](https://roadmap.sh/kubernetes) و [PDF سرفصل‌ها](https://roadmap.sh/pdfs/roadmaps/kubernetes.pdf).
- [مستندات مفهومی رسمی Kubernetes](https://kubernetes.io/docs/concepts/) و [محیط یادگیری فارسی](https://kubernetes.io/fa/docs/setup/learning-environment/).
- منابع فارسی منتخب: [DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)، [Darvag Cloud](https://darvagcloud.com/blog/learning-kubernetes/) و [دورهٔ EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa).
- نمونه‌های دنیای واقعی در فصل‌های مربوط آمده‌اند: [مطالعهٔ موردی Michelin در CNCF](https://www.cncf.io/case-studies/michelin/) دربارهٔ پلتفرم Michelin و [تجربهٔ Netflix دربارهٔ Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c).

</div>