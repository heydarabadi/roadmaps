# ۱.۳ — ابزارهای Go و خواندن مستندات

<div dir="rtl">

**زمان پیشنهادی:** ۷۵ دقیقه · **پیش‌نیاز:** نصب Go و module · **هدف:** بتوانی اجرای برنامه، build، test، format، dependency و مستندات API را بدون حدس مدیریت کنی.

## مدل ذهنی: `go` یک toolchain است

`go` فقط compiler نیست؛ فرمان اصلی چند ابزار هماهنگ را اجرا می‌کند. معمولاً توسعه‌دهنده فرمان `go` را صدا می‌زند و toolchain تشخیص می‌دهد packageها در کدام module هستند، چه فایل‌هایی باید کامپایل شوند و چه وابستگی‌هایی لازم‌اند. فرمان‌ها را از module root اجرا کن، مگر اینکه مستندات دستور حالت دیگری بگوید.

ابتدا این سه فرمان را بشناس:

</div>

```powershell
go version
go env GOMOD GOPATH GOROOT GOOS GOARCH
go help
```

<div dir="rtl">

`go version` نسخهٔ فعال را می‌گوید. `go env` مقادیر محیطی‌ای را که toolchain می‌بیند چاپ می‌کند. `go help` فهرست فرمان‌ها و `go help test` راهنمای یکی از آن‌هاست. اگر build روی دو ماشین فرق می‌کند، قبل از تغییر source، نسخه و environment هر دو را مقایسه کن.

## فرمان‌های مهم با رفتار دقیق

### `go run`

</div>

```powershell
go run .
go run .\cmd\worker
```

<div dir="rtl">

package را build و اجرا می‌کند. برای اجرای روزمره مناسب است؛ فایل اجرایی پایدار برای توزیع نمی‌سازد. آرگومان برنامه بعد از package/فایل می‌آید: `go run . -- --input data.csv` ممکن است `--` را به برنامه بدهد؛ برای ابزار واقعی رفتار آرگومان را آزمایش کن.

### `go build`

</div>

```powershell
go build ./...
go build -o .\bin\server.exe .\cmd\server
```

<div dir="rtl">

فرمان اول packageهای زیر module فعلی را build-check می‌کند؛ چون چند package دارد معمولاً یک binary واحد تولید نمی‌کند. فرمان دوم package اجرایی مشخص را به فایل تعیین‌شده تبدیل می‌کند. `GOOS` و `GOARCH` هدف build را تغییر می‌دهند؛ `CGO_ENABLED` و dependencyهای native هم می‌توانند بر قابل‌حمل‌بودن خروجی اثر بگذارند.

### `go install`

</div>

```powershell
go install .\cmd\mytool
```

<div dir="rtl">

برای نصب command توسعه‌یافته در module جاری استفاده می‌شود و binary معمولاً به پوشهٔ `bin` در `GOPATH` می‌رود. برای نصب یک ابزار بیرون از پروژه، شکل نسخه‌دار `go install example.com/tool@v1.2.3` مناسب است؛ این حالت dependencyهای module جاری را تغییر نمی‌دهد. نسخهٔ مشخص را برای build تکرارپذیر بهتر از `@latest` ثبت کن.

### فرمت و کیفیت پایه

</div>

```powershell
gofmt -w .\main.go
go fmt ./...
go vet ./...
```

<div dir="rtl">

`gofmt` یک فایل/فایل‌ها را به قالب استاندارد می‌برد؛ `go fmt ./...` روی packageهای انتخاب‌شده کار می‌کند. `go vet` تحلیل‌های ایستای مشکوک را اجرا می‌کند، ولی compiler یا تست همهٔ خطاها را پیدا نمی‌کنند. پس از formatting، diff را مرور کن تا تغییر فایل ناخواسته از چشم دور نماند.

### تست و وابستگی

</div>

```powershell
go test ./...
go test -run '^TestParse$' ./internal/parser
go mod tidy
go list -m all
```

<div dir="rtl">

`go test ./...` packageهای زیر مسیر جاری را تست می‌کند، اما به moduleهای nested وارد نمی‌شود. `-run` نام test را با regular expression فیلتر می‌کند. `go mod tidy` importهای source و test را بررسی می‌کند و `go.mod`/`go.sum` را مرتب می‌کند؛ بعد از اجرا تغییر فایل‌ها را بازبینی کن. `go list -m all` نسخه‌های moduleهای graph را نشان می‌دهد.

### مستندات و جست‌وجوی API

</div>

```powershell
go doc fmt.Printf
go doc net/http.Client
```

<div dir="rtl">

`go doc` مستندات package و symbol را از همان محیط/ماژول پیدا می‌کند. `pkg.go.dev` برای مرور آنلاین package و نسخه‌هاست؛ نسخهٔ آن را با `go.mod` پروژه تطبیق بده. `Effective Go` راهنمای ارزشمند سبک پایه است، اما خودش تصریح می‌کند که از ۲۰۰۹ است و generics و modules امروزی را پوشش نمی‌دهد؛ برای رفتار دقیق زبان، spec و مستندات جاری را بخوان.

## یک چرخهٔ معمول در پروژه

از ریشهٔ module: `gofmt -w` روی فایل‌های تغییرکرده، `go test ./...`، `go vet ./...` و سپس `go build ./cmd/app`. اگر وابستگی اضافه یا حذف شده، `go mod tidy` را اجرا و diff `go.mod` و `go.sum` را بررسی کن. در گزارش bug نسخهٔ Go، فرمان دقیق، OS/architecture و خطای کامل را ثبت کن.

`go clean` cache/build artifactهای مشخصی را پاک می‌کند. پاک‌کردن module cache همهٔ dependencyها را برای دانلود مجدد نیازمند می‌کند؛ از فرمان پاک‌سازی گسترده برای «حل هر خطا» استفاده نکن.

## تمرین مرحله‌ای

1. `go help test` را باز کن و مفهوم `-run` را در یک جمله توضیح بده.
2. در پروژه‌ای دارای `cmd/server`, فقط آن executable را بساز.
3. یک dependency در import اضافه کن، `go mod tidy` بزن و تغییرات دو فایل module را ببین.
4. نسخهٔ Go و `GOOS/GOARCH` را برای ثبت در یک گزارش عیب‌یابی چاپ کن.

### پاسخ نمونهٔ فرمان ۲

</div>

```powershell
go build -o .\bin\server.exe .\cmd\server
```

<div dir="rtl">

پوشهٔ `bin` باید پیش از build ساخته شود یا از مسیری استفاده کنی که وجود دارد. این فرمان package اجرایی زیر `cmd/server` را هدف می‌گیرد، نه تمام packageها را به یک binary تبدیل.

## کوییز

### پرسش‌ها

1. فرق compile و execute در `go build` و `go run` چیست؟
2. چرا `go build ./...` لزوماً یک executable تولید نمی‌کند؟
3. `go install tool@version` چه تفاوتی با build ابزار داخل module دارد؟
4. `go fmt` و `go vet` چه نوع مسئله‌ای را هدف می‌گیرند؟
5. چرا باید خروجی `go mod tidy` را review کرد؟
6. `go test ./...` چه محدوده‌ای دارد و چه چیزی را جا می‌گذارد؟
7. در Go 1.26 به بعد برای مستندات محلی از چه فرمانی استفاده می‌شود؟
8. چرا `Effective Go` به‌تنهایی مرجع کافی برای generics/modules نیست؟
9. سه موردی که در گزارش build failure ثبت می‌کنی چیست؟
10. چرا پاک‌کردن `GOMODCACHE` درمان عمومی مشکلات build نیست؟

### کلید پاسخ

1. build executable را می‌سازد؛ run نتیجه را بلافاصله اجرا می‌کند.
2. `./...` چند package را انتخاب می‌کند و libraryها executable اصلی نیستند.
3. نصب نسخه‌دار بیرون از module جاری ابزار را نصب می‌کند و go.mod همان پروژه را تغییر نمی‌دهد.
4. fmt قالب را استاندارد می‌کند؛ vet الگوهای ایستای مشکوک را گزارش می‌دهد.
5. چون ممکن است go.mod/go.sum تغییر کنند و dependencyها تغییر یافته باشند.
6. packageهای recursive زیر مسیر/module جاری؛ module nested و برخی هدف‌های build-tag خارج از همان scope ممکن است پوشش داده نشوند.
7. `go doc`; `go tool doc` حذف شده است.
8. خود سند می‌گوید قدیمی است و آن موضوع‌های جدید را پوشش نمی‌دهد.
9. نسخهٔ Go، OS/architecture، فرمان کامل؛ پیام خطا و module path نیز ثبت شوند.
10. دانلود دوباره لازم می‌شود و علت واقعی ممکن است cache نباشد؛ ابتدا علت و scope را تشخیص بده.

## منابع

- [راهنمای رسمی command go](https://go.dev/doc/cmd)
- [مرجع go command](https://pkg.go.dev/cmd/go)
- [مستندات go doc](https://pkg.go.dev/cmd/go#hdr-Show_documentation_for_a_package_or_symbol)
- [Effective Go و یادداشت محدودیت نسخه](https://go.dev/doc/effective_go)
- فارسی: [GoFarsi — ابزارها و دستورات](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [مجموعهٔ Go به زبان ساده](https://tarhche.com/fa/articles/018fabf6-10ac-7e5a-ab68-0f33e765574f)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
