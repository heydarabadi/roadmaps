# مسیر یادگیری Go (Golang)

<div dir="rtl">

این دورهٔ فارسی از گره‌های نقشهٔ [Go Developer در Roadmap.sh](https://roadmap.sh/golang) فصل‌بندی شده است. ساختار شامل ۱۴ فصل و ۲۷ درس موضوعی است. هر درس آموزش مرحله‌ای، مدل ذهنی، مثال Go، دام‌ها، تمرین و کوییز با پاسخ دارد.

## شروع

1. نسخهٔ toolchain را از [Go downloads](https://go.dev/dl/) نصب کن؛ در بازبینی ۱۱ نوامبر ۲۰۲۶، Go 1.27.4 آخرین patch درج‌شده در تاریخچهٔ رسمی است.
2. مسیر [نقشهٔ مطالعهٔ ۱۲ هفته‌ای](%D9%86%D9%82%D8%B4%D9%87-%D9%85%D8%B7%D8%A7%D9%84%D8%B9%D9%87.md) را پیش ببر و هر روز یک بخش را با دست trace کن.
3. پیش از دیدن جواب، تمرین و quiz را حل کن؛ سپس اشتباه را با توضیح مفهوم اصلاح کن.
4. پس از درس‌ها، سه [پروژهٔ راهنمایی‌شده](%D9%BE%D8%B1%D9%88%DA%98%D9%87%E2%80%8C%D9%87%D8%A7/README.md) را به ترتیب انجام بده.
5. برای واژه‌های فنی از [واژه‌نامه](%D9%88%D8%A7%DA%98%D9%87%E2%80%8C%D9%86%D8%A7%D9%85%D9%87.md) و برای ارجاع مستقیم از [منابع و case studyها](SOURCES-AND-CASES.md) استفاده کن.

## فصل‌ها و درس‌ها

1. [شروع و ابزار](01-%D8%B4%D8%B1%D9%88%D8%B9-%D9%88-%D8%A7%D8%A8%D8%B2%D8%A7%D8%B1/README.md) — [معرفی Go](01-%D8%B4%D8%B1%D9%88%D8%B9-%D9%88-%D8%A7%D8%A8%D8%B2%D8%A7%D8%B1/01-%D9%85%D8%B9%D8%B1%D9%81%DB%8C-go/README.md)، [نصب و Hello World](01-%D8%B4%D8%B1%D9%88%D8%B9-%D9%88-%D8%A7%D8%A8%D8%B2%D8%A7%D8%B1/02-%D9%86%D8%B5%D8%A8-%D9%88-hello-world/README.md)، [فرمان‌ها و docs](01-%D8%B4%D8%B1%D9%88%D8%B9-%D9%88-%D8%A7%D8%A8%D8%B2%D8%A7%D8%B1/03-%D9%81%D8%B1%D9%85%D8%A7%D9%86-%D9%88-docs/README.md)
2. [مبانی زبان](02-%D9%85%D8%A8%D8%A7%D9%86%DB%8C-%D8%B2%D8%A8%D8%A7%D9%86/README.md) — [متغیر و constant](02-%D9%85%D8%A8%D8%A7%D9%86%DB%8C-%D8%B2%D8%A8%D8%A7%D9%86/01-variables-constants/README.md)، [type و conversion](02-%D9%85%D8%A8%D8%A7%D9%86%DB%8C-%D8%B2%D8%A8%D8%A7%D9%86/02-types-conversion/README.md)
3. [ساختار داده](03-%D8%B3%D8%A7%D8%AE%D8%AA%D8%A7%D8%B1-%D8%AF%D8%A7%D8%AF%D9%87/README.md) — [array و slice](03-%D8%B3%D8%A7%D8%AE%D8%AA%D8%A7%D8%B1-%D8%AF%D8%A7%D8%AF%D9%87/01-arrays-slices/README.md)، [string](03-%D8%B3%D8%A7%D8%AE%D8%AA%D8%A7%D8%B1-%D8%AF%D8%A7%D8%AF%D9%87/02-strings/README.md)، [map](03-%D8%B3%D8%A7%D8%AE%D8%AA%D8%A7%D8%B1-%D8%AF%D8%A7%D8%AF%D9%87/03-maps-comma-ok/README.md)، [struct و embedding](03-%D8%B3%D8%A7%D8%AE%D8%AA%D8%A7%D8%B1-%D8%AF%D8%A7%D8%AF%D9%87/04-struct-tags-embedding/README.md)
4. [کنترل و تابع](04-%DA%A9%D9%86%D8%AA%D8%B1%D9%84-%D9%88-%D8%AA%D9%88%D8%A7%D8%A8%D8%B9/README.md) — [شرط و حلقه](04-%DA%A9%D9%86%D8%AA%D8%B1%D9%84-%D9%88-%D8%AA%D9%88%D8%A7%D8%A8%D8%B9/01-loops-conditionals/README.md)، [function و closure](04-%DA%A9%D9%86%D8%AA%D8%B1%D9%84-%D9%88-%D8%AA%D9%88%D8%A7%D8%A8%D8%B9/02-functions-closures/README.md)
5. [Pointer و حافظه](05-pointer-memory/README.md) — [pointer، حافظه و GC](05-pointer-memory/01-pointers-memory-gc/README.md)
6. [Method، interface و generics](06-%D9%85%D8%AA%D8%AF-interface-generics/README.md) — [method و interface](06-%D9%85%D8%AA%D8%AF-interface-generics/01-methods-interfaces/README.md)، [generics](06-%D9%85%D8%AA%D8%AF-interface-generics/02-generics/README.md)
7. [Package و module](07-packages-modules/README.md) — [سازمان کد و dependency](07-packages-modules/01-packages-modules/README.md)
8. [خطا و تاب‌آوری](08-error-resilience/README.md) — [error chain](08-error-resilience/01-errors/README.md)، [panic، defer و recover](08-error-resilience/02-panic-defer-recover/README.md)
9. [Concurrency](09-concurrency/README.md) — [goroutine و channel](09-concurrency/01-goroutines-channels/README.md)، [sync و context](09-concurrency/02-sync-context/README.md)، [worker pool و pipeline](09-concurrency/03-worker-pool-pipeline/README.md)، [race detector](09-concurrency/04-race-detector/README.md)
10. [Testing](10-testing/README.md) — [test و httptest](10-testing/01-testing-httptest/README.md)، [benchmark و coverage](10-testing/02-benchmarks-coverage/README.md)
11. [Standard library](11-standard-library/README.md) — [I/O، JSON، time و ابزارهای استاندارد](11-standard-library/01-stdlib-io-json-time/README.md)
12. [اکوسیستم](12-%D8%A7%DA%A9%D9%88%D8%B3%DB%8C%D8%B3%D8%AA%D9%85/README.md) — [CLI، web، gRPC، database و realtime](12-%D8%A7%DA%A9%D9%88%D8%B3%DB%8C%D8%B3%D8%AA%D9%85/01-%DA%A9%D8%AA%D8%A7%D8%A8%D8%AE%D8%A7%D9%86%D9%87-%D9%87%D8%A7%DB%8C-%D8%A7%DA%A9%D9%88%D8%B3%DB%8C%D8%B3%D8%AA%D9%85/README.md)
13. [Toolchain، امنیت و deploy](13-toolchain-%D8%A7%D9%85%D9%86%DB%8C%D8%AA/README.md) — [فرمان‌ها، lint، scan و artifact](13-toolchain-%D8%A7%D9%85%D9%86%DB%8C%D8%AA/01-tooling-security-deploy/README.md)
14. [مباحث پیشرفته](14-%D9%85%D8%A8%D8%A7%D8%AD%D8%AB-%D9%BE%DB%8C%D8%B4%D8%B1%D9%81%D8%AA%D9%87/README.md) — [runtime، reflection، unsafe و cgo](14-%D9%85%D8%A8%D8%A7%D8%AD%D8%AB-%D9%BE%DB%8C%D8%B4%D8%B1%D9%81%D8%AA%D9%87/01-advanced-runtime/README.md)

## دامنه و نسخه

لینک مقصد درخواست به مسیر /golang بود؛ عنوان نمایشی پیام به /system-design اشاره داشت. این دوره طبق مقصد واقعی، رودمپ Go را مبنا گرفته است. PDF مبنا [Go Developer Roadmap](https://roadmap.sh/pdfs/roadmaps/golang.pdf) است. عنوان‌های رسمی به درس‌های محلی در [نگاشت کامل Roadmap](ROADMAP-MAP.md) وصل شده‌اند؛ چند زیرموضوع نزدیک در یک درس ادغام شده است. نسخهٔ patch در روز بازبینی Go 1.27.4 است؛ directive زبان ماژول Go 1.27 می‌ماند و ویژگی نسخه‌دار کنار موضوعش توضیح داده شده است. تاریخچه و منبع در [Go Release History](https://go.dev/doc/devel/release) ثبت شده.

تمام مفاهیم اصلی این سرفصل، با مثال و تمرین، داخل پوشه درس داده شده‌اند تا مسیر را بدون اتصال دائمی به اینترنت بخوانی. منابع بیرونی برای spec جاری، تغییرهای نسخه و مقالهٔ اصلی case study نگه داشته شده‌اند؛ این دوره جست‌وجوی کامل همهٔ صفحه‌های اینترنت را ادعا نمی‌کند.

## نسخهٔ انگلیسی

[Go Self-Study Course — English Edition](../../en/go/README.md)

## ابزارهای مرور

- [نقشهٔ مطالعه](%D9%86%D9%82%D8%B4%D9%87-%D9%85%D8%B7%D8%A7%D9%84%D8%B9%D9%87.md)
- [واژه‌نامهٔ انگلیسی ـ فارسی](%D9%88%D8%A7%DA%98%D9%87%E2%80%8C%D9%86%D8%A7%D9%85%D9%87.md)
- [پروژه‌ها](%D9%BE%D8%B1%D9%88%DA%98%D9%87%E2%80%8C%D9%87%D8%A7/README.md)
- [نگاشت رودمپ](ROADMAP-MAP.md)
- [منابع و تجربه‌های واقعی](SOURCES-AND-CASES.md)
- [معیار گسترش و ممیزی دوره](COURSE-EXPANSION-PLAN.md)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](../../en/go/README.md)
</div>
