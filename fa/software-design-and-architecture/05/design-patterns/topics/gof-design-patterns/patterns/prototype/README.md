<div dir="rtl" align="right">

# نمونه‌اولیه — Prototype


> **زبان:** [نسخهٔ انگلیسی](../../../../../../../../en/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/prototype/README.md)

> [ادامهٔ آموزش عمیق در درس کامل این فصل](../../../../lessons.md) — مثال‌ها، مبادله‌ها و آزمون جامع.

**خانواده:** creational · **فصل:** [الگوهای طراحی](../../../../README.md)

## قصد الگو

شیء پیکربندی‌شده را کپی می‌کند تا ساخت مجدد یا شناخت نوع concrete لازم نباشد.

## مثال کاربردی

ویرایشگر سند از یک الگوی آماده کپی عمیق می‌گیرد.

## زمان استفاده و محدودیت

این الگو زمانی کاندید است که فشار مسئله با قصد آن سازگار باشد و قراردادش بتواند پیچیدگی را در یک مرز قابل‌فهم محدود کند.

**محدودیت مهم:** تفاوت shallow/deep copy و ارجاع‌های مشترک منبع باگ است.

## پرسش‌های آزمون با پاسخ

1. **کدام مسئله را حل می‌کند؟**
   - پاسخ پیشنهادی: شیء پیکربندی‌شده را کپی می‌کند تا ساخت مجدد یا شناخت نوع concrete لازم نباشد.
2. **در این مثال چه چیزی را ساختار می‌دهد؟**
   - پاسخ پیشنهادی: ویرایشگر سند از یک الگوی آماده کپی عمیق می‌گیرد.
3. **چه زمانی بهتر است سراغ گزینهٔ ساده‌تر بروی؟**
   - پاسخ پیشنهادی: تفاوت shallow/deep copy و ارجاع‌های مشترک منبع باگ است.

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

قالب گزارش آماده را کپی می‌کنیم وقتی ساخت دوبارهٔ آن گران یا دشوار است. معنای shallow و deep copy را مشخص کن؛ referenceهای mutable مشترک نشت state می‌سازند. اگر ساخت ارزان است، شیء تازه بساز.
**تمرین با پاسخ:** تغییر فهرست ستون در کپی نباید قالب اصلی را تغییر دهد؛ فهرست را immutable کن یا جداگانه کپی کن.

قطعه‌کد C# طرح آموزشی است و نوع‌های پشتیبان دامنه را کوتاه کرده است.

~~~csharp
public sealed record ReportTemplate(
    string Header, string Footer, IReadOnlyList<string> Columns);

var monthly = invoiceTemplate with { Header = "Monthly report" };
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
