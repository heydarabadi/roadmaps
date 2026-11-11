# ۱۰.۲ — benchmark، coverage و fuzz test

<div dir="rtl">

**زمان پیشنهادی:** ۱۵۰ دقیقه · **پیش‌نیاز:** تست، function، string و ابزارهای Go  
**هدف:** عملکرد را به‌جای حدس اندازه بگیری، coverage را درست تفسیر کنی و ورودی‌های غیرمنتظره را با fuzzing پیدا کنی.

## نقشهٔ این درس

- benchmark استاندارد Go
- تفسیر ns/op، B/op و allocs/op
- benchmark منصفانه و قابل‌تکرار
- مقایسه و profile
- coverage و محدودیت آن
- fuzz test و property
- seed corpus و reproduction
- زمان مناسب fuzzing
- جلوگیری از micro-optimization بی‌دلیل

## ۱) benchmark چه پرسشی را جواب می‌دهد؟

Benchmark اندازه می‌گیرد یک عملیات در محیط فعلی معمولاً چقدر زمان یا حافظه مصرف می‌کند. این پاسخ به CPU، نسخهٔ Go، build flags، load و شکل داده وابسته است. benchmark حکم عمومی برای همهٔ ماشین‌ها نیست؛ دو نسخه را در شرایط مشابه مقایسه کن.

تابع benchmark با پیشوند <code>Benchmark</code> و آرگومان <code>*testing.B</code> تعریف می‌شود. framework تعداد تکرار را در <code>b.N</code> تنظیم می‌کند تا اندازه‌گیری پایدارتر شود.

~~~go
func BenchmarkNormalizeSpace(b *testing.B) {
	input := "  Go   makes concurrent programs easier to structure  "
	b.ReportAllocs()

	for i := 0; i < b.N; i++ {
		_ = NormalizeSpace(input)
	}
}
~~~

</div>
<div dir="rtl">

اجرا:

</div>

~~~powershell
go test -run '^$' -bench BenchmarkNormalizeSpace -benchmem ./...
~~~

<div dir="rtl">

خروجی ممکن است زمان هر عملیات (ns/op)، بایت allocation به‌ازای عملیات (B/op) و تعداد allocationها (allocs/op) را گزارش کند. <code>b.ReportAllocs()</code> یا flag <code>-benchmem</code> allocation را نشان می‌دهد. یک عدد را به تنهایی به نتیجه تبدیل نکن؛ چند بار اجرا، ماشین یکسان، دادهٔ یکسان و baseline ثبت‌شده لازم‌اند.

## ۲) benchmark را منصفانه بنویس

- setup سنگین و ثابت را بیرون loop انجام بده.
- اگر setup باید در زمان اندازه‌گیری حساب نشود، پس از آن <code>b.ResetTimer()</code> صدا بزن.
- نتیجه را طوری مصرف کن که compiler کل محاسبه را حذف نکند.
- ورودی representative انتخاب کن، نه فقط کوچک‌ترین داده.
- برای parallel workload benchmark جدا با <code>b.RunParallel</code> بنویس و contention واقعی را بسنج.
- چند بار اجرا و با ابزار مقایسهٔ معتبر مانند <code>benchstat</code> نتیجه را مقایسه کن.
- benchmark را به absolute threshold شکننده در CI تبدیل نکن مگر محیط بسیار کنترل‌شده باشد.

Benchmark یک تابع با دادهٔ خاص را می‌سنجد؛ اگر production bottleneck در network/database است، benchmark parser داخل RAM کل latency سیستم را توضیح نمی‌دهد.

## ۳) profile برای پیدا کردن محل هزینه

وقتی benchmark کند است، حدس نزن. CPU profile می‌گوید زمان صرف چه stackهایی شده؛ memory profile allocationها و retention را روشن می‌کند. می‌توانی از flagهای test مانند <code>-cpuprofile</code> و <code>-memprofile</code> خروجی بگیری و با <code>go tool pprof</code> بررسی کنی. روی برنامهٔ واقعی، pprof endpoint را امن و محدود کن؛ profile ممکن است ساختار و دادهٔ حساس را نشان دهد.

Performance engineering چرخه است:

1. baseline و workload را ثبت کن.
2. profile بگیر.
3. یک گلوگاه قابل‌اندازه‌گیری را انتخاب کن.
4. کوچک‌ترین تغییر را انجام بده.
5. نتیجه و تخصیص را در شرایط مشابه بسنج.
6. correctness و حافظه را هم بررسی کن.

## ۴) Coverage: کدام بخش اجرا شد؟

Coverage درصد statementهای source است که تست در اجرای ثبت‌شده پوشانده است. فرمان‌های رایج:

</div>

~~~powershell
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -func=coverage.out
go tool cover -html=coverage.out
~~~

<div dir="rtl">

Coverage بالا تضمین نمی‌کند تست assertion معنادار دارد، ورودی مرزی را پوشش می‌دهد یا خطا را درست مدیریت می‌کند. ۱۰۰٪ coverage ممکن است همهٔ statementها را اجرا کند ولی هیچ invariantی را بررسی نکند. از درصد به‌عنوان signal برای یافتن بخش تست‌نشده استفاده کن، نه هدفی مستقل برای جایزه‌دادن یا مقایسهٔ تیم‌ها.

Packageهایی با تولید کد، platform-specific build tag یا integration dependency می‌توانند coverage report متفاوت داشته باشند. command و flag را مطابق نسخهٔ Go و ساختار پروژه بررسی کن.

## ۵) fuzz testing چیست؟

Fuzz test تابعی است که test engine ورودی‌های متنوع تولید می‌کند تا panic، crash یا نقض property را پیدا کند. در Go fuzzing در testing package از Go 1.18 در دسترس است. تابع با <code>Fuzz</code> شروع می‌شود، <code>*testing.F</code> می‌گیرد و با <code>f.Fuzz</code> callback را اجرا می‌کند. مقدارهای seed حالت‌های مهم و ورودی‌های پایه را مشخص می‌کنند.

~~~go
func FuzzParsePort(f *testing.F) {
	f.Add("8080")
	f.Add("")
	f.Add("65536")
	f.Add("999999999999999999999")

	f.Fuzz(func(t *testing.T, input string) {
		port, err := parsePort(input)
		if err == nil && (port < 1 || port > 65535) {
			t.Fatalf("parsePort(%q) = %d without error", input, port)
		}
	})
}
~~~

</div>
<div dir="rtl">

Property این fuzz test این است: هر ورودی‌ای که با موفقیت پذیرفته شد باید در محدودهٔ پورت بماند. خود parser هم باید رفتار قراردادی برای تمام رشته‌ها داشته باشد و نباید panic کند. ورودی fuzz از دادهٔ بیرونی می‌آید؛ parser امن باید malformed و طولانی را مدیریت کند.

برای اجرای fuzz:

~~~powershell
go test -fuzz=FuzzParsePort -fuzztime=30s ./...
~~~

</div>
<div dir="rtl">

هنگام پیدا شدن failure، Go تلاش می‌کند ورودی کوچک‌تر reproducible بسازد و آن را در corpus تست نگه دارد. آن ورودی را به‌عنوان regression test حفظ کن. مدت fuzz فقط سقف همین اجرا است؛ اجرای ۳۰ ثانیه‌ای نبود bug را ثابت نمی‌کند.

## ۶) property خوب تعریف کن

Fuzzing بدون property assertion صرفاً ورودی‌های زیادی اجرا می‌کند. propertyهای مفید:

- parser هرگز panic نکند.
- encode ثم decode مقدار قابل‌بازسازی بدهد.
- normalize دوبار اجرا نتیجه را عوض نکند.
- خروجی مرتب‌سازی واقعاً مرتب و permutation ورودی باشد.
- اگر parser موفق شد، invariant محدوده و format برقرار بماند.
- byte processor با ورودی هر اندازه memory/index را درست نگه دارد.

Property باید قابل‌اثبات برای همهٔ inputهای معتبر باشد؛ برای ورودی invalid هم قرارداد را بنویس. برای زمان، randomness یا network در fuzz target از side effect بیرونی پرهیز کن تا نتیجه deterministic و سریع باشد.

## ۷) تجربهٔ عملی performance

تیم backend معمولاً فقط زمان تابع را نمی‌بیند: allocation زیاد ممکن است GC را بیشتر فعال کند؛ queue و serialization ممکن است latency tail را بالا ببرند؛ benchmark محلی ممکن است connection pool production را نشان ندهد. بنابراین یک بهینه‌سازی واقعی باید هدف قابل‌اندازه‌گیری داشته باشد (مثلاً P95 latency یا allocation/request)، profile متناسب بگیرد و اثر روی correctness و مصرف منابع را بسنجد. این روش تجربهٔ عمومی مهندسی است، نه ادعای یک case study خاص.

## خطاهای رایج

- benchmark کردن setup ثابت داخل loop.
- مقایسهٔ اعداد از ماشین‌ها یا نسخه‌های متفاوت.
- نتیجه‌گیری از یک بار benchmark.
- بهینه‌سازی براساس حدس، بدون profile.
- استفاده از coverage درصدی به‌عنوان تضمین کیفیت.
- fuzz target بدون assertion/property.
- fuzz testی که به اینترنت یا زمان واقعی وابسته است.
- حذف regression seed پس از رفع bug.
- قراردادن absolute timing threshold ناپایدار در CI.
- نادیده‌گرفتن allocation در تابع پرتکرار.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: benchmark parser

برای <code>parsePort</code> ورودی معتبر و نامعتبر جدا benchmark کن. پاسخ: benchmarkهای نام‌دار با ورودی ثابت و representative بساز؛ در صورت نیاز <code>b.ReportAllocs()</code> اجرا کن. هر دو مسیر را جدا تحلیل کن.

### تمرین ۲: property برای normalize

خاصیتی بنویس که اجرای <code>NormalizeSpace</code> روی خروجی خودش نتیجه را تغییر ندهد.

~~~go
f.Fuzz(func(t *testing.T, input string) {
	once := NormalizeSpace(input)
	twice := NormalizeSpace(once)
	if once != twice {
		t.Fatalf("not idempotent: once=%q twice=%q", once, twice)
	}
})
~~~

### تمرین ۳: coverage را تفسیر کن

Package به ۹۸٪ coverage رسیده ولی هیچ testی error را assert نمی‌کند. پاسخ: coverage زیاد است ولی contract failure تست نشده؛ testهایی اضافه کن که error type/identity و side effect را بررسی کنند.

### تمرین ۴: profile first

یک optimization سریع‌تر به نظر می‌رسد ولی CPU profile می‌گوید بخش بسیار کمی از کل زمان را مصرف می‌کند. پاسخ: اگر بهینه‌سازی ریسک و complexity دارد، احتمالاً اولویت پایین است؛ گلوگاه واقعی را پیدا کن و end-to-end اثر را اندازه بگیر.

## کوییز

### پرسش‌ها

1. benchmark در Go با چه prefixی نام‌گذاری می‌شود؟
2. <code>b.N</code> چه کاربردی دارد؟
3. <code>-benchmem</code> چه اطلاعاتی می‌دهد؟
4. چرا setup را از loop benchmark بیرون می‌آوریم؟
5. benchmark یک ماشین چه تعمیمی به ماشین دیگر دارد؟
6. profile چه کمکی می‌کند؟
7. Coverage چه چیزی را اندازه می‌گیرد؟
8. چرا coverage بالا کیفیت assertion را ثابت نمی‌کند؟
9. fuzz testing از کدام نسخهٔ Go در testing package موجود است؟
10. seed corpus چه نقشی دارد؟
11. fuzz target باید چه چیزی را بررسی کند؟
12. fuzz failure را چرا به regression تبدیل می‌کنیم؟
13. fuzztime 30s چه چیزی را تضمین نمی‌کند؟
14. چرا target نباید به اینترنت وابسته باشد؟
15. benchstat چه کمکی می‌تواند بکند؟
16. چرا absolute performance threshold در CI شکننده است؟
17. برای مشاهدهٔ allocation چه روش ساده‌ای هست؟
18. property برای NormalizeSpace چه نمونه‌ای دارد؟

### کلید پاسخ

1. <code>Benchmark</code>.
2. شمار تکرار عملیاتی که framework تنظیم می‌کند.
3. byte و تعداد allocation به‌ازای operation.
4. تا هزینهٔ initialization ثابت در زمان خود عملیات حساب نشود.
5. فقط روند محدود و مشروط؛ hardware/runtime/load متفاوت است.
6. stackهای زمان مصرف‌شده و هزینهٔ memory را نشان می‌دهد تا محل بهینه‌سازی معلوم شود.
7. statementهای اجراشده در test run.
8. ممکن است خط اجرا شود ولی نتیجه assert نشود.
9. Go 1.18.
10. نمونه‌های پایه برای شروع fuzz و regression.
11. property یا invariant نتیجه، و عدم panic برای ورودی‌ها.
12. تا bug دوباره ظاهر نشود و ورودی مشخص در test suite بماند.
13. نبود باگ.
14. کندی، عدم تکرارپذیری و وابستگی خارجی وارد تست نشود.
15. مقایسهٔ آماری چند اجرای benchmark.
16. CI load و سخت‌افزار ممکن است نوسان کند.
17. <code>-benchmem</code> یا <code>b.ReportAllocs()</code>.
18. normalize یک‌بار و دوبار باید خروجی یکسان بدهد.

## منابع

- انگلیسی: [Go documentation — Diagnostics (benchmarks and profiling)](https://go.dev/doc/diagnostics)
- انگلیسی: [Go package testing — benchmarks and fuzzing](https://pkg.go.dev/testing)
- انگلیسی: [Go tutorial — Fuzz tests](https://go.dev/doc/tutorial/fuzz)
- انگلیسی: [Go Security — Fuzzing](https://go.dev/doc/security/fuzz/)
- فارسی: [GoFarsi — testing و ابزارها](https://cloud-book.gofarsi.ir/chapter-3/)
- فارسی: [مجموعه آموزش Go](https://book.gofarsi.ir/chapter-3/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
