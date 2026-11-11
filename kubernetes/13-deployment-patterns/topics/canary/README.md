<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#13-deployment-and-delivery)

# انتشار Canary

**فصل:** [الگوهای انتشار و تحویل](../../README.md)  
**درس کامل همراه با مقایسه و آزمایشگاه:** [Canary و Blue-Green](../canary-bluegreen/README.md)

## مدل ذهنی

در Canary نسخهٔ تازه را یک‌باره به همهٔ کاربران نمی‌دهیم. ابتدا گروه یا سهم کوچکی از ترافیک به candidate می‌رسد؛ سلامت آن را زیر بار واقعی می‌سنجیم و سپس مرحله‌ای گسترش می‌دهیم. در صورت regression، سهم را افزایش نمی‌دهیم و به stable برمی‌گردیم. هدف کاهش دامنهٔ اثر و گرفتن شواهد زودهنگام است، نه تضمین بدون‌خطابودن release.

دو نسخهٔ برنامه باید هم‌زمان قابل اجرا باشند. مسیر درخواست باید بتواند stable و candidate را تشخیص دهد و metricها را برچسب نسخه داشته باشند؛ وگرنه شکست candidate زیر میانگین stable پنهان می‌شود.

## Canary با چه مکانیزمی؟

Kubernetes Deployment از RollingUpdate پشتیبانی می‌کند و جایگزینی Podها را با maxSurge/maxUnavailable کنترل می‌کند. این رفتار معادل هدایت دقیق 5 درصد درخواست HTTP نیست. اگر دو نسخه را به نسبت Pod پشت یک Service قرار دهید، سهم درخواست تقریبی است و به connectionها، تعداد endpoint آماده و روش توزیع بستگی دارد.

وزن دقیق یا انتخاب یک cohort معمولاً به Gateway/Ingress سازگار، service mesh، load balancer یا progressive-delivery controller مثل Argo Rollouts نیاز دارد. افزونه باید همراه با مسیر ترافیک، metric provider و قواعد rollback پیکربندی شود.

طرح سادهٔ rollout می‌تواند مراحل 5%، 20%، 50% و 100% داشته باشد. هر گام باید مدت یا حجم نمونه، metric و شرط توقف داشته باشد. مثلاً پس از 5% ترافیک 10 دقیقه صبر کنید، نرخ 5xx و p95 نسخهٔ candidate را با stable مقایسه کنید و تنها اگر معیار SLO برقرار بود ادامه دهید. مدت نمونه باید برای الگوی ترافیک واقعی کافی باشد.

## پیش از شروع چه چیزی ثبت کنیم؟

- **خط مبنا:** خطا، latency صدکی، مصرف منابع، صف و رفتار dependency روی stable.
- **شرط قبولی و توقف:** threshold و تعداد بازه‌های متوالی، پیش از دیدن نتیجه.
- **پنجرهٔ مشاهده:** مدت یا حداقل تعداد درخواست‌ها؛ پنج درخواست سالم، شواهد کافی نیست.
- **تفکیک:** metric بر اساس نسخه و در صورت نیاز region، نوع کاربر یا مسیر.
- **مالک تصمیم:** چه کسی rollout را pause/abort/promote می‌کند؟
- **داده و state:** سازگاری دو نسخه با schema، cache، queue و session.
- **ظرفیت:** امکان اجرای هم‌زمان candidate و stable در مرحلهٔ اوج.

مثال آموزشی: اگر در دو بازهٔ متوالی نرخ خطای candidate از SLO عبور کرد یا p95 آن به‌طور پایدار از baseline بدتر شد، rollout را متوقف کنید؛ سهم را بالا نبرید تا signal بررسی شود. اعداد باید با SLO واقعی و نویز سرویس تنظیم شوند.

## شکست‌های رایج

1. **وزن غلط:** controller فقط replica ratio را تنظیم کرده ولی تصور می‌کنیم وزن request دقیق است.
2. **نمونهٔ کوچک یا ناممثل:** پنجره فقط بار کم را دیده یا cohort آسیب‌پذیر وارد Canary نشده.
3. **metric تجمیعی:** stable سالم است و میانگین کلی افت candidate را پنهان می‌کند.
4. **Readiness ناقص:** Pod ready است اما کاربر journey واقعی را کامل نمی‌کند.
5. **rollback داده‌ناپذیر:** نسخهٔ تازه قالب ناسازگار نوشته و نسخهٔ قبلی دیگر قادر به خواندن نیست.
6. **ظرفیت ناکافی:** اجرای دو نسخه باعث throttling یا فشار dependency مشترک می‌شود.

## تمرین

یک API آزمایشی با دو نسخه بسازید و در release جدید عمدی latency یا نرخ خطا ایجاد کنید. در طرح مکتوب مشخص کنید چه درصدی Canary می‌گیرد، چه metricی آن را می‌سنجد، چه حجمی از نمونه لازم است و چه شرطی rollback را فعال می‌کند. سپس توضیح دهید چرا Kubernetes Service معمولی درخواست‌ها را بر مبنای cookie یا درصد دقیق تقسیم نمی‌کند.

## کوییز با پاسخ

1. **آیا Deployment بومی 10% ترافیک را تضمین می‌کند؟** خیر؛ rolling update جایگزینی Pod را کنترل می‌کند. تقسیم request دقیق به dataplane یا کنترلر سازگار نیاز دارد.
2. **چرا metric باید نسخه‌محور باشد؟** چون stable می‌تواند افت candidate را در آمار کلی مخفی کند.
3. **Canary سالم روی 5 درخواست، برای promotion کافی است؟** خیر؛ حجم نمونه و نمایندگی بار باید برای آشکارسازی regression کافی باشد.
4. **چه چیزی بعد از نقض SLO انجام می‌دهیم؟** exposure را متوقف می‌کنیم، سهم را افزایش نمی‌دهیم و طبق runbook pause/rollback و تحلیل signal را انجام می‌دهیم.
5. **آیا rollback image دادهٔ نوشته‌شده را برمی‌گرداند؟** خیر؛ سازگاری schema و سیاست بازیابی داده باید جدا طراحی شود.

## منابع

- [Deployment در مستندات رسمی Kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Canary در Argo Rollouts](https://argoproj.github.io/argo-rollouts/features/canary/)
- [تحلیل metric در Argo Rollouts](https://argoproj.github.io/argo-rollouts/features/analysis/)
- [تحلیل و rollback در Flagger](https://docs.flagger.app/usage/how-it-works)
- [آموزش فارسی مقدماتی Kubernetes از DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)

</div>