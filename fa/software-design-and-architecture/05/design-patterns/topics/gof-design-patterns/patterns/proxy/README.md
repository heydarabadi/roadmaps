<div dir="rtl" align="right">

# واسطه — Proxy


> **زبان:** [نسخهٔ انگلیسی](../../../../../../../../en/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/proxy/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** structural · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

جایگزین کنترل‌شده‌ای جلوی شیء می‌گذارد تا دسترسی، lazy loading یا ارتباط راه‌دور را مدیریت کند.

## مثال کاربردی

proxy قبل از تماس با سرویس بیرونی احراز هویت یا cache انجام می‌دهد.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** هزینهٔ پنهان latency و failure را پشت همان رابط جا نگذار.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: جایگزین کنترل‌شده‌ای جلوی شیء می‌گذارد تا دسترسی، lazy loading یا ارتباط راه‌دور را مدیریت کند.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: proxy قبل از تماس با سرویس بیرونی احراز هویت یا cache انجام می‌دهد.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: هزینهٔ پنهان latency و failure را پشت همان رابط جا نگذار.

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

Proxy همان قرارداد object واقعی را ارائه می‌کند و ساخت، مجوز یا دسترسی راه‌دور را کنترل می‌کند. latency و خطا را پنهان نکن و هم‌زمانی lazy initialization را بررسی کن.
**تمرین با پاسخ:** بارگذاری تصویر شکست خورد؛ خطای روشن بده و تعیین کن فراخوانی بعدی retry می‌کند یا شکست cache می‌شود.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public sealed class LazyImage(string path, IImageLoader loader) : IImage
{
    private IImage? _real;
    public void Draw(Canvas canvas)
    {
        _real ??= loader.Load(path);
        _real.Draw(canvas);
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
