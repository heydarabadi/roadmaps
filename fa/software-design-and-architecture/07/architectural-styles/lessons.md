<div dir="rtl" align="right">

# درس کامل: سبک‌های معماری


> **زبان:** [نسخهٔ انگلیسی](../../../../en/software-design-and-architecture/07/architectural-styles/lessons.md)

## سبک معماری یعنی چه؟

سبک معماری محدودیت‌هایی دربارهٔ اجزا و رابطه‌های مجاز تعیین می‌کند. این محدودیت‌ها بعضی خاصیت‌ها را آسان و بعضی را دشوار می‌کنند. بنابراین «سبک مدرن» یا «مقیاس‌پذیر» پاسخ تصمیم نیست؛ باید بگویی چه قیدی می‌پذیری و برای کدام فشار محصول.

## ۱. Component-based

در معماری مؤلفه‌محور، قابلیت‌های منسجم در componentهایی با interface روشن جمع می‌شوند. component می‌تواند داخل یک process باشد و release جدا نداشته باشد. boundary tooling، API محدود، آزمون و مالکیت داده از پوشه‌بندی ساده مهم‌ترند.

این سبک معمولاً قدم خوبی برای ماژولارسازی است: ابتدا dependency داخلی را روشن کن؛ بعد اگر deploy یا scale مستقل لازم شد، استخراج سرویس را ارزیابی کن.

## ۲. Monolithic و Modular Monolith

Monolith یک واحد deploy است؛ این تعریف نمی‌گوید کد داخلش تمیز است یا آشفته. Modular monolith یک deployment با مرزهای درون‌فرایندی کنترل‌شده دارد: اجزا API محدود دارند، داده را از پشت contract می‌خوانند و مالکیت تغییر روشن است.

مزیت monolith: deployment و debug ساده‌تر، local call سریع، transaction سراسری آسان‌تر، هزینهٔ عملیاتی کم. ریسک: deploy همهٔ بخش‌ها به هم گره می‌خورد، مقیاس واحد است و boundaryها ممکن است فرسوده شوند.

Shopify گزارش کرده که بخش اصلی Rails خود را با componentها modular کرده و فقط کارکردهایی چون storefront rendering یا پرداخت حساس را با دلیل مستقل‌تری جدا کرده است. [گزارش Shopify](https://shopify.engineering/shopify-monolith).

## ۳. Layered / N-tier

Layered architecture مسئولیت منطقی را به presentation, application, domain و infrastructure تقسیم می‌کند. N-tier معمولاً آن لایه‌ها را به deployment/network tier هم تبدیل می‌کند. این دو واژه را با هم یکی ندان.

لایه‌بندی برای separation of concerns مفید است، اما call از UI تا دیتابیس می‌تواند از چند mapping و class عبور کند. dependency direction را تعریف کن؛ domain نباید از جزئیات web/database خبر داشته باشد اگر استقلال قواعد مهم است. برای CRUD کوچک، چندلایه‌سازی سنگین هزینهٔ اضافی می‌سازد.

## ۴. Structural styles

سبک ساختاری نحوهٔ اتصال اجزا را توصیف می‌کند. Pipe-and-filter، لایه‌ای و component collaboration نمونه‌هایی‌اند. یک نام مبهم مثل structural کافی نیست؛ connector، قرارداد داده، ترتیب و محل کنترل را مشخص کن. برای پردازش رسانه، pipeline مرحله‌ای می‌تواند قابل فهم باشد؛ برای workflow تعاملی با state مشترک شاید مناسب نباشد.

## ۵. Client-Server

Client درخواست می‌دهد و server مالک resource یا capability است. HTTP API معمولاً stateless request/response دارد، اما server همچنان state پایدار و session/domain data نگه می‌دارد. سمت client را منبع معتبر امنیتی فرض نکن: authentication, authorization و validation سمت server لازم‌اند.

هزینه‌ها: network latency، timeout، retry، نسخه‌بندی قرارداد، server capacity و failure جزئی. درخواست ممکن است server را اجرا کرده باشد ولی پاسخ در شبکه گم شود؛ command باید idempotency key یا reconciliation داشته باشد.

## ۶. Peer-to-Peer

در P2P گره می‌تواند هم مصرف‌کننده و هم ارائه‌دهندهٔ داده/منبع باشد. این سبک می‌تواند توزیع ظرفیت و تاب‌آوری بدهد، اما discovery، NAT, trust, churn, consistency و abuse را دشوار می‌کند. حذف server به‌تنهایی دلیل انتخاب P2P نیست؛ threat model و گره‌های نامطمئن را طراحی کن.

## ۷. Distributed systems

وقتی چند process روی شبکه همکاری می‌کنند، شبکهٔ کند/ناپایدار، clockهای متفاوت، duplicate message و خرابی جزئی واقعیت‌اند. distributed system یک سبک deploy یا فناوری نیست؛ مجموعه‌ای از failure modeهاست که باید در هر سبک توزیع‌شده مدیریت شوند.

اصول عملی:

- timeout داشته باش؛ بی‌نهایت منتظر نمان.
- retry را محدود، با backoff و jitter اجرا کن.
- command را idempotent کن تا retry اثر تکراری نسازد.
- circuit breaker و bulkhead را فقط برای dependency واقعی به کار ببر.
- consistency model و reconciliation را تعیین کن.
- correlation ID, logs, metrics و traces را از مرز عبور بده.

## ۸. Event-Driven

Producer رخداد fact را منتشر می‌کند؛ consumerها واکنش مستقل دارند. Event می‌گوید چه اتفاقی افتاد؛ command درخواست می‌کند کاری انجام شود. رویداد بعد از وقوع است و نباید منظور پنهانی «انجامش بده» داشته باشد.

وقتی producer نباید از subscriberها بداند، fan-out لازم است، یا پردازش async ارزش دارد، event-driven مفید است. اما ترتیب، duplicate، replay، schema evolution و eventual consistency را هم اضافه می‌کند. یک event bus control flow را از call stack پنهان می‌کند؛ observability ضروری است.

## ۹. Publish-Subscribe و Messaging

Publish-subscribe چند consumer را به topic/event وصل می‌کند و producer را از فهرست آن‌ها جدا می‌سازد. Message contract داده و semantics تبادل است. Queue معمولاً کار را به یک consumer/گروه می‌دهد و پس از پردازش ack می‌شود؛ stream سابقهٔ مرتب‌شده‌ای با offset/retention برای چند consumer می‌دهد. فناوری‌ها ممکن است قابلیت ترکیبی داشته باشند، پس semantics ابزار را بررسی کن.

~~~json
{
  "event": "OrderPaid",
  "orderId": "ord-1042",
  "occurredAt": "2026-11-10T09:00:00+03:30",
  "schemaVersion": 1
}
~~~

پیام production به owner، version policy، key برای partitioning، retry/DLQ، idempotency و data classification نیاز دارد. پیاده‌سازی reliable event publishing گاهی transactional outbox می‌خواهد تا تغییر دیتابیس و پیام از هم جا نمانند.

## ۱۰. مطالعهٔ موردی: انتخاب موردی

Prime Video گزارش کرد که سرویس مشخص پایش صوت/تصویر را از اجزای serverless توزیع‌شده به processهای یکپارچه‌تر منتقل کرد؛ در آن workload هزینهٔ انتقال داده و orchestration زیاد بود. گزارش ۹۰٪ کاهش هزینه دربارهٔ همان سرویس است، نه همهٔ Prime Video. [مقالهٔ تیم Prime Video](https://www.primevideotech.com/video-streaming/scaling-up-the-prime-video-audio-video-monitoring-service-and-reducing-costs-by-90).

Shopify از طرف دیگر از modular monolith بزرگی گزارش داده که با component boundary و ابزار، coupling داخلی را محدود می‌کند. کنار هم گذاشتن این دو تجربه نشان می‌دهد monolith/microservices/serverless را با measurement و workload انتخاب کن.

## ۱۱. سبک را چطور انتخاب کنیم؟

| فشار | گزینهٔ بررسی | چیزی که باید بسنجی |
| --- | --- | --- |
| محصول کوچک، یک تیم، قواعد ساده | monolith ساده یا ماژولار | آیا release و ownership کافی روشن‌اند؟ |
| کدبیس رو به رشد با deploy مشترک | modular monolith / component-based | آیا boundary درون‌فرایندی کافی است؟ |
| قابلیت‌ها و تیم‌های مستقل | microservices | هزینهٔ عملیات، دادهٔ جدا، contract و failure |
| کار سنگین/پس‌زمینه | Web-Queue-Worker | lag، retry، idempotency و backpressure |
| fan-out رخدادهای دامنه | event-driven/pub-sub | order, duplicate, evolution, observability |
| گره‌های مستقیم همکار | P2P | discovery, trust, churn و abuse |

تصمیم را بر اساس اندازهٔ تیم، تغییر، scale profile، security boundary، data ownership و هزینهٔ cloud ثبت کن. سبک‌ها قابل ترکیب‌اند، ولی ترکیب باید قابل توضیح بماند.

## ۱۲. کوییز پاسخ‌دار

۱. Monolith یعنی کد بدون ماژول؟
   - پاسخ: نه؛ فقط یک واحد deploy را توصیف می‌کند. modular monolith مرزهای درونی دارد.
۲. Layer و tier چه تفاوتی دارند؟
   - پاسخ: layer مسئولیت منطقی است؛ tier معمولاً جداشدن deployment/runtime/network را می‌رساند.
۳. Event و command چه فرق دارند؟
   - پاسخ: event fact رخ‌داده است؛ command درخواست انجام عمل.
۴. Queue و stream را با چه پرسشی مقایسه می‌کنی؟
   - پاسخ: آیا کار باید به یک consumer سپرده شود یا چند consumer به تاریخچه/offset مستقل نیاز دارند؟ semantics و broker را هم بررسی می‌کنم.
۵. چرا retry نیاز به idempotency دارد؟
   - پاسخ: درخواست ممکن است اجرا شده ولی پاسخ گم شده باشد؛ retry بدون idempotency اثر را تکرار می‌کند.
۶. آیا P2P همیشه availability را بهتر می‌کند؟
   - پاسخ: نه؛ churn، کشف گره، اعتماد و partition می‌تواند دسترسی را سخت‌تر کند.
۷. گزارش Prime Video چه نتیجه‌ای ثابت نمی‌کند؟
   - پاسخ: اینکه همهٔ پلتفرم یا همهٔ microservices را monolith کردند؛ فقط یک سرویس پایش را توصیف می‌کند.

## تمرین جامع: انتخاب سبک برای فروشگاه آنلاین

فروشگاه یک تیم دارد، روزانه چند هزار سفارش می‌گیرد، قواعد قیمت‌گذاری هنوز ساده‌اند و گزارش شبانه گاهی ده دقیقه طول می‌کشد. تیم می‌خواهد به microservices مهاجرت کند چون انتظار رشد دارد.

**کارها**
1. محدودیت‌ها و کیفیت‌های مهم را مشخص کن.
2. سبک شروع و راه‌حل گزارش را انتخاب کن.
3. معیارهایی بنویس که جداسازی سرویس را بعداً توجیه کند.

**پاسخ تشریحی:** با modular monolith و مرزهای روشن سفارش، کاتالوگ و پرداخت شروع می‌کنم؛ یک صف برای گزارش شبانه اضافه می‌کنم تا کار طولانی از پاسخ HTTP جدا شود. اندازهٔ فعلی به‌تنهایی microservices را توجیه نمی‌کند. latency، نرخ تغییر مستقل، bottleneck و مالکیت تیمی را اندازه می‌گیرم. وقتی یک capability واقعاً به scale یا release مستقل نیاز داشت، همان مرز را با قرارداد و مالک دادهٔ مشخص جدا می‌کنم. صف هم به retry محدود، idempotency، پایش lag و مسیر خطا نیاز دارد.

## منابع اختیاری

- [Microsoft Azure Architecture Center؛ سبک‌های معماری](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/)
- [Martin Fowler؛ Microservices](https://martinfowler.com/articles/microservices.html)
- [DNTips؛ معماری لایه‌بندی فارسی](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3)
- [Shopify؛ modular monolith](https://shopify.engineering/shopify-monolith)



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../references.md#chapter-07)
</div>
