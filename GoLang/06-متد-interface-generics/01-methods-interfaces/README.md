# ۶.۱ — متدها، interface و ترکیب typeها

<div dir="rtl">

**زمان پیشنهادی:** ۱۵۰ دقیقه · **پیش‌نیاز:** struct، تابع، pointer و error  
**هدف:** رفتار را به type وصل کنی، interface کوچک طراحی کنی و type assertion و nil را با آگاهی به‌کار ببری.

## نقشهٔ این درس

- method و receiver
- value receiver و pointer receiver
- method set و interface satisfaction
- تعریف ضمنی interface
- interface کوچک و مصرف‌کننده‌محور
- type assertion و type switch
- interface خالی و <code>any</code>
- nil interface و typed nil
- embedding و composition
- مرز interface و abstraction

## ۱) متد چیست؟

متد تابعی است که receiver دارد. receiver معمولاً یک struct یا type تعریف‌شده است و پیش از نام متد داخل پرانتز می‌آید. متد رفتار مربوط به آن type را در کنار خود type قرار می‌دهد.

</div>

~~~go
type Celsius float64

func (c Celsius) Fahrenheit() float64 {
	return float64(c)*9/5 + 32
}
~~~

<div dir="rtl">

در این مثال <code>c</code> receiver value است؛ متد مقدار را فقط می‌خواند. Go برای methodها overload بر اساس امضای یکسان فراهم نمی‌کند؛ نام متدهای یک type باید یکتا باشد. method را با syntax <code>temperature.Fahrenheit()</code> فراخوانی می‌کنیم، ولی از دید مفهومی receiver هم ورودی تابع است.

## ۲) value receiver و pointer receiver

Value receiver یک کپی از receiver می‌گیرد. برای type کوچک و immutable-like این شکل طبیعی است. Pointer receiver اجازه می‌دهد متد object اصلی را mutate کند و از کپی‌کردن struct بزرگ جلوگیری می‌کند.

</div>

~~~go
type Counter struct {
	value int
}

func (c *Counter) Add(delta int) {
	c.value += delta
}

func (c Counter) Value() int {
	return c.value
}

func main() {
	counter := Counter{}
	counter.Add(3)
	fmt.Println(counter.Value()) // 3
}
~~~

<div dir="rtl">

Go در call syntax گاهی تبدیل آدرس را خودکار و راحت می‌کند: اگر <code>counter</code> addressable باشد، <code>counter.Add(3)</code> معمولاً معادل فراخوانی با <code>&amp;counter</code> است. این راحتی به معنی یکی‌بودن method set دو نوع نیست؛ در interface satisfaction باید method set را جداگانه بررسی کرد.

در یک type، receiverها را بی‌دلیل مخلوط نکن. اگر یکی از متدها برای mutation pointer receiver است، غالباً بقیه را هم pointer receiver بگذار تا رفتار و پیاده‌سازی interface قابل‌پیش‌بینی باشد. برای type دارای mutex، pointer receiver ضروری است تا lock کپی نشود.

## ۳) interface یک قرارداد رفتاری است

Interface مجموعه‌ای از امضای متدهاست. یک type با داشتن آن متدها، بدون نوشتن کلیدواژهٔ implements، interface را پیاده می‌کند. این پیاده‌سازی ضمنی است؛ بنابراین می‌توانی type خود را در package دیگری بسازی و همچنان با interface استاندارد سازگار شود.

</div>

~~~go
type Stringer interface {
	String() string
}

type User struct {
	Name string
}

func (u User) String() string {
	return "User(" + u.Name + ")"
}

func printValue(value Stringer) {
	fmt.Println(value.String())
}
~~~

<div dir="rtl">

تابع <code>printValue</code> به struct مشخص وابسته نیست؛ فقط رفتاری را نیاز دارد که interface توصیف کرده است. interface معمولاً در package مصرف‌کننده تعریف می‌شود: مصرف‌کننده فقط همان methodهای لازم را بیان می‌کند. این روش coupling را کم می‌کند و پیاده‌سازی‌های متنوع را قابل استفاده می‌سازد.

### Embedding interface در interface

Interface می‌تواند interface دیگری را embed کند تا قرارداد مرکب بسازد. typeی که قرارداد مرکب را satisfy می‌کند باید همهٔ متدهای اعضا را داشته باشد:

~~~go
type Reader interface {
	Read([]byte) (int, error)
}

type Writer interface {
	Write([]byte) (int, error)
}

type ReadWriter interface {
	Reader
	Writer
}
~~~

<code>io.ReadWriter</code> نمونهٔ standard library همین ترکیب رفتار خواندن و نوشتن است. embedding interface composition قرارداد متدها را انجام می‌دهد؛ در حالت تداخل نام، signatureها باید با هم سازگار باشند. فقط متدهایی را embed کن که consumer واقعاً نیاز دارد؛ قرارداد مرکب بزرگ‌تر جای interface کوچک را نمی‌گیرد.
## ۴) method set و pointer receiver

اگر type <code>T</code> متدی با receiver نوع <code>*T</code> داشته باشد، method set مربوط به <code>*T</code> آن متد را شامل می‌شود؛ method set خود <code>T</code> شامل آن نمی‌شود. پس ممکن است pointer نوع interface را پیاده کند، اما value نوع پیاده نکند.

</div>

~~~go
type Renamer interface {
	Rename(string)
}

type Account struct {
	Name string
}

func (a *Account) Rename(name string) {
	a.Name = name
}

func useRenamer(r Renamer) {
	r.Rename("new name")
}

func main() {
	account := Account{Name: "old"}
	useRenamer(&account) // pointer متد را دارد
	// useRenamer(account) // این مقدار interface را satisfy نمی‌کند
}
~~~

<div dir="rtl">

برای آزمون مستندشده در زمان compile می‌توانی از اعلان زیر استفاده کنی:

</div>

~~~go
var _ Renamer = (*Account)(nil)
~~~

<div dir="rtl">

این declaration مقدار runtime نمی‌سازد؛ compiler را وادار می‌کند ناسازگاری امضا را زود گزارش کند. برای value implementation می‌توانی <code>var _ Renamer = Account{}</code> بنویسی، به شرط آنکه method set واقعاً کافی باشد.

## ۵) interface کوچک بنویس

یک interface کوچک یک نیاز را نام‌گذاری می‌کند. مثال کتابخانهٔ استاندارد <code>io.Reader</code> فقط یک عملیات می‌خواهد: گرفتن بایت. فایل، connection یا reader ساختگی تست می‌تواند این قرارداد را پیاده کند.

</div>

~~~go
type Reader interface {
	Read(p []byte) (n int, err error)
}
~~~

<div dir="rtl">

اگر تابع فقط لازم دارد چند بایت بخواند، گرفتن یک interface بزرگ شامل Read، Write، Close، Seek و ده‌ها عملیات دیگر وابستگی غیرضروری می‌سازد. از طرف دیگر، interface را صرفاً برای هر struct یک‌به‌یک mirror نکن. abstraction وقتی ارزش دارد که نیاز واقعی مصرف‌کننده، جایگزینی پیاده‌سازی، یا seam تست را روشن کند.

یک تابع کوچک وابسته به رفتار را اغلب می‌توان بدون packageهای لایه‌ای پیچیده test کرد: interface در نزدیکی تابع مصرف‌کننده تعریف می‌شود و fake در test همان چند متد را پیاده می‌کند.

## ۶) assertion، type switch و any

Interface در runtime یک مقدار concrete و type آن را حمل می‌کند. اگر رفتار خاص type لازم شد، type assertion آن را بررسی می‌کند. فرم دوخروجی خطای assertion را به panic تبدیل نمی‌کند؛ فرم تک‌خروجی در صورت شکست panic می‌دهد و فقط در مسیر قطعی استفاده شود.

</div>

~~~go
var value any = "hello"

text, ok := value.(string)
if !ok {
	fmt.Println("مقدار string نیست")
	return
}
fmt.Println(text)

switch v := value.(type) {
case string:
	fmt.Println("متن:", v)
case int:
	fmt.Println("عدد:", v)
default:
	fmt.Printf("نوع دیگر: %T\n", v)
}
~~~

<div dir="rtl">

از Go 1.18، <code>any</code> نام مستعار خواناتر برای <code>interface{}</code> است. interface خالی هر نوع concrete را می‌پذیرد، اما static type safety و دانش compiler دربارهٔ عملیات را کمتر می‌کند. از <code>any</code> برای مرزهایی مثل decoding عمومی یا containerهای واقعاً ناهمگون استفاده کن، نه به‌عنوان جایگزین همهٔ typeهای مشخص.

اگر می‌خواهی از value عمومی استفاده کنی، برای هر type پذیرفته‌شده policy روشن بنویس. type assertionهای پیاپی که منطق اصلی را تشکیل می‌دهند ممکن است نشانهٔ مدل domain نامناسب یا interface گم‌شده باشند.

## ۷) nil interface و typed nil

Interface را به شکل مفهومی می‌توان ترکیب نوع concrete و مقدار concrete تصور کرد. interface وقتی nil است که هر دو بخش تهی باشند. اگر pointer nil را داخل interface قرار دهی، خود interface مقدار type دارد و nil نیست.

</div>

~~~go
type Reporter interface {
	Report() string
}

type FileReporter struct{}

func (r *FileReporter) Report() string {
	if r == nil {
		return "reporter is nil"
	}
	return "report ready"
}

func maybeReporter() Reporter {
	var reporter *FileReporter = nil
	return reporter
}

func main() {
	reporter := maybeReporter()
	fmt.Println(reporter == nil) // false: interface مقدار typed nil دارد
	fmt.Println(reporter.Report())
}
~~~

<div dir="rtl">

این تفاوت یکی از علت‌های رایج باگ است: تابعی که <code>error</code> برمی‌گرداند ممکن است pointer error nil را به interface تبدیل کند و caller یک error غیرnil ببیند. قرارداد را طوری طراحی کن که موفقیت را صریحاً <code>return nil</code> کند، نه typed nil. لازم نیست برای هر pointer داخل interface بررسی خاص اضافه کنی؛ طراحی بازگشت را اصلاح کن.

## ۸) embedding و composition

Embedding یک type در struct باعث می‌شود field و methodهایش در selector set بیرونی promoted شوند. این کار composition و reuse رفتاری فراهم می‌کند، اما subclassing یا inheritance کلاسیک نیست. type داخلی خودکار به invariantهای type بیرونی دسترسی مدیریتی ندارد و override مجازی به معنای زبان‌های کلاس‌محور اتفاق نمی‌افتد.

</div>

~~~go
type Logger struct{}

func (Logger) Info(message string) {
	fmt.Println("INFO:", message)
}

type Service struct {
	Logger
	Name string
}

func (s Service) Start() {
	s.Info("starting " + s.Name)
}
~~~

<div dir="rtl">

مشتری می‌تواند <code>service.Info(...)</code> را صدا بزند چون متد promoted شده است، اما طراحی همچنان دو type ترکیب‌شده را نشان می‌دهد. اگر نام متدها برخورد داشته باشند، selector ممکن است مبهم شود و باید از نام field داخلی مثل <code>service.Logger.Info(...)</code> کمک بگیری. embedding را برای composition قابل‌فهم استفاده کن، نه برای ساخت سلسله‌مراتب عمیق و پنهان.

## ۹) abstraction را از نیاز شروع کن

پرسش‌های مفید هنگام طراحی interface:

1. caller دقیقاً کدام رفتارها را نیاز دارد؟
2. آیا بیش از یک پیاده‌سازی واقعی وجود دارد یا تست برای fake به seam کوچکی نیاز دارد؟
3. آیا interface را در package مصرف‌کننده تعریف کرده‌ام؟
4. آیا type concrete را بی‌دلیل از کاربر پنهان می‌کنم؟
5. آیا یک interface بزرگ دارد همهٔ کارها را نمایندگی می‌کند؟
6. آیا نام interface رفتار را می‌گوید؟

در Go گاهی بازگرداندن concrete type و قبول interface کوچک در ورودی API ساده‌تر است. interface را برای قابلیت جایگزینی واقعی بساز؛ abstraction پرهزینه‌ای که هیچ variability را مدیریت نمی‌کند، فقط درک کد را سخت‌تر می‌کند.

## خطاهای رایج

- فرض اینکه type باید صریحاً <code>implements</code> بنویسد.
- اشتباه‌گرفتن method set نوع value با pointer به آن.
- تعریف interface بزرگ برای mirror کردن یک struct.
- استفاده از interface خالی برای دورزدن type system.
- گرفتن typed nil و مقایسهٔ آن با nil interface.
- تصور اینکه embedding معادل inheritance یا override است.
- تبدیل هر type کوچک به interface بدون نیاز مصرف‌کننده.
- استفاده از assertion تک‌خروجی در ورودی نامطمئن.
- export کردن interfaceهای متعدد پیش از فهم رفتار مصرف‌کننده.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: قرارداد چاپ

type <code>Temperature</code> بساز که متد <code>String() string</code> داشته باشد و interface کوچک <code>fmt.Stringer</code> را پیاده کند.

**پاسخ:** اگر <code>String</code> value receiver داشته باشد، هم value و هم pointer معمولاً method set لازم را دارند. اگر receiver pointer باشد، value ممکن است interface را پیاده نکند. انتخاب receiver را با نیاز mutation انجام بده.

### تمرین ۲: جداکردن storage

تابع <code>loadNames</code> فقط یک operation از storage لازم دارد. interface محلی با <code>Load(string) (string, error)</code> تعریف و یک fake ساده برای test بساز.

**پاسخ:** interface را در package یا فایل مصرف‌کننده تعریف کن، fake map-backed بنویس، و خطای key مفقود را طبق قراردادت برگردان. به interface یک database driver کامل وابسته نشو اگر فقط یک عملیات می‌خواهی.

### تمرین ۳: typed nil

تابعی بساز که error برمی‌گرداند و موفقیت را nil اعلام کند. پاسخ: در مسیر موفقیت به‌صورت صریح <code>return nil</code> کن. pointer به نوع خطای nil را مستقیم به <code>error</code> تبدیل و برنگردان.

### تمرین ۴: assertion امن

مقدار <code>any</code> را به string تبدیل کن، اما در نبود string برنامه panic نکند.

**پاسخ:** <code>text, ok := value.(string)</code> بنویس و <code>ok</code> را بررسی کن یا type switch داشته باش.

## کوییز

### پرسش‌ها

1. receiver در تعریف متد چه نقشی دارد؟
2. value receiver چه چیزی دریافت می‌کند؟
3. pointer receiver معمولاً چه دو مزیتی دارد؟
4. چه فرقی میان method set نوع <code>T</code> و <code>*T</code> وجود دارد؟
5. پیاده‌سازی interface در Go چگونه اعلام می‌شود؟
6. interface بهتر است غالباً در کجا تعریف شود؟
7. چرا interface کوچک مفید است؟
8. چه وقت interface ارزشمند است؟
9. فرم دوخروجی type assertion چه چیزی می‌دهد؟
10. <code>any</code> از کدام نسخهٔ Go در دسترس است؟
11. typed nil چه رفتاری در مقایسه با nil interface دارد؟
12. چرا ممکن است تابع error موفقیت را به اشتباه غیرnil برگرداند؟
13. embedding چه قابلیتی می‌دهد؟
14. آیا embedding inheritance است؟
15. چرا interface بزرگ برای تابعی که یک متد می‌خواهد بد است؟
16. چه وقت concrete type را مستقیم در API برگردانیم؟
17. embedding interfaceها چگونه قرارداد بزرگ‌تر می‌سازد؟
18. برای پیاده‌سازی <code>io.ReadWriter</code> چه دو رفتار لازم است؟
19. منظور از interface کوچک چیست؟
20. چرا interface را صرفاً برای توسعهٔ احتمالی آینده نمی‌سازیم؟

### کلید پاسخ

1. مشخص می‌کند متد روی کدام type تعریف شده و receiver ورودی ضمنی آن است.
2. یک کپی از مقدار type.
3. امکان mutation object اصلی و جلوگیری از کپی بزرگ.
4. methodهای pointer receiver در method set مربوط به pointer هستند، نه value؛ جزئیات کامل در specification است.
5. ضمنی است؛ کافی است امضای methodها سازگار باشد.
6. در package مصرف‌کننده‌ای که به آن رفتار نیاز دارد.
7. وابستگی و بار fake/test را کم می‌کند.
8. وقتی caller به رفتار مشخص یا جایگزینی پیاده‌سازی نیاز دارد.
9. مقدار concrete و یک bool برای موفقیت assertion.
10. Go 1.18.
11. interface حاوی pointer nil همچنان نوع دارد و با nil برابر نیست.
12. چون typed nil به interface تبدیل شده و interface دیگر واقعاً nil نیست.
13. promotion برخی selectorها و reuse ترکیبی رفتار.
14. خیر؛ inheritance کلاسیک و override مجازی نیست.
15. پیاده‌سازی غیرضروری را تحمیل و coupling را بیشتر می‌کند.
16. وقتی کاربر به جزئیات concrete نیاز دارد و variability واقعی یا seam مناسب وجود ندارد.
17. method set قرارداد جدید را با ترکیب methodهای interfaceهای embedded می‌سازد.
18. متدهای Read و Write با signature سازگار.
19. چند رفتار ضروری و دقیق که مصرف‌کننده واقعاً لازم دارد؛ قرارداد کوچک‌تر fake و پیاده‌سازی را آسان می‌کند.
20. چون abstraction بی‌نیاز coupling و سطح API را زیاد می‌کند؛ نیاز واقعی مصرف‌کننده را مبنا بگیر.

## منابع

- انگلیسی: [Go specification — Method sets](https://go.dev/ref/spec#Method_sets)
- انگلیسی: [Go specification — Interface types](https://go.dev/ref/spec#Interface_types)
- انگلیسی: [Go FAQ — nil error values](https://go.dev/doc/faq#nil_error)
- انگلیسی: [Go wiki — Code review comments on interfaces](https://go.dev/wiki/CodeReviewComments#interfaces)
- انگلیسی: [A Tour of Go — Interfaces](https://go.dev/tour/methods/9)
- فارسی: [GoFarsi — متدها و interface](https://cloud-book.gofarsi.ir/chapter-2/)
- فارسی: [GoFarsi — embedding و ترکیب](https://cloud-book.gofarsi.ir/chapter-2/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
