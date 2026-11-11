<div dir="rtl" align="right">

# پل — Bridge


> **زبان:** [نسخهٔ انگلیسی](../../../../../../../../en/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/bridge/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** structural · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

انتزاع را از پیاده‌سازی جدا می‌کند تا دو بُعد مستقل تغییر کنند.

## مثال کاربردی

گزارش‌دهی و مقصد ذخیره‌سازی مستقل ترکیب می‌شوند.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** ساختار دو سلسله‌مراتبی برای دو بُعد تغییر فهم را دشوار می‌کند.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: انتزاع را از پیاده‌سازی جدا می‌کند تا دو بُعد مستقل تغییر کنند.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: گزارش‌دهی و مقصد ذخیره‌سازی مستقل ترکیب می‌شوند.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: ساختار دو سلسله‌مراتبی برای دو بُعد تغییر فهم را دشوار می‌کند.

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

نوع گزارش و قالب رندر دو محور تغییر مستقل‌اند. Bridge آن‌ها را با composition جدا می‌کند تا برای هر ترکیب زیرکلاس نسازیم. هزینه‌اش abstraction و delegation اضافه است؛ اگر محور دوم واقعی نیست، طراحی ساده را حفظ کن.
**تمرین با پاسخ:** رندر متنی را بیفزا بی‌آنکه قواعد فاکتور تغییر کند. اگر hierarchy گزارش برای هر قالب دست‌کاری می‌شود، محورها جدا نشده‌اند.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public interface IReportRenderer
{
    string Render(string title, IReadOnlyList<string> rows);
}

public abstract class Report
{
    protected readonly IReportRenderer Renderer;
    protected Report(IReportRenderer renderer) => Renderer = renderer;
    public abstract string Print();
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
