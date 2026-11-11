<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../references/README.md#06-configuration-management)

# فصل 06: مدیریت پیکربندی و دادهٔ حساس

## چرا config را از image جدا می‌کنیم؟

یک image باید در محیط توسعه، staging و production یک artifact باشد؛ تفاوت محیط در endpoint، feature flag و credential است. اگر config در image bake شود، برای هر تغییر محیط artifact جدا می‌سازید و همگام‌بودن دشوار می‌شود. Kubernetes ConfigMap و Secret را می‌تواند به‌صورت env یا فایل به Pod بدهد.

## ConfigMap و Secret چه تفاوتی دارند؟

ConfigMap دادهٔ غیرحساس مثل APP_MODE یا URL سرویس را نگه می‌دارد. Secret برای دادهٔ محرمانه طراحی شده، ولی encoding پیش‌فرض base64 رمزنگاری نیست. RBAC، encryption at rest، محدودیت access و rotation همچنان لازم‌اند.

~~~yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-config
data:
  LOG_LEVEL: info
---
apiVersion: v1
kind: Secret
metadata:
  name: web-secret
type: Opaque
stringData:
  API_TOKEN: replace-in-local-lab
~~~

Secret نمونهٔ بالا را به Git commit نکنید. در production از secret manager یا روش رمزگذاری و تحویل امن سازمان استفاده کنید.

## فایل و Environment Variable

ConfigMap/Secret در env هنگام ساخت process خوانده می‌شود؛ تغییر object، env موجود در process را زنده عوض نمی‌کند. Volume projection ممکن است فایل را به‌روزرسانی کند، اما برنامه باید فایل را مجدداً بخواند. بعضی برنامه‌ها تنها با restart config را reload می‌کنند. برای تغییر قابل‌پیش‌بینی، rollout صریح یا checksum annotation در chart/GitOps در نظر بگیرید.

## چرخهٔ secret

Secret rotation را به‌صورت چرخه طراحی کنید: ساخت مقدار جدید، تحویل آن، مصرف برنامه، اعتبارسنجی و سپس لغو مقدار قبلی. اگر process فقط در startup مقدار را می‌خواند، restart و rollout را هماهنگ کنید. log و error نباید مقدار secret را چاپ کنند.

## چک‌لیست عملی

- مقدار غیرمحرمانه را در ConfigMap، محرمانه را در Secret/secret manager بگذارید.
- دسترسی به Secret را براساس service account محدود کنید.
- فایل حاوی credential را از Git، artifact و log دور نگه دارید.
- بدانید mount و env چه زمان تازه می‌شوند.
- تغییر config را با readiness و rollout مشاهده کنید.
- اندازهٔ config را کوچک نگه دارید؛ اشیای حجیم مکان ذخیرهٔ فایل یا دیتابیس نیستند.

## کوییز با پاسخ

1. تغییر ConfigMap چه زمانی به env موجود می‌رسد؟ — خودکار به process فعال نمی‌رسد؛ Pod restart یا reload برنامه لازم است.
2. آیا Secret base64 محرمانگی را تأمین می‌کند؟ — خیر، فقط encoding است.
3. چرا ConfigMap را داخل image نمی‌گذاریم؟ — image یک‌بار ساخته و در محیط‌های مختلف با تنظیم مستقل اجرا می‌شود.
4. چگونه Secret را rotate می‌کنید؟ — مقدار تازه را تحویل دهید، مصرف را تأیید کنید، سپس مقدار قدیمی را revoke کنید.

## منابع

- [Configuration مفاهیم رسمی](https://kubernetes.io/docs/concepts/configuration/)
- [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Secret](https://kubernetes.io/docs/concepts/configuration/secret/)
- [راهنمای فارسی مقدماتی و Secret](https://devna.ir/articles/kubernetes-basics-for-beginners)

</div>