<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#13-deployment-and-delivery)

# GitOps

**فصل:** [الگوهای انتشار](../../README.md)

## مدل desired state در Git

در GitOps repo، وضعیت مطلوب version control می‌شود. Controller در cluster repo را می‌خواند و تغییر را reconcile می‌کند. این روش تاریخچه، review، audit، drift detection و تکرارپذیری را بهتر می‌کند. Git به‌خودی‌خود runtime state یا Secret را ایمن نمی‌کند.

## اجزای فرایند

- repo برنامه: code، image version و بسته.
- repo محیط: replica، config و policy محیط.
- controller: pull و sync وضعیت مطلوب.
- secret delivery: encryption, external secret manager یا identity.
- observability: sync status، drift، health و alert.

تغییر دستی ممکن است controller بعداً بازنویسی کند. برای incident hotfix، تغییر را به repo برگردانید تا drift دائمی نسازید.

## Rollback و دسترسی

Rollback معمولاً revert commit یا تغییر version است، اما دیتابیس یا پیام خارجی را خودکار برنمی‌گرداند. کنترل branch، approval، signed commit و policy را متناسب با حساسیت محیط تنظیم کنید. دسترسی token repo و cluster controller را جدا و کمینه نگه دارید.

## تمرین

نسخهٔ replicas را از Git تغییر دهید، sync را ببینید، سپس تغییر دستی replica را در کلاستر اعمال کنید و drift را مشاهده کنید. commit را برگردانید و نتیجهٔ reconciliation را بررسی کنید.

## کوییز

1. منبع desired state چیست؟ — repo نسخه‌بندی‌شده.
2. GitOps چه چیزی را تضمین نمی‌کند؟ — صحت برنامه، Secret ایمن یا recovery داده.
3. تغییر دستی در cluster چه می‌شود؟ — ممکن است drift شود و controller آن را reconcile کند.
4. آیا rollback commit دیتابیس را بازمی‌گرداند؟ — خیر؛ schema/data مسیر جدا دارد.

## منابع

- [Argo CD User Guide](https://argo-cd.readthedocs.io/en/stable/user-guide/)
- [Flux documentation](https://fluxcd.io/flux/)
- [Kubernetes Declarative Management](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/)
- [منبع فارسی GitOps](https://enginedevops.com/)

</div>