# پروژهٔ ۳ — URL checker هم‌زمان و محدود

<div dir="rtl">

## مسئله

CLIای بساز که برای هر URL status code، زمان پاسخ و خطا را گزارش کند. حداکثر N request هم‌زمان، timeout روشن، پشتیبانی از Ctrl+C و ترتیب خروجی مطابق ورودی لازم است.

اگر فقط URLهایی را بررسی می‌کند که کاربر به CLI می‌دهد، ریسک با سرویس عمومی فرق دارد. اگر API بسازی که caller دلخواه URL می‌دهد، SSRF جدی می‌شود: loopback، شبکهٔ خصوصی، link-local، metadata service، redirect به مقصد ممنوع و DNS rebinding را بررسی کن. بررسی رشته به‌تنهایی کافی نیست.

## مدل و قرارداد

~~~go
type Result struct {
    Index      int
    URL        string
    StatusCode int
    Duration   time.Duration
    Err        error
}
~~~

هر ورودی دقیقاً یک نتیجه داشته باشد، حتی URL نامعتبر یا timeoutشده. duplicateها را طبق قرارداد نگه دار یا حذف کن. پاسخ HTTP 404/500 با DNS/connection error فرق دارد.

## نقشهٔ جریان

~~~text
input lines -> bounded jobs -> N workers -> result channel -> ordered collector
~~~

collector تنها مالک آرایهٔ خروجی باشد. worker نتیجه را همراه Index می‌فرستد؛ آرایهٔ مشترک را مستقیم تغییر نمی‌دهد. channel نیازمند ownership و close دقیق است.

## milestone ۱: نسخهٔ ترتیبی

URL را parse و فقط http/https قبول کن. client و timeout بساز، response body را ببند، زمان را با time.Since اندازه بگیر، نتیجه را به ترتیب ورودی چاپ کن. تعداد URL و اندازهٔ فایل را محدود کن.

اگر فقط status می‌خواهی HEAD کم‌هزینه‌تر است، اما همهٔ serverها پشتیبانی نمی‌کنند؛ fallback به GET را تعریف و body را محدود/ببند.

**پذیرش:** URL بدفرمت، DNS failure، connection refused، timeout، 404 و 200 مشخص باشند.

## milestone ۲: worker pool

- worker count مثبت و دارای سقف باشد.
- producer job را با context-aware send بفرستد.
- workerها از jobs بخوانند تا channel بسته یا cancellation رخ دهد.
- coordinator پس از پایان همهٔ workerهای sender، results را ببندد.
- collector نتیجه را در slot متناظر بگذارد.
- buffer را با دلیل انتخاب کن؛ بزرگ‌کردنش backpressure را حذف نمی‌کند.

کسی که پایان senderها را هماهنگ می‌کند channel را می‌بندد. چند goroutine نباید یک channel را ببندند.

## milestone ۳: cancellation

1. signal.NotifyContext برای Ctrl+C.
2. root context به producer، worker و هر HTTP request برسد.
3. timeout request علاوه بر cancellation کلی برقرار باشد.
4. cancellation کار جدید را متوقف کند.
5. نتایج کامل حفظ شوند؛ ورودی‌های شروع‌نشده canceled/not-started باشند.
6. main تا پایان goroutineهای خودش صبر کند.

سیاست قابل‌قبول: توقف فوری یا shutdown کوتاه برای دریافت نتیجهٔ جاری. رفتار و exit code را مستند کن.

## milestone ۴: تست هم‌زمانی

به‌جای sleep تصادفی از httptest.Server با channel gate و شمارندهٔ atomic استفاده کن. requestها را gate کن، بیشترین active count را اندازه بگیر و سپس آزاد کن. timeout تست فقط guard نهایی باشد.

Test کن: concurrency از worker count بیشتر نشود؛ ترتیب output حفظ شود؛ URL invalid نتیجه داشته باشد؛ cancellation goroutine را جمع کند؛ 404 status بماند؛ redirect policy روشن باشد. go test -race فقط interleavingهای اجراشده را بررسی می‌کند.

## milestone ۵: اندازه‌گیری

benchmark parser یا collector خالص بنویس. network را با server محلی و client جدا اندازه بگیر و version/hardware/workload را ثبت کن. benchmem allocation را می‌دهد. profile را فقط برای bottleneck مشخص بگیر. concurrency بیشتر ممکن است throughput را کم یا remote server را overload کند.

## failure modeها

- results را زود می‌بندی درحالی‌که worker هنوز send می‌کند.
- channel را نمی‌بندی و collector منتظر می‌ماند.
- WaitGroup را بعد از شروع workerها Add می‌کنی.
- workerها slice مشترک را تغییر می‌دهند.
- defer body.Close داخل loop بزرگ می‌گذاری و bodyها تا پایان function باز می‌مانند.
- cancellation به main رسیده اما HTTP request context ندارد.
- URL دارای userinfo یا token را کامل log می‌کنی.
- worker نامحدود remote و socketها را زیر فشار می‌برد.

## coordinator کوچک

~~~go
go func() {
    workerGroup.Wait()
    close(results)
}()

for result := range results {
    ordered[result.Index] = result
}
~~~

این fragment فقط پایان workerها و بستن result channel را نشان می‌دهد؛ producer، بستن jobs، cancellation و انتظار collector نیز لازم‌اند.

## تجربهٔ واقعی

مطالعهٔ Uber دربارهٔ raceهای Go detector را در codebase بزرگ و microserviceهای آن بررسی می‌کند. اعداد مقاله فقط مربوط به همان محیط و بازه‌اند و نتیجهٔ مشابه را برای همه تضمین نمی‌کنند. درس عملی: detector را کنار طراحی ownership/cancellation و workload test به کار ببر. لینک در [منابع و تجربه‌ها](../../SOURCES-AND-CASES.md) است.

## تمرین با پاسخ

**چرا result با index ذخیره می‌شود؟** زمان پایان مستقل است؛ index ترتیب ورودی را بازسازی می‌کند.  
**چرا main channel را نبندد؟** worker ممکن است هنوز send کند؛ coordinator پس از پایان senderها می‌بندد.  
**چرا 500 transport error نیست؟** response از server رسیده؛ DNS error پیش از HTTP شکست خورده.  
**چرا worker count برابر همهٔ ورودی‌ها نیست؟** concurrency بی‌سقف، remote و socket را تحت فشار می‌گذارد.

## کوییز

### پرسش‌ها

1. چرا اول نسخهٔ ترتیبی را می‌سازیم؟
2. ورودی parseنشده باید result داشته باشد؟
3. چرا 404 transport error نیست؟
4. چه کسی result channel را می‌بندد؟
5. چرا چند sender channel واحد را نبندند؟
6. worker pool چه resourceهایی را محدود می‌کند؟
7. buffer بزرگ backpressure را حذف می‌کند؟
8. ترتیب ورودی چگونه حفظ می‌شود؟
9. چرا request باید context داشته باشد؟
10. چرا response body را می‌بندیم؟
11. timeout request با root cancellation چه فرق دارد؟
12. race detector همهٔ raceها را تضمین می‌کند؟
13. چه synchronizationای از sleep بهتر است؟
14. URL دلخواه از API چه ریسک دارد؟
15. چرا redirect policy لازم است؟
16. چرا URL credentials را log نمی‌کنیم؟

### کلید پاسخ

1. baseline ساده و درست پیش از concurrency.
2. بله؛ Result با خطای parse.
3. چون response HTTP واقعی گرفته شده.
4. coordinatorی که از پایان همهٔ senderها خبر دارد.
5. send به closed channel panic می‌کند؛ مالکیت close یگانه باشد.
6. request هم‌زمان، socket و فشار dependency.
7. خیر؛ فقط ظرفیت انتظار را عوض می‌کند.
8. result در slot متناظر Index می‌رود.
9. cancellation و deadline به transport برسد.
10. connection و resource آزاد شود.
11. timeout سقف زمان عملیات است؛ cancellation سیگنال توقف lifecycle مشترک.
12. خیر؛ فقط interleavingهای اجراشده را می‌بیند.
13. channel gate، WaitGroup یا ابزار مناسب؛ timeout فقط guard نهایی.
14. SSRF به شبکه داخلی، loopback یا metadata.
15. مقصد امن می‌تواند به host ناامن redirect شود.
16. userinfo/query ممکن است credential یا token داشته باشد.

## معیار پایان

worker bound، cancellation، channel ownership، ترتیب، تست concurrency و SSRF مستند باشند. برای مرور همهٔ درس‌ها، [نقشهٔ مطالعه](../../نقشه-مطالعه.md) را انجام بده.



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
