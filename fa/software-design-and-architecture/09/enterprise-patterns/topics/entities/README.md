<div dir="rtl" align="right">

# موجودیت‌ها (Entities) — Entities

> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/software-design-and-architecture/09/enterprise-patterns/topics/entities/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

entity هویت پایدار دارد و ویژگی‌هایش در طول زمان تغییر می‌کنند؛ هویت، lifecycle و invariantهای مجاز مهم‌اند.

## مثال کاربردی

مشتری با `CustomerId` یکسان پس از تغییر ایمیل همچنان همان مشتری است.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** شناسه و lifecycle persistence با هویت دامنه یکی نیستند همیشه.
- **بازبینی:** برابری entity را فقط با همهٔ فیلدهای قابل تغییر نسنج.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: entity هویت پایدار دارد و ویژگی‌هایش در طول زمان تغییر می‌کنند؛ هویت، lifecycle و invariantهای مجاز مهم‌اند.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: مشتری با `CustomerId` یکسان پس از تغییر ایمیل همچنان همان مشتری است.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: شناسه و lifecycle persistence با هویت دامنه یکی نیستند همیشه.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: برابری entity را فقط با همهٔ فیلدهای قابل تغییر نسنج.

## آموزش تکمیلی مستقل

### ۹. Domain Model و Entity

Domain model رفتار و قوانین را کنار هم نگه می‌دارد. Entity هویت پایدار و lifecycle دارد؛ برابری آن با مقدار همهٔ propertyهای mutable تعریف نمی‌شود. Customer emailش را عوض می‌کند اما همچنان همان CustomerId است.

Aggregate root مرز consistency و دسترسی تغییرات داخل aggregate را کنترل می‌کند. Query model و entity یکسان بودن لازم ندارند. Domain event حقیقتی مانند OrderPaid ثبت می‌کند، نه صرفاً log اینکه تابع اجرا شده است.

مدل بی‌رفتار برای CRUD ساده کافی است؛ برای قواعد متغیر مثل سقف برداشت یا eligibility لغو، behavior را در owner نگه دار. تشخیص باید بر مبنای invariant و پراکندگی تغییر باشد.

## نمونهٔ کد مرحله‌ای

Entity هویت پایدار دارد؛ دو نمونه با دادهٔ یکسان ممکن است entityهای متفاوت باشند و دادهٔ تغییرکرده هنوز همان entity باشد. equality را بر اساس شناسه تعریف کن و invariant تغییر state را در مالک entity نگه دار.
**دام رایج:** equality پیش‌فرض همهٔ propertyها را ملاک هویت نکن.
**تمرین با پاسخ:** دو نسخهٔ بارگذاری‌شده با OrderId برابر یک سفارش‌اند؛ اگر ID متفاوت است، برابری مقدارهای دیگر هویت مشترک نمی‌سازد.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public sealed class Order : IEquatable<Order>
{
    public OrderId Id { get; }

    public bool Equals(Order? other) => other is not null && Id == other.Id;
    public override bool Equals(object? obj) => obj is Order other && Equals(other);
    public override int GetHashCode() => Id.GetHashCode();
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

موجودیت‌ها (Entities) را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
