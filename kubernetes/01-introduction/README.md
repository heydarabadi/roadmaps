<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../references/README.md#01-introduction-and-mental-model)

# فصل 01: مقدمه و مدل ذهنی Kubernetes

## هدف‌های فصل

پس از این فصل باید بتوانید:

- توضیح دهید Kubernetes چه مسئله‌ای را حل می‌کند و چه چیزهایی را حل نمی‌کند.
- تفاوت وضعیت مطلوب و وضعیت مشاهده‌شده و نقش reconciliation را شرح دهید.
- مسیر یک درخواست استقرار را از kubectl تا اجرای container دنبال کنید.
- برای یک سرویس کوچک تصمیم بگیرید که Kubernetes انتخاب مناسبی هست یا نه.

## ایدهٔ مرکزی

Kubernetes یک سامانهٔ توزیع‌شده برای مدیریت برنامه‌های کانتینری است. شما از طریق API وضعیت مطلوب را ثبت می‌کنید؛ کنترلرها و مؤلفه‌های کلاستر به‌طور مداوم برای نزدیک‌کردن وضعیت واقعی به آن وضعیت تلاش می‌کنند. این نگاه به «حلقهٔ کنترل» مهم‌تر از حفظ‌کردن فرمان‌هاست.

## از درخواست تا اجرای برنامه چه رخ می‌دهد؟

فرض کنیم فایل Deployment می‌گوید دو نسخه از وب‌سرویس باید اجرا شود:

1. kubectl فایل را می‌خواند و درخواست را به API Server می‌فرستد.
2. API Server هویت و مجوز درخواست را بررسی، شیء را اعتبارسنجی و admission policyها را اجرا می‌کند.
3. وضعیت پذیرفته‌شده در پایگاه دادهٔ کلاستر، معمولاً etcd، ذخیره می‌شود.
4. Deployment controller می‌بیند که باید دو Pod وجود داشته باشد و ReplicaSet مناسب می‌سازد.
5. Scheduler برای Podهای بدون node، nodeهایی را براساس منابع درخواستی و قیدها انتخاب می‌کند.
6. kubelet روی node از container runtime می‌خواهد image را آماده و container را اجرا کند.
7. شبکه، volume و probeها پیکربندی می‌شوند؛ وضعیت به API گزارش می‌شود.
8. تا وقتی وضعیت مطلوب و واقعی فرق دارند، کنترلرها دوباره تلاش می‌کنند.

هیچ فرمانی لازم نیست به تک‌تک سرورها بگویید «این فرایند را اجرا کن». درخواست روی API ثبت می‌شود و control loopها کار را پیگیری می‌کنند. این رفتار asynchronous است: پذیرش manifest یعنی درخواست پذیرفته شده، نه اینکه برنامه همین لحظه آمادهٔ پاسخ‌گویی است.

## وضعیت مطلوب در برابر وضعیت واقعی

در Deployment، وضعیت مطلوب شامل تعداد replica، الگوی انتخاب Pod و قالب Pod است. وضعیت واقعی ممکن است یک Pod سالم، یک Pod در حال راه‌اندازی و یک Pod خراب باشد. Controller اختلاف را می‌بیند و اقدام می‌کند؛ اما نمی‌داند از دید کسب‌وکار «درست» چیست، مگر اینکه شما تعداد replica، probe، policy و معیار سلامت را تعریف کرده باشید.

این طراحی declarative چند پیامد دارد:

- اجرای مجدد همان تعریف عموماً باید بی‌خطر باشد.
- تاریخچهٔ تعریف، امکان بازبینی و بازسازی را بهتر می‌کند.
- تغییر دستی روی node ممکن است با وضعیت تعریف‌شده ناسازگار شود.
- کنترلرها تضمین جادویی نمی‌دهند؛ اگر image خراب باشد، ممکن است همان image خراب را بارها اجرا کنند.

## مثال کامل کوچک

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - name: http
          containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 64Mi
~~~

پس از ذخیره در web.yaml، آن را در کلاستر آموزشی اجرا کنید:

~~~sh
kubectl apply -f web.yaml
kubectl get deployment,pods
kubectl describe deployment web
kubectl get events --sort-by=.metadata.creationTimestamp
~~~

توجه کنید selector در Deployment باید با labelهای قالب Pod سازگار باشد. اگر مقدار replica را از 2 به 3 تغییر دهید و دوباره apply کنید، controller وضعیت مطلوب تازه را دنبال می‌کند.

## تصمیم معماری: کجا مناسب است؟

| Kubernetes انتخاب معقولی است وقتی | گزینهٔ ساده‌تر را جدی بگیرید وقتی |
| --- | --- |
| چند سرویس و چند محیط دارید و استقرارها زیاد تکرار می‌شوند | یک برنامه روی یک میزبان و ترافیک ثابت دارید |
| به rollout، self-healing سطح فرایند، scheduling یا isolation تیمی نیاز دارید | تیم on-call یا مهارت نگهداری control plane و افزونه‌ها ندارد |
| می‌خواهید workload را با API و ابزارهای مشترک مدیریت کنید | سرویس managed ساده نیاز را با عملیات کمتر پوشش می‌دهد |
| سرمایه‌گذاری در platform engineering توجیه‌پذیر است | هزینهٔ شبکه، ذخیره‌سازی و پایش از ارزش محصول بیشتر می‌شود |

در یک فروشگاه پرترافیک، استقرار چند نسخهٔ API و rollout روزانه می‌تواند از orchestration استاندارد سود ببرد. برای یک سایت معرفی کم‌ترافیک، سرویس میزبانی ساده‌تر ممکن است اقتصادی‌تر باشد. تصمیم را با هزینهٔ کل مالکیت، نه محبوبیت فناوری، بگیرید.

## تجربهٔ واقعی

گزارش CNCF دربارهٔ Michelin از بازطراحی پلتفرمی برای صدها برنامه در چندین کلاستر صحبت می‌کند. نکتهٔ معماری، فقط «انتقال برنامه به کانتینر» نیست؛ پلتفرم باید onboarding تیم‌ها، ارتقا، امنیت، مشاهده‌پذیری و شکست یک کلاستر را نیز پوشش دهد. این مورد را با اندازه و توان عملیاتی تیم خود مقایسه کنید.

## دام‌های رایج

- Kubernetes را با Docker یا container runtime یکی‌گرفتن.
- فرض اینکه هر Pod همیشه همان IP را نگه می‌دارد.
- فرض اینکه apply موفق یعنی برنامه سالم است.
- انتظار اینکه Kubernetes باگ برنامه، قطعی دیتابیس یا کمبود backup را رفع کند.
- راه‌اندازی کلاستر production بدون owner، runbook، ارتقا و پاسخ‌گویی به رخداد.

## کوییز تشریحی

1. چرا تعداد replica را در Deployment تعریف می‌کنیم، نه اینکه یک‌بار Pod بسازیم؟
   - **پاسخ:** Deployment وضعیت مطلوب را نگه می‌دارد و controller اختلاف را اصلاح می‌کند؛ Pod دستی controller ندارد که آن را جایگزین کند.
2. پس از پذیرش manifest، چرا باید rollout status و readiness را بررسی کرد؟
   - **پاسخ:** API درخواست را پذیرفته است؛ image pull، زمان‌بندی و آغاز برنامه هنوز ممکن است شکست بخورند.
3. اگر کنترلر Pod خراب را دوباره بسازد، آیا availability تضمین شده؟
   - **پاسخ:** نه؛ اگر image یا پیکربندی خراب باشد، Pod جدید هم خراب می‌شود. probe، ظرفیت، rollback و observability لازم‌اند.
4. کدام بخش را یک provider مدیریت‌شده ممکن است به‌جای شما نگهداری کند و چه چیزی هنوز با شماست؟
   - **پاسخ:** بخشی از control plane؛ workload، داده، مجوز، هزینه، پیکربندی و recovery برنامه همچنان مسئولیت تیم است.

## منابع

- [نقشهٔ راه Kubernetes در roadmap.sh](https://roadmap.sh/kubernetes)
- [PDF رسمی سرفصل‌ها](https://roadmap.sh/pdfs/roadmaps/kubernetes.pdf)
- [مفاهیم رسمی Kubernetes](https://kubernetes.io/docs/concepts/)
- [مستندات مؤلفه‌های کلاستر](https://kubernetes.io/docs/concepts/overview/components/)
- [منبع فارسی مقدماتی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)
- [گزارش سالانه CNCF 2025 و مورد Michelin](https://www.cncf.io/wp-content/uploads/2026/03/cncf_ar25_033126a.pdf)

</div>