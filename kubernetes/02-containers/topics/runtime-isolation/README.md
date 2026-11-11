<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#02-containers-and-images)

# Runtime و ایزوله‌سازی کانتینر

**فصل:** [کانتینرها](../../README.md)

## لایه‌ها را جدا کنید

Kubernetes API با Pod کار می‌کند؛ kubelet روی node وضعیت Pod را دنبال می‌کند؛ CRI قرارداد ارتباط kubelet با container runtime است؛ runtimeهایی مانند containerd image را آماده و container را اجرا می‌کنند. CNI شبکه را فراهم می‌کند و CSI volume را وصل می‌کند. این مرزها برای عیب‌یابی اهمیت دارند: خطای image الزاماً خطای Deployment نیست.

## Container ماشین مجازی کامل نیست

Container processهای ایزوله روی kernel میزبان است. Linux namespaces دید فرایندها، شبکه و mount را جدا می‌کنند؛ cgroups میزان CPU و حافظه را محدود و حساب می‌کنند. اما kernel مشترک است. VM معمولاً kernel مهمان جدا دارد. پس پیکربندی privilege و آسیب‌پذیری kernel/runtime روی سطح خطر اثر می‌گذارد.

در Pod از securityContext برای non-root، حذف capability غیرضروری، read-only root filesystem یا seccomp استفاده کنید. مقدار مناسب به image و نیاز واقعی برنامه وابسته است؛ آزمایش کنید که برنامه فایل یا پورت لازم را دارد.

## عیب‌یابی لایه‌ای

- فرایند در حال crash: kubectl logs و logs قبلی را بخوانید.
- فرمان یا filesystem: در محیط امن kubectl exec، command و مسیر فایل را بررسی کنید.
- image آماده نمی‌شود: Pod event، registry و credential را بررسی کنید.
- مشکل فقط روی یک node رخ می‌دهد: condition و eventهای node، runtime و kubelet را بررسی کنید.
- شبکه یا mount: رویدادهای CNI/CSI و وضعیت node را دنبال کنید.

دسترسی node-level معمولاً privilege بالاست؛ از آن برای هر خطای برنامه استفاده نکنید.

## مثال و کوییز

1. آیا container kernel خودش را دارد؟ — نه؛ kernel میزبان را به‌اشتراک می‌گذارد.
2. چه چیزی process را در node اجرا می‌کند؟ — runtime با هماهنگی kubelet و CRI.
3. cgroups چه می‌کند؟ — مصرف منابع را دسته‌بندی و محدود می‌کند.
4. چرا root بودن داخل container مهم است؟ — در ترکیب با misconfiguration می‌تواند پیامد نفوذ را بیشتر کند.
5. وقتی یک Pod crash می‌کند از کدام لایه شروع می‌کنید؟ — status، event و log؛ سپس فقط بر اساس شواهد به runtime/node می‌روید.

## منابع

- [Container Runtime Interface](https://kubernetes.io/docs/concepts/containers/cri/)
- [مفهوم Container Runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
- [Pod Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- [منبع فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>