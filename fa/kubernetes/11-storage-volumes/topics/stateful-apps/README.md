<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/11-storage-volumes/topics/stateful-apps/README.md) · [کتابخانهٔ منابع](../../../references/README.md#11-storage-and-volumes)

# برنامه‌های Stateful

**فصل:** [Storage و Volume](../../README.md)

## State از کجا می‌آید؟

برنامه stateful داده یا هویت محلی دارد. برای اجرای امن آن باید storage، consistency، membership، leader election، replication، backup، restore و upgrade را بفهمید. StatefulSet نام ordinal و PVC اختصاصی می‌دهد؛ پروتکل دیتابیس را جایگزین نمی‌کند.

## طراحی عملیات

- معماری replication و quorum را از مستند همان دیتابیس بخوانید.
- failure node، zone و volume را جدا تمرین کنید.
- snapshot crash-consistent با application-consistent را از هم تشخیص دهید.
- backup را در failure domain جدا و ترجیحاً immutable نگه دارید.
- RPO، RTO، retention و روش restore را مشخص کنید.
- upgrade نسخه را مرحله‌ای و rollback داده را جدا طراحی کنید.
- monitoring شامل replication lag، disk usage و backup age باشد.

## مثال

برای PostgreSQL، Pod سالم کافی نیست. باید بدانید primary چگونه انتخاب می‌شود، replica چطور catch up می‌کند، چه کسی backup می‌گیرد، WAL کجا می‌رود و هنگام حذف volume چه recovery path دارید. اگر تیم توان نگهداری این چرخه را ندارد، managed database می‌تواند مناسب‌تر باشد.

## کوییز

1. StatefulSet چه چیزی می‌دهد؟ — هویت و ارتباط volume با replica.
2. چه چیزی همچنان در سطح DB باقی است؟ — consistency، quorum، replication و recovery.
3. PV را از دست دادید؛ چرا snapshot تنها کافی نیست؟ — باید restore و سازگاری snapshot را تمرین کنید.
4. چه معیارهایی برای backup دارید؟ — RPO، RTO، retention و restore drill.

## منابع

- [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [Storage مفاهیم](https://kubernetes.io/docs/concepts/storage/)
- [Kubernetes Volume Snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)

</div>