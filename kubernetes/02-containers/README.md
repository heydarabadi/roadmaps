<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../references/README.md#02-containers-and-images)

# فصل 02: کانتینرها

## هدف‌های فصل

- تفاوت source code، image، container، runtime و registry را توضیح دهید.
- بفهمید Kubernetes چه نقشی در اجرای container دارد و چه چیزی را به runtime واگذار می‌کند.
- یک image کوچک و نسخه‌دار بسازید و خطای pull را عیب‌یابی کنید.
- محدودیت ایزوله‌سازی container را در تصمیم امنیتی لحاظ کنید.

## مدل ذهنی

Image مانند artifact قابل‌انتقال برنامه است؛ container نمونهٔ در حال اجرای آن artifact است. Registry تصویر را نگه می‌دارد و runtime آن را دریافت و process را اجرا می‌کند. Kubernetes از طریق CRI با runtime ارتباط می‌گیرد، اما image را نمی‌سازد. ساخت image معمولاً کار CI است؛ زمان‌بندی و restart کردن Pod کار Kubernetes است.

## زنجیرهٔ build تا اجرا

1. وابستگی و کد را در build context مشخص کنید.
2. Dockerfile یا ابزار build OCI image را تولید می‌کند.
3. image در registry قابل‌دسترسی برای node منتشر می‌شود.
4. Deployment یک image reference ثبت می‌کند.
5. kubelet از runtime می‌خواهد image را pull یا از cache استفاده کند.
6. runtime فرایند را در container راه می‌اندازد؛ kubelet health و exit را گزارش می‌کند.

اگر pull شکست بخورد، بررسی را از event شروع کنید: name/tag، credential، TLS، DNS و دسترسی شبکه. اگر pull موفق و برنامه crash است، command، env، filesystem و log را دنبال کنید.

## image امن‌تر و تکرارپذیرتر

برای انتشار قابل‌ردیابی tag نسخه‌دار یا digest به کار ببرید، artifact را در CI بسازید و آن را اسکن/امضا کنید. image کوچک‌تر pull و سطح بسته‌های آسیب‌پذیر را کاهش می‌دهد، اما خودکار امن نیست. secret را در لایهٔ image یا build argument دائمی نگذارید.

## تمرین

یک image نمونه را اجرا، tag کنید و در manifest به‌روزرسانی نمایید. در کلاستر محلی، نام tag را عمداً غلط کنید و eventهای ImagePullBackOff را بخوانید. سپس نام درست را بازگردانید و تفاوت image pull از container crash را توضیح دهید.

## کوییز با پاسخ

1. **Image و container چه تفاوتی دارند؟** — Image بستهٔ برنامه است؛ container نمونهٔ در حال اجراست که runtime ساخته است.
2. **آیا Kubernetes image می‌سازد؟** — خیر؛ CI یا ابزار build آن را تولید می‌کند و Kubernetes workload را زمان‌بندی و مدیریت می‌کند.
3. **برای ImagePullBackOff از کجا شروع می‌کنیم؟** — Eventهای Pod، سپس نام/tag، دسترسی registry، credential، TLS، DNS و شبکه.
4. **ثبت digest چه فایده‌ای دارد؟** — artifact تغییرناپذیر را دقیق‌تر از tag قابل‌تغییر مشخص می‌کند.
5. **آیا container کرنل جداگانه دارد؟** — معمولاً نه؛ از سازوکارهای ایزوله‌سازی استفاده می‌کند و کرنل میزبان را به‌اشتراک می‌گذارد.
## منابع

- [مستندات رسمی Container Images](https://kubernetes.io/docs/concepts/containers/images/)
- [Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
- [Kubernetes container concepts](https://kubernetes.io/docs/concepts/containers/)
- [منبع فارسی Learn Kubernetes](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>