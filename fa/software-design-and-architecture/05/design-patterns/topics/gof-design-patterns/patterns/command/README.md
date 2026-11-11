<div dir="rtl" align="right">

# فرمان — Command


> **زبان:** [نسخهٔ انگلیسی](../../../../../../../../en/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/command/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** behavioral · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

درخواست را به یک شیء/پیام تبدیل می‌کند تا صف، زمان‌بندی، retry یا undo ممکن شود.

## مثال کاربردی

فرمان `ApproveRefund` با شناسهٔ یکتا صف‌بندی و idempotent پردازش می‌شود.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** فرمان‌ها می‌توانند کلاس‌های boilerplate زیاد کنند؛ ترتیب و تکرار را مدیریت کن.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: درخواست را به یک شیء/پیام تبدیل می‌کند تا صف، زمان‌بندی، retry یا undo ممکن شود.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: فرمان `ApproveRefund` با شناسهٔ یکتا صف‌بندی و idempotent پردازش می‌شود.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: فرمان‌ها می‌توانند کلاس‌های boilerplate زیاد کنند؛ ترتیب و تکرار را مدیریت کن.

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

درخواست را به object داده تبدیل می‌کنیم تا صف، log، retry و undo ممکن شود. تحویل تکراری در صف رایج است؛ handler باید idempotent باشد و اثر command از query جدا بماند.
**تمرین با پاسخ:** worker پس از گرفتن وجه crash کرد؛ retry با همان کلید idempotency باید نتیجهٔ قبلی را بگیرد، نه اینکه دوباره برداشت کند.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public sealed record CapturePayment(Guid CommandId, Guid OrderId, Money Amount);

public sealed class CapturePaymentHandler(IPaymentGateway gateway)
{
    public Task<PaymentResult> Handle(CapturePayment command, CancellationToken ct)
        => gateway.Capture(command.Amount, ct);
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
