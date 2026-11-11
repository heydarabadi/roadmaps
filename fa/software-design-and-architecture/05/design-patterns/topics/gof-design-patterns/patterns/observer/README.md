<div dir="rtl" align="right">

# ناظر — Observer


> **زبان:** [نسخهٔ انگلیسی](../../../../../../../../en/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/observer/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** behavioral · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

تغییر موضوع را به مشترک‌های متعدد خبر می‌دهد؛ fan-out از وابستگی مستقیم جدا می‌شود.

## مثال کاربردی

پس از انتشار قیمت، cache و فهرست جستجو به‌روز می‌شوند.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** ترتیب نامشخص، subscriberهای نشت‌کرده و جریان پنهان را کنترل کن.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: تغییر موضوع را به مشترک‌های متعدد خبر می‌دهد؛ fan-out از وابستگی مستقیم جدا می‌شود.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: پس از انتشار قیمت، cache و فهرست جستجو به‌روز می‌شوند.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: ترتیب نامشخص، subscriberهای نشت‌کرده و جریان پنهان را کنترل کن.

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

پس از ارسال، سفارش event تغییر را منتشر می‌کند و subscriberهای مستقل واکنش نشان می‌دهند. event را immutable نگه دار و اجرای sync یا async را مشخص کن. برای تحویل بادوام بین processها broker و retry لازم است؛ subscriber هم باید از event unsubscribe شود.
**تمرین با پاسخ:** شکست ایمیل ارسال را برنمی‌گرداند؛ آن را جدا ثبت و retry کن، چون ارسال واقعیتی ثبت‌شده است.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public event EventHandler<OrderShippedEventArgs>? Shipped;

public void MarkShipped(string trackingCode)
{
    ValidateTransition();
    Status = OrderStatus.Shipped;
    Shipped?.Invoke(this, new OrderShippedEventArgs(trackingCode));
}
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
