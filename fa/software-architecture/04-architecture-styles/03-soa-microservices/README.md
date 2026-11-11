<div dir="rtl" align="right">

# SOA و Microservices

SOA و microservices قابلیت را با service contract عرضه می‌کنند. SOA معمولاً برای قابلیت‌های مشترک و یکپارچه‌سازی سازمانی است؛ microservices بر سرویس‌های مستقل با مالکیت داده و انتشار جدا تأکید دارد. مرز را از business capability پیدا کن.

هر تماس شبکه خطاپذیر است؛ tracing، discovery، versioning، secrets، incident response و هماهنگی داده هزینه دارند. استقلال تیمی بدون مالکیت داده و عملیات واقعی به دست نمی‌آید. API Gateway می‌تواند route و concerns مشترک را انجام دهد، اما نباید منطق دامنه را در خود جمع کند.

Netflix دربارهٔ معماری سرویس‌ها و بازسازی pipeline پردازش ویدئو نوشته است. این نمونه تجربهٔ مقیاس و بلوغ عملیاتی خاصی را نشان می‌دهد، نه نسخه‌ای برای کپی‌کردن در هر سازمان.

| انتخاب | مناسب | هزینه |
| --- | --- | --- |
| Monolith ماژولار | تیم کوچک، دامنهٔ در حال کشف | انتشار و scale مشترک |
| SOA | قابلیت مشترک در سازمان | governance و هماهنگی |
| Microservices | مرز و مالکیت روشن | پیچیدگی توزیع و آن‌کال |

## درس گام‌به‌گام: آیا یک قابلیت باید سرویس شود؟

سرویس را بر اساس **قابلیت کسب‌وکار و مالکیت** نام‌گذاری کن، نه یک جدول یا فعل فنی. برای استخراج payments از فروشگاه:

۱. **مرز دامنه:** پرداخت چرخهٔ عمر خودش را دارد: شروع، تأیید، رد و برگشت.
۲. **مالک داده:** سرویس پرداخت مالک intent، تراکنش و تطبیق است؛ سفارش شناسه و وضعیت تجاری لازم را نگه می‌دارد. سرویس دیگر نباید با SQL در جدول پرداخت بنویسد.
۳. **قرارداد:** CreatePayment با شناسهٔ سفارش و idempotency key؛ پاسخ اولیه می‌تواند Pending باشد. callback یا رویداد بعدی نتیجه را می‌رساند.
۴. **سازگاری:** سفارش و پرداخت یک ACID transaction نیستند. state machine و saga تعریف کن: سفارش PendingPayment می‌شود، نتیجهٔ موفق آن را تأیید می‌کند و timeout به reconciliation می‌رود.
۵. **شکست:** اگر payment timeout شد، دوباره charge نکن؛ وضعیت را از provider استعلام کن یا عملیات idempotent را تکرار کن. برای پیام تکراری، deduplication و transition معتبر لازم است.
۶. **استقلال واقعی:** تیم باید مالک build، deploy، پایش، رخداد، schema و پشتیبانی باشد. اگر هر release هنوز هماهنگی هم‌زمان می‌خواهد، استقلال عملی حاصل نشده.

## تماس همگام، پیام ناهمگام و API Gateway

تماس همگام ساده است، اما latency و دسترس‌پذیری زنجیره را به caller منتقل می‌کند. پیام ناهمگام burst را جدا می‌کند، ولی تأخیر، تکرار، ترتیب، dead-letter و سازگاری نهایی می‌آورد. gateway در مرز ورودی می‌تواند authentication، routing، rate limit و telemetry مشترک انجام دهد؛ policy دامنه‌ای و workflow را داخل gateway جمع نکن.

قرارداد را سازگار با نسخهٔ قبلی تغییر بده: مصرف‌کننده اول شکل جدید را هم می‌فهمد، سپس تولیدکنندهٔ جدید deploy می‌شود، داده یا پیام مهاجرت می‌کند و فقط پس از مشاهدهٔ نبود مصرف‌کنندهٔ قدیمی فیلد منسوخ حذف می‌شود. برای هر نسخه پایان عمر تعریف کن.

## نشانه‌های معماری نیازمند بازبینی

- سرویس‌های بسیار ریز با deploy و on-call پرهزینه می‌توانند نشانهٔ مرزگذاری بیش از حد باشند.
- مالکیت مشترک جدول یا تغییر schema هماهنگ، استقلال ناقص را نشان می‌دهد.
- latency آبشاری و retry هم‌زمان به deadline، bulkhead، محدودسازی بار و fallback معتبر نیاز دارند.
- تراکنش توزیع‌شده با retry ساده حل نمی‌شود؛ stateها، تحویل، idempotency، جبران و reconciliation را روشن کن.

تجربهٔ Netflix یا شرکت دیگر برای استخراج trade-off مفید است. نتیجه به ساختار تیم، ترافیک، فرهنگ on-call، ابزار و اقتصاد همان شرکت وابسته است؛ اندازهٔ شرکت به‌تنهایی دلیل کپی‌کردن معماری نیست.

## آزمون

۱. process جدا چه چیزی را تضمین نمی‌کند؟ **پاسخ:** استقلال داده، تیم، release و عملیات.
۲. چه زمانی modular monolith ترجیح دارد؟ **پاسخ:** وقتی دامنه و تیم کوچک‌اند یا توان عملیات سرویس‌ها وجود ندارد.
۳. API Gateway چه کاری نباید بکند؟ **پاسخ:** محل مرکزی منطق دامنه و orchestration شود.
۴. تجربهٔ Netflix را چگونه استفاده می‌کنی؟ **پاسخ:** مطالعهٔ trade-off در زمینهٔ خودش، نه الگوی تضمینی برای هر شرکت.

## تمرین

جداسازی سفارش از پرداخت را بر اساس ownership، consistency، fault isolation، latency و هزینهٔ تیم مقایسه کن.

## پاسخ نمونهٔ تمرین

برای تیم کوچک و دامنهٔ درحال‌کشف، پرداخت می‌تواند ماژول هم‌فرایند بماند: latency و عملیات ساده‌تر، ولی deploy/scale مشترک. استخراج service وقتی مالکیت data و تیم، release مستقل، بار خاص یا isolation خطا شواهد دارد می‌ارزد؛ در مقابل timeout، idempotency، consistency نهایی، tracing و on-call هزینه می‌آید. پاسخ درست با زمینه و سنجهٔ تصمیم مشخص می‌شود.

## منابع

- فارسی: [مبانی معماری: Microservices](https://www.alirostami.com/software-architecture/18-microservices-architecture)، [مقایسهٔ Monolith و Microservices](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3390.pdf)
- انگلیسی: [Martin Fowler: Microservices](https://martinfowler.com/articles/microservices.html)، [Microservice Prerequisites](https://martinfowler.com/bliki/MicroservicePrerequisites.html)، [Netflix video pipeline](https://netflixtechblog.com/rebuilding-netflix-video-processing-pipeline-with-microservices-4e5e6310e359)

</div>
