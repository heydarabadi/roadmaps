<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#10-autoscaling)

# Vertical Pod Autoscaler یا VPA

**فصل:** [Autoscaling](../../README.md)  
**پیش‌نیاز:** فصل [مدیریت منابع](../../../07-resource-management/README.md).

## VPA چه مسئله‌ای را حل می‌کند؟

VPA پیشنهاد می‌دهد یا مدیریت می‌کند هر Pod چه میزان CPU و حافظه درخواست کند. هدف right-sizing است: request بسیار پایین باعث رقابت و فشار منابع می‌شود؛ request بیش از نیاز، ظرفیت قابل‌زمان‌بندی کلاستر را بیهوده مصرف می‌کند. VPA تعداد Podها را زیاد یا کم نمی‌کند؛ برای تغییر تعداد replicaها HPA را بخوانید. برای نیاز بیشتر به node، به autoscaler کلاستر نیاز است.

VPA به‌صورت افزونه/CRD نصب می‌شود و معمولاً از metrics API برای مشاهدهٔ مصرف کمک می‌گیرد. اجزای منطقی آن:
- **Recommender:** مصرف اخیر/تاریخی، تغییرپذیری و رخدادهایی مثل OOM را تحلیل می‌کند و مقدار target، lower bound و upper bound پیشنهاد می‌دهد.
- **Updater:** در حالت‌های اعمال، تشخیص می‌دهد Pod باید resource تازه بگیرد و می‌تواند آن را جابه‌جا یا resize کند.
- **Admission controller:** هنگام ساخت Pod recommendation را روی resourceهای آن اعمال می‌کند.

برای مشاهدهٔ اولیه Metrics Server و سازگاری نصب VPA با نسخهٔ کلاستر را بررسی کنید.

## حالت‌های update

- **Off:** پیشنهاد تولید می‌شود ولی خودکار روی Pod اعمال نمی‌شود. نقطهٔ شروع مناسب برای اندازه‌گیری و بازبینی انسانی است.
- **Initial:** resource در زمان ساخته‌شدن Pod تنظیم می‌شود؛ Pod موجود خودبه‌خود تغییر نمی‌کند.
- **Recreate:** برای اعمال تغییر ممکن است Pod را evict کند تا controller آن را دوباره بسازد. ظرفیت کافی، replica، readiness و PodDisruptionBudget مهم‌اند.
- **InPlaceOrRecreate:** در صورت امکان resource را درجا تغییر می‌دهد؛ اگر تغییر درجا ممکن نباشد، به روش evict/recreate بازمی‌گردد.
- **InPlace:** رفتار و پشتیبانی آن به نسخه و feature gate وابسته است. در مستند فعلی Kubernetes، این حالت alpha با پیش‌نیازهای نسخه‌ای مشخص است؛ در محیط خود پیش از اتکا به آن نسخهٔ دقیق را بررسی کنید.

حالت Auto در VPAهای جدید منسوخ اعلام شده است. از mode صریح و مستند همان نسخه استفاده کنید.

## شروع امن با recommendation

نمونهٔ زیر پیشنهاد را جمع می‌کند ولی resource را خودکار تغییر نمی‌دهد:

~~~yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: api-vpa
  namespace: shop
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  updatePolicy:
    updateMode: Off
  resourcePolicy:
    containerPolicies:
      - containerName: api
        minAllowed:
          cpu: 100m
          memory: 128Mi
        maxAllowed:
          cpu: "2"
          memory: 2Gi
        controlledResources:
          - cpu
          - memory
        controlledValues: RequestsOnly
~~~

مقدارهای min/max حفاظ‌اند، نه هدف عملکرد. پس از ایجاد resource، status recommendation را ببینید و با ترافیک اوج، latency، throttling، OOM و ظرفیت nodeها مقایسه کنید. recommendation روی مصرف دیده‌شده تکیه دارد؛ اگر دورهٔ اوج را نبیند، بیش از حد پایین پیشنهاد می‌دهد.

RequestsOnly یعنی VPA requestها را تنظیم می‌کند و limitها را دست‌نخورده می‌گذارد؛ اگر مصرف از limit بگذرد، throttling یا OOM همچنان ممکن است. RequestsAndLimits limitها را نیز متناسب تنظیم می‌کند. انتخاب را با semantics برنامه و سازمان هماهنگ کنید.

## رابطهٔ VPA با HPA و disruption

HPA روی CPU utilization هدف‌گذاری‌شده نسبت به request حساب می‌کند. اگر VPA هم request CPU را مدام تغییر دهد، مخرج محاسبهٔ utilization تغییر می‌کند و HPA ممکن است تعداد replicaها را تغییر دهد؛ توصیهٔ VPA نیز تحت اثر بار تازه تغییر می‌کند. این حلقه می‌تواند نوسان ایجاد کند. اگر هر دو لازم‌اند، سیگنال و مالک را جدا طراحی کنید؛ مثلاً HPA را بر اساس نرخ درخواست یا queue length تنظیم و VPA را در حالت recommendation برای right-size به‌کار ببرید.

در Recreate، Pod replacement می‌تواند وقفه ایجاد کند. چند replica، PDB مناسب، capacity برای جایگزینی و rollout health را پیش از فعال‌سازی بسنجید. PDB همهٔ قطع‌ها را منع نمی‌کند و VPA جایگزین high availability نیست.

## روش rollout

1. ابتدا mode=Off بگذارید و recommendation را در شرایط بار واقعی جمع کنید.
2. پیشنهاد را با request فعلی، اوج مصرف، OOM/CPU throttling و ظرفیت node مقایسه کنید.
3. minAllowed/maxAllowed و controlledResources را تعیین کنید.
4. یک namespace یا workload کم‌ریسک را انتخاب و تغییرات/restart را پایش کنید.
5. در صورت HPA، کنترلرها را جدا آزمایش کنید و oscillation را دنبال کنید.
6. پس از هر تغییر، مصرف node، Pending Pod، SLO و هزینه را بسنجید.

## کوییز با پاسخ

1. **VPA با HPA چه فرقی دارد؟** VPA اندازهٔ resource هر Pod را پیشنهاد/تغییر می‌دهد؛ HPA تعداد replica را تغییر می‌دهد.
2. **چرا Off نقطهٔ آغاز خوبی است؟** recommendation را بدون تغییر خودکار و اختلال می‌سنجیم.
3. **Recreate چه خطری دارد؟** برای اعمال resource ممکن است Pod را خارج کند و نسخهٔ تازه بسازد.
4. **VPA تعداد node را زیاد می‌کند؟** خیر؛ scheduling و node autoscaling مسئلهٔ جداست.
5. **چه تداخلی با HPA CPU ممکن است؟** تغییر request نسبت utilization را تغییر می‌دهد و حلقهٔ دو کنترلر می‌تواند نوسان کند.
6. **InPlace همیشه بدون restart در دسترس است؟** خیر؛ نسخه، feature gate و محدودیت resize تعیین‌کننده است و mode جدید ممکن است alpha باشد.

## منابع

- [مستندات رسمی Vertical Pod Autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/vertical-pod-autoscale/)
- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/)
- [منابع و کد پروژهٔ VPA](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)
- [مفاهیم autoscaling در همین دوره](../../README.md)

</div>