# ۶.۲ — Generics: type parameter و constraint

<div dir="rtl">

**زمان پیشنهادی:** ۱۵۰ دقیقه · **پیش‌نیاز:** type، function، interface، map و slice  
**هدف:** کد قابل‌استفادهٔ مجدد بنویسی، محدودیت نوع را درست تعریف کنی و بدانی چه زمانی generic ارزش دارد.

## نقشهٔ این درس

- مسئله‌ای که generics حل می‌کند
- type parameter و type argument
- type inference
- constraint و type set
- union و underlying type با <code>~</code>
- تابع generic
- type generic و متدهای آن
- <code>comparable</code>
- محدودیت عملیات روی type parameter
- انتخاب میان generic، interface و کد مشخص

## ۱) مسئله: تکرار الگوریتم برای typeهای مختلف

فرض کن تابعی برای پیدا کردن بیشینهٔ عددهای <code>int</code> داری و همان الگوریتم را دوباره برای <code>int64</code> و <code>float64</code> لازم داری. نسخهٔ جداگانه می‌تواند تکرار شود؛ تبدیل همه‌چیز به <code>any</code> نوع را پنهان می‌کند و assertionهای runtime لازم می‌آورد. Generic اجازه می‌دهد یک الگوریتم را برای مجموعه‌ای از نوع‌های مجاز تعریف کنیم و در عین حال بررسی type در compile time بماند.

Generics در Go از Go 1.18 افزوده شد. اگر package باید با toolchain قدیمی‌تر ساخته شود، generic syntax قابل‌استفاده نیست؛ نسخهٔ حداقل موردنیاز پروژه را در go.mod و راهنمای اجرا اعلام کن.

## ۲) type parameter و type argument

در تعریف تابع generic، type parameter داخل کروشه می‌آید. در زمان استفاده، type واقعی را type argument می‌نامیم. اگر compiler بتواند آن را از آرگومان‌های تابع نتیجه بگیرد، معمولاً نیازی به نوشتنش نیست.

</div>

~~~go
func First[T any](values []T) (T, bool) {
	if len(values) == 0 {
		var zero T
		return zero, false
	}
	return values[0], true
}

func main() {
	number, ok := First([]int{8, 9})
	fmt.Println(number, ok) // 8 true

	word, ok := First([]string{"go"})
	fmt.Println(word, ok) // go true
}
~~~

<div dir="rtl">

<code>T</code> نام type parameter است؛ <code>any</code> constraint آن است. هر بار این تابع را با sliceای از یک نوع صدا می‌زنیم، compiler نسخهٔ type-safe همان عملیات را بررسی می‌کند. نتیجهٔ نوعی برمی‌گردد که با slice ورودی سازگار است. برای generic که type از ورودی قابل‌استنتاج نیست، می‌توان type argument را صریح نوشت.

## ۳) constraint: چه عملیاتی روی T مجازند؟

Type parameter فقط placeholder دلخواه نیست. Constraint می‌گوید کدام نوع‌ها مجازند و چه عملیات‌هایی برای همهٔ آن نوع‌ها معتبر است. <code>any</code> هر نوعی را می‌پذیرد، اما به‌تنهایی نمی‌گوید می‌توان آن را با <code>&lt;</code> مقایسه کرد یا با هم جمع زد. compiler فقط عملیاتی را می‌پذیرد که برای تمام typeهای set مجاز معتبر باشند.

</div>

~~~go
type Number interface {
	~int | ~int64 | ~float64
}

func Sum[T Number](values []T) T {
	var total T
	for _, value := range values {
		total += value
	}
	return total
}
~~~

<div dir="rtl">

Interface این مثال constraint است. خط <code>~int</code> همهٔ نوع‌هایی را می‌پذیرد که underlying type آن‌ها <code>int</code> است، از جمله type تعریف‌شدهٔ خودمان:

</div>

~~~go
type UserID int

var ids = []UserID{2, 5, 8}
total := Sum(ids)
~~~

<div dir="rtl">

اگر به جای <code>~int</code> فقط <code>int</code> بنویسی، type تعریف‌شده‌ای مثل <code>UserID</code> عضو آن type term نیست. <code>~</code> عملیات را جادویی نمی‌کند؛ فقط مجموعهٔ typeهای مجاز constraint را گسترش می‌دهد. عبارت type termها باید در همهٔ typeهای مجاز عملیات بدنه را معتبر نگه دارد.

## ۴) constraint استاندارد یا constraint محلی؟

برای مقایسهٔ نوع‌های مرتب‌شدنی، کتابخانهٔ استاندارد از Go 1.21 پکیج <code>cmp</code> و constraintی مانند <code>cmp.Ordered</code> دارد. اگر پروژه Go 1.21 یا جدیدتر را هدف می‌گیرد، به جای تعریف دوبارهٔ فهرست نوع‌های ordered از نسخهٔ استاندارد مناسب استفاده کن.

</div>

~~~go
import "cmp"

func Minimum[T cmp.Ordered](a, b T) T {
	if a < b {
		return a
	}
	return b
}
~~~

<div dir="rtl">

نسخهٔ حداقلی Go مهم است. ممکن است الگوریتم عمومی در Go 1.18 کار کند، ولی نام constraint یا helper کتابخانهٔ استاندارد در نسخهٔ تازه‌تری اضافه شده باشد. برای APIهای استاندارد به صفحهٔ رسمی همان پکیج مراجعه کن.

## ۵) type generic: دادهٔ وابسته به یک نوع

Type نیز می‌تواند type parameter داشته باشد. مثلاً Set مجموعه‌ای از elementهای یکتا است. چون map key باید قابل‌مقایسه باشد، <code>E comparable</code> در این مثال ضرورت دارد.

</div>

~~~go
type Set[E comparable] map[E]struct{}

func (s Set[E]) Add(value E) {
	s[value] = struct{}{}
}

func (s Set[E]) Contains(value E) bool {
	_, ok := s[value]
	return ok
}

func main() {
	words := Set[string]{}
	words.Add("go")
	fmt.Println(words.Contains("go")) // true
}
~~~

<div dir="rtl">

<code>struct{}</code> مقدار بدون payload است؛ وجود کلید در map نشان‌دهندهٔ عضویت است و برای هر عضو مقدار اضافی معنی‌داری نگه نمی‌دارد. این پیاده‌سازی Set از نظر طراحی ساده است، ولی map صفرشده nil است و در آن نمی‌توان کلید نوشت. پس نمونه با literal خالی ساخته شده؛ متد <code>Add</code> در نسخهٔ واقعی باید در قرارداد بگوید receiver باید initialize شده باشد یا متد خودش nil map را با ساختن map جایگزین کند و map تازه را برگرداند.

Type generic می‌تواند متد داشته باشد. از Go 1.27 متد نیز می‌تواند type parameter مستقل خودش را بعد از نام متد تعریف کند؛ متد علاوه بر پارامترهای type گیرنده، پارامترهای خودش را دارد. نمونهٔ Map روی List:

~~~go
type List[E any] []E

func (list List[E]) Map[R any](convert func(E) R) List[R] {
	result := make(List[R], len(list))
	for index, value := range list {
		result[index] = convert(value)
	}
	return result
}

numbers := List[int]{1, 2, 3}
words := numbers.Map(func(value int) string {
	return strconv.Itoa(value)
})
~~~

Compiler می‌تواند <code>R</code> را از نوع خروجی callback استنتاج کند. Interface declaration در Go 1.27 هنوز نمی‌تواند متدی با type parameter مستقل اعلام کند و generic method، متد interface generic را implement نمی‌کند؛ method را پیش از فراخوانی یا استفاده به‌عنوان value باید instantiate کرد. در moduleهایی با language version پایین‌تر از 1.27، متد generic در دسترس نیست؛ تابع مستقل generic راه سازگارتر است.
## ۶) comparable و محدودیت‌های کلید

<code>comparable</code> typeهایی را می‌پذیرد که با <code>==</code> و <code>!=</code> قابل مقایسه‌اند. این constraint برای کلید map و الگوریتم‌هایی مثل Set مناسب است. Slice و map و function قابل‌مقایسه نیستند، پس نمی‌توانند کلید معمول map باشند. struct/array قابل‌مقایسه‌اند اگر تمام field/elementهایشان قابل‌مقایسه باشند.

از مقایسه‌پذیری به‌عنوان proxy «برابری domain» استفاده نکن. مثلاً دو struct ممکن است از نظر byte-for-byte برابر باشند اما در مفهوم business باید بر اساس شناسه مقایسه شوند.

## ۷) type inference

Compiler در بسیاری از callها type argument را از آرگومان‌های تابع نتیجه می‌گیرد. این باعث می‌شود استفادهٔ روزمره کوتاه باشد، درحالی‌که تعریف همچنان type-safe است.

</div>

~~~go
func Pair[A, B any](first A, second B) (A, B) {
	return first, second
}

name, age := Pair("Sara", 28)
~~~

<div dir="rtl">

در مثال، compiler از <code>"Sara"</code> به <code>string</code> و از <code>28</code> به <code>int</code> می‌رسد. اگر inference ممکن نباشد یا call خوانایی لازم داشته باشد، می‌توانی <code>Pair[string, int](...)</code> بنویسی. مجبورکردن type argument صریح در همهٔ callها معمولاً مزیتی ندارد.

## ۸) محدودیت و زبان design

مفهوم مهم در constraint فقط «این typeها را بپذیر» نیست؛ «بدنه اجازه دارد چه عملی انجام دهد» هم هست. اگر constraint تنها <code>any</code> باشد، بدنه نمی‌تواند فرض کند T قابلیت جمع، مرتب‌سازی، indexing یا متد خاصی دارد. باید رفتار را از constraint بگیرد.

برای رفتار متدی، constraint می‌تواند method set را تعریف کند. برای عملگرهایی مانند جمع یا مقایسه، type set termهای مناسب را تعریف می‌کند. هرچه constraint پیچیده‌تر شود، فهم call و error compile سخت‌تر می‌شود؛ آن را به کوچک‌ترین set لازم محدود کن.

## ۹) generic یا interface یا کد مشخص؟

Generics برای الگوریتم یا data structureی است که با چند type کار می‌کند و منطقش مستقل از رفتار خاص آن‌هاست: مجموعه، تبدیل slice، جست‌وجو، sort یا helper مشابه. Interface برای مصرف رفتاری است که چند پیاده‌سازی ممکن دارند: Reader، Clock، Store یا Sender. کد مشخص برای یک مسئلهٔ خاص خواناتر است.

این قاعده راهنمای شروع است، نه قانون مطلق. generic را برای «شاید یک روز لازم شد» نساز. از خودت بپرس:

- آیا منطق یکسانی را واقعاً برای چند نوع تکرار کرده‌ام؟
- آیا interface رفتار باثباتی را بیان می‌کند؟
- آیا generic compile-time type safety را حفظ می‌کند؟
- آیا caller مجبور می‌شود constraint دشواری بفهمد؟
- آیا دو پیاده‌سازی ساده خواناتر از یک abstraction پیچیده‌اند؟

Generic جایگزین interface و dynamic dispatch نیست؛ همچنین همهٔ کدهای Go نیازمند generic نیستند. طراحی را با ساده‌ترین قرارداد قابل‌فهم شروع کن.

## خطاهای رایج

- استفاده از <code>any</code> و انتظار عملگرهایی که همهٔ نوع‌ها ندارند.
- فراموش‌کردن constraint لازم برای عملگر بدنه.
- تصور اینکه <code>~T</code> با T یکسان است.
- تعریف یک constraint عظیم که هر نوعی را به زور پوشش می‌دهد.
- ساخت generic صرفاً برای حذف چند خط تکرار خوانا.
- استفاده از generic برای جایگزینی رفتار runtime و interfaceهای مرزی.
- فرض‌کردن type inference هرجا ممکن است.
- فراموش‌کردن حداقل نسخهٔ Go موردنیاز.
- استفاده از type به‌عنوان map key بدون توجه به semantics برابری.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: آخرین مقدار

تابع generic بنویس که آخرین عنصر slice را با bool وجود برگرداند. برای slice خالی zero value از نوع T را بده.

~~~go
func Last[T any](values []T) (T, bool) {
	if len(values) == 0 {
		var zero T
		return zero, false
	}
	return values[len(values)-1], true
}
~~~

### تمرین ۲: شمارش مقدارهای برابر

تابع genericی بنویس که تعداد دفعات ظاهرشدن یک مقدار را بشمارد. پاسخ باید constraint <code>comparable</code> داشته باشد.

~~~go
func Count[T comparable](values []T, target T) int {
	count := 0
	for _, value := range values {
		if value == target {
			count++
		}
	}
	return count
}
~~~

### تمرین ۳: Set ایمن از nil

متد <code>Add</code> در Set map nil را نمی‌تواند بنویسد. یک constructor <code>NewSet</code> اضافه کن یا Add را طوری طراحی کن که Set صفرشده را پشتیبانی کند.

**پاسخ ممکن:** اگر Set یک defined map type است، متد نمی‌تواند خود map nil caller را از طریق value receiver جایگزین کند. constructor و الزام initialize‌شدن را مستند کن، یا type را struct شامل map کن و receiver pointer داشته باش تا map داخلی را lazy initialize کند.

### تمرین ۴: انتخاب درست

برای هر مورد یکی را انتخاب کن: generic، interface یا کد مشخص.  
الف) الگوریتم پیدا کردن آخرین عضو برای slice از هر نوع. ب) مصرف‌کننده‌ای که از فایل و شبکه byte می‌خواند. ج) تابع تبدیل یک مدل اختصاصی domain با یک کاربرد.

**پاسخ:** الف generic؛ ب interface رفتار مانند <code>io.Reader</code>؛ ج معمولاً کد مشخص.

## کوییز

### پرسش‌ها

1. type parameter در کدام بخش declaration می‌آید؟
2. type argument چیست؟
3. چه زمانی compiler type inference انجام می‌دهد؟
4. <code>any</code> چه constraintی را بیان می‌کند؟
5. آیا <code>any</code> به تنهایی مجوز جمع کردن T را می‌دهد؟
6. constraint چه دو نقشی دارد؟
7. <code>~int</code> چه typeهایی را می‌پذیرد؟
8. چرا <code>UserID int</code> با constraint <code>~int</code> سازگار است؟
9. چرا Set map-based به <code>comparable</code> نیاز دارد؟
10. کدام نوع‌ها نمی‌توانند کلید map باشند؟
11. از کدام نسخه Go generic در دسترس است؟
12. در چه زمانی type argument را صریح می‌نویسیم؟
13. آیا type generic می‌تواند متد داشته باشد؟
14. آیا متد می‌تواند type parameter تازهٔ دلخواه تعریف کند؟
15. چه تفاوت عملی میان generic و interface وجود دارد؟
16. چرا generic برای «آینده شاید لازم شود» معمولاً تصمیم خوبی نیست؟
17. چرا type قابل مقایسه الزاماً برابری domain را نشان نمی‌دهد؟
18. چه چیزی را باید برای استفاده از <code>cmp.Ordered</code> بررسی کرد؟
19. generic method از کدام نسخهٔ Go در دسترس است؟
20. آیا interface می‌تواند متد generic را declare کند یا با آن satisfy شود؟

### کلید پاسخ

1. داخل کروشه پس از نام تابع یا type.
2. type واقعی‌ای که به جای type parameter در استفاده قرار می‌گیرد.
3. وقتی ورودی‌ها و constraintها اطلاعات کافی برای استنتاج type بدهند.
4. هر type.
5. خیر؛ باید عملیات برای همهٔ typeهای مجاز تعریف شده باشد.
6. set نوع‌های قابل‌قبول را تعیین می‌کند و عملیات مجاز بدنه را محدود می‌کند.
7. typeهایی با underlying type برابر int.
8. چون underlying type آن int است.
9. چون key map باید قابل مقایسه باشد.
10. slice، map و function و struct/arrayهای دارای عنصر غیرقابل‌مقایسه.
11. Go 1.18.
12. وقتی inference ممکن نیست یا نوشتن آن خوانایی call را بهتر می‌کند.
13. بله، methodهای type parameterهای همان type generic را استفاده می‌کنند.
14. از Go 1.27 بله؛ متد generic می‌تواند type parameterهای خودش را داشته باشد.
15. generic الگوریتم/data structure را برای typeهای مختلف type-safe می‌کند؛ interface نیاز رفتاری را در runtime بیان می‌کند.
16. abstraction، constraint و سطح پیچیدگی اضافه می‌کند پیش از آنکه تنوع واقعی وجود داشته باشد.
17. برابری نحوی ممکن است با برابری معنایی/business متفاوت باشد.
18. حداقل نسخهٔ Go و API رسمی همان نسخه را.
19. Go 1.27.
20. خیر؛ interface method نمی‌تواند type parameter مستقل داشته باشد و generic method آن را implement نمی‌کند.

## منابع

- انگلیسی: [Go specification — Type parameters](https://go.dev/ref/spec#Type_parameter_declarations)
- انگلیسی: [Go specification — Constraints](https://go.dev/ref/spec#Interface_types)
- انگلیسی: [Go blog — An Introduction to Generics](https://go.dev/blog/intro-generics)
- انگلیسی: [Go 1.27 — Generic Methods](https://go.dev/blog/generic-methods)
- انگلیسی: [Go 1.27 release notes](https://go.dev/doc/go1.27)
- انگلیسی: [Go documentation — cmp](https://pkg.go.dev/cmp)
- انگلیسی: [Go documentation — slices](https://pkg.go.dev/slices)
- فارسی: [GoFarsi — generics](https://cloud-book.gofarsi.ir/chapter-2/)
- فارسی: [GoFarsi — داده‌های مجموعه‌ای](https://cloud-book.gofarsi.ir/chapter-2/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
