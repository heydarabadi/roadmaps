<div dir="rtl" align="right">

# نگاشت‌گرها (Mappers) — Mappers

> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/software-design-and-architecture/09/enterprise-patterns/topics/mappers/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

mapper تبدیل میان دو مدل مستقل را انجام می‌دهد؛ مدل‌ها می‌توانند DTO، دامنه، persistence یا پیام باشند.

## مثال کاربردی

`OrderEntity` به `OrderResponse` تبدیل می‌شود تا API فقط قرارداد عمومی را نمایش دهد.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** نگاشت‌ها synchronization و خطای تبدیل می‌آورند.
- **بازبینی:** یک mapper خودکار و پنهان را بدون کنترل null، value object و invariant به کار نگیر.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: mapper تبدیل میان دو مدل مستقل را انجام می‌دهد؛ مدل‌ها می‌توانند DTO، دامنه، persistence یا پیام باشند.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: `OrderEntity` به `OrderResponse` تبدیل می‌شود تا API فقط قرارداد عمومی را نمایش دهد.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: نگاشت‌ها synchronization و خطای تبدیل می‌آورند.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: یک mapper خودکار و پنهان را بدون کنترل null، value object و invariant به کار نگیر.

## آموزش تکمیلی مستقل

### ۵. Data Mapper

Data Mapper بین objectها و دیتابیس ترجمه می‌کند، بدون اینکه دو مدل به هم وابسته شوند. Mapper تبدیل mapping و identity/relationships را انجام می‌دهد؛ دامنه نباید مجبور باشد schema table را تکرار کند. ORM اغلب Data Mapper را پیاده می‌کند، هرچند جزئیات framework فرق دارد.

mapping ممکن است اطلاعات گم کند، null را غلط تعبیر کند یا N+1 query بسازد. تست mapping برای invariantها، precision پول/زمان و relationها لازم است. AutoMapper جای فهم قرارداد را نمی‌گیرد.

## نمونهٔ کد مرحله‌ای

Mapper شکل داده را میان مرزها تبدیل می‌کند؛ تصمیم دامنه‌ای یا خطای اعتبارسنجی را نباید بی‌صدا حذف کند. نگاشت را نزدیک مرز انجام بده، و بگذار قواعد business در domain/use case باقی بمانند.
**دام رایج:** auto-mapping را برای پنهان‌کردن تغییر semantics یا فیلدهای حساس استفاده نکن.
**تمرین با پاسخ:** مقدار پول با واحد نامشخص وارد می‌شود؛ mapper باید خطا بدهد یا نوع ورودی را کامل کند، نه اینکه ارز پیش‌فرض حدس بزند.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public static CreateOrderCommand ToCommand(CreateOrderRequest request)
{
    var lines = request.Lines
        .Select(line => new OrderLineInput(line.ProductId, line.Quantity))
        .ToArray();

    return new CreateOrderCommand(request.CustomerId, lines);
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

نگاشت‌گرها (Mappers) را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
