<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#13-deployment-and-delivery)

# CI/CD Integration

**فصل:** [الگوهای انتشار](../../README.md)

## Build و deploy را جدا کنید

CI کد را validate/test/build می‌کند و artifact تولید می‌کند. CD artifact را به محیط می‌رساند و وضعیت deployment را بررسی می‌کند. artifact یکسان را از dev به staging و production promote کنید؛ در هر مرحله دوباره build متفاوت نسازید، مگر سیاست محصول دلیل داشته باشد.

## Pipeline پیشنهادی

1. lint، unit و integration test.
2. image build با Dockerfile و dependency lock.
3. vulnerability scan، SBOM و provenance.
4. image push با tag نسخه و ثبت digest.
5. render/validate manifest یا Helm.
6. deploy به staging و smoke test.
7. promotion با approval و credential محدود.
8. rollout monitoring و rollback decision.

## هویت و مجوز

CI secret ثابت و cluster-admin ریسک جدی دارد. از credential کوتاه‌عمر، workload identity یا OIDC در صورت پشتیبانی provider و مجوز namespace محدود استفاده کنید. log pipeline نباید token یا secret را چاپ کند. در pipeline، manifest را validate کنید و production context را از محیط آزمایشی جدا سازید.

## تمرین

یک image نسخه‌دار بسازید، digest را در manifest ثبت کنید، در local cluster deploy و rollout status را بررسی کنید. image خراب را در branch آزمایشی امتحان و شکست را بدون دسترسی وسیع CI تشخیص دهید.

## کوییز

1. چرا artifact را بین stageها ثابت نگه می‌داریم؟ — اثبات می‌کنیم همان چیز تست‌شده منتشر شده است.
2. چرا deploy credential را کوتاه‌عمر کنیم؟ — سرقت آن دسترسی بلندمدت به cluster نمی‌دهد.
3. CI موفق یعنی production سالم است؟ — نه؛ provider، dependency، config و ترافیک واقعی متفاوت است.
4. چه چیزی بعد از deploy پایش می‌شود؟ — rollout، health، error/latency و dependencyها.

## منابع

- [Kubernetes Images و pull policy](https://kubernetes.io/docs/concepts/containers/images/)
- [GitHub Actions: Kubernetes deploy](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-kubernetes)
- [SLSA framework](https://slsa.dev/)
- [منبع فارسی CI/CD در EnginDevOps](https://enginedevops.com/)

</div>