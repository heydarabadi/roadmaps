<div dir="rtl" align="right">

# مخزن‌ها (Repository) — Repositories

> **زبان:** [نسخهٔ انگلیسی](../../../../en/09/enterprise-patterns/topics/repositories/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

repository مجموعه‌ای از aggregateهای دامنه را مانند collection قابل پرس‌وجو/ذخیره‌سازی عرضه می‌کند و جزئیات persistence را پنهان می‌کند.

## مثال کاربردی

`OrderRepository` سفارش را با شناسه بار می‌کند و تغییر aggregate را ذخیره می‌کند.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** abstraction عمومی برای همهٔ queryها ممکن است امکانات دیتابیس را خفه کند.
- **بازبینی:** برای هر جدول CRUD repository نساز اگر مرز دامنه یا ارزش جداسازی وجود ندارد.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: repository مجموعه‌ای از aggregateهای دامنه را مانند collection قابل پرس‌وجو/ذخیره‌سازی عرضه می‌کند و جزئیات persistence را پنهان می‌کند.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: `OrderRepository` سفارش را با شناسه بار می‌کند و تغییر aggregate را ذخیره می‌کند.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: abstraction عمومی برای همهٔ queryها ممکن است امکانات دیتابیس را خفه کند.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: برای هر جدول CRUD repository نساز اگر مرز دامنه یا ارزش جداسازی وجود ندارد.

## آموزش تکمیلی مستقل

### ۴. Repository

Repository مجموعه‌ای از aggregateها یا objectهای دامنه را از دید مصرف‌کننده بازیابی و ذخیره می‌کند. هدف جداسازی query/persistence detail از use case است، نه ساخت یک CRUD class برای هر جدول.

~~~text
OrderRepository:
  get(order_id)
  save(order)
~~~

اگر interface همهٔ SQL و queryهای ad-hoc را مجبور به abstraction عمومی کند، مصرف‌کننده‌ها به امکانات واقعی storage نیاز دارند. Repository هم transaction manager یا ORM را جایگزین نمی‌کند؛ عمر unit of work و transaction باید روشن باشد.

## نمونهٔ کد مرحله‌ای

Repository برای aggregate root قراردادی شبیه collection فراهم می‌کند تا use case از جزئیات persistence جدا بماند. queryهای خاص خواندن ممکن است projection مستقیم داشته باشند؛ repository عمومی با CRUD برای هر جدول قانون دامنه را پنهان می‌کند.
**دام رایج:** Repository را به wrapper بی‌معنای DbSet یا generic repository برای همهٔ نیازها تبدیل نکن.
**تمرین با پاسخ:** عملیات PlaceOrder باید Save(Order) را روی repository سفارش صدا بزند؛ repository مالک هماهنگی چند aggregate یا تراکنش توزیع‌شده نیست.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public interface IOrderRepository
{
    Task<Order?> Find(OrderId id, CancellationToken ct);
    Task Add(Order order, CancellationToken ct);
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

مخزن‌ها (Repository) را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
