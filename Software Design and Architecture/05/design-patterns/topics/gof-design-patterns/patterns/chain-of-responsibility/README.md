<div dir="rtl" align="right">

# زنجیرهٔ مسئولیت — Chain of Responsibility


> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/05/design-patterns/topics/gof-design-patterns/patterns/chain-of-responsibility/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** behavioral · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

درخواست از زنجیره‌ای از handlerها عبور می‌کند تا یکی آن را پردازش یا به بعدی واگذار کند.

## مثال کاربردی

مراحل اعتبارسنجی درخواست پرداخت از فیلترهای احراز هویت و ریسک عبور می‌کنند.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** ترتیب و اتمام زنجیره را شفاف کن؛ درخواست نباید بی‌صدا ناپدید شود.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: درخواست از زنجیره‌ای از handlerها عبور می‌کند تا یکی آن را پردازش یا به بعدی واگذار کند.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: مراحل اعتبارسنجی درخواست پرداخت از فیلترهای احراز هویت و ریسک عبور می‌کنند.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: ترتیب و اتمام زنجیره را شفاف کن؛ درخواست نباید بی‌صدا ناپدید شود.

## آموزش تکمیلی مستقل

### ۳. خانوادهٔ رفتاری GoF

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

#### تشخیص الگوهای شبیه

Adapter رابط را تغییر می‌دهد تا دو قرارداد ناسازگار همکاری کنند؛ Decorator معمولاً contract را حفظ می‌کند و behavior می‌افزاید؛ Proxy دسترسی یا مقصد را کنترل می‌کند. Factory Method واگذاری ساخت یک نوع را حل می‌کند؛ Abstract Factory خانوادهٔ چند محصول مرتبط را. Strategy algorithm را با composition جابه‌جا می‌کند؛ Template Method گام‌های الگوریتم ارث‌بری‌شده را تغییر می‌دهد.

## پیاده‌سازی گام‌به‌گام

درخواست از handlerهای احراز هویت، محدودیت نرخ و اعتبارسنجی عبور می‌کند؛ هرکدام ادامه می‌دهد یا متوقف می‌کند. ترتیب تصمیم امنیتی است و باید آزمون شود. رفتار نبودن handler مسئول را هم تعریف کن.
**تمرین با پاسخ:** درخواست rate-limited نباید به endpoint برسد؛ آزمون pipeline را طوری بنویس که این ترتیب را ثابت کند.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public delegate Task<Response> Handler(Request request, Func<Task<Response>> next);

Handler endpoint = request => HandleRequest(request);
Handler validate = (request, next) =>
    IsValid(request) ? next() : Task.FromResult(Response.BadRequest());
~~~


## منابع

### فارسی

- [الگوهای طراحی فارسی](https://alireza-haeri.github.io/Persian-Design-Patterns/) — خلاصه‌های فارسی از الگوهای GoF و چند الگوی معماری.
- [آزمایشگاه مهندسی نرم‌افزار هوشمند؛ اصول و الگوها](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — منبع درسی فارسی برای GoF، GRASP و الگوهای معماری.

### انگلیسی

- [Refactoring.Guru؛ Design Patterns](https://refactoring.guru/design-patterns) — فهرست الگوهای GoF و مثال‌های چندزبانه.
- [Patterns.Guru؛ GoF catalog](https://patterns.guru/) — بازخوانی امروزی الگوها و هزینهٔ انتخاب آن‌ها.
- [Wiley؛ POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — نمونه‌ای از الگوهای معماری و هم‌زمانی در مجموعهٔ POSA.



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../../../references.md#chapter-05)
</div>
