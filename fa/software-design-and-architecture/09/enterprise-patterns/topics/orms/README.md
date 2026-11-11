<div dir="rtl" align="right">

# نگاشت‌گر شیء-رابطه‌ای (ORM) — Object-Relational Mappers (ORMs)

> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/software-design-and-architecture/09/enterprise-patterns/topics/orms/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

ORM تفاوت مدل شیء و رابطه را پنهان/مدیریت می‌کند و query، identity، transaction و mapping را آسان می‌سازد.

## مثال کاربردی

ORM فاکتورها را بار می‌کند؛ query گزارش پرترافیک ممکن است به SQL هدفمند نیاز داشته باشد.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** lazy loading، N+1، tracking و coupling به ابزار هزینه‌های رایج‌اند.
- **بازبینی:** ORM را معادل دیتابیس یا تضمین کارایی ندان؛ query plan و transaction را اندازه بگیر.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: ORM تفاوت مدل شیء و رابطه را پنهان/مدیریت می‌کند و query، identity، transaction و mapping را آسان می‌سازد.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: ORM فاکتورها را بار می‌کند؛ query گزارش پرترافیک ممکن است به SQL هدفمند نیاز داشته باشد.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: lazy loading، N+1، tracking و coupling به ابزار هزینه‌های رایج‌اند.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: ORM را معادل دیتابیس یا تضمین کارایی ندان؛ query plan و transaction را اندازه بگیر.

## آموزش تکمیلی مستقل

### ۱۰. ORM

Object-Relational Mapper objectها را به rowها و رابطه‌های relational نگاشت می‌کند و query, unit of work, identity tracking و transaction را فراهم می‌کند. ORM سرعت توسعه می‌دهد، اما تفاوت object graph و relation را حذف نمی‌کند.

#### خطرهای رایج

- N+1: یک query برای فهرست و query جدا برای هر سطر.
- lazy load ناخواسته پس از بسته‌شدن transaction.
- tracking و state قدیمی.
- transaction طولانی یا lock نامنتظر.
- مدل domain وابسته به attribute/base class ORM.
- query سنگین که خروجی مطلوبش با entity graph مناسب نیست.

رفتار SQL generated، query plan و transaction را ببین. برای read/report بزرگ، projection یا SQL مستقیم ممکن است روشن‌تر باشد؛ ORM را ابزار بگیر نه قرارداد معماری کل سامانه.

## نمونهٔ کد مرحله‌ای

ORM نگاشت object و دادهٔ رابطه‌ای و اجرای query را ساده می‌کند، اما query plan، transaction، lazy loading و concurrency را از بین نمی‌برد. مدل domain را بر اساس قواعد طراحی کن و mapping را با آزمون integration بررسی کن.
**دام رایج:** N+1 query یا lazy load پنهان می‌تواند latency و سربار غیرمنتظره بسازد.
**تمرین با پاسخ:** لیست ۱۰۰ سفارش queryهای فراوان اجرا می‌کند؛ queryها را بشمار و projection یا eager loading هدفمند را انتخاب کن.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
var orders = await db.Orders
    .Where(order => order.CustomerId == customerId)
    .Select(order => new OrderSummary(
        order.Id, order.Status, order.Lines.Count))
    .ToListAsync(ct);
~~~

## منابع

### فارسی

- [راهنمای فارسی طراحی دامنه‌محور](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — واژگان دامنه، مدل، موجودیت و ارزش‌شیء.
- [الگوهای طراحی فارسی](https://alireza-haeri.github.io/Persian-Design-Patterns/) — شرح فارسی DTO، CQRS و الگوهای مرتبط در کنار GoF.

### انگلیسی

- [Martin Fowler؛ Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — کاتالوگ مرجع Repository، Identity Map، Mapper و دیگر الگوها.
- [Microsoft Learn؛ Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — نمونهٔ آموزشی سفارش و تفکیک فرمان/پرس‌وجو.

## خلاصه

نگاشت‌گر شیء-رابطه‌ای (ORM) را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
