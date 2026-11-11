<div dir="rtl" align="right">
[English version](../../../en/system-design/11-capstone-project/README.md)


# پروژهٔ پایانی: طراحی checkout فروشگاه در زمان فروش ویژه

این پروژه مفاهیم ده فصل را در یک طراحی واحد به هم وصل می‌کند. اعداد مسئله فرض آموزشی‌اند تا روش تخمین را تمرین کنی؛ آن‌ها ادعای ظرفیت هیچ شرکت یا محصولی نیستند.

## صورت مسئله

فروشگاه آنلاین صفحهٔ کالا، سبد خرید و ثبت سفارش دارد. در کمپین، بار بالا می‌رود. کاربر پس از زدن «پرداخت» نباید دوبار charge شود؛ موجودی منفی نباید ایجاد شود؛ پاسخ سیستم باید وضعیت روشن بدهد، حتی اگر درگاه پرداخت دیر جواب دهد.

### نیازمندی‌های کارکردی

- مشاهدهٔ محصول و قیمت فعلی.
- ثبت سفارش با اقلام و قیمتِ snapshotشده.
- رزرو موجودی برای زمان محدود.
- درخواست پرداخت و ثبت نتیجهٔ نهایی یا pending.
- retry امن از client و پیگیری وضعیت سفارش.
- ارسال رسید پس از موفقیت.

### نیازمندی‌های کیفی نمونه

- در بار عادی p95 مسیر آغاز checkout زیر 500ms باشد؛ تماس درگاه در همین deadline اجباری نیست.
- درخواست پذیرفته‌شده پس از crash از بین نرود.
- duplicate request یک سفارش/charge دوم نسازد.
- در اختلال اعلان، ثبت پرداخت متوقف نشود.
- دسترسی به سفارش فقط برای مالک یا نقش مجاز باشد.

## فرض‌های بار

فرض کن 200 هزار سفارش در روز و ضریب اوج 10 داریم. میانگین `200000 / 86400 ≈ 2.31` سفارش در ثانیه و اوج تقریبی 23 سفارش در ثانیه است. در کمپین استثنایی، 5 برابر اوج یعنی حدود 115 سفارش در ثانیه را برای 10 دقیقه فرض کن. اگر هر سفارش به‌طور میانگین 3KB دادهٔ اصلی دارد، دادهٔ خام سفارش تقریباً 600MB در روز است؛ index، event، replica و retention به این عدد اضافه می‌شوند.

حدود اعداد را محاسبه کن، سپس مشخص کن کدام جزء read-heavy است (کاتالوگ)، کدام write-critical است (سفارش/موجودی/پرداخت) و کدام asynchronous است (رسید). تقسیم بار را با workload این اجزا بسنج.

## معماری پیشنهادی برای نسخهٔ اول

برای تیم کوچک، modular monolith با مرز ماژول‌های کاتالوگ، سفارش، موجودی و پرداخت می‌تواند شروع کم‌هزینه باشد. API stateless جلوی SQL database قرار می‌گیرد؛ جدول‌های سفارش و ledger پرداخت transaction محلی دارند. Outbox در همان DB رخدادهای لازم برای worker را ذخیره می‌کند. Worker اعلان را پردازش می‌کند؛ cache فقط کاتالوگ عمومی را سریع می‌کند.

~~~mermaid
flowchart LR
  C[Client] --> G[API Gateway / Rate Limit]
  G --> A[Order API]
  A --> DB[(SQL: orders, inventory, payment ledger, outbox)]
  A --> P[Payment Provider]
  DB --> W[Outbox Worker]
  W --> Q[Durable Queue]
  Q --> N[Notification Worker]
  C --> S[Order Status API]
  S --> DB
  CDN[CDN Cache] --> CAT[Public Catalog]
  C --> CDN
~~~

اگر بار یا ownership تیم رشد کرد، ماژول‌ها را فقط براساس نیاز استقلال deploy/scale جدا کن. جداسازی زودهنگام، تراکنش محلی را به saga و observability/network complexity تبدیل می‌کند.

## طراحی قرارداد API

### آغاز سفارش

`POST /v1/orders` با `Idempotency-Key` و اطلاعات سبد ارسال می‌شود. Server کاربر را احراز و مالکیت کالا/موجودی را بررسی می‌کند، قیمت و تخفیف را از منبع معتبر می‌خواند و snapshot می‌سازد. پاسخ می‌تواند `201 Created` با وضعیت `pending_payment` بدهد، یا `202 Accepted` اگر درخواست فقط job durable را آغاز کرده است. تفاوت این دو را در قرارداد روشن نگه‌دار.

### پیگیری وضعیت

`GET /v1/orders/{id}` مالکیت را بررسی و state را می‌دهد: `pending_payment`, `paid`, `payment_failed`, `cancelled`, `needs_review`. اطلاعات کارت و secret در response یا log قرار نمی‌گیرد. اگر وضعیت نامعلوم است، به‌جای نمایش موفقیت، pending و زمان retry بعدی را نشان بده.

## داده و invariantها

- `orders`: order id، owner id، وضعیت، مبلغ و currency snapshot، timestamp.
- `order_items`: SKU، تعداد، قیمت واحد زمان خرید.
- `inventory_reservations`: SKU، order id، تعداد، expiry، وضعیت.
- `payments`: provider، provider reference، idempotency key، مبلغ، وضعیت و پاسخ لازم برای reconciliation.
- `outbox`: event id، aggregate id/version، نوع و payload محدود، زمان انتشار.

قواعد «یک idempotency key برای یک intent»، «provider reference یکتا»، «موجودی رزروشده از موجودی قابل فروش بیشتر نشود» و «مبلغ charge با مبلغ سفارش برابر باشد» باید در منطق و constraintهای مناسب enforce شوند. اعداد پولی را decimal/واحد کوچک integer نگه‌دار؛ float برای حساب پول مناسب نیست.

## مسیر عادی و سناریوی پرداخت مبهم

1. API با transaction، order pending و رزرو موجودی را ایجاد و outbox event را ثبت می‌کند.
2. Worker درخواست پرداخت را با همان idempotency key به provider می‌فرستد.
3. پاسخ موفق با provider reference ثبت می‌شود؛ status به paid می‌رود.
4. رویداد `OrderPaid` در outbox قرار می‌گیرد؛ اعلان‌گر مستقل رسید می‌فرستد.

اگر provider charge کند ولی پاسخ در شبکه گم شود، order را fail قطعی اعلام نکن. با همان کلید از provider status را بپرس یا همان درخواست idempotent را retry کن؛ تا روشن‌شدن نتیجه سفارش pending می‌ماند. اگر provider کلید idempotency ندارد، reconciliation با statement/reference و صف بررسی دستی لازم است. انقضای رزرو باید با قواعد کسب‌وکار و وضعیت پرداخت هماهنگ باشد؛ لغو زودهنگام و سپس charge دیررس می‌تواند تضاد بسازد.

## مقیاس‌پذیری و رفتار زیر بار

- Katalog عمومی را CDN/cache می‌تواند خدمت دهد؛ checkout قیمت را دوباره از source معتبر می‌خواند.
- API را stateless و افقی scale کن؛ session محلی یا file محلی به instance نچسبد.
- connection pool کل instanceها را جمع بزن و با سقف DB مقایسه کن.
- در کمپین rate limit و queue را برای کارهای جانبی به‌کار ببر؛ سفارش حیاتی را در صف نامحدود مخفی نکن.
- SKU داغ hotspot موجودی می‌سازد؛ lock کوتاه، atomic update یا partition ownership لازم است.
- notification backlog نباید worker پرداخت را اشغال کند؛ pool و queue جدا داشته باشند.
- اگر DB write به سقف برسد، ابتدا query/transaction و workload را اصلاح کن؛ replica خواندنی نوشتن را افزایش نمی‌دهد.

## Availability، consistency و recovery

موجودی و ledger مسیر سازگاری قوی‌تری می‌خواهند؛ شمارندهٔ صفحه و گزارش فروش می‌تواند با تأخیر همگرا شود. برای DB، backup مستقل و آزمون restore لازم است. Replica تأخیر دارد؛ پس از ایجاد سفارش، status را از primary یا read-your-writes مسیر بده. RTO/RPO را با کسب‌وکار تعیین و failover را تمرین کن. اعلان‌ها قابل retry و idempotent باشند؛ خطای اعلان نباید order را rollback کند.

## امنیت و حریم خصوصی

AuthN هویت کاربر را تأیید می‌کند؛ AuthZ هر خواندن/تغییر order را براساس owner/role می‌سنجد. Secret درگاه را در secret manager نگه‌دار و rotate کن. نرخ درخواست و اندازهٔ payload را کنترل کن. اطلاعات کارت را ذخیره نکن مگر الزامات و مسئولیت کامل آن روشن باشد؛ از tokenization provider استفاده کن. signed URL فایل رسید باید کوتاه‌عمر و محدود باشد. audit مالی، دسترسی محدود و retention اطلاعات شخصی را تعریف کن.

## مشاهده‌پذیری و SLO

SLIهای پیشنهادی: نرخ ایجاد سفارش موفق، نرخ پرداخت نهایی، p95/p99 آغاز checkout، سن oldest outbox/queue، نرخ payment timeout/duplicate، inventory conflict و error budget ماهانه. Trace باید client request id، order id، outbox event id و provider call را وصل کند؛ شناسه‌های شخصی در metric label نگذار. Alert برای افزایش pendingهای قدیمی یا پرداخت‌های نامشخص مهم‌تر از CPU تنهاست.

## آزمون‌های معماری

- همان درخواست را هم‌زمان 10 بار بفرست؛ فقط یک order/charge ایجاد شود.
- پاسخ provider را پس از charge عمداً drop کن؛ وضعیت نهایی را بدون charge دوباره بازیابی کن.
- worker را بعد از commit و پیش از ack متوقف کن؛ redelivery اثر تکراری نسازد.
- DB را کند کن؛ pool و queue محدود بمانند و API deadline رعایت شود.
- notification queue را پر کن؛ checkout همچنان کار کند و alert backlog بیاید.
- replica را عقب بینداز؛ status بلافاصله بعد از ثبت برای همان کاربر کهنه نشود.
- failover را اجرا کن و RTO/RPO واقعی، reconciliation و صحت ledger را بسنج.

## پاسخ نمونه به پرسش‌های طراحی

### چرا payment را در transaction دیتابیس نگه نمی‌داریم؟

درگاه بیرونی عضو transaction محلی نیست و ممکن است کند یا مبهم پاسخ دهد. transaction DB را کوتاه نگه می‌داریم، intent/outbox را پایدار می‌کنیم، provider را با idempotency key صدا می‌زنیم و نتیجه را ثبت/reconcile می‌کنیم.

### چرا همه چیز را microservice نمی‌کنیم؟

نسخهٔ اول تیم/بار فرض‌شده الزام مستقلی برای deployment ندارد؛ modular monolith مرز دامنه را نگه می‌دارد و عملیات ساده‌تر است. اگر تیم پرداخت نیاز انتشار/SLO/مقیاس مستقل پیدا کرد، جداکردن مرحله‌ای با قرارداد و outbox توجیه می‌شود.

### اگر دیتابیس از کار بیفتد چه می‌کنیم؟

API سفارش را با خطای روشن یا پذیرش محدودشده پاسخ می‌دهد؛ صف in-memory جای دادهٔ پایدار نیست. primary/replica طبق RTO/RPO promotion می‌شوند، درخواست‌های مبهم idempotent باقی می‌مانند و پس از بازگشت reconciliation انجام می‌شود. backup جدا برای خرابی منطقی و restore استفاده می‌شود.

## تمرین پایانی

این طراحی را برای سیستم رزرو بلیت تغییر بده: آخرین صندلی هم‌زمان به چند کاربر فروخته نشود، payment timeout درست مدیریت شود، صندلی پس از مدت مشخص آزاد شود و region دوم در قطعی وارد سرویس شود. پاسخ باید نمودار، invariantها، قرارداد retry، SLI/SLO، RTO/RPO و تست خرابی داشته باشد.

</div>

