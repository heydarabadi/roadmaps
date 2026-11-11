# ۲.۲ — نوع‌های داده و تبدیل

<div dir="rtl">

**زمان:** ۱۲۰ دقیقه · **پیش‌نیاز:** متغیرها · **هدف:** نوع مناسب انتخاب کنی، تبدیل صریح انجام دهی و خطای precision/range را بفهمی.

## ۱) نوع چه قراردادی می‌دهد؟

نوع تعیین می‌کند چه مقدارهایی معتبرند، چه عملیات‌هایی روی آن‌ها مجاز است و معمولاً چه رفتار حافظه‌ای دارند. Go نوع‌دهی ایستا دارد و بسیاری از نوع‌های نامرتبط را خودکار تبدیل نمی‌کند. این‌که مقدار `3` بتواند هم در `int` و هم در `float64` به کار رود به معنی سازگاری همیشگی این typeها نیست.

### نوع‌های پایه

- `bool`: فقط `true` یا `false`؛ Go مقدار عددی یا رشته را به شرط تبدیل ضمنی نمی‌کند.
- `string`: دنبالهٔ byte immutable؛ جزئیات Unicode در درس string آمده است.
- signed integer: `int`, `int8`, `int16`, `int32`, `int64`.
- unsigned integer: `uint`, `uint8`, `uint16`, `uint32`, `uint64`, `uintptr`.
- اعشاری: `float32`, `float64`.
- مختلط: `complex64`, `complex128`.
- aliasهای معنایی: `byte` برابر `uint8` و `rune` برابر `int32` است.

اندازهٔ `int` و `uint` به معماری وابسته است، پس برای فایل binary یا پروتکل شبکه‌ای که عرض ثابتی دارد `int32`/`int64` و encoding مشخص استفاده کن. `uintptr` برای آدرس‌های سطح پایین است، نه برای محاسبهٔ عادی یا ذخیرهٔ pointer پایدار.

## ۲) مثال نوع‌ها و خروجی

</div>

```go
package main

import "fmt"

func main() {
	var active bool = true
	var stock int32 = 12
	price := 4.75 // literal اعشاری اینجا float64 می‌شود
	var symbol rune = 'گ'
	var letter byte = 'G'

	total := float64(stock) * price
	fmt.Printf("active=%t stock=%d price=%.2f total=%.2f\n", active, stock, price, total)
	fmt.Printf("rune=%U byte=%d\n", symbol, letter)
}
```

<div dir="rtl">

خروجی:

</div>

```text
active=true stock=12 price=4.75 total=57.00
rune=U+06AF byte=71
```

<div dir="rtl">

`stock` نوع `int32` دارد. برای ضرب با `price` آن را صریح به float64 بردیم؛ حاصل اعشاری هم float64 است. `%d` عدد صحیح، `%f` اعشار و `%.2f` دو رقم اعشار چاپ می‌کند. `rune` code point حرف «گ» و `byte` مقدار ASCII حرف لاتین `G` را نگه می‌دارد.

## ۳) conversion با cast ضمنی فرق دارد

Go تبدیل عددی خودکار را محدود می‌کند:

</div>

```go
var count int = 5
var ratio float64 = float64(count) / 2
var small int8 = int8(200)
fmt.Println(ratio, small)
```

<div dir="rtl">

`ratio` برابر `2.5` است. مقدار `int8(200)` در بازهٔ signed 8-bit قرار ندارد؛ تبدیل عدد صحیح به نوع کوچک **range-check** نمی‌کند و بیت‌های پرارزش دور ریخته می‌شوند. نتیجه در Go یک مقدار wrapped/تفسیرشده بر اساس نوع است، نه error. بنابراین پیش از تبدیل دادهٔ ورودی را بررسی کن:

</div>

```go
func toInt8(n int) (int8, error) {
	if n < -128 || n > 127 {
		return 0, fmt.Errorf("%d outside int8 range", n)
	}
	return int8(n), nil
}
```

<div dir="rtl">

Conversion عدد به string هم به معنی چاپ ده‌دهی نیست: `string(65)` رشتهٔ حاوی code point 65 را می‌سازد، نه `"65"`. برای نمایش عدد از `strconv.Itoa`, `fmt.Sprint` یا formatter مناسب استفاده کن.

## ۴) typed و untyped constants

عدد literal مثل `5` در بسیاری از عبارت‌ها untyped constant است و تا زمان استفاده دقت و قابلیت بیشتری دارد. وقتی به متغیر می‌رسد نوع می‌گیرد. مثال:

</div>

```go
const secondsPerMinute = 60
const minutesPerHour = 60
const secondsPerHour = secondsPerMinute * minutesPerHour
```

<div dir="rtl">

ثابت‌ها compile-time هستند؛ برای پیکربندی‌ای که زمان اجرا عوض می‌شود از متغیر/ساختار config استفاده کن. ثابت عددی ممکن است در contextهای مختلف با نوع هدف متناسب شود، ولی متغیرهای typed خودکار با نوع دیگر مخلوط نمی‌شوند.

## ۵) float و پول

float دودویی بسیاری از کسرهای ده‌دهی را دقیق نمایش نمی‌دهد. برای نمونه ممکن است `0.1 + 0.2` دقیقاً `0.3` نباشد. مقایسهٔ float با `==` در الگوریتم‌های عددی نیازمند فهم tolerance است. برای مبلغ، الگوی رایج نگهداری کوچک‌ترین واحد صحیح است (مثلاً سنت)، یا type/کتابخانهٔ decimal با قواعد rounding روشن. واحد و rounding بخشی از قرارداد دامنه‌اند.

## ۶) typeهای معنایی خودت

</div>

```go
type UserID int64
type OrderID int64

func loadUser(id UserID) {}
```

<div dir="rtl">

هر دو پایهٔ `int64` دارند اما `UserID` و `OrderID` دو type جدا هستند؛ این کار اشتباه جابه‌جا کردن شناسه‌ها را در compile time محدود می‌کند. برای تبدیل باید صریح بنویسی `UserID(raw)`. اگر دو مقدار semantics متفاوت دارند، typeهای نام‌دار معمولاً از aliasهای مبهم بهترند.

## خطاهای رایج و تشخیص

- **`cannot use x as type Y`:** نوع واقعی را با `%T` چاپ کن، سپس تبدیل امن و صریح انجام بده.
- **عدد منفی در unsigned:** محدوده و sign را پیش از تبدیل بررسی کن.
- **overflow بی‌صدا در conversion:** input را با bound مقایسه کن؛ cast به تنهایی validation نیست.
- **مبلغ با float ناپایدار:** سیاست واحد، scale و rounding را تعریف کن.
- **`string(n)` متن عددی نمی‌دهد:** برای رقم‌نگاری از `strconv`/`fmt` استفاده کن.
- **فرض یکسان‌بودن `int` در amd64 و 32-bit:** قرارداد binary را با عرض ثابت بنویس.

## تمرین با پاسخ

**۱.** `int64` را برای `float64` تبدیل کن و نسبت را چاپ کن. چرا ممکن است مقدار دقیق integer بزرگ از دست برود؟

پاسخ: `f := float64(n)`؛ float64 همهٔ integerهای بزرگ را دقیق نمایش نمی‌دهد چون mantissa محدود دارد.

**۲.** رشتهٔ رقم‌ها را به integer تبدیل کن.

پاسخ: `n, err := strconv.Atoi(input)`؛ خطا را بررسی و محدودهٔ کاربردی را جدا validate کن.

**۳.** چرا `type CustomerID int64` مفید است؟

پاسخ: به compiler اجازه می‌دهد شناسهٔ سفارش را تصادفاً به تابعی که شناسهٔ مشتری می‌خواهد ندهیم.

## کوییز

### پرسش‌ها

1. چرا Go بین `int` و `float64` تبدیل خودکار نمی‌کند؟
2. اندازهٔ `int` به چه چیزی وابسته است؟
3. تفاوت `byte` و `rune` چیست؟
4. آیا `rune` همیشه یک حرف دیداری است؟
5. Conversion از عدد بزرگ به int8 چه تضمینی ندارد؟
6. برای چاپ عدد 65 به شکل `"65"` چه ابزارهایی به‌کار می‌رود؟
7. چرا float64 ممکن است برای مبلغ نامناسب باشد؟
8. `uintptr` را برای چه نوع کاری نگه می‌داریم؟
9. یک دلیل استفاده از named type برای ID چیست؟
10. برای تبدیل رشتهٔ ورودی به int همراه خطا چه تابعی مناسب است؟

### کلید پاسخ

1. تا مرز نوع و احتمال precision loss در کد آشکار بماند.
2. معماری/implementation هدف.
3. byte alias uint8 و rune alias int32 برای code point است.
4. خیر؛ grapheme ممکن است چند code point داشته باشد.
5. Range validation؛ cast می‌تواند truncate/wrap شود.
6. `strconv.Itoa`, `fmt.Sprint`, `fmt.Sprintf`.
7. بسیاری از کسرهای ده‌دهی دقیقاً binary-representable نیستند.
8. pointer/address arithmetic سطح پایین و APIهایی که صریحاً لازم دارند.
9. جلوگیری compile-time از اشتباه‌گرفتن شناسه‌های با معنای متفاوت.
10. `strconv.Atoi` یا `strconv.ParseInt` با bit size مشخص.

## منابع

- [Specification: numeric types](https://go.dev/ref/spec#Numeric_types)
- [Specification: conversions](https://go.dev/ref/spec#Conversions)
- [package strconv](https://pkg.go.dev/strconv) · [math/big](https://pkg.go.dev/math/big)
- فارسی: [GoFarsi — نوع‌های پایه](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [Tarhche — اعداد و انواع داده](https://tarhche.com/fa/articles/018fabe7-3e27-7e5a-b2ae-d7445f617fc1)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
