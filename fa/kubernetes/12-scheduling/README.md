<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/12-scheduling/README.md) · [کتابخانهٔ منابع](../references/README.md#12-scheduling)

# فصل 12: Scheduling، اولویت و Eviction

## هدف‌های یادگیری

- بفهمید scheduler چگونه nodeهای نامناسب را حذف و گزینه‌های مناسب را رتبه‌بندی می‌کند.
- request، affinity، taint، topology و capacity را در placement لحاظ کنید.
- disruption داوطلبانه و eviction اجباری را از هم جدا کنید.
- availability را با PDB و توزیع failure domain طراحی کنید.

## چرخهٔ Scheduler

Pod جدید ابتدا بدون node است. Scheduler فیلتر می‌کند: آیا node منابع request را دارد؟ selector و affinity برقرارند؟ taint تحمل شده؟ volume در topology مناسب قابل‌اتصال است؟ سپس nodeهای باقی‌مانده را رتبه می‌دهد و یکی را bind می‌کند. اگر هیچ node مناسب نباشد، Pod Pending و event علت را گزارش می‌کند.

Scheduler مصرف واقعی لحظه‌ای برنامه را پیش‌بینی نمی‌کند؛ request و constraintهای شما مبنا هستند. request اشتباه می‌تواند packing نامناسب یا Pending ایجاد کند.

## قیدها برای placement

- nodeSelector و required node affinity می‌توانند node را اجباری محدود کنند.
- preferred affinity ترجیح است، نه الزام.
- taint node را برای Podهای فاقد toleration نامناسب می‌کند.
- topology spread replicaها را میان zone/node پخش می‌کند.
- PriorityClass ترتیب اهمیت را مشخص می‌کند؛ preemption ممکن است Pod کم‌اولویت را بیرون کند.

هر الزام سخت می‌تواند availability را پایین بیاورد اگر node کافی نباشد. قید را از نیاز واقعی مثل GPU، compliance یا zone isolation استخراج کنید.

## Disruption و Eviction

Kubelet ممکن است تحت memory/disk pressure Pod را evict کند. drain و برخی عملیات نگهداری disruption داوطلبانه می‌سازند. PodDisruptionBudget حداقل availability یا حداکثر disruption داوطلبانهٔ هم‌زمان را محدود می‌کند. PDB خرابی ناگهانی node را منع نمی‌کند و جای replica و zone spread نیست.

## مثال واقعی و کاربردی

پردازش دسته‌ای چندتیمی به صف و ظرفیت نیاز دارد. Netflix در مقالهٔ Kueue تجربهٔ استفاده از queueing و مدیریت ظرفیت را شرح می‌دهد. این نشان می‌دهد scheduling فقط node-fit نیست؛ سهم تیم‌ها، اولویت، ظرفیت و fairness نیز مهم‌اند.

## تمرین

1. Pod با request بیشتر از کل ظرفیت node بسازید و event Pending را بخوانید.
2. یک node آزمایشی taint کنید و Pod بدون/با toleration را مقایسه کنید.
3. replicaها را با topology spread توزیع کنید.
4. PDB بسازید و drain را در cluster محلی آزمایش کنید.

## کوییز

1. Scheduler چه زمانی Pod را bind می‌کند؟ — پس از آنکه node مناسب براساس filter/score انتخاب شود.
2. Toleration انتخاب node را تضمین می‌کند؟ — خیر؛ فقط taint را تحمل می‌کند.
3. PDB خرابی power/node ناگهانی را متوقف می‌کند؟ — خیر؛ عمدتاً disruption داوطلبانه را کنترل می‌کند.
4. Priority capacity می‌سازد؟ — خیر؛ فقط اولویت و احتمال preemption را تغییر می‌دهد.
5. چرا zone spread مفید است؟ — همهٔ replicaها را در یک failure domain جمع نمی‌کند.

## منابع

- [Scheduling, Preemption and Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/)
- [Pod Topology Spread Constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/)
- [Pod Disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [Netflix TechBlog: Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c)

</div>