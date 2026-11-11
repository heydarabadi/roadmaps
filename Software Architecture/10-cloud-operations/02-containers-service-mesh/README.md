<div dir="rtl" align="right">

# کانتینرها و Service Mesh

Container image برنامه و dependencyهای لازم را بسته‌بندی می‌کند، اما kernel را با host به اشتراک می‌گذارد و VM کامل نیست. image، runtime، filesystem لایه‌ای، network، secret، resource limit و orchestration همگی باید امن و قابل‌اداره باشند. Docker ابزار ساخت و اجرای container است؛ Kubernetes زمان‌بندی و کنترل desired state را مدیریت می‌کند.

Service mesh مثل Istio ترافیک service-to-service را با proxy و control plane مدیریت می‌کند: identity، mTLS، routing و telemetry. Mesh برای سازمانی با شبکهٔ پیچیده می‌تواند کمک کند، ولی cost و failure mode جدید می‌آورد. اگر تیم چند سرویس محدود دارد، کتابخانه یا platform ساده‌تر ممکن است کافی باشد.

## از source تا container image

Image باید reproducible و حداقلی باشد: base image معتبر و pin‌شده، build چندمرحله‌ای برای حذف compiler غیرلازم، dependency lock، اجرای non-root و اسکن artifact. tag قابل‌تغییر را به‌تنهایی به‌عنوان هویت release استفاده نکن؛ digest دقیق deploy را ثبت کن. secret داخل layer image باقی می‌ماند حتی اگر در لایهٔ بعد پاکش کنی.

Runtime محدودیت CPU و memory، filesystem، port و signal را تعریف می‌کند. process باید config را از محیط بگیرد اما secret را با دسترسی حداقلی بخواند. probe readiness و liveness هدف‌های جدا دارند و shutdown graceful باید پیاده شود.

## Kubernetes و desired state

Control plane وضعیت موردنظر را نگه می‌دارد؛ scheduler pod را روی node می‌گذارد؛ controllerها اختلاف desired و actual state را reconcile می‌کنند. Deployment نسخه و replica را مدیریت می‌کند، Service endpoint پایدار می‌دهد و Ingress/Gateway ورودی را route می‌کند. این اشیا خرابی application را خودکار حل نمی‌کنند؛ request/limit، probe، rollout، policy و RBAC درست لازم‌اند.

## Service mesh را چه وقت اضافه کنیم؟

Mesh identity سرویس، mTLS، retry/routing و telemetry را در لایهٔ platform عرضه می‌کند، ولی proxy هر hop resource و failure path جدید می‌آورد. debugging مسیر، upgrade control plane و policy پیچیده می‌شود. پیش از استقرار بپرس کدام نیاز را با چه معیار حل می‌کند و چرا ingress/library ساده‌تر کافی نیست. retry mesh و retry application را با هم حساب کن تا چندبرابر نشوند.

## تمرین

برای API و worker تصویری، image، non-root، config/secret، limit، health probe، graceful shutdown و storage را فهرست کن؛ سپس لزوم Kubernetes و mesh را با تعداد سرویس و قابلیت تیم بسنج.

## آزمون

۱. Container با VM چه تفاوت مهمی دارد؟ **پاسخ:** container معمولاً kernel host را شریک است و سبک‌تر است؛ VM سیستم‌عامل مهمان دارد.
۲. چرا image باید کوچک و pin شده باشد؟ **پاسخ:** سطح حمله و نوسان build را کاهش می‌دهد.
۳. Mesh چه چیزی را حل نمی‌کند؟ **پاسخ:** مرزبندی دامنه، کیفیت قرارداد یا تحمل خطای منطق برنامه را.
۴. Kubernetes برای هر app لازم است؟ **پاسخ:** خیر؛ orchestration هزینهٔ عملیاتی دارد و باید با نیاز مقایسه شود.

## تمرین

برای سرویس API و worker فایل Dockerfile مفهومی با non-root، health endpoint، config و storage ماندگار طراحی کن.

## پاسخ نمونهٔ تمرین

Image از base pin‌شده، multi-stage و non-root ساخته می‌شود؛ secret وارد layer نمی‌شود. config جدا، limit CPU/memory، readiness/liveness هدفمند، SIGTERM drain و object storage برای فایل ماندگار است. چند سرویس محدود معمولاً بدون mesh شروع می‌کنند؛ mesh زمانی افزوده می‌شود که mTLS/traffic policy/telemetry مرکزی ارزشش از proxy و control-plane complexity بیشتر باشد.

## منابع

- فارسی: [ساخت زیرساخت DevOps با Docker و Kubernetes](https://codity.ir/devops-infrastructure-docker-kubernetes/)، [DevDocs: Kubernetes و Linux](https://devdocs.ir/)
- انگلیسی: [Docker Overview](https://docs.docker.com/get-started/docker-overview)، [Kubernetes Architecture](https://kubernetes.io/docs/concepts/architecture/)، [Istio Concepts](https://istio.io/latest/docs/concepts/what-is-istio/)

</div>

