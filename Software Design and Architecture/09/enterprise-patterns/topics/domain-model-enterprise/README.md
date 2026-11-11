<div dir="rtl" align="right">

# مدل دامنه — Domain Models

> **زبان:** [نسخهٔ انگلیسی](../../../../en/09/enterprise-patterns/topics/domain-model-enterprise/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

در الگوهای سازمانی، domain model رفتار و قواعد پیچیده را کنار مفاهیم دامنه نگه می‌دارد؛ گزینه‌ای در برابر transaction script است.

## مثال کاربردی

مدل اعتبار، سقف برداشت و انتقال را با invariantهای درون aggregate کنترل می‌کند.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** مدل غنی نیازمند کشف دامنه و آزمون دارد.
- **بازبینی:** برای دامنهٔ ساده، domain model تشریفاتی نساز؛ برای قواعد پیچیده منطق را در serviceهای بی‌شمار پخش نکن.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: در الگوهای سازمانی، domain model رفتار و قواعد پیچیده را کنار مفاهیم دامنه نگه می‌دارد؛ گزینه‌ای در برابر transaction script است.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: مدل اعتبار، سقف برداشت و انتقال را با invariantهای درون aggregate کنترل می‌کند.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: مدل غنی نیازمند کشف دامنه و آزمون دارد.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: برای دامنهٔ ساده، domain model تشریفاتی نساز؛ برای قواعد پیچیده منطق را در serviceهای بی‌شمار پخش نکن.

## آموزش تکمیلی مستقل

### ۹. Domain Model و Entity

Domain model رفتار و قوانین را کنار هم نگه می‌دارد. Entity هویت پایدار و lifecycle دارد؛ برابری آن با مقدار همهٔ propertyهای mutable تعریف نمی‌شود. Customer emailش را عوض می‌کند اما همچنان همان CustomerId است.

Aggregate root مرز consistency و دسترسی تغییرات داخل aggregate را کنترل می‌کند. Query model و entity یکسان بودن لازم ندارند. Domain event حقیقتی مانند OrderPaid ثبت می‌کند، نه صرفاً log اینکه تابع اجرا شده است.

مدل بی‌رفتار برای CRUD ساده کافی است؛ برای قواعد متغیر مثل سقف برداشت یا eligibility لغو، behavior را در owner نگه دار. تشخیص باید بر مبنای invariant و پراکندگی تغییر باشد.

## نمونهٔ کد مرحله‌ای

Domain Model رفتار، state و invariantهای کسب‌وکار را کنار هم نگه می‌دارد. برای قواعد پیچیده و transitionهای مهم مناسب است؛ نگاشت persistence و mapping به DTO باید مدل را به schema دیتابیس تبدیل نکند.
**دام رایج:** هر فیلد جدول را public property دامنه نکن.
**تمرین با پاسخ:** Order باید AddLine را فقط در Draft بپذیرد؛ رفتار را در خود مدل بگذار تا همهٔ callerها همان invariant را رعایت کنند.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public sealed class Order
{
    private readonly List<OrderLine> _lines = [];
    public OrderStatus Status { get; private set; }

    public void AddLine(Product product, Quantity quantity)
    {
        if (Status != OrderStatus.Draft) throw new InvalidOperationException();
        _lines.Add(new OrderLine(product.Id, quantity, product.Price));
    }
}
~~~

## منابع

### فارسی

- [راهنمای فارسی طراحی دامنه‌محور](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — واژگان دامنه، مدل، موجودیت و ارزش‌شیء.
- [الگوهای طراحی فارسی](https://alireza-haeri.github.io/Persian-Design-Patterns/) — شرح فارسی DTO، CQRS و الگوهای مرتبط در کنار GoF.

### انگلیسی

- [Martin Fowler؛ Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — کاتالوگ مرجع Repository، Identity Map، Mapper و دیگر الگوها.
- [Microsoft Learn؛ Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — نمونهٔ آموزشی سفارش و تفکیک فرمان/پرس‌وجو.

## خلاصه

مدل دامنه را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
