<div dir="rtl" align="right">

# شیء انتقال داده (DTO) — Data Transfer Object (DTO)

> **زبان:** [نسخهٔ انگلیسی](../../../../en/09/enterprise-patterns/topics/dto/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

DTO داده را از یک مرز عبور می‌دهد و شکل آن برای API، view یا پیام بهینه می‌شود؛ باید از مدل دامنه و entity persistence جدا دیده شود.

## مثال کاربردی

API سفارش `OrderSummaryDto` را با فیلدهای لازم موبایل برمی‌گرداند، نه کل graph موجودیت را.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** mapping و نسخه‌بندی فیلدها هزینه دارد.
- **بازبینی:** entity دیتابیس را مستقیم به API عمومی نده؛ اطلاعات داخلی و lazy loading نشت می‌کند.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: DTO داده را از یک مرز عبور می‌دهد و شکل آن برای API، view یا پیام بهینه می‌شود؛ باید از مدل دامنه و entity persistence جدا دیده شود.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: API سفارش `OrderSummaryDto` را با فیلدهای لازم موبایل برمی‌گرداند، نه کل graph موجودیت را.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: mapping و نسخه‌بندی فیلدها هزینه دارد.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: entity دیتابیس را مستقیم به API عمومی نده؛ اطلاعات داخلی و lazy loading نشت می‌کند.

## آموزش تکمیلی مستقل

### ۱. DTO

Data Transfer Object داده را از یک boundary عبور می‌دهد. هدفش API سطحی، serialization یا انتقال داده است؛ لازم نیست entity دامنه باشد. DTO را بر اساس مصرف‌کننده و security طراحی کن: فقط field لازم را بده، دادهٔ داخلی را پنهان کن، versioning را در نظر بگیر و validation مرز را انجام بده.

~~~python
@dataclass(frozen=True)
class OrderSummaryDto:
    order_id: str
    total_cents: int
    currency: str
~~~

بازگرداندن entity یا ORM graph از API می‌تواند data حساس، lazy-loading و رابطه‌های داخلی را افشا کند. DTO زیاد هم mapping و version drift می‌آورد؛ اگر مدل ساده و فقط‌خواندنی است، جداسازی را بر اساس ریسک واقعی بسنج.

## نمونهٔ کد مرحله‌ای

DTO داده را از مرز API یا process عبور می‌دهد؛ به entity دامنه یا ORM وابسته نباشد. ورودی را در boundary اعتبارسنجی کن و پاسخ را بر اساس نیاز مصرف‌کننده شکل بده؛ DTO خودش مجوز تغییر دامنه نیست.
**دام رایج:** entity داخلی را serialize نکن؛ ممکن است دادهٔ محرمانه یا navigation loop افشا شود.
**تمرین با پاسخ:** API فقط نام و قیمت کالا را نیاز دارد؛ یک DTO حداقلی برگردان، نه کل entity و relationها را.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public sealed record ProductResponse(
    string Name, decimal Price, string Currency);

public sealed record CreateOrderRequest(
    Guid CustomerId, IReadOnlyList<CreateOrderLine> Lines);
~~~

## منابع

### فارسی

- [راهنمای فارسی طراحی دامنه‌محور](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — واژگان دامنه، مدل، موجودیت و ارزش‌شیء.
- [الگوهای طراحی فارسی](https://alireza-haeri.github.io/Persian-Design-Patterns/) — شرح فارسی DTO، CQRS و الگوهای مرتبط در کنار GoF.

### انگلیسی

- [Martin Fowler؛ Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — کاتالوگ مرجع Repository، Identity Map، Mapper و دیگر الگوها.
- [Microsoft Learn؛ Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — نمونهٔ آموزشی سفارش و تفکیک فرمان/پرس‌وجو.

## خلاصه

شیء انتقال داده (DTO) را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
