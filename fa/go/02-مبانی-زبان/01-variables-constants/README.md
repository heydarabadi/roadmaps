# ۲.۱ — متغیر، مقدار صفر، ثابت و محدودهٔ دید

<div dir="rtl">

**زمان:** ۹۰ دقیقه · **پیش‌نیاز:** آشنایی با برنامه و تابع `main` · **هدف:** مقدار را نگه داری، اعلان مناسب را انتخاب کنی و با scope/constant خطای پنهان نسازی.

## ۱) متغیر را چگونه تصور کنیم؟

متغیر یک نام متصل به مکانی است که در طول برنامه یک مقدار از نوع مشخص نگه می‌دارد. نوع اجازه می‌دهد compiler عملیات ناسازگار را رد کند. در Go متغیر محلی را نمی‌توان فقط اعلان کرد و رها کرد؛ اگر مقدارش استفاده نشود ممکن است compiler خطای unused بدهد. این قانون عمداً متغیرهای فراموش‌شده را آشکار می‌کند.

سه شکل اعلان:

</div>

```go
var count int = 4  // نوع و مقدار هر دو مشخص‌اند
var name string    // مقدار صفر می‌گیرد
count = 5          // انتساب به متغیر موجود

limit := 12        // فقط داخل تابع؛ نوع از literal استنباط می‌شود
```

<div dir="rtl">

`var` را زمانی بگیر که نوع را روشن می‌کنی، در package scope اعلان داری یا مقدار بعداً می‌رسد. `:=` کوتاه‌تر است و برای متغیر محلی با مقدار آغازین مناسب است. `:=` عملگر assignment ساده نیست: declaration می‌کند. برای تغییر مقدار موجود از `=` استفاده کن.

</div>

## ۲) برنامهٔ کامل برای مشاهدهٔ zero value


```go
package main

import "fmt"

func main() {
	var count int
	var enabled bool
	var label string
	var pointer *int
	var values []int
	var lookup map[string]int

	fmt.Printf("int=%d bool=%t string=%q pointer=%v slice=%#v map=%v\n",
		count, enabled, label, pointer, values, lookup)

	values = append(values, 7) // append به slice nil مجاز است
	lookup = make(map[string]int)
	lookup["ok"] = 1
	fmt.Println(values, lookup["ok"])
}
```

<div dir="rtl">

خروجی نمونه:

</div>

```text
int=0 bool=false string="" pointer=<nil> slice=[]int(nil) map=map[]
[7] 1
```

<div dir="rtl">

مقدار صفر (zero value) مقدار آغازین خودکار است: عددها صفر، bool برابر false، رشته خالی، pointer/interface/function/channel/map برابر nil و struct از zero value فیلدهایش تشکیل می‌شود. خواندن map nil مجاز است و zero value می‌دهد، اما نوشتن روی آن panic می‌کند. append روی slice nil کار می‌کند و خودش slice آماده برمی‌گرداند. این رفتارها باعث می‌شوند بعضی typeها بدون constructor قابل استفاده باشند.

## ۳) scope یعنی چه؟

scope محدوده‌ای است که یک نام در آن قابل استفاده است: فایل/package، تابع، یا بلوک‌های `{}` مثل if/for. نام داخلی ممکن است نام بیرونی را **shadow** کند. این کد از نظر زبان معتبر اما از نظر نتیجه bugدار است:

</div>

```go
package main

import "fmt"

func main() {
	status := "pending"
	if true {
		status := "paid" // متغیر جدید در بلوک if
		fmt.Println("داخل:", status)
	}
	fmt.Println("بیرون:", status)
}
```

<div dir="rtl">

خروجی `داخل: paid` و `بیرون: pending` است. `:=` در بلوک داخلی متغیر جدید ساخته است. اگر می‌خواستیم بیرونی را تغییر دهیم، باید درون if بنویسیم `status = "paid"`. یکی از اشتباه‌های مشهور همین است:

</div>

```go
var err error
if condition {
	result, err := doWork() // result تازه است؛ err هم در scope داخلی تازه تعریف می‌شود
	_ = result
	_ = err
}
// err بیرونی هنوز nil است
```

<div dir="rtl">

برای تشخیص shadowing، خط را بلند بخوان: آیا نام سمت چپ از قبل در همین block وجود دارد؟ اگر چند مقدار بازگشتی داری، حداقل یک نام تازه لازم است تا `:=` مجاز باشد. `go vet` بعضی از موارد مشکوک را گزارش می‌کند، اما قانون را باید خودت بفهمی.

## ۴) `const` و `iota`

ثابت مقداری است که در زمان کامپایل معلوم باشد و در اجرا تغییر نکند. ثابت‌های Go مقدارهای عددی، رشته‌ای، rune و bool هستند؛ مقدارهای runtime مثل `time.Now()` را نمی‌توان const کرد.

</div>

```go
const maxRetries = 4
const serviceName = "catalog"

const (
	StatusUnknown = iota // 0
	StatusQueued         // 1
	StatusPaid           // 2
	StatusSent           // 3
)
```

<div dir="rtl">

`iota` شمارندهٔ هر const block است و با هر specification جلو می‌رود. این راه برای شناسه‌های ساده مناسب است، اما عددهای ذخیره‌شده در دیتابیس/API را بی‌فکر جابه‌جا نکن؛ افزودن یا حذف عضو وسط enum می‌تواند قرارداد پایدار را بشکند. اگر مقدار wire-format قرارداد دارد، مقدارها را صریح و با دقت مدیریت کن.

## ۵) تایپ‌گذاری، نام‌گذاری و `_`

</div>

```go
var age int = 30
var score float64 = 97.5
nickname := "Pouya"
_, err := fmt.Println(nickname, age, score)
if err != nil {
	// در برنامهٔ واقعی تصمیم مناسب بگیر؛ مثال فقط برای نمایش خروجی تابع است.
}
```

<div dir="rtl">

`_` blank identifier است و مقدار را عمداً دور می‌اندازد. در production خطا را به `_` نده مگر دلیل روشن داشته باشی. نامی که با حرف بزرگ شروع می‌شود از package صادر می‌شود (`UserID`)، حرف کوچک محلی می‌ماند (`userID`). Go از MixedCaps استفاده می‌کند، نه snake_case. نام کوتاه وقتی scope کوتاه است مناسب است؛ نامی که قرارداد عمومی را توضیح می‌دهد بهتر است روشن باشد.

## خطاهای رایج

- استفاده از `:=` در package scope؛ مجاز نیست.
- تلاش برای تغییر مقدار ثابت یا تعریف const با مقدار runtime.
- فرض اینکه `var m map[...]...` برای نوشتن آماده است؛ map nil است.
- تعریف دوبارهٔ `err` ناخواسته و shadowing خطا.
- استفاده از `=` برای متغیری که هنوز تعریف نشده یا `:=` برای تغییر تنها متغیر موجود.
- حذف خطا با `_` و نادیده‌گرفتن رفتار واقعی تابع.

## تمرین با پاسخ

**۱.** zero value یک `struct{ Count int; Ready bool }` چیست؟

پاسخ: `struct{Count: 0, Ready: false}`؛ یعنی مقدار صفر همهٔ fieldها.

**۲.** برنامه‌ای بنویس که مقدار اولیهٔ map را امن کند.

پاسخ: `scores := make(map[string]int)` یا `scores := map[string]int{}`؛ هر دو map قابل نوشتن می‌سازند.

**۳.** چرا این کد صفر چاپ می‌کند؟ `total := 0; if ok { total := 10 }; fmt.Println(total)`

پاسخ: `total := 10` در scope داخلی متغیر تازه می‌سازد. اگر هدف تغییر outer است، `total = 10` بنویس.

## کوییز

### پرسش‌ها

1. `var x int` چه مقداری می‌گیرد؟
2. تفاوت `:=` با `=` چیست؟
3. `:=` در کدام محدوده مجاز است؟
4. آیا خواندن key از map nil مجاز است؟ نتیجه چیست؟
5. آیا نوشتن روی map nil مجاز است؟
6. مقدار zero یک string و یک `*T` چیست؟
7. `iota` از کجا دوباره صفر می‌شود؟
8. آیا `const now = time.Now()` معتبر است؟ چرا؟
9. در `a, err := f()` چه شرطی لازم است تا `:=` compile شود؟
10. چه زمانی استفاده از `_` برای error خطرناک است؟
11. `Status` و `status` در package API از نظر export چه فرقی دارند?
12. چرا enum ذخیره‌شده در API را فقط با `iota` و ترتیب تغییرپذیر نسازیم؟

### کلید پاسخ

1. صفر.
2. `:=` اعلان محلی همراه مقداردهی و استنباط نوع؛ `=` انتساب به نام از پیش تعریف‌شده.
3. داخل تابع.
4. بله؛ مقدار zero نوع map value را می‌دهد.
5. خیر؛ panic می‌شود.
6. رشتهٔ خالی `""` و pointer برابر nil.
7. در آغاز هر const block.
8. نه؛ const باید compile-time constant باشد.
9. دست‌کم یک شناسهٔ تازه در سمت چپ لازم است.
10. وقتی failure باید retry، گزارش، rollback یا به caller منتقل شود.
11. نام بزرگ export و از بیرون package قابل دسترسی است؛ کوچک export نمی‌شود.
12. تغییر ترتیب مقدار wire/database را عوض می‌کند و داده‌های قبلی را ناسازگار می‌سازد.

## منابع

- [Tour: Variables](https://go.dev/tour/basics/8) · [Constants](https://go.dev/ref/spec#Constant_declarations) · [Short variable declarations](https://go.dev/ref/spec#Short_variable_declarations)
- فارسی: [GoFarsi — متغیر و مقدار صفر](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [Tarhche — متغیرها](https://tarhche.com/fa/articles/018fabe7-3e27-7e5a-b2ae-d7445f617fc1)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
