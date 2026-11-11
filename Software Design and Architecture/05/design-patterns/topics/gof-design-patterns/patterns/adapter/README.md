<div dir="rtl" align="right">

# سازگارگر — Adapter


> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/05/design-patterns/topics/gof-design-patterns/patterns/adapter/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** structural · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

رابط ناسازگار را به قراردادی که مصرف‌کننده انتظار دارد تبدیل می‌کند.

## مثال کاربردی

adapter پاسخ SDK پرداخت را به نتیجهٔ استاندارد دامنه نگاشت می‌کند.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** mapping خطا و معنا باید صریح باشد؛ جزئیات خطا را پنهان نکن.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: رابط ناسازگار را به قراردادی که مصرف‌کننده انتظار دارد تبدیل می‌کند.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: adapter پاسخ SDK پرداخت را به نتیجهٔ استاندارد دامنه نگاشت می‌کند.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: mapping خطا و معنا باید صریح باشد؛ جزئیات خطا را پنهان نکن.

## آموزش تکمیلی مستقل

### ۲. خانوادهٔ ساختاری GoF

Structural patternها ترکیب و رابط میان objectها را سامان می‌دهند.

| الگو | کاربرد | محدودیت |
| --- | --- | --- |
| Adapter | ترجمهٔ contract ناسازگار به نیاز مصرف‌کننده | خطا و معنای provider هنگام ترجمه نباید گم شود |
| Bridge | جداسازی abstraction از implementation برای تغییر مستقل | دو محور hierarchy و indirection می‌سازد |
| Composite | پردازش leaf و tree از راه یک قرارداد مشترک | ساختار بازگشتی و رفتار مشترک واقعی لازم است |
| Decorator | افزودن behavior با wrapperهای قابل‌ترکیب | ترتیب wrapper و trace را پیچیده می‌کند |
| Facade | API ساده جلوی زیرسیستم پیچیده | می‌تواند به god object تبدیل شود |
| Flyweight | اشتراک دادهٔ ثابت میان تعداد زیادی object برای کاهش حافظه | باید حالت مشترک را از حالت وابسته به نمونه جدا کرد و صرفه‌جویی را اندازه گرفت |
| Proxy | واسطه برای کنترل دسترسی، lazy loading، remote call یا cache | latency و failure نباید پشت رابط پنهان بمانند |

## پیاده‌سازی گام‌به‌گام

SDK پرداخت فروشنده را پشت قرارداد داخلی ترجمه می‌کنیم؛ شکل درخواست و معنای خطا هر دو باید حفظ شوند. use case نباید نوع SDK را بشناسد. نگاشت موفقیت، رد، timeout و پاسخ خراب را جدا آزمون کن.
**تمرین با پاسخ:** فروشنده عوض شد؛ باید adapter و آزمونش تغییر کند. اگر use case هم تغییر می‌کند، جزئیات vendor از مرز عبور کرده‌اند.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public sealed class VendorPaymentAdapter(IVendorSdk sdk) : IPaymentGateway
{
    public async Task<PaymentResult> Capture(Money amount, CancellationToken ct)
    {
        var reply = await sdk.ChargeAsync(amount.MinorUnits, amount.CurrencyCode, ct);
        return reply.Approved
            ? PaymentResult.Success(reply.TransactionReference)
            : PaymentResult.Declined(MapReason(reply.Code));
    }
}
~~~


## منابع

### فارسی

- [الگوهای طراحی فارسی](https://alireza-haeri.github.io/Persian-Design-Patterns/) — خلاصه‌های فارسی از الگوهای GoF و چند الگوی معماری.
- [آزمایشگاه مهندسی نرم‌افزار هوشمند؛ اصول و الگوها](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — منبع درسی فارسی برای GoF، GRASP و الگوهای معماری.

### انگلیسی

- [Refactoring.Guru؛ Design Patterns](https://refactoring.guru/design-patterns) — فهرست الگوهای GoF و مثال‌های چندزبانه.
- [Patterns.Guru؛ GoF catalog](https://patterns.guru/) — بازخوانی امروزی الگوها و هزینهٔ انتخاب آن‌ها.
- [Wiley؛ POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — نمونه‌ای از الگوهای معماری و هم‌زمانی در مجموعهٔ POSA.



## منابع تکمیلی

[کتابخانهٔ منابع مرتبط با این فصل](../../../../../../references.md#chapter-05)
</div>
