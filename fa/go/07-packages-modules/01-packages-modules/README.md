# ۷.۱ — package، module و مدیریت وابستگی

<div dir="rtl">

**زمان پیشنهادی:** ۱۶۵ دقیقه · **پیش‌نیاز:** توابع، typeها، خطا و فرمان‌های Go  
**هدف:** یک پروژهٔ چندفایلی بسازی، import path را بفهمی و وابستگی‌های قابل‌بازتولید و امن نگه داری.

## نقشهٔ این درس

- package در برابر module
- module path و ساختار پوشه
- نام package و export
- import و dependency graph
- فایل <code>go.mod</code> و <code>go.sum</code>
- نسخه‌بندی semantic و major version
- ابزارهای <code>go mod</code>
- internal package، vendor و workspace
- وابستگی خصوصی و حریم‌خصوصی
- ساختار یک برنامهٔ چند package

## ۱) package کوچک‌ترین واحد سازمان‌دهی کد Go است

هر فایل Go با یک declaration از نوع <code>package</code> شروع می‌شود. فایل‌های یک پوشه معمولاً عضو یک package هستند؛ package نامی برای تعریف‌های همان گروه است. فایل‌های یک package را می‌توان به چند فایل جدا تقسیم کرد و آن‌ها به declarationهای package یکدیگر دسترسی دارند، اما هر فایل importهای موردنیاز خودش را اعلام می‌کند.

نمونهٔ سرآغاز فایل:

</div>

~~~go
package users

import "context"
~~~

<div dir="rtl">

نام package معمولاً کوتاه و lowercase است؛ این نام لزوماً برابر آخرین بخش import path نیست، هرچند هماهنگی آن خوانایی را بهتر می‌کند. درون یک package، identifierهایی که با حرف بزرگ شروع می‌شوند export می‌شوند و از packageهای دیگر قابل‌دسترسی‌اند. حروف کوچک به همان package محدودند. نام type، function، const و fieldهای public را برای مصرف‌کنندهٔ واقعی طراحی کن؛ صرفاً publicکردن همهٔ جزئیات API را بزرگ می‌کند.

## ۲) module چیست؟

Module نسخه‌بندی و انتشار یک یا چند package را زیر یک module path مدیریت می‌کند. ریشهٔ module پوشه‌ای است که <code>go.mod</code> دارد. برای برنامهٔ آموزشی یا ابزار شخصی، از یک module شروع کن؛ برای ساختن submodule به مرز انتشار و نسخه‌بندی مستقل نیاز واقعی داشته باش.

فرض کنیم پروژه چنین ساختاری دارد:

</div>

~~~text
taskcli/
  go.mod
  cmd/
    taskcli/
      main.go
  internal/
    task/
      task.go
  README.md
~~~

<div dir="rtl">

با فرمان زیر ماژول را ایجاد کن؛ module path را با مسیر واقعی repository خودت هماهنگ کن:

</div>

~~~powershell
go mod init example.com/pouya/taskcli
~~~

<div dir="rtl">

در این نمونه <code>cmd/taskcli</code> package اجرایی <code>main</code> است، و <code>internal/task</code> منطق داخلی را نگه می‌دارد. import path آن package برابر <code>example.com/pouya/taskcli/internal/task</code> خواهد بود. مسیر module معمولاً repository URL یا namespace پایدار است؛ برای package‌ای که قرار است دیگران import کنند از مسیر ساختگی موقت استفاده نکن.

## ۳) package و directory در عمل

یک پوشهٔ Go به‌طور معمول یک package را دربرمی‌گیرد. نام‌گذاری چند فایل هم‌پوشه می‌تواند به تقسیم موضوعی کمک کند، اما package فقط برای اینکه پوشهٔ بزرگ‌تر شود جدا نکن. مرز package باید API، وابستگی و ownership روشنی ایجاد کند.

در package قابل‌استفادهٔ مجدد، یک فایل تست با suffix <code>_test.go</code> کنار source می‌آید. تست با همان package به unexportedها دسترسی دارد؛ تست با نام <code>package users_test</code> از بیرون package رفتار public را می‌سنجد. این دو انتخاب را بر اساس آنچه می‌خواهی تضمین کنی انجام بده، نه بر اساس سلیقهٔ ثابت.

Import cycle مجاز نیست. اگر package A به B و B به A وابسته‌اند، معمولاً یک abstraction یا type مشترک را به package سومی منتقل کن، یا یکی از وابستگی‌های برگشتی را با interface سمت مصرف‌کننده حل کن. انتقال بی‌هدف فایل‌ها فقط import cycle را جابه‌جا می‌کند؛ جهت dependency را طراحی کن.

## ۴) مرز <code>internal</code>

پوشه‌ای با نام <code>internal</code> قانون ویژهٔ Go دارد: packageهای داخل آن را فقط packageهای زیر درخت مجاز می‌توانند import کنند. این قانون از import تصادفی جزئیات خصوصی توسط برنامه‌های بیرونی جلوگیری می‌کند. برای منطق برنامه یا packageهایی که API عمومی پایدار نیستند مناسب است.

آنچه <code>internal</code> نمی‌کند: امنیت داده را جایگزین نمی‌کند، typeهای exportشده را از packageهای مجاز پنهان مطلق نمی‌کند و مرز domain را خودکار طراحی نمی‌کند. public API یک package را با identifierهای lowercase و کمینهٔ exportها حفظ کن.

## ۵) <code>go.mod</code>: شناسنامه و حداقل نسخه

نمونهٔ سادهٔ <code>go.mod</code>:

</div>

~~~go
module example.com/pouya/taskcli

go 1.27
~~~

<div dir="rtl">

خط <code>module</code> مسیر اصلی importها و نسخهٔ module را تعیین می‌کند. خط <code>go</code> language version و حداقل نسخهٔ Go موردنیاز semantics/build را مشخص می‌کند. نسخهٔ <code>go</code> را با نسخه‌ای که کد واقعاً نیاز دارد و تیم/مصرف‌کننده پشتیبانی می‌کند هماهنگ کن. اگر فقط از قابلیت Go 1.22 استفاده کرده‌ای، بالا بردن بی‌دلیل این خط ممکن است مصرف‌کنندگان قدیمی را محروم کند؛ اگر از API استاندارد تازه استفاده می‌کنی، پایین نوشتن آن هم نادرست است.

برای پروژهٔ تیمی، toolchainهای استانداردشده در CI، فایل‌های راهنمای اجرا و نسخهٔ ماژول باید با هم سازگار باشند. در نسخه‌های جدید Go directiveهای دیگری مانند <code>toolchain</code> نیز ممکن است حضور داشته باشند؛ آن‌ها را صرفاً برای پین‌کردن نسخه کپی نکن، ابتدا نقش هر directive را در مستندات نسخهٔ target بخوان.

## ۶) <code>go.sum</code> و گراف وابستگی

وقتی moduleی لازم شود، اطلاعات نسخه در <code>go.mod</code> و checksumهای محتوا در <code>go.sum</code> نگه‌داری می‌شوند. <code>go.sum</code> فهرست سادهٔ «dependencyهای مستقیم» یا lockfile کلاسیک با یک نسخهٔ یگانه برای هر کتابخانه نیست؛ checksumها برای تأیید محتوای ماژول‌هایی که Go در محاسبات dependency به آن‌ها نیاز دارد ثبت می‌شوند.

Go برای انتخاب نسخه از Minimal Version Selection استفاده می‌کند: گراف module نسخه‌های حداقل لازم را نگه می‌دارد و نسخهٔ انتخاب‌شده را براساس نیازهای وابستگی‌ها محاسبه می‌کند. نتیجه را با <code>go list -m all</code> ببین. ارتقای یک dependency صرفاً با ویرایش دستی یک خط تمام نمی‌شود؛ سازگاری، security advisory، release note و تست رفتار را بررسی کن.

فایل‌های <code>go.mod</code> و <code>go.sum</code> را معمولاً commit می‌کنند تا دیگران همان graph/checksum را دریافت کنند. از حذف بی‌دلیل go.sum نترس، اما تغییراتش را هم بازبینی کن؛ package ناشناخته یا تغییر checksum ناخواسته نیازمند بررسی منشأ است.

## ۷) فرمان‌های پرکاربرد

</div>

~~~powershell
go mod init example.com/org/project
go get example.com/library@v1.2.3
go mod tidy
go mod download
go list -m all
go mod graph
go mod verify
go mod vendor
~~~

<div dir="rtl">

- <code>go mod init</code>: module تازه می‌سازد.
- <code>go get</code>: نسخهٔ dependency را اضافه یا تنظیم می‌کند؛ اثر دقیق را در فایل‌ها بازبینی کن.
- <code>go mod tidy</code>: dependencyهای لازم را براساس source و testها اضافه و موردهای بلااستفاده را پاک‌سازی می‌کند.
- <code>go mod download</code>: ماژول‌های لازم را دریافت می‌کند.
- <code>go list -m all</code>: نسخه‌های انتخاب‌شدهٔ گراف را نشان می‌دهد.
- <code>go mod graph</code>: رابطه‌های dependency را چاپ می‌کند.
- <code>go mod verify</code>: checksum module cache را بررسی می‌کند.
- <code>go mod vendor</code>: source لازم را در vendor قرار می‌دهد؛ فقط وقتی سیاست build/offline آن را لازم دارد.

فرمان‌های مدیریت module ممکن است فایل‌ها را تغییر دهند؛ پیش و پس از اجرا diff را ببین. <code>tidy</code> را در تغییر branch یا نسخهٔ Go اجرا کن و اثرش را بازبینی کن، نه اینکه تغییر خودکار را کورکورانه commit کنی.

## ۸) نسخه‌بندی و major version

برای انتشار عمومی، semantic versioning قرارداد سازگاری API است: تغییر patch برای bug fix سازگار، minor برای قابلیت سازگار، major برای تغییر ناسازگار. جزئیات و pre-releaseها قواعد خود را دارند؛ API public باید از همان ابتدا تا حد امکان کوچک بماند.

در Go moduleهای major از نسخهٔ ۲ به بالا معمولاً major version suffix به module path و import path افزوده می‌شود، مانند <code>/v2</code>. این اجازه می‌دهد نسخه‌های ناسازگار در graph کنار هم وجود داشته باشند، اما packageها typeهای متفاوت خواهند داشت و عبور type از boundary نسخه‌ها نیازمند تبدیل است. major جدید را صرفاً به‌خاطر تغییر داخلی منتشر نکن؛ فقط وقتی قرارداد سازگاری شکسته است از آن استفاده کن و migration guide بنویس.

## ۹) <code>replace</code> و workspace

Directive <code>replace</code> می‌تواند module path را به نسخه یا مسیر local دیگری redirect کند. این برای توسعهٔ چند repository یا reproduction محلی مفید است، اما replace به مسیر machine-specific معمولاً برای library منتشرشده مناسب نیست؛ مصرف‌کننده آن مسیر را ندارد. پیش از انتشار یا CI، بررسی کن تغییر موقت به go.mod نمانده باشد.

برای کار هم‌زمان روی چند module محلی، <code>go work</code> workspace می‌سازد تا toolchain نسخهٔ checkoutهای local را پیدا کند. فایل workspace معمولاً مخصوص محیط توسعه است؛ آن را در صورتی commit کن که تیم آگاهانه از workspace مشترک استفاده می‌کند و همهٔ مسیرها قابل‌دسترسی‌اند.

## ۱۰) dependency خصوصی و privacy

هنگام دریافت module، ممکن است مسیر module به proxy یا checksum database عمومی فرستاده شود. برای ماژول خصوصی، تنظیم درست <code>GOPRIVATE</code> یا policyهای مرتبط لازم است تا نام repository خصوصی افشا نشود. این تنظیمات را با host و سازمان خود هماهنگ کن؛ token را در go.mod یا URL ذخیره‌شده در repository قرار نده.

کمینه‌سازی dependencyها سطح حمله، به‌روزرسانی و نگه‌داری را کم می‌کند. پیش از افزودن یک کتابخانه، standard library و کتابخانه‌های جاری پروژه را بررسی کن. برای dependency خارجی، مالکیت نگه‌داری، releaseها، issueها، license، vulnerabilityها و نیاز واقعی را ارزیابی کن. lockfile و checksum به‌تنهایی به معنی امن‌بودن package نیستند.

## انتشار module عمومی

قبل از انتشار، module path باید پایدار و در repository/VCS واقعی باشد؛ README کاربرد و حداقل نسخهٔ Go را توضیح دهد، license روشن باشد، test و security review انجام شده باشد و API exported کوچک بماند. برای release نسخهٔ سازگار semantic version را Git tag کن، مانند <code>v1.2.3</code>، و tag را پس از push بررسی کن. مصرف‌کننده با module path و version می‌تواند آن را دریافت کند؛ انتشار به معنای deploy server نیست.

در نسخهٔ ۲ به بعد، suffix مسیر مانند <code>/v2</code> بخشی از module path و importهاست. پیش از tag کردن breaking change، migration guide و مثال ارتقا بنویس. نسخهٔ pre-v1 هنوز قرارداد سازگاری پایدار v1 را ندارد، پس تغییرها را صادقانه مستند کن. برای private module، privacy تنظیمات proxy و checksum را پیش از اولین fetch بررسی کن. دستورهای <code>go list -m</code> و <code>go mod download</code> کمک می‌کنند نسخهٔ مصرفی را مشاهده و دریافت کنی.
## ۱۱) مثال API package

فرض کن package <code>internal/task</code> یک عملیات ساده تعریف می‌کند. fieldهای حساس داخلی می‌مانند و package تنها عملیات موردنیاز را export می‌کند:

</div>

~~~go
package task

type Task struct {
	id    string
	title string
}

func New(id, title string) Task {
	return Task{id: id, title: title}
}

func (t Task) Title() string {
	return t.title
}
~~~

<div dir="rtl">

این API عمداً getter برای هر field نمی‌سازد. اگر مصرف‌کننده به id نیاز دارد، بر اساس نیاز دامنه یک method اضافه می‌کنیم. اگر fieldها مستقیم export شوند، هر caller می‌تواند invariant را دور بزند. اما encapsulation را بیش از حد هم نکن: typeی که هیچ رفتار یا access لازم را ارائه نمی‌دهد قابل‌استفاده نیست.

## خطاهای رایج

- قاطی‌کردن مفهوم package، repository و module.
- نامیدن هر پوشه‌ای با نام متفاوت بدون مرز مسئولیت.
- ساخت dependency cycle میان packageها.
- export کردن همهٔ fieldها و functionها.
- استفاده از import path موقت برای module منتشرشدنی.
- تصور اینکه go.sum فقط لیست dependency مستقیم است.
- تغییر نسخه بدون بازبینی گراف و امنیت.
- نگه‌داشتن replace محلی در module عمومی.
- نادیده‌گرفتن افشای module خصوصی به proxy عمومی.
- افزودن dependency سنگین برای کاری که standard library انجام می‌دهد.
- ساخت چند submodule برای پروژهٔ کوچک بدون نیاز release مستقل.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: module تازه

در پوشهٔ تمرین moduleای با مسیر فرضی repository بساز، یک command در <code>cmd/hello</code> و package داخلی در <code>internal/greeting</code> قرار بده.

**چک‌لیست پاسخ:** هر پوشه یک package، module root دارای go.mod، import path برابر module path به‌علاوهٔ مسیر پوشه، و identifierهای موردنیاز از package دیگر export شده‌اند.

### تمرین ۲: import cycle

فرض کن <code>order</code> به <code>payment</code> نیاز دارد و <code>payment</code> هم typeهای داخلی order را import می‌کند. وابستگی را جهت‌دار کن.

**پاسخ نمونه:** قرارداد موردنیاز <code>order</code> را در package مصرف‌کننده تعریف و implementation payment را طوری طراحی کن که آن قرارداد را satisfy کند؛ type مشترکی که واقعاً domain مستقل دارد در package مناسب جدا شود. package عمومی «common» برای هر چیزی نساز.

### تمرین ۳: بازبینی dependency

یک dependency فرضی جدید را اضافه کن. نسخهٔ انتخاب‌شده، changelog، license، نگه‌داری و checksum را بررسی و diffهای go.mod/go.sum را توضیح بده.

**پاسخ:** برنامه باید بگوید dependency مستقیم است یا transitive، چرا لازم است، نسخه چرا انتخاب شده، و آیا تنظیم GOPRIVATE برای repository خصوصی لازم است. عدد نسخه به‌تنهایی دلیل اعتماد نیست.

### تمرین ۴: مرز package

مشخص کن آیا هر یک از موارد زیر باید export شوند: تابع constructor مصرف‌کننده، cache داخلی package، typeی که در signature عمومی ظاهر می‌شود.

**پاسخ:** constructorی که مصرف‌کننده لازم دارد export شود؛ cache داخلی باقی بماند unexported؛ هر typeی که در signature exported می‌آید باید خودش نیز برای مصرف‌کننده قابل‌نام‌گذاری باشد و طراحی آن بخشی از API است.

## کوییز

### پرسش‌ها

1. package با module چه تفاوتی دارد؟
2. یک package معمولاً از چه فایل‌هایی تشکیل می‌شود؟
3. module root چگونه مشخص می‌شود؟
4. import path یک package از چه بخش‌هایی ساخته می‌شود؟
5. identifier چگونه از package export می‌شود؟
6. import cycle در Go چه وضعی دارد؟
7. <code>internal</code> چه محدودیتی اعمال می‌کند؟
8. <code>go.mod</code> چه اطلاعاتی نگه می‌دارد؟
9. <code>go</code> directive چرا مهم است؟
10. آیا <code>go.sum</code> فقط dependencyهای مستقیم را فهرست می‌کند؟
11. <code>go mod tidy</code> چه می‌کند؟
12. Minimal Version Selection چه چیزی انتخاب می‌کند؟
13. در moduleهای Go، major version 2+ چه اثری بر مسیر دارد؟
14. چرا مسیر replace محلی نباید در کتابخانهٔ منتشرشده باقی بماند؟
15. چه وقت <code>go work</code> مفید است؟
16. <code>GOPRIVATE</code> چه نوع خطری را کاهش می‌دهد؟
17. آیا وجود checksum ثابت می‌کند dependency امن است؟
18. چرا تعداد کم dependency می‌تواند سودمند باشد؟
19. برای انتشار module عمومی چه چیزی باید در tag و import path بررسی شود؟

### کلید پاسخ

1. package واحد source/import است؛ module مجموعهٔ نسخه‌بندی‌شده‌ای از packageها با ریشهٔ go.mod است.
2. چند فایل .go هم‌پوشه با یک نام package؛ فایل‌ها importهای خود را جداگانه می‌آورند.
3. پوشه‌ای که go.mod در آن قرار دارد.
4. module path به‌علاوهٔ مسیر پوشهٔ package.
5. با شروع شناسه از حرف بزرگ.
6. ممنوع است و باید جهت dependency را بازطراحی کرد.
7. import را به packageهای در زیرشاخه‌های مجاز محدود می‌کند.
8. module path، نسخهٔ زبان/حداقل Go و نیازهای module.
9. حداقل نسخه و language semantics موردنیاز را برای toolchain مشخص می‌کند.
10. خیر؛ برای checksumهای moduleهایی است که در graph/ساخت لازم می‌شوند.
11. dependencyهای لازم را اضافه و dependencyهای بلااستفاده را حذف/همگام می‌کند.
12. حداقل نسخه‌های موردنیاز در graph، مطابق قواعد MVS.
13. معمولاً suffixی مثل /v2 به module path/import path اضافه می‌شود.
14. مسیر روی دستگاه توسعه‌دهنده وجود دارد و برای مصرف‌کننده/CI قابل‌استفاده نیست.
15. وقتی روی چند module محلی به‌طور هم‌زمان کار و تست می‌کنی.
16. جلوگیری از ارسال ناخواستهٔ نام module خصوصی به proxy یا خدمات عمومی.
17. خیر؛ checksum یکپارچگی محتوا را بررسی می‌کند، نه کیفیت یا امنیت طراحی را.
18. سطح به‌روزرسانی، حمله، license review و هزینهٔ نگه‌داری را محدود می‌کند.
19. tag معنایی هماهنگ با module path؛ برای v2+ suffix /v2 نیز در module و importها لازم است.

## منابع

- انگلیسی: [Managing dependencies](https://go.dev/doc/modules/managing-dependencies)
- انگلیسی: [Go Modules Reference](https://go.dev/ref/mod)
- انگلیسی: [Go specification — Packages](https://go.dev/ref/spec#Packages)
- انگلیسی: [Go Blog — Go Modules: v2 and beyond](https://go.dev/blog/v2-go-modules)
- فارسی: [GoFarsi — module](https://book.gofarsi.ir/chapter-4/go-mod/)
- فارسی: [GoFarsi — کتاب آموزش Go](https://cloud-book.gofarsi.ir/chapter-4/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
