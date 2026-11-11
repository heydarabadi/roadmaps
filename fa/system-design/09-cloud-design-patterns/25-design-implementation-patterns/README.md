<div dir="rtl" align="right">
[English version](../../../../en/system-design/09-cloud-design-patterns/25-design-implementation-patterns/README.md)


# الگوهای Design و Implementation

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

الگوها گزینه‌های تکرارشونده‌اند، نه اجبار: Strangler برای مهاجرت، sidecar/gateway برای قابلیت جانبی و BFF برای نیاز متفاوت client.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Strangler قابلیت legacy را تدریجی پشت مسیر جدید می‌برد. Sidecar کنار سرویس کار مشترک می‌کند؛ Ambassador ارتباط خروجی را proxy می‌کند. Gateway routing مسیر نسخه را انتخاب، offloading کارهایی چون TLS/auth را منتقل و aggregation چند پاسخ را جمع می‌کند. BFF API مناسب هر client می‌دهد. External config store باید version، access control و rollback داشته باشد. Compute consolidation هزینه را کم اما blast radius را بیشتر می‌کند؛ pipes & filters مراحل را جدا می‌کند.

## درس گام‌به‌گام: الگوهای پیاده‌سازی

### مهاجرت و جداسازی قابلیت

**Strangler Fig:** یک facade یا routing layer جلوی سیستم قدیمی می‌گذارد و قابلیت‌ها را مرحله‌ای به implementation جدید منتقل می‌کند. مسیر هر قابلیت باید قابل مشاهده و برگشت باشد. Data dual-write بدون reconciliation خطرناک است؛ ابتدا مالکیت و migration strategy را تعیین کن. این الگو از big-bang migration می‌کاهد، اما دو سیستم و مسیر دادهٔ موازی را موقتاً نگهداری می‌کند.

**Anti-Corruption Layer:** adapter بین مدل دامنهٔ خودت و API/دادهٔ بیرونی قرار می‌گیرد تا اصطلاحات و محدودیت‌های legacy به هستهٔ برنامه نشت نکنند. ترجمه، validation و version handling در این مرز انجام می‌شود. اگر صرفاً passthrough است و مدل خارجی با دامنه یکی است، لایهٔ اضافه می‌تواند بی‌دلیل باشد.

### قابلیت جانبی و پردازش مرحله‌ای

**Sidecar:** process همراه برنامه در همان host/pod اجرا می‌شود؛ proxy، certificate renewal یا telemetry را ارائه می‌دهد. چرخهٔ عمر و منابع مشترک‌اند، اما failure/CPU sidecar می‌تواند برنامه را تحت تأثیر قرار دهد.

**Ambassador:** نوعی proxy خروجی است که اتصال به dependency خارجی را مدیریت می‌کند؛ TLS، retry محدود یا routing را می‌تواند متمرکز کند. تعداد hopها، identity و مالکیت policy را ثبت کن؛ پراکسی مبهم تشخیص را سخت می‌کند.

**Pipes & Filters:** هر filter یک تبدیل محدود انجام می‌دهد و خروجی را به مرحلهٔ بعد می‌دهد؛ مثلاً دریافت فایل، parse، validate، enrich و persist. retry و replay per-stage ممکن است؛ باید schema ورودی/خروجی و ترتیب را حفظ کرد.

### استقرار محتوای ثابت

**Static Content Hosting:** فایل‌های JS/CSS/image را از compute جدا و در object storage/CDN می‌گذاری. URL نسخه‌دار cache طولانی می‌گیرد؛ deployment باید asset جدید را پیش از HTML reference منتشر کند و فایل‌های قدیمی را تا پایان cache نگه دارد. برای فایل private، authorization و URL محدود لازم است.

### Leader Election

وقتی یک worker باید کار انحصاری را انجام دهد، nodeها برای leadership هماهنگ می‌شوند. Lease یا quorum رهبر را انتخاب می‌کند؛ heartbeat منقضی‌شده ممکن است رهبر قدیمی را فقط از دید follower غایب نشان دهد، در حالی که هنوز نوشتن می‌کند. Fencing token رو به افزایش در هر نوشتن بررسی می‌شود تا صاحب lease قدیمی رد شود. election خود سامانهٔ توزیع‌شده و نیازمند failure handling است.

### Gateway family

**Gateway Routing:** بر اساس path، header، tenant یا نسخه درخواست را route می‌کند. rollout تدریجی و canary ممکن می‌شود؛ policy باید پایدار و قابل مشاهده باشد.

**Gateway Offloading:** کار عمومی مانند TLS termination، authentication مقدماتی، compression یا rate limit را از سرویس‌ها به gateway منتقل می‌کند. سرویس مالک همچنان باید authorization دامنه‌ای را enforce کند؛ offloading مرز امنیتی تنها نیست.

**Gateway Aggregation:** پاسخ چند backend را برای client در یک round trip جمع می‌کند. timeout هر dependency، partial result، caching و ترتیب باید مشخص باشد. منطق دامنهٔ چندمرحله‌ای را داخل gateway انباشته نکن؛ gateway پرتراکم به monolith جدید تبدیل می‌شود.

**Backend for Frontend (BFF):** برای mobile، web یا partner APIهای متناسب می‌سازد تا هر client داده/shape لازم را بگیرد. BFF باید بهینه‌سازی تجربهٔ client باشد، نه تکثیر منطق کسب‌وکار و مجوز. در صورت share بالای منطق، library یا domain service مناسب‌تر است.

### Config و منابع compute

**External Configuration Store:** config را از artifact جدا می‌کند تا rollout و تنظیم مستقل شود. secret و config را جدا/محافظت‌شده نگه‌دار؛ version، validation، audit، cache و rollback داشته باش. تغییر config زنده ممکن است هزاران instance را هم‌زمان تحت تأثیر بگذارد، پس staged rollout و safe default مهم‌اند.

**Compute Resource Consolidation:** چند workload را برای utilization و هزینه بهتر روی منابع مشترک قرار می‌دهد. quota، scheduler، priority، isolation و noisy-neighbor monitoring لازم‌اند. consolidation شکست‌های هم‌بسته و اثر security boundary را زیاد می‌کند؛ workload حساس/پرنوسان شاید نیاز به جداسازی داشته باشد.

### CQRS و مدل خواندن

در این فصل CQRS را به‌عنوان الگوی implementation ببین: command handler قواعد و write model را اجرا می‌کند؛ query endpoint از read model بهینه‌شده می‌خواند. پس از write ممکن است projection عقب باشد؛ UI وضعیت pending یا نسخهٔ session را مدیریت کند. برای هر query یک read model جدا نساز؛ هزینهٔ projection و rebuild باید با سود پاسخ‌گویی توجیه شود.

### جدول انتخاب الگو

| مسئله | الگوی محتمل | شرط موفقیت |
| --- | --- | --- |
| جایگزینی legacy مرحله‌ای | Strangler Fig | route قابل برگشت و مالکیت داده روشن |
| API خارجی با مدل ناسازگار | Anti-Corruption Layer | ترجمهٔ معنا و version contract |
| قابلیت مشترک کنار سرویس | Sidecar/Ambassador | resource cap و failure isolation |
| API clientهای متفاوت | BFF | منطق کسب‌وکار در domain service بماند |
| محتوای عمومی حجیم | Static hosting/CDN | versioning و cache policy امن |
| تنظیم زندهٔ چند نمونه | External config store | validation، audit و staged rollout |

## مرور همهٔ ریزموضوع‌های roadmap

- Strangler Fig: جایگزینی تدریجی legacy با route و قابلیت تازه.
- Sidecar: قابلیت هم‌میزبان مثل proxy/telemetry کنار برنامه.
- Static Content Hosting: تحویل فایل ثابت از object store/CDN.
- Leader Election: انتخاب یک هماهنگ‌کننده؛ fencing برای رهبر دیررس.
- CQRS: جداکردن مدل command از query؛ سازگاری projection را مدیریت کن.
- Pipes & Filters: مراحل مستقل با قرارداد ورودی/خروجی.
- Ambassador: proxy ارتباط خروجیِ سرویس را مدیریت می‌کند.
- Gateway Routing: انتخاب backend براساس route/نسخه.
- Gateway Offloading: انتقال TLS، auth یا rate limit به gateway با مالکیت امنیت روشن.
- Gateway Aggregation: جمع‌کردن پاسخ‌های فنی چند سرویس برای یک client.
- External Config Store: پیکربندی نسخه‌دار، امن و قابل rollback.
- Compute Resource Consolidation: تجمیع برای کاهش هزینه با خطر noisy neighbor.
- Backend for Frontend: API متناسب برای هر نوع client.
- Anti-Corruption Layer: adapter برای جلوگیری از نشت مدل legacy/بیرونی به دامنه.

## مثال عملی

در مهاجرت سفارش، بخشی از routeها به سرویس تازه می‌روند؛ reconciliation و مسیر rollback آماده است.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

Strangler برای مهاجرت تدریجی؛ BFF برای clientهای متفاوت؛ از gateway با منطق کسب‌وکار زیاد اجتناب کن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- دو منبع حقیقت؛ proxy chain طولانی؛ config بی‌نسخه؛ sidecar بی‌نیاز؛ fallback حذف‌شده.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. Strangler چه ریسکی را می‌کاهد؟
2. Gateway aggregation کجا نباید orchestration شود؟
3. consolidation چه اثری بر blast radius دارد؟

### پاسخ‌نامهٔ فشرده

1. Strangler قابلیت‌های legacy را تدریجی به مسیر تازه منتقل می‌کند و big-bang را کاهش می‌دهد.
2. gateway را برای routing/aggregation فنی نگه دار؛ منطق دامنه و workflow طولانی در سرویس مالک/ارکستریتور باشد.
3. چند tenant یا workload روی compute مشترک می‌توانند منابع را رقابتی و خرابی را هم‌بسته کنند.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

الگوها گزینه‌های تکرارشونده‌اند، نه اجبار: Strangler برای مهاجرت، sidecar/gateway برای قابلیت جانبی و BFF برای نیاز متفاوت client. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [API Gateway](https://virgool.io/%40javadAgha/gateway-api-%DA%86%D9%87-%DA%A9%D8%A7%D8%B1%DB%8C-%D8%A7%D9%86%D8%AC%D8%A7%D9%85-%D9%85%DB%8C-%D8%AF%D9%87%D8%AF-mpxgnytywqua)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Microsoft: Microservices architecture](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

