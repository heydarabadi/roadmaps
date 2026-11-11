<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#13-deployment-and-delivery)

# Helm Charts

**فصل:** [الگوهای انتشار](../../README.md)

## Chart چیست؟

Chart بسته‌ای از template و metadata برای ایجاد resourceهای Kubernetes است. values تفاوت محیط را تعریف می‌کند؛ release یک نصب/نسخهٔ chart در cluster است. Helm manifest را render و مدیریت release را فراهم می‌کند، اما ساختار chart را خودکار ایمن یا درست نمی‌کند.

## چرخهٔ کار

~~~sh
helm lint ./chart
helm template shop ./chart -f values-staging.yaml
helm upgrade --install shop ./chart -n shop --create-namespace
helm history shop -n shop
helm rollback shop 2 -n shop
~~~

پیش از نصب، خروجی renderشده را بازبینی کنید: image، privilege، RBAC، Secret، resource، selector و service port. chart dependency را pin و نسخهٔ chart را نگه دارید.

## الگوی values

پیش‌فرض‌ها باید امن و قابل‌فهم باشند. Secret را به‌صورت متن در values.yaml یا Git نگذارید. values مشترک و overlay محیطی را طوری تنظیم کنید که production به‌اشتباه با مقدار توسعه منتشر نشود. تغییر chart version و app image را از هم تفکیک کنید.

## دام‌ها

- نصب chart ناشناخته از registry.
- استفاده از template logic پیچیده و سخت‌تست.
- فرض rollback Helm تغییر دیتابیس را بازمی‌گرداند.
- فراموش‌کردن منابع قبلی در upgrade و نام release.
- chart ناسازگار با API نسخهٔ cluster.

## کوییز

1. Chart و release چه تفاوتی دارند؟ — chart package؛ release نصب/نمونهٔ آن در cluster.
2. چرا helm template اجرا می‌کنیم؟ — خروجی YAML را قبل از تغییر cluster ببینیم.
3. آیا rollback Helm اثر migration را خنثی می‌کند؟ — خیر.
4. values حاوی Secret را کجا می‌گذاریم؟ — سازوکار امن secret management، نه repo plaintext.

## منابع

- [Helm Docs](https://helm.sh/docs/)
- [Helm Chart Best Practices](https://helm.sh/docs/chart_best_practices/)
- [منبع فارسی EnginDevOps](https://enginedevops.com/)

</div>