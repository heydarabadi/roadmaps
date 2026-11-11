<div dir="rtl" align="right">

# الگوهای لایهٔ دامنه و دسترسی داده

## ایدهٔ مرکزی

Enterprise patterns واژگان متداول برای جداکردن مدل دامنه، حمل داده، دسترسی به ذخیره‌ساز و اجرای use case هستند. هر pattern قرارداد و مسئولیت دارد. انباشتنشان بدون نیاز باعث ایجاد boilerplate و لایه‌هایی می‌شود که هیچ تصمیمی را محصور نمی‌کنند.

## الگوها

- **Entity:** شیء دارای identity و چرخهٔ عمر.
- **Value Object:** مقدار توصیفی بدون هویت مستقل؛ مانند Money با مبلغ و currency.
- **Domain Model:** رفتار و invariant کنار مدل دامنه.
- **Transaction Script:** عملیات تجاری را در رویهٔ مشخص پیاده می‌کند؛ برای دامنهٔ ساده و use case محدود مناسب است.
- **Repository:** مجموعه‌ای برای ذخیره و بازیابی Aggregate، نه لزوماً پوششی یک‌به‌یک روی هر جدول.
- **Data Mapper / ORM:** مدل دامنه را از schema ذخیره جدا می‌کند؛ mapping پیچیده و lazy loading می‌توانند مشکل ایجاد کنند.
- **DTO:** شکل انتقال داده در مرز API یا فرایند؛ لازم نیست با Entity مشترک باشد.
- **Identity Map:** در یک واحد کار از ساخت نسخه‌های متعدد یک رکورد جلوگیری می‌کند.
- **Command / Query:** درخواست تغییر را از خواندن داده جدا می‌سازد.
- **Use Case / Application Service:** جریان یک کار را هماهنگ می‌کند؛ نباید همهٔ قواعد دامنه را در آن انباشته کرد.

## چطور میان Transaction Script و Domain Model انتخاب کنیم؟

اگر use case ساده است—مثلاً ثبت علاقه‌مندی بدون invariantهای چندمرحله‌ای—Transaction Script روشن و ارزان است. اگر رفتارهای زیادی روی یک مفهوم اثر می‌گذارند و ruleها باید همیشه با هم برقرار بمانند، Domain Model می‌تواند invariant را نزدیک داده نگه دارد. معماری خوب ممکن است در یک محصول هر دو را داشته باشد؛ به‌کارگیری یک pattern برای همهٔ بخش‌ها الزام نیست.

### مرزهای مهم در یک درخواست

1. **Controller/Endpoint:** HTTP را به ورودی داخلی تبدیل می‌کند و status پاسخ را می‌سازد.
2. **Application service / use case:** جریان و transaction boundary را هماهنگ می‌کند.
3. **Domain model:** قاعده و invariant را اعمال می‌کند.
4. **Repository/adapter:** جزئیات query یا ارتباط بیرونی را پشت مرز قرار می‌دهد.
5. **DTO:** فقط دادهٔ لازم برای مرز بیرونی را منتقل می‌کند.

اگر endpoint هم محاسبهٔ قیمت و هم query و هم ارسال پیام را انجام دهد، تغییر و آزمون سخت می‌شود. اگر برای هر خط یک interface و یک کلاس بسازیم، مسیر خواندن هم مبهم می‌شود. هدف، boundary معنادار است.

### ORM و Identity Map

ORM objectها را با رکوردها map می‌کند؛ Unit of Work می‌تواند تغییرات چند object را در transaction جمع کند. Lazy loading ممکن است query ناخواسته و N+1 بسازد. Eager loading هم ممکن است دادهٔ بیش از نیاز بار کند. برای endpointهایی با read shape خاص، projection یا query مستقیم کنترل‌شده مناسب است؛ لازم نیست همیشه Entity کامل را load کنیم.

DTO برای API است و معمولاً versioned contract می‌خواهد؛ Entity برای domain identity و رفتار دارد؛ persistence model برای schema ذخیره است. در پروژهٔ ساده می‌توان آن‌ها را هم‌شکل گذاشت، اما این باید تصمیم آگاهانه باشد و نه فرض همیشگی.

## مثال: فاکتور

Money بهتر است amount و currency را با هم نگه دارد تا جمع دو واحد ناسازگار دشوار شود. Invoice یک Entity با شناسه و وضعیت است؛ هر InvoiceLine مقدار دارد. DTO پاسخ API فقط فیلدهای لازم مشتری را منتشر می‌کند. Repository می‌تواند Aggregate را بارگیری و ذخیره کند. اگر سیستم ساده است، ORM و transaction script ممکن است کافی باشند.

~~~text
HTTP DTO -> UseCase -> Invoice Aggregate -> Repository -> Database
                              |
                           Money value
~~~

## انتخاب

| الگو | استفاده کن وقتی | مراقب باش |
| --- | --- | --- |
| DTO | قرارداد بیرونی باید مستقل از مدل داخلی باشد | کپی و mapping بی‌هدف |
| Repository | رفتار و مرز Aggregate ارزش abstraction دارد | generic repository برای هر جدول |
| Transaction Script | منطق ساده و واحد است | قواعد پیچیده میان چند script تکرار شود |
| Domain Model | invariantها و رفتارهای دامنه پیچیده‌اند | مدل anemia فقط داده باشد |

## آزمون

۱. چرا Entity را مستقیم از API برنمی‌گردانیم؟  
**پاسخ:** مدل ذخیره و قواعد داخلی را افشا نمی‌کنیم و قرارداد بیرونی را مستقل نگه می‌داریم.

۲. Value Object چه فایده‌ای دارد؟  
**پاسخ:** معنا و قواعد مقدار را یک‌جا نگه می‌دارد، مانند مقایسه و محاسبهٔ مبلغ با ارز.

۳. چه زمانی Transaction Script مناسب است؟  
**پاسخ:** وقتی قواعد ساده و flowها محدودند و مدل دامنهٔ پررفتار هنوز پیچیدگی را کاهش نمی‌دهد.

۴. Repository خوب چه چیزی را پنهان می‌کند؟  
**پاسخ:** جزئیات ذخیره و بازیابی مدل دامنه را؛ نه اینکه queryهای نامرتبط و همهٔ دسترسی‌های سیستم را یک‌جا کند.

## تمرین

برای پرداخت، PaymentAttempt، Money، CreatePaymentCommand، PaymentResponse DTO و repository boundary را تعریف کن. نشان بده کدام تغییر نباید API عمومی را بشکند.

## پاسخ نمونهٔ تمرین

PaymentAttempt هویت/provider reference/state/version دارد؛ Money مبلغ و currency را به‌صورت value object نگه می‌دارد؛ CreatePaymentCommand شناسهٔ سفارش و idempotency key می‌گیرد؛ PaymentResponse DTO فقط قرارداد عمومی لازم را می‌دهد؛ PaymentGateway/Repository port درونی‌اند. تغییر provider یا schema داخلی repository نباید API مشتری را بشکند. وضعیت‌های قابل‌انتقال و error mapping جدا version می‌شوند.

## منابع

- فارسی: [راهنمای DDD فارسی](https://github.com/hheydarian/Understanding-Domain-Driven-Design)، [DNTips: DDD به زبان ساده](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-1406.pdf)
- انگلیسی: [Martin Fowler: Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/)، [Microsoft: DDD and CQRS patterns](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)

</div>
