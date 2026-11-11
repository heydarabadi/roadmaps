# مسیر یادگیری Go (Golang)

<div dir="rtl">

این دورهٔ فارسی از گره‌های نقشهٔ [Go Developer در Roadmap.sh](https://roadmap.sh/golang) فصل‌بندی شده است. ساختار شامل ۱۴ فصل و ۲۷ درس موضوعی است. هر درس آموزش مرحله‌ای، مدل ذهنی، مثال Go، دام‌ها، تمرین و کوییز با پاسخ دارد.

## شروع

1. نسخهٔ toolchain را از [Go downloads](https://go.dev/dl/) نصب کن؛ در بازبینی ۱۱ نوامبر ۲۰۲۶، Go 1.27.4 آخرین patch درج‌شده در تاریخچهٔ رسمی است.
2. مسیر [نقشهٔ مطالعهٔ ۱۲ هفته‌ای](نقشه-مطالعه.md) را پیش ببر و هر روز یک بخش را با دست trace کن.
3. پیش از دیدن جواب، تمرین و quiz را حل کن؛ سپس اشتباه را با توضیح مفهوم اصلاح کن.
4. پس از درس‌ها، سه [پروژهٔ راهنمایی‌شده](پروژه‌ها/README.md) را به ترتیب انجام بده.
5. برای واژه‌های فنی از [واژه‌نامه](واژه‌نامه.md) و برای ارجاع مستقیم از [منابع و case studyها](SOURCES-AND-CASES.md) استفاده کن.

## فصل‌ها و درس‌ها

1. [شروع و ابزار](01-شروع-و-ابزار/README.md) — [معرفی Go](01-شروع-و-ابزار/01-معرفی-go/README.md)، [نصب و Hello World](01-شروع-و-ابزار/02-نصب-و-hello-world/README.md)، [فرمان‌ها و docs](01-شروع-و-ابزار/03-فرمان-و-docs/README.md)
2. [مبانی زبان](02-مبانی-زبان/README.md) — [متغیر و constant](02-مبانی-زبان/01-variables-constants/README.md)، [type و conversion](02-مبانی-زبان/02-types-conversion/README.md)
3. [ساختار داده](03-ساختار-داده/README.md) — [array و slice](03-ساختار-داده/01-arrays-slices/README.md)، [string](03-ساختار-داده/02-strings/README.md)، [map](03-ساختار-داده/03-maps-comma-ok/README.md)، [struct و embedding](03-ساختار-داده/04-struct-tags-embedding/README.md)
4. [کنترل و تابع](04-کنترل-و-توابع/README.md) — [شرط و حلقه](04-کنترل-و-توابع/01-loops-conditionals/README.md)، [function و closure](04-کنترل-و-توابع/02-functions-closures/README.md)
5. [Pointer و حافظه](05-pointer-memory/README.md) — [pointer، حافظه و GC](05-pointer-memory/01-pointers-memory-gc/README.md)
6. [Method، interface و generics](06-متد-interface-generics/README.md) — [method و interface](06-متد-interface-generics/01-methods-interfaces/README.md)، [generics](06-متد-interface-generics/02-generics/README.md)
7. [Package و module](07-packages-modules/README.md) — [سازمان کد و dependency](07-packages-modules/01-packages-modules/README.md)
8. [خطا و تاب‌آوری](08-error-resilience/README.md) — [error chain](08-error-resilience/01-errors/README.md)، [panic، defer و recover](08-error-resilience/02-panic-defer-recover/README.md)
9. [Concurrency](09-concurrency/README.md) — [goroutine و channel](09-concurrency/01-goroutines-channels/README.md)، [sync و context](09-concurrency/02-sync-context/README.md)، [worker pool و pipeline](09-concurrency/03-worker-pool-pipeline/README.md)، [race detector](09-concurrency/04-race-detector/README.md)
10. [Testing](10-testing/README.md) — [test و httptest](10-testing/01-testing-httptest/README.md)، [benchmark و coverage](10-testing/02-benchmarks-coverage/README.md)
11. [Standard library](11-standard-library/README.md) — [I/O، JSON، time و ابزارهای استاندارد](11-standard-library/01-stdlib-io-json-time/README.md)
12. [اکوسیستم](12-اکوسیستم/README.md) — [CLI، web، gRPC، database و realtime](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md)
13. [Toolchain، امنیت و deploy](13-toolchain-امنیت/README.md) — [فرمان‌ها، lint، scan و artifact](13-toolchain-امنیت/01-tooling-security-deploy/README.md)
14. [مباحث پیشرفته](14-مباحث-پیشرفته/README.md) — [runtime، reflection، unsafe و cgo](14-مباحث-پیشرفته/01-advanced-runtime/README.md)

## دامنه و نسخه

لینک مقصد درخواست به مسیر /golang بود؛ عنوان نمایشی پیام به /system-design اشاره داشت. این دوره طبق مقصد واقعی، رودمپ Go را مبنا گرفته است. PDF مبنا [Go Developer Roadmap](https://roadmap.sh/pdfs/roadmaps/golang.pdf) است. عنوان‌های رسمی به درس‌های محلی در [نگاشت کامل Roadmap](ROADMAP-MAP.md) وصل شده‌اند؛ چند زیرموضوع نزدیک در یک درس ادغام شده است. نسخهٔ patch در روز بازبینی Go 1.27.4 است؛ directive زبان ماژول Go 1.27 می‌ماند و ویژگی نسخه‌دار کنار موضوعش توضیح داده شده است. تاریخچه و منبع در [Go Release History](https://go.dev/doc/devel/release) ثبت شده.

تمام مفاهیم اصلی این سرفصل، با مثال و تمرین، داخل پوشه درس داده شده‌اند تا مسیر را بدون اتصال دائمی به اینترنت بخوانی. منابع بیرونی برای spec جاری، تغییرهای نسخه و مقالهٔ اصلی case study نگه داشته شده‌اند؛ این دوره جست‌وجوی کامل همهٔ صفحه‌های اینترنت را ادعا نمی‌کند.

## نسخهٔ انگلیسی

[Go Self-Study Course — English Edition](README.en.md)

## ابزارهای مرور

- [نقشهٔ مطالعه](نقشه-مطالعه.md)
- [واژه‌نامهٔ انگلیسی ـ فارسی](واژه‌نامه.md)
- [پروژه‌ها](پروژه‌ها/README.md)
- [نگاشت رودمپ](ROADMAP-MAP.md)
- [منابع و تجربه‌های واقعی](SOURCES-AND-CASES.md)
- [معیار گسترش و ممیزی دوره](COURSE-EXPANSION-PLAN.md)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
