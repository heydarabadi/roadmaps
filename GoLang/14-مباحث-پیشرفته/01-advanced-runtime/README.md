# ۱۴.۱ — runtime، reflection، unsafe، cgo و plugin

<div dir="rtl">

**زمان پیشنهادی:** ۲۱۰ دقیقه · **پیش‌نیاز:** pointer/GC، interface/generics، build و profile  
**خط مبنای این بازبینی:** Go 1.27.4، منتشرشده در ۱۰ نوامبر ۲۰۲۶. جزئیات compiler و runtime implementation هستند و با releaseها تغییر می‌کنند.

## نقشهٔ این درس

- runtime، goroutine و GC در سطح مفهومی
- allocation و escape analysis
- profile پیش از بهینه‌سازی
- reflection و قواعد Value
- unsafe و محدودیت portability
- مرز Go/C و cgo pointer rules
- compiler/linker flags
- build constraints
- Go plugins و محدودیت deployment
- تجربه‌های تاریخی Twitch و Allegro

## ۱) قرارداد زبان در برابر پیاده‌سازی runtime

Go specification رفتار قابل‌مشاهدهٔ زبان را تعریف می‌کند؛ جزئیاتی مثل layout دقیق objectها، برنامهٔ تخصیص حافظه، مسیر scheduler و نحوهٔ بهینه‌سازی compiler جزو قرارداد ثابت نیستند. برنامه را به layout داخلی struct یا زمان دقیق اجرای GC وابسته نکن. وقتی performance یا debugging به جزئیات runtime نیاز دارد، نسخهٔ Go، OS و architecture را در آزمایش ثبت کن و فرض را با profile تأیید کن.

Go runtime اجرای goroutineها، تخصیص/مدیریت حافظه، stackهای goroutine، timerها و ارتباط با OS را پشتیبانی می‌کند. این پیچیدگی پشت مدل برنامه قرار دارد، اما مسئولیت طراحی lifecycle، lock، queue و resource همچنان با برنامه‌نویس است.

## ۲) allocation و escape analysis

Compiler تحلیل می‌کند آیا مقدار از scope خودش فراتر زنده می‌ماند. اگر لازم باشد، مقدار را جایی قرار می‌دهد که عمر مناسب داشته باشد؛ این تصمیم می‌تواند با شکل کد، inlining و نسخهٔ compiler تغییر کند. «هر متغیر local روی stack است» یا «هر return pointer حتماً heap allocation می‌سازد» قواعد قابل‌اتکا نیستند.

برای دیدن پیام escape در toolchain می‌توان اجرا کرد:

~~~powershell
go build -gcflags="-m=2" ./...
~~~

</div>
<div dir="rtl">

این خروجی diagnostic وابسته به نسخه و build است؛ آن را به API یا قرارداد برنامه تبدیل نکن. allocation count را با benchmark، <code>-benchmem</code> و memory profile بررسی کن. اگر heap بزرگ است، هم allocationها و هم retention را پیدا کن: یک slice کوچک ممکن است backing array بزرگ را زنده نگه دارد؛ cache/global ممکن است referenceی را نگه دارد که دیگر لازم نیست.

راه درست بهینه‌سازی: اول correctness، بعد baseline و profile، سپس یک تغییر کوچک و مقایسهٔ دوباره. کاهش allocation ممکن است CPU بیشتر، کد سخت‌تر یا bug ownership ایجاد کند؛ metrics هدف را هم‌زمان بسنج.

## ۳) GC چه می‌کند و چه نمی‌کند؟

Garbage collector objectهای reachable را دنبال می‌کند و حافظهٔ objectهایی را که دیگر reachable نیستند در زمانی که runtime انتخاب می‌کند بازیافت می‌کند. این زمان‌بندی تضمین لحظه‌ای نیست. GC منبع بیرونی مثل file، transaction، socket، lock یا goroutine را نمی‌بندد؛ lifecycle این‌ها باید صریح باشد.

GC race را رفع نمی‌کند و cacheای را که عمداً reference objectها را نگه داشته پاک نمی‌کند. فشار GC فقط یکی از هزینه‌های حافظه است؛ تعداد objectهای pointer-rich، allocation rate، retention، heap size و latency برنامه را جدا اندازه بگیر. در برنامهٔ سرویس، memory limit و رفتار container را هم بررسی کن.

## ۴) تجربهٔ تاریخی: Twitch و Allegro

در نوشتهٔ Twitch از ۲۰۱۶، تیم دربارهٔ سرویس chat با صدها هزار اتصال هم‌زمان روی هر host و اثر pauseهای GC در نسخه‌های بسیار قدیمی Go گزارش می‌دهد. مقاله شرح می‌دهد که profiling و ارائهٔ workload واقعی به تیم runtime به بهبود releaseهای Go 1.5 تا 1.7 کمک کرد. این یک تاریخچهٔ مهم همکاری production و runtime است؛ اعداد pause و workaroundهای آن مربوط به نسخه‌های ۲۰۱۵–۲۰۱۶ هستند و نباید مستقیماً به Go 1.27 تعمیم داده شوند.

در مقالهٔ Allegro از ۲۰۱۶، تیم cache با میلیون‌ها entry را با workload و معیار مشخص آزمود، lock contention را با sharding کاهش داد و برای کم‌کردن اثر pointerهای متعدد در GC از representation فشرده‌تر بررسی کرد. این داستان «همیشه GC را دور بزن» نمی‌گوید؛ آن‌ها cache خاصی را برای معیارهای سخت اندازه گرفتند. راهکارهای custom memory ممکن است portability و safety را قربانی کنند؛ برای برنامهٔ معمولی ابتدا profile بگیر و standard map/cache را حفظ کن مگر شواهد قوی داشته باشی.

## ۵) reflection: دادهٔ dynamic را در runtime بررسی کن

Package <code>reflect</code> به runtime type و value را بررسی می‌کند. این کار در serializer، framework، test tooling و ابزارهای generic runtime مفید است. اما compiler کمتر می‌تواند type و عملیات را بررسی کند؛ branchهای runtime، خطای دیرهنگام و API پیچیده‌تر می‌شود. اول interface، type switch یا generics را بررسی کن؛ reflection وقتی مناسب است که input typeها واقعاً dynamic باشند.

</div>

~~~go
func describe(value any) string {
	if value == nil {
		return "nil interface"
	}

	typeOf := reflect.TypeOf(value)
	valueOf := reflect.ValueOf(value)
	return fmt.Sprintf("type=%s kind=%s", typeOf, valueOf.Kind())
}
~~~

<div dir="rtl">

نکتهٔ ظریف: <code>reflect.TypeOf(nil)</code> و <code>reflect.ValueOf(nil)</code> مقدار type/value ندارند؛ <code>ValueOf</code> یک Value نامعتبر می‌دهد. نوع typed nil مثل <code>(*User)(nil)</code> داخل interface، type دارد. پیش از <code>Elem</code> یا <code>Interface</code>، valid بودن، kind و nil بودن را بررسی کن؛ عملیات نامعتبر panic می‌دهد.

تغییر value با reflect فقط وقتی ممکن است که Value addressable و <code>CanSet()</code> باشد. نمونه:

~~~go
number := 3
value := reflect.ValueOf(&number).Elem()
if value.CanSet() {
	value.SetInt(9)
}
~~~

</div>
<div dir="rtl">

فیلد unexported را با reflect نمی‌توان مثل field عمومی set کرد. API reflection را روی typeهای مورد اعتماد و ورودی محدود استفاده کن؛ ورودی نامطمئن را parse و validate کن.

## ۶) unsafe: دورزدن قراردادهای ایمنی

<code>unsafe</code> اجازه می‌دهد اشاره‌گرها و representation را در سطحی پایین‌تر مدیریت کنی. نامش هشدار است: اشتباه می‌تواند به memory corruption یا رفتار وابسته به compiler/architecture برسد. unsafe pointer arithmetic عمومی شبیه C ارائه نمی‌دهد؛ فقط عملیات و conversionهای مستند‌شده را، با محدودیت‌های دقیق، استفاده کن.

قواعد عملی:

- ابتدا benchmark/profiling نشان دهد این مرز گلوگاه است.
- بخش unsafe را کوچک، کامنت‌دار و با code review ویژه نگه دار.
- به layout و alignment مستندنشده تکیه نکن.
- pointer را برای دورزدن lifetime/GC نگه‌داری نکن.
- <code>uintptr</code> را آدرس دائمی برای استفادهٔ بعدی فرض نکن.
- تست را روی نسخه‌ها و architectureهای هدف انجام بده.
- برای دادهٔ خارجی/ABI از قرارداد مستند استفاده کن.

اگر راه‌حل امن و سریع‌تر با type ساده وجود دارد، آن را انتخاب کن. unsafe ممکن است بعدها با تغییر compiler یا layout از کار بیفتد.

## ۷) cgo: ارتباط با C

Cgo به Go اجازه می‌دهد C code/library را در process address space صدا بزند. Go source فایل <code>import "C"</code> دارد؛ comment بلافاصله قبل از آن preamble است. C compiler و linker بخشی از build می‌شوند و C typeها را نباید به‌عنوان API عمومی Go package منتشر کرد.

نمونهٔ کوچک برای C string؛ این کد برای build به cgo و C compiler نیاز دارد:

~~~go
package main

/*
#include <stdlib.h>
*/
import "C"

import (
	"fmt"
	"unsafe"
)

func main() {
	text := C.CString("hello from Go")
	defer C.free(unsafe.Pointer(text))
	fmt.Println(C.GoString(text))
}
~~~

</div>
<div dir="rtl">

<code>C.CString</code> در C heap حافظه می‌گیرد؛ مسئولیت free برعهدهٔ caller است. هر طرف حافظه‌ای را که خودش ساخته آزاد کند. C pointer و Go pointer rules پیچیده‌اند: Go memory که به C پاس می‌شود باید pinned باشد؛ C اجازه ندارد pointer به Go memory را بعد از call نگه دارد مگر قواعد pinning رسمی برقرار باشد. از <code>runtime/cgo.Handle</code> برای handleهای Go در موارد مناسب استفاده می‌شود؛ رشته، slice و channel را بی‌قاعده در C نگه ندار.

Cgo به C compiler، libraryهای target، ABI و linking وابسته است و cross-compilation را دشوار می‌کند. برای deployment، version header/library، security patch و dynamic library باید مدیریت شوند. cgo را وقتی انتخاب کن که library موجود، hardware API یا performance measured نیاز واقعی ایجاد کند؛ نه برای راحتی فرضی.

## ۸) compiler و linker flags

Go command معمولاً باید compiler/linker را از پشت <code>go build</code> مدیریت کند. ابزار low-level را مستقیم اجرا نکن مگر در diagnosis یا ابزارسازی نیاز داشته باشی. چند نمونه:

- <code>go build -x</code>: commandهای build اجراشده را چاپ می‌کند.
- <code>go build -gcflags="-m=2"</code>: diagnostics بهینه‌سازی/escape را می‌بیند.
- <code>-ldflags="-s -w"</code>: symbol/debug tableهایی را حذف می‌کند؛ debugging را سخت می‌کند.
- <code>-ldflags="-X main.version=..."</code>: variable رشته‌ای package را در link مقدار می‌دهد، اگر variable مطابق قرارداد تعریف شده باشد.

Flagها بر portability، debugability و reproducibility اثر می‌گذارند. build script را مستند و تغییر آن را با artifact واقعی بررسی کن. پیام compiler implementation detail است و بین releaseها می‌تواند عوض شود.

## ۹) build constraints و cgo

فایل‌ها را با constraintهای <code>//go:build</code> بر اساس platform/tag انتخاب کن. cgo نیز constraint ویژهٔ <code>cgo</code> را فعال می‌کند. در cross-compile معمولاً cgo خاموش است مگر C cross-compiler target مشخص شود. برای هر حالت platform implementation یا فایل stub مناسب داشته باش؛ build targetهای پشتیبانی‌شده را صریحاً در CI بساز.

## ۱۰) plugin و dynamic loading

Package استاندارد <code>plugin</code> امکان بازکردن symbolهای یک plugin Go را می‌دهد، اما محدودیت‌های مهم دارد:

- پشتیبانی محدود به Linux، FreeBSD و macOS است.
- plugin را نمی‌توان unload/close کرد.
- برنامه و plugin باید با toolchain، build tags، flagها و dependencyهای سازگار دقیق build شوند.
- race detector محدودیت دارد.
- initialization و deployment پیچیده‌تر می‌شود.
- بارکردن plugin نامطمئن ممکن است اجرای code مهاجم را ممکن کند.

برای extension قابل‌اعتماد با یک process و release واحد شاید build-time registration یا code generation ساده‌تر باشد. برای plugin مستقل، versioning و sandbox واقعی معمولاً RPC/process boundary امن‌تر و قابل‌کنترل‌تری است. Plugin Go مرز امنیتی نیست.

## خطاهای رایج

- optimize کردن بر اساس حدس compiler/GC.
- تکیه بر local variable حتماً در stack بودن.
- استفاده از reflection برای مدل‌هایی که type معلوم دارند.
- نادیده‌گرفتن typed nil و Value invalid در reflect.
- تبدیل pointer به uintptr و استفادهٔ دیرتر از آن.
- نگه‌داشتن Go pointer در C پس از call بدون رعایت pinning.
- free نکردن C allocation.
- تصور اینکه cgo با cross-compile رایگان سازگار است.
- روشن‌کردن plugin برای اجرای library نامطمئن در همان process.
- انتشار build با <code>-s -w</code> بدون حفظ symbol/debug artifact لازم.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: profile قبل از unsafe

یک parser ۵٪ CPU process را مصرف می‌کند و راه‌حل unsafe کد پیچیده می‌سازد. آیا تغییر را انجام می‌دهی؟

**پاسخ:** ابتدا benchmark کل workload و هزینهٔ نگه‌داری/ریسک را مقایسه کن؛ ۵٪ گلوگاه کوچک است مگر SLO یا هزینهٔ واقعی آن را مهم کند. بهینه‌سازی محلی را با end-to-end اثر بسنج.

### تمرین ۲: reflection یا generics؟

تابع sort روی slice از نوع‌های مشخص لازم است. کدام را بررسی می‌کنی؟

**پاسخ:** generics یا library standard را اول بررسی؛ reflection وقتی type فقط در runtime معلوم است.

### تمرین ۳: cgo string lifecycle

C.CString ساخته شده است؛ چه کسی آن را آزاد می‌کند؟

**پاسخ:** Go caller آن را با C.free آزاد می‌کند؛ C heap و Go heap مالکیت جدا دارند.

### تمرین ۴: plugin deployment

سه plugin با buildهای متفاوت در container deploy شده‌اند و runtime crash می‌شود. چه چیزهایی باید یکسان باشند؟

**پاسخ:** toolchain version، build tags، flags، environment موثر و source version dependencyهای مشترک؛ pluginها باید به‌عنوان artifact سازگار با هم build شوند. شاید process/RPC boundary مناسب‌تر باشد.

### تمرین ۵: escape message

پیام compiler می‌گوید object فرار کرد. آیا API را تغییر می‌دهی؟

**پاسخ:** هنوز نه. ابتدا allocation/heap profile و benchmark را ببین؛ escape outcome ممکن است بین compiler نسخه‌ها تغییر کند و correctness را نباید به آن وابسته کرد.

## کوییز

### پرسش‌ها

1. کدام جزئیات runtime قرارداد پایدار زبان نیستند؟
2. Escape analysis چه نوع تصمیمی را کمک می‌کند؟
3. چگونه diagnostics escape/inlining را می‌بینی؟
4. چرا diagnostic compiler را قرارداد API نمی‌کنیم؟
5. GC چه زمانی object را بازیافت می‌کند؟
6. چرا file را به GC نمی‌سپاریم؟
7. reflection چه مزیت و هزینه‌ای دارد؟
8. <code>reflect.Value.CanSet</code> چه می‌گوید؟
9. TypeOf(nil) چه نتیجه‌ای دارد؟
10. چرا unsafe به review ویژه نیاز دارد؟
11. آیا uintptr معادل pointer ریشه‌دار GC است؟
12. cgo برای build به چه ابزار بیرونی نیاز دارد؟
13. چه کسی C.CString را آزاد می‌کند؟
14. آیا C می‌تواند Go slice را بعد از call نگه دارد؟
15. برای انتقال handle Go به C چه ابزار استانداردی وجود دارد؟
16. pluginهای Go روی چه OSهایی پشتیبانی می‌شوند؟
17. آیا plugin Go را می‌توان close/unload کرد؟
18. چرا plugin یک sandbox امنیتی نیست؟
19. چه چیزهایی باید میان برنامه و plugin سازگار باشند؟
20. در گزارش Twitch کدام اصل مهندسی مهم بود؟

### کلید پاسخ

1. layout دقیق، تصمیم heap/stack، scheduler/GC internals و پیام‌های compiler.
2. آیا مقدار از scope فراتر باید زنده بماند و مکان مناسب نگه‌داری آن چیست.
3. <code>go build -gcflags="-m=2"</code>.
4. چون implementation و نسخه ممکن است تغییر کند.
5. زمانی که دیگر reachable نیست و runtime تصمیم به collection بگیرد؛ زمان دقیق تضمین نیست.
6. resource خارجی باید صریح بسته شود.
7. انعطاف برای typeهای runtime؛ در برابر type safety و خوانایی کمتر.
8. آیا Value addressable و اجازهٔ set دارد.
9. TypeOf مقدار nil برمی‌گرداند؛ ValueOf(nil) Value نامعتبر می‌سازد.
10. ممکن است memory corruption، portability issue یا lifetime violation ایجاد کند.
11. خیر؛ uintptr عدد است و pointer root محسوب نمی‌شود.
12. C compiler، linker و libraryهای لازم.
13. caller با C.free.
14. خیر مگر قواعد pinning رسمی و lifetime را رعایت کند؛ slice را مستقیم نگه‌داری نکن.
15. <code>runtime/cgo.Handle</code>.
16. Linux، FreeBSD و macOS.
17. خیر.
18. code داخل همان process با دسترسی‌های برنامه اجرا می‌شود؛ بارگذاری code ناشناخته خطرناک است.
19. toolchain، build tags، flags، environment و dependency source.
20. اندازه‌گیری/profile واقعی و همکاری با تیم runtime به‌جای tuning حدسی و دائمی.

## منابع

- انگلیسی: [Go GC Guide](https://go.dev/doc/gc-guide)
- انگلیسی: [Go FAQ — stack or heap](https://go.dev/doc/faq#stack_or_heap)
- انگلیسی: [Package reflect](https://pkg.go.dev/reflect)
- انگلیسی: [Package unsafe](https://pkg.go.dev/unsafe)
- انگلیسی: [cgo command documentation](https://pkg.go.dev/cmd/cgo)
- انگلیسی: [Package plugin and its warnings](https://pkg.go.dev/plugin)
- انگلیسی: [Compiler flags](https://pkg.go.dev/cmd/compile)
- تجربهٔ تاریخی: [Twitch — Go’s march to low-latency GC](https://blog.twitch.tv/en/2016/07/05/gos-march-to-low-latency-gc-a6fa96f06eb7/)
- تجربهٔ تاریخی: [Allegro — cache service with millions of entries](https://blog.allegro.tech/2016/03/writing-fast-cache-service-in-go.html)
- فارسی: [GoFarsi — مباحث پیشرفته](https://cloud-book.gofarsi.ir/chapter-4/)
- فارسی: [Tarhche — Go و CGO](https://tarhche.com/fa/articles/018fabf6-f87a-7e5a-be4e-69f8916bcea8)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
