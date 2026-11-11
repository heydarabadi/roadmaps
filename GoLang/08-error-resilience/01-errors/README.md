# ۸.۱ — طراحی و مدیریت خطا در Go

<div dir="rtl">

**زمان پیشنهادی:** ۱۵۰ دقیقه · **پیش‌نیاز:** تابع، چند مقدار بازگشتی، package و interface  
**هدف:** شکست را بخشی از قرارداد API بدانی، خطا را با context منتقل کنی و caller را قادر کنی بر اساس علت تصمیم بگیرد.

## نقشهٔ این درس

- error به‌عنوان مقدار
- ساختن و برگرداندن خطا
- خطای ورودی و اعتبارسنجی
- sentinel error
- type error اختصاصی
- wrapping، <code>%w</code>، <code>errors.Is</code> و <code>errors.As</code>
- مقایسهٔ error با متن
- سیاست retry، log و context
- error چندگانه
- خطا در مرز HTTP و storage

## ۱) error یک نتیجهٔ عادی تابع است

در Go، خطا معمولاً panic نیست. تابعی که ممکن است شکست بخورد، یک <code>error</code> در خروجی خود دارد. مقدار موفقیت را همراه با <code>nil</code> error برمی‌گرداند و caller فوراً آن را بررسی می‌کند.

</div>

~~~go
func divide(a, b int) (int, error) {
	if b == 0 {
		return 0, errors.New("تقسیم بر صفر مجاز نیست")
	}
	return a / b, nil
}
~~~

<div dir="rtl">

caller:

</div>

~~~go
result, err := divide(20, 4)
if err != nil {
	return fmt.Errorf("محاسبهٔ گزارش: %w", err)
}
fmt.Println(result)
~~~

<div dir="rtl">

نتیجه را قبل از بررسی خطا مصرف نکن. مقدار صفر در خروجی همراه خطا می‌تواند فقط یک placeholder قراردادی باشد و ارزش business نداشته باشد. قرارداد تابع مشخص می‌کند در شکست کدام خروجی معتبر می‌ماند.

## ۲) error ساده برای چه زمانی است؟

برای شکست عمومی که caller قرار نیست براساس هویت یا نوعش رفتار متفاوتی انجام دهد، <code>errors.New</code> یا <code>fmt.Errorf</code> با متن مناسب کافی است. متن error برای انسان و log است؛ شرط برنامه را با مقایسهٔ متن پیاده نکن، چون متن API پایدار و machine-readable نیست.

</div>

~~~go
if len(name) == 0 {
	return errors.New("نام خالی است")
}
~~~

<div dir="rtl">

در یک package، sentinel error یک مقدار خطای ازپیش‌تعریف‌شده است که caller می‌تواند با <code>errors.Is</code> بررسی کند. برای معنی‌هایی مثل «یافت نشد» یا «غیرمجاز»، فقط اگر caller واقعاً باید تصمیمی بگیرد آن را export کن.

</div>

~~~go
var ErrNotFound = errors.New("یافت نشد")

func findUser(id string) (User, error) {
	user, ok := users[id]
	if !ok {
		return User{}, ErrNotFound
	}
	return user, nil
}
~~~

<div dir="rtl">

caller باید با <code>errors.Is(err, ErrNotFound)</code> تطبیق دهد تا حتی پس از اضافه‌شدن context، علت را پیدا کند.

## ۳) خطای نوع‌دار برای دادهٔ بیشتر

اگر خطا اطلاعات ساخت‌یافته‌ای مانند نام field، شمارهٔ خط یا نوع ورودی دارد، نوع اختصاصی تعریف کن. آن را برای نمایش به کاربر نهایی یا branching استفاده نکن، مگر اینکه قراردادش مستند باشد.

</div>

~~~go
type ValidationError struct {
	Field string
	Why   string
}

func (e *ValidationError) Error() string {
	return e.Field + ": " + e.Why
}

func parseAge(text string) (int, error) {
	age, err := strconv.Atoi(text)
	if err != nil {
		return 0, &ValidationError{Field: "age", Why: "باید عدد باشد"}
	}
	if age < 0 {
		return 0, &ValidationError{Field: "age", Why: "نباید منفی باشد"}
	}
	return age, nil
}
~~~

<div dir="rtl">

caller با <code>errors.As</code> می‌تواند نوع را در chain پیدا کند:

</div>

~~~go
age, err := parseAge(input)
var validationErr *ValidationError
if errors.As(err, &validationErr) {
	fmt.Println("field:", validationErr.Field)
}
if err != nil {
	return err
}
_ = age
~~~

<div dir="rtl">

در کد واقعی، اگر <code>err</code> nil باشد، <code>errors.As</code> مقدار false می‌دهد؛ غالباً error را بررسی کن و type-specific پاسخ را مطابق قرارداد خروجی طراحی کن.

## ۴) wrapping: context اضافه کن، علت را حفظ کن

وقتی تابع خطای dependency را می‌گیرد و می‌خواهد نشان دهد کدام عملیات شکست خورده، خطا را با <code>%w</code> wrap کن. این باعث می‌شود caller بالاتر همچنان علت را با <code>errors.Is</code> یا <code>errors.As</code> تشخیص دهد.

</div>

~~~go
func loadConfig(path string) ([]byte, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("خواندن فایل تنظیمات %q: %w", path, err)
	}
	return data, nil
}
~~~

<div dir="rtl">

از <code>%v</code> برای نمایش error بدون حفظ wrapping استفاده کن، وقتی عمداً نمی‌خواهی جزئیات خطای زیرین بخشی از API شود. تبدیل به رشته و ساخت error تازه ممکن است machine-readable cause را از بین ببرد. wrapping یک تصمیم API است: با <code>%w</code> caller اجازه می‌یابد dependency error را تشخیص دهد.

### تفاوت Is و As

- <code>errors.Is(err, target)</code>: آیا خطا یا یکی از خطاهای زیرمجموعه با مقدار موردنظر match می‌شود؟
- <code>errors.As(err, &amp;target)</code>: آیا در زنجیره/درخت خطا نمونه‌ای از نوع موردنظر وجود دارد و می‌توان آن را در متغیر مقصد قرار داد؟

مقایسهٔ مستقیم <code>err == ErrNotFound</code> فقط هنگامی درست است که wrap وجود نداشته باشد و قرارداد همان مقایسهٔ مستقیم باشد. برای chain عمومی، <code>errors.Is</code> را به‌کار ببر.

## ۵) خطا را تبدیل به متن برای شرط نکن

این کار را نکن:

~~~go
if err != nil && strings.Contains(err.Error(), "not found") {
	// رفتار ویژه
}
~~~

</div>
<div dir="rtl">

متن می‌تواند عوض یا ترجمه شود؛ به جای آن sentinel با <code>errors.Is</code> یا type با <code>errors.As</code> بساز. همچنین پیام error نباید خودکار به پاسخ کاربر HTTP تبدیل شود؛ خطای database ممکن است نام table، SQL یا جزئیات داخلی را لو بدهد. در مرز API، خطای داخلی را به status code و پیام امن تبدیل کن و جزئیات را در log محافظت‌شده نگه دار.

## ۶) Stack trace و debugging خطا

خطای معمولی که با <code>errors.New</code> یا <code>fmt.Errorf</code> ساخته شده، به‌طور پیش‌فرض stack trace کامل همراه خود نگه نمی‌دارد. chain خطا با <code>%w</code> علت و context عملیاتی را منتقل می‌کند؛ stack trace پرسش دیگری را پاسخ می‌دهد: کدام مسیر فراخوانی panic یا خطا را تولید کرد؟ برای errorهای معمولی، مرزهای تابع را با context معنی‌دار wrap کن؛ اگر سیستم stack trace می‌خواهد، سیاست و dependency مشخصی برای capture داشته باش و آن را در هر لایه تکرار نکن.

در اجرای panic، runtime معمولاً stack را هنگام خاتمه چاپ می‌کند. اگر در مرز امن panic را recover می‌کنی و برای incident باید stack را ثبت کنی، <code>runtime/debug.Stack()</code> stack goroutine جاری را به byte slice می‌دهد:

~~~go
defer func() {
	if value := recover(); value != nil {
		log.Printf("panic=%v stack=%s", value, debug.Stack())
	}
}()
~~~

این snippet برای boundary کنترل‌شده است و باید پس از ثبت خطا، درخواست را failed کند؛ panic را موفقیت تلقی نکن. در debugging خطای معمولی: error chain را با <code>errors.Is/As</code> دنبال کن، ورودی و نسخه را ثبت کن، کوچک‌ترین reproduction بساز، test regression اضافه کن و در صورت نیاز debugger مانند Delve را به‌کار ببر. log باید request/trace ID داشته باشد ولی secret و payload حساس را ثبت نکند.
## ۷) retry بخشی از سیاست error است

داشتن error به تنهایی نمی‌گوید عملیات retryشدنی است. caller باید بداند شکست گذراست یا دائمی، عملیات idempotent است یا خیر، چه timeout و سقفی مجاز است، و آیا سامانه زیر بار است. Retry بی‌سقف می‌تواند خرابی را تشدید کند.

### تجربهٔ مستند از Google SRE

کتاب SRE گوگل توضیح می‌دهد clientها برای جلوگیری از retry storm از سقف تلاش در هر request، retry budget در سطح client و backoff استفاده می‌کنند. در مثال کتاب، تلاش مجدد می‌تواند بار ورودی را تا نزدیک سه برابر ببرد؛ budget نسبت retry را محدود می‌کند تا retry به عامل تشدید overload تبدیل نشود. این نمونه نشان می‌دهد error فقط متن نیست: نوع شکست، قرارداد retry و budget بخشی از طراحی availability است. جزئیات و اعداد وابسته به همان سناریوی مستندند، نه نسخهٔ آماده برای هر سرویس.

در کد Go، retry را در لایه‌ای انجام بده که می‌داند عملیات امن و تکرارپذیر است. timeout/context، سقف تلاش، backoff با jitter و cancellation را با هم طراحی کن. POST غیر-idempotent را بی‌فکر تکرار نکن؛ idempotency key یا قرارداد domain ممکن است لازم باشد.

## ۸) log و propagation

خطا را یا مدیریت کن، یا context بده و به caller بازگردان؛ در هر لایه یکسان log نکن. اگر هر package همان خطا را log کند، یک مشکل واحد به چند alert/log تبدیل می‌شود. معمولاً مرز نهاییِ درخواست یا worker جایی است که سیستم دربارهٔ پاسخ، retry، metric و logging تصمیم دارد.

از خطاهای بی‌زمینه مثل <code>return err</code> در مرزهای پیچیده پرهیز کن اگر caller نمی‌فهمد کدام عملیات شکست خورده؛ اما context بی‌فایدهٔ چندباره هم اضافه نکن. دادهٔ حساس، token، password، PII و payload خام را به پیام error یا log منتقل نکن.

## ۹) چند خطای هم‌زمان

از Go 1.20، <code>errors.Join</code> چند خطا را در یک درخت error جمع می‌کند. این برای اعتبارسنجی‌ای که همهٔ fieldها را بررسی می‌کند یا cleanupهای چندگانه مناسب است. خطاها را فقط هنگامی join کن که caller به دیدن بیش از یک شکست نیاز دارد.

</div>

~~~go
var problems []error
if email == "" {
	problems = append(problems, errors.New("email خالی است"))
}
if age < 0 {
	problems = append(problems, errors.New("age منفی است"))
}
if err := errors.Join(problems...); err != nil {
	return err
}
~~~

<div dir="rtl">

وقتی <code>problems</code> خالی باشد، <code>errors.Join</code> nil می‌دهد. برای جمع‌کردن چند cleanup مستقل از هم نیز می‌توانی خطاها را جمع و در پایان گزارش کنی؛ ترتیب و اولویت را طبق نیاز روشن کن.

## ۱۰) خطا در مرزهای سامانه

معمولاً نوع خام خطای داخلی را مستقیماً به protocol بیرونی نمی‌دهیم. نمونهٔ mapping در HTTP:

- ورودی نامعتبر → 400
- احراز هویت/مجوز ناکافی → 401/403
- resource موجود نیست → 404
- تعارض دامنه → 409
- محدودیت نرخ → 429
- اختلال dependency یا خطای پیش‌بینی‌نشده → پاسخ عمومی 5xx

این mapping مثال متداول است؛ تصمیم درست به contract API وابسته است. retry-after، trace ID و log ساخت‌یافته می‌تواند برای اپراتور/مشتری مفید باشد. خطای timeout در database را 404 نکن؛ خطای داخلی را بدون sanitize به response body نفرست.

## دام‌های رایج

- استفاده از panic برای ورودی نامعتبر موردانتظار.
- فراموش‌کردن بررسی error قبل از مصرف نتیجه.
- branch براساس متن <code>err.Error()</code>.
- wrap با <code>%v</code> و انتظار بازیابی علت با <code>errors.Is</code>.
- export کردن تمام خطاهای داخلی که API را قفل می‌کند.
- log کردن همان error در هر لایه.
- retry بی‌سقف یا روی عملیات غیر-idempotent.
- نمایش مستقیم خطای داخلی به کاربر.
- حذف context مفید با return خام در مرز مبهم.
- قرار دادن اطلاعات محرمانه داخل متن خطا.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: sentinel را wrap کن

تابعی <code>findUser</code> بساز که برای ID ناموجود <code>ErrNotFound</code> را wrap کند. caller باید همچنان آن را تشخیص دهد.

**راه‌حل:**

~~~go
if !ok {
	return User{}, fmt.Errorf("جست‌وجوی user با شناسهٔ %q: %w", id, ErrNotFound)
}

// caller:
if errors.Is(err, ErrNotFound) {
	// پاسخ 404 یا جریان business مناسب
}
~~~

### تمرین ۲: error ساخت‌یافته

برای خطای اعتبارسنجی، field و علت را در ValidationError نگه‌دار و با <code>errors.As</code> بازیابی کن. پاسخ: نمونهٔ کامل در بخش ۳.

### تمرین ۳: تصمیم retry

سه خطا را دسته‌بندی کن: «ورودی نامعتبر»، «connection reset»، «شناسه یافت نشد». کدام را retry می‌کنی؟

**پاسخ:** invalid input retry نمی‌شود؛ not found نیز معمولاً علت domain است و retry نمی‌خواهد؛ connection reset ممکن است گذرا باشد، اما فقط با سقف تلاش، backoff، deadline و اطمینان از تکرارپذیری عملیات retry کن.

### تمرین ۴: HTTP boundary

خطای SQL شامل نام جدول را به کاربر response نده. پاسخ: در log محافظت‌شده خطای داخلی را با trace/request ID ثبت کن؛ response عمومی 5xx با شناسهٔ پیگیری بده. از ثبت دادهٔ حساس خودداری کن.

## کوییز

### پرسش‌ها

1. در Go شکست تابع معمولاً چگونه بازنمایی می‌شود؟
2. error موفقیت چه مقداری دارد؟
3. چرا قبل از بررسی error نتیجه را مصرف نمی‌کنیم؟
4. چه وقت sentinel error مناسب است؟
5. چه وقت custom error type مناسب است؟
6. <code>%w</code> چه قابلیتی فراهم می‌کند؟
7. فرق عملی <code>errors.Is</code> و <code>errors.As</code> چیست؟
8. چرا مقایسهٔ متن خطا شکننده است؟
9. چه وقت عمداً از <code>%v</code> به جای <code>%w</code> استفاده می‌شود؟
10. wrapping خطای زیرین چه اثری بر API دارد؟
11. چرا retry را نباید در هر لایه انجام داد؟
12. چه شرایطی برای retry ایمن لازم است؟
13. مثال مستند Google SRE چه خطری را دربارهٔ retry نشان می‌دهد؟
14. چرا هر لایه نباید همان خطا را log کند؟
15. چرا خطای SQL خام را به HTTP client برنمی‌گردانیم؟
16. <code>errors.Join</code> از چه نسخه‌ای وجود دارد؟
17. چه زمانی خطاهای متعدد را join می‌کنیم؟
18. آیا connection reset همیشه باید retry شود؟

### کلید پاسخ

1. معمولاً به شکل خروجی <code>error</code> در کنار نتیجه.
2. nil.
3. چون در شکست، مقدار ممکن است نامعتبر باشد و contract آن را تضمین نکرده باشد.
4. وقتی caller باید یک علت محدود و پایدار را با <code>errors.Is</code> تشخیص دهد.
5. وقتی caller به دادهٔ ساخت‌یافته یا دسته‌بندی نوعی نیاز دارد.
6. زنجیرهٔ خطا را قابل‌بررسی نگه می‌دارد.
7. Is مقدار/علت قابل‌مقایسه را می‌یابد؛ As type مشخص را در chain پیدا و مقصد را مقداردهی می‌کند.
8. متن برای انسان است و در طول زمان تغییر می‌کند.
9. وقتی نمی‌خواهیم جزئیات cause زیرین بخشی از API قابل‌unwrap باشد.
10. caller می‌تواند dependency error را تشخیص دهد، پس implementation زیرین به‌نوعی در قرارداد بیرونی افشا می‌شود.
11. retryها ضرب و جمع شده و ممکن است بار را چند برابر کنند.
12. transient بودن، idempotency، سقف، deadline/backoff/jitter و cancellation.
13. retry می‌تواند overload را تشدید کند؛ بودجه و سقف تلاش لازم‌اند.
14. log و alert تکراری و پرنویز می‌شود؛ مدیریت معمولاً در یک مرز مناسب انجام می‌شود.
15. ممکن است جزئیات داخلی و اطلاعات حساس را افشا کند؛ خطا را به قرارداد بیرونی تبدیل کن.
16. Go 1.20.
17. وقتی چند شکست مستقل باید به caller نشان داده شوند.
18. خیر؛ باید policy، تکرارپذیری و deadline را در نظر گرفت.

## منابع

- انگلیسی: [Go Blog — Working with Errors in Go 1.13](https://go.dev/blog/go1.13-errors)
- انگلیسی: [Go documentation — package errors](https://pkg.go.dev/errors)
- انگلیسی: [Go diagnostics](https://go.dev/doc/diagnostics)
- انگلیسی: [Delve debugger](https://github.com/go-delve/delve)
- انگلیسی: [Google SRE Book — Handling Overload](https://sre.google/sre-book/handling-overload/)
- انگلیسی: [Google SRE Book — Addressing Cascading Failures](https://sre.google/sre-book/addressing-cascading-failures/)
- فارسی: [GoFarsi — آموزش Go و error handling](https://cloud-book.gofarsi.ir/chapter-3/)
- فارسی: [مجموعهٔ فارسی GoFarsi](https://book.gofarsi.ir/chapter-3/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
