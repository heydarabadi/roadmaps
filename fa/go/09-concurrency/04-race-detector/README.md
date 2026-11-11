# ۹.۴ — data race و race detector

<div dir="rtl">

**زمان پیشنهادی:** ۱۴۰ دقیقه · **پیش‌نیاز:** goroutine، memory model، mutex و channel  
**هدف:** race را از خطای منطقی جدا کنی، دسترسی مشترک را تحت synchronization قرار دهی و race detector را درست تفسیر کنی.

## نقشهٔ این درس

- تعریف data race
- happens-before و visibility
- نمونهٔ race روی counter و map
- حل با mutex، channel و atomic
- اجرای race detector
- محدودیت کشف پویا
- بررسی stack trace
- تجربهٔ مستند صنعتی
- جلوگیری از race با ownership

## ۱) تعریف data race

Data race زمانی رخ می‌دهد که دو goroutine هم‌زمان به یک محل حافظه دسترسی دارند، دست‌کم یکی دسترسی نوشتن است و آن دسترسی‌ها با سازوکار synchronization رابطهٔ ترتیب‌دهنده ندارند. این صرفاً «دو عدد نتیجهٔ نامنتظر» نیست؛ رفتار برنامه دربارهٔ آن داده قابل‌اعتماد نیست.

نمونهٔ race:

</div>

~~~go
var counter int
var wg sync.WaitGroup

for i := 0; i < 2; i++ {
	wg.Add(1)
	go func() {
		defer wg.Done()
		for j := 0; j < 1000; j++ {
			counter++ // read-modify-write غیراتمی
		}
	}()
}
wg.Wait()
fmt.Println(counter)
~~~

<div dir="rtl">

عملگر <code>counter++</code> یک read و یک write است، نه یک operation اتمی. هر دو goroutine می‌توانند مقدار یکسان بخوانند و یکی از incrementها از دست برود. حتی اگر یک اجرای آزمایشی عدد مورد انتظار را چاپ کند، race همچنان وجود دارد. nondeterminism و race را از خروجی یک بار اجرا نمی‌توان رد کرد.

## ۲) happens-before و visibility

Synchronization مشخص می‌کند چه تغییراتی را goroutine دیگر می‌تواند ببیند و کدام دسترسی‌ها ترتیب دارند. Lock/unlock متناظر، channel send/receive و atomic operationهای درست از ابزارهای سازگارند. صرف اینکه یک goroutine «احتمالاً زودتر اجرا می‌شود» یا scheduler معمولاً ترتیب خاصی می‌دهد، ضمانت حافظه نیست.

تغییر داده را با همگام‌ساز واقعی محافظت کن. sleep یا delay راه‌حل race نیست؛ فقط زمان‌بندی اجرای خراب را تغییر می‌دهد. متغیری که از چند goroutine قابل‌دسترسی است باید ownership، lock یا atomic policy روشن داشته باشد.

## ۳) راه‌حل با mutex

</div>

~~~go
var (
	counter int
	mu      sync.Mutex
	wg      sync.WaitGroup
)

for i := 0; i < 2; i++ {
	wg.Add(1)
	go func() {
		defer wg.Done()
		for j := 0; j < 1000; j++ {
			mu.Lock()
			counter++
			mu.Unlock()
		}
	}()
}
wg.Wait()
fmt.Println(counter)
~~~

<div dir="rtl">

lock تمام read-modify-write را در یک بخش انحصاری نگه می‌دارد. در کد واقعی برای جلوگیری از unlock جاافتاده، معمولاً critical section را در تابع کوتاه می‌گذاری و <code>defer mu.Unlock()</code> می‌نویسی. این نمونه lock را در هر iteration آزاد می‌کند تا رقابت روی آن بخش محدود باشد.

## ۴) راه‌حل با atomic یا channel

Counter مستقل و ساده می‌تواند از <code>sync/atomic</code> استفاده کند:

</div>

~~~go
var counter atomic.Int64
counter.Add(1)
value := counter.Load()
~~~

<div dir="rtl">

Atomic برای read-modify-write یک متغیر هم‌تراز و تعریف‌شده مناسب است. اگر چند فیلد باید سازگار و با هم تغییر کنند، atomic جدا برای هر فیلد invariant کل object را تضمین نمی‌کند؛ mutex معمولاً ساده‌تر است.

راه دیگر، single-owner goroutine است که همهٔ تغییرات counter را از channel دریافت کند. این روش ownership را روشن می‌کند، اما برای هر counter ساده احتمالاً پیچیدگی بیشتری از lock دارد. اصل انتخاب: ساده‌ترین synchronizationی که invariant را درست نگه می‌دارد.

## ۵) data race روی map و alias

Map معمولی برای خواندن/نوشتن هم‌زمان بدون synchronization امن نیست؛ این می‌تواند هم race گزارش دهد و هم runtime failure ایجاد کند. map را با mutex محافظت کن یا mapهای مستقل به goroutineها بده و در پایان ترکیب کن.

برخی داده‌ها ظاهراً به تابع کپی شده‌اند اما backing memory مشترک است: slice، map، pointer، struct حاوی آن‌ها و closure captureشده. برای یافتن race مسیر alias را از مرزها دنبال کن، نه فقط متغیر با نام مشابه را.

## ۶) اجرای detector

Race detector پویاست و در build/runtime instrumentation اضافه می‌کند. دستورات رایج:

</div>

~~~powershell
go test -race ./...
go test -race -run TestConcurrentCache ./internal/cache
go run -race ./cmd/server
~~~

<div dir="rtl">

اولین فرمان تمام packageهای module را با detector می‌سازد و testها را اجرا می‌کند؛ اجرای برنامهٔ race-enabled نیز می‌تواند workload را بررسی کند. این ابزار زمان و حافظهٔ بیشتری مصرف می‌کند، پس برای production build معمولاً آن را به‌عنوان instrumentation آزمایشی به‌کار می‌بریم، نه اجرای عادی کاربر.

برای رفع race:

1. stack trace اولین و دومین دسترسی را بخوان.
2. هر دو مسیر را تا مالک داده دنبال کن.
3. مشخص کن مشکل state مشترک، closure، lifecycle یا test fixture است.
4. invariant لازم را بنویس.
5. mutex/channel/atomic مناسب را انتخاب کن.
6. detector را در همان مسیر workload دوباره اجرا کن.
7. عملکرد را پس از correctness بسنج.

## ۷) detector چه چیزی را ثابت نمی‌کند؟

Detector فقط executionهایی را می‌بیند که در run instrumented واقعاً رخ داده‌اند. اگر مسیر نادر، configuration خاص یا load بالا اجرا نشود، race آن ممکن است کشف نشود. سبزشدن تست race همهٔ raceها را ثابت نمی‌کند. پوشش workload، تست concurrent، stress/fuzz در موارد مناسب و بازبینی ownership مکمل‌اند.

برعکس، detector روی execution خاص می‌تواند نشانهٔ قطعی race باشد و نباید به خاطر اینکه «فعلاً نتیجه‌ها درست‌اند» نادیده گرفته شود. اگر race عمداً روی memory مستقل از دید detector رخ می‌دهد، کد/ownership را طوری بازطراحی کن که synchronization contract روشن باشد؛ suppression را راه‌حل پیش‌فرض نکن.

## ۸) تجربهٔ مستند صنعتی: Uber

پژوهش «A Study of Real-World Data Races in Golang» تجربهٔ استقرار race detector را در codebase صنعتی Uber گزارش می‌کند: ۴۶ میلیون خط Go و ۲۱۰۰ microservice در دامنهٔ مطالعه؛ پژوهشگران طی شش ماه بیش از ۲۰۰۰ race یافتند و بیش از ۱۰۰۰ مورد را رفع کردند. مقاله همچنین به چالش‌های مقیاس‌پذیری و flakiness ابزار پویا اشاره دارد. این اعداد شرح همان codebase و بازه‌اند؛ آن‌ها را به نرخ race هر Go service تعمیم نده.

نکتهٔ مهندسی این گزارش: detector ارزشمند است، اما برای استفادهٔ پایدار در مقیاس بزرگ، انتخاب workload، زمان‌بندی اجرا، noise و فرایند رسیدگی اهمیت دارند. بررسی race باید بخشی از توسعه و CI باشد، نه فقط واکنش پس از incident.

## ۹) race در test و test helper

تست‌ها هم goroutine دارند. اگر parallel test با state package-global اجرا شود، دو تست مستقل ممکن است یکدیگر را race کنند. Test fixture مشترک را immutable کن یا per-test بساز. <code>t.Parallel()</code> را فقط وقتی استفاده کن که setup/cleanup و resourceها concurrent safe باشند. در test، WaitGroup/channel را درست drain کن تا race روی نتیجه یا goroutine بعد از پایان تست نماند.

## خطاهای رایج

- فکرکردن <code>x++</code> اتمی است.
- رفع race با <code>time.Sleep</code>.
- اعتماد به یک اجرای موفق یا مقدار ظاهراً درست.
- محافظت از write ولی نه read.
- atomic کردن بخشی از invariant چندفیلدی.
- فرض اینکه کپی slice/map داده را مستقل کرده است.
- تفسیر detector سبز به‌عنوان اثبات عدم race.
- نادیده‌گرفتن تست‌ها/fixtureهای concurrent.
- استفاده از race detector در runtime عادی بدون درک overhead.
- سرکوب race بدون اصلاح مالکیت.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: counter

نمونهٔ بخش ۱ را با Mutex ایمن کن. پاسخ: هر increment را زیر <code>Lock/Unlock</code> قرار بده یا counter مستقل را با atomic جایگزین کن.

### تمرین ۲: map مشترک

یک goroutine map را می‌نویسد و دیگری می‌خواند. پاسخ: هر دو دسترسی زیر همان mutex؛ یا writer مالک map باشد و خواننده از طریق پیام/درخواست پاسخ بگیرد. فقط نوشتن را قفل نکن.

### تمرین ۳: race detector را تفسیر کن

<code>go test -race ./...</code> سبز است. چه نتیجه‌ای می‌گیری؟

**پاسخ:** فقط test executionهای پوشش‌داده‌شده race گزارش نکردند. اجرای مسیرهای production-like و code review همچنان لازم است؛ این نتیجه اثبات سراسری نیست.

### تمرین ۴: lock یا atomic

یک struct شامل balance و version دارد که باید با هم به‌روز شوند. کدام را انتخاب می‌کنی؟

**پاسخ:** mutex یا abstraction تراکنشی که invariant چندفیلدی را حفظ کند؛ atomic جداگانه تضمین می‌کند هر field مستقل است، نه سازگاری جفت آن‌ها.

## کوییز

### پرسش‌ها

1. data race چه سه شرط اصلی دارد؟
2. چرا increment معمولی اتمی نیست؟
3. آیا خروجی درست یک بار اجرای raceدار کد را ایمن می‌کند؟
4. happens-before چه ارزشی دارد؟
5. چرا sleep race را رفع نمی‌کند؟
6. برای state چندفیلدی کدام primitive غالباً ساده‌تر است؟
7. atomic چه زمانی مناسب است؟
8. map معمولی چه رفتاری در دسترسی هم‌زمان دارد؟
9. چرا slice کپی‌شده هنوز ممکن است race کند؟
10. race detector چگونه اجرا می‌شود؟
11. چرا detector پویا است؟
12. سبزشدن detector چه چیزی را ثابت نمی‌کند؟
13. پس از یافتن race چه چیزی باید ریشه‌یابی شود؟
14. تجربهٔ Uber چه دامنه و نتیجه‌ای را گزارش کرد؟
15. آیا اعداد Uber نرخ عمومی همهٔ Goها هستند؟
16. چرا test fixture می‌تواند race داشته باشد؟
17. آیا افزودن mutex به هر متغیر همیشه طراحی درست است؟
18. race detector چه هزینه‌ای نسبت به build عادی دارد؟

### کلید پاسخ

1. دسترسی هم‌زمان به محل مشترک، حداقل یک write، و نبود synchronization ترتیب‌دهنده.
2. read و writeهای جداگانه است.
3. خیر.
4. visibility و ترتیب قانونی میان goroutineها را مشخص می‌کند.
5. فقط زمان‌بندی را تغییر می‌دهد و memory synchronization نمی‌سازد.
6. mutex.
7. عملیات مستقل کم‌سطح مانند counter/flag که semantics آن روشن باشد.
8. بدون synchronization برای read/write هم‌زمان امن نیست.
9. ممکن است backing array را شریک باشد.
10. با <code>-race</code> روی test، run یا build.
11. فقط raceهای مسیر اجراشده را مشاهده می‌کند.
12. نبود race در pathهای اجراشده را فراتر از آن ثابت نمی‌کند.
13. مالکیت داده و هر دو مسیر دسترسی.
14. 46 میلیون خط، 2100 microservice؛ بیش از 2000 race یافت و بیش از 1000 مورد در شش ماه رفع شد.
15. خیر، یک نمونهٔ صنعتی خاص است.
16. چند تست parallel به global یا resource مشترک دسترسی می‌گیرند.
17. خیر؛ channel/ownership یا دادهٔ immutable هم ممکن است بهتر باشد؛ lock اضافه هم complexity دارد.
18. زمان و حافظهٔ بیشتری به‌خاطر instrumentation مصرف می‌کند.

## منابع

- انگلیسی: [Go Race Detector](https://go.dev/doc/articles/race_detector)
- انگلیسی: [Go Memory Model](https://go.dev/ref/mem)
- پژوهش صنعتی: [A Study of Real-World Data Races in Golang (PLDI 2022 / arXiv)](https://arxiv.org/abs/2204.00764)
- انگلیسی: [Go package sync/atomic](https://pkg.go.dev/sync/atomic)
- فارسی: [GoFarsi — هم‌زمانی در Go](https://cloud-book.gofarsi.ir/chapter-3/)
- فارسی: [GoFarsi — goroutine](https://book.gofarsi.ir/chapter-3/goroutine/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
