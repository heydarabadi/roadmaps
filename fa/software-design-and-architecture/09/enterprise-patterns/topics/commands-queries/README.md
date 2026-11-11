<div dir="rtl" align="right">

# فرمان‌ها و پرس‌وجوها — Commands and Queries

> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/software-design-and-architecture/09/enterprise-patterns/topics/commands-queries/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

command درخواست تغییر است و query پاسخ می‌خواند بدون تغییر state؛ قراردادشان side effect، validation و پاسخ را شفاف می‌کند.

## مثال کاربردی

`ApproveRefund` فرمان است؛ `GetRefundStatus` query است و داده را تغییر نمی‌دهد.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** تفکیک handlerها boilerplate و coordination می‌آورد.
- **بازبینی:** query پنهانی که state را تغییر می‌دهد یا commandی که خروجی متناقض می‌دهد قرارداد را می‌شکند.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: command درخواست تغییر است و query پاسخ می‌خواند بدون تغییر state؛ قراردادشان side effect، validation و پاسخ را شفاف می‌کند.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: `ApproveRefund` فرمان است؛ `GetRefundStatus` query است و داده را تغییر نمی‌دهد.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: تفکیک handlerها boilerplate و coordination می‌آورد.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: query پنهانی که state را تغییر می‌دهد یا commandی که خروجی متناقض می‌دهد قرارداد را می‌شکند.

## آموزش تکمیلی مستقل

### ۷. Command و Query

Command درخواست تغییر state است و معمولاً outcome یا شناسه برمی‌گرداند؛ query اطلاعات می‌دهد و state دامنه را عوض نمی‌کند. این تفکیک CQS را در API نیز روشن می‌کند.

Command باید مجوز، validation، idempotency و failure واضح داشته باشد. Query می‌تواند projection مختصر و cacheable بدهد. Query نباید زیر نام read، command پنهان اجرا کند؛ side effect فنی مانند logging را هم از mutation دامنه تفکیک کن.

اگر مدل خواندن و نوشتن به شکل جدی متفاوت شد، CQRS را بررسی کن؛ صرف جداکردن handlerها CQRS کامل یا نیازمند دو database نیست.

## نمونهٔ کد مرحله‌ای

Command تغییر یا side effect می‌خواهد؛ query داده می‌خواند و نباید state را عوض کند. جداکردن آن‌ها نتیجه را قابل‌فهم می‌کند، اما projection جدا یا CQRS لازم نیست مگر نیاز واقعی داشته باشی.
**دام رایج:** نام query را با فعل تغییردهنده انتخاب نکن و query را برای نوشتن پنهانی به‌کار نبر.
**تمرین با پاسخ:** GetOrderStatus باید فقط خواندنی باشد؛ CancelOrder command است و باید نتیجهٔ transition را برگرداند.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public sealed record GetOrderStatus(OrderId Id);
public sealed record CancelOrder(OrderId Id, CancellationReason Reason);

Task<OrderStatusView> Handle(GetOrderStatus query, CancellationToken ct);
Task<CancelResult> Handle(CancelOrder command, CancellationToken ct);
~~~

## منابع

### فارسی

- [راهنمای فارسی طراحی دامنه‌محور](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — واژگان دامنه، مدل، موجودیت و ارزش‌شیء.
- [الگوهای طراحی فارسی](https://alireza-haeri.github.io/Persian-Design-Patterns/) — شرح فارسی DTO، CQRS و الگوهای مرتبط در کنار GoF.

### انگلیسی

- [Martin Fowler؛ Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — کاتالوگ مرجع Repository، Identity Map، Mapper و دیگر الگوها.
- [Microsoft Learn؛ Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — نمونهٔ آموزشی سفارش و تفکیک فرمان/پرس‌وجو.

## خلاصه

فرمان‌ها و پرس‌وجوها را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
