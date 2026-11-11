<div dir="rtl" align="right">
[English version](../../en/05-data-and-caching/16-databases/README.md)


# پایگاه داده: SQL و NoSQL

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

انتخاب DB از query، تراکنش، consistency، ظرفیت و توان عملیاتی تیم شروع می‌شود، نه شعار schema-less یا مقیاس.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

SQL برای قیود، join و تراکنش چندردیفی مناسب است. NoSQL شامل key-value، document، wide-column و graph است و هرکدام workload متفاوت دارد. Index نوشتن و فضا هزینه دارد؛ schema evolution و restore نیز لازم‌اند. انتخاب یک DB دوم ownership و همگام‌سازی اضافه می‌کند.

## درس گام‌به‌گام

### از query شروع کن، نه از نام محصول

برای هر قابلیت بنویس چه چیزی نوشته می‌شود، چه چیزی خوانده می‌شود، آیا lookup با key است یا range/join، چه ترتیب و freshness لازم دارد، اندازهٔ داده و نرخ رشد چقدر است و آیا چند تغییر باید اتمیک شوند. بعد گزینهٔ ذخیره‌سازی را براساس الگوی دسترسی بسنج. یک دیتابیس محبوب نمی‌تواند به‌تنهایی همهٔ مدل‌های داده و SLAها را با هزینهٔ کم حل کند.

### مدل رابطه‌ای و ACID

Relational database داده را در جدول و رابطه مدل می‌کند و constraintهایی مانند foreign key و unique را در منبع حقیقت enforce می‌کند. ACID به atomicity (همه یا هیچ)، consistency (حفظ invariantهای تعریف‌شده)، isolation (محدودکردن اثر هم‌زمانی) و durability (ماندن commit پس از خرابی‌های در محدودهٔ تضمین‌شده) اشاره دارد. Isolation level مهم است؛ `READ COMMITTED` و `SERIALIZABLE` رفتار و هزینهٔ متفاوت دارند. ACID به معنی اینکه برنامه هیچ bug منطقی ندارد نیست.

### خانواده‌های NoSQL

- Key-value: lookup ساده با کلید؛ session، feature flag یا cache.
- Document: دادهٔ نیمه‌ساختاریافته و aggregate با خواندن/نوشتن کنارهم؛ باید index و queryها را بشناسی.
- Wide-column: partition و دسترسی حجیم بر اساس کلید/ترتیب؛ طراحی query-first مهم است.
- Graph: رابطه و traversal چندمرحله‌ای؛ برای joinهای شبکه‌ای خاص می‌تواند مناسب باشد.

این‌ها مرز بازاریابی نیستند؛ سیستم‌های ترکیبی ویژگی‌های چند مدل دارند. «schema-less» یعنی الزام schema از دیتابیس به برنامه منتقل شده، نه اینکه schema وجود ندارد.

### Index و هزینهٔ query

Index پیدا کردن row را سریع می‌کند اما فضا و کار write اضافه دارد؛ هر update باید indexهای مرتبط را تغییر دهد. ابتدا queryهای واقعی و cardinality را بشناس. Composite index ترتیب ستون دارد: index روی `(tenant_id, created_at)` برای فیلتر tenant و بازهٔ زمان مناسب است، اما شاید برای فیلتر فقط created_at مناسب نباشد. `EXPLAIN` و query plan نشان می‌دهند موتور چه می‌کند. N+1، full scan، lock contention و connection exhaustion از علل رایج‌اند.

### تراکنش و invariant

قواعدی مانند «شناسهٔ پرداخت برای هر provider یکتا است» را با constraint پایگاه داده هم enforce کن؛ بررسی فقط در کد در رقابت هم‌زمان fail می‌شود. تراکنش را کوتاه نگه‌دار و network call را داخل transaction طولانی انجام نده. برای عملیات بین چند سرویس از saga/outbox استفاده کن و مرز اتمیک بودن را صریح بنویس.

### Replication، partitioning و backup

Replication نسخهٔ داده می‌سازد و می‌تواند read scaling بدهد؛ sharding داده را بین بخش‌ها پخش می‌کند تا ظرفیت ذخیره/نوشتن افزایش یابد. Sharding queryهای cross-partition، rebalancing و hot key را پیچیده می‌کند. این دو جای backup نیستند. Backup زمان‌بندی، encryption، retention، point-in-time recovery و تمرین restore می‌خواهد. موفقیت backup job تا زمانی که restore سنجیده نشده، اثبات recovery نیست.

### روش انتخاب

برای هر گزینه یک نمونهٔ query، transaction، index، migration، backup/restore و عملیات incident طراحی کن. هزینهٔ consistency و مهارت تیم را حساب کن. دیتابیس دوم تنها زمانی ارزش دارد که مزیت workload آن روشن باشد و مالکیت، sync، retention و failure mode آن مشخص شود.

## مثال عملی

سفارش و پرداخت به constraint و تراکنش نیاز دارند؛ session می‌تواند key-value باشد.

## نمونهٔ قرارداد / شبه‌کد

~~~text
CREATE UNIQUE INDEX ux_payment_key ON payments(provider, idempotency_key);
~~~

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Uber Engineering](https://www.uber.com/blog/engineering/)

SQL برای رابطه/یکپارچگی؛ document برای aggregate مناسب؛ graph برای پیمایش رابطه. از polyglot persistence بی‌نیاز دوری کن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- NoSQL را بی‌schema فرض‌کردن؛ انتخاب فناوری محبوب؛ index زیاد؛ restore تمرین‌نشده.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. key-value برای چه workloadی خوب است؟
2. چرا uniqueness در DB هم لازم است؟
3. هزینهٔ datastore دوم چیست؟

### پاسخ‌نامهٔ فشرده

1. session و lookup با کلید یکتا و دسترسی ساده معمولاً برای key-value مناسب‌اند.
2. دو درخواست هم‌زمان ممکن است هر دو قبل از ثبت برنامه‌ای کلید را آزاد ببینند؛ unique constraint اتمیک رقابت را می‌بندد.
3. schema، migration، backup/restore، امنیت، پایش و سازگاری بین منابع داده.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

انتخاب DB از query، تراکنش، consistency، ظرفیت و توان عملیاتی تیم شروع می‌شود، نه شعار schema-less یا مقیاس. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [معماری وب و اجزای یک سامانه](https://virgool.io/Quera-Mag/%D9%85%D8%B9%D9%85%D8%A7%D8%B1%DB%8C-%D9%88%D8%A8-%D8%A2%D8%B4%D9%86%D8%A7%DB%8C%DB%8C-%D9%85%D9%81%D8%A7%D9%87%DB%8C%D9%85-%D9%BE%D8%A7%DB%8C%D9%87-ofbcud4oao0c)

### منابع انگلیسی و تجربه‌های مهندسی

- [AWS: Choosing a database](https://docs.aws.amazon.com/whitepapers/latest/choosing-an-aws-database/choosing-an-aws-database.html)
- [PostgreSQL: Streaming Replication](https://www.postgresql.org/docs/current/warm-standby.html)
- [Uber Engineering](https://www.uber.com/blog/engineering/)

</div>

