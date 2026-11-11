# ۱.۲ — نصب Go و اجرای اولین برنامه

<div dir="rtl">

**زمان پیشنهادی:** ۶۰ دقیقه · **پیش‌نیاز:** درس ۱.۱ · **نسخهٔ مبنا:** Go 1.27.4

## خروجی این درس

Go را نصب می‌کنی، نصب و مسیرهایش را می‌شناسی، یک module می‌سازی، برنامه را اجرا و build می‌کنی و تفاوت فایل source و executable را توضیح می‌دهی.

## ۱) نصب روی Windows

1. به [صفحهٔ دانلود رسمی Go](https://go.dev/dl/) برو و نسخهٔ Windows مناسب معماری دستگاه را بگیر.
2. installer رسمی را اجرا کن و مسیر پیشنهادی را بپذیر؛ معمولاً toolchain در `C:\Program Files\Go` نصب می‌شود.
3. پنجرهٔ جدید PowerShell باز کن. پنجرهٔ قدیمی ممکن است PATH قبل از نصب را نگه داشته باشد.
4. اجرا کن:

</div>

```powershell
go version
go env GOROOT GOPATH GOMOD
```

<div dir="rtl">

`go version` باید نام سیستم‌عامل/معماری و نسخه را چاپ کند، مانند `go version go1.27.4 windows/amd64` (نسخهٔ دقیق ممکن است تغییر کند). `GOROOT` محل toolchain نصب‌شده است؛ معمولاً نباید آن را دستی تغییر بدهی. `GOPATH` محل cache و ابزارهای نصب‌شدهٔ کاربر است. `GOMOD` در پوشهٔ پروژه مسیر `go.mod` را نشان می‌دهد.

در Linux/macOS از installer یا archive رسمی همان صفحه استفاده کن. پس از نصب، terminal تازه باز کن و همان سه فرمان را اجرا کن. نصب را از چند روش مختلف روی هم انجام نده؛ دو نصب متفاوت ممکن است PATH را گیج کنند.

## ۲) پوشه و module

هر پروژهٔ معمولی باید نام module داشته باشد. در PowerShell:

</div>

```powershell
New-Item -ItemType Directory -Force hello-go | Out-Null
Set-Location hello-go
go mod init example.com/hello-go
```

<div dir="rtl">

`go mod init` فایل `go.mod` را در ریشه می‌سازد. `example.com/hello-go` در این مثال شناسهٔ آموزشی است؛ اگر پروژه را واقعاً منتشر می‌کنی، مسیر باید با مخزن/دامنهٔ تحت اختیار تو سازگار باشد. Go ابزار وابستگی و نسخه را از همین module root مدیریت می‌کند.

## ۳) ساختار اولین برنامه

در ریشهٔ پوشه فایلی به نام `main.go` بساز:

</div>

```go
package main

import "fmt"

func main() {
	fmt.Println("سلام، Go")
}
```

<div dir="rtl">

- `package main`: این package قرار است executable تولید کند.
- `import "fmt"`: package استاندارد چاپ قالب‌بندی‌شده را وارد می‌کند.
- `func main()`: نقطهٔ شروع اجرای executable است.
- `fmt.Println`: متن را چاپ می‌کند و newline می‌گذارد.

حالا:

</div>

```powershell
go run .
go build -o hello.exe
.\hello.exe
```

<div dir="rtl">

`go run .` package جاری را build و همان لحظه اجرا می‌کند؛ برای توسعه مناسب است. `go build -o hello.exe` executable می‌سازد، اما آن را اجرا نمی‌کند. فرمان آخر فایل ساخته‌شده را اجرا می‌کند. اگر PowerShell پیام «command not found» داد، مسیر فعلی را با `.\` مشخص کن.

## ۴) خطاهای رایج نصب

- **`go : The term 'go' is not recognized`:** terminal را ببند و باز کن؛ اگر ادامه داشت، مطمئن شو مسیر `...Go\bin` در PATH است.
- **`go.mod file not found`:** از ریشهٔ پروژه `go mod init <module-path>` بزن؛ در هر subdirectory یک go.mod نساز.
- **`expected 'package'`:** مطمئن شو فایل پسوند `.go` دارد، متن کامل ذخیره شده و بالای فایل declaration package هست.
- **اجرای `hello.exe` پیدا نمی‌شود:** در PowerShell از `.\hello.exe` استفاده کن یا مسیر دقیق executable را بده.
- **نسخهٔ اشتباه:** `Get-Command go` و `where.exe go` را اجرا و مسیرهای نصب را بررسی کن.

## تمرین مرحله‌ای

1. برنامه‌ای بساز که نام و نسخهٔ برنامه را چاپ کند.
2. یک `const appName = "inventory"` اضافه و خروجی را با `fmt.Printf` قالب‌بندی کن.
3. `go build` را اجرا کن؛ executable را از پوشهٔ دیگری اجرا کن و توضیح بده چرا source code لازم نیست در آن پوشه باشد.

### پاسخ نمونه

```go
package main

import "fmt"

const appName = "inventory"
const version = "0.1.0"

func main() {
	fmt.Printf("%s %s\n", appName, version)
}
```

## کوییز

### پرسش‌ها

1. چرا terminal را پس از نصب می‌بندیم و باز می‌کنیم؟
2. نقش `GOROOT` چیست؟
3. نقش `GOPATH` در toolchain امروزی چیست؟
4. `go mod init` چه فایلی می‌سازد و چرا؟
5. `package main` و `func main` چه نقشی دارند؟
6. `go run .` و `go build` چه تفاوتی دارند؟
7. چرا `go.mod` باید در ریشهٔ module باشد؟
8. اگر چند نسخهٔ Go نصب باشد، چطور مسیر فرمان فعال را پیدا می‌کنی؟

### کلید پاسخ

1. shell معمولاً PATH را هنگام شروع می‌خواند و ممکن است تغییر جدید را ندیده باشد.
2. محل نصب toolchain استاندارد Go را مشخص می‌کند.
3. cacheها و bin ابزارهای نصب‌شدهٔ کاربر را دربرمی‌گیرد؛ پروژه‌های معمول با module ساخته می‌شوند.
4. `go.mod`؛ module path و تنظیمات/وابستگی‌های module را نگه می‌دارد.
5. `package main` نوع package اجرایی است و `main` نقطهٔ ورود اجرای آن.
6. run build و اجرا می‌کند؛ build artifact قابل اجرا می‌سازد و اجرا نمی‌کند.
7. فرمان Go از module root برای یافتن وابستگی و packageها استفاده می‌کند.
8. در Windows با `Get-Command go` یا `where.exe go`، سپس PATH را بررسی می‌کنی.

## منابع

- [دانلود رسمی Go](https://go.dev/dl/)
- [Getting Started رسمی](https://go.dev/doc/tutorial/getting-started)
- فارسی: [GoFarsi — نصب و فصل مبانی](https://cloud-book.gofarsi.ir/chapter-1/)
- فارسی: [گولنگ به زبان ساده — راه‌اندازی](https://tarhche.com/fa/articles/018fabf6-10ac-7e5a-ab68-0f33e765574f)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
