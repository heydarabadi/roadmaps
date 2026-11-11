<div dir="rtl" align="right">
[English version](../../../../en/system-design/06-async-and-messaging/22-idempotency/README.md)


# Idempotent Operations

## هدف یادگیری

- مسئله‌ای را که این مفهوم حل می‌کند تعریف کنی.
- برای یک سامانهٔ نمونه انتخاب را با trade-off توضیح بدهی.
- رفتار سیستم را هنگام اختلال پیش‌بینی کنی.

## ایدهٔ مرکزی

عملیات idempotent با تکرار همان intent اثر تجاری را دوباره اجرا نمی‌کند؛ برای retry شبکه و redelivery پیام ضروری است.

## نقشهٔ مفهومی

نیاز کسب‌وکار ← قرارداد بار/کیفیت ← انتخاب الگو ← نقطهٔ شکست ← مشاهده و بازیابی

## توضیح کامل

کلاینت یک کلید برای intent ثابت می‌فرستد؛ سرور کلید، hash ورودی و نتیجه را با uniqueness نگه می‌دارد. همان کلید و ورودی نتیجهٔ قبلی را می‌دهد؛ همان کلید با payload متفاوت باید رد شود. TTL از پنجرهٔ retry و عمر کسب‌وکار پیروی کند. Side effect خارجی به outbox، ledger یا provider key نیاز دارد.

## درس گام‌به‌گام

### چرا شبکه ابهام می‌سازد؟

Client درخواست charge می‌فرستد. Server پرداخت را انجام می‌دهد اما پاسخ در شبکه گم می‌شود. Client فقط timeout می‌بیند و نمی‌داند charge نشده یا پاسخ نرسیده است. اگر درخواست تازه بسازد، ممکن است مشتری دوبار شارژ شود؛ اگر هیچ‌وقت retry نکند، سفارش بی‌نتیجه بماند. شبکه راهی به caller نمی‌دهد که از روی timeout بفهمد side effect رخ داده یا نه.

### قرارداد کلید

Client برای یک intent تجاری ثابت کلیدی پایدار می‌سازد و در هر retry همان را می‌فرستد. Scope کلید باید tenant/account و operation را مشخص کند؛ کلید تصادفی یا قابل‌پیش‌بینی نباشد. Server hash canonical ورودی را ذخیره می‌کند. اگر همان key با ورودی متفاوت بیاید، `409 Conflict` یا خطای قراردادی برمی‌گرداند. پاسخ قبلی یا وضعیت در حال اجرا را به caller می‌دهد.

### ثبت اتمیک با اثر کسب‌وکار

یک جدول idempotency key با unique constraint داشته باش. درج کلید و ایجاد رکورد intent باید در یک transaction محلی انجام شوند. فقط درخواست برنده اجازهٔ انجام مرحلهٔ بعد را دارد. اگر اثر اصلی در همان DB است، ثبت وضعیت و تغییر موجودی را اتمیک کن. اگر اثر در provider خارجی است، از کلید idempotency خود provider استفاده کن، request را durable نگه‌دار و پاسخ provider را reconcile کن؛ DB محلی نمی‌تواند transaction اتمیک با بانک ایجاد کند.

### وضعیت‌ها و درخواست هم‌زمان

وضعیت‌های `in_progress`، `completed` و `failed_retryable` را تعریف کن. درخواست هم‌زمان با همان key نباید اثر را دوباره اجرا کند؛ می‌تواند پاسخ در جریان یا نتیجهٔ قبلی را بگیرد. اگر owner درخواست crash کرد، lease/timeout و recovery process لازم است تا کلید برای همیشه در حالت pending نماند. نتیجهٔ نهایی را تا مدت لازم نگه‌دار؛ پاک‌کردن کلید زودهنگام duplicate دیررس را دوباره فعال می‌کند.

### Idempotency در consumer پیام

برای پیام، `event_id` یا business key را با نتیجهٔ پردازش در datastore ثبت کن. در یک transaction، «آیا این شناسه قبلاً انجام شده؟» را با نوشتن اثر کنترل کن. سپس broker ack شود. اگر crash پس از commit و قبل از ack رخ دهد، redelivery دیده می‌شود و اثر دوباره اعمال نمی‌شود. اگر effect بیرونی است، outbox/inbox و کلید provider لازم است.

### چه چیزی idempotent نیست؟

عملیات idempotent با اجرای دوبارهٔ همان intent حالت نهایی یکسانی دارد؛ این به معنای بی‌هزینه‌بودن retry، نادیده‌گرفتن payload یا dedupe همیشگی نیست. `PUT /profile/1` با همان مقدار معمولاً idempotent است؛ `POST /charge` فقط وقتی قراردادی ساخته‌ای. retry policy باید فقط خطای transient، deadline، backoff و سقف داشته باشد. کلید را از log عمومی و telemetry حذف یا mask کن.

## مثال عملی

پاسخ پرداخت timeout شده؛ retry با همان key نتیجهٔ charge قبلی را بازیابی می‌کند.

## نمونهٔ قرارداد / شبه‌کد

~~~text
جدول کلید idempotency باید unique constraint، request hash، status و result را نگه دارد.
~~~

## تجربهٔ موردی واقعی منتشرشده

[Amazon Builders' Library: ایمن‌کردن retry با APIهای idempotent](https://aws.amazon.com/builders-library/making-retries-safe-with-idempotent-APIs/) — مطالعهٔ موردی عمومی است؛ آن را با نسخه و محدودیت‌های زمان انتشار بخوان.

## تجربهٔ عملی و تصمیم‌های معماری

نمونهٔ مهندسی برای مطالعه: [Amazon Builders Library](https://aws.amazon.com/builders-library/)

برای پرداخت، رزرو و create؛ حتی اگر endpoint ظاهراً GET است، side effect پنهان را بررسی کن.

| تصمیم | چه زمانی مناسب است | کجا پرریسک می‌شود |
| --- | --- | --- |
| راه‌حل ساده | بار و دامنه محدود، رفتار قابل‌اندازه‌گیری | نیاز اثبات‌شدهٔ چندمنطقه‌ای یا حد ظرفیت |
| الگوی توزیع‌شده | نیاز روشن به جداسازی، ظرفیت یا دوام | پیچیدگی عملیاتی از سود بیشتر شود |

## دام‌ها و سوءبرداشت‌ها

- ثبت کلید بعد از charge؛ TTL کوتاه؛ payload متفاوت؛ تصور exactly-once میان چند سرویس.
- عددهای مثال آموزشی‌اند؛ SLO و ظرفیت نهایی را از دادهٔ واقعی تعیین کن.

## آزمون کوتاه

1. چرا سرور نتیجهٔ درخواست اول را همیشه نمی‌داند؟
2. قید یکتا را کجا می‌گذاری؟
3. با ورودی متفاوت و همان کلید چه می‌کنی؟

### پاسخ‌نامهٔ فشرده

1. timeout پاسخ را مبهم می‌کند: درخواست شاید اجرا شده و پاسخ گم شده یا اصلاً نرسیده باشد.
2. با ثبت کلید یکتا و نتیجه در تراکنش/ledger منبع حقیقت، اتمیک نسبت به اثر کسب‌وکار.
3. درخواست را رد کن؛ یک کلید نباید برای دو intent متفاوت استفاده شود.

## تمرین

برای یک فروشگاه اینترنتی، مسیر درخواست این مفهوم را رسم کن. منبع حقیقت، مرز شبکه، رفتار شکست، دادهٔ حساس، معیار پایش و راه بازگشت را مشخص کن. سپس یک آزمون خرابی بنویس که بتواند فرض اصلی را رد کند.

## خلاصه

عملیات idempotent با تکرار همان intent اثر تجاری را دوباره اجرا نمی‌کند؛ برای retry شبکه و redelivery پیام ضروری است. پیش از پیاده‌سازی رفتار عادی، حالت اختلال و معیار موفقیت را ثبت کن.

## مبنای roadmap

- [System Design Roadmap — نسخهٔ تعاملی](https://roadmap.sh/system-design)
- [PDF رسمی roadmap.sh با شاخه‌ها و ریزموضوع‌ها](https://roadmap.sh/pdfs/roadmaps/system-design.pdf)

### مقالهٔ فارسی

- [اید‌مپوتنسی و تاب‌آوری تراکنش‌ها](https://dntips.ir/www.dntips.ir-posts-3769.html)

### منابع انگلیسی و تجربه‌های مهندسی

- [Stripe: Idempotent requests](https://docs.stripe.com/api/idempotent_requests)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)
- [Amazon Builders Library](https://aws.amazon.com/builders-library/)

</div>

