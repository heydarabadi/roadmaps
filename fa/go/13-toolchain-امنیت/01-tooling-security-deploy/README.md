# ۱۳.۱ — ابزارهای Go، امنیت و deployment

<div dir="rtl">

**زمان پیشنهادی:** ۱۸۰ دقیقه · **پیش‌نیاز:** module، تست، HTTP، concurrency و dependency  
**هدف:** build و بررسی را تکرارپذیر کنی، vulnerabilityها و misconfigurationها را زود پیدا کنی و برنامه را با lifecycle درست deploy کنی.

## نقشهٔ این درس

- چرخهٔ build، test و format
- vet و ابزار lint
- ابزارهای versioned
- vulnerability scan
- go generate و build tags
- cross-compilation و cgo
- profile و trace
- CI و artifact reproducible
- graceful shutdown و container
- اصول امنیت dependency و runtime

## ۱) چرخهٔ پایهٔ پروژه

قبل از commit، کد را format کن، testها را اجرا و warningهای محتمل را بررسی کن:

~~~powershell
gofmt -w .
go test ./...
go vet ./...
go build ./...
~~~

</div>
<div dir="rtl">

- <code>gofmt</code> formatter استاندارد است؛ style شخصی جای آن را نمی‌گیرد.
- <code>go test</code> testها و packageها را می‌سازد و اجرا می‌کند؛ از Go 1.27، <code>stdversion</code> vet check هم به‌طور پیش‌فرض اجرا می‌شود تا استفاده از symbol جدیدتر از go directive فایل را پیدا کند.
- <code>go vet</code> الگوهای مشکوک را پیدا می‌کند؛ جای code review و test را نمی‌گیرد.
- <code>go build</code> build موفق را بررسی می‌کند؛ deployment را اثبات نمی‌کند.

CI باید همان فرمان‌ها را روی نسخهٔ Go پشتیبانی‌شده اجرا کند. برای format check، تفاوت خروجی <code>gofmt -d</code> را به job failure تبدیل کن؛ صرفاً اجرای <code>-d</code> ممکن است diff چاپ کند ولی pipeline آن را fail نکند.

## ۲) lint و versioning ابزار

<code>goimports</code> (از x/tools) importها را مرتب و format می‌کند؛ <code>revive</code>، <code>staticcheck</code> و <code>golangci-lint</code> تحلیل و lintهای بیشتری فراهم می‌کنند. این‌ها ابزارهای بیرونی‌اند؛ نسخه و rule setشان را در CI مشخص کن. Ruleهای زیاد که بدون مالک و توضیح روشن‌اند تیم را به خاموش‌کردن warningها عادت می‌دهند. از profileهای مشخص شروع کن و هر rule را با هدف نگه‌داری انتخاب کن.

ابزار را به‌صورت dependency تکرارپذیر نصب کن؛ نمونهٔ نصب نسخه‌دار:

~~~powershell
go install honnef.co/go/tools/cmd/staticcheck@2026.2.2
~~~

</div>
<div dir="rtl">

نمونهٔ بالا به Staticcheck 2026.2.2 اشاره دارد که پشتیبانی Go 1.27 را اضافه کرد. هر بار نسخهٔ Go هدف را با release notes ابزار تطبیق بده و همان نسخه را در CI pin کن. ابزار نصب‌شده در <code>GOBIN</code> یا مسیر binaryهای Go می‌رود؛ CI نباید به نسخهٔ تصادفی روی PATH تکیه کند.

## ۳) vulnerability scanning

<code>govulncheck</code> از پایگاه آسیب‌پذیری Go استفاده می‌کند تا dependencyهای آسیب‌پذیر و call pathهای reachable را بررسی کند. ابزار می‌تواند یافتن vulnerability شناخته‌شده را بهتر کند، اما امنیت کامل را تضمین نمی‌کند: آسیب‌پذیری ممکن است هنوز در دیتابیس نباشد، پیکربندی یا misuse برنامه مشکل داشته باشد، یا مسیر مهم با scan پوشش داده نشود.

فرمان نمونه:

~~~powershell
govulncheck ./...
~~~

</div>
<div dir="rtl">

خروجی را با نسخهٔ dependency و مسیر import/call بررسی کن. Update امنیتی ممکن است breaking change داشته باشد؛ staging، test و برنامهٔ rollback لازم است. Scanner باید در CI تکرار شود و owner داشته باشد، نه اینکه فقط یک بار پیش از deploy اجرا شود.

## ۴) go generate و build tags

<code>go generate</code> commentهای directive را پیدا و generator بیرونی را اجرا می‌کند؛ <code>go build</code> آن را خودکار اجرا نمی‌کند. خروجی تولیدشده را براساس قرارداد repository commit یا در CI regenerate و diff را بررسی کن. Generator، ورژن آن و ورودی‌ها باید مشخص باشند تا خروجی تکرارپذیر بماند.

Build constraint با comment <code>//go:build</code> در ابتدای فایل تعیین می‌کند فایل برای کدام OS، architecture یا tag انتخاب شود. مثال:

~~~go
//go:build linux

package platform
~~~

</div>
<div dir="rtl">

برای پیاده‌سازی جداگانهٔ یک capability، تست‌های هر target و حالت build را روشن نگه دار. فایل‌های بدون build constraint ممکن است روی platform دیگری هم compile شوند و آن‌جا شکست بخورند؛ compile ماتریسی را در CI انجام بده.

## ۵) cross-compilation

Go معمولاً می‌تواند برای OS/architecture دیگر build کند؛ تنظیمات از طریق environment variable است. در PowerShell:

~~~powershell
$env:GOOS = 'linux'
$env:GOARCH = 'amd64'
go build -o app-linux-amd64 ./cmd/app
Remove-Item Env:GOOS
Remove-Item Env:GOARCH
~~~

</div>
<div dir="rtl">

در shellهای POSIX syntax متفاوت است؛ commandهای CI را با shell واقعی خودشان مستند کن. خروجی target را روی سیستم مبدأ لزوماً نمی‌توانی اجرا کنی. cgo و dependencyهای native به compiler/linker مناسب target نیاز دارند و cross-compile را پیچیده می‌کنند. قبل از خاموش‌کردن cgo، dependencyها، DNS/TLS و نیازهای runtime را بررسی کن.

## ۶) تشخیص و performance tooling

در فصل‌های test و concurrency با race detector آشنا شدی. ابزارهای دیگر:

- <code>go test -cover</code> برای گزارش statement coverage.
- benchmark و <code>-benchmem</code> برای زمان و allocation.
- CPU/memory profile برای یافتن bottleneck.
- execution trace برای timeline scheduler، goroutine و blocking.
- Go 1.27 به <code>runtime/pprof</code> پروفایل <code>goroutineleak</code> افزود؛ تشخیص پویاست و همهٔ leakها را نمی‌یابد.
- <code>runtime/pprof</code> برای ارائهٔ profile از process؛ endpoint را در محیط production با دسترسی کنترل‌شده فعال کن.

ابتدا سؤال عملکردی مشخص تعریف کن، سپس profile بگیر. pprof/trace می‌توانند CPU، heap یا رفتار داخلی را افشا کنند؛ artifact آن را مانند دادهٔ عملیاتی حساس نگه‌دار.

## ۷) reproducible build و artifact

برای build قابل‌بازتولید، version Go، dependency graph، build command و generated source را ثبت کن. در release metadata مانند version، commit و build time را آگاهانه اضافه کن؛ timestamp تصادفی می‌تواند byte-for-byte reproducibility را بشکند. <code>-trimpath</code> مسیر absolute محیط build را از binary حذف می‌کند، اما به تنهایی build را کامل reproducible نمی‌سازد.

Artifact باید برای target واقعی ساخته شود. نتیجهٔ یک build روی Windows ثابت نمی‌کند binary لینوکس درست است؛ integration smoke test در runtime target، image security، configuration، secret injection و health check را جدا بررسی کن.

## ۸) اجرای امن در production

- process را با user غیر root اجرا کن، مگر نیاز مشخص و کنترل‌شده‌ای داشته باشی.
- secret را داخل image یا binary bake نکن؛ secret manager/environment امن و rotation داشته باش.
- ورودی network/file را محدود و validate کن.
- TLS verification را خاموش نکن؛ crypto را با کتابخانه‌های استاندارد/معتبر پیاده کن.
- server را با timeout و request limit تنظیم کن.
- readiness/liveness را بر اساس رفتار واقعی طراحی کن.
- با SIGTERM درخواست‌های جدید را متوقف و درخواست‌های جاری را تا deadline کوتاه drain کن.
- log/metric/trace را بدون token و payload حساس تولید کن.
- image کوچک به تنهایی نشانهٔ امن‌بودن نیست؛ dependency، base image و permission را هم بررسی کن.

## ۹) graceful shutdown در HTTP

الگوی کلی: signal را دریافت کن، سرور را با timeout محدود shutdown کن و پس از مهلت resourceهای باقی‌مانده را جمع کن.

~~~go
shutdownCtx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
defer cancel()

if err := server.Shutdown(shutdownCtx); err != nil {
	log.Printf("graceful shutdown: %v", err)
}
~~~

</div>
<div dir="rtl">

این snippet مرحلهٔ shutdown است، نه یک server کامل. context سرور هنگام startup جداگانه با signal بسته می‌شود؛ workerها، message consumerها و DB transactionها نیز باید از همان cancellation مسیر بگیرند. اگر فقط HTTP listener را ببندی اما goroutineهای پس‌زمینه را رها کنی، shutdown graceful کامل نشده است.

## ۱۰) pipeline نمونهٔ CI

ترتیب پیشنهادی را با runtime پروژه تطبیق بده:

1. checkout و نصب نسخهٔ پشتیبانی‌شدهٔ Go.
2. دریافت module dependency و cache مطابق policy.
3. format check و static analysis.
4. test و در صورت نیاز race test.
5. vulnerability scan و dependency review.
6. build برای targetهای پشتیبانی‌شده.
7. انتشار artifact با checksum و metadata.
8. smoke/integration test و deploy مرحله‌ای.
9. مشاهدهٔ SLO، rollback path و migration state.

این لیست قالب آموزشی است؛ deployment production نیاز به threat model، secret policy، approval، rollout و ownership سامانه دارد. ابزار خودکار مجوز deployment را جایگزین نمی‌کند.

## دام‌های رایج

- فکرکردن <code>go build</code>، go generate را اجرا می‌کند.
- اتکا به version lint tool نصب‌شده روی لپ‌تاپ.
- تصور اینکه govulncheck همهٔ bugها و misconfigurationها را پیدا می‌کند.
- cross-build و فرض اینکه cgo اهمیتی ندارد.
- فعال‌کردن pprof عمومی یا نگهداری profile حساس.
- افزودن timestamp و مسیر محلی به build و انتظار binary قابل‌تکرار.
- secret را داخل container image گذاشتن.
- بستن listener و فراموش‌کردن workerهای پس‌زمینه.
- تکیه بر 100٪ coverage به‌عنوان security gate.
- عبور از scan چون build موفق است.

## تمرین‌های مرحله‌ای با پاسخ

### تمرین ۱: CI برای Go

Pipeline طراحی کن که format، test، vet، vulnerability check و build را انجام دهد.

**پاسخ:** نسخه Go و نسخه ابزار بیرونی را pin کن؛ format diff را به failure تبدیل کن؛ scan را در CI اجرا کن؛ artifact خروجی را با commit/target metadata منتشر کن.

### تمرین ۲: cross-build روی Windows

برای linux/amd64 binary بساز و environment variable را پس از build پاک کن.

**پاسخ:** دستورات PowerShell بخش ۵؛ برای linux/arm64 مقدار GOARCH را تنظیم و در محیط target smoke test کن.

### تمرین ۳: graceful shutdown

یک server با worker background داری. چه lifecycle لازم است؟

**پاسخ:** signal → cancel root context → توقف پذیرش کار جدید → Shutdown HTTP با deadline → drain/stop worker → بستن DB و log → اگر timeout گذشت failure را ثبت و process را طبق policy خاتمه بده.

### تمرین ۴: vulnerability finding

Scanner نسخهٔ vulnerable dependency را گزارش می‌کند، اما reachability unclear است. پاسخ: module/version/call path advisory و policy را بررسی کن؛ fix version و compatibility را ارزیابی، update و test کن؛ صرفاً با suppress بی‌توضیح رد نکن.

## کوییز

### پرسش‌ها

1. نقش gofmt چیست؟
2. go vet چه چیزی را تضمین نمی‌کند؟
3. go test چه نوع code را اجرا می‌کند؟
4. آیا go build، go generate را خودکار اجرا می‌کند؟
5. build constraint چه چیزی را انتخاب می‌کند؟
6. GOOS/GOARCH در PowerShell چگونه تنظیم می‌شوند؟
7. چه چیزی cross-compilation را دشوار می‌کند؟
8. govulncheck چه نوع دانشی به scan اضافه می‌کند؟
9. چرا govulncheck امنیت کامل را اثبات نمی‌کند؟
10. چرا نسخهٔ linter باید مشخص باشد؟
11. pprof/trace چه نوع شواهدی می‌دهند؟
12. چرا pprof endpoint نباید عمومی باشد؟
13. graceful shutdown چه چیزی را drain می‌کند؟
14. چرا فقط HTTP listener را بستن کافی نیست؟
15. چه چیزی در artifact build باید ثبت شود؟
16. چرا build timestamp می‌تواند reproducibility را مختل کند؟
17. secret را کجا نباید ذخیره کرد؟
18. آیا race/coverage سبز امنیت کامل را ثابت می‌کند؟
19. goimports چه چیزی را نسبت به gofmt تکمیل می‌کند؟
20. چرا staticcheck/revive را باید با نسخه و rule set مشخص اجرا کرد؟
21. از Go 1.27، go test چه vet check تازه‌ای را به‌طور پیش‌فرض اجرا می‌کند؟
22. آیا goroutineleak profile همهٔ leakها را تشخیص می‌دهد؟

### کلید پاسخ

1. format استاندارد و یکپارچهٔ source.
2. تمام bugها، raceها یا correctness را تضمین نمی‌کند.
3. testهای package و build آن‌ها را اجرا می‌کند.
4. خیر، صریحاً اجرا شود.
5. OS، architecture و tag.
6. با <code>$env:GOOS</code> و <code>$env:GOARCH</code>.
7. cgo و native compiler/linker target.
8. پایگاه vulnerability و reachable call path در Go.
9. پوشش دیتابیس/کد محدود است و misconfiguration یا bug ناشناخته را نمی‌یابد.
10. تا CI روی ماشین‌های مختلف رفتار یکسان داشته باشد.
11. profile CPU/memory و timeline اجرای برنامه.
12. داده و ساختار حساس می‌تواند افشا شود و endpoint بار اضافی دارد.
13. درخواست‌های در حال اجرا و worker/resourceهای متعلق به process.
14. goroutineهای background و dependencyها ممکن است باقی بمانند.
15. version toolchain، dependency graph، commit، target و metadata لازم.
16. build هر بار timestamp متفاوت دارد.
17. داخل source، binary یا image.
18. خیر.
19. importها را مرتب می‌کند و فایل را format می‌کند؛ gofmt به‌تنهایی importهای استفاده‌نشده را مدیریت نمی‌کند.
20. تا CI و محیط توسعه نتیجهٔ یکسان بدهند و drift/false positive کنترل شود.
21. stdversion؛ استفاده از symbol جدیدتر از language version فایل را گزارش می‌کند.
22. خیر؛ فقط بعضی goroutineهای دائماً blockشده را از روی reachability تشخیص می‌دهد.

## منابع

- انگلیسی: [Go command documentation](https://go.dev/doc/cmd)
- انگلیسی: [Go security — Vulnerability management](https://go.dev/doc/security/vuln/)
- انگلیسی: [Go diagnostics](https://go.dev/doc/diagnostics)
- انگلیسی: [Go toolchain release history](https://go.dev/doc/devel/release)
- انگلیسی: [Go 1.27 release notes](https://go.dev/doc/go1.27)
- انگلیسی: [Staticcheck releases](https://github.com/dominikh/go-tools/releases)
- انگلیسی: [goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports) · [revive](https://github.com/mgechev/revive)
- انگلیسی: [Go build constraints](https://pkg.go.dev/cmd/go#hdr-Build_constraints)
- فارسی: [GoFarsi — ماژول و ابزارها](https://cloud-book.gofarsi.ir/chapter-4/)
- فارسی: [GoFarsi — کتاب Go](https://book.gofarsi.ir/chapter-4/)



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](README.en.md)
</div>
