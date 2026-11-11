# ۳.۲ — string، UTF-8، rune و متن چندزبانه

<div dir="rtl">

**زمان:** ۹۰ دقیقه · **پیش‌نیاز:** عددها و slice · **هدف:** بفهمی string چیست، چه زمانی با byte/rune کار کنی و متن را بدون بریدن UTF-8 پردازش کنی.

## ۱) string آرایهٔ حروف نیست

در Go یک <code>string</code> دنبالهٔ immutable از byteهاست. معمولاً متن Unicode به شکل UTF-8 داخلش قرار می‌گیرد، اما نوع string تضمین نمی‌کند byteها UTF-8 معتبر باشند. <code>len(s)</code> تعداد byte را می‌دهد؛ index مثل <code>s[0]</code> یک byte می‌دهد. در UTF-8، code pointهای غیر ASCII چند byte مصرف می‌کنند.

</div>

~~~go
package main

import (
	"fmt"
	"unicode/utf8"
)

func main() {
	s := "Go فارسی"
	fmt.Println("bytes:", len(s))
	fmt.Println("runes:", utf8.RuneCountInString(s))
	for index, r := range s {
		fmt.Printf("byte-index=%d rune=%U %q\n", index, r, r)
	}
}
~~~

<div dir="rtl">

<code>range</code> روی string با مرز UTF-8 حرکت می‌کند و هر بار index آغازین byte و rune را می‌دهد. indexهای rune پشت سر هم نیستند؛ مثلاً حرف فارسی ممکن است index بعدی را چند byte جلوتر ببرد. اگر رشته UTF-8 خراب باشد، decoder در range از <code>utf8.RuneError</code> استفاده می‌کند؛ برای اعتبارسنجی صریح <code>utf8.ValidString</code> داریم.

## ۲) سه اندازهٔ متفاوت

- **byte length:** اندازهٔ ذخیره‌سازی UTF-8؛ با <code>len(s)</code>.
- **rune count:** تعداد Unicode code point؛ با <code>utf8.RuneCountInString(s)</code> یا range.
- **grapheme count:** تعداد خوشه‌های متنی که کاربر معمولاً یک نویسه می‌بیند؛ ممکن است چند rune ترکیب شوند.

Emoji مرکب، حروف با علامت ترکیبی و متن‌های فارسی ممکن است در این شمارش‌ها تفاوت داشته باشند. برای محدودیت payload بر اساس byte، <code>len</code> درست است؛ برای حرکت روی code point از range؛ برای محدودیت UI بر اساس نویسهٔ دیداری به Unicode grapheme segmentation نیاز داری.

## ۳) string immutable است؛ []byte قابل تغییر

</div>

~~~go
text := "cat"
bytes := []byte(text)
bytes[0] = 'b'
fmt.Println(text, string(bytes)) // cat bat
~~~

<div dir="rtl">

تبدیل به <code>[]byte</code> یک دنبالهٔ قابل تغییر می‌دهد؛ string اولیه عوض نمی‌شود. تبدیل‌ها ممکن است allocation داشته باشند. در پردازش پرحجم، profile بگیر و صرفاً برای صرفه‌جویی خیالی از unsafe استفاده نکن.

## ۴) نوشتن و اتصال رشته

برای تعداد کمی اتصال از <code>+</code> خوانا است. در loop بزرگ، <code>strings.Builder</code> می‌تواند allocationهای مکرر را کمتر کند:

</div>

~~~go
var b strings.Builder
for _, name := range names {
	b.WriteString(name)
	b.WriteByte('\n')
}
result := b.String()
~~~

<div dir="rtl">

Builder را پس از ساخت string خروجی دوباره Reset/تغییر نده، و از کپی‌کردن <code>strings.Builder</code> پس از استفاده خودداری کن. معمولاً <code>strings.Join(parts, separator)</code> از loop دستی واضح‌تر است.

## ۵) literalهای رشته

- <code>"hello\n"</code> interpreted string است و escape مثل <code>\n</code> پردازش می‌شود.
- raw string که با backtick نوشته شود، backslash و newline را literal نگه می‌دارد. برای متن چندخطی و regex خام مفید است؛ خود backtick را نمی‌توان مستقیم داخل raw literal قرار داد.

## ۶) APIهای مفید استاندارد

<code>strings.TrimSpace</code> فاصلهٔ دو سوی متن را برمی‌دارد؛ <code>Fields</code> بر اساس whitespace جدا می‌کند؛ <code>Split</code> بر اساس separator دقیق می‌شکند؛ <code>Cut</code> متن را در اولین جداکننده به دو بخش می‌دهد؛ <code>Contains</code> عضویت زیررشته را بررسی می‌کند. انتخاب تابع مهم است: برای CSV quoting، تقسیم سادهٔ <code>strings.Split(line, ",")</code> parser کامل CSV نیست؛ از <code>encoding/csv</code> استفاده کن.

</div>

~~~go
left, right, found := strings.Cut("id=42", "=")
if found {
	fmt.Println(left, right)
}
~~~

<div dir="rtl">

## فارسی و normalization

دو رشته ممکن است از نظر byte متفاوت باشند اما در ظاهر شبیه نمایش داده شوند؛ مثلاً شکل‌های متفاوت ی/ک عربی و فارسی یا ترکیب حرف و اعراب. <code>strings.EqualFold</code> case folding را برای Unicode بررسی می‌کند، ولی مسئلهٔ normalization و قواعد زبان را کامل حل نمی‌کند. برای جست‌وجوی دقیق فارسی ممکن است normalization لازم باشد؛ آن را با قواعد محصول و کتابخانهٔ مناسب طراحی کن، نه با جایگزینی بی‌قاعدهٔ همهٔ حروف در هر context.

## باگ رایج: بریدن با byte index دلخواه

<code>prefix := s[:n]</code> امن است فقط وقتی n مرز byte معتبر و سیاست موردنظر byte-based باشد. اگر n وسط encoding افتد، رشتهٔ UTF-8 خراب می‌شود. برای کوتاه‌کردن بر اساس code point:

</div>

~~~go
func runePrefix(s string, maxRunes int) string {
	if maxRunes <= 0 {
		return ""
	}
	count := 0
	for i := range s {
		if count == maxRunes {
			return s[:i]
		}
		count++
	}
	return s
}
~~~

<div dir="rtl">

این تابع code point می‌شمارد، نه grapheme دیداری. در Go، <code>range</code> index شروع هر rune را می‌دهد؛ پس خروجی در مرزهای decodeشده بریده می‌شود. اگر API باید UTF-8 معتبر بپذیرد، اول <code>utf8.ValidString</code> را بررسی کن.

## تمرین با پاسخ

**۱.** طول byte و rune متن <code>"Go فارسی"</code> را جدا چاپ کن.

پاسخ: <code>len(s)</code> و <code>utf8.RuneCountInString(s)</code>؛ این دو مقدار برابر نیستند.

**۲.** چرا <code>string(65)</code> عدد ده‌دهی را چاپ نمی‌کند؟

پاسخ: conversion عدد به string یک code point می‌سازد. برای نمایش عدد از <code>strconv.Itoa(65)</code> استفاده کن.

**۳.** نام ستون‌های یک CSV را جدا کن. آیا <code>strings.Split</code> کافی است؟

پاسخ: اگر CSV quoting/comma داخل field دارد، نه؛ <code>encoding/csv.Reader</code> را استفاده کن.

## کوییز

### پرسش‌ها

1. <code>len(string)</code> چه چیزی را می‌شمارد؟
2. <code>s[0]</code> چه چیزی برمی‌گرداند؟
3. <code>for range</code> روی string چه دو مقداری می‌دهد؟
4. rune با grapheme چه تفاوتی دارد؟
5. آیا string نوع Go صحت UTF-8 را تضمین می‌کند؟
6. چرا تبدیل string به <code>[]byte</code> دادهٔ اولیه را تغییر نمی‌دهد؟
7. برای اتصال تکه‌های زیاد رشته چه ابزارهایی داری؟
8. raw string چه رفتاری با backslash و newline دارد؟
9. چرا <code>strings.Split</code> parser عمومی CSV نیست؟
10. با <code>s[:n]</code> چه نوع مرزی را باید رعایت کرد؟
11. برای اعتبارسنجی UTF-8 چه تابعی هست؟
12. آیا <code>RuneCountInString</code> تعداد نویسه‌های دیداری UI را دقیق می‌دهد؟

### کلید پاسخ

1. تعداد byte.
2. یک byte.
3. index آغازین byte و rune.
4. code point در برابر خوشهٔ متنی دیداری؛ خوشه می‌تواند چند rune باشد.
5. خیر.
6. string immutable است و تبدیل به byte slice mutable مستقل می‌دهد.
7. <code>strings.Builder</code> یا <code>strings.Join</code> بسته به مسئله.
8. backslash و newline را literal نگه می‌دارد.
9. چون field quoted می‌تواند comma و newline داشته باشد؛ parser CSV قواعد کامل دارد.
10. مرز معتبر UTF-8، مگر عمدی byte-based کار کنی.
11. <code>utf8.ValidString</code>.
12. خیر؛ grapheme segmentation لازم است.

## منابع

- [Strings, bytes, runes and characters in Go](https://go.dev/blog/strings)
- [unicode/utf8](https://pkg.go.dev/unicode/utf8) · [strings](https://pkg.go.dev/strings)
- فارسی: [GoFarsi — string](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [Tarhche — رشته‌ها](https://tarhche.com/fa/articles/018fabe7-3e27-7e5a-b2ae-d7445f617fc1)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
