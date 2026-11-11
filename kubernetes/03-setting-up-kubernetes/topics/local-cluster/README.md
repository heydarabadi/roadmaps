<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#03-setting-up-kubernetes)

# ساخت کلاستر محلی

**فصل:** [راه‌اندازی Kubernetes](../../README.md)

## چرا محلی؟

کلاستر محلی برای یادگیری API و manifest ارزان و دورریختنی است. می‌توانید Pod خراب بسازید و دوباره از صفر شروع کنید. اما شبکهٔ cloud، load balancer، CSI واقعی، HA control plane، quota، IAM و رفتار failure بین zoneها را دقیق بازنمایی نمی‌کند.

## kind و minikube

- **kind** کلاستر node را در container اجرا می‌کند؛ برای تست manifest، CI و چند node محلی مفید است.
- **minikube** یک محیط محلی چندحالته با driverهای مختلف دارد و افزونه‌های تمرینی ارائه می‌کند.
- Kubernetes Desktopها استفاده را ساده می‌کنند، اما منابع لازم و مدل network/storage را بررسی کنید.

انتخاب ابزار تابع OS، دسترسی container runtime، منابع لپ‌تاپ و هدف lab است. دستور نصب را از مستند رسمی همان ابزار بگیرید؛ نصب‌ها و گزینه‌ها با نسخه تغییر می‌کنند.

## چرخهٔ ساخت و پاک‌کردن kind

~~~sh
kind create cluster --name learn
kubectl config current-context
kubectl get nodes
kubectl cluster-info
kind delete cluster --name learn
~~~

قبل از delete context را ببینید؛ پاک‌کردن cluster همهٔ منابع محلی آن را از بین می‌برد. برای تمرین چندکلاستری، نام contextها را واضح نگه دارید.

## گام‌های آمادگی

- kubectl نصب و نسخهٔ client/server را بررسی کنید.
- برای imageهای محلی، مشخص کنید node چطور آن را می‌بیند؛ ممکن است لازم باشد image را به kind بارگذاری کنید.
- RAM، CPU و فضای disk کافی اختصاص دهید.
- kubeconfigهای شخصی را در repository قرار ندهید.
- بعد از lab، namespace و cluster آزمایشی را پاک کنید.

## محدودیت‌های مهم

Service نوع LoadBalancer ممکن است در کلاستر محلی IP نگیرد؛ افزونه یا tunnel لازم می‌شود. StorageClass پیش‌فرض ممکن است hostPath یا driver ساده داشته باشد. success در local test فقط صحت بخشی از manifest و API را نشان می‌دهد، نه آمادگی production.

## کوییز تشریحی

1. چرا کلاستر محلی برای یادگیری خوب است؟ — ساخت/پاک‌سازی سریع و ریسک کم دارد.
2. چرا معادل staging نیست؟ — failure domain، provider integration، ذخیره و شبکه متفاوت‌اند.
3. اگر image محلی pull نمی‌شود چه مسئله‌ای را اول می‌سنجید؟ — image داخل cache/registry قابل‌دسترسی node هست یا نه.
4. پیش از حذف cluster چه چیزی باید بررسی شود؟ — current context و اینکه منابع مهمی روی cluster نباشد.

## منابع

- [محیط یادگیری رسمی Kubernetes](https://kubernetes.io/docs/setup/learning-environment/)
- [راهنمای فارسی محیط یادگیری](https://kubernetes.io/fa/docs/setup/learning-environment/)
- [Kind Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Minikube Start](https://minikube.sigs.k8s.io/docs/start/)

</div>