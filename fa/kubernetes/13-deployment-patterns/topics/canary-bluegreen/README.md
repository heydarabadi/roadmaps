<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../../../en/kubernetes/13-deployment-patterns/topics/canary-bluegreen/README.md) · [کتابخانهٔ منابع](../../../references/README.md#13-deployment-and-delivery)

# درس کامل: Canary و Blue-Green

**فصل:** [الگوهای انتشار و تحویل](../../README.md)  
**پیش‌نیاز:** فصل [اجرای برنامه‌ها](../../../04-running-applications/README.md)، [شبکه](../../../05-services-networking/README.md) و [مشاهده‌پذیری](../../../09-monitoring-logging/README.md).

## مسئله و واژه‌ها

بالا آمدن Pod به معنی درست‌کارکردن برنامه نیست. نسخهٔ تازه ممکن است فقط برای نوع خاصی از درخواست خطا بدهد، کند شود، دادهٔ ناسازگار بنویسد یا وابستگی را بیش از حد مصرف کند. انتشار تدریجی می‌پرسد: چطور اثر نسخهٔ جدید را محدود کنیم و با چه شواهدی ادامه، مکث یا بازگشت را انتخاب کنیم؟

- **stable:** نسخه‌ای که ترافیک اصلی را می‌گیرد.
- **candidate:** نسخه‌ای که می‌خواهیم آزمایش کنیم.
- **promotion:** پذیرفتن candidate به عنوان نسخهٔ اصلی.
- **rollback:** برگرداندن مسیر به نسخهٔ قبلی؛ این کار لزوماً داده را برنمی‌گرداند.
- **blast radius:** کاربران و سامانه‌هایی که نسخهٔ معیوب می‌تواند تحت تأثیر قرار دهد.
- **پنجرهٔ مشاهده:** مدت و حجم داده‌ای که برای تصمیم انتشار جمع می‌کنیم.

## Canary یعنی چه؟

در Canary، ابتدا سهم کوچکی از درخواست‌ها یا cohort مشخصی از کاربران به candidate می‌رسد. اگر metricها در حدود تعریف‌شده باشند، سهم زیاد می‌شود؛ اگر regression دیده شود، rollout متوقف یا برگردانده می‌شود.

| گام نمونه | سهم candidate | مشاهده | تصمیم |
| --- | ---: | --- | --- |
| آزمون پایه | 0% ترافیک واقعی | smoke test | سلامت شروع و dependency |
| کوچک | 5% | 10 دقیقه | خطا و latency قابل‌قبول |
| متوسط | 20% | 15 دقیقه | metric فنی و محصول سالم |
| بزرگ | 50% | 20 دقیقه | regression معنادار دیده نشود |
| تکمیل | 100% | پایش تقویت‌شده | پایان پنجرهٔ مراقبت |

درصد و مدت قانون همگانی نیست. اگر در ده دقیقه پنج درخواست داشته باشیم، سالم‌بودن ده‌دقیقه‌ای شاهد آماری قوی نیست. مدت باید الگوی اوج/کم‌باری، نرخ درخواست و تأخیر آشکارشدن مشکل را پوشش دهد. اگر خرابی فقط برای منطقه یا روش پرداخت خاصی رخ می‌دهد، metric کلی آن را پنهان می‌کند.

### Canary با Kubernetes

Deployment بومی با RollingUpdate تعداد Podهای قدیم و جدید را کنترل می‌کند و readiness probe در endpointهای آماده نقش دارد. اما به تنهایی 5% دقیق درخواست HTTP، انتخاب بر اساس کاربر یا rollback مبتنی بر شاخص کسب‌وکار را پیاده نمی‌کند.

اگر دو نسخه را با replicaهای متفاوت پشت Service بگذاریم، سهم درخواست فقط تقریبی است: load balancing روی endpoint و connection اثر دارد، نه الزاماً روی درصد دقیق درخواست. برای وزن واقعی معمولاً Gateway/Ingress سازگار، service mesh، load balancer یا progressive-delivery controller لازم است.

Argo Rollouts و Flagger می‌توانند مرحله‌بندی و تحلیل metric را هماهنگ کنند. باید traffic router، منبع داده، آستانه، پنجرهٔ مشاهده و عمل rollback را تنظیم و تمرین کرد. نصب ابزار به معنی وجود تصمیم‌گیری امن نیست.

نمونهٔ مفهومی Argo Rollouts:

~~~yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: checkout
spec:
  replicas: 10
  selector:
    matchLabels:
      app: checkout
  template:
    metadata:
      labels:
        app: checkout
    spec:
      containers:
        - name: app
          image: example.invalid/checkout:2026-11-10
  strategy:
    canary:
      steps:
        - setWeight: 5
        - pause:
            duration: 10m
        - setWeight: 20
        - pause:
            duration: 15m
        - setWeight: 50
        - pause: {}
~~~

این fragment برای اجرا کامل نیست و image ساختگی دارد. port، probe، منابع، Serviceها و traffic-routing provider باید مشخص شوند. setWeight با router متصل می‌تواند وزن درخواست را تغییر دهد؛ بدون آن ممکن است فقط نسبت replicaها تغییر کند. pause نیز به خودی خود metric را نمی‌سنجد؛ Analysis جدا لازم است.

## Blue-Green یعنی چه؟

دو محیط کامل هم‌زمان آماده می‌شوند:

- **Blue** نسخهٔ جاری و دریافت‌کنندهٔ ترافیک است.
- **Green** نسخهٔ جایگزین است که پیش از cutover در preview آزمایش می‌شود.

پس از آمادگی Green، مسیر اصلی به آن تغییر می‌کند. در صورت مشکل مسیر را به Blue برمی‌گردانیم، اگر Blue هنوز موجود و با دادهٔ فعلی سازگار باشد.

نمونهٔ ساده با دو Deployment و Service که فقط Blue را انتخاب می‌کند:

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
      track: blue
  template:
    metadata:
      labels:
        app: web
        track: blue
    spec:
      containers:
        - name: web
          image: nginx:1.27
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
      track: green
  template:
    metadata:
      labels:
        app: web
        track: green
    spec:
      containers:
        - name: web
          image: nginx:1.28
---
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
      targetPort: 80
~~~

برای preview یک Service مجزا و محدود بسازید. برای cutover، selector اصلی را از blue به green تغییر دهید. تغییر selector فوراً تمام connectionهای باز را جابه‌جا نمی‌کند؛ آماده‌بودن endpoint، draining، load balancer و sessionها را آزمایش کنید. برای production از tag تغییرناپذیر یا digest استفاده کنید و probe/resource/config را کامل کنید.

## معیارهای ادامه یا توقف

خط مبنا را در زمان و بار مشابه از stable بگیرید. برای هر معیار owner، منبع، بازهٔ سنجش، شرط قبولی و اقدام توقف را از قبل بنویسید.

- نرخ پاسخ موفق، خطای 5xx و خطای دامنه
- p95/p99 latency؛ میانگین به تنهایی کندشدن بخشی از کاربران را پنهان می‌کند
- CPU، memory، throttling، connection pool، صف و رد درخواست
- خطا و تأخیر دیتابیس، cache، پرداخت و API بیرونی
- metric محصول مثل تکمیل خرید یا سفارش تکراری، در صورت مجاز و متناسب بودن
- خطای migration، conflict و replication lag

نمونهٔ شرط: اگر در دو بازهٔ متوالی خطای candidate دست‌کم یک واحد درصد از stable بیشتر شود یا p95 بیش از 20% از baseline فراتر رود، وزن را افزایش نده و طبق runbook مکث یا rollback کن. این آستانه فقط نمونه است و باید با SLO و نویز طبیعی سرویس تنظیم شود. آستانه را پس از دیدن نتیجه انتخاب نکن.

## مقایسه و انتخاب

| ویژگی | Canary | Blue-Green |
| --- | --- | --- |
| ورود نسخه | سهم ترافیک در چند گام | محیط جایگزین کامل، سپس تغییر مسیر |
| کشف خطا | تدریجی زیر بار واقعی | در preview و بعد از cutover |
| اثر خرابی | با سهم/cohort محدود می‌شود، اگر routing درست باشد | پیش از switch کم؛ پس از آن می‌تواند سراسری باشد |
| ظرفیت | اجرای هم‌زمان هر دو نسخه به نسبت مرحله | معمولاً دو محیط کامل هم‌زمان |
| نیاز routing | وزن دقیق به ابزار سازگار نیاز دارد | تغییر selector/route، با توجه به propagation و connection |
| rollback | وزن را کم یا صفر می‌کنیم | مسیر را به Blue برمی‌گردانیم، اگر داده و نسخه سازگار باشند |
| هزینهٔ برجسته | routing و metric pipeline | ظرفیت اوج و نگهداری stack قدیم |
| تناسب | تقسیم ترافیک معنادار و نیاز به آزمایش تدریجی | امکان preview و cutover روشن |

Canary وقتی مفید است که درخواست‌ها را معنادار تقسیم و metric هر نسخه را جدا تحلیل کنیم. Blue-Green وقتی مناسب است که بتوانیم محیط کامل دوم را آماده نگه داریم. RollingUpdate برای تغییر عادی معمولاً ساده‌تر است. Recreate می‌تواند برای تغییر ناسازگار مناسب باشد، با پذیرش توقف. Feature flag قابلیت برنامه را از انتشار image جدا می‌کند، اما نگهداری flag و دو مسیر کد هزینه دارد. این روش‌ها می‌توانند با هم ترکیب شوند.

## دیتابیس و rollback

نسخهٔ قدیم ممکن است ساختار دادهٔ قبلی را بخواهد. اگر Green ستون لازم Blue را حذف کند یا قالب ناسازگار بنویسد، برگشت traffic به Blue نرم‌افزار را نجات نمی‌دهد. همین ریسک برای پیام صف، session، cache key و فایل وجود دارد.

الگوی رایج expand–migrate–contract:

1. **Expand:** ساختار جدید را اضافه کن ولی قبلی را نگه دار.
2. **سازگاری دوطرفه:** نسخه‌ای منتشر کن که هر دو قالب را بخواند/بنویسد.
3. **Migrate:** داده را منتقل کن و صحت/تعداد را بسنج.
4. **Contract:** بعد از حذف نسخه‌های قدیمی و آماده‌بودن recovery ساختار قدیمی را حذف کن.

Rollback کد، داده را برنمی‌گرداند. تصمیم بین rollback و forward-fix، restore و مالک تأیید باید در runbook روشن باشد.

## چک‌لیست انتشار

**قبل:** image یکتا؛ context/namespace درست؛ probe واقعاً readiness را می‌سنجد؛ ظرفیت برای دو نسخه موجود؛ baseline و شرط stop معلوم؛ migration، cache، queue و session بررسی؛ راه برگشت آزمایش شده.

**حین:** مرحله‌به‌مرحله پیش برو؛ dashboard نسخه‌محور را ببین؛ زمان/سهم/تصمیم را ثبت کن؛ با رخداد stop سهم را بیشتر نکن؛ وضعیت Running را با سالم‌بودن مسیر اصلی کاربر یکی ندان.

**بعد:** تا پایان پنجرهٔ مراقبت alertها را ببین؛ سپس نسخهٔ قدیمی را طبق برنامه جمع کن؛ incident را با timeline، اثر مشتری و signal ازدست‌رفته بازبینی کن.

## تمرین عملی

### Blue-Green بومی

1. در کلاستر محلی namespace آزمایشی بساز.
2. دو Deployment با برچسب‌های track=blue و track=green مستقر کن.
3. Service اصلی را به Blue و Service preview را به Green وصل کن.
4. با port-forward یا درخواست داخل کلاستر نسخهٔ پاسخ را تأیید کن.
5. selector سرویس اصلی را به Green تغییر بده؛ EndpointSlice و Podهای انتخاب‌شده را ببین.
6. چند درخواست بفرست و سپس selector را به Blue برگردان.
7. توضیح بده چرا selector connection جاری یا تراکنش دیتابیس را برنمی‌گرداند.

### طرح Canary و incident فرضی

برای checkout با 20هزار درخواست در دقیقه، مراحل 1، 5، 20، 50 و 100 درصد را طراحی کن. برای هر مرحله حجم/مدت، metric و شرط توقف بنویس. حالا فرض کن در 5% همه‌چیز سالم است ولی در 20% نرخ خطای پرداخت کارت‌های یک کشور بالا می‌رود و میانگین کلی تقریباً ثابت می‌ماند. اقدام: exposure را متوقف کن، metric را بر اساس کشور/وابستگی تفکیک کن، پرداخت نامشخص یا تکراری را بررسی کن و signal ازدست‌رفته را ثبت کن. این سناریو آموزشی است، نه ادعای رخداد شرکت مشخص.

## عیب‌یابی

| نشانه | علت محتمل | بررسی |
| --- | --- | --- |
| candidate درخواست نمی‌گیرد | selector یا route اشتباه | Service، EndpointSlice، route و labelها را مقایسه کن |
| وزن دقیق نیست | فقط replica ratio تنظیم شده | اتصال traffic router را بررسی کن |
| preview نسخهٔ قدیم را می‌دهد | selector/namespace اشتباه | label Pod و selector Service را ببین |
| پس از cutover خطاست | Green، config، secret یا dependency خراب است | exposure را طبق runbook متوقف؛ event/log همان release را بخوان |
| rollback شکست می‌خورد | Blue حذف یا schema ناسازگار شده | داده و سلامت نسخهٔ قدیم را جدا بررسی کن |
| Canary سالم است اما incident می‌آید | پنجره، cohort یا metric ناکافی | حجم نمونه، مدت و تفکیک metric را اصلاح کن |

## کوییز و پاسخ تشریحی

1. **RollingUpdate چه می‌کند و چه نمی‌کند؟** جایگزینی Pod و حدود surge/unavailable را کنترل می‌کند؛ درصد دقیق درخواست و rollback metricمحور را به‌تنهایی ارائه نمی‌کند.
2. **چرا 10% Pod برابر 10% درخواست نیست؟** توزیع بر اساس endpoint/connection است؛ affinity و connection طولانی هم اثر دارند.
3. **شرط rollback در Blue-Green چیست؟** Blue باید سالم و موجود بماند و دادهٔ جاری با آن سازگار باشد.
4. **چرا metric بر اساس نسخه جداست؟** stable پرتعداد می‌تواند افت candidate را در عدد کلی بپوشاند.
5. **پنج درخواست بی‌خطا برای promote کافی است؟** خیر؛ نمونه کوچک، خطای کم‌تکرار یا cohort خاص را نمی‌سنجد.
6. **حذف ستون دیتابیس را با rollback app حل می‌کنیم؟** خیر؛ سازگاری دو نسخه و طرح expand–migrate–contract لازم است.
7. **چرا threshold را قبل از rollout می‌نویسیم؟** انتخاب پسینی می‌تواند نتیجه را به نفع ادامه یا توقف منحرف کند.
8. **پس از 100% ترافیک، Blue را فوراً حذف کنیم؟** نه؛ پنجرهٔ مراقبت، jobهای فعال، state و نیاز rollback را بررسی کن.
9. **این الگوها جای backup هستند؟** خیر؛ backup، restore و disaster recovery مسئولیت جدا هستند.
10. **سرویس کم‌ترافیک و بدون routing دقیق چه کند؟** RollingUpdate امن، آزمون staging، feature flag یا Blue-Green ساده را بر اساس ظرفیت و شواهد انتخاب کند؛ Canary بدون نمونهٔ کافی ارزش کمی دارد.

## منابع

- [Deployment و RollingUpdate رسمی](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [مفاهیم Argo Rollouts](https://argoproj.github.io/argo-rollouts/concepts/)
- [Canary](https://argoproj.github.io/argo-rollouts/features/canary/) و [Blue-Green](https://argoproj.github.io/argo-rollouts/features/bluegreen/)
- [تحلیل metric در Argo Rollouts](https://argoproj.github.io/argo-rollouts/features/analysis/)
- [تحلیل و rollback در Flagger](https://docs.flagger.app/usage/how-it-works)
- [مقدمهٔ فارسی Kubernetes از DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)

</div>