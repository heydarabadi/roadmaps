# ۱۱.۱ — کتابخانهٔ استاندارد: io، JSON و time

<div dir="rtl">

**زمان پیشنهادی:** ۱۸۰ دقیقه · **پیش‌نیاز:** struct، interface، error و slice  
**هدف:** ورودی/خروجی stream را بدون بارگذاری بی‌دلیل همه‌چیز مدیریت کنی، JSON امن‌تر بخوانی و زمان را با timezone و duration اشتباه نگیری.

## نقشهٔ این درس

- Reader و Writer
- stream و محدودیت حافظه
- Close و resource lifecycle
- JSON و struct tag
- validation پس از decode
- ورودی نامطمئن و محدودیت اندازه
- زمان در برابر duration
- قالب زمانی Go
- timezone، UTC و monotonic clock
- انتخاب API مناسب استاندارد

## ۱) io.Reader و io.Writer

بخش زیادی از standard library داده را به شکل stream منتقل می‌کند. <code>io.Reader</code> bytes را به buffer پرشده می‌خواند؛ <code>io.Writer</code> bytes را می‌نویسد. فایل، HTTP body، buffer و بسیاری از connectionها با این قراردادها کار می‌کنند. تابعی که به Reader نیاز دارد لازم نیست به concrete type فایل وابسته باشد.

</div>

~~~go
func copyFile(dst io.Writer, src io.Reader) error {
	_, err := io.Copy(dst, src)
	if err != nil {
		return fmt.Errorf("کپی داده: %w", err)
	}
	return nil
}
~~~

<div dir="rtl">

<code>io.Copy</code> stream را با bufferهای مناسب منتقل می‌کند؛ لازم نیست کل فایل را در حافظه بگیری. در کد واقعی مالکیت <code>Close</code> معمولاً با سازندهٔ resource است، نه copy helper. هر interface کوچک‌تر dependency را قابل‌آزمایش‌تر می‌کند.

## ۲) stream، EOF و محدودکردن ورودی

در Reader، <code>io.EOF</code> معمولاً پایان طبیعی stream است، نه لزوماً خطای application. حلقهٔ خواندن باید <code>n</code> و <code>err</code> را مطابق contract بررسی کند؛ ممکن است هم bytes و هم error در یک call برگردند. برای کمک‌های معمول، <code>io.ReadAll</code> داده را در حافظه جمع می‌کند و فقط وقتی مناسب است که اندازهٔ ورودی محدود و قابل‌قبول باشد.

برای ورودی نامطمئن، حد بگذار. مثلاً JSON request body را با <code>http.MaxBytesReader</code> محدود کن؛ در ابزار خارج از HTTP می‌توانی از <code>io.LimitReader</code> استفاده کنی و عبور از سقف را تشخیص بدهی. limit از memory exhaustion جلوگیری می‌کند؛ بعد از decode همچنان validation معنایی لازم است.

## ۳) JSON: serialization با validation یکی نیست

JSON را به struct مشخص decode کن تا type و قرارداد داده روشن بماند. Tagها field name را تعیین می‌کنند. Go اجازه می‌دهد tag به شکل interpreted string literal نوشته شود:

~~~go
type CreateUserRequest struct {
	Name  string "json:\"name\""
	Email string "json:\"email\""
}
~~~

</div>
<div dir="rtl">

مثال decode محدودشده برای HTTP:

</div>

~~~go
func decodeCreateUser(w http.ResponseWriter, r *http.Request) (CreateUserRequest, error) {
	r.Body = http.MaxBytesReader(w, r.Body, 1<<20)

	decoder := json.NewDecoder(r.Body)
	decoder.DisallowUnknownFields()

	var request CreateUserRequest
	if err := decoder.Decode(&request); err != nil {
		return CreateUserRequest{}, fmt.Errorf("خواندن JSON: %w", err)
	}

	var extra any
	if err := decoder.Decode(&extra); err != io.EOF {
		if err == nil {
			return CreateUserRequest{}, errors.New("پس از مقدار JSON دادهٔ اضافی وجود دارد")
		}
		return CreateUserRequest{}, fmt.Errorf("خواندن ادامهٔ body: %w", err)
	}

	if strings.TrimSpace(request.Name) == "" {
		return CreateUserRequest{}, errors.New("name الزامی است")
	}
	return request, nil
}
~~~

<div dir="rtl">

تشخیص دادهٔ اضافی پس از JSON واحد باعث می‌شود endpointی که یک object می‌خواهد، stream حاوی چند مقدار را بی‌صدا قبول نکند. <code>DisallowUnknownFields</code> برای schema سخت‌گیر مفید است، اما ممکن است forward compatibility را بشکند؛ سیاست API را مشخص کن. JSON decode موفق فقط type shape را تا حدی بررسی می‌کند؛ قواعد دامنه مانند طول، مجوز و سازگاری fieldها جدا هستند.

برای خروجی JSON از <code>json.NewEncoder(w).Encode(value)</code> استفاده کن. این متد newline اضافه می‌کند. برای serialization در memory، <code>json.Marshal</code> مناسب است. دادهٔ کاربر را پیش از encode HTML به‌صورت خام concat نکن؛ encoding استاندارد را به‌کار ببر و قواعد HTML/script context را رعایت کن.

## ۴) JSON و اطلاعات عددی

وقتی JSON را در <code>any</code> decode می‌کنی، عددها به‌طور پیش‌فرض معمولاً <code>float64</code> می‌شوند. برای عدد صحیح بزرگ یا دادهٔ مالی ممکن است دقت از بین برود. از struct با فیلد عددی مشخص استفاده کن یا روی Decoder، <code>UseNumber</code> فعال کن و بعد رشتهٔ عدد را طبق domain parse/validate کن. برای پول، representation و rounding را خودت تعریف کن.

Custom <code>MarshalJSON</code>/<code>UnmarshalJSON</code> می‌تواند مفید باشد، اما در صورت recursion ناخواسته، pointer receiver، null، صفرمقدار و compatibility ظرافت دارد. اول tagها و typeهای ساده را ترجیح بده.

### JSON v2 در Go 1.27

Go 1.27 پکیج‌های <code>encoding/json/v2</code> برای API سطح‌بالا و <code>encoding/json/jsontext</code> برای پردازش token/value سطح‌پایین اضافه کرد. نسخهٔ v2 گزینه‌های قابل‌تنظیم دارد و پیش‌فرض‌های سخت‌گیرانه‌تری می‌گذارد؛ از جمله UTF-8 نامعتبر و نام تکراری در یک object را رد می‌کند. API قدیمی <code>encoding/json</code> همچنان پشتیبانی می‌شود و روی implementation جدید تکیه دارد؛ رفتار marshal/unmarshal آن باید حفظ شود، هرچند متن دقیق برخی errorها ممکن است فرق کند.

برای پروژهٔ Go 1.27 می‌توان این APIها را صریح import کرد:

~~~go
import jsonv2 "encoding/json/v2"

data, err := jsonv2.Marshal(value)
if err != nil {
	return err
}
~~~

اگر JSON موجود به duplicate key یا UTF-8 نامعتبر تکیه دارد، پیش از مهاجرت سازگاری را بررسی کن. برای یادگیری پایهٔ struct، encode و decode این دوره همچنان از API رایج v1 استفاده می‌کند؛ v2 را بر اساس نیاز strictness و قرارداد مشتری انتخاب کن، نه صرفاً به‌خاطر شمارهٔ جدید.
## ۵) Time و Duration دو مفهوم جدا هستند

<code>time.Time</code> یک لحظهٔ زمانی را نمایش می‌دهد؛ <code>time.Duration</code> فاصلهٔ زمانی بر حسب nanosecond است. برای timeout و elapsed time از Duration استفاده کن، نه عدد خامی که واحدش نامعلوم است.

</div>

~~~go
timeout := 3 * time.Second
deadline := time.Now().Add(timeout)
fmt.Println(deadline)
~~~

<div dir="rtl">

از عملگرهای duration مثل <code>time.Second</code> استفاده کن تا واحد در خود کد دیده شود. در timestamp بیرونی معمولاً UTC ذخیره/منتقل کن و timezone محلی را فقط برای نمایش یا قانون business منطقه‌ای اعمال کن. ساعت دیواری ممکن است جابه‌جا شود؛ مقایسهٔ elapsed time با <code>time.Now</code> و <code>Since</code> در یک process از جزء monotonic داخلی استفاده می‌کند، اما serialization آن جزء را حفظ نمی‌کند.

## ۶) فرمت زمان در Go

Go به‌جای الگوی printf از یک layout reference استفاده می‌کند: تاریخ مرجع ۲ ژانویهٔ ۲۰۰۶ ساعت ۳:04:05 بعدازظهر با منطقهٔ زمانی -0700. برای ساخت layout، همان اعداد/کلمات مرجع را به شکل دلخواه مرتب کن.

~~~go
const layout = "2006-01-02 15:04:05 -0700"
parsed, err := time.Parse(layout, "2026-11-10 14:30:00 +0330")
if err != nil {
	return err
}
fmt.Println(parsed.UTC())
~~~

</div>
<div dir="rtl">

<code>time.Parse</code> بدون location برای offset صریح مناسب است. برای رشتهٔ زمانی بدون offset و با منطقهٔ قراردادی، <code>time.ParseInLocation</code> می‌تواند timezone را مشخص کند. timezoneهایی با تغییر ساعت فصلی (DST) ممکن است بعضی local timeها را دوپهلو یا ناموجود کنند؛ برای برنامه‌ریزی رویداد محلی این سیاست را روشن کن.

## ۷) چه وقت از APIهای stream استفاده کنیم؟

- فایل بزرگ یا شبکه: Reader/Writer و پردازش تدریجی.
- JSON کوچک با حد اندازهٔ روشن: Decode/Marshal struct.
- HTTP response body: حتماً Close شود.
- input user-facing: محدودسازی اندازه، parse، validation و پیام امن.
- timestamp machine-readable: RFC3339/UTC معمولاً روشن‌تر از فرمت اختصاصی.
- اندازه‌گیری مدت سپری‌شده: Duration/monotonic clock؛ نه تفریق تاریخ‌های رشته‌ای.

## ۸) ابزارهای روزمرهٔ standard library

Roadmap علاوه بر I/O، JSON و زمان، چند package پرکاربرد دیگر را هم نام می‌برد.

### flag برای ورودی CLI

برای ابزار کوچک از <code>flag</code> شروع کن. در برنامهٔ بزرگ‌تر یک <code>FlagSet</code> مجزا می‌تواند parsing را از logic command جدا و تست‌پذیر کند:

~~~go
func parseArgs(args []string) (string, bool, error) {
	flags := flag.NewFlagSet("report", flag.ContinueOnError)
	output := flags.String("output", "report.json", "مسیر خروجی")
	verbose := flags.Bool("verbose", false, "نمایش جزئیات")
	if err := flags.Parse(args); err != nil {
		return "", false, err
	}
	return *output, *verbose, nil
}
~~~

از flag برای secretهایی مثل password استفاده نکن؛ process list، shell history یا log ممکن است آن را افشا کنند. بعد از parsing، مقدارهای دامنه را validate کن.

### os برای process و filesystem

<code>os</code> آرگومان و environment، فایل و directory، permission و process exit را مدیریت می‌کند. برای فایل کوچک با سقف اندازه از <code>os.ReadFile</code>؛ برای فایل بزرگ از <code>os.Open</code> و stream استفاده کن. permission را حداقلی تنظیم کن، ورودی path را validate کن و error را در boundary توضیح بده. <code>os.Exit</code> process را فوراً خاتمه می‌دهد و deferها را اجرا نمی‌کند؛ cleanup را پیش از exit در ساختار تابعی انجام بده.

### bufio برای I/O bufferشده

<code>bufio.Scanner</code> برای line/tokenهای متنی ساده مناسب است؛ سقف token پیش‌فرض محدود است. اگر line بزرگ‌تر می‌شود، <code>Scanner.Buffer</code> را با سقف موردنیاز تنظیم کن یا <code>bufio.Reader</code> را برای پروتکل‌های پیچیده‌تر انتخاب کن. حتی با buffer بزرگ، ورودی نامطمئن را بی‌سقف نپذیر. هر خطای scanner را پس از loop با <code>scanner.Err()</code> بررسی کن.

### regexp برای patternهای محدود

Package <code>regexp</code> برای pattern matching مناسب و در برابر backtracking نماییِ برخی موتورهای regex مقاوم طراحی شده است؛ syntax آن backreference و lookbehind عمومی را ندارد. pattern ثابت را یک‌بار compile کن، نه در هر request. <code>regexp.MustCompile</code> فقط برای pattern ثابت برنامه که compile failure یعنی bug است مناسب است؛ pattern کاربر را با <code>Compile</code> parse و خطایش را برگردان.

### slog برای structured logging

<code>log/slog</code> از Go 1.21 standard structured logging می‌دهد. handler متنی برای terminal و JSON برای machine processing انتخاب کن. فیلدهای key/value مانند operation، request_id و duration را ثبت کن؛ secret و payload حساس را حذف یا redact کن. Log جای metric و trace را نمی‌گیرد و هر error نباید در چند لایه تکراری log شود.

### embed برای فایل همراه binary

Directive <code>//go:embed</code> از Go 1.16 به بعد فایل‌های build-time را در executable/package قرار می‌دهد. pattern مسیر باید نسبت به پوشهٔ package باشد و فایل معمولاً در همان package subtree قرار گیرد:

~~~go
package web

import (
	"embed"
	"net/http"
)

//go:embed assets/*
var assets embed.FS

func assetHandler() http.Handler {
	return http.FileServer(http.FS(assets))
}
~~~

Embed برای template، schema یا فایل ایستای versionشده مناسب است؛ secret، config محیط deployment یا داده‌ای که باید بدون build تغییر کند را embed نکن. فایل embedشده هم باید lifecycle و license خودش را داشته باشد.
## تجربهٔ عملی

در یک endpoint upload که body نامحدود را به <code>io.ReadAll</code> می‌دهد، چند درخواست بزرگ می‌تواند حافظهٔ process را مصرف کند؛ stream و سقف اندازه فشار را محدود می‌کند. در export JSON، ساخت یک buffer کامل ممکن است peak memory را بالا ببرد؛ Encoder روی Writer stream می‌نویسد. در log، UTC و format استاندارد مقایسهٔ رخدادها را میان hostهای مناطق زمانی مختلف آسان‌تر می‌کند. این‌ها الگوهای عمومی عملیاتی هستند؛ سقف اندازه و قرارداد timestamp باید با محصول تعیین شوند.

## خطاهای رایج

- استفاده از <code>io.ReadAll</code> برای ورودی نامحدود.
- فراموش‌کردن Close کردن response body یا فایل.
- تصور اینکه JSON decode موفق یعنی business input معتبر است.
- فرض اینکه همهٔ عددهای JSON در <code>any</code> به شکل صحیح حفظ می‌شوند.
- نادیده‌گرفتن trailing JSON value.
- قبول unknown fields بدون تصمیم دربارهٔ compatibility.
- استفاده از timestamp محلی برای ذخیره‌سازی سراسری.
- قاطی‌کردن Duration و timestamp.
- ساخت layout با الگوی تاریخ زبان‌های دیگر.
- نادیده‌گرفتن تغییر DST برای زمان محلی.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: محدودسازی body

برای endpointی که JSON می‌گیرد سقف ۱ MiB بگذار، سپس struct را decode و field لازم را بررسی کن.

**پاسخ:** از <code>http.MaxBytesReader</code>، decoder و validation جداگانه استفاده کن؛ نمونهٔ بخش ۳ الگو را نشان می‌دهد.

### تمرین ۲: JSON trailing

چرا یک بار <code>Decode</code> ممکن است کافی نباشد؟

**پاسخ:** stream می‌تواند JSON معتبر اول و سپس مقدار دیگری داشته باشد؛ decode دوم باید <code>io.EOF</code> ببیند اگر فقط یک value پذیرفته می‌شود.

### تمرین ۳: timezone

رشتهٔ زمان شامل <code>Z</code> یا offset دارد؛ چرا UTC کردن مفید است؟

**پاسخ:** instant را مستقل از timezone نمایش می‌دهد و مقایسه/ذخیرهٔ سراسری روشن‌تر می‌شود؛ display می‌تواند بعداً به timezone کاربر تبدیل شود.

### تمرین ۴: عدد JSON

ID بزرگ را به <code>any</code> decode کرده‌ای و دقت کم شده. پاسخ: فیلد struct را <code>int64</code> تعریف کن، یا از <code>UseNumber</code> استفاده و parse دقیق انجام بده؛ float را برای ID به‌کار نبر.

## کوییز

### پرسش‌ها

1. Reader چه قراردادی می‌دهد؟
2. چرا Reader/Writer برای فایل و HTTP مفیدند؟
3. EOF در Reader چه مفهومی دارد؟
4. چه زمانی ReadAll نامناسب است؟
5. JSON decode موفق چه چیزی را تضمین نمی‌کند؟
6. MaxBytesReader از چه خطری جلوگیری می‌کند؟
7. چرا یک بار Decode برای یک object ممکن است کافی نباشد؟
8. DisallowUnknownFields چه trade-offی دارد؟
9. هنگام decode عدد JSON در any چه دقتی ممکن است از بین برود؟
10. چرا HTTP response body را Close می‌کنیم؟
11. Time و Duration چه تفاوتی دارند؟
12. layout زمان Go بر چه مرجعی ساخته می‌شود؟
13. برای timestamp بیرونی معمولاً چه timezone مناسب است؟
14. ParseInLocation چه زمانی مفید است؟
15. چرا DST زمان محلی را دوپهلو می‌کند؟
16. monotonic component در serialization حفظ می‌شود؟
17. چرا status body/validation باید جدا باشند؟
18. برای خروجی JSON stream از چه API استفاده می‌کنی؟
19. چه وقت Scanner.Buffer را تنظیم می‌کنی؟
20. os.Exit چه اثری بر defer دارد؟
21. چرا pattern regex ورودی کاربر را با Compile می‌سنجیم؟
22. slog چه نوع logی می‌سازد؟
23. go:embed از کدام نسخه وجود دارد و چه چیزی را embed می‌کند؟
24. چه چیزهایی را نباید در binary embed کرد؟
25. کدام دو package جدید برای JSON در Go 1.27 آمده‌اند؟
26. دو پیش‌فرض سخت‌گیرانهٔ v2 را نام ببر.

### کلید پاسخ

1. bytes را در buffer caller قرار می‌دهد و تعداد/error را می‌دهد.
2. به تابع وابستگی به storage/network concrete را کم و stream را ممکن می‌کنند.
3. stream دیگر داده ندارد؛ در بسیاری از loopها پایان طبیعی است.
4. وقتی ورودی نامحدود/بزرگ است یا حافظه باید محدود بماند.
5. قواعد domain و امنیت را.
6. مصرف بی‌حد حافظه از body نامطمئن را.
7. ممکن است value دوم پس از object اول وجود داشته باشد.
8. schema strict و خطای typo را بهتر می‌کند، ولی evolution/forward compatibility را سخت می‌کند.
9. float64 ممکن است integer بزرگ را دقیق نگه ندارد.
10. resource و connection قابل‌بازیافت شوند.
11. Time لحظه است؛ Duration فاصله.
12. layout reference ثابت 2006-01-02 15:04:05 -0700.
13. معمولاً UTC برای ذخیره/انتقال.
14. وقتی ورودی offset ندارد و باید در timezone مشخص تفسیر شود.
15. ساعت می‌تواند عقب/جلو برود و local time تکرار یا حذف شود.
16. خیر.
17. شکل JSON فقط ساختار را parse می‌کند؛ قواعد کسب‌وکار جدا هستند.
18. <code>json.NewEncoder(writer).Encode</code>.
19. وقتی token/line مجاز از سقف پیش‌فرض بزرگ‌تر است؛ یک سقف امن تعیین کن.
20. process را فوراً خاتمه می‌دهد و deferها را اجرا نمی‌کند.
21. چون ورودی ممکن است syntax نامعتبر یا هزینه‌ساز داشته باشد و باید error کنترل‌شده بدهیم؛ pattern را در هر call دوباره compile نکن.
22. log ساخت‌یافته با fieldهای key/value و level.
23. Go 1.16؛ فایل‌های build-time در package.
24. secret، config محیطی یا داده‌ای که باید مستقل از build تغییر کند.
25. <code>encoding/json/v2</code> و <code>encoding/json/jsontext</code>.
26. ردکردن UTF-8 نامعتبر و نام‌های تکراری در object، مگر option/policy آن را تغییر دهد.

## منابع

- انگلیسی: [Go package io](https://pkg.go.dev/io)
- انگلیسی: [Go package encoding/json](https://pkg.go.dev/encoding/json)
- انگلیسی: [Go package time](https://pkg.go.dev/time)
- انگلیسی: [Go package flag](https://pkg.go.dev/flag), [os](https://pkg.go.dev/os), [bufio](https://pkg.go.dev/bufio), [regexp](https://pkg.go.dev/regexp), [log/slog](https://pkg.go.dev/log/slog), [embed](https://pkg.go.dev/embed)
- انگلیسی: [Go Blog — JSON and Go](https://go.dev/blog/json)
- انگلیسی: [Go 1.27 release notes — JSON v2](https://go.dev/doc/go1.27#encoding_json_v2)
- انگلیسی: [Go package net/http/httptest](https://pkg.go.dev/net/http/httptest)
- انگلیسی: [Go embed directive](https://pkg.go.dev/embed#hdr-Directives)
- فارسی: [GoFarsi — کتابخانهٔ استاندارد و JSON](https://cloud-book.gofarsi.ir/chapter-3/)
- فارسی: [مجموعهٔ فارسی GoFarsi](https://book.gofarsi.ir/chapter-3/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
