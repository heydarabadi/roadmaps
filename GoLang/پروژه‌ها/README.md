# پروژه‌های مرحله‌ای Go

<div dir="rtl">

سه پروژه را به ترتیب انجام بده: ابزار محلی، API، سپس برنامهٔ هم‌زمانی. هر راهنما مسئله، نیازمندی، ساختار، milestone، تست، خطرها و خودارزیابی را دارد.

| ترتیب | پروژه | مهارت اصلی |
|---|---|---|
| ۱ | [مدیریت کارها در CLI](01-task-tracker-cli/README.md) | تابع، struct، JSON، فایل، error، test |
| ۲ | [API کاتالوگ HTTP](02-catalog-http-api/README.md) | net/http، interface، context، httptest، امنیت |
| ۳ | [بررسی هم‌زمان URLها](03-concurrent-url-checker/README.md) | goroutine، channel، worker pool، cancellation، race، benchmark |

## روش انجام

1. ابتدا قرارداد ورودی/خروجی را با زبان خودت بنویس.
2. هر milestone را جدا کامل کن و رفتار قبلی را با test تثبیت کن.
3. ابتدا hint را بخوان؛ سپس کد را خودت بساز.
4. در پایان trade-offها را در README ثبت و با rubric ارزیابی کن.

rubric هر معیار را از صفر تا دو امتیاز بده: صفر یعنی غایب یا نادرست، یک یعنی کارا اما ناقص، دو یعنی رفتار روشن و testپذیر. معیارها: قرارداد، validation و error، جداسازی I/O از منطق، پوشش شکست‌ها، lifecycle/resource bounds، مستندات و تصمیم‌های صریح. امتیاز یک سنجهٔ رسمی کیفیت نیست؛ برای خودبازبینی است.

## درس‌های لازم

- پروژهٔ ۱: [تابع‌ها](../04-کنترل-و-توابع/02-functions-closures/README.md)، [array و slice](../03-ساختار-داده/01-arrays-slices/README.md)، [map](../03-ساختار-داده/03-maps-comma-ok/README.md)، [error](../08-error-resilience/01-errors/README.md)، [I/O و JSON](../11-standard-library/01-stdlib-io-json-time/README.md).
- پروژهٔ ۲: [method و interface](../06-متد-interface-generics/01-methods-interfaces/README.md)، [module](../07-packages-modules/01-packages-modules/README.md)، [اکوسیستم HTTP](../12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md)، [httptest](../10-testing/01-testing-httptest/README.md).
- پروژهٔ ۳: [goroutine و channel](../09-concurrency/01-goroutines-channels/README.md)، [sync و context](../09-concurrency/02-sync-context/README.md)، [worker pool](../09-concurrency/03-worker-pool-pipeline/README.md)، [race detector](../09-concurrency/04-race-detector/README.md)، [benchmark](../10-testing/02-benchmarks-coverage/README.md).

## بازبینی نهایی

اگر ورودی ده برابر شد چه چیزی می‌شکند؟ اگر dependency دیر جواب داد چه resource باقی می‌ماند؟ اگر process وسط write قطع شود چه داده‌ای خراب می‌شود؟ اگر token وارد log شود چه کسی می‌بیند؟ چه اندازه‌گیری‌ای optimization را ثابت می‌کند؟ جواب‌های روشن را در README پروژه نگه دار.



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
