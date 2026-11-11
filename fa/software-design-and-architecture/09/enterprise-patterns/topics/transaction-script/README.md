<div dir="rtl" align="right">

# اسکریپت تراکنش — Transaction Script

> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/software-design-and-architecture/09/enterprise-patterns/topics/transaction-script/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

Transaction Script منطق یک عملیات کسب‌وکار را در رویه‌ای سازمان می‌دهد؛ برای عملیات ساده و تراکنش‌محور کم‌هزینه است.

## مثال کاربردی

use case پرداخت صورت‌حساب چند update را در یک transaction انجام می‌دهد و نتیجه را ثبت می‌کند.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** با رشد قواعد، رویه‌ها تکراری و شرطی می‌شوند.
- **بازبینی:** برای هر CRUD ساده aggregate پیچیده نساز؛ اما قواعد تکراری را در اسکریپت‌های پراکنده رها نکن.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: Transaction Script منطق یک عملیات کسب‌وکار را در رویه‌ای سازمان می‌دهد؛ برای عملیات ساده و تراکنش‌محور کم‌هزینه است.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: use case پرداخت صورت‌حساب چند update را در یک transaction انجام می‌دهد و نتیجه را ثبت می‌کند.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: با رشد قواعد، رویه‌ها تکراری و شرطی می‌شوند.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: برای هر CRUD ساده aggregate پیچیده نساز؛ اما قواعد تکراری را در اسکریپت‌های پراکنده رها نکن.

## آموزش تکمیلی مستقل

### ۶. Transaction Script

Transaction Script منطق یک use case را به رویه‌ای می‌سپارد که یک transaction را کنترل می‌کند. برای CRUD و قواعد محدود، ساده و مؤثر است: ثبت پرداخت، update status و نوشتن audit داخل یک unit.

وقتی قواعد در چند script کپی می‌شوند یا هر اسکریپت invariant را متفاوت اجرا می‌کند، domain model غنی یا domain service را بررسی کن. برعکس، برای فرم تنظیمات ساده aggregate پیچیده نساز. معیار، تغییر و پیچیدگی قواعد است.

## نمونهٔ کد مرحله‌ای

Transaction Script منطق یک use case را در procedure یا service function متمرکز می‌کند و برای workflowهای ساده و data-centric مؤثر است. با رشد شرط و invariant، منطق تکرار می‌شود؛ آن زمان domain model غنی‌تر را بررسی کن.
**دام رایج:** یک script عظیم برای تمام عملیات نساز.
**تمرین با پاسخ:** سه شرط مستقل در ثبت سفارش تکرار شده‌اند؛ آن‌ها را در rule/domain function مشترک قرار بده یا مدل دامنه را ارتقا بده، نه اینکه همهٔ فرایند را یکجا بزرگ‌تر کنی.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public async Task<Result> PlaceOrder(PlaceOrderRequest request, CancellationToken ct)
{
    var customer = await customers.Find(request.CustomerId, ct);
    if (customer is null) return Result.CustomerNotFound();

    var order = Order.From(request);
    await orders.Add(order, ct);
    return Result.Success(order.Id);
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

اسکریپت تراکنش را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
