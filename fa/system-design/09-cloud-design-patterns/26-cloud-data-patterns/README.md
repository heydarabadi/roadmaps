<div dir="rtl" align="right">
[English version](../../../../en/system-design/09-cloud-design-patterns/26-cloud-data-patterns/README.md)


# الگوهای Cloud برای Data

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

الگوهای داده سرعت query یا جداسازی را با هزینهٔ نسخه‌های مشتق و سازگاری نهایی مبادله می‌کنند.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

Sharding داده را partition می‌کند؛ Materialized View/Index Table پاسخ query را آماده می‌کنند. Event Sourcing رویداد دامنه را ثبت می‌کند؛ CQRS read و write model را جدا می‌کند. Cache-Aside fill را به برنامه می‌دهد. Valet Key دسترسی blob کوتاه‌عمر می‌دهد و میزبانی Static Content بار فایل را از compute می‌گیرد. Projection باید نسخه‌پذیر و بازسازی‌پذیر باشد.

## مرور همهٔ ریزموضوع‌های roadmap

- Valet Key: دسترسی محدود و کوتاه‌عمر به blob.
- Static Content Hosting: فایل عمومی را از compute جدا می‌کند.
- Sharding: داده را با کلید به partitionها پخش می‌کند.
- Materialized View: query/aggregation را از پیش می‌سازد.
- Index Table: lookup ثانویهٔ متناسب با مسیر خواندن نگه می‌دارد.
- Event Sourcing: رویدادهای تغییر state را ثبت می‌کند.
- CQRS: مدل نوشتن/خواندن را جدا می‌کند.
- Cache-Aside: برنامه در miss از منبع پر می‌کند.

## درس گام‌به‌گام

### یک منبع حقیقت و چند مدل خواندن

در سامانهٔ عملی ممکن است یک منبع حقیقت برای سفارش داشته باشیم و چند مدل مشتق برای feed، گزارش و جست‌وجو. منبع حقیقت باید invariantهای کسب‌وکار را enforce کند؛ read model با event/outbox به‌روز می‌شود و ممکن است lag داشته باشد. API باید بگوید کدام query read-your-writes می‌خواهد و کدام query stale را می‌پذیرد. هر مدل مشتق را version، rebuild و reconcile کن.

### Sharding و انتخاب کلید

Sharding ظرفیت storage/write را با پخش داده بین partitionها بالا می‌برد. کلید باید بار متوازن، queryهای لازم و growth را در نظر بگیرد. Range key query بازه‌ای را آسان می‌کند اما زمان جاری می‌تواند hotspot بسازد؛ hash کلیدها را پخش می‌کند اما range scan را سخت می‌کند. Tenant key، user key یا compound key به workload وابسته‌اند. پیش از اجرا plan انتقال داده، rebalancing، failure recovery و cross-shard query را بنویس.

### Materialized View و Index Table

Materialized view نتیجهٔ محاسبه/Join را از قبل ذخیره می‌کند؛ index table یک lookup ثانویه می‌سازد. هر write باید یا همهٔ مدل‌ها را اتمیک به‌روز کند، یا رویداد durable/outbox منتشر و lag را تحمل کند. Snapshot view باید امکان rebuild داشته باشد؛ اگر projection خراب شد، از event/source replay کن و نسخهٔ schema را عوض کن. view را براساس query واقعی بساز، نه برای همهٔ queryهای احتمالی.

### CQRS و Event Sourcing

CQRS مسئولیت تغییر و خواندن را جدا می‌کند؛ read side می‌تواند denormalized و سریع باشد. هزینهٔ آن eventual consistency، read modelهای بیشتر و عملیات replay است. Event Sourcing به جای نگهداری فقط state فعلی، eventهای تغییر را append می‌کند؛ audit و بازسازی مفید است، اما eventها باید schema version، ordering، idempotent consumer و retention داشته باشند. این دو مستقل‌اند؛ CRUD ساده با یک جدول از آن‌ها سودی نمی‌برد.

### Cache-Aside

در cache miss، application از source می‌خواند و entry را با TTL می‌گذارد. هنگام update باید کلید را invalidate، نسخه‌دار یا read model را refresh کند. Cache فقط وقتی سود دارد که hit بالا، miss manageable و داده با freshness قرارداد سازگار باشد. Cache-shared برای دادهٔ tenantدار باید tenant در key داشته باشد تا نشت اتفاق نیفتد.

### Valet Key و static hosting

Valet key مانند URL امضاشده، اختیار محدود و موقت به client می‌دهد تا blob را مستقیم بخواند/بنویسد. object id، method، expiry و اندازه محدود باشند؛ بعد از upload server file type و مالکیت را کنترل کند. Static hosting فایل عمومی versioned را به object store/CDN می‌دهد تا application server صرف API و منطق بماند. URL عمومی، private object و cache مشترک را باهم ترکیب نکن.

### جدول تصمیم

| الگو | ورودی لازم برای تصمیم | هزینهٔ مهم |
| --- | --- | --- |
| Sharding | حجم/نرخ، کلید و query profile | rebalancing و cross-shard query |
| Materialized View/Index Table | query گران و پرتکرار | lag، rebuild، storage و write amplification |
| CQRS | خواندن/نوشتن با نیازهای متفاوت | projection و consistency نهایی |
| Event Sourcing | نیاز واقعی audit/replay | schema evolution و replay پیچیده |
| Cache-Aside | hit rate و freshness هدف | invalidation و stampede |
| Valet Key/Static hosting | انتقال مستقیم فایل | مجوز، expiry و cache policy |

برای walkthrough کامل CQRS، Event Sourcing، sharding و Cache-Aside به [درس الگوهای مدیریت داده](../../05-data-and-caching/18-data-patterns/README.md) برو؛ این صفحه هر الگوی cloud را در زمینهٔ معماری جمع‌بندی می‌کند.

## مثال عملی

فاکتور immutable در object storage، metadata در DB و لینک امضاشده محدود به کاربر.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

View برای query پرتکرار؛ sharding پس از tuning؛ Event Sourcing برای تاریخچهٔ ارزشمند، نه CRUD معمولی.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- projection stale؛ رویداد بی‌نسخه؛ bucket عمومی؛ URL طولانی‌عمر؛ cache بدون invalidate.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. CQRS الزاماً با Event Sourcing می‌آید؟
2. شارد بد چه hotspotی می‌سازد؟
3. لینک valet key را با چه محدودیت‌هایی صادر می‌کنی؟

### پاسخ‌نامهٔ فشرده

1. پاسخ یا aggregation گران را از قبل محاسبه و برای query آماده نگه می‌دارد.
2. CQRS شکل read/write را جدا می‌کند؛ Event Sourcing تاریخچهٔ رویداد را ذخیره می‌کند و یک انتخاب مستقل است.
3. scope شیء و عملیات، مالک، tenant و زمان انقضای کوتاه.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

الگوهای داده سرعت query یا جداسازی را با هزینهٔ نسخه‌های مشتق و سازگاری نهایی مبادله می‌کنند. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [CQRS و Event Sourcing](https://www.hostragons.com/fa/%D9%88%D8%A8%D9%84%D8%A7%DA%AF/%D8%A7%D9%84%DA%AF%D9%88%D9%87%D8%A7%DB%8C-%D9%85%D9%86%D8%A8%D8%B9%DB%8C%D8%A7%D8%A8%DB%8C-%D8%B1%D9%88%DB%8C%D8%AF%D8%A7%D8%AF-%D9%88-cqrs/)

### منابع انگلیسی و تجربه‌های مهندسی

- [Azure Architecture Center: Design Patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/)
- [Azure: CQRS pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)
- [Azure: Event Sourcing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/event-sourcing)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

