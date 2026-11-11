<div dir="rtl" align="right">

# اشیای ارزشی — Value Objects

> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/software-design-and-architecture/09/enterprise-patterns/topics/value-objects/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**جایگاه در نقشه‌راه:** [الگوهای نرم‌افزار سازمانی](../../README.md) · [فهرست کل دوره](../../../../00-index.md)

## هدف یادگیری

پس از این درس بتوانی مفهوم را با زبان خودت تعریف کنی، در مثال دامنه‌ای تشخیصش بدهی و هزینهٔ انتخاب یا کنارگذاشتنش را توضیح بدهی.

## آموزش

value object با مقدار و معنا شناخته می‌شود نه شناسهٔ مستقل؛ معمولاً immutable است و invariant را در ساختن حفظ می‌کند.

## مثال کاربردی

`Money(amount, currency)` جمع پول‌های با ارز متفاوت را رد می‌کند.

این مثال آموزشی است و ادعای پیاده‌سازی دقیق یک شرکت مشخص را ندارد. نمونهٔ صنعتی مستند و زمینهٔ آن در فصل «الگوهای نرم‌افزار سازمانی» پیوند داده شده است.

## تصمیم معماری و محدودیت‌ها

- **چه زمانی به‌کار ببر:** وقتی مسئلهٔ اصلی‌ای که مفهوم حل می‌کند در سامانه واقعاً دیده می‌شود و قراردادش می‌تواند در کد یا آزمون بررسی شود.
- **چه زمانی ساده‌تر بماند:** نوع‌های زیاد می‌توانند mapping و serialization را سنگین کنند.
- **بازبینی:** مقدار دامنه‌ای مثل Money را به عدد بی‌واحد تبدیل نکن.

## کوییز با پاسخ تشریحی

پاسخ را بپوشان و ابتدا با کلمات خودت توضیح بده؛ پاسخ پیشنهادی معیار سنجش است، نه تنها عبارت درست.

1. **این مفهوم دقیقاً چه مسئله‌ای را حل می‌کند؟**
   - پاسخ پیشنهادی: value object با مقدار و معنا شناخته می‌شود نه شناسهٔ مستقل؛ معمولاً immutable است و invariant را در ساختن حفظ می‌کند.
2. **در مثال زیر چه تصمیمی می‌گیری و چرا؟**
   - پاسخ پیشنهادی: `Money(amount, currency)` جمع پول‌های با ارز متفاوت را رد می‌کند.
3. **چه زمانی انتخاب آن نامناسب یا پرهزینه است؟**
   - پاسخ پیشنهادی: نوع‌های زیاد می‌توانند mapping و serialization را سنگین کنند.
4. **کدام خطای رایج را قبل از ادغام کد بررسی می‌کنی؟**
   - پاسخ پیشنهادی: مقدار دامنه‌ای مثل Money را به عدد بی‌واحد تبدیل نکن.

## آموزش تکمیلی مستقل

### ۸. Value Object

Value Object هویت مستقل ندارد و با مقدار/معنایش برابر است. Money شامل amount و currency است؛ EmailAddress می‌تواند نرمال‌سازی و اعتبار پایه را هنگام ساخت انجام دهد. Value object عموماً immutable است تا تغییر پنهان و hash/equality ناپایدار نشود.

~~~python
@dataclass(frozen=True)
class Money:
    amount_cents: int
    currency: str

    def add(self, other):
        if self.currency != other.currency:
            raise ValueError("Currencies must match")
        return Money(self.amount_cents + other.amount_cents, self.currency)
~~~

نوع‌های دامنه‌ای زیاد mapping و serialization می‌آورند؛ برای هر رشتهٔ ساده type نساز مگر معنا، validation یا عملیات مشخص داشته باشد.

## نمونهٔ کد مرحله‌ای

Value Object با مقدار و equality مبتنی بر مقدار تعریف می‌شود و هویت مستقل ندارد. آن را immutable و self-validating بساز تا واحد، ارز و بازهٔ معتبر همراه داده بمانند.
**دام رایج:** پول را decimal بی‌واحد نگذار؛ جمع ارزهای متفاوت باید رد یا با نرخ آشکار تبدیل شود.
**تمرین با پاسخ:** Money با مقدار ۱۰ USD با ۱۰ EUR برابر نیست؛ currency بخشی از equality و invariant عملیات است.

در این طرح C#، نوع‌های پشتیبان کوتاه شده‌اند تا مرز الگو روشن بماند.

~~~csharp
public sealed record Money(decimal Amount, string Currency)
{
    public Money Add(Money other)
    {
        if (Currency != other.Currency) throw new InvalidOperationException();
        return this with { Amount = Amount + other.Amount };
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

اشیای ارزشی را برای حل مسئلهٔ مشخص به کار ببر، trade-off آن را ثبت کن و با یک آزمون/معیار قابل مشاهده بررسی کن که آیا مرز طراحی واقعاً بهتر شده است.


## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../references.md#chapter-09)
</div>
