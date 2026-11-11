<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](../../../en/kubernetes/10-autoscaling/README.md) · [کتابخانهٔ منابع](../references/README.md#10-autoscaling)

# فصل 10: Autoscaling

## هدف‌های فصل

- تفاوت مقیاس افقی Pod، مقیاس عمودی Pod و مقیاس node را بفهمید.
- متریک، request و ظرفیت را به حلقهٔ کنترل autoscaling وصل کنید.
- تأخیر startup و محدودیت cloud را در طراحی لحاظ کنید.
- نوسان scale و Podهای Pending را تشخیص دهید.

## سه کنترلر و سه مسئله

- **HPA:** شمار replicaهای workload را براساس metric تنظیم می‌کند.
- **VPA:** request/limit مناسب Pod را پیشنهاد یا اعمال می‌کند.
- **Cluster Autoscaler:** node capacity را براساس Podهای زمان‌نشده کم‌وزیاد می‌کند.

HPA و cluster autoscaler مکمل‌اند: HPA Pod اضافه می‌کند؛ اگر node جا نداشته باشد، Pod Pending می‌ماند تا ظرفیت جدید بیاید. VPA و HPA می‌توانند روی CPU یا memory با هم تعارض کنند؛ طراحی متریک و ownership را مشخص کنید.

## رابطهٔ متریک و replica

برای metric utilization، HPA نسبت actual به target را محاسبه و replica مطلوب را تقریب می‌زند. CPU utilization معمولاً نسبت به CPU request سنجیده می‌شود؛ request خالی یا نادرست باعث رفتار نامعتبر می‌شود. متریک custom/external نیازمند adapter و تعریف دقیق واحد و freshness است.

## ظرفیت و تأخیر

Pod ممکن است سریع‌تر از node جدید آماده شود یا برعکس؛ باید startup time، image pull، quota provider، اندازهٔ node و زمان warm-up را بسنجید. حداقل/حداکثر replica، budget هزینه و رفتار scale down را تنظیم کنید. node کاهش‌یافته ممکن است Pod را drain کند و storage یا PDB مانع شود.

## تمرین

بار آزمایشی بسازید، HPA را ببینید، replica را دستی محدود کنید و metric را خراب/غایب کنید. سپس Pod Pending و node scaling را دنبال کنید. این آزمایش را در cluster محلی بدون هزینهٔ cloud انجام دهید؛ در cloud quota و هزینه را پیشاپیش کنترل کنید.

## کوییز

1. HPA چه چیزی را تغییر می‌دهد؟ — تعداد replicaهای هدف.
2. چرا HPA با CPU request نیاز دارد؟ — utilization نسبت به request محاسبه می‌شود.
3. Podها Pending هستند؛ HPA چه چیزی را فراهم نمی‌کند؟ — node و ظرفیت فیزیکی.
4. VPA و HPA چه زمانی نوسان می‌سازند؟ — وقتی هم‌زمان بر مبنای همان metric منابع/تعداد را تغییر دهند.
5. چه چیزی scale-down را متوقف می‌کند؟ — disruption constraint، PDB، storage یا نبود ظرفیت تخلیه.

## منابع

- [Autoscaling مفاهیم رسمی](https://kubernetes.io/docs/concepts/workloads/autoscaling/)
- [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [VPA project](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)
- [راهنمای فارسی EasyEnv](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)

</div>