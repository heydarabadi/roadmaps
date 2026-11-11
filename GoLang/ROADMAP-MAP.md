# نگاشت کامل PDF رسمی Go Developer Roadmap

<div dir="rtl">

این جدول همهٔ عنوان‌های آموزشی PDF تک‌صفحه‌ای [Go Developer Roadmap](https://roadmap.sh/pdfs/roadmaps/golang.pdf) را که در ۱۰ نوامبر ۲۰۲۶ بررسی شد، به درس‌های همین پوشه وصل می‌کند. چند node هم‌خانواده در یک README ادغام شده‌اند؛ عنوان node در ستون اول صریحاً نگه داشته شده تا چیزی در نگاشت گم نشود. Roadmap تعاملی ممکن است با نسخهٔ PDF فرق کند؛ در تغییر ساختار دوره، این جدول را دوباره با نسخهٔ رسمی تطبیق بده.

## عنوان‌ها و درس‌ها

| عنوان‌های Roadmap.sh | پوشش محلی |
|---|---|
| **Go, Introduction to Go, Why use Go, History of Go** | [۱.۱ معرفی، انتخاب زبان و تاریخچه](01-شروع-و-ابزار/01-معرفی-go/README.md) |
| **Setting up the Environment, Hello World in Go** | [۱.۲ نصب، محیط و برنامهٔ Hello World](01-شروع-و-ابزار/02-نصب-و-hello-world/README.md) |
| **go command, Commands & Docs** | [۱.۳ فرمان‌ها، build، test، module و مستندات](01-شروع-و-ابزار/03-فرمان-و-docs/README.md) |
| **Language Basics, Variables & Constants, var vs :=, Zero Values, const and iota, Scope and Shadowing** | [۲.۱ متغیر، مقدار صفر، ثابت، iota و scope](02-مبانی-زبان/01-variables-constants/README.md) |
| **Data Types, Boolean, Numeric Types, Integers (Signed, Unsigned), Floating Points, Complex Numbers, Runes, Type Conversion** | [۲.۲ نوع‌ها و تبدیل](02-مبانی-زبان/02-types-conversion/README.md) |
| **Strings, Raw String Literals, Interpreted String Literals** | [۳.۲ رشته، UTF-8، rune و grapheme](03-ساختار-داده/02-strings/README.md) |
| **Composite Types, Arrays, Slices, Capacity and Growth, make(), Slice to Array Conversion, Array to Slice Conversion, Strings** | [۳.۱ array، slice، make، رشد، ظرفیت و تبدیل نسخه‌دار](03-ساختار-داده/01-arrays-slices/README.md) |
| **Maps, Comma-Ok Idiom** | [۳.۳ map، comma-ok، حذف و پیمایش](03-ساختار-داده/03-maps-comma-ok/README.md) |
| **Structs, Struct Tags & JSON, Embedding Structs** | [۳.۴ struct، tag، JSON، embedding و fieldهای literal در Go 1.27](03-ساختار-داده/04-struct-tags-embedding/README.md) |
| **Conditionals, if, if-else, switch, for loop, for range Loops, Iterating Maps, Iterating Strings, break, continue, goto (discouraged)** | [۴.۱ کنترل جریان، range، label و حلقه](04-کنترل-و-توابع/01-loops-conditionals/README.md) |
| **Functions, Functions Basics, Variadic Functions, Multiple Return Values, Anonymous Functions, Closures, Named Return Values, Call by Value** | [۴.۲ تابع، خروجی، variadic و closure](04-کنترل-و-توابع/02-functions-closures/README.md) |
| **Pointers, Pointers Basics, Pointers with Structs, With Maps & Slices, Memory Management, Garbage Collection, Get a Brief Overview** | [۵.۱ pointer، aliasing، حافظه، stack/heap و GC](05-pointer-memory/01-pointers-memory-gc/README.md) |
| **Methods and Interfaces, Methods vs Functions, Pointer Receivers, Value Receivers, Interfaces, Empty Interfaces, Embedding Interfaces, Type Assertions, Type Switch, Interfaces Basics** | [۶.۱ متد، method set، receiver، interface، embedding و assertion](06-متد-interface-generics/01-methods-interfaces/README.md) |
| **Generics, Why Generics?, Generic Functions, Generic Types / Interfaces, Type Constraints, Type Inference** | [۶.۲ generic function/type/method، constraint و inference](06-متد-interface-generics/02-generics/README.md) |
| **Code Organization, Modules & Dependencies, go mod init, go mod tidy, go mod vendor, Packages, Package Import Rules, Using 3rd Party Packages, Publishing Modules** | [۷.۱ package، import، internal، module، dependency و انتشار](07-packages-modules/01-packages-modules/README.md) |
| **Error Handling, Error Handling Basics, error interface, errors.New, fmt.Errorf, Wrapping/Unwrapping Errors, Sentinel Errors, panic and recover, Stack Traces & Debugging** | [۸.۱ error، chain، retry و stack trace](08-error-resilience/01-errors/README.md) و [۸.۲ panic، recover و defer](08-error-resilience/02-panic-defer-recover/README.md) |
| **Goroutines, Channels, Buffered vs Unbuffered, Select Statement** | [۹.۱ goroutine و channel](09-concurrency/01-goroutines-channels/README.md) |
| **Worker Pools, sync Package, Mutexes, WaitGroups, context Package, Deadlines & Cancellations, Common Usecases** | [۹.۲ sync و context](09-concurrency/02-sync-context/README.md) و [۹.۳ worker pool](09-concurrency/03-worker-pool-pipeline/README.md) |
| **Concurrency Patterns, fan-in, fan-out, pipeline** | [۹.۳ fan-in/fan-out و pipeline](09-concurrency/03-worker-pool-pipeline/README.md) |
| **Race Detection** | [۹.۴ race و detector](09-concurrency/04-race-detector/README.md) |
| **Standard Library, I/O & File Handling, flag, time, encoding/json, os, bufio, slog, regexp, go:embed for embedding** | [۱۱.۱ کتابخانهٔ استاندارد و I/O](11-standard-library/01-stdlib-io-json-time/README.md)؛ همچنین [slog و مرز HTTP](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md) |
| **Testing & Benchmarking, testing package basics, Table-driven Tests, Mocks and Stubs, httptest for HTTP Tests** | [۱۰.۱ test، table test، stub/fake/mock و httptest](10-testing/01-testing-httptest/README.md) |
| **Benchmarks, Coverage** | [۱۰.۲ benchmark، allocation، coverage و fuzz](10-testing/02-benchmarks-coverage/README.md) |
| **Ecosystem & Popular Libraries, Building CLIs, Cobra, urfave/cli, bubbletea** | [۱۲.۱ CLI و انتخاب dependency](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md) |
| **net/http (standard), Web Development, Frameworks (Optional), gin, echo, fiber, beego** | [۱۲.۱ HTTP server/client و frameworkها](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md) |
| **gRPC & Protocol Buffers** | [۱۲.۱ RPC و سازگاری schema](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md) |
| **ORMs & DB Access, pgx, GORM** | [۱۲.۱ database/sql، pgx، ORM و query ایمن](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md) |
| **Logging, Zerolog, Zap** | [۱۲.۱ logging و observability](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md)؛ [slog استاندارد](11-standard-library/01-stdlib-io-json-time/README.md) |
| **Realtime Communication, Melody, Centrifugo** | [۱۲.۱ WebSocket، realtime، backpressure و deployment boundary](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.md) |
| **Go Toolchain and Tools, Core Go Commands, go run, go build, go install, go fmt, go mod, go test, go clean, go doc, go version** | [۱.۳ دستورهای روزمره](01-شروع-و-ابزار/03-فرمان-و-docs/README.md) و [۱۳.۱ چرخهٔ ساخت/کیفیت](13-toolchain-امنیت/01-tooling-security-deploy/README.md) |
| **Code Generation / Build Tags, go generate, Build Tags** | [۱۳.۱ generator، constraint و CI](13-toolchain-امنیت/01-tooling-security-deploy/README.md) |
| **Code Quality and Analysis, go vet, goimports, Linters, revive, staticcheck, golangci-lint** | [۱۳.۱ format، vet و linterهای نسخه‌دار](13-toolchain-امنیت/01-tooling-security-deploy/README.md) |
| **Security, govulncheck** | [۱۳.۱ dependency scan و امنیت](13-toolchain-امنیت/01-tooling-security-deploy/README.md) |
| **Performance and Debugging, pprof, trace, Race Detector** | [۱۳.۱ profile و trace](13-toolchain-امنیت/01-tooling-security-deploy/README.md)، [۹.۴ race](09-concurrency/04-race-detector/README.md)، [۱۴.۱ runtime](14-مباحث-پیشرفته/01-advanced-runtime/README.md) |
| **Deployment & Tooling, Cross-compilation, Building Executables** | [۱۳.۱ artifact، cross-build و shutdown](13-toolchain-امنیت/01-tooling-security-deploy/README.md) |
| **Advanced Topics, Memory Mgmt. in Depth, Escape Analysis, Reflection, Unsafe Package, Build Constraints & Tags, CGO Basics, Compiler & Linker Flags, Plugins & Dynamic Loading** | [۱۴.۱ runtime و مرزهای سطح پایین](14-مباحث-پیشرفته/01-advanced-runtime/README.md) |

## Roadmapهای مرتبط

PDF در کنار Go به [Backend](https://roadmap.sh/backend)، [DevOps](https://roadmap.sh/devops)، [Docker](https://roadmap.sh/docker)، [Kubernetes](https://roadmap.sh/kubernetes)، [System Design](https://roadmap.sh/system-design) و [Software Design & Architecture](https://roadmap.sh/software-architecture) ارجاع می‌دهد. این مسیرهای جدا، nodeهای Go Developer نیستند؛ این دوره آن‌ها را جایگزین نمی‌کند.



**نسخهٔ انگلیسی:** [مطالعهٔ این صفحه به انگلیسی](ROADMAP-MAP.en.md)
</div>
