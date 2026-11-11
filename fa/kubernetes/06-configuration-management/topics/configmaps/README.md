<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/06-configuration-management/topics/configmaps/README.md) · [کتابخانهٔ منابع](../../../references/README.md#06-configuration-management)

# ConfigMap

**فصل:** [مدیریت پیکربندی](../../README.md)

## ساختار و مصرف

ConfigMap key/value غیرمحرمانه را ذخیره می‌کند. می‌توان مقدار را با env، envFrom یا volume به Pod رساند. انتخاب به شکل config و روش reload برنامه بستگی دارد.

~~~yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  LOG_LEVEL: info
  app.yaml: |
    retries: 3
    timeout: 2s
~~~

~~~yaml
envFrom:
- configMapRef:
    name: app-config
volumeMounts:
- name: config-files
  mountPath: /etc/app
volumes:
- name: config-files
  configMap:
    name: app-config
~~~

در نمونهٔ دوم، کلید app.yaml به فایل تبدیل می‌شود. برنامه باید مسیر را بخواند؛ متغیر محیطی و فایل config تفاوت semantics دارند.

## تغییر config و rollout

تغییر env داخل process فعال رخ نمی‌دهد. فایل mount شده می‌تواند پس از تأخیر به‌روز شود، اما برنامه شاید لازم باشد آن را دوباره بخواند. برای رفتار deterministic، نسخه‌گذاری config یا checksum annotation در Pod template را به کار ببرید تا تغییر config rollout ایجاد کند. دادهٔ حساس را در ConfigMap نگذارید.

## عیب‌یابی

- Pod شروع نمی‌شود: ConfigMap ناموجود یا key لازم وجود ندارد.
- برنامه مقدار قدیمی دارد: env فقط در startup خوانده شده یا برنامه فایل را reload نکرده.
- فایل path اشتباه است: mountPath و subPath را بررسی کنید.
- config غیرقابل‌خواندن است: mode و user برنامه را بسنجید.

## کوییز

1. ConfigMap برای چه نوع داده‌ای است؟ — تنظیم غیرحساس.
2. env value چه زمان خوانده می‌شود؟ — زمان شروع process/container.
3. چه چیزی rollout جدید می‌سازد؟ — تغییر Pod template؛ ConfigMap update به‌تنهایی الزاماً آن را تغییر نمی‌دهد.
4. config حجیم را کجا می‌گذاریم؟ — فایل artifact یا storage مناسب، نه ConfigMap نامحدود.

## منابع

- [ConfigMap رسمی](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [تنظیم Pod با ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)
- [آموزش فارسی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)

</div>