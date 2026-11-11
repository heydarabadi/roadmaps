<div dir="rtl" align="right">

# نقشهٔ هویت — Identity Map

> **زبان:** [نسخهٔ انگلیسی](../../../../en/09/enterprise-patterns/topics/identity-map/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

در یک واحد کاری، identity map تضمین می‌کند یک ردیف/شناسه به یک نمونهٔ شیء در حافظه نگاشت شود و بارگذاری تکراری به نمونهٔ دیگری نینجامد.

## مثال کاربردی

در یک transaction، دو query برای `Customer#42` همان شیء مدیریت‌شده را بازمی‌گردانند.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** حافظه و عمر واحد کاری باید محدود باشد؛ state قدیمی ممکن است گیج‌کننده شود.
- **بازبینی:** identity map را cache سراسری یا بین‌درخواستی تلقی نکن.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: در یک واحد کاری، identity map تضمین می‌کند یک ردیف/شناسه به یک نمونهٔ شیء در حافظه نگاشت شود و بارگذاری تکراری به نمونهٔ دیگری نینجامد.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: در یک transaction، دو query برای `Customer#42` همان شیء مدیریت‌شده را بازمی‌گردانند.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: حافظه و عمر واحد کاری باید محدود باشد؛ state قدیمی ممکن است گیج‌کننده شود.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: identity map را cache سراسری یا بین‌درخواستی تلقی نکن.

## آموزش تکمیلی مستقل

### ۲. Identity Map

Identity Map در یک unit of work تضمین می‌کند یک هویت/شناسه به یک instance در حافظه نگاشت شود. اگر Customer با شناسهٔ یکسان دوبار query شود، دو نسخهٔ مستقل mutable نگیریم که تغییرشان با هم ناسازگار باشد. ORMها معمولاً در scope یک context/session چنین رفتاری دارند.

این الگو global cache نیست. عمر آن را به transaction/request یا unit of work محدود کن؛ cache سراسری مسئلهٔ invalidation، race و stale state دارد. دیتابیس concurrency و identity مستقل از object reference دارند.

## نمونهٔ کد مرحله‌ای

Identity Map در یک unit of work برای هر شناسه یک نمونهٔ درون‌حافظه‌ای نگه می‌دارد. این کار سازگاری تغییرها و تعداد query را بهتر می‌کند، اما عمر cache را محدود و رفتار concurrency و stale data را روشن می‌خواهد.
**دام رایج:** identity map بلندعمر را به cache سراسری تبدیل نکن.
**تمرین با پاسخ:** دو query در یک transaction همان OrderId را می‌خوانند؛ نمونهٔ tracked را برگردان تا updateهای متناقض نسازی.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public sealed class OrderIdentityMap
{
    private readonly Dictionary<OrderId, Order> _orders = [];

    public Order GetOrAdd(OrderId id, Func<Order> load)
    {
        if (!_orders.TryGetValue(id, out var order))
            _orders[id] = order = load();
        return order;
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

نقشهٔ هویت را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
