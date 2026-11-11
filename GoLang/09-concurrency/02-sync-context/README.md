# ۹.۲ — sync، cancellation و context

<div dir="rtl">

**زمان پیشنهادی:** ۱۷۰ دقیقه · **پیش‌نیاز:** goroutine/channel، pointer و error  
**هدف:** دسترسی مشترک را ایمن کنی، goroutineها را با لغو یا deadline متوقف کنی و از primitive درست برای هر مسئله استفاده کنی.

## نقشهٔ این درس

- data race و state مشترک
- mutex و RWMutex
- WaitGroup
- Once و atomic
- context و propagation
- deadline، timeout و cancellation
- context value و کلید خصوصی
- انتخاب channel یا lock
- lifecycle و shutdown

## ۱) concurrency-safe بودن را باید طراحی کرد

اگر دو goroutine هم‌زمان به یک memory location دسترسی دارند و حداقل یکی می‌نویسد، بدون synchronization ممکن است data race رخ دهد. خروجی برنامه در آن حالت قابل‌اعتماد نیست. استفاده از goroutine به‌تنهایی حافظه را ایمن نمی‌کند. ابزار <code>go test -race</code> می‌تواند بسیاری از raceهای اجراشده را پیدا کند، اما اثبات نمی‌کند همهٔ مسیرهای برنامه امن‌اند.

برای دادهٔ مشترک، دو الگوی پایه وجود دارد:

1. مالکیت داده را با channel واگذار کن و دسترسی هم‌زمان را محدود کن.
2. داده را مشترک نگه دار و با mutex/atomic از دسترسی محافظت کن.

هر کدام در جای خود مناسب است؛ channel برای همهٔ stateها ساده‌تر نیست، و lock لزوماً کد بدی نمی‌سازد.

## ۲) Mutex: از invariant محافظت کن

Mutex اجازه می‌دهد یک goroutine در هر لحظه بخش protected را اجرا کند. lock را بلافاصله پس از گرفتن آزاد کن، معمولاً با defer، تا returnهای زودهنگام هم unlock کنند.

</div>

~~~go
type SafeCounter struct {
	mu     sync.Mutex
	values map[string]int
}

func (c *SafeCounter) Add(key string, delta int) {
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.values == nil {
		c.values = make(map[string]int)
	}
	c.values[key] += delta
}

func (c *SafeCounter) Get(key string) int {
	c.mu.Lock()
	defer c.mu.Unlock()
	return c.values[key]
}
~~~

<div dir="rtl">

همهٔ دسترسی‌ها به map باید زیر همان mutex باشند؛ محافظت نوشتن بدون محافظت خواندن کافی نیست. fieldهای protected و lock را در یک type جمع کن تا invariant نزدیک داده بماند. پس از استفاده، struct دارای mutex را کپی نکن. receiverهای آن type معمولاً pointer هستند.

Lock را هنگام network call، file I/O یا callback خارجی نگه ندار؛ caller کند می‌تواند lock را برای مدت طولانی نگه دارد. اگر لازم است state را snapshot کن، lock را آزاد کن و کار کند را بیرون lock انجام بده.

## ۳) RWMutex و atomic

<code>sync.RWMutex</code> اجازه می‌دهد چند reader هم‌زمان بخوانند، ولی writer انحصاری است. این ابزار همیشه از Mutex سریع‌تر نیست؛ bookkeeping اضافه دارد و در workload خاص ممکن است throughput را کم کند. benchmark نمایندهٔ ترافیک واقعی لازم است.

Atomic برای عملیات کوچک و دقیق روی state مشترک است، مثل counter یا flag؛ مجموعهٔ چند field را به تراکنش اتمی تبدیل نمی‌کند. دسترسی atomic را با دسترسی معمولی بی‌هماهنگ به همان متغیر مخلوط نکن. در بیشتر طراحی‌ها Mutex ساده‌تر است.

<code>sync.Map</code> هم map عمومیِ سریع‌تر برای همهٔ شرایط نیست؛ برای الگوهای خاص مانند entryهای مستقل و read-heavy ساخته شده. map معمولی با lock گزینهٔ پیش‌فرض روشن‌تری است.

## ۴) WaitGroup: منتظر پایان کارها

WaitGroup تعداد کارهایی را نگه می‌دارد که باید تمام شوند. <code>Add</code> را پیش از شروع goroutine انجام بده و در آن goroutine <code>Done</code> را defer کن. <code>Wait</code> تا صفرشدن شمارنده منتظر می‌ماند. WaitGroup برای انتقال error یا data طراحی نشده است؛ کانال نتایج یا ابزار مناسب دیگری را جداگانه استفاده کن.

</div>

~~~go
var wg sync.WaitGroup

for _, item := range items {
	wg.Add(1)
	go func(value string) {
		defer wg.Done()
		process(value)
	}(item)
}

wg.Wait()
~~~

<div dir="rtl">

برای جلوگیری از closure ناخواسته، این مثال value را پارامتر می‌کند. همچنین process باید contract خطا/cancellation داشته باشد؛ فقط WaitGroup تضمین نمی‌کند کارها بتوانند متوقف شوند. اگر worker در I/O بی‌نهایت منتظر است، Wait همچنان ممکن است تا ابد بماند.

## ۵) context: لغو و deadline را منتقل کن

<code>context.Context</code> مسیر انتقال cancellation، deadline و metadata محدود درخواست است. برای هر عملیات ورودی یا درخواست بیرونی، context را از caller دریافت کن و به عملیات پایین‌دستی که آن را می‌پذیرند منتقل کن. Context را در field یک struct ذخیره نکن؛ آن را در پارامتر صریح بگیر، معمولاً نخستین پارامتر است.

</div>

~~~go
func fetch(ctx context.Context, url string) ([]byte, error) {
	request, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}

	response, err := http.DefaultClient.Do(request)
	if err != nil {
		return nil, fmt.Errorf("درخواست %s: %w", url, err)
	}
	defer response.Body.Close()

	return io.ReadAll(response.Body)
}
~~~

<div dir="rtl">

وقتی client یا downstream از context پشتیبانی کند، لغو و deadline به آن منتقل می‌شود. در عملیات CPU-bound یا حلقهٔ طولانی خودت هم <code>ctx.Done()</code> را هر از گاه بررسی کن؛ context نمی‌تواند کدی را که cancellation را نادیده می‌گیرد به زور متوقف کند.

اگر API ورودی context nil بگیرد، رفتار نامشخص یا panic ممکن است رخ دهد؛ به‌طور معمول caller باید context معتبر مانند <code>context.Background()</code> برای آغاز برنامه یا <code>context.TODO()</code> موقت بدهد. library context را بی‌دلیل از نو نسازد.

## ۶) deadline و لغو child context

برای عملیات کند timeout تعیین کن. فراموش‌کردن فراخوانی تابع cancel باعث می‌شود parent resourceهای timer و child context را تا لغو بعدی نگه دارد؛ بنابراین بلافاصله cancel را defer کن.

</div>

~~~go
func callDependency(parent context.Context) error {
	ctx, cancel := context.WithTimeout(parent, 2*time.Second)
	defer cancel()

	request, err := http.NewRequestWithContext(ctx, http.MethodGet, "https://example.com/health", nil)
	if err != nil {
		return err
	}

	response, err := http.DefaultClient.Do(request)
	if err != nil {
		return err
	}
	defer response.Body.Close()
	return nil
}
~~~

<div dir="rtl">

در برنامهٔ واقعی URL باید از config بیاید و error response status هم بررسی شود؛ هدف این مثال فقط انتقال context و deadline است. دو ثانیه برای همهٔ سرویس‌ها درست نیست؛ budget latency کل درخواست را بین عملیات تقسیم کن و deadline caller را محترم بشمار.

## ۷) context value را برای metadata محدود نگه دار

Context value برای دادهٔ request-scoped مناسب است که از مرز APIها عبور می‌کند، مانند trace ID یا هویت احراز‌شده پس از اعتبارسنجی. آن را برای پارامترهای اختیاری عملکردی، config سراسری یا وابستگی‌های اجباری پنهان استفاده نکن. برای این موارد پارامتر صریح بهتر است.

کلید را با type خصوصی تعریف کن تا collision میان packageها رخ ندهد. دادهٔ حساس را بی‌فکر در context قرار نده؛ ممکن است در log یا tracing افشا شود. مقدار context باید immutable یا دارای قرارداد concurrency-safe باشد.

## ۸) select برای خروج هم‌زمان با انتظار

برای goroutineای که منتظر ورودی یا کار است، cancellation را کنار receive/send در select قرار بده:

</div>

~~~go
func worker(ctx context.Context, jobs <-chan Job) error {
	for {
		select {
		case <-ctx.Done():
			return ctx.Err()
		case job, ok := <-jobs:
			if !ok {
				return nil
			}
			if err := process(ctx, job); err != nil {
				return err
			}
		}
	}
}
~~~

<div dir="rtl">

در صورت لغو، تابع با <code>ctx.Err()</code> خارج می‌شود. هر pipeline باید مسیر cancellation هر مرحله را داشته باشد؛ اگر stage پایانی دیگر نمی‌خواند، stageهای بالاتر باید بتوانند متوقف شوند. برای گروهی از taskها، خروجی error و cancel باقی کارها را با helper مناسب مدیریت کن؛ package بیرونی <code>golang.org/x/sync/errgroup</code> متداول است، اما dependency جداست و باید در go.mod اضافه و نسخه‌اش بررسی شود.

### تشخیص leak در Go 1.27

Go 1.27، <code>goroutineleak</code> profile را در <code>runtime/pprof</code> و endpoint متناظر در <code>net/http/pprof</code> به‌صورت عمومی در دسترس قرار داد. Runtime می‌تواند بخشی از goroutineهای دائماً blockشده را از روی reachability تشخیص دهد؛ این قابلیت همهٔ leakها را پیدا نمی‌کند، به‌ویژه اگر channel/primitive از global یا goroutine runnable قابل‌دسترسی بماند. از profile به‌عنوان سیگنال diagnostics استفاده کن و همچنان shutdown و cancellation را درست طراحی کن.
## ۹) deadlock و lock ordering

دو mutex را در توالی‌های متفاوت بین goroutineها نگیری؛ ممکن است A lock اول را بگیرد و منتظر دومی باشد، درحالی‌که B دوم را گرفته و منتظر اول است. اگر چند lock نیاز داری، ترتیب global ثابت تعریف کن یا critical sectionها را بازطراحی کن. callback بیرونی را زیر lock اجرا نکن.

تشخیص deadlock فقط با دیدن یک goroutine مسدود کافی نیست؛ همهٔ wait edgeها و ownerها را بررسی کن. deadline برای network operation کمک می‌کند، اما mutex از آن پشتیبانی نمی‌کند؛ برای lock طولانی باید ساختار و scope را اصلاح کنی.

## خطاهای رایج

- محافظت‌نکردن map یا struct مشترک.
- گرفتن lock و return بدون unlock.
- انتظار اینکه RWMutex یا atomic خودکار کارایی را بالا ببرد.
- کپی‌کردن WaitGroup یا Mutex پس از استفاده.
- فراخوانی Wait پیش از Add هماهنگ‌نشده.
- استفاده از WaitGroup برای نتیجه یا error.
- Context را داخل struct ذخیره‌کردن یا پنهانی ساختن Background در library.
- نادیده‌گرفتن Done در loop/send/receive.
- فراموش‌کردن cancel پس از WithTimeout.
- استفاده از Context value برای configuration یا parameter اصلی.
- انتظار اینکه cancellation کد را به اجبار terminate کند.
- انتظار با WaitGroup برای workerای که هیچ راه خروج ندارد.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: counter ایمن

یک map مشترک را با mutex محافظت کن. خواندن و نوشتن هر دو باید زیر lock باشند.

**پاسخ:** نمونهٔ <code>SafeCounter</code> بخش ۲؛ در طراحی واقعی فقط query و تغییر را داخل critical section کوتاه نگه دار.

### تمرین ۲: worker cancellable

Worker channel job را بخواند، ولی در لغو دیگر روی receive گیر نکند.

**پاسخ:** select بین <code>&lt;-ctx.Done()</code> و دریافت jobs، مانند بخش ۸. اگر process خود blocking است باید ctx را دریافت کند.

### تمرین ۳: deadline propagation

در handler درخواست HTTP، context را به repository و از آنجا به database query منتقل کن.

**پاسخ:** context را پارامتر نخست هر تابع بگیر و API databaseای را انتخاب کن که context می‌پذیرد. context.Background تازه در repository نساز، چون لغو caller قطع می‌شود.

### تمرین ۴: race یا lock؟

دو worker counter مشترک را افزایش می‌دهند. دو راه‌حل بنویس.

**پاسخ:** mutex پیرامون increment؛ یا atomic مناسب برای counter مستقل. اگر increment بخشی از update چند field است، atomic counter به تنهایی invariant کلی را محافظت نمی‌کند.

## کوییز

### پرسش‌ها

1. چه شرایطی data race می‌سازد؟
2. Mutex از چه چیزی محافظت می‌کند؟
3. چرا mutex باید کنار دادهٔ موردحفاظت نگه‌داری شود؟
4. چه وقت RWMutex مفید است؟
5. چرا RWMutex الزاماً Mutex را سریع‌تر نمی‌کند؟
6. WaitGroup چه چیزی را هماهنگ می‌کند؟
7. چرا Add را پیش از شروع goroutine انجام می‌دهیم؟
8. آیا WaitGroup خطاها را جمع می‌کند؟
9. context چه دو سیگنال اصلی را منتقل می‌کند؟
10. چرا context باید پارامتر function باشد؟
11. چرا context را در struct ذخیره نمی‌کنیم؟
12. WithTimeout چه موقع cancel باید شود؟
13. چرا cancel را defer می‌کنیم؟
14. آیا context کدی را که Done را بررسی نمی‌کند terminate می‌کند؟
15. context value برای چه داده‌ای مناسب است؟
16. چرا Context جای config و parameter عادی نیست؟
17. چرا sync.Map گزینهٔ عمومی پیش‌فرض نیست؟
18. race detector چه محدودیتی دارد؟
19. goroutineleak profile از چه نسخه‌ای است و چه محدودیتی دارد؟

### کلید پاسخ

1. دسترسی هم‌زمان به یک location که حداقل یک دسترسی نوشتن باشد و synchronization درستی نداشته باشد.
2. invariant و دسترسی هم‌زمان به state مشترک را.
3. چون مالکیت و قانون دسترسی در همان abstraction دیده شود.
4. در workloadی با read بسیار زیاد و write کم، پس از اندازه‌گیری.
5. bookkeeping و pattern دسترسی ممکن است هزینهٔ بیشتری از سود concurrent read داشته باشد.
6. انتظار برای اتمام چند goroutine.
7. تا goroutine قبل از اضافه‌شدن شمارنده تمام نشده و Wait زودتر صفر نبیند.
8. خیر.
9. cancellation و deadline؛ همچنین metadata محدود با value.
10. وابستگی عملیات به زمان/درخواست صریح و قابل‌انتقال باشد.
11. چون هر عملیات lifetime/cancellation خود را دارد و ذخیره‌سازی پنهان coupling می‌سازد.
12. پس از پایان کار یا بلافاصله پس از ساخت با defer cancel.
13. cleanup حتی در returnهای مختلف تضمین شود.
14. خیر.
15. metadata محدود request-scoped مانند trace ID یا identity معتبر.
16. پارامترها و config باید explicit و قابل‌اعتبارسنجی باشند.
17. فقط برای الگوهای خاص مناسب است؛ map معمولی با lock عمومی‌تر و روشن‌تر است.
18. فقط raceهایی را می‌بیند که اجرای instrumented test/workload به آن‌ها می‌رسد؛ همهٔ برنامه را ثابت نمی‌کند.
19. Go 1.27؛ بخشی از goroutineهای blockشده را می‌یابد، ولی همهٔ leakها را تشخیص نمی‌دهد.

## منابع

- انگلیسی: [Go package sync](https://pkg.go.dev/sync)
- انگلیسی: [Go package context](https://pkg.go.dev/context)
- انگلیسی: [Go 1.27 release notes — goroutine leak profile](https://go.dev/doc/go1.27#goroutine_leak_profile)
- انگلیسی: [Go Memory Model](https://go.dev/ref/mem)
- انگلیسی: [Go Blog — Context](https://go.dev/blog/context)
- فارسی: [GoFarsi — context و هم‌زمانی](https://cloud-book.gofarsi.ir/chapter-3/)
- فارسی: [GoFarsi — Goroutine](https://book.gofarsi.ir/chapter-3/goroutine/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
