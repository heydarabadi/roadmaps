<div dir="rtl" align="right">

# تک‌نمونه — Singleton


> **زبان:** [نسخهٔ انگلیسی](../../../../../../en/05/design-patterns/topics/gof-design-patterns/patterns/singleton/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** creational · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

وجود یک نمونهٔ مشترک را تضمین می‌کند و معمولاً دسترسی global هم فراهم می‌کند.

## مثال کاربردی

یک cache process-local شاید واقعاً نمونهٔ واحد در هر process بخواهد.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** دسترسی global، تست و concurrency را سخت می‌کند؛ برای shared service معمولاً DI بهتر است.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: وجود یک نمونهٔ مشترک را تضمین می‌کند و معمولاً دسترسی global هم فراهم می‌کند.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: یک cache process-local شاید واقعاً نمونهٔ واحد در هر process بخواهد.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: دسترسی global، تست و concurrency را سخت می‌کند؛ برای shared service معمولاً DI بهتر است.

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

Singleton فقط یک نمونه در هر process می‌دهد، نه یک نمونه در cluster. دسترسی global وابستگی پنهان ایجاد می‌کند و آزمون را دشوار می‌سازد. برای سرویس برنامه معمولاً lifetime تک‌نمونه در DI کنترل‌پذیرتر است.
**تمرین با پاسخ:** آیا حافظهٔ Singleton میان containerها مشترک است؟ خیر؛ هر process نمونهٔ خود را دارد. از storage مشترک یا هماهنگ‌کننده استفاده کن.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public sealed class MetricsRegistry
{
    private static readonly Lazy<MetricsRegistry> Holder =
        new(() => new MetricsRegistry());

    public static MetricsRegistry Instance => Holder.Value;
    private MetricsRegistry() { }
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
