# ۳.۳ — map، کلیدها و comma-ok

<div dir="rtl">

**زمان:** ۹۰ دقیقه · **پیش‌نیاز:** متغیر، function و slice · **هدف:** نگاشت بسازی، نبودن کلید را از مقدار صفر تفکیک کنی و ترتیب/هم‌روندی را درست مدیریت کنی.

## ۱) مدل map

Map نگاشت key به value است؛ برای شمارش، index و lookup مناسب است. نوع آن <code>map[K]V</code> است و key باید comparable باشد: مثلاً عدد، string، pointer، struct قابل‌مقایسه و interfaceهای دارای مقدار comparable. slice، map و function key معتبر نیستند. keyهای float از نظر فنی مجازند اما NaN با خودش برابر نیست؛ برای index معمولاً انتخاب خوبی نیست.

</div>

~~~go
package main

import "fmt"

func main() {
	scores := map[string]int{} // map خالی و قابل نوشتن
	scores["blue"] = 4
	scores["blue"]++
	fmt.Println(scores["blue"])
}
~~~

<div dir="rtl">

zero value یک map برابر nil است. خواندن از nil map امن است و value zero می‌دهد؛ نوشتن panic می‌کند. برای ساخت map قابل نوشتن از literal یا <code>make</code> استفاده کن. ظرفیت در make راهنمای allocation است، نه طول اولیه و نه تضمین layout.

</div>

~~~go
scores := map[string]int{}          // literal
ages := make(map[string]int, 100)   // hint تقریبی ظرفیت
initial := map[string]int{"Ada": 36, "Lin": 28}
~~~

<div dir="rtl">

## ۲) افزودن، خواندن، حذف و مقدار صفر

</div>

~~~go
scores := make(map[string]int)
scores["blue"] = 4
delete(scores, "missing") // حذف کلید غایب هم مجاز است
fmt.Println(scores["unknown"]) // 0
~~~

<div dir="rtl">

خواندن کلید غایب zero value نوع V را برمی‌گرداند؛ اگر zero value معنی‌دار است باید وجود کلید را جدا بخوانی. این الگو **comma-ok** نام دارد:

</div>

~~~go
value, ok := scores["blue"]
if !ok {
	fmt.Println("no score recorded")
} else {
	fmt.Println("score:", value)
}
~~~

<div dir="rtl">

<code>ok</code> وقتی key وجود دارد true است، حتی اگر value برابر صفر یا nil باشد. pattern مشابه در type assertion و channel receive هم هست.

## ۳) مقدار map و update struct

اگر value از نوع struct باشد، خواندن آن مقدار را کپی می‌کند؛ field را مستقیم از map تغییر نمی‌دهی. الگو: value را بخوان، field را تغییر بده، سپس value را دوباره در map قرار بده. اگر pointer به object ذخیره کنی، mutation مشترک خواهد بود؛ lifecycle و ownership را روشن کن.

## ۴) ترتیب پیمایش ثابت نیست

<code>for range</code> روی map ترتیب قراردادی نمی‌دهد. خروجی CLI، JSON array یا snapshot تست را مستقیماً از map چاپ نکن اگر deterministic order لازم است. keyها را در slice کپی و sort کن.

</div>

~~~go
keys := make([]string, 0, len(scores))
for name := range scores {
	keys = append(keys, name)
}
sort.Strings(keys)
for _, name := range keys {
	fmt.Println(name, scores[name])
}
~~~

<div dir="rtl">

## ۵) هم‌روندی

map عادی برای دسترسی concurrent که حداقل یک goroutine می‌نویسد بدون synchronization امن نیست. راه رایج: state را پشت <code>sync.Mutex</code> نگه‌دار؛ یا کارها را به goroutine مالک بسپار و با channel پیام بده. <code>sync.Map</code> type-agnostic و مناسب چند الگوی خاص read-mostly/independent-key است؛ جای پیش‌فرض همهٔ mapها نیست. با <code>go test -race ./...</code> داده‌رقابتی را در مسیرهای آزموده‌شده جست‌وجو کن.

عملیات ترکیبی مانند «اگر key نبود، بساز و مقدارش را افزایش بده» باید اتمیک باشد. قفل‌کردن فقط assignment کافی نیست اگر lookup و update با هم invariant می‌سازند.

## ۶) برنامهٔ کامل شمارش واژه

</div>

~~~go
package main

import (
	"fmt"
	"sort"
	"strings"
)

func countWords(text string) map[string]int {
	counts := make(map[string]int)
	for _, word := range strings.Fields(strings.ToLower(text)) {
		counts[word]++
	}
	return counts
}

func main() {
	counts := countWords("Go is simple and Go is fast")
	keys := make([]string, 0, len(counts))
	for word := range counts {
		keys = append(keys, word)
	}
	sort.Strings(keys)
	for _, word := range keys {
		fmt.Printf("%s: %d\n", word, counts[word])
	}
}
~~~

<div dir="rtl">

<code>make</code> map خالی می‌سازد. <code>Fields</code> ورودی را با whitespace جدا می‌کند. map value از نوع int است و خواندن key غایب zero یعنی صفر می‌دهد؛ بنابراین افزایش بار اول از صفر آغاز می‌شود. پیش از چاپ keyها sort می‌شوند تا خروجی پایدار باشد. <code>ToLower</code> ساده‌سازی نمونه است و همهٔ قاعده‌های Unicode را برای هر زبان پوشش نمی‌دهد.

## خطاهای رایج

- map nil را خواندن می‌توان، نوشتن نمی‌توان.
- iteration map را sorted فرض می‌کنی.
- چند goroutine map مشترک را می‌نویسند؛ race رخ می‌دهد.
- value struct را می‌خوانی و انتظار داری تغییر field خودکار برگردد.
- <code>ok</code> را حذف می‌کنی درحالی‌که zero value و key غایب فرق دارند.
- <code>sync.Map</code> را بدون نیاز، جایگزین map عادی می‌کنی.

## تمرین با پاسخ

**۱.** تعداد درخواست‌های هر status را نگه‌دار؛ اگر status هنوز وجود ندارد با صفر آغاز شود.

پاسخ: <code>counts := make(map[string]int)</code> و در هر درخواست <code>counts[status]++</code>.

**۲.** چرا <code>map[string][]string</code> برای index tagها مفید است؟

پاسخ: یک key می‌تواند چند value داشته باشد. مقدار nil slice هم appendپذیر است؛ سپس باید slice برگشتی را در map قرار دهی: <code>m[k] = append(m[k], v)</code>.

**۳.** آیا خواندن map هم‌زمان با نوشتن امن است؟

پاسخ: نه؛ تمام دسترسی‌هایی را که با write هم‌پوشانی دارند با mutex یا channel هماهنگ کن.

## کوییز

### پرسش‌ها

1. zero value یک map چیست؟
2. خواندن از map nil چه می‌دهد؟
3. نوشتن به map nil چه می‌کند؟
4. comma-ok کدام ابهام را برطرف می‌کند؟
5. آیا map iteration مرتب است؟
6. چرا <code>map[[]byte]int</code> معتبر نیست؟
7. چطور keyهای خروجی را deterministic چاپ می‌کنی؟
8. چرا update struct value در map نیاز به assignment دوباره دارد؟
9. map عادی برای read هم‌زمان با write امن است؟
10. <code>sync.Map</code> چه وقت ممکن است مناسب باشد؟
11. آیا delete کلید غایب خطاست؟
12. برای key float چه مورد خاصی باید بدانی؟

### کلید پاسخ

1. nil.
2. zero value نوع value.
3. panic.
4. نبودن key را از value zero تفکیک می‌کند.
5. خیر.
6. slice comparable نیست.
7. keyها را در slice جمع، sort و سپس براساس آن‌ها پیمایش کن.
8. مقدار struct هنگام خواندن کپی می‌شود.
9. خیر، synchronization لازم است.
10. در الگوهای محدود مانند read-mostly یا keyهای مستقل؛ معیار و benchmark لازم است.
11. خیر.
12. NaN با خودش برابر نیست؛ lookup/equality رفتار غافلگیرکننده می‌شود.

## منابع

- [Go maps in action](https://go.dev/blog/maps)
- [Go specification: map types](https://go.dev/ref/spec#Map_types)
- [sync.Map](https://pkg.go.dev/sync#Map)
- فارسی: [GoFarsi — map](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [Tarhche — map](https://tarhche.com/fa/articles/018fabef-c30e-7e5a-9e5d-65c3bf0a4c7b)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
