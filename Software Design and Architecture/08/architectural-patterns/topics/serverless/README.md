<div dir="rtl" align="right">

# معماری serverless — Serverless Architecture

> **زبان:** [نسخهٔ انگلیسی](../../../../en/08/architectural-patterns/topics/serverless/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای معماری](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

کد به صورت function یا سرویس مدیریت‌شده اجرا می‌شود و بخشی از provisioning و مقیاس‌پذیری به provider سپرده می‌شود؛ مالکیت عملیات حذف نمی‌شود.

## مثال کاربردی

پردازش بارگذاری تصویر می‌تواند رویدادمحور و کوتاه‌مدت اجرا شود.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای معماری» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** cold start، محدودیت زمان/حافظه، هزینهٔ invocation و وابستگی به provider باید بررسی شوند.
- **بازبینی:** serverless را مساوی بدون سرور یا ارزان در هر workload ندان.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: کد به صورت function یا سرویس مدیریت‌شده اجرا می‌شود و بخشی از provisioning و مقیاس‌پذیری به provider سپرده می‌شود؛ مالکیت عملیات حذف نمی‌شود.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: پردازش بارگذاری تصویر می‌تواند رویدادمحور و کوتاه‌مدت اجرا شود.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: cold start، محدودیت زمان/حافظه، هزینهٔ invocation و وابستگی به provider باید بررسی شوند.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: serverless را مساوی بدون سرور یا ارزان در هر workload ندان.

## آموزش تکمیلی مستقل

### ۶. Serverless

Serverless یعنی بخش‌هایی از provisioning، runtime یا scaling را provider مدیریت می‌کند؛ سرور از نظر واقعی حذف نمی‌شود. Function/event-driven execution برای workloadهای bursty، کوتاه‌مدت و مستقل مفید است.

باید این‌ها را بسنجی: cold start، حداکثر زمان اجرا، حافظه، concurrency limit، provider lock-in، دادهٔ بین invocationها، observability و هزینهٔ per invocation. workload دائمی یا پردازش پرحجم ممکن است container/VM ارزان‌تر و قابل‌پیش‌بینی‌تری بخواهد.

## نمودار معماری و خواندن مرحله‌ای

Serverless مدیریت سرور را به provider می‌سپارد و اجرای function را به event یا درخواست وصل می‌کند. پرداخت بر مصرف و مقیاس‌پذیری ساده‌تر می‌شود، اما cold start، quota، observability، local testing و lock-in را باید سنجید.
**دام رایج:** بدون state بودن function را با بی‌نیازی سامانه از state اشتباه نگیر؛ state باید در سرویس بیرونی ذخیره شود.
**تمرین با پاسخ:** function ممکن است دوبار اجرا شود؛ کلید idempotency و ذخیرهٔ پایدار نتیجه را طراحی کن.

این یک view ساده است؛ طراحی production باید مالکیت، شکست، امنیت و محدودیت‌های عملیاتی را نیز روشن کند.

~~~text
[HTTP / queue / timer event]
              |
              v
         [Function]
          /      \
 [Managed DB] [Object store]
              |
       provider runs/scales
~~~

## نمودار معماری و خواندن مرحله‌ای

Serverless اجرای function را به event یا درخواست وصل می‌کند و مدیریت server را به provider می‌سپارد. هزینهٔ مصرف و scale ساده‌تر می‌شود؛ cold start، quota، observability، آزمون محلی و lock-in را بسنج.
**دام رایج:** stateless بودن function به معنی بی‌نیازی از ذخیرهٔ state نیست.
**تمرین با پاسخ:** function دوبار اجرا می‌شود؛ idempotency key و ذخیرهٔ پایدار نتیجه طراحی کن.

این view ساده باید با تصمیم روشن دربارهٔ مالکیت، شکست، امنیت و عملیات کامل شود.

~~~text
[HTTP / queue / timer event]
              |
              v
         [Function]
          /      \
 [Managed DB] [Object store]
              |
       provider runs/scales
~~~

## منابع

### فارسی

- [راهنمای فارسی طراحی دامنه‌محور](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — راهنمای ساختاریافتهٔ فارسی برای DDD، زبان مشترک و مدل‌سازی.
- [DNTips؛ معماری لایه‌بندی نرم‌افزار](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — مثال‌های فارسی در لایهٔ کاربرد و داده.

### انگلیسی

- [Microsoft Learn؛ DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — مرز دامنه، لایه‌ها و مدل دامنه.
- [Martin Fowler؛ CQRS](https://martinfowler.com/bliki/CQRS.html) — تعریف CQRS و هشدار دربارهٔ پیچیدگی اضافی.
- [Martin Fowler؛ Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — ثبت تغییرات به صورت رویداد و ملاحظات بازپخش.

## خلاصه

معماری serverless را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-08)
</div>
