# ۸.۲ — panic، defer و recover

<div dir="rtl">

**زمان پیشنهادی:** ۱۱۰ دقیقه · **پیش‌نیاز:** تابع، خطا و resourceهایی مثل فایل  
**هدف:** cleanup را حتی در مسیر خطا انجام بدهی، panic را از خطای عادی جدا کنی و recover را فقط در مرز مناسب به کار ببری.

## نقشهٔ این درس

- panic در برابر error
- اجرای defer و ترتیب LIFO
- زمان ارزیابی argumentهای defer
- defer با named return
- recover و محدودیت همان goroutine
- مدیریت panic در boundary
- cleanup با file، lock و transaction
- خطاهای رایج و طراحی lifecycle

## ۱) error یا panic؟

Error برای شکست‌هایی است که تابع یا caller به‌طور عادی انتظارشان را دارد: ورودی نامعتبر، فایل پیدا نشد، timeout یا عدم دسترسی به یک رکورد. تابع خطا را return می‌کند تا caller تصمیم بگیرد.

Panic جریان عادی اجرا را قطع می‌کند؛ stack همین goroutine باز می‌شود و deferهای ثبت‌شده اجرا می‌شوند. Panic برای ورودی غلط کاربر یا وضعیت business معمول نیست. آن را برای invariant شکسته یا خطایی به‌کار ببر که ادامهٔ این مسیر امن نیست. panic نامنتظره معمولاً bug یا وضعیت فساد state است و باید در سرویس به signal قابل‌مشاهده تبدیل شود، نه اینکه بی‌صدا پنهان بماند.

## ۲) defer چه زمانی اجرا می‌شود؟

<code>defer</code> فراخوانی یک تابع را برای زمان خروج تابع جاری ثبت می‌کند؛ خروج می‌تواند return عادی یا unwind ناشی از panic باشد. اگر چند defer وجود داشته باشند، آخرین مورد ثبت‌شده زودتر اجرا می‌شود (LIFO).

</div>

~~~go
func readFile(path string) ([]byte, error) {
	file, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	data, err := io.ReadAll(file)
	if err != nil {
		return nil, err
	}
	return data, nil
}
~~~

<div dir="rtl">

پس از open موفق، close را بلافاصله defer می‌کنیم؛ در این صورت مسیر موفق و تمام returnهای بعدی cleanup را انجام می‌دهند. اگر open شکست بخورد، fileای برای بستن نداریم. برای کار واقعی، خطای <code>Close</code> نیز ممکن است مهم باشد، مخصوصاً برای writer و flush نهایی؛ در نمونهٔ ساده نادیده گرفته شده، اما برای نوشتن پایدار باید خطای close/sync را هم در قرارداد نتیجه مدیریت کنی.

## ۳) argumentهای defer زود ارزیابی می‌شوند

خود function call بعداً اجرا می‌شود، ولی argumentهای آن در لحظهٔ ثبت defer ارزیابی می‌شوند.

</div>

~~~go
value := 1
defer fmt.Println(value)
value = 2
~~~

<div dir="rtl">

هنگام خروج چاپ می‌شود <code>1</code>، چون value argument همان موقع کپی شده است. اگر closure را defer کنی، closure هنگام خروج متغیر را می‌خواند و مقدار نهایی را می‌بیند:

</div>

~~~go
value := 1
defer func() {
	fmt.Println(value)
}()
value = 2
~~~

<div dir="rtl">

این نسخه <code>2</code> چاپ می‌کند. این تفاوت برای ثبت زمان، counter، نام فایل و متغیر loop اهمیت دارد. وقتی لازم است مقدار زمان ثبت ثابت بماند، آن را به‌صورت argument پاس بده؛ اگر می‌خواهی مقدار نهایی خوانده شود، closure مناسب است.

## ۴) ترتیب deferها

</div>

~~~go
func steps() {
	defer fmt.Println("اول ثبت شد، آخر اجرا می‌شود")
	defer fmt.Println("دوم ثبت شد، اول اجرا می‌شود")
	fmt.Println("بدنه")
}
~~~

<div dir="rtl">

خروجی: ابتدا <code>بدنه</code>، بعد «دوم ثبت شد»، سپس «اول ثبت شد». این ترتیب برای بازکردن چند resource تو در تو مفید است: resource دوم زودتر بسته می‌شود، مانند unwind کردن پشتهٔ acquisition. defer را در loop طولانی بی‌محابا به‌کار نبر؛ همهٔ callها تا پایان تابع والد منتظر می‌مانند و ممکن است file descriptor زیادی باز بماند. کار loop را در تابع کمکی جدا کن تا defer هر iteration زودتر اجرا شود.

## ۵) defer و named return

قبل از اجرای deferها، مقادیر return در خروجی‌های نام‌دار قرار می‌گیرند؛ defer می‌تواند همان named result را تغییر دهد. این قابلیت در برخی cleanupها useful است، اما می‌تواند خروجی واقعی تابع را پنهان کند.

</div>

~~~go
func example() (result int) {
	defer func() {
		result++
	}()
	return 10
}
~~~

<div dir="rtl">

تابع در پایان ۱۱ برمی‌گرداند. <code>return 10</code> ابتدا named result را می‌سازد و سپس defer اجرا می‌شود. این رفتار برای ثبت خطای بستن resource گاهی مفید است، اما بهتر است تنها وقتی contract را واضح می‌کند به‌کار رود. اگر defer خطا را بی‌صدا جایگزین کند یا success را عوض کند، caller را غافلگیر می‌کند.

## ۶) panic و unwind

نمونهٔ آموزشی:

</div>

~~~go
func mustPositive(value int) {
	if value <= 0 {
		panic("value باید مثبت باشد")
	}
}
~~~

<div dir="rtl">

این شکل برای نشان‌دادن panic است، نه validation یک API عمومی. برای ورودی کاربر بنویس:

</div>

~~~go
func positive(value int) (int, error) {
	if value <= 0 {
		return 0, fmt.Errorf("value باید مثبت باشد: %d", value)
	}
	return value, nil
}
~~~

<div dir="rtl">

Panic از همان goroutine بالا می‌آید. deferهای همان goroutine به‌ترتیب LIFO اجرا می‌شوند. اگر هیچ defer آن را recover نکند، برنامه terminate می‌شود. panic در goroutine جداگانه با recover موجود در goroutine والد گرفته نمی‌شود؛ هر goroutine باید boundary و مسیر گزارش خودش را داشته باشد.

## ۷) recover فقط برای boundary کنترل‌شده است

<code>recover</code> panic جاری را متوقف می‌کند وقتی از deferred function مناسب همان goroutine فراخوانی شود. اگر panic جاری نباشد، nil می‌دهد. فراخوانی معمولی <code>recover()</code> وسط تابع panic را نمی‌گیرد. recover را به‌کار ببر تا مرز کار مستقل (مثلاً یک request handler) از سقوط کل process جلوگیری کند، اما خطا را ثبت و پاسخ ناموفق واضح بده؛ panic را به نتیجهٔ موفق تبدیل نکن.

</div>

~~~go
func safeHandler(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			if value := recover(); value != nil {
				log.Printf("panic handling request: %v", value)
				http.Error(w, "خطای داخلی سرور", http.StatusInternalServerError)
			}
		}()
		next.ServeHTTP(w, r)
	})
}
~~~

<div dir="rtl">

این مثال فقط نشان‌دهندهٔ الگوی مرزی است. برای middleware production، stack trace و request/trace ID را امن ثبت کن، از نشت دادهٔ حساس جلوگیری کن و بررسی کن response قبلاً شروع شده است یا نه. HTTP response ممکن است پیش از panic بخشی از body را نوشته باشد و دیگر نتوانی status جدید بفرستی.

Recover را داخل هر helper قرار نده؛ اگر همه‌جا recover کنی، نشانهٔ خرابی و stack trace گم می‌شود. مرز واحدی داشته باش که panic را به incident/error گزارش تبدیل کند. بعد از recover، سیستم باید بدانند operation شکست خورده، metric/alert مناسب داشته باشد و state نیمه‌نوشته را ادامه ندهد.

## ۸) defer برای lock و transaction

پس از گرفتن mutex، <code>defer mu.Unlock()</code> cleanup را در returnهای متعدد تضمین می‌کند. اما defer قفل را تا خروج کل تابع نگه می‌دارد؛ اگر scope طولانی است، بخش critical را در تابع کوچک‌تری بگذار. برای database transaction، defer rollback را پس از begin ثبت کن و پس از commit موفق، طبق API transaction رفتار کن. خطای commit را بررسی کن؛ rollback best effort نباید خطای اصلی را پنهان کند.

## خطاهای رایج

- استفاده از panic برای ورودی نادرست یا «پیدا نشد».
- انتظار اینکه recover در goroutine دیگر panic را بگیرد.
- ثبت defer با argument متغیری که تصور می‌شود هنگام خروج خوانده می‌شود.
- defer کردن close در loop بزرگ و نگه‌داشتن resourceها تا پایان تابع.
- swallow کردن panic بدون stack، log یا failed result.
- گرفتن panic در هر تابع و مخفی‌کردن bug.
- فرض اینکه recover کردن درخواست، state نیمه‌کاره را rollback می‌کند.
- نادیده‌گرفتن خطای Close، Sync یا Commit.
- نگه‌داشتن lock بیش از لازم به دلیل defer در تابع طولانی.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: cleanup

فایلی را باز کن، پس از بررسی خطا close را defer کن و داده را بخوان.

**پاسخ:** نمونهٔ بخش ۲. برای production، خطای close را نیز بسته به اینکه read/write است و قرارداد API باید گزارش شود، بررسی کن.

### تمرین ۲: ترتیب defer

سه defer چاپی ثبت کن و ترتیب اجرا را پیش‌بینی کن.

**پاسخ:** آخرین defer اول اجرا می‌شود. برای release resourceها این معمولاً ترتیب درست است.

### تمرین ۳: loop و file

هزار فایل را در loop باز می‌کنی و داخل loop defer close گذاشتی. چه ایرادی هست و چه تغییری می‌دهی؟

**پاسخ:** fileها تا خروج تابع والد باز می‌مانند؛ تعداد زیادی file descriptor مصرف می‌شود. پردازش هر فایل را به تابع کمکی منتقل کن تا defer در پایان همان iteration اجرا شود.

### تمرین ۴: panic boundary

در request handler panic رخ می‌دهد. آیا recover کافی است؟

**پاسخ:** خیر. باید در همان goroutine boundary باشد، stack و request ID ثبت شود، پاسخ failure امن داده شود، metric/alert ثبت شود و اطمینان یابد عملیات نیمه‌تمام به‌عنوان موفق تلقی نشده است.

### تمرین ۵: خطای cleanup

تابع هم در نوشتن داده و هم در Close خطا دارد. کدام را برمی‌گردانی؟

**پاسخ:** به قرارداد وابسته است؛ خطای اصلی نوشتن معمولاً حفظ می‌شود، ولی failure در flush/close هم ممکن است از دست‌رفتن داده باشد و باید به‌نحو ساخت‌یافته گزارش شود؛ می‌توان errorها را با <code>errors.Join</code> ترکیب کرد. خطا را بی‌صدا دور نریز.

## کوییز

### پرسش‌ها

1. defer چه چیزی را ثبت می‌کند؟
2. چند defer با چه ترتیبی اجرا می‌شوند؟
3. argumentهای تابع defer چه زمانی ارزیابی می‌شوند؟
4. defer closure چه تفاوتی با defer یک تابع معمول دارد؟
5. defer در کدام مسیرها اجرا می‌شود؟
6. deferهای تابع بیرونی چه زمانی در loop اجرا می‌شوند؟
7. defer می‌تواند named return را تغییر دهد؟
8. panic در کدام محدوده اجرا/بالا می‌رود؟
9. recover از کجا باید فراخوانی شود؟
10. آیا recover در goroutine parent، panic child را می‌گیرد؟
11. برای چه خطاهایی panic مناسب نیست؟
12. چرا recovery باید در boundary باشد؟
13. آیا recovery state تغییر‌یافته را خودکار rollback می‌کند؟
14. چرا خطای Close ممکن است اهمیت داشته باشد؟
15. lock طولانی همراه defer چه ریسکی دارد؟
16. چرا هر iteration را در helper جدا می‌بریم؟

### کلید پاسخ

1. function callی برای اجرا هنگام خروج تابع فعلی.
2. LIFO؛ آخرین ثبت‌شده اول اجرا می‌شود.
3. هنگام اجرای دستور defer.
4. argument عادی همان لحظه کپی می‌شود؛ closure می‌تواند متغیر را هنگام اجرا بخواند.
5. return عادی و unwind ناشی از panic.
6. در پایان تابعی که defer در آن ثبت شده، نه در پایان iteration.
7. بله؛ پس از آماده‌شدن مقدار named return، defer می‌تواند آن را تغییر دهد.
8. در همان goroutine؛ deferهای همان goroutine unwind می‌شوند.
9. در deferred function مناسب حین panic جاری.
10. خیر.
11. شکست‌های موردانتظار مثل ورودی نامعتبر، timeout یا resource یافت‌نشده.
12. تا خرابی گزارش شود و محدودهٔ شکست کنترل بماند، نه اینکه همهٔ bugها مخفی شوند.
13. خیر؛ rollback و transaction باید جداگانه طراحی شوند.
14. نوشتن buffer یا flush نهایی ممکن است در close شکست بخورد.
15. رقابت، latency و بن‌بست احتمالی؛ critical section را کوتاه کن.
16. تا cleanup هر iteration به‌موقع انجام شود و resourceها انباشته نشوند.

## منابع

- انگلیسی: [A Tour of Go — defer, panic and recover](https://go.dev/tour/flowcontrol/12)
- انگلیسی: [Effective Go — Defer](https://go.dev/doc/effective_go#defer)
- انگلیسی: [Go specification — Handling panics](https://go.dev/ref/spec#Handling_panics)
- انگلیسی: [Go blog — Defer, Panic, and Recover](https://go.dev/blog/defer-panic-and-recover)
- فارسی: [GoFarsi — error و panic](https://cloud-book.gofarsi.ir/chapter-3/)
- فارسی: [GoFarsi — کتاب Go](https://book.gofarsi.ir/chapter-3/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
