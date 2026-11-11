<div dir="rtl" align="right">
نسخهٔ انگلیسی: [English](README.en.md) · [کتابخانهٔ منابع](../../../references/README.md#15-cluster-operations)

# آیا کلاستر خودمان را مدیریت کنیم؟

**فصل:** [عملیات کلاستر](../../README.md)

## تصمیم را از مسئولیت شروع کنید

Self-managed یعنی کنترل بیشتر و مسئولیت مستقیم‌تر برای control plane، certificate، etcd، upgrade، CNI/CSI، node OS، backup و incident. Managed بخشی را به provider واگذار می‌کند، اما workload، IAM، policy، هزینه، داده و recovery برنامه را از دوش شما برنمی‌دارد.

## ماتریس تصمیم

| پرسش | اگر پاسخ مثبت است |
| --- | --- |
| تیم on-call توان control plane و شبکه را دارد؟ | self-managed قابل‌بررسی‌تر می‌شود |
| نیاز به کنترل خاص زیرساخت/سازمان دارید؟ | self-managed ممکن است انعطاف بدهد |
| مهارت و زمان نگهداری محدود است؟ | managed هزینهٔ عملیات را کاهش می‌دهد |
| منطقه، SLA یا policy خاص دارید؟ | service فعلی و جایگزین را دقیق با الزامات بسنجید |
| برنامه ساده و کم‌ترافیک است؟ | container platform ساده‌تر را نیز مقایسه کنید |

هزینهٔ کل شامل VM، storage، egress، support، افزونه، زمان مهندس و downtime است. قیمت provider متغیر است؛ در این جزوه قیمت ثابت نمی‌دهم.

## چک‌لیست پیش از تصمیم

- owner تمام layerها و incidentها مشخص است؟
- backup و restore آزمایش شده؟
- upgrade، certificate rotation و node replacement runbook دارد؟
- CNI/CSI پشتیبانی و compatibility روشن دارد؟
- تیم می‌تواند 24/7 در حد نیاز محصول پاسخ دهد؟
- provider-specific بودن identity/network/storage قابل‌قبول است؟

## کوییز

1. Managed چه چیزی را حذف نمی‌کند؟ — مسئولیت برنامه، داده، IAM، هزینه و recovery.
2. هزینهٔ پنهان self-managed چیست؟ — نیروی متخصص، incident و cycle نگهداری.
3. چه زمانی گزینهٔ ساده‌تر را بسنجیم؟ — وقتی orchestration، scale و پلتفرم ارزش هزینهٔ خودمدیریتی را ندارند.
4. چرا backup test لازم است؟ — توان بازیابی را اثبات می‌کند، صرف وجود snapshot کافی نیست.

## منابع

- [Managed Kubernetes environments](https://kubernetes.io/docs/setup/production-environment/turnkey-solutions/)
- [Production Environment](https://kubernetes.io/docs/setup/production-environment/)
- [راهنمای فارسی محیط یادگیری](https://kubernetes.io/fa/docs/setup/learning-environment/)

</div>