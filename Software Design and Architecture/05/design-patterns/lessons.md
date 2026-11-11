<div dir="rtl" align="right">

# درس کامل: الگوهای طراحی


> **زبان:** [نسخهٔ انگلیسی](../../en/05/design-patterns/lessons.md)

## روش یادگیری الگوها

Pattern نام راه‌حلی تکرارشونده برای مسئله‌ای در زمینه‌ای مشخص است؛ نه کد آماده و نه الزام به ساخت کلاس‌های بیشتر. برای هر الگو چهار چیز را یاد بگیر: مسئله/نیروها، ساختار راه‌حل، پیامدهای مثبت، هزینه و شرایطی که نباید استفاده شود.

قبل از انتخاب، مسئله را با نیاز و محدودیتش بنویس. سپس کوچک‌ترین ساختاری را انتخاب کن که تغییر یا ریسک را محدود کند و آزمونش را طراحی کن. اگر pattern فقط اسم اضافه می‌کند، implementationهای واقعی ندارد یا جریان را مخفی می‌کند، گزینهٔ ساده‌تر را نگه دار.

## ۱. خانوادهٔ ایجادی GoF

الگوهای ایجادی چگونگی ساخت object را از مصرف‌کننده جدا می‌کنند. [فایل کامل هرکدام](topics/gof-design-patterns/README.md) شامل مثال و quiz جداست.

| الگو | کاربرد | محدودیت |
| --- | --- | --- |
| Abstract Factory | تولید خانواده‌ای سازگار از محصولات؛ مانند کنترل‌های UI برای سیستم‌عامل مشخص | افزودن محصول جدید ممکن است همهٔ factoryها را تغییر دهد |
| Builder | ساخت object پیچیده با گزینه‌ها، ترتیب یا validation | برای object ساده سربار دارد؛ object ناقص را نباید بیرون داد |
| Factory Method | واگذاری انتخاب نوع concrete به creator یا subclass | hierarchy موازی می‌سازد؛ DI binding یا factory تابعی شاید کافی باشد |
| Prototype | کپی شیء پیکربندی‌شده وقتی ساخت مجدد گران یا دشوار است | shallow/deep copy و reference مشترک ریسک دارند |
| Singleton | محدودکردن نمونه و دسترسی مشترک | global state، تست سخت و مشکل concurrency؛ معمولاً DI بهتر است |

## ۲. خانوادهٔ ساختاری GoF

Structural patternها ترکیب و رابط میان objectها را سامان می‌دهند.

| الگو | کاربرد | محدودیت |
| --- | --- | --- |
| Adapter | ترجمهٔ contract ناسازگار به نیاز مصرف‌کننده | خطا و معنای provider هنگام ترجمه نباید گم شود |
| Bridge | جداسازی abstraction از implementation برای تغییر مستقل | دو محور hierarchy و indirection می‌سازد |
| Composite | پردازش leaf و tree از راه یک قرارداد مشترک | ساختار بازگشتی و رفتار مشترک واقعی لازم است |
| Decorator | افزودن behavior با wrapperهای قابل‌ترکیب | ترتیب wrapper و trace را پیچیده می‌کند |
| Facade | API ساده جلوی زیرسیستم پیچیده | می‌تواند به god object تبدیل شود |
| Flyweight | اشتراک دادهٔ ثابت میان تعداد زیادی object برای کاهش حافظه | باید حالت مشترک را از حالت وابسته به نمونه جدا کرد و صرفه‌جویی را اندازه گرفت |
| Proxy | واسطه برای کنترل دسترسی، lazy loading، remote call یا cache | latency و failure نباید پشت رابط پنهان بمانند |

## ۳. خانوادهٔ رفتاری GoF

Behavioral patternها همکاری و جریان کنترل را سامان می‌دهند.

| الگو | کاربرد | محدودیت |
| --- | --- | --- |
| Chain of Responsibility | عبور درخواست میان handlerها تا رسیدن به مسئول مناسب | ترتیب و حالتی که هیچ handler قبول نمی‌کند باید روشن باشد |
| Command | تبدیل درخواست به پیام/object برای صف، retry، ثبت یا undo | idempotency، ordering و boilerplate مهم‌اند |
| Interpreter | ارزیابی grammar کوچک دامنه‌ای | زبان بزرگ parser واقعی می‌خواهد؛ eval دلخواه ناامن است |
| Iterator | پیمایش داده بدون افشای ساختمان collection | پایان stream و concurrency را تعریف کن |
| Mediator | هماهنگی همکارهای متعدد در یک نقطه | پیچیدگی می‌تواند به mediator مرکزی منتقل شود |
| Memento | snapshot و بازگردانی state خصوصی | حافظه و سازگاری نسخه هزینه دارد |
| Observer | اطلاع تغییر به مشترک‌های متعدد و مستقل | جریان پنهان، ترتیب، retry و unsubscribe سخت‌اند |
| State | واگذاری رفتار و transitionهای مجاز به stateها | برای یک شرط ساده کلاس‌های زیاد نساز |
| Strategy | الگوریتم‌های قابل تعویض پشت یک contract | وقتی variation واقعی نیست abstraction اضافه است |
| Template Method | الگوریتم ثابت با چند گام قابل override | inheritance شکننده است؛ ترتیب مراحل باید پایدار باشد |
| Visitor | افزودن operationها به element typeهای پایدار | افزودن element جدید همهٔ visitorها را تغییر می‌دهد |

### تشخیص الگوهای شبیه

Adapter رابط را تغییر می‌دهد تا دو قرارداد ناسازگار همکاری کنند؛ Decorator معمولاً contract را حفظ می‌کند و behavior می‌افزاید؛ Proxy دسترسی یا مقصد را کنترل می‌کند. Factory Method واگذاری ساخت یک نوع را حل می‌کند؛ Abstract Factory خانوادهٔ چند محصول مرتبط را. Strategy algorithm را با composition جابه‌جا می‌کند؛ Template Method گام‌های الگوریتم ارث‌بری‌شده را تغییر می‌دهد.

## ۴. مثال checkout

~~~text
Checkout use case
  -> DiscountPolicy: محاسبهٔ تخفیف (Strategy)
  -> PaymentAuthorizer: قرارداد پرداخت دامنه
       <- VendorAdapter: ترجمه به SDK واقعی (Adapter)
  -> PaymentRequested command: اجرای صف‌دار در صورت نیاز (Command)
  -> PaymentCaptured event: واکنش رسید/تحلیل (Observer)
~~~

این فهرست به معنای استفاده از همهٔ patternها نیست. ابتدا یک discount function و یک adapter ممکن است کافی باشد. وقتی انتخاب الگوریتم، retry، fan-out یا شکست بیرونی مسئلهٔ واقعی شد، ساختار را مرحله‌ای اضافه کن. در پیام‌رسانی، duplicate delivery و سازگاری نهایی را هم در طراحی بگنجان.

## ۵. POSA و الگوهای معماری

POSA مخفف Pattern-Oriented Software Architecture است. در قیاس کلی، GoF بیشتر collaborationهای object و کلاس را پوشش می‌دهد، درحالی‌که POSA می‌تواند ساختار subsystem، concurrency، ارتباط شبکه‌ای و جریان runtime را توصیف کند. هنگام مطالعهٔ pattern معماری بپرس:

- چه نوع component و connector دارد؟
- کنترل و داده چگونه جریان می‌یابد؟
- کدام خاصیت مانند هم‌زمانی، fault isolation یا تغییرپذیری بهتر می‌شود؟
- چه فرضی دربارهٔ process، شبکه، failure و deployment دارد؟
- چه هزینهٔ عملیاتی ایجاد می‌کند و آیا گزینهٔ ساده‌تری هست؟

POSA نیز نسخهٔ ثابت نیست. pattern را با محدودیت سامانهٔ واقعی مقایسه کن. فهرست درس و منبع POSA در [فایل موضوعی](topics/posa-patterns/README.md) آمده است.

## ۶. ترجمه به زبان‌های امروزی

مفهوم الگو را یاد بگیر و implementation را با idiom زبان تطبیق بده. Function type می‌تواند Strategy باشد؛ middleware زنجیرهٔ wrapper بسازد؛ genericها برخی ساختارهای Visitor را کوتاه کنند؛ dependency injection نیاز Singleton را رفع کند. کپی‌کردن syntax کلاس‌های سال ۱۹۹۴ همیشه بهترین راه امروز نیست.

## ۷. دام‌ها و معیار بازبینی

- الگو را پیش از نوشتن مسئله انتخاب نکن.
- تعداد patternها را معیار کیفیت نگذار.
- هر if یا switch را smell فرض نکن.
- abstraction، wiring، retry، trace و نسخه‌بندی را هزینه حساب کن.
- pattern را برای نیاز اثبات‌نشده نساز.
- اگر رفتار و failure از روی call site قابل ردیابی نیست، مشاهده‌پذیری اضافه کن یا ساختار را ساده‌تر کن.

برای تصمیم مهم، چهار خط ثبت کن: مسئله؛ الگوی انتخابی؛ alternative ساده‌تر؛ پیامد و آزمون. مثال: «دو الگوریتم تخفیف فعال‌اند؛ Strategy باعث می‌شود checkout به جزئیات نرخ وابسته نباشد؛ هزینه‌اش دو implementation و wiring است؛ contract test هر دو را بررسی می‌کند.»

## ۸. تمرین جامع

یک checkout طراحی کن که دو نوع تخفیف، دو درگاه و صدور رسید دارد. برای هر گام pattern نامزد، دلیل، گزینهٔ ساده‌تر، failure case و آزمون را بنویس. در نسخهٔ نخست فقط patternهایی را پیاده کن که همین نیازهای معلوم را حل می‌کنند.

## ۹. آزمون با پاسخ تشریحی

۱. pattern چیست؟
   - پاسخ: راه‌حل نام‌گذاری‌شده برای مسئله و نیروهای تکرارشونده همراه با پیامدها و trade-offها.
۲. Adapter با Decorator چه فرق دارد؟
   - پاسخ: Adapter قرارداد را تبدیل می‌کند؛ Decorator معمولاً همان قرارداد را نگه می‌دارد و behavior اضافه می‌کند.
۳. Strategy و Template Method چه فرقی دارند؟
   - پاسخ: Strategy با composition الگوریتم را عوض می‌کند؛ Template Method از inheritance برای گام‌های الگوریتم ثابت استفاده می‌کند.
۴. چرا Singleton معمولاً ریسک دارد؟
   - پاسخ: دسترسی global و state مشترک تست، concurrency و پنهان‌ماندن dependency را سخت می‌کند.
۵. Visitor کدام نوع تغییر را آسان و کدام را سخت می‌کند؟
   - پاسخ: operation تازه روی elementهای ثابت آسان‌تر است؛ افزودن element همهٔ visitorها را می‌شکند.
۶. چرا Observer برای debugging هزینه دارد؟
   - پاسخ: publish point فهرست اثرهای بعدی را نشان نمی‌دهد؛ ترتیب و شکست consumerها باید جدا trace شود.
۷. POSA معمولاً چه سطحی از مسئله را می‌بیند؟
   - پاسخ: ساختار و همکاری معماری/سیستم، concurrency و ارتباط اجزا؛ هر کتاب ممکن است دسته‌بندی متفاوت داشته باشد.
۸. چه زمانی pattern را حذف می‌کنی؟
   - پاسخ: وقتی فرض variation از بین رفته یا هزینهٔ فهم و نگهداری از فایده بیشتر شده است.

## منابع اختیاری

- [الگوهای طراحی فارسی](https://alireza-haeri.github.io/Persian-Design-Patterns/)
- [Refactoring.Guru؛ کاتالوگ الگوها](https://refactoring.guru/design-patterns)
- [Patterns.Guru؛ GoF در زبان‌های مدرن](https://patterns.guru/)
- [نمونهٔ رسمی کتاب POSA در Wiley](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf)



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../references.md#chapter-05)
</div>
