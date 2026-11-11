<div dir="rtl" align="right">
[English version](../../en/05-data-and-caching/18-data-patterns/README.md)


# الگوهای مدیریت داده

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

الگوهای داده سرعت یا جداسازی خواندن/نوشتن را با نسخه‌های مشتق‌شده و سازگاری نهایی مبادله می‌کنند.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Sharding داده را بین partitionها می‌برد؛ کلید بد hotspot می‌سازد. Materialized View و Index Table query را از پیش آماده می‌کنند. Event Sourcing تغییرات را ثبت و state را بازسازی می‌کند؛ CQRS مدل read/write را جدا می‌کند و الزاماً Event Sourcing نیست. Cache-aside برنامه را مسئول fill می‌کند. Valet Key دسترسی محدود به blob می‌دهد؛ میزبانی ایستا بایت را از compute جدا می‌کند.

## درس گام‌به‌گام و مرور الگوها

### Sharding

داده را با shard key بین partitionها تقسیم می‌کنیم. کلید باید queryهای پرتکرار را پشتیبانی کند و بار را پخش کند. `user_id` برای inbox یک کاربر خوب است، اما query «همهٔ رویدادهای آخر ساعت» ممکن است همهٔ shardها را بخواند؛ کلید زمانی ممکن است همهٔ نوشتن‌های فعلی را به یک partition داغ کند. Hash distribution، range partition، virtual node و rebalancing هرکدام مزایا و محدودیت دارند. قبل از sharding، index، query، cache و scale عمودی را بسنج؛ shard migration پرهزینه است.

### Materialized View و Index Table

Materialized view نتیجهٔ join/aggregate را ذخیره می‌کند تا خواندن پرتکرار سریع شود. باید رویداد تغییر منبع را بگیرد، نسخه/offset نگه دارد و تأخیر projection را نمایش دهد. Index table lookup متفاوتی را به جدول یا store مشتق اضافه می‌کند؛ write باید منبع و index را هماهنگ یا با outbox/eventually consistent کند. اگر query view با source اختلاف دارد، سیاست rebuild و reconciliation لازم است.

### CQRS

Command model تغییرات را اعتبارسنجی و ثبت می‌کند؛ query model پاسخ‌هایی مطابق نیاز خواندن می‌سازد. این دو می‌توانند schema یا datastore متفاوت داشته باشند. مزیت آن optimize جداگانهٔ write/read و خواندن پیچیده است؛ هزینه‌اش projection، versioning، latency همگرایی و debug بیشتر است. CQRS لازم نیست به معنی دو پایگاه داده یا Event Sourcing باشد. اگر CRUD ساده است، یک مدل واحد معمولاً بهتر است.

### Event Sourcing

به جای overwrite state، eventهای دامنه مانند `OrderPlaced`، `PaymentCaptured` و `OrderCancelled` را append می‌کنیم؛ state فعلی از replay یا snapshot به دست می‌آید. تاریخچهٔ قصد تغییر و audit قوی می‌شود. باید event schema را version بدهی، event را immutable نگه داری، consumerها را idempotent کنی و replay را کنترل کنی. رویداد همان log فنی نیست؛ نام و معنا باید در واژگان دامنه باشد. حذف/اصلاح دادهٔ شخصی نیز نیازمند سیاست حقوقی و طراحی است.

### Cache-Aside

برنامه ابتدا cache را می‌خواند، در miss منبع را می‌گیرد و با TTL/نسخه cache می‌کند. Update منبع می‌تواند key را invalidate کند یا نسخهٔ تازه بسازد. حذف کردن cache entry به تنهایی تضمین نمی‌کند درخواست هم‌زمان دادهٔ قدیمی را دوباره ننویسد؛ version/fencing یا سیاست stale-while-revalidate را در نظر بگیر.

### Valet Key و Static Content Hosting

Valet key یک URL/token امضاشده و محدود برای دسترسی مستقیم به object storage است. Scope را به یک object و یک operation محدود کن، expiration کوتاه بگذار و پس از upload ownership، MIME type و size را بررسی کن. Static hosting فایل‌های عمومی versioned را از server application جدا می‌کند؛ CDN آن را از edge تحویل می‌دهد. فایل private نباید با URL عمومی یا cache مشترک منتشر شود.

### تصمیم انتخاب

| نیاز | گزینهٔ محتمل | پرسش سخت |
| --- | --- | --- |
| query خواندنی گران و پرتکرار | materialized view/index table | تاخیر و rebuild را چطور مدیریت می‌کنی؟ |
| تقسیم حجم/نوشتن از سقف یک node بیشتر شده | sharding | کلید و hot partition چیست؟ |
| audit و بازسازی تاریخچه ارزش واقعی دارد | Event Sourcing | schema و retention چطور evolve می‌شود؟ |
| read/write model نیاز متفاوت دارند | CQRS | چه هزینه‌ای برای projection پذیرفته‌ای؟ |
| فایل بزرگ از client جابه‌جا می‌شود | Valet Key/object storage | authorization و expiry کجاست؟ |

## مثال عملی

فاکتور blob می‌ماند در object storage؛ metadata در DB؛ client URL امضاشدهٔ کوتاه‌عمر می‌گیرد.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

CQRS برای نیازهای read/write متفاوت؛ sharding پس از tuning/vertical scale؛ Event Sourcing برای audit یا بازسازی واقعی، نه CRUD ساده.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- projection عقب‌افتاده؛ رویداد بی‌نسخه؛ shard داغ؛ URL دائمی؛ cache بدون policy.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. CQRS و Event Sourcing چه فرقی دارند؟
2. shard key بد چه مشکلی می‌سازد؟
3. valet key چه محدودیت‌هایی می‌خواهد؟

### پاسخ‌نامهٔ فشرده

1. CQRS فقط command/read model را جدا می‌کند؛ Event Sourcing تاریخچهٔ تغییرات را منبع حقیقت می‌کند و مستقل انتخاب می‌شود.
2. کلید با skew مثل tenant خیلی بزرگ یا مقدار محبوب می‌تواند بار را روی یک partition متمرکز کند.
3. object، عملیات مجاز (GET/PUT)، انقضا، اندازه/نوع محتوا و tenant/مالک.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

الگوهای داده سرعت یا جداسازی خواندن/نوشتن را با نسخه‌های مشتق‌شده و سازگاری نهایی مبادله می‌کنند. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [CQRS و Event Sourcing](https://www.hostragons.com/fa/%D9%88%D8%A8%D9%84%D8%A7%DA%AF/%D8%A7%D9%84%DA%AF%D9%88%D9%87%D8%A7%DB%8C-%D9%85%D9%86%D8%A8%D8%B9%DB%8C%D8%A7%D8%A8%DB%8C-%D8%B1%D9%88%DB%8C%D8%AF%D8%A7%D8%AF-%D9%88-cqrs/)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure: CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)
- [Azure: Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)
- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

