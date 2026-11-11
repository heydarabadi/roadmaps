<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#12-scheduling)

# مبانی Scheduling

**فصل:** [Scheduling](../../README.md)

## filter و score

Scheduler برای Pod بدون node ابتدا nodeهای ناسازگار را فیلتر می‌کند، سپس از گزینه‌های باقی‌مانده node مناسب‌تر را انتخاب می‌کند. request منابع، node condition، affinity، taint، topology و volume binding اثر دارند. انتخاب scheduler ضمانت نمی‌کند برنامه بعداً سالم بماند.

~~~sh
kubectl get pods
kubectl describe pod demo
kubectl get nodes
kubectl describe node NODE_NAME
~~~

اگر Pod Pending است، بخش Events علت مستقیم‌تری از حدس می‌دهد: Insufficient cpu، taint، PVC، node selector یا quota. request را کم‌کردن بدون بررسی نیاز واقعی ممکن است Pod را زمان‌بندی کند ولی ناپایداری اجرا بسازد.

## قید و اولویت

nodeSelector و required affinity محدودیت سخت‌اند؛ preferred affinity فقط ترجیح است. روی node labelها و سیاست ownership توافق کنید. تغییر label/selector ممکن است workloadهای دیگر را تحت‌تأثیر قرار دهد.

## کوییز

1. Pod Pending یعنی scheduler خراب است؟ — نه؛ ممکن است هیچ node واجد شرایطی وجود نداشته باشد.
2. چه چیزی placement resource را تعیین می‌کند؟ — عمدتاً request، نه limit یا مصرف لحظه‌ای.
3. preferred affinity چه تفاوتی دارد؟ — اگر انتخاب ممکن نباشد الزاماً Pod را متوقف نمی‌کند.
4. چرا event مهم است؟ — علت عدم زمان‌بندی را ثبت می‌کند.

## منابع

- [Scheduling مفاهیم](https://kubernetes.io/docs/concepts/scheduling-eviction/)
- [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- [Resource Requests and Limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

</div>