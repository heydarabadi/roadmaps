<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#13-deployment-and-delivery)

# استقرار Blue-Green

**فصل:** [الگوهای انتشار و تحویل](../../README.md)  
**درس کامل همراه با مقایسه و آزمایشگاه:** [Canary و Blue-Green](../canary-bluegreen/README.md)

## مدل ذهنی

دو stack یا دو مجموعهٔ Pod می‌سازیم. **Blue** نسخهٔ فعلی و متصل به ترافیک اصلی است. **Green** نسخهٔ جدید است که بالا می‌آید و جداگانه با smoke/integration test بررسی می‌شود. پس از آمادگی، route ورودی را به Green می‌بریم. اگر مشکل رخ دهد، مسیر را دوباره به Blue بازمی‌گردانیم، به شرط حفظ نسخهٔ قبلی و سازگاری داده.

این روش مسیر پیش‌نمایش واضح و سوئیچ قابل‌کنترل دارد. برای مدتی هر دو نسخه منابع می‌خواهند و سوئیچ routing، sessionهای باز یا schema دیتابیس را خودکار برنمی‌گرداند.

## پیاده‌سازی ساده با Service

Deploymentها باید labelهای یکسان برای برنامه و label جدا برای رنگ داشته باشند. Service اصلی در ابتدا فقط blue را انتخاب می‌کند:

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  selector:
    app: web
    track: blue
  ports:
    - port: 80
      targetPort: 8080
~~~

نسخهٔ Green را با track=green اجرا کنید و یک Service preview مستقل بسازید. پس از تأیید آن، manifest Service اصلی را به track=green تغییر دهید و با kubectl apply اعمال کنید. EndpointSlice را بررسی کنید تا مطمئن شوید مقصدهای جدید آماده‌اند. برای بازگشت، selector را به blue برگردانید، اگر Blue همچنان سالم و سازگار است.

برای اجرای واقعی image باید tag یکتا/تغییرناپذیر، resource، readiness probe، پیکربندی و secret لازم داشته باشد. preview را عمومی رها نکنید؛ ممکن است نسخهٔ آزمایشی دادهٔ واقعی را تغییر دهد یا endpoint داخلی را افشا کند.

## ترتیب عملیات

1. نسخهٔ جدید را با پیکربندی production-compatible بالا بیاورید.
2. آمادگی Pod و dependency را بررسی کنید؛ Running به‌تنهایی موفقیت نیست.
3. smoke test مسیرهای مهم را روی preview انجام دهید.
4. baseline و threshold خطا/latency را ثبت کنید.
5. route اصلی را عوض کنید؛ endpoint و رفتار درخواست‌ها را دنبال کنید.
6. اگر معیار سلامت نقض شد، طبق runbook به Blue برگردید و داده‌های ایجادشده را جدا بررسی کنید.
7. تا پایان پنجرهٔ مراقبت Blue را زود حذف نکنید؛ بعد از موفقیت منابع اضافه را برنامه‌ریزی‌شده جمع کنید.

## ریسک داده و اتصال

فرض کنید Green ساختار جدیدی در دیتابیس می‌نویسد که Blue نمی‌تواند بخواند. برگرداندن Service به Blue ممکن است همهٔ درخواست‌ها را خراب کند. برای تغییر schema، سازگاری قدیم/جدید را طی rollout حفظ کنید؛ تغییر را مرحله‌ای انجام دهید و حذف فیلد قدیمی را تا پایان rollback window عقب بیندازید. همین فکر برای صف پیام، cache key و session لازم است.

در سطح شبکه، تغییر selector ارتباط جدید را به endpointهای منتخب هدایت می‌کند، اما لزوماً connectionهای باز را جابه‌جا نمی‌کند. readiness، propagation endpoint، draining و session affinity را آزمایش کنید. Blue-Green به‌تنهایی zero downtime را تضمین نمی‌کند.

## کاربرد و کوییز

این روش را وقتی بررسی کنید که preview کامل مفید است، ظرفیت اجرای دو نسخه را دارید و مسیر cutover/rollback روشن است. اگر دو برابرشدن منابع ممکن نیست، یا state ناسازگار است، طرح دیگری مناسب‌تر است.

1. **Blue و Green چه تفاوتی دارند؟** Blue نسخهٔ جاری است؛ Green نسخهٔ candidate و پیش از cutover.
2. **آیا بالا بودن Green برای cutover کافی است؟** خیر؛ آزمون مسیر کاربردی، dependency و metric لازم است.
3. **مزیت rollback چیست؟** در صورت حفظ Blue سالم، route را می‌توان بازگرداند.
4. **rollback Service، schema را برمی‌گرداند؟** خیر؛ تغییر route با برگشت داده فرق دارد.
5. **هزینهٔ شاخص چیست؟** ظرفیت و نگهداری دو نسخه به‌صورت هم‌زمان.
6. **آیا تغییر selector اتمی برای تمام connectionهاست؟** خیر؛ endpoint propagation و اتصال‌های جاری باید در نظر گرفته شوند.

## منابع

- [Deployment در Kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Blue-Green در Argo Rollouts](https://argoproj.github.io/argo-rollouts/features/bluegreen/)
- [تحلیل قبل و بعد از promotion](https://argoproj.github.io/argo-rollouts/features/analysis/)
- [مقایسهٔ کامل Canary و Blue-Green در همین دوره](../canary-bluegreen/README.md)

</div>