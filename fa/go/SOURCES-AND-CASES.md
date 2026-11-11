# منابع منتخب، تجربه‌های واقعی و راهنمای ارجاع

<div dir="rtl">

## نسخه و منابع رسمی Go

این دوره در ۱۱ نوامبر ۲۰۲۶ با مرجع رسمی بازبینی شده است. release history رسمی، Go 1.27.4 را منتشرشده در ۱۰ نوامبر ۲۰۲۶ نشان می‌دهد؛ این patch شامل اصلاحات امنیتی و bug fix است. نسخهٔ language در ماژول همچنان 1.27 نوشته می‌شود؛ نسخهٔ patch را با syntax directive ماژول اشتباه نگیر.

- [Go release history](https://go.dev/doc/devel/release) — مرجع تاریخ patchها و policy پشتیبانی.
- [Go 1.27 release notes](https://go.dev/doc/go1.27) — تغییرهای زبان، runtime، library و ابزار.
- [Go official downloads](https://go.dev/dl/) و [release archive](https://go.dev/dl/) — نصب نسخهٔ جاری و archive.
- [Go Documentation](https://go.dev/doc/)، [A Tour of Go](https://go.dev/tour/)، [Effective Go](https://go.dev/doc/effective_go)، [Language Specification](https://go.dev/ref/spec).
- [Go Blog](https://go.dev/blog/)، [Go security policy](https://go.dev/security/)، [pkg.go.dev](https://pkg.go.dev/).
- [Go diagnostics](https://go.dev/doc/diagnostics) و [Go vulnerability management](https://go.dev/doc/security/vuln/).
- [Go blog — Goroutine leak profile](https://go.dev/blog/goroutine-leak-profiles) برای درک قابلیت نسخهٔ Go 1.27 و محدودیت‌های تشخیص.
- [راهنمای مهاجرت JSON v2](https://go.dev/doc/jsonv2-migration) برای تفاوت‌های سازگاری و مسیر تدریجی مهاجرت از API قبلی.

اگر رفتار API یا نسخه تغییر کرد، release notes/spec/package docs را دوباره ببین. توضیح محلی برای آموزش و mental model است؛ مرجع رسمی برای جزئیات دقیق نسخه authority دارد.

## منابع آموزشی فارسی

این لینک‌ها نقطهٔ شروع و مکمل فارسی‌اند؛ بعضی محتواها قدیمی‌تر از Go 1.27 هستند. syntax یا رفتار نسخه‌ای را از یک مطلب قدیمی حدس نزن.

- [GoFarsi — مبانی](https://cloud-book.gofarsi.ir/chapter-1/)
- [GoFarsi — مکانیزم زبان](https://cloud-book.gofarsi.ir/chapter-2/)
- [GoFarsi — هم‌زمانی](https://book.gofarsi.ir/chapter-3/)
- [GoFarsi — مباحث پیشرفته](https://book.gofarsi.ir/chapter-4/)
- [GoFarsi — array و slice](https://book.gofarsi.ir/chapter-1/go-array/)
- [GoFarsi — goroutine](https://book.gofarsi.ir/chapter-3/goroutine/)
- [GoFarsi — Go Modules](https://book.gofarsi.ir/chapter-4/go-mod/)
- [Tarhche — گولنگ به زبان ساده](https://tarhche.com/fa/articles/018fabf6-10ac-7e5a-ab68-0f33e765574f)
- [Tour فارسی Go](https://fa-go-dev.shuijingwanwq.com/tour/list)
- [Faragiri — مجموعهٔ درس‌های Go](https://faragiri.com/learning/go/)؛ محتوای آموزشی بیرونی است و نسخه/تاریخ درس را پیش از پیروی بررسی کن.
- [DinaCode — Go از صفر](https://dinacode.net/courses/go-az-sefr)؛ صفحه اعلام می‌کند محیط مثال‌هایش Go 1.16.2 است، پس مطالب جدید مثل generics و امکانات تازه را پوشش نمی‌دهد.

در هر README، منبع فارسی همان موضوع کنار مستند رسمی آمده است؛ اگر نشانی یک سایت جابه‌جا شد، اسم درس/سایت را در جست‌وجو پیدا کن و لینک جدید را پس از بازکردن منبع اصلاح کن.

## تجربه‌های واقعی و paper

| منبع دست‌اول | چه چیزی را برای یادگیری بخوانی | محدودیت شواهد |
|---|---|---|
| [Go Case Studies](https://go.dev/solutions/case-studies) و [Success Stories](https://go.dev/wiki/SuccessStories) | نمونه‌های Go در شرکت‌ها و سرویس‌های مختلف | گزیدهٔ روایت سازمان‌هاست؛ همهٔ سیستم‌ها یکسان نیستند. |
| [Dropbox — Open-sourcing our Go libraries](https://dropbox.tech/infrastructure/open-sourcing-our-go-libraries) | مهاجرت backendهای حساس به کارایی از Python و ساخت libraryهای داخلی؛ مقاله مربوط به ۲۰۱۴ است | تجربهٔ Dropbox در آن دوره و workload آن تیم. |
| [Allegro — Fast cache service with millions of entries](https://blog.allegro.tech/2016/03/writing-fast-cache-service-in-go.html) | cache، sharding، profile و اثر GC | اعداد performance وابسته به workload، hardware و نسخهٔ مقاله‌اند. |
| [Twitch — Go’s march to low-latency GC](https://blog.twitch.tv/en/2016/07/05/gos-march-to-low-latency-gc-a6fa96f06eb7/) | تجربهٔ chat هم‌زمان و همکاری پیرامون latency GC | تاریخی است؛ رفتار نسخه‌های امروز را مستقیم نشان نمی‌دهد. |
| [Uber — A Study of Real-World Data Races in Golang](https://arxiv.org/abs/2204.00764) | دشواری detector در محیط بزرگ و تجربهٔ اجرای آن در کد Go Uber | اعداد فقط به codebase، sample و بازهٔ مقاله تعلق دارند؛ نتیجهٔ عمومی نیست. |
| [Cloudflare — Do you want to work with Go?](https://blog.cloudflare.com/do-you-want-to-work-with-go/) | تجربهٔ استفاده از Go در tooling شبکه و زیرساخت | مقالهٔ تجربی سازمان است، نه benchmark بی‌طرف. |
| [Google SRE Book — Handling Overload](https://sre.google/sre-book/handling-overload/) | retry budget، overload و جلوگیری از retry amplification | الگو را به SLO، client mix و dependency واقعی خودت تطبیق بده. |
| [Uber Go Style Guide](https://github.com/uber-go/guide) | conventions و تصمیم‌های code review یک سازمان | style guide تیم جایگزین spec زبان نیست. |
| [Kubernetes source repository](https://github.com/kubernetes/kubernetes) | مشاهدهٔ Go در codebase بزرگ متن‌باز | repository بزرگ است؛ برای یادگیری از package کوچک و ownership شروع کن. |
| [Uber — کاهش ۷۰هزار core در ۳۰ سرویس](https://www.uber.com/gb/en/blog/how-we-saved-70k-cores-across-30-mission-critical-services/) | تنظیم GC، بودجهٔ حافظه و observability در مقیاس fleet | تجربهٔ سال ۲۰۲۱ و workloadهای Uber؛ tuning به ظرفیت حافظه و safeguard نیاز دارد. |
| [Uber — بهینه‌سازی حافظهٔ ترجمه‌ها در مقیاس](https://www.uber.com/gp/en/blog/translations-at-scale/) | نمونهٔ ۲۰۲۶ از کاهش objectها و هزینهٔ GC با تغییر چیدمان داده | اثر گزارش‌شده برای همان سرویس و سنجش نویسندگان است. |
| [Uber — کاهش هزینهٔ رشد stack](https://www.uber.com/gb/en/blog/zero-growth-stack/) | تجربهٔ ۲۰۲۶ دربارهٔ اندازهٔ stack و مصرف CPU در مقیاس | یک workload و دست‌کاری runtime خاص؛ پیش از اندازه‌گیری tuning نکن. |
| [Discord — چرا یک سرویس را از Go به Rust منتقل کرد](https://discord.com/blog/why-discord-is-switching-from-go-to-rust) | نمونهٔ hot path که latency مربوط به GC با هدف محصول سازگار نبود | گزارش یک سرویس cache-heavy با قیدهای خاص است؛ حکم عمومی دربارهٔ Go نیست. |
| [Discord — ذخیره‌سازی تریلیون‌ها پیام](https://discord.com/blog/how-discord-stores-trillions-of-messages) | معماری storage، عملیات Cassandra و trade-off زبان/runtime | گزارش عملیاتی شرکت است؛ GC دیتابیس Cassandra را با GC زبان Go اشتباه نگیر. |

این مثال‌ها به‌جای «Go همیشه سریع‌تر است» نشان می‌دهند تیم‌ها trade-off را با اندازه‌گیری، profile، workload و عملیات بررسی می‌کنند. تجربهٔ گزارش‌شده را از استنتاج خودمان جدا نگه دار.

## دربارهٔ دامنهٔ جست‌وجو

این فهرست curated و محدود به منابع مستقیم، رسمی، فارسی آموزشی و case studyهای قابل‌ارجاع است؛ ادعای index یا خواندن تمام صفحه‌های اینترنت نمی‌کند. همهٔ کدها و آموزش‌های لازم برای سرفصل‌های Roadmap در درس‌های محلی توضیح داده شده‌اند؛ لینک‌های بیرونی برای مرجع نسخه، شواهد اصلی و مطالعهٔ انتخابی‌اند.



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](../../en/go/SOURCES-AND-CASES.md)
</div>
