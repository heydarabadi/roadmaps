# ۳.۴ — struct، JSON tag و embedding

<div dir="rtl">

**زمان:** ۱۲۰ دقیقه · **پیش‌نیاز:** نوع‌ها و packageها · **هدف:** مدل داده بسازی، مرز JSON را کنترل کنی و composition را با embedding از inheritance جدا بدانی.

## ۱) struct یعنی دادهٔ دارای فیلدهای نام‌دار

<code>struct</code> چند field با نوع مشخص را در یک value ترکیب می‌کند. zero value struct از zero value fieldها ساخته می‌شود؛ بنابراین یک type خوب می‌تواند بدون constructor هم وضعیت امن اولیه داشته باشد. برای خوانایی معمولاً در literal نام field را می‌نویسیم:

</div>

~~~go
type Point struct {
	X int
	Y int
}

p := Point{X: 3, Y: 7}
origin := Point{} // X و Y هر دو صفر
~~~

<div dir="rtl">

<code>Point{3, 7}</code> fieldها را به ترتیب struct می‌چیند و با اضافه یا تغییر field شکننده‌تر است. برای API، تست و کد نگه‌داری‌پذیر keyed literal را ترجیح بده. field با حرف بزرگ export می‌شود؛ field کوچک فقط در همان package قابل دسترسی است. packageهایی مثل encoding/json به طور معمول fieldهای exportشده را serialize می‌کنند.

## ۲) Tag: metadata برای packageها

Struct tag رشته‌ای کنار field است؛ packageای که tag convention را می‌شناسد آن را تفسیر می‌کند. tag خودش validation، authorization یا رمزنگاری انجام نمی‌دهد. مثال متداول:

</div>

~~~go
type Product struct {
	ID       int64  "json:\"id\""
	Name     string "json:\"name\""
	Note     string "json:\"note,omitempty\""
	Internal string "json:\"-\""
}
~~~

<div dir="rtl">

اینجا از interpreted string برای tag استفاده شده؛ raw string با backtick هم شکل رایج‌تری است. <code>omitempty</code> در JSON field خالی/zero را در شرایط مستند package حذف می‌کند. fieldهای pointer و interface هم قواعد omitempty ویژه دارند؛ وقتی حضور صریح null/false/0 اهمیت دارد، struct و قرارداد را دقیق طراحی کن. <code>json:"-"</code> آن field را از encoding/json کنار می‌گذارد؛ این جای access control نیست و مانع چاپ دستی یا leak از مسیر دیگر نمی‌شود.

## ۳) مثال کامل decode، validation و encode

</div>

~~~go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strings"
)

type CreateProduct struct {
	Name  string "json:\"name\""
	Price int64  "json:\"price_cents\""
}

type ProductResponse struct {
	ID    int64  "json:\"id\""
	Name  string "json:\"name\""
	Price int64  "json:\"price_cents\""
}

func decodeCreateProduct(input string) (CreateProduct, error) {
	var req CreateProduct
	decoder := json.NewDecoder(strings.NewReader(input))
	decoder.DisallowUnknownFields()

	if err := decoder.Decode(&req); err != nil {
		return CreateProduct{}, fmt.Errorf("decode request: %w", err)
	}
	if strings.TrimSpace(req.Name) == "" {
		return CreateProduct{}, fmt.Errorf("name is required")
	}
	if req.Price < 0 {
		return CreateProduct{}, fmt.Errorf("price must not be negative")
	}
	return req, nil
}

func main() {
	req, err := decodeCreateProduct("{\"name\":\"Pen\",\"price_cents\":250}")
	if err != nil {
		panic(err) // فقط برای demo؛ server باید پاسخ خطای کنترل‌شده بدهد.
	}

	response := ProductResponse{ID: 17, Name: req.Name, Price: req.Price}
	var out bytes.Buffer
	encoder := json.NewEncoder(&out)
	encoder.SetIndent("", "  ")
	if err := encoder.Encode(response); err != nil {
		panic(err)
	}
	fmt.Print(out.String())
}
~~~

<div dir="rtl">

در این Go کد از struct tagهای رشته‌ای استفاده شده‌اند. در کدهای واقعی raw string با backtick رایج است. برای خواندن HTTP واقعی، body را با محدودیت اندازه بخوان، request را decode کن، بعد business validation و authorization انجام بده؛ در مثال کوتاه هیچ سرویس یا databaseای نداریم.

نکتهٔ امنیتی: decoder معمولی اگر field اضافه ببیند ممکن است آن را نادیده بگیرد؛ این لزوماً همیشه بد نیست اما باید آگاهانه باشد. <code>DisallowUnknownFields</code> قرارداد ورودی را سخت‌تر می‌کند. برای trailing JSON document نیز پس از decode اول باید بررسی کنی محتوای اضافی وجود ندارد. اعتبار نحوی JSON معادل معتبر بودن درخواست کسب‌وکار نیست.

## ۴) Embedding یعنی composition، نه ارث‌بری

با embedding می‌توان type را در struct دیگر جای داد و بعضی field/methodها را promoted کرد:

</div>

~~~go
type AuditFields struct {
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Customer struct {
	ID   int64
	Name string
	AuditFields
}
~~~

<div dir="rtl">

با این تعریف می‌توان به <code>customer.CreatedAt</code> دسترسی داشت، اما field همچنان بخشی از field داخلی <code>AuditFields</code> است. این inheritance کلاسیک نیست: object والد/فرزند، virtual dispatch و override خودکار زبان‌های class-based را ندارد. embedding composition و روش کوتاه‌نویسی دسترسی است. اگر دو field هم‌نام در سطح یکسان promote شوند، selector مبهم می‌شود و compile error می‌دهد؛ می‌توانی field داخلی را با نام type مشخص کنی.

Embedding exported type در struct public API می‌تواند method set را ناخواسته به بیرون نشان دهد؛ public API را با API نهایی طراحی کن.

از Go 1.27، fieldی که از struct embeddedشده promote شده می‌تواند در keyed struct literal نیز مستقیم نوشته شود. این قابلیت فقط syntax ساخت مقدار را تغییر می‌دهد؛ field همچنان در embedded type ذخیره می‌شود:

~~~go
customer := Customer{
	ID:        7,
	Name:      "Ada",
	CreatedAt: time.Now(), // field از AuditFields در Go 1.27+
}
~~~

در نسخه‌های قدیمی‌تر باید nested literal بدهی: <code>AuditFields: AuditFields{CreatedAt: ...}</code>. اگر module با language version پایین‌تر از 1.27 کار می‌کند، syntax جدید را استفاده نکن.


## ۵) DTO، domain model و persistence را تفکیک کن

HTTP request، database row و domain object ممکن است field و invariant متفاوت داشته باشند. استفاده از یک struct برای هر سه مرز باعث می‌شود فیلد داخلی به پاسخ راه پیدا کند، JSON tag دیتابیس را شکل دهد، یا تغییر API مدل دامنه را بشکند. در پروژهٔ کوچک جداسازی را بی‌دلیل زیاد نکن؛ اما وقتی قراردادها تفاوت دارند DTOهای جدا بساز.

## خطاهای رایج

- field کوچک را انتظار داری encoding/json بخواند یا بنویسد.
- خیال می‌کنی tag خودش ورودی را validate می‌کند.
- <code>omitempty</code> را برای فیلدی می‌گذاری که صفر آن باید حتماً ارسال شود.
- struct را با positional literal می‌سازی و بعد اضافه‌کردن field کد را شکننده می‌کند.
- embedding را inheritance یا interface implementation خودکار فرض می‌کنی.
- payload ورودی untrusted را بدون اندازه و validation decode می‌کنی.
- با یک struct هم secret داخلی و هم response عمومی را نمایش می‌دهی.

## تمرین با پاسخ

**۱.** type پاسخ کاربر بساز که password hash را در JSON ندهد.

پاسخ: response DTO جدا شامل ID و Name بساز؛ password hash را اصلاً در type پاسخ قرار نده. <code>json:"-"</code> فقط defense-in-depth است، نه مجوز اشتراک همان struct بین لایه‌ها.

**۲.** <code>omitempty</code> را برای عددی به‌کار ببر که صفر، مقدار معتبر و باید حاضر باشد. مشکل چیست؟

پاسخ: encoder ممکن است zero value را حذف کند؛ با pointer، presence flag یا custom type وجود explicit zero را از نبودن field جدا کن.

**۳.** embedding یک struct چه زمانی خوب است؟

پاسخ: وقتی رفتار/مفهوم مشترکی واقعاً composition می‌شود و API field/methodهای promoteشده مناسب است؛ نه برای تقلید اجباری از hierarchy کلاس.

## کوییز

### پرسش‌ها

1. zero value struct از چه ساخته می‌شود؟
2. حرف بزرگ اول field چه معنا دارد؟
3. struct tag خودش validation می‌کند؟
4. encoding/json معمولاً به چه fieldهایی دسترسی دارد؟
5. <code>omitempty</code> چه تغییری در marshal می‌دهد؟
6. چرا <code>json:"-"</code> را security boundary نمی‌دانیم؟
7. embedding چه چیزی را کوتاه می‌کند؟
8. آیا embedding معادل inheritance است؟
9. چه وقت literal نام‌دار بهتر از positional است؟
10. چرا HTTP request struct را همیشه با domain struct یکی نمی‌کنیم؟
11. آیا JSON decode موفق یعنی داده برای business معتبر است؟
12. برای strict input با field ناشناخته چه قابلیتی در decoder وجود دارد؟
13. Go 1.27 چه تغییری برای fieldهای embedded در keyed struct literal داد؟

### کلید پاسخ

1. از zero value همهٔ fieldها.
2. field export و از packageهای دیگر قابل دسترسی است.
3. خیر؛ packageها آن را فقط به‌عنوان metadata تفسیر می‌کنند.
4. fieldهای exported.
5. fieldهای empty طبق قواعد package حذف می‌شوند.
6. field ممکن است از مسیر دیگر leak شود؛ این فقط رفتار encoder است.
7. دسترسی به field/methodهای embedded type را promote می‌کند.
8. خیر؛ composition است و inheritance class semantics ندارد.
9. وقتی تغییر ترتیب/اضافه‌شدن field نباید literal را بشکند.
10. قرارداد API، persistence و invariant دامنه متفاوت‌اند.
11. خیر؛ validation/authorization جداست.
12. <code>Decoder.DisallowUnknownFields</code>.
13. نام fieldهای promoted از embedded struct را هم می‌توان مستقیم به‌عنوان کلید literal نوشت.

## منابع

- [Tour: struct types](https://go.dev/tour/moretypes/2)
- [encoding/json package](https://pkg.go.dev/encoding/json) · [Go 1.27 release notes](https://go.dev/doc/go1.27)
- فارسی: [GoFarsi — struct و فصل دوم](https://cloud-book.gofarsi.ir/chapter-2/)
- فارسی: [Tarhche — struct](https://tarhche.com/fa/articles/018fabf6-10ac-7e5a-ab68-0f33e765574f)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
