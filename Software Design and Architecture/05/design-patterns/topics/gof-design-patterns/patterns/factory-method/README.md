<div dir="rtl" align="right">

# متد کارخانه — Factory Method


> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/05/design-patterns/topics/gof-design-patterns/patterns/factory-method/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** creational · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

ایجاد محصول را به عملیات یا زیرنوع سازنده واگذار می‌کند تا caller به نوع concrete گره نخورد.

## مثال کاربردی

چارچوب import فرمت فایل را از پیاده‌سازی انتخاب‌شده می‌سازد.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** اگر یک map ساده یا dependency injection کافی است، سلسله‌مراتب ارث‌بری نساز.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: ایجاد محصول را به عملیات یا زیرنوع سازنده واگذار می‌کند تا caller به نوع concrete گره نخورد.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: چارچوب import فرمت فایل را از پیاده‌سازی انتخاب‌شده می‌سازد.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: اگر یک map ساده یا dependency injection کافی است، سلسله‌مراتب ارث‌بری نساز.

## آموزش تکمیلی مستقل

### ۱. خانوادهٔ ایجادی GoF

الگوهای ایجادی چگونگی ساخت object را از مصرف‌کننده جدا می‌کنند. [فایل کامل هرکدام](../../README.md) شامل مثال و quiz جداست.

| الگو | کاربرد | محدودیت |
| --- | --- | --- |
| Abstract Factory | تولید خانواده‌ای سازگار از محصولات؛ مانند کنترل‌های UI برای سیستم‌عامل مشخص | افزودن محصول جدید ممکن است همهٔ factoryها را تغییر دهد |
| Builder | ساخت object پیچیده با گزینه‌ها، ترتیب یا validation | برای object ساده سربار دارد؛ object ناقص را نباید بیرون داد |
| Factory Method | واگذاری انتخاب نوع concrete به creator یا subclass | hierarchy موازی می‌سازد؛ DI binding یا factory تابعی شاید کافی باشد |
| Prototype | کپی شیء پیکربندی‌شده وقتی ساخت مجدد گران یا دشوار است | shallow/deep copy و reference مشترک ریسک دارند |
| Singleton | محدودکردن نمونه و دسترسی مشترک | global state، تست سخت و مشکل concurrency؛ معمولاً DI بهتر است |

## پیاده‌سازی گام‌به‌گام

جریان ساخت خروجی گزارش ثابت است، اما writer با قالب فرق می‌کند. creator جریان را نگه می‌دارد و زیرکلاس فقط محصول را تعیین می‌کند. اگر الگوریتم اصلی واقعی و پایدار است مفید است؛ factory تابعی یا DI ممکن است کم‌هزینه‌تر باشد.
**تمرین با پاسخ:** اگر CSV و PDF مراحل متفاوت هم دارند، یک hook مشترک را تحمیل نکن؛ فقط مراحل واقعاً یکسان را استخراج کن.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public abstract class ReportExporter
{
    public void Export(Report report)
    {
        var writer = CreateWriter();
        writer.WriteHeader(report.Title);
        writer.WriteRows(report.Rows);
        writer.Complete();
    }

    protected abstract IReportWriter CreateWriter();
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
