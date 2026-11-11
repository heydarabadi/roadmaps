<div dir="rtl" align="right">
[English version](../../en/04-application-architecture/15-service-discovery/README.md)


# Service Discovery

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

نمونه‌های پویا باید با سازوکار به‌روز پیدا شوند؛ discovery سمت کلاینت یا proxy انجام می‌شود و health/expiry اهمیت دارد.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Client-side discovery registry را می‌خواند و endpoint را انتخاب می‌کند؛ server-side انتخاب را به LB/proxy می‌سپارد. ثبت، lease/TTL، readiness، zone awareness و identity لازم‌اند. DNS ساده اما cacheدار است؛ service mesh سیاست مشترک را به proxy منتقل می‌کند و control plane می‌افزاید.

## درس گام‌به‌گام

### چرا آدرس ثابت کافی نیست؟

نمونه‌های سرویس هنگام deploy، autoscaling یا خرابی اضافه و حذف می‌شوند. اگر client آدرس `10.0.1.12` را در تنظیم دائمی نگه دارد، ممکن است به instance مرده یا جایگزین‌شده وصل شود. Service discovery فهرست endpointهای قابل استفاده را براساس نام سرویس، ناحیه، نسخه و سلامت پیدا می‌کند. DNS معمولاً برای نام سطح بالا کافی است؛ محیط‌های بسیار پویا به registry یا orchestration control plane نیاز دارند.

### ثبت، health و انقضای رکورد

Instance هنگام شروع می‌تواند خود را register کند یا پلتفرم deployment آن را ثبت کند. Heartbeat/lease مانع باقی‌ماندن endpoint مرده می‌شود، ولی heartbeat صرفاً نشان می‌دهد process یا agent پاسخ می‌دهد. Readiness باید بررسی کند که instance آمادهٔ بار است: warm-up تمام شده، config معتبر است و dependencyهای حیاتی در وضع قابل قبول‌اند. هنگام shutdown ابتدا deregister و connectionها را drain کن، سپس process را متوقف کن.

### Client-side و server-side discovery

در client-side، هر caller endpointها را می‌گیرد، health/zone را لحاظ و مقصد را انتخاب می‌کند. این توزیع‌شده است ولی کتابخانه‌ها و cacheهای client پیچیده می‌شوند. در server-side، reverse proxy یا load balancer انتخاب می‌کند؛ رفتار client ساده‌تر اما proxy مسیر حیاتی و ظرفیت‌دار می‌شود. Service mesh انتخاب، mTLS و telemetry را به proxyهای sidecar می‌سپارد؛ control plane و عیب‌یابی آن هزینه دارد.

### Cache و تغییر topology

Client اغلب endpoint list را cache می‌کند. اگر TTL خیلی بلند باشد، failover دیر دیده می‌شود؛ اگر هر درخواست registry را بپرسد، خود registry گلوگاه و dependency سخت می‌شود. Cache کوتاه‌مدت، fallback کنترل‌شده، retry با محدودیت و refresh پس از خطای اتصال می‌توانند کمک کنند. مراقب refresh storm در زمان outage باش.

### Region، identity و امنیت

انتخاب endpoint فقط «نزدیک‌ترین» نیست. وضعیت داده، residency، ظرفیت، health و مالکیت shard باید رعایت شود. پاسخ discovery را از منبع مورد اعتماد بگیر، mTLS یا هویت workload را برای ارتباط بررسی کن و endpointهای داخلی را عمومی منتشر نکن. DNS discovery هم خطر تغییر IP و cache دارد؛ مراجع داخلی و خارجی را جدا نگه‌دار.

### روش عیب‌یابی

اگر call به service نمی‌رسد، به‌ترتیب نام resolveشده، نسخهٔ cacheشده، registry status، readiness، route/LB، policy شبکه و TLS identity را بررسی کن. یک health dashboard باید تعداد endpoint سالم، stale registration، زمان انتشار تغییر و توزیع منطقه‌ای را نشان دهد.

## مثال عملی

نمونه در deploy تا آماده نشده نباید ترافیک بگیرد؛ هنگام shutdown ابتدا از discovery خارج و درخواست‌های جاری drain شوند.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

نمونهٔ عمومی: [شرح زیرساخت Uber](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) به service discovery و routing در سامانه‌ای با وابستگی‌های فراوان می‌پردازد؛ ابزارهای داخلی آن‌ها را به‌عنوان انتخاب اجباری تلقی نکن.

DNS برای محیط کم‌تغییر؛ registry پویا برای autoscaling؛ mesh زمانی که سیاست مشترک چند سرویس ارزشمند است.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- endpoint stale؛ health فقط heartbeat؛ وابستگی به registry در هر request؛ نبود graceful deregistration.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. فرق client و server discovery چیست؟
2. چرا heartbeat سلامت کامل را ثابت نمی‌کند؟
3. چطور نمونهٔ در حال خروج را drain می‌کنی؟

### پاسخ‌نامهٔ فشرده

1. در client-side caller registry را می‌پرسد و instance برمی‌گزیند؛ در server-side proxy/LB این کار را می‌کند.
2. heartbeat فقط نشان می‌دهد سیگنالی می‌آید؛ سرویس ممکن است درخواست را به‌موقع پاسخ ندهد یا dependency حیاتی خراب باشد.
3. از registry خارجش کن، جلوی درخواست جدید را بگیر، سپس درخواست‌های جاری را drain کن.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

نمونه‌های پویا باید با سازوکار به‌روز پیدا شوند؛ discovery سمت کلاینت یا proxy انجام می‌شود و health/expiry اهمیت دارد. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [API Gateway](https://virgool.io/%40javadAgha/gateway-api-%DA%86%D9%87-%DA%A9%D8%A7%D8%B1%DB%8C-%D8%A7%D9%86%D8%AC%D8%A7%D9%85-%D9%85%DB%8C-%D8%AF%D9%87%D8%AF-mpxgnytywqua)

### منابع انگلیسی و تجربه‌های مهندسی

- [HashiCorp Consul: Service Discovery](https://developer.hashicorp.com/consul/docs/concepts/service-discovery)
- [Microsoft: Microservices architecture](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

