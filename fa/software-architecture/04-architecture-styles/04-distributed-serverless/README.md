<div dir="rtl" align="right">

# سیستم توزیع‌شده، Actor و Serverless

سیستم توزیع‌شده روی چند process اجرا می‌شود و از latency، شکست جزئی، اختلاف ساعت، تکرار یا جابه‌جایی پیام و replicaهای ناهمگام اثر می‌پذیرد. Serverless مدل مصرف اجراست، نه حذف زیرساخت. Actor مالک state خودش است و با پیام ارتباط می‌گیرد.

برای مرز شبکه timeout تعریف کن. retry باید محدود، با backoff و jitter باشد؛ در عملیات تغییردهنده idempotency را تعریف کن. Circuit breaker، bulkhead، correlation ID، صف مرده و telemetry به مهار خطا کمک می‌کنند؛ هیچ‌کدام منطق درست دامنه را خودکار ایجاد نمی‌کنند.

## مثال: پردازش عکس کالا

ثبت عکس رویداد پایدار می‌سازد. worker serverless تصویر را resize می‌کند. پیام ممکن است دوباره برسد، پس خروجی نسخه‌دار و پردازش idempotent است. صف burst را جذب می‌کند و DLQ پیام مشکل‌دار را برای تحلیل نگه می‌دارد. اگر کار طولانی یا runtime ویژه می‌خواهد، container worker را هم بسنج.

| گزینه | سود | هزینه |
| --- | --- | --- |
| Function مدیریت‌شده | مقیاس بر اساس مصرف | محدودیت اجرا، cold start و وابستگی provider |
| Actor runtime | مالکیت state و concurrency پیام‌محور | persistence و رفتار توزیع |
| سرویس دائمی | کنترل runtime و کار طولانی | ظرفیت، استقرار و patching |

## درس گام‌به‌گام: طراحی مصرف‌کنندهٔ مقاوم

فرض کن پیام ProductImageUploaded دو بار تحویل شود و worker هنگام ذخیرهٔ خروجی از کار بیفتد:

۱. **تحویل را تعریف کن.** بسیاری از صف‌ها تحویل حداقل یک‌بار دارند؛ پیام تکراری ممکن است برسد. بدون تضمین end-to-end فرض «دقیقاً یک‌بار» نساز.
۲. **شناسهٔ پایدار بگذار.** event ID و شناسهٔ تصویر را نگه دار و بفهم این event قبلاً تکمیل شده است یا نه.
۳. **اثر را idempotent کن.** خروجی را بر اساس شناسه و نسخه در مسیر deterministic بنویس یا نتیجه و وضعیت پردازش را اتمی ذخیره کن. crash بین دو نوشتن را تحلیل کن.
۴. **زمان و retry را محدود کن.** timeout تابع، تعداد retry و backoff را تنظیم کن. خطای دائمی مثل فایل خراب با تکرار درمان نمی‌شود.
۵. **DLQ را عملیاتی کن.** dead-letter باید alarm، مالک، دستور بازپخش امن و سیاست حذف داشته باشد؛ وگرنه فقط محل دفن خطاست.
۶. **مشاهده‌پذیری بساز.** event ID را در log و trace حفظ کن؛ سن پیام، عمق صف، نرخ retry و DLQ را اندازه بگیر.

برای پرداخت نیز اثر بیرونی باید idempotent باشد: provider باید کلید تکرار را پشتیبانی کند یا وضعیت پیش از retry استعلام شود. idempotent بودن کد تابع کافی نیست اگر provider دوباره پول برداشت کند.

## Actor در برابر صف و تابع

Actor با mailbox و مالکیت state، دسترسی هم‌زمان به state همان actor را سری می‌کند؛ اما پیام ازدست‌رفته، restart، partition، persistence یا انتقال state را خودکار حل نمی‌کند. صف برای buffer کار بین producer و consumer است؛ serverless function برای اجرای کوتاه‌عمر مصرفی مناسب است؛ سرویس دائمی برای اتصال بلندمدت یا پردازش طولانی ممکن است بهتر باشد. مدل را با نیاز انتخاب کن، نه مد روز.

## محاسبهٔ هزینهٔ Serverless

هزینه فقط مدت اجرا نیست: تعداد invocation، زمان و حافظه، شبکه و egress، صف و storage، log و trace، cold start، quota و هزینهٔ سرویس‌های جانبی را هم حساب کن. برای بار یکنواخت و دائمی، container همیشه‌روشن ممکن است ارزان‌تر و پیش‌بینی‌پذیرتر باشد؛ برای burst و بیکاری طولانی، مصرف‌محور ممکن است سودمند باشد. محدودیت اجرا، حافظه، concurrency و region را در مستندات پلتفرم منتخب بررسی کن.

## دسترس‌پذیری و سازگاری

با چند replica، خواندن ممکن است از نوشتن عقب باشد؛ مشخص کن کجا read-after-write لازم است و کجا lag پذیرفتنی است. circuit breaker تماس بی‌فایده را موقتاً متوقف می‌کند؛ fallback باید از نظر کسب‌وکار معتبر باشد. ثبت سفارش به‌صورت «موفق» وقتی نتیجهٔ پرداخت نامعلوم است fallback معتبر نیست.

## آزمون

۱. timeout چرا اثبات نمی‌کند عملیات شکست خورده؟ **پاسخ:** پاسخ ممکن است گم شود، درحالی‌که server عمل را commit کرده باشد.
۲. idempotency چه فایده‌ای دارد؟ **پاسخ:** اجرای تکراری را به یک اثر منطقی تبدیل می‌کند.
۳. Serverless چه چیزی را حذف نمی‌کند؟ **پاسخ:** طراحی امنیت، شبکه، failure، telemetry و هزینه.
۴. Actor model به‌تنهایی durability دارد؟ **پاسخ:** خیر؛ persistence جداست.

## تمرین

برای ارسال فاکتور، Function و worker کانتینری را بر اساس burst، طول اجرا، هزینه، شبکه و مشاهده‌پذیری مقایسه کن.

## پاسخ نمونهٔ تمرین

Function برای burst کوتاه‌مدت و idleness طولانی هزینهٔ مصرفی و scale خودکار می‌دهد؛ محدودیت اجرا، cold start، observability و provider limits را بررسی کن. Worker container برای کار طولانی، dependency خاص یا مصرف دائمی کنترل runtime بهتر می‌دهد اما ظرفیت/patching می‌خواهد. هر دو باید invoice ID را idempotency key کنند، retry محدود داشته باشند و failure را observable کنند.

## منابع

- فارسی: [آموزش فارسی Event-Driven](https://github.com/gloonch/eventdrivenfarsi)، [مبانی معماری فارسی](https://www.alirostami.com/software-architecture/)
- انگلیسی: [AWS Event-Driven Architecture](https://aws.amazon.com/event-driven-architecture/)، [Azure Serverless Architecture](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/serverless)، [Akka Actors](https://doc.akka.io/libraries/akka-core/current/typed/actors.html)

</div>

