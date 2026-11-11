# ۵.۱ — pointer، حافظه و garbage collector

<div dir="rtl">

**زمان پیشنهادی:** ۱۳۵ دقیقه · **پیش‌نیاز:** متغیر، struct، تابع و slice  
**هدف:** آدرس را فقط وقتی لازم است به اشتراک بگذاری، nil را ایمن مدیریت کنی و رفتار GC را بدون افسانه‌های stack/heap توضیح بدهی.

## نقشهٔ این درس

- آدرس متغیر و نوع pointer
- dereference و تغییر مقدار
- nil و دسترسی امن
- تفاوت pointer با کپی struct
- pointer به آرایه، slice و map
- مالکیت و aliasing
- stack، heap و escape analysis
- garbage collector و چرخهٔ عمر حافظه
- طراحی API با pointer یا value

## ۱) pointer چیست؟

هر متغیر در زمان اجرا جایی برای نگه‌داری مقدار دارد. عملگر <code>&amp;</code> آدرس آن متغیر را می‌گیرد. نوع pointer با <code>*T</code> نوشته می‌شود و می‌گوید pointer به مقدار نوع <code>T</code> اشاره می‌کند. عملگر <code>*p</code> مقدار در آن آدرس را می‌خواند یا تغییر می‌دهد؛ به این عمل dereference می‌گویند.

</div>

~~~go
package main

import "fmt"

func main() {
	score := 10
	p := &score

	fmt.Println(*p) // 10
	*p = 25
	fmt.Println(score) // 25
}
~~~

<div dir="rtl">

متغیر <code>p</code> خود عدد ۱۰ را نگه نمی‌دارد؛ آدرس <code>score</code> را نگه می‌دارد. بنابراین نوشتن از مسیر <code>*p</code> همان متغیر را عوض می‌کند. آدرس معمولاً برای به‌اشتراک‌گذاری تغییر، نشان‌دادن نبودن یک مقدار یا جلوگیری از کپی ساختار بزرگ استفاده می‌شود؛ pointer به‌تنهایی الزاماً سریع‌تر یا بهتر نیست.

Go اجازهٔ محاسبات معمول روی pointer را نمی‌دهد؛ pointer را نمی‌توان مانند C با جمع یا تفریق جابه‌جا کرد. این محدودیت ایمنی و ساده‌بودن تحلیل را افزایش می‌دهد. package <code>unsafe</code> مسیرهای ویژه‌ای دارد، اما برای کد روزمره نیست.

## ۲) دریافت pointer در تابع

چون آرگومان تابع copy است، اگر تابع باید یک متغیر سادهٔ caller را تغییر دهد، pointer آن را بگیر. اگر تابع فقط مقدار را می‌خواند، value receiver یا پارامتر value معمولاً ساده‌تر است.

</div>

~~~go
func setToZero(value *int) {
	if value == nil {
		return
	}
	*value = 0
}

func main() {
	count := 7
	setToZero(&count)
	fmt.Println(count) // 0

	setToZero(nil) // امن؛ تابع nil را مدیریت می‌کند
}
~~~

<div dir="rtl">

ابتدا nil را بررسی می‌کنیم و بعد dereference. خود dereference کردن pointer برابر nil باعث panic می‌شود. لازم نیست هر تابعی که pointer می‌گیرد حتماً nil را بپذیرد؛ می‌توانی قرارداد کنی pointer باید non-nil باشد، اما آن شرط باید در API روشن و در مرز ورودی enforce شود.

## ۳) pointer به struct و سازنده

دسترسی به فیلد struct از طریق pointer به syntax خاصی نیاز ندارد؛ <code>p.Name</code> در Go مانند <code>(*p).Name</code> کار می‌کند. گرفتن آدرس struct محلی و برگرداندنش مجاز است؛ compiler/runtime عمر حافظه را به گونه‌ای مدیریت می‌کند که ارجاع زنده بماند.

</div>

~~~go
type User struct {
	Name string
}

func newUser(name string) *User {
	return &User{Name: name}
}

func rename(user *User, name string) {
	if user == nil {
		return
	}
	user.Name = name
}
~~~

<div dir="rtl">

در بسیاری از موارد <code>&amp;User{Name: name}</code> از <code>new(User)</code> خواناتر است، چون fieldها را همان‌جا مقداردهی می‌کند. <code>new(T)</code> pointer به مقدار صفرشدهٔ <code>T</code> می‌سازد؛ object را با fieldهای غیرصفر پیکربندی نمی‌کند. هر دو ابزارند، نه دستوری برای انتخاب stack یا heap.

## ۴) value یا pointer در API؟

برای انتخاب، این پرسش‌ها را بررسی کن:

- آیا تابع باید state اصلی را تغییر دهد؟ اگر بله، pointer یا یک API mutation آشکار لازم است.
- آیا نوع بزرگ است و کپی‌کردنش مهم است؟ pointer ممکن است از کپی پرهزینه جلوگیری کند، ولی هزینهٔ واقعی را با benchmark بسنج.
- آیا type مقدار صفرشدهٔ مفیدی دارد؟ value ساده‌تر می‌تواند خوب کار کند.
- آیا کپی‌شدن type خطرناک است؟ typeهایی با mutex، فایل باز یا state مالکیتی نباید پس از استفاده بی‌محابا کپی شوند.
- آیا pointer به‌دلیل کوچک‌سازی struct واقعاً لازم است؟ pointerهای nullable، aliasing و نگهداری objectهای heap را زیاد می‌کنند.

در Go قوانین اجبارآور «همیشه pointer» یا «هرگز pointer» وجود ندارد. متدها، اندازهٔ type، mutability، قرارداد nil و روش استفادهٔ package را با هم ببین. اگر همهٔ متدهای یک type pointer receiver دارند، غالباً متغیر را pointer بگیر تا interface satisfaction و mutation هماهنگ بماند.

## ۵) pointer با slice و map چه فرقی دارد؟

slice خودش یک مقدار کوچک شامل اشاره به backing array، طول و ظرفیت است. کپی slice همان header را کپی می‌کند و ممکن است هر دو header به آرایهٔ مشترک برسند. map نیز یک handle/reference-like مقدار برای دادهٔ map است. برای تغییر عناصر آن‌ها معمولاً لازم نیست pointer به slice یا map بگیری.

اگر لازم است خود slice را reslice کنی و طول تازه را به caller منتقل کنی، معمولاً slice جدید را برگردان:

</div>

~~~go
func appendName(names []string, name string) []string {
	return append(names, name)
}

// names = appendName(names, "Ada")
~~~

<div dir="rtl">

تابع بالا لازم نیست <code>*[]string</code> بگیرد؛ assignment نتیجه در caller طول تازه را نگه می‌دارد. pointer به slice فقط هنگامی توجیه دارد که واقعاً می‌خواهی header caller را از مسیر pointer تغییر دهی و API را چنین طراحی کرده‌ای. این قاعده دربارهٔ map نیز معمولاً برقرار است: map را مستقیم به تابع بده و محتوا را تغییر بده؛ pointer به map در موارد عادی اضافه‌کاری است.

## ۶) aliasing و مالکیت داده

Aliasing یعنی دو نام یا چند object به حافظهٔ قابل‌تغییر مشترک دسترسی دارند. این اشتراک می‌تواند عمدی باشد، اما منشأ باگ‌های «چرا این مقدار تغییر کرد؟» و data race است. قرارداد API باید تا حد امکان روشن کند:

- تابع فقط تا پایان call ورودی را می‌خواند یا آن را برای بعد نگه می‌دارد؟
- تابع ورودی را mutate می‌کند؟
- خروجی مستقل است یا حافظه را با ورودی شریک است؟
- اگر چند goroutine می‌نویسند، چه synchronizationی از داده محافظت می‌کند؟

برای برش مستقل می‌توان از <code>slices.Clone</code> در Go 1.21 به بعد استفاده کرد؛ clone سطحی است. اگر element خودش pointer، slice یا map باشد، دادهٔ تو در تو همچنان ممکن است مشترک باشد. Deep copy باید معنای نوع domain را تعریف کند و راه‌حل عمومی جادویی ندارد.

## ۷) stack، heap و escape analysis

برنامه‌نویس Go نباید بر اساس حدس «این متغیر قطعاً روی stack است» یا «برگرداندن pointer همیشه heap allocation دارد» correctness طراحی کند. compiler با تحلیل escape تصمیم می‌گیرد چه داده‌ای کجا قرار گیرد؛ نسخهٔ compiler، inlining و شکل کد روی تصمیم اثر دارند. زبان رفتار قابل‌مشاهده را مشخص می‌کند، نه همهٔ جایگذاری‌های فیزیکی حافظه را.

اصل مهم: اگر object پس از پایان scope لازم است، Go عمرش را حفظ می‌کند؛ garbage collector فقط وقتی حافظه را آزاد می‌کند که object دیگر از rootهای قابل‌دسترسی دنبال‌شدنی نباشد. فرار یک مقدار به heap خطا نیست. بهینه‌سازی allocation را پس از اندازه‌گیری انجام بده.

برای مشاهدهٔ allocation و escape message از ابزار compiler و benchmark استفاده کن، اما خروجی وابسته به نسخه را حکم دائمی برنامه تلقی نکن. رشد بی‌دلیل slice، تبدیل‌های مکرر، objectهای کوچک در loop پرتکرار یا نگه‌داشتن یک slice کوچک از آرایهٔ بسیار بزرگ می‌توانند مصرف حافظه را افزایش دهند.

## ۸) garbage collection: چه چیزی را تضمین می‌کند؟

Go دارای garbage collector خودکار است. وقتی دیگر راهی از متغیرهای زنده و rootهای runtime به object نرسد، آن object برای جمع‌آوری واجد شرایط است. جمع‌آوری دقیقاً در همان لحظهٔ از دست‌رفتن آخرین reference تضمین نمی‌شود. برای فایل، socket، lock یا تراکنش به GC تکیه نکن: منابع عملیاتی باید با <code>Close</code> یا الگوی <code>defer</code> صریح آزاد شوند.

GC دسترسی هم‌زمان ناامن را درست نمی‌کند. دو goroutine که بدون synchronization یک map معمولی را هم‌زمان می‌خوانند/می‌نویسند همچنان مشکل دارند. همچنین GC memory leak منطقی را رفع نمی‌کند: اگر cache یا global هنوز object را reachable نگه دارد، GC نمی‌داند که دیگر نمی‌خواهی‌اش.

از reset کردن pool یا ساخت حافظهٔ unsafe زودهنگام پرهیز کن. ابتدا رفتار مصرف حافظه را با profiling/metrics بسنج و طول عمر داده، اندازهٔ cache، buffer و referenceهای پنهان را بررسی کن.

## ۹) pointer و nil در طراحی typeها

هر pointer می‌تواند nil باشد، مگر قرارداد یا ساختار زبان مانع شود. nil گاهی حالت «مقدار وجود ندارد» را خوب نمایش می‌دهد؛ اما افزودن pointer به همهٔ فیلدها تعداد حالت‌های نامعتبر را بیشتر می‌کند. برای فیلد اختیاری، روشن کن تفاوت بین «مفقود»، «صفر»، و «صفرشدهٔ عمدی» چیست. در JSON، database و PATCH این تمایز ممکن است روی مدل اثر بگذارد.

هنگامی که pointer را دریافت می‌کنی، guard nil را در مرز مناسب انجام بده. panic ناشی از nil pointer معمولاً نشان‌دهندهٔ قرارداد نامشخص یا validation جاافتاده است، نه چیزی که باید به‌صورت عادی با recover پنهان شود.

## دام‌های رایج

- فرض اینکه pointer به معنی pass-by-reference زبان است؛ خود pointer هم با value کپی می‌شود.
- dereference کردن pointer nil.
- استفاده از pointer به slice/map بدون دلیل برای تغییر header.
- فرض کردن هر pointer-returning function الزاماً allocation مشخصی روی heap دارد.
- استفاده از GC برای بستن فایل یا آزادکردن منبع بیرونی.
- کپی‌کردن struct دارای mutex پس از شروع استفاده.
- ناآگاهی از aliasing دادهٔ ورودی و خروجی.
- تلاش برای «بهینه‌سازی» allocation بدون profile یا اندازه‌گیری.
- تصور اینکه garbage collector جلوی race یا leak منطقی را می‌گیرد.

## تمرین‌های مرحله‌ای با راه‌حل

### تمرین ۱: mutate واضح

تابعی بنویس که به یک شمارندهٔ غیرnil یک واحد اضافه کند و برای nil رفتار مشخص داشته باشد.

~~~go
func increment(value *int) bool {
	if value == nil {
		return false
	}
	*value++
	return true
}
~~~

در Go، عبارت <code>(*value)++</code> روشن‌تر از شکل فشرده است؛ نسخهٔ صریح:

~~~go
func increment(value *int) bool {
	if value == nil {
		return false
	}
	(*value)++
	return true
}
~~~

### تمرین ۲: خروجی مستقل

از یک slice کپی مستقل بساز تا تغییر خانهٔ کپی، ورودی را تغییر ندهد.

~~~go
func independentCopy(input []int) []int {
	return slices.Clone(input)
}
~~~

در Goهای قدیمی‌تر، <code>make</code> و <code>copy</code> را به‌کار ببر. برای nil، clone از nil معمولاً nil می‌دهد؛ contract برنامه را بررسی کن.

### تمرین ۳: علت تغییر را پیش‌بینی کن

تابع ورودی <code>[]int</code> می‌گیرد، خانهٔ صفر را عوض می‌کند و append می‌کند. مشخص کن کدام تغییر در caller دیده می‌شود. پاسخ: تغییر خانهٔ موجود در backing array مشترک قابل مشاهده است؛ append یک slice جدید برمی‌گرداند که caller باید دریافت کند تا طول جدید را داشته باشد. اگر append ظرفیت فعلی را رد کند، backing array جدید ساخته می‌شود.

### تمرین ۴: resource lifecycle

فایلی را باز کن، خطا را بررسی و بلافاصله <code>defer file.Close()</code> را پس از موفقیت open قرار بده. پاسخ مفهومی: <code>defer</code> فایل را در خروج تابع می‌بندد؛ GC جایگزین این قرارداد نیست.

## کوییز

### پرسش‌ها

1. <code>&amp;x</code> چه چیزی می‌سازد؟
2. <code>*p</code> چه عملی انجام می‌دهد؟
3. چرا pointer nil باید پیش از dereference بررسی شود؟
4. آیا آرگومان pointer در Go با reference منتقل می‌شود؟
5. چرا mutation یک struct از طریق pointer برای caller قابل‌مشاهده است؟
6. آیا برای append به slice معمولاً pointer به slice لازم است؟
7. slice کپی‌شده چه چیزی را با نسخهٔ اصلی ممکن است شریک بماند؟
8. escape analysis چیست؟
9. آیا زبان Go محل فیزیکی stack/heap هر متغیر را تضمین می‌کند؟
10. چه زمانی object برای GC قابل جمع‌آوری است؟
11. چرا برای بستن فایل نباید منتظر GC ماند؟
12. آیا GC یک data race را حل می‌کند؟
13. چرا یک slice کوچک ممکن است حافظهٔ آرایهٔ بزرگ را نگه دارد؟
14. clone سطحی چه چیزی را کپی نمی‌کند؟
15. چه زمانی pointer برای API انتخاب مناسبی است؟
16. چرا type دارای mutex را پس از استفاده کپی نمی‌کنیم؟

### کلید پاسخ

1. مقدار pointer به متغیر <code>x</code>.
2. مقدار اشاره‌شده را می‌خواند یا تغییر می‌دهد.
3. dereference nil panic ایجاد می‌کند.
4. خیر؛ خود pointer value کپی می‌شود، هر دو کپی می‌توانند به object مشترک اشاره کنند.
5. هر دو pointer به همان object می‌رسند.
6. خیر؛ slice جدید را return کن و caller آن را نگه دارد.
7. backing array را.
8. تحلیل compiler برای تشخیص اینکه مقداری باید از scope فراتر زنده بماند و روی heap قرار بگیرد یا نه.
9. خیر؛ جزئیات پیاده‌سازی و نسخهٔ compiler است.
10. وقتی دیگر از rootهای قابل‌دسترسی reachable نباشد؛ زمان جمع‌آوری دقیق تضمین نیست.
11. زمان GC تعیین نمی‌شود و منبع بیرونی باید صریح آزاد شود.
12. خیر؛ برای دسترسی هم‌زمان باید synchronization داشت.
13. چون header slice هنوز به backing array بزرگ اشاره می‌کند.
14. objectهای تو در تو یا داده‌ای که pointer/slice/map داخل element به آن می‌رسد؛ این‌ها ممکن است مشترک بمانند.
15. برای mutation صریح، نبودن اختیاری مقدار، یا جلوگیری از کپی پرهزینه پس از سنجش.
16. چون کپی lock state می‌تواند synchronization و قرارداد مالکیت را خراب کند.

## منابع

- انگلیسی: [Go specification — Address operators](https://go.dev/ref/spec#Address_operators)
- انگلیسی: [Go FAQ — stack or heap?](https://go.dev/doc/faq#stack_or_heap)
- انگلیسی: [Go GC guide](https://go.dev/doc/gc-guide)
- انگلیسی: [Go memory model](https://go.dev/ref/mem)
- فارسی: [GoFarsi — اشاره‌گرها](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [منبع فارسی — برش‌ها و دادهٔ مشترک](https://book.gofarsi.ir/chapter-1/go-array/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
