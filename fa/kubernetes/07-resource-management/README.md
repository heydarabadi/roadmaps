<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/07-resource-management/README.md) · [کتابخانهٔ منابع](../references/README.md#07-resource-management)

# فصل 07: مدیریت منابع

## هدف‌های یادگیری

- تفاوت request و limit و پیامد آن‌ها برای CPU و حافظه را بفهمید.
- Quota و LimitRange را در سطح namespace استفاده کنید.
- مصرف واقعی را اندازه‌گیری و منابع را براساس بار تنظیم کنید.
- Pending، throttling و OOMKilled را تشخیص دهید.

## سه مفهوم جدا

**Request** در زمان‌بندی Pod و محاسبهٔ ظرفیت اثر دارد. **Limit** سقف مصرف را اعمال می‌کند. **مصرف واقعی** رفتار برنامه در طول زمان است. request کمتر از نیاز می‌تواند رقابت و eviction ایجاد کند؛ request بیش‌ازحد بزرگ ظرفیت بلااستفاده می‌گذارد و Pod جدید را Pending می‌کند.

CPU قابل throttle است؛ memory limit سخت‌گیرانه‌تر است و عبور از آن می‌تواند container را OOM kill کند. 100m CPU برابر یک‌دهم CPU منطقی است. Mi و Gi با MB و GB دقیقاً یکی نیستند.

~~~yaml
resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: "1"
    memory: 512Mi
~~~

اعداد صرفاً نمونه‌اند. مقدار مناسب به رفتار startup، peak، cache و هدف latency برنامه بستگی دارد.

## ظرفیت و QoS

Requestهای Podها در ظرفیت قابل‌زمان‌بندی node جمع می‌شوند. node برای سیستم‌عامل و daemonها هم منابع لازم دارد؛ ظرفیت اسمی ماشین را تماماً به workload اختصاص ندهید. ترکیب request و limit روی QoS کلاس Pod اثر دارد و هنگام فشار منابع در eviction مهم است، اما QoS عالی جای تنظیم صحیح و capacity planning را نمی‌گیرد.

## Quota و اندازه‌گیری

ResourceQuota سقف تجمعی namespace را محدود می‌کند؛ LimitRange مقدار پیش‌فرض یا بازهٔ منابع هر Pod/container را تعیین می‌کند. افزایش quota بدون ظرفیت node فقط مشکل را به زمان‌بندی منتقل می‌کند. مصرف را همراه latency، restart، throttling، OOM و SLO ببینید؛ یک snapshot برای ظرفیت‌سنجی کافی نیست.

## روند tuning

1. workload و SLO را مشخص کنید.
2. در بار معتبر، مصرف معمول و peak را ثبت کنید.
3. مصرف را با request و limit مقایسه کنید.
4. یک تغییر کوچک اعمال و اثرش را روی latency و ظرفیت بررسی کنید.
5. policy و نمودار را به‌روز کنید؛ پس از تغییر نسخه دوباره بسنجید.

## کوییز و پاسخ

1. Scheduler معمولاً کدام مقدار را برای ظرفیت می‌بیند؟ — request.
2. CPU limit چه اثری دارد؟ — می‌تواند پردازش را throttle و latency را بالا ببرد.
3. memory از limit بگذرد چه رخ می‌دهد؟ — container ممکن است OOMKilled شود.
4. Quota چه چیزی می‌سازد؟ — محدودیت مصرف/تعداد؛ نه ظرفیت node.
5. آیا میانگین مصرف request خوبی است؟ — نه به‌تنهایی؛ peak و نوسان بار را هم بسنجید.

## منابع

- [مدیریت منابع Pod و Container](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Resource Quota](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/)
- [آموزش مقدماتی فارسی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners)

</div>