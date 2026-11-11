# ۳.۱ — آرایه، slice و مالکیت داده

<div dir="rtl">

**زمان:** ۱۲۰ دقیقه · **پیش‌نیاز:** متغیر و نوع · **هدف:** فرق array و slice را در ذهن نگه داری، aliasing را پیش‌بینی کنی و در API مرز مالکیت را مشخص کنی.

## ۱) Array: طول بخشی از نوع است

<code>[3]int</code> و <code>[4]int</code> دو نوع متفاوت‌اند. آرایه مقدار است: انتساب یا ارسال آرایه به تابع، عناصر را کپی می‌کند. آرایه برای اندازهٔ ثابت و محدود می‌تواند مفید باشد؛ در برنامه‌های روزمره slice انعطاف بیشتری دارد.

</div>

~~~go
var a [3]int
b := [3]int{10, 20, 30}
c := b
c[0] = 99
fmt.Println(a, b, c)
~~~

<div dir="rtl">

<code>b</code> همچنان <code>[10 20 30]</code> است چون انتساب array آن را کپی کرد. zero value آرایه، آرایه‌ای است که همهٔ عنصرهایش zero value نوع عنصر هستند.

## ۲) Slice: نمایی به آرایهٔ پشتیبان

Slice خودِ داده نیست؛ descriptorای شامل pointer به بخشی از backing array، <code>len</code> و <code>cap</code> است. برش‌زدن یا انتساب slice، descriptor را کپی می‌کند اما عناصر backing array را clone نمی‌کند. به همین دلیل mutation از یک نما ممکن است در نماهای دیگر دیده شود.

</div>

~~~go
package main

import "fmt"

func main() {
	data := [5]int{10, 20, 30, 40, 50}
	view := data[1:4]
	fmt.Println("view:", view, "len:", len(view), "cap:", cap(view))

	view[0] = 99
	fmt.Println("data after view write:", data)

	clone := append([]int(nil), view...)
	clone[0] = 7
	fmt.Println("view:", view, "clone:", clone)
}
~~~

<div dir="rtl">

خروجی:

</div>

~~~text
view: [20 30 40] len: 3 cap: 4
data after view write: [10 99 30 40 50]
view: [99 30 40] clone: [7 30 40]
~~~

<div dir="rtl">

<code>data[1:4]</code> شامل indexهای ۱، ۲ و ۳ است؛ انتهای slice exclusive است. ظرفیت view از index آغاز تا انتهای array می‌رسد: <code>cap=4</code>. clone با append به slice تازه، عناصر را مستقل کپی کرده است.

## ۳) make، literal، nil و empty

</div>

~~~go
var nilSlice []int
empty := []int{}
ready := make([]int, 0, 8)
values := make([]int, 3, 5)
~~~

<div dir="rtl">

- nil slice مقدار صفر slice است: <code>len=0</code>, <code>cap=0</code>, و <code>s == nil</code> درست است.
- empty slice مقداردهی‌شده ولی بدون عنصر است: <code>len=0</code>, اما <code>s == nil</code> نادرست.
- <code>make([]int, 3, 5)</code> طول سه می‌سازد و سه عنصر اول zero value هستند؛ ظرفیت تا پنج عنصر جا دارد.
- <code>append</code> به nil slice مجاز است و slice نتیجه را باید نگه داشت.

در JSON، nil slice اغلب به <code>null</code> و empty slice به <code>[]</code> تبدیل می‌شود. این تفاوت برای API contract مهم است.

## ۴) append، ظرفیت و سه-index slice

<code>append(s, values...)</code> slice نتیجه را برمی‌گرداند. اگر capacity کافی است، ممکن است backing array مشترک بماند؛ اگر کافی نیست، runtime آرایهٔ تازه می‌سازد. الگوریتم رشد ظرفیت جزئیات implementation است؛ روی مقدار دقیق cap بعد از append تکیه نکن.

سه-index slice مانند <code>s[low:high:max]</code> سقف ظرفیت نما را محدود می‌کند. این کار می‌تواند append روی نما را مجبور کند backing array تازه بسازد و دادهٔ همسایه را تصادفاً overwrite نکند؛ ولی مرز مالکیت کامل ایجاد نمی‌کند مگر عناصر را clone کنی.

</div>

~~~go
base := []int{1, 2, 3, 4}
left := base[:2:2] // len=2 cap=2
left = append(left, 99)
// left backing array تازه می‌گیرد؛ base[2] overwrite نمی‌شود.
~~~

<div dir="rtl">

## ۵) کپی، حذف و تابع‌ها

برای clone مستقل از نسخهٔ Go می‌توانی از <code>append([]T(nil), s...)</code> یا <code>copy</code> استفاده کنی. در Goهای جدید package استاندارد <code>slices</code> عملیات عمومی مانند <code>Clone</code>, <code>Sort</code>, <code>Delete</code> دارد. <code>slices.Delete</code> ترتیب را نگه می‌دارد و عناصر بعدی را جابه‌جا می‌کند؛ اگر ترتیب لازم نیست، الگوی swap-with-last سریع‌تر است اما ترتیب را خراب می‌کند.

وقتی slice را به تابع می‌دهی header به‌صورت value کپی می‌شود، اما داده می‌تواند مشترک بماند. تغییر عنصر را caller می‌بیند؛ اگر تابع append کند و capacity تمام شود، backing array تازه می‌سازد و caller باید slice برگشتی را بگیرد.

### تبدیل array و slice

با <code>array[:]</code> نمای slice از آرایه می‌گیری؛ داده کپی نمی‌شود و تغییر خانهٔ slice روی همان آرایه اثر می‌گذارد:

~~~go
array := [3]int{10, 20, 30}
view := array[:]
view[0] = 99
fmt.Println(array) // [99 20 30]
~~~

از Go 1.17 می‌توان slice را به pointer آرایه تبدیل کرد؛ pointer و slice همان عناصر backing array را می‌بینند و اگر طول slice از N کمتر باشد، تبدیل panic می‌کند. از Go 1.20 تبدیل مستقیم به array نیز موجود است؛ در آن حالت عناصر کپی می‌شوند و طول ناکافی باز هم panic می‌دهد:

~~~go
values := []int{4, 5, 6}
pointer := (*[3]int)(values) // Go 1.17+
copyArray := [3]int(values)  // Go 1.20+
pointer[0] = 7               // values[0] نیز 7 می‌شود
copyArray[1] = 8             // values[1] بدون تغییر می‌ماند
~~~

پیش از تبدیل، <code>len(values) &gt;= N</code> را کنترل کن؛ قابل‌تبدیل‌بودن type به معنی بی‌خطر بودن طول ورودی نیست. برای سازگاری با Go قدیمی‌تر، length را بررسی و با <code>copy</code> منتقل کن.
## ۶) retention: برش کوچک، آرایهٔ بزرگ

اگر slice یک جزء کوچک از آرایهٔ یک‌میلیونی باشد، reference همان slice می‌تواند backing array بزرگ را زنده نگه دارد. اگر مقدار کوچک را مدت طولانی ذخیره می‌کنی، clone کردن می‌تواند حافظهٔ اضافه را آزادپذیر کند. این را با heap profile بسنج؛ clone بی‌دلیل هم allocation می‌سازد.

## مثال حذف با حفظ ترتیب

</div>

~~~go
package main

import (
	"fmt"
	"slices"
)

func main() {
	items := []string{"a", "b", "c", "d"}
	items = slices.Delete(items, 1, 2) // بازهٔ [1,2): فقط b حذف می‌شود
	fmt.Println(items)
}
~~~

<div dir="rtl">

خروجی <code>[a c d]</code> است. <code>slices</code> در standard library از Go 1.21 به بعد موجود است. در Go قدیمی‌تر باید جابه‌جایی/کپی را بنویسی. API حذف را به نسخهٔ module/toolchain و go.mod وصل کن.

## خطاهای رایج

- index خارج از <code>[0, len)</code> باعث panic می‌شود.
- slice دو بعدی را با <code>make([][]T, rows)</code> می‌سازی اما هر ردیف nil می‌ماند تا جداگانه مقداردهی شود.
- append می‌کنی ولی مقدار برگشتی را نمی‌گیری.
- slice داخلی struct را بیرون می‌دهی و caller state داخلی را تغییر می‌دهد.
- برای فرستادن داده به goroutine، مالکیت و عمر buffer را مشخص نمی‌کنی.

## تمرین با پاسخ

**۱.** سه عدد آخر را از slice بگیر و مستقل برگردان.

~~~go
func lastThreeCopy(s []int) []int {
	if len(s) <= 3 { return append([]int(nil), s...) }
	return append([]int(nil), s[len(s)-3:]...)
}
~~~

**۲.** چرا <code>s = append(s, x)</code> داخل تابع ممکن است caller را به‌روز نکند؟

پاسخ: header ورودی به‌صورت value کپی شده؛ اگر append backing array جدید بسازد، فقط header محلی به آن اشاره دارد. slice جدید را return کن.

**۳.** خروجی API باید <code>[]</code> باشد، نه <code>null</code>. چه کار می‌کنی؟

پاسخ: مقدار خالی non-nil مثل <code>make([]T, 0)</code> برگردان یا در مرز serialization آن را normalize کن.

## کوییز

### پرسش‌ها

1. چرا <code>[3]int</code> با <code>[4]int</code> قابل انتساب مستقیم نیست؟
2. هنگام کپی slice چه چیزی کپی و چه چیزی share می‌شود؟
3. در <code>s[a:b]</code> index <code>b</code> داخل برش هست؟
4. <code>len</code> و <code>cap</code> چه تفاوتی دارند؟
5. آیا <code>append</code> همیشه backing array را بزرگ می‌کند؟
6. چرا باید مقدار برگشتی append را نگه داشت؟
7. چگونه slice مستقلی از داده می‌سازی؟
8. سه-index slice چه بخشی را محدود می‌کند؟
9. چرا slice کوچک می‌تواند حافظهٔ زیادی نگه دارد؟
10. تفاوت nil slice و empty slice در JSON معمولاً چیست؟
11. آیا تابعی که slice می‌گیرد می‌تواند عنصر را تغییر دهد؟
12. <code>slices.Delete</code> ترتیب را حفظ می‌کند؟
13. تفاوت تبدیل slice به pointer آرایه و تبدیل مستقیم به array چیست؟
14. تبدیل slice به pointer آرایه از چه نسخه‌ای است و شرط runtime آن چیست؟

### کلید پاسخ

1. طول در نوع array بخشی از type است.
2. header کپی و backing array مشترک می‌شود.
3. نه؛ high endpoint exclusive است.
4. len تعداد عناصر قابل index؛ cap حد رشد تا backing array موجود.
5. خیر؛ اگر ظرفیت کافی است ممکن است همان array استفاده شود.
6. چون append ممکن است descriptor/backing array تازه برگرداند.
7. <code>slices.Clone(s)</code> یا copy/append به buffer تازه.
8. حداکثر capacity را کم می‌کند، نه مرز mutation دادهٔ موجود را.
9. reference آن کل backing array را reachable نگه می‌دارد.
10. nil معمولاً null و empty non-nil معمولاً <code>[]</code>.
11. بله، چون عنصرها در backing array مشترک‌اند.
12. بله؛ برای حذف با جابه‌جایی عناصر بعدی.
13. pointer به همان backing array اشاره می‌کند؛ array مستقل عناصر را کپی می‌کند.
14. Go 1.17؛ طول slice باید دست‌کم N باشد وگرنه panic رخ می‌دهد. تبدیل مستقیم slice به array از Go 1.20 است.

## منابع

- [Go Slices: usage and internals](https://go.dev/blog/slices-intro)
- [package slices](https://pkg.go.dev/slices) · [Specification: slice types](https://go.dev/ref/spec#Slice_types) · [slice-to-array conversions](https://go.dev/ref/spec#Conversions_from_slice_to_array_or_array_pointer)
- فارسی: [GoFarsi — آرایه و slice](https://book.gofarsi.ir/chapter-1/go-array/)
- فارسی: [Tarhche — slice](https://tarhche.com/fa/articles/018fabef-c30e-7e5a-9e5d-65c3bf0a4c7b)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
