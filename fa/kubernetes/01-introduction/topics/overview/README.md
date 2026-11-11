<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/01-introduction/topics/overview/README.md) · [کتابخانهٔ منابع](../../../references/README.md#01-introduction-and-mental-model)

# مرور کلی Kubernetes

**فصل:** [مقدمه و مدل ذهنی](../../README.md)

## هدف یادگیری

بتوانید معماری control plane و worker، نقش API و کنترلرها، و مسیر ساخته‌شدن یک Pod را توضیح دهید.

## ایدهٔ اصلی

Kubernetes ارکستراتور container نیست به این معنا که فقط یک فرمان اجرا کند؛ API مشترکی برای توصیف workload و control loopهایی برای مدیریت چرخهٔ اجرا فراهم می‌کند. کلاستر شامل صفحهٔ کنترل و nodeهای اجراست. کاربر از API درخواست می‌کند، اما مؤلفه‌های مختلف به شکل غیرهم‌زمان آن درخواست را به اجرا می‌رسانند.

### Control plane

- **API Server** درگاه خواندن و نوشتن منابع است و احراز هویت، مجوز، اعتبارسنجی و admission را اجرا می‌کند.
- **etcd** وضعیت ماندگار API را ذخیره می‌کند. پشتیبان‌گیری و حفاظت از آن حیاتی است.
- **Scheduler** Podهای بدون node را با توجه به درخواست منابع، محدودیت‌ها و وضعیت nodeها جایابی می‌کند.
- **Controller manager** کنترلرهای داخلی را اجرا می‌کند؛ هر کنترلر یک نوع وضعیت را دنبال می‌کند.

### Node اجرا

- **kubelet** وضعیت Podهای اختصاص‌یافته به node را پیگیری می‌کند.
- **Container runtime** مانند containerd image را آماده و container را اجرا می‌کند.
- افزونهٔ شبکه و storage به ترتیب اتصال شبکه و mount volume را فراهم می‌کنند.

## مسیر واقعی درخواست

~~~text
kubectl → API Server → ذخیرهٔ شیء → Deployment controller
→ ReplicaSet → Pod → Scheduler → kubelet/runtime → container
~~~

این مسیر یک تراکنش واحد و هم‌زمان نیست. ممکن است Deployment موجود باشد ولی Pod هنوز ساخته نشده باشد؛ Pod ساخته شود ولی Pending بماند؛ container اجرا شود اما readiness آن شکست بخورد.

## تمرین عملی

~~~sh
kubectl get nodes
kubectl get pods -A
kubectl get componentstatuses
~~~

فرمان آخر در برخی نسخه‌ها deprecated یا غیرقابل اتکا است؛ برای سلامت اجزای امروزی از روش‌های مستند provider یا kubeadm و متریک‌های control plane استفاده کنید. روی کلاستر محلی، یک Pod را حذف کنید و رویدادها و وضعیت Deployment را پیش و پس از حذف مقایسه کنید.

## چگونه یک مفهوم را از دیگری جدا کنیم؟

| واژه | پرسشی که پاسخ می‌دهد |
| --- | --- |
| Cluster | کدام منابع تحت یک API و control plane هستند؟ |
| Node | workload روی کدام ماشین اجرا می‌شود؟ |
| Pod | کدام واحد با هم زمان‌بندی و شبکهٔ مشترک دارد؟ |
| Controller | چه کسی تعداد/وضعیت مطلوب را پیگیری می‌کند؟ |
| Service | مصرف‌کننده چگونه مجموعه‌ای از Podهای قابل‌تغییر را پیدا می‌کند؟ |

## خطایابی مرحله‌ای

اگر Pod اجرا نمی‌شود، ابتدا get برای وضعیت، بعد describe برای eventها، سپس logs برای خطای برنامه را بخوانید. برای Pod بدون node، event زمان‌بندی و ظرفیت مهم است؛ برای image pull، دسترسی registry؛ برای process در حال crash، فرمان، config و log. سراغ تغییر cluster-wide نروید تا لایهٔ مشکل معلوم شود.

## کوییز با پاسخ تشریحی

1. کدام مؤلفه node را برای Pod انتخاب می‌کند؟ — Scheduler، پس از آنکه controller Pod را ایجاد و API ثبت کرده باشد.
2. آیا API Server خودش container را اجرا می‌کند؟ — خیر؛ API شیء را می‌پذیرد و kubelet/runtime روی node فرایند را اجرا می‌کند.
3. چرا ممکن است Pod در API دیده شود ولی برنامه پاسخ ندهد؟ — هنوز زمان‌بندی یا اجرا نشده، readiness ناموفق است، شبکه مشکل دارد یا خود برنامه خطا دارد.
4. اگر control plane هدف replica را ببیند ولی nodeها ظرفیت نداشته باشند چه رخ می‌دهد؟ — Pod در Pending می‌ماند و event علت جایابی را نشان می‌دهد؛ تنظیم replica به تنهایی ظرفیت نمی‌سازد.

## منابع

- [Cluster Architecture رسمی](https://kubernetes.io/docs/concepts/architecture/)
- [اجزای Kubernetes](https://kubernetes.io/docs/concepts/overview/components/)
- [مستند فارسی محیط یادگیری](https://kubernetes.io/fa/docs/setup/learning-environment/)
- [DevNA: مقدمهٔ Kubernetes](https://devna.ir/articles/kubernetes-basics-for-beginners)

</div>