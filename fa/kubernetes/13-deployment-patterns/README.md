<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/13-deployment-patterns/README.md) · [کتابخانهٔ منابع](../references/README.md#13-deployment-and-delivery)

# فصل 13: الگوهای انتشار و تحویل

## هدف‌های یادگیری

- CI را از استقرار و promotion محیط‌ها جدا کنید.
- GitOps و Helm را برای مسئلهٔ مناسب به‌کار ببرید.
- rolling update، Canary و Blue-Green را با readiness و معیار سلامت طراحی کنید.
- rollback نرم‌افزار را از recovery داده و schema تفکیک کنید.

## زنجیرهٔ artifact تا production

1. CI کد را آزمایش، image را build و dependency را اسکن می‌کند.
2. image immutable با نسخه یا digest ثبت می‌شود.
3. manifest یا Helm chart نسخه‌دار می‌شود.
4. تغییر با بازبینی به محیط staging می‌رود.
5. smoke/integration check و telemetry نسخه را می‌سنجد.
6. promotion به production با هویت محدود و audit انجام می‌شود.
7. rollback به artifact/تعریف قبلی امکان‌پذیر و تمرین‌شده است.

Pipeline نباید credential دائمی cluster-admin داشته باشد. credential کوتاه‌عمر، OIDC یا service identity امن و مجوز namespace محدود را بررسی کنید.

## GitOps و Helm

GitOps repo را منبع وضعیت مطلوب می‌گیرد و controller drift را reconcile می‌کند. Helm قالب و بستهٔ منابع Kubernetes می‌دهد؛ chart قابل‌اعتماد را version کنید و خروجی renderشده را بازبینی کنید. این ابزارها جای کیفیت manifest، مدیریت Secret و فهم resourceها را نمی‌گیرند.

## انتخاب استراتژی انتشار

- **RollingUpdate:** نسخه‌ها مدتی هم‌زمان‌اند؛ ظرفیت اضافه و schema سازگار لازم است.
- **Canary:** درصد کمی ترافیک را به نسخهٔ تازه می‌دهد؛ metric و controller traffic-split لازم است.
- **Blue-Green:** محیط تازه را جدا آماده و route را جابه‌جا می‌کند؛ ظرفیت دو محیط و state مشترک را مدیریت کنید.
- **Recreate:** قبلی را متوقف و سپس جدید را بالا می‌آورد؛ ممکن است downtime دهد.

هیچ strategy rollback داده را تضمین نمی‌کند. migration را backward-compatible و rollback را operationally tested طراحی کنید.

## کوییز

1. CI چه چیزی تولید می‌کند؟ — artifact آزمایش‌شده و نسخه‌دار.
2. GitOps چه چیزی را همگام می‌کند؟ — وضعیت واقعی cluster با تعریف desired state در Git.
3. Helm امنیت chart را تضمین می‌کند؟ — خیر؛ template و permission را بازبینی کنید.
4. Canary برای چیست؟ — آزمایش محدود نسخهٔ تازه با معیار توقف.
5. چرا rollout و database migration باید جدا طراحی شوند؟ — داده و schema با rollback کد به حالت قبلی برنمی‌گردند.

## تجربهٔ واقعی

Netflix دربارهٔ Kueue و مدیریت batch compute تجربهٔ ظرفیت/صف خود را شرح می‌دهد. برای این فصل نیز از آن می‌توان درس گرفت که rollout و batch هر دو به مدیریت ظرفیت و fair sharing نیاز دارند؛ ابزار خاص باید با مقیاس سازمان سنجیده شود.

## منابع

- [Deployment و rollout](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Helm documentation](https://helm.sh/docs/)
- [Argo CD User Guide](https://argo-cd.readthedocs.io/en/stable/user-guide/)
- [Argo Rollouts](https://argo-rollouts.readthedocs.io/en/stable/)
- [منبع فارسی EnginDevOps](https://enginedevops.com/)

</div>