<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/06-configuration-management/topics/secrets/README.md) · [کتابخانهٔ منابع](../../../references/README.md#06-configuration-management)

# Secret و مدیریت credential

**فصل:** [مدیریت پیکربندی](../../README.md)

## Secret چیست و چه نیست؟

Secret منبع API برای نگهداری دادهٔ حساس است تا credential را مثل تنظیم عادی در ConfigMap پخش نکنیم. مقدار معمول در manifest می‌تواند base64 باشد؛ این رمزنگاری نیست. حفاظت به encryption at rest، کنترل دسترسی API، امنیت etcd، کنترل node و نحوهٔ mount وابسته است.

~~~sh
kubectl create secret generic api-auth --from-file=TOKEN=./token.txt -n shop
kubectl get secret api-auth -n shop
~~~

برای دیدن مقدار Secret از فرمان‌های decode استفاده نکنید مگر در محیط مجاز و نیاز مشخص؛ terminal history و log نیز می‌تواند داده را افشا کند.

## کنترل‌های امنیتی

- service account هر workload را جدا کنید؛ فقط namespace و key لازم را بدهید.
- Secret را در image، Git، build log و chat/issue قرار ندهید.
- encryption at rest را برای etcd پیکربندی کنید.
- در صورت امکان secret manager و credential کوتاه‌عمر را انتخاب کنید.
- فقط containerهای لازم را به volume دسترسی دهید.
- rotation، revoke، audit و response به افشا را مستند کنید.
- backup etcd را نیز حساس و رمزگذاری‌شده نگه دارید؛ backup می‌تواند شامل Secret باشد.

## تزریق و rotation

Secret را env یا volume کنید. متغیر env در process فعال خودبه‌خود عوض نمی‌شود. فایل mountشده ممکن است به‌روز شود، اما برنامه باید دوباره بخواند. برای rotation ممکن است rollout لازم باشد. مقدار جدید را قبل از لغو مقدار قبلی validate کنید تا قطعی auth ایجاد نشود.

## عیب‌یابی

اگر container secret را نمی‌بیند، namespace، نام object، key، volumeMount و file permission را بررسی کنید. اگر مقدار قدیمی است، معلوم کنید برنامه env را در start می‌خواند یا فایل را reload می‌کند. credential را برای رفع سریع در YAML یا command line ثبت نکنید.

## کوییز تشریحی

1. Secret base64 چه می‌کند؟ — داده را encode می‌کند، نه encrypt.
2. چرا هر workload نباید همهٔ Secretها را بخواند؟ — دسترسی گسترده دامنهٔ افشای credential را زیاد می‌کند.
3. هنگام rotation چه ترتیب امنی دارید؟ — ساخت مقدار جدید، تحویل، آزمون، سپس revoke مقدار قدیمی.
4. چرا backup etcd حساس است؟ — می‌تواند کپی Secretهای cluster را در خود داشته باشد.

## منابع

- [Secrets رسمی Kubernetes](https://kubernetes.io/docs/concepts/configuration/secret/)
- [رمزنگاری داده در حال استراحت](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)
- [راهنمای فارسی Secret در DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)
- [مستندات رسمی RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

</div>