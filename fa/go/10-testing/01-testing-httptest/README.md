# ۱۰.۱ — تست، table-driven test و httptest

<div dir="rtl">

**زمان پیشنهادی:** ۱۷۰ دقیقه · **پیش‌نیاز:** function، package، error و HTTP پایه  
**هدف:** رفتار را از دید caller تثبیت کنی، حالت‌های مرزی را پوشش دهی و HTTP را بدون وابستگی به اینترنت تست کنی.

## نقشهٔ این درس

- ساختار تست در Go
- <code>go test</code> و convention نام‌گذاری
- تست table-driven و subtest
- assertion با کتابخانهٔ استاندارد
- helper و cleanup
- تست handler با ResponseRecorder
- تست server/client با httptest
- تست error و boundary
- تست واحد، integration و end-to-end
- پرهیز از تست شکننده

## ۱) تست Go یک function با قرارداد مشخص است

فایل تست پسوند <code>_test.go</code> دارد و تابع تست با <code>Test</code> شروع می‌شود. signature آن <code>func TestXxx(t *testing.T)</code> است. framework استاندارد برای test نیاز به assertion library خارجی ندارد؛ مقایسه را با شرط‌ها و پیام تشخیصی بنویس. نام test باید رفتاری را بیان کند، نه جزئیات پیاده‌سازی.

برای اجرای تست‌ها:

</div>

~~~powershell
go test ./...
go test -run TestGreet ./...
go test -v ./...
~~~

<div dir="rtl">

اولین فرمان تمام packageهای module را آزمایش می‌کند. اگر شکست رخ دهد، خروجی باید ورودی و expected/actual را نشان دهد تا علت پیدا شود. از تستی که فقط می‌گوید «مقدار غلط بود» استفاده نکن.

## ۲) تابع ساده و table-driven test

چند ورودی برای یک رفتار معمولاً در table-driven test قرار می‌گیرند: اسم مورد، ورودی، انتظار. هر ردیف یک subtest مستقل می‌شود.

~~~go
package textutil

import "strings"

func NormalizeSpace(value string) string {
	return strings.Join(strings.Fields(value), " ")
}
~~~

~~~go
package textutil

import "testing"

func TestNormalizeSpace(t *testing.T) {
	tests := []struct {
		name string
		in   string
		want string
	}{
		{name: "spaces", in: "  one   two ", want: "one two"},
		{name: "empty", in: "", want: ""},
		{name: "single", in: "go", want: "go"},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			got := NormalizeSpace(test.in)
			if got != test.want {
				t.Fatalf("NormalizeSpace(%q) = %q; want %q", test.in, got, test.want)
			}
		})
	}
}
~~~

</div>
<div dir="rtl">

تابع تست فایل جداگانه می‌تواند همان package باشد یا <code>package textutil_test</code> تا فقط public API را ببیند. اسم <code>t.Run</code> گزارش failure را دقیق‌تر می‌کند. در تستی که قرار است بقیهٔ checkها ادامه یابند از <code>t.Errorf</code>، و وقتی ادامهٔ همان test بی‌معنی است از <code>t.Fatalf</code> استفاده کن.

## ۳) تست باید رفتار را ثابت کند

Test را به invariantهای observable وصل کن: ورودی معتبر چه نتیجه می‌دهد؟ ورودی مرزی؟ error چه نوع یا متنی دارد؟ side effect مهم چیست؟ تستی که private field را بی‌دلیل assert می‌کند ممکن است refactor سالم را بشکند. رفتار بیرونی را بیازمای، مگر آنکه جزئیات داخلی خودشان invariant مهم باشند.

برای error، caller باید علت را با <code>errors.Is</code>/<code>errors.As</code> بررسی کند. اگر قرارداد فقط وجود خطا را تضمین می‌کند، کل متن آن را به شکل brittle قفل نکن. اگر پیام برای CLI بخشی از UX است، تست پیام ممکن است موجه باشد.

## ۴) HTTP handler را بدون network تست کن

برای handler مستقل از router/server، <code>httptest.NewRequest</code> و <code>httptest.NewRecorder</code> به کار می‌روند. هیچ پورت TCP واقعی باز نمی‌شود.

~~~go
package web

import (
	"fmt"
	"net/http"
)

func Greet(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		w.Header().Set("Allow", http.MethodGet)
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	name := r.URL.Query().Get("name")
	if name == "" {
		name = "world"
	}
	fmt.Fprintf(w, "hello, %s", name)
}
~~~

~~~go
package web

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestGreet(t *testing.T) {
	tests := []struct {
		name       string
		method     string
		path       string
		wantStatus int
		wantBody   string
	}{
		{
			name: "default name", method: http.MethodGet, path: "/greet",
			wantStatus: http.StatusOK, wantBody: "hello, world",
		},
		{
			name: "custom name", method: http.MethodGet, path: "/greet?name=Ada",
			wantStatus: http.StatusOK, wantBody: "hello, Ada",
		},
		{
			name: "reject post", method: http.MethodPost, path: "/greet",
			wantStatus: http.StatusMethodNotAllowed, wantBody: "method not allowed\n",
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			request := httptest.NewRequest(test.method, test.path, nil)
			recorder := httptest.NewRecorder()

			Greet(recorder, request)

			if recorder.Code != test.wantStatus {
				t.Fatalf("status = %d; want %d", recorder.Code, test.wantStatus)
			}
			if recorder.Body.String() != test.wantBody {
				t.Errorf("body = %q; want %q", recorder.Body.String(), test.wantBody)
			}
		})
	}
}
~~~

</div>
<div dir="rtl">

در application واقعی علاوه بر status/body، headerهای قراردادی، محتوای JSON و error pathهای معنادار را تست کن. برای JSON، decode کن و field را assert کن؛ مقایسهٔ رشتهٔ کامل JSON ممکن است ترتیب/spacing غیرمهم را قفل کند.

## ۵) httptest.Server برای تست client و wire behavior

اگر باید رفتار client، middleware، routing، header یا تعامل واقعی HTTP را آزمایش کنی، <code>httptest.NewServer</code> یک server محلی تستی می‌سازد. متد <code>Close</code> را با <code>defer</code> ثبت کن.

</div>

~~~go
server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
	if r.Header.Get("X-Request-ID") == "" {
		http.Error(w, "missing request id", http.StatusBadRequest)
		return
	}
	w.WriteHeader(http.StatusAccepted)
}))
defer server.Close()

request, err := http.NewRequest(http.MethodGet, server.URL, nil)
if err != nil {
	t.Fatal(err)
}
request.Header.Set("X-Request-ID", "test-123")

response, err := server.Client().Do(request)
if err != nil {
	t.Fatal(err)
}
defer response.Body.Close()

if response.StatusCode != http.StatusAccepted {
	t.Fatalf("status = %d; want %d", response.StatusCode, http.StatusAccepted)
}
~~~

<div dir="rtl">

این تست به اینترنت وابسته نیست و server را روی local ephemeral port اجرا می‌کند. اگر client timeout دارد، test client هم timeout معقول بگذار تا خطای hanging به timeout کل CI تبدیل نشود. تست handler ساده را با recorder نگه‌دار؛ server کامل را فقط وقتی لایهٔ transport یا client جزو رفتار موردآزمون است انتخاب کن.

از Go 1.27، <code>httptest.NewTestServer</code> نیز یک شبکهٔ fake درون‌حافظه‌ای فراهم می‌کند و با <code>testing/synctest</code> برای بعضی تست‌های transport/زمان هماهنگ‌تر است. برای handler مستقیم، <code>ResponseRecorder</code> همچنان ساده‌ترین گزینه است؛ برای wire behavior به‌دنبال API مناسب نسخهٔ هدف بگرد. چون این helper به Go 1.27 نیاز دارد، تست module قدیمی‌تر باید از <code>NewServer</code> یا recorder استفاده کند.
## ۶) test helper و cleanup

Helperی که check انجام می‌دهد باید <code>t.Helper()</code> را صدا بزند تا خطا به محل caller نسبت داده شود. Resource تستی را با <code>t.Cleanup</code> یا defer آزاد کن. برای setup مشترک، از global mutable state دوری کن؛ parallel test ممکن است آن را race کند.

</div>

~~~go
func requireStatus(t *testing.T, got, want int) {
	t.Helper()
	if got != want {
		t.Fatalf("status = %d; want %d", got, want)
	}
}
~~~

<div dir="rtl">

از <code>t.Parallel()</code> برای کوتاه‌کردن تست استفاده کن فقط وقتی تست و fixture مستقل و concurrency-safe هستند. Go 1.22 semantics متغیر loop را تغییر داد، اما برای کد قدیمی و نسخهٔ module باید همچنان semantics language directive را در نظر گرفت. تست‌های مستقل را واقعاً مستقل بساز.

## Test double: stub، fake و mock

برای test کردن service بدون database واقعی، یک dependency رفتاری کوچک تعریف کن و پیاده‌سازی آزمایشی بساز. این مثال یک stub است که همیشه نتیجهٔ مشخص می‌دهد:

~~~go
type User struct {
	Name string
}

type UserStore interface {
	Find(context.Context, string) (User, error)
}

type ProfileService struct {
	store UserStore
}

func (s ProfileService) DisplayName(ctx context.Context, id string) (string, error) {
	user, err := s.store.Find(ctx, id)
	if err != nil {
		return "", err
	}
	return user.Name, nil
}

type stubUserStore struct {
	user User
	err  error
}

func (s stubUserStore) Find(context.Context, string) (User, error) {
	return s.user, s.err
}
~~~

تست می‌تواند <code>ProfileService{store: stubUserStore{user: User{Name: "Ada"}}}</code> بسازد و نتیجه را بررسی کند. Stub پاسخ ثابت می‌دهد؛ fake رفتار ساده اما واقعی‌تری مانند map-backed storage دارد؛ mock معمولاً انتظار interactionها را ثبت و assert می‌کند. در Go اغلب fake/stub کوچک دستی از framework پیچیده خواناتر است. فقط وقتی «چند بار و با چه آرگومان» بخشی از contract test است، interaction را صریح ثبت کن. Interface را در نزدیکی مصرف‌کننده و فقط با متدهای لازم تعریف کن.
## ۷) unit، integration و end-to-end

- Unit test یک رفتار محدود را با dependencyهای کوچک می‌سنجد.
- Integration test ارتباط چند بخش واقعی، مثل handler و database تستی، را می‌سنجد.
- End-to-end مسیر کاربر را از مرزهای بیشتر سامانه طی می‌کند و کندتر و شکننده‌تر است.

این نام‌ها مرز ریاضی ندارند، اما هزینه و هدف را روشن می‌کنند. برای test integration، dependencyهای تست را با config، container یا fake کنترل‌شده فراهم کن. از testهای unit انتظار ثابت‌کردن semantics database واقعی را نداشته باش؛ و از integration test برای هر branch سادهٔ parser استفاده نکن.

## ۸) تست زمان، randomness و dependencyها

تست نباید به زمان واقعی، ترتیب تصادفی، اینترنت عمومی، حساب واقعی یا sleep وابسته باشد. Clock یا random source را از بیرون تزریق کن اگر زمان‌بندی بخشی از منطق است. برای timeout، context و channel synchronization استفاده کن، نه delay ثابت. در تست network، server تستی و deadline محدود بگذار. تست flaky اعتماد تیم به CI را کم می‌کند.

## خطاهای رایج

- نوشتن تست فقط برای رسیدن به coverage percentage.
- انتظار متن دقیق خطای داخلی بدون قرارداد.
- تست handler با network واقعی یا سرویس بیرونی.
- نداشتن timeout برای HTTP client تست.
- اشتراک map یا fixture mutable میان parallel testها.
- استفاده از sleep برای انتظار کار goroutine.
- بررسی فقط status، بدون body/header مهم.
- assert کردن جزئیات داخلی شکننده به‌جای رفتار.
- فراموش‌کردن بستن httptest.Server و response body.
- تست موفقیت، بدون ورودی مرزی و مسیر خطا.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: table-driven

برای parser خود سه ردیف بساز: ورودی درست، ورودی malformed، ورودی مرزی. برای هر کدام expected value و وجود/نوع error را مشخص کن.

**پاسخ:** table شامل name، input، want، wantErr باشد؛ هر case زیر <code>t.Run</code> اجرا شود. برای error sentinel از <code>errors.Is</code> استفاده کن.

### تمرین ۲: method نامعتبر HTTP

برای handler بخش ۴، درخواست POST را تست کن و status، body و <code>Allow</code> را بررسی کن.

**پاسخ:** در مثال handler header Allow set شده؛ test را طوری گسترش بده که <code>recorder.Header().Get("Allow")</code> برابر GET باشد.

### تمرین ۳: client بدون اینترنت

برای client خود httptest.Server بساز که header یا JSON را بررسی کند. پاسخ: server را با handler تستی بالا بیاور، <code>server.URL</code> را به client بده و در پایان response body و server را ببند.

### تمرین ۴: تشخیص flaky test

Test گاهی fail می‌شود چون <code>time.Sleep(10*time.Millisecond)</code> کافی نیست. پاسخ: به‌جای افزایش sleep، synchronization صریح با channel/WaitGroup و deadline test به‌کار ببر و lifecycle goroutine را انتظار بکش.

## کوییز

### پرسش‌ها

1. نام فایل تست Go چه suffixی دارد؟
2. signature معمول تابع تست چیست؟
3. table-driven test چه فایده‌ای دارد؟
4. <code>t.Run</code> چه کمکی می‌کند؟
5. تفاوت <code>Errorf</code> و <code>Fatalf</code> چیست؟
6. چرا پیام خطا را همیشه byte-for-byte assert نمی‌کنیم؟
7. recorder برای چه تستی مناسب است؟
8. httptest.Server برای چه زمانی مفید است؟
9. چرا server و response body را می‌بندیم؟
10. <code>t.Helper</code> چه می‌کند؟
11. چه زمانی <code>t.Parallel</code> امن است؟
12. چرا sleep در تست هم‌زمان شکننده است؟
13. تست unit چه چیزی را هدف می‌گیرد؟
14. تست integration چه چیزی را می‌سنجد؟
15. چرا coverage بالا کیفیت تست را ثابت نمی‌کند؟
16. چرا dependency بیرونی را در هر unit test واقعی صدا نمی‌زنیم؟
17. برای درخواست HTTP test چه resource کنترلی اضافه می‌کنی؟
18. برای تست handler JSON چگونه assertion پایدارتر می‌نویسی؟
19. فرق stub، fake و mock چیست؟
20. برای unit test چرا معمولاً fake/stub کوچک مفید است؟
21. چه وقت ResponseRecorder را به NewTestServer ترجیح می‌دهی؟
22. NewTestServer از چه نسخه‌ای در دسترس است؟

### کلید پاسخ

1. <code>_test.go</code>.
2. <code>func TestName(t *testing.T)</code>.
3. چند ورودی/حالت را با شکل واحد و گزارش مستقل می‌سنجد.
4. case مستقل و نام‌دار برای گزارش می‌سازد.
5. Errorf ثبت خطا و ادامه؛ Fatalf ثبت و پایان همان test.
6. چون متن ممکن است جزئیات implementation باشد؛ علت/type یا UX قراردادی را assert کن.
7. اجرای مستقیم handler بدون پورت واقعی.
8. تست client/transport/routing و رفتار HTTP بین اجزا.
9. برای جلوگیری از نشت resource و باقی‌ماندن test server.
10. stack گزارش را به caller helper نزدیک می‌کند.
11. وقتی fixture، global و وابستگی‌ها مستقل و concurrency-safe باشند.
12. timing میان machineها و loadها متفاوت است و synchronization نیست.
13. یک رفتار محدود.
14. ارتباط چند جزء واقعی و مرز integration.
15. ممکن است خطوط اجرا شوند بدون اینکه نتیجه یا invariant بررسی شود.
16. زمان، flakiness، هزینه، دسترسی و وابستگی خارجی را حذف می‌کنیم.
17. timeout/deadline.
18. JSON را decode و fieldهای قرارداد را بررسی کن، به‌جای مقایسهٔ raw formatting.
19. stub پاسخ ثابت می‌دهد؛ fake رفتار سادهٔ واقعی دارد؛ mock interaction مورد انتظار را ثبت/assert می‌کند.
20. dependency بیرونی را ایزوله می‌کند، سریع و deterministic می‌ماند، و برای نیاز محدود framework اضافی نمی‌آورد.
21. وقتی فقط رفتار handler را مستقیم می‌سنجی و نیازی به transport/client واقعی نیست.
22. Go 1.27.

## منابع

- انگلیسی: [Go tutorial — Add a test](https://go.dev/doc/tutorial/add-a-test)
- انگلیسی: [Go package testing](https://pkg.go.dev/testing)
- انگلیسی: [Go package net/http/httptest](https://pkg.go.dev/net/http/httptest)
- انگلیسی: [Go 1.27 release notes — httptest](https://go.dev/doc/go1.27#net_http_httptest)
- انگلیسی: [Go Wiki — Table-driven tests](https://go.dev/wiki/TableDrivenTests)
- انگلیسی: [Go package testing](https://pkg.go.dev/testing)
- انگلیسی: [Go blog — Testing](https://go.dev/doc/tutorial/fuzz)
- فارسی: [GoFarsi — تست و ابزارهای Go](https://cloud-book.gofarsi.ir/chapter-3/)
- فارسی: [مجموعهٔ آموزش GoFarsi](https://book.gofarsi.ir/chapter-3/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
