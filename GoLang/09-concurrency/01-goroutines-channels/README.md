# ۹.۱ — goroutine و channel

<div dir="rtl">

**زمان پیشنهادی:** ۱۶۵ دقیقه · **پیش‌نیاز:** تابع، slice و error  
**هدف:** کار هم‌زمان را با lifecycle روشن انجام بدهی، از channel برای هماهنگی درست استفاده کنی و goroutine رهاشده نسازی.

## نقشهٔ این درس

- concurrency در برابر parallelism
- goroutine و scheduler
- channel بدون buffer و با buffer
- ارسال، دریافت و بستن channel
- range روی channel
- مالکیت close
- nil channel و select
- happens-before و انتقال داده
- goroutine leak و cancellation
- طراحی producer/consumer

## ۱) concurrency با parallelism یکی نیست

Concurrency یعنی برنامه چند کار را طوری سازمان می‌دهد که پیشرفتشان در بازهٔ زمانی هم‌پوشان باشد. Parallelism یعنی چند کار واقعاً هم‌زمان روی چند core اجرا شوند. برنامه می‌تواند concurrent باشد ولی روی یک core اجرا شود؛ runtime برنامه‌ریزی goroutineها را مدیریت می‌کند. اضافه‌کردن goroutine همیشه سرعت را زیاد نمی‌کند: اگر کار CPU-bound است یا lock contention دارد، scheduling و synchronization هم هزینه دارد.

## ۲) goroutine چیست؟

Goroutine اجرای یک function call است که با کلیدواژهٔ <code>go</code> آغاز می‌شود. goroutine از thread سیستم‌عامل سبک‌تر است، اما مجانی نیست: حافظه، زمان‌بندی، stack و مسیر shutdown لازم دارد. آغازکردن goroutine، نتیجهٔ آن را به caller برنمی‌گرداند و ترتیب اجرا را هم تضمین نمی‌کند.

</div>

~~~go
go doWork()
~~~

<div dir="rtl">

اگر parent function فوراً برگردد، process به‌خاطر وجود goroutine زنده نگه داشته نمی‌شود؛ برنامهٔ command-line ممکن است قبل از اتمام آن خارج شود. برای انتظار از <code>sync.WaitGroup</code>، channel نتیجه یا abstraction مالک lifecycle استفاده کن. برای کار cancellable، <code>context.Context</code> را هم منتقل کن.

## ۳) channel، مسیر هماهنگی

Channel مقدارهای یک type را میان goroutineها منتقل می‌کند. Channel بدون buffer روی ارسال و دریافت rendezvous می‌کند: sender تا زمانی که receiver حاضر شود منتظر می‌ماند و برعکس. این همگام‌سازی ساده است، ولی اگر یک سمت هرگز فعال نشود برنامه deadlock می‌شود.

</div>

~~~go
messages := make(chan string)

go func() {
	messages <- "آماده"
}()

message := <-messages
fmt.Println(message)
~~~

<div dir="rtl">

Channel با buffer تا ظرفیتش مقدار می‌پذیرد؛ sender هنگامی block می‌شود که buffer پر باشد. buffer صف و ظرفیت bounded می‌دهد، اما cancellation، ownership و مصرف نهایی را حل نمی‌کند. buffer بزرگ یا نامحدودسازی عملی آن می‌تواند memory و latency را بالا ببرد.

## ۴) خواندن و نوشتن و پایان stream

برای دریافت یک مقدار می‌نویسیم <code>value := &lt;-ch</code>. اگر لازم است بدانیم channel بسته شده یا مقدار صفر عادی بوده، از فرم دوخروجی استفاده کن: <code>value, ok := &lt;-ch</code>. بعد از close، دریافت‌های باقی‌مانده تخلیه می‌شوند و سپس مقدار صفر type با <code>ok == false</code> می‌آید.

</div>

~~~go
for value := range results {
	fmt.Println(value)
}
~~~

<div dir="rtl">

<code>range</code> تا وقتی channel بسته شود ادامه می‌یابد. channel را برای پایان stream می‌بندیم؛ بستن آن معادل «هیچ داده‌ای نمی‌فرستم» است. ارسال روی channel بسته panic می‌کند؛ بستن دوباره نیز panic است. بنابراین owner فرستنده، پس از آنکه دیگر senderی ندارد، channel را می‌بندد. Receiver معمولاً channel را نمی‌بندد.

اگر چند sender وجود دارد، یک هماهنگ‌کننده باید پس از پایان همهٔ آن‌ها close کند. بدون دانستن مالکیت channel، closeکردن خطرناک است.

## ۵) nil channel و select

Channel صفرشده nil است. ارسال و دریافت از nil channel برای همیشه block می‌شود؛ در <code>select</code> این رفتار می‌تواند یک case را عمداً غیرفعال کند. اگر تمام caseها nil یا غیرفعال باشند و default هم نباشد، select block می‌ماند.

</div>

~~~go
select {
case value, ok := <-input:
	if !ok {
		input = nil // case دریافت را برای دورهای بعد غیرفعال می‌کند
	} else {
		fmt.Println(value)
	}
case <-ctx.Done():
	return ctx.Err()
}
~~~

<div dir="rtl">

<code>select</code> میان caseهای آماده یکی را انتخاب می‌کند؛ برای اولویت دائمی یا ترتیب قطعی طراحی نشده است. اگر می‌خواهی یکی را ترجیح دهی، منطق جداگانه یا state machine بساز؛ فرض نکن case متنی اول همیشه زودتر اجرا می‌شود.

## ۶) بستن channel چیست و چیست نیست؟

- close نشان می‌دهد دیگر valueی ارسال نمی‌شود؛ signal broadcast یک‌طرفه به receiverها هم می‌تواند باشد.
- close مقدارهای buffer را حذف نمی‌کند.
- close به‌تنهایی تمام goroutineها را متوقف نمی‌کند.
- channel بسته‌شده همچنان قابل‌دریافت است و پس از تخلیه مقدار zero می‌دهد.
- ارسال به channel بسته panic است.
- channel بسته دوباره panic می‌دهد.

در کدی که owner نامعلوم است، بهتر است قرارداد مالکیت را اصلاح کنی: producer channel را می‌سازد و close می‌کند، consumer آن را دریافت می‌کند.

## ۷) هماهنگی حافظه و happens-before

Channel فقط container نیست؛ synchronization هم فراهم می‌کند. در مدل حافظهٔ Go، یک send روی channel پیش از receive متناظر کامل می‌شود، پس receiver می‌تواند داده‌ای را که sender قبل از send نوشت مشاهده کند. این رابطه از visibility پشتیبانی می‌کند؛ اما اگر چند goroutine هم‌زمان متغیر مشترک را می‌نویسند، channel دیگر خودکار race را حل نمی‌کند مگر دسترسی‌ها واقعاً تحت قرارداد synchronization باشند.

داده را انتقال بده و ownership را واگذارکردن را در نظر بگیر. اگر sender پس از ارسال همچنان buffer را تغییر دهد و receiver هم بخواند، race می‌تواند باقی بماند. Channel message copying، deep copy انجام نمی‌دهد؛ slice/map/pointer داخل message هنوز دادهٔ مشترک می‌آورد.

## ۸) producer/consumer و cancellation

الگوی ساده: producer value می‌فرستد و consumer range می‌کند. در سامانهٔ واقعی، producer ممکن است زودتر از consumer تمام شود یا برعکس. برای اینکه sender در send blockشده رها نشود، context را در send نیز select کن.

</div>

~~~go
func generate(ctx context.Context, values []int) <-chan int {
	out := make(chan int)
	go func() {
		defer close(out)
		for _, value := range values {
			select {
			case out <- value:
			case <-ctx.Done():
				return
			}
		}
	}()
	return out
}
~~~

<div dir="rtl">

این تابع channel خروجی را خودش می‌سازد و خودش می‌بندد؛ caller فقط receive می‌کند. اگر caller فقط بخشی از خروجی را می‌خواهد، باید context را cancel کند؛ در غیر این صورت producer ممکن است روی send بعدی block بماند و goroutine leak شود. در برنامهٔ واقعی context را از caller می‌گیریم، نه اینکه context.Background را پنهانی داخل هر تابع بسازیم.

## ۹) سناریوی عملی production

یک سرویس فایل‌های ورودی را می‌خواند و برای هر کدام درخواست شبکه می‌زند. اگر برای هر فایل goroutine بدون محدودیت بسازیم، spike ورودی می‌تواند هزاران اتصال باز کند. اگر consumer نتیجه متوقف شود، producerها ممکن است روی channel نتایج block بمانند. راه‌حل کامل ترکیبی است: تعداد worker محدود، queue محدود با backpressure، deadline/cancellation برای درخواست، مالکیت روشن channelها و انتظار برای shutdown. این سناریوی آموزشی است؛ ظرفیت‌های واقعی را با workload و SLO سامانه بسنج.

## خطاهای رایج

- فرض کردن goroutine اجرا را به پایان می‌رساند یا نتیجه را نگه می‌دارد.
- فراموش‌کردن WaitGroup یا مسیر shutdown.
- closeکردن channel از receiver یا چند بار.
- ارسال روی channel بسته.
- نداشتن cancellation برای producerی که ممکن است block شود.
- channel بدون buffer با receiverی که هرگز اجرا نمی‌شود.
- buffer بسیار بزرگ برای پنهان‌کردن کندی consumer.
- فرض اینکه close goroutine را kill می‌کند.
- تغییر slice/map پس از ارسال همان reference.
- فرض ترتیب ثابت در select.
- نداشتن owner مشخص برای close و lifecycle.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: جمع‌آوری نتیجه

یک goroutine رشته‌ای می‌سازد و نتیجه را می‌فرستد. برنامه باید تا دریافت نتیجه منتظر بماند.

**پاسخ مفهومی:** برای یک نتیجهٔ محدود، channel buffered یک‌تایی می‌تواند اجازه دهد sender حتی اگر receiver کمی دیرتر حاضر شود نتیجه را بفرستد؛ اما caller همچنان باید channel را دریافت کند و خطا/timeout را مدیریت کند. برای چند task، WaitGroup و کانال result مناسب است.

### تمرین ۲: close توسط owner

چند worker از input می‌خوانند. چه کسی input را می‌بندد؟

**پاسخ:** producerی که دیگر داده نمی‌فرستد. workerها consumer هستند و channel را نمی‌بندند. خروجی را هماهنگ‌کننده بعد از پایان workerها می‌بندد.

### تمرین ۳: producer نیمه‌مصرف‌شده

Caller فقط اولین مقدار را می‌خواند. چه چیزی لازم است؟

**پاسخ:** cancellation را ارسال کند؛ producer در send با context.Done همزمان select کند و خارج شود. close خروجی در defer رخ دهد.

### تمرین ۴: predict

Channel با ظرفیت ۱ می‌سازیم، یک مقدار می‌فرستیم و پیش از receive دوباره مقدار می‌فرستیم. چه اتفاقی می‌افتد؟

**پاسخ:** send دوم block می‌شود تا buffer جا باز کند یا اجرای دیگری receive کند.

## کوییز

### پرسش‌ها

1. concurrency و parallelism چه تفاوتی دارند؟
2. <code>go f()</code> چه تضمینی دربارهٔ پایان f می‌دهد؟
3. channel بدون buffer چه زمانی send را کامل می‌کند؟
4. channel با buffer چه زمانی sender را block می‌کند؟
5. channel بسته‌شده هنگام receive چه می‌دهد؟
6. فرم <code>value, ok := &lt;-ch</code> چه چیزی را از zero value متمایز می‌کند؟
7. معمولاً چه کسی channel را close می‌کند؟
8. چرا send به channel بسته خطرناک است؟
9. close چه چیزی را اعلام می‌کند؟
10. nil channel در select چه کاربردی دارد؟
11. آیا case اول select همیشه اولویت دارد؟
12. channel send/receive چه رابطه‌ای در مدل حافظه فراهم می‌کند؟
13. چرا channel دادهٔ slice را deep-copy نمی‌کند؟
14. چرا buffer بزرگ backpressure را از بین نمی‌برد؟
15. goroutine leak چگونه رخ می‌دهد؟
16. چه سازوکاری برای توقف producer مناسبت دارد؟
17. آیا close به تنهایی goroutine را terminate می‌کند؟
18. چرا تعداد نامحدود goroutine برای کار شبکه پرخطر است؟

### کلید پاسخ

1. concurrency سازمان‌دهی پیشرفت هم‌پوشان کارهاست؛ parallelism اجرای واقعی هم‌زمان روی چند core.
2. هیچ تضمینی؛ parent ممکن است زود خارج شود.
3. وقتی receiver حاضر و مقدار دریافت شود.
4. وقتی buffer پر شود.
5. پس از تخلیه buffer مقدار zero و <code>ok == false</code>.
6. آیا مقدار از channel آمد یا channel بسته و خالی بود.
7. فرستنده/producer مالک channel، پس از پایان ارسال.
8. panic می‌دهد.
9. دیگر valueی فرستاده نمی‌شود.
10. برای disable کردن موقت یک case.
11. خیر؛ select ترتیب و اولویت ثابت تضمین نمی‌کند.
12. send پیش از receive متناظر happens-before دارد.
13. slice header کپی می‌شود ولی backing array مشترک می‌ماند.
14. مصرف بیش از ظرفیت هنوز sender را متوقف می‌کند و queue بزرگ فقط فشار را دیرتر و پرهزینه‌تر نشان می‌دهد.
15. goroutine روی send/receive/wait block می‌ماند اما دیگر مصرف‌کننده یا مسیر لغو ندارد.
16. context cancellation که در send/receive با select بررسی شود.
17. خیر؛ باید مسیر خودش را با context/channel/شرط پایان دهد.
18. اتصال، حافظه و scheduler مصرف می‌شود و بار بالا فشار را چندبرابر می‌کند.

## منابع

- انگلیسی: [A Tour of Go — Goroutines](https://go.dev/tour/concurrency/1)
- انگلیسی: [A Tour of Go — Channels](https://go.dev/tour/concurrency/2)
- انگلیسی: [Go specification — Select statements](https://go.dev/ref/spec#Select_statements)
- انگلیسی: [Go Memory Model](https://go.dev/ref/mem)
- انگلیسی: [Go blog — Pipelines and cancellation](https://go.dev/blog/pipelines)
- فارسی: [GoFarsi — Goroutine](https://book.gofarsi.ir/chapter-3/goroutine/)
- فارسی: [GoFarsi — concurrency](https://cloud-book.gofarsi.ir/chapter-3/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
