# Complete Go Developer Roadmap Coverage Map

This table maps every node in the reviewed one-page [official Go Developer Roadmap PDF](https://roadmap.sh/pdfs/roadmaps/golang.pdf) to a local English lesson. Closely related nodes are taught together, while their names remain explicit in the first column. The interactive roadmap can change independently of the PDF; recheck this map when the course structure is updated.

| Roadmap.sh node titles | Local coverage |
|---|---|
| Go, Introduction to Go, Why use Go, History of Go | [1.1 Introduction, language choice, and history](01-شروع-و-ابزار/01-معرفی-go/README.en.md) |
| Setting up the Environment, Hello World in Go | [1.2 Installation, environment, and Hello World](01-شروع-و-ابزار/02-نصب-و-hello-world/README.en.md) |
| go command, Commands & Docs | [1.3 Commands, build, test, modules, and documentation](01-شروع-و-ابزار/03-فرمان-و-docs/README.en.md) |
| Language Basics, Variables & Constants, var vs :=, Zero Values, const and iota, Scope and Shadowing | [2.1 Variables, zero values, constants, iota, and scope](02-مبانی-زبان/01-variables-constants/README.en.md) |
| Data Types, Boolean, Numeric Types, Integers (Signed, Unsigned), Floating Points, Complex Numbers, Runes, Type Conversion | [2.2 Types and conversions](02-مبانی-زبان/02-types-conversion/README.en.md) |
| Strings, Raw String Literals, Interpreted String Literals | [3.2 Strings, UTF-8, rune, and grapheme](03-ساختار-داده/02-strings/README.en.md) |
| Composite Types, Arrays, Slices, Capacity and Growth, make(), Slice to Array Conversion, Array to Slice Conversion, Strings | [3.1 Arrays, slices, make, growth, capacity, and versioned conversions](03-ساختار-داده/01-arrays-slices/README.en.md) |
| Maps, Comma-Ok Idiom | [3.3 Maps, comma-ok, deletion, and iteration](03-ساختار-داده/03-maps-comma-ok/README.en.md) |
| Structs, Struct Tags & JSON, Embedding Structs | [3.4 Structs, tags, JSON, embedding, and Go 1.27 keyed literals](03-ساختار-داده/04-struct-tags-embedding/README.en.md) |
| Conditionals, if, if-else, switch, for loop, for range Loops, Iterating Maps, Iterating Strings, break, continue, goto (discouraged) | [4.1 Control flow, range, labels, and loops](04-کنترل-و-توابع/01-loops-conditionals/README.en.md) |
| Functions, Functions Basics, Variadic Functions, Multiple Return Values, Anonymous Functions, Closures, Named Return Values, Call by Value | [4.2 Functions, results, variadics, and closures](04-کنترل-و-توابع/02-functions-closures/README.en.md) |
| Pointers, Pointers Basics, Pointers with Structs, With Maps & Slices, Memory Management, Garbage Collection, Get a Brief Overview | [5.1 Pointers, aliasing, memory, stack/heap, and GC](05-pointer-memory/01-pointers-memory-gc/README.en.md) |
| Methods and Interfaces, Methods vs Functions, Pointer Receivers, Value Receivers, Interfaces, Empty Interfaces, Embedding Interfaces, Type Assertions, Type Switch, Interfaces Basics | [6.1 Methods, method sets, receivers, interfaces, embedding, and assertions](06-متد-interface-generics/01-methods-interfaces/README.en.md) |
| Generics, Why Generics?, Generic Functions, Generic Types / Interfaces, Type Constraints, Type Inference | [6.2 Generic functions, types, methods, constraints, and inference](06-متد-interface-generics/02-generics/README.en.md) |
| Code Organization, Modules & Dependencies, go mod init, go mod tidy, go mod vendor, Packages, Package Import Rules, Using 3rd Party Packages, Publishing Modules | [7.1 Packages, imports, internal, modules, dependencies, and publishing](07-packages-modules/01-packages-modules/README.en.md) |
| Error Handling, Error Handling Basics, error interface, errors.New, fmt.Errorf, Wrapping/Unwrapping Errors, Sentinel Errors, panic and recover, Stack Traces & Debugging | [8.1 Errors, chains, retries, and stack traces](08-error-resilience/01-errors/README.en.md) and [8.2 panic, recover, and defer](08-error-resilience/02-panic-defer-recover/README.en.md) |
| Goroutines, Channels, Buffered vs Unbuffered, Select Statement | [9.1 Goroutines and channels](09-concurrency/01-goroutines-channels/README.en.md) |
| Worker Pools, sync Package, Mutexes, WaitGroups, context Package, Deadlines & Cancellations, Common Usecases | [9.2 sync and context](09-concurrency/02-sync-context/README.en.md) and [9.3 Worker pools](09-concurrency/03-worker-pool-pipeline/README.en.md) |
| Concurrency Patterns, fan-in, fan-out, pipeline | [9.3 Fan-in, fan-out, and pipelines](09-concurrency/03-worker-pool-pipeline/README.en.md) |
| Race Detection | [9.4 Races and the race detector](09-concurrency/04-race-detector/README.en.md) |
| Standard Library, I/O & File Handling, flag, time, encoding/json, os, bufio, slog, regexp, go:embed for embedding | [11.1 Standard library and I/O](11-standard-library/01-stdlib-io-json-time/README.en.md); also [slog and HTTP boundaries](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md) |
| Testing & Benchmarking, testing package basics, Table-driven Tests, Mocks and Stubs, httptest for HTTP Tests | [10.1 Tests, table tests, test doubles, and httptest](10-testing/01-testing-httptest/README.en.md) |
| Benchmarks, Coverage | [10.2 Benchmarks, allocations, coverage, and fuzzing](10-testing/02-benchmarks-coverage/README.en.md) |
| Ecosystem & Popular Libraries, Building CLIs, Cobra, urfave/cli, bubbletea | [12.1 CLIs and dependency selection](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md) |
| net/http (standard), Web Development, Frameworks (Optional), gin, echo, fiber, beego | [12.1 HTTP servers/clients and optional frameworks](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md) |
| gRPC & Protocol Buffers | [12.1 RPC and schema compatibility](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md) |
| ORMs & DB Access, pgx, GORM | [12.1 database/sql, pgx, ORMs, and safe queries](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md) |
| Logging, Zerolog, Zap | [12.1 Logging and observability](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md); [standard slog](11-standard-library/01-stdlib-io-json-time/README.en.md) |
| Realtime Communication, Melody, Centrifugo | [12.1 WebSockets, realtime, backpressure, and deployment boundaries](12-اکوسیستم/01-کتابخانه-های-اکوسیستم/README.en.md) |
| Go Toolchain and Tools, Core Go Commands, go run, go build, go install, go fmt, go mod, go test, go clean, go doc, go version | [1.3 Everyday commands](01-شروع-و-ابزار/03-فرمان-و-docs/README.en.md) and [13.1 Build and quality workflow](13-toolchain-امنیت/01-tooling-security-deploy/README.en.md) |
| Code Generation / Build Tags, go generate, Build Tags | [13.1 Generators, build constraints, and CI](13-toolchain-امنیت/01-tooling-security-deploy/README.en.md) |
| Code Quality and Analysis, go vet, goimports, Linters, revive, staticcheck, golangci-lint | [13.1 Formatting, vet, and versioned linters](13-toolchain-امنیت/01-tooling-security-deploy/README.en.md) |
| Security, govulncheck | [13.1 Dependency scanning and security](13-toolchain-امنیت/01-tooling-security-deploy/README.en.md) |
| Performance and Debugging, pprof, trace, Race Detector | [13.1 Profiles and traces](13-toolchain-امنیت/01-tooling-security-deploy/README.en.md), [9.4 race detection](09-concurrency/04-race-detector/README.en.md), and [14.1 runtime](14-مباحث-پیشرفته/01-advanced-runtime/README.en.md) |
| Deployment & Tooling, Cross-compilation, Building Executables | [13.1 Artifacts, cross-builds, and graceful shutdown](13-toolchain-امنیت/01-tooling-security-deploy/README.en.md) |
| Advanced Topics, Memory Mgmt. in Depth, Escape Analysis, Reflection, Unsafe Package, Build Constraints & Tags, CGO Basics, Compiler & Linker Flags, Plugins & Dynamic Loading | [14.1 Runtime and low-level boundaries](14-مباحث-پیشرفته/01-advanced-runtime/README.en.md) |

## Related roadmaps

The PDF also points to [Backend](https://roadmap.sh/backend), [DevOps](https://roadmap.sh/devops), [Docker](https://roadmap.sh/docker), [Kubernetes](https://roadmap.sh/kubernetes), [System Design](https://roadmap.sh/system-design), and [Software Architecture](https://roadmap.sh/software-architecture). These are separate paths, not Go Developer nodes; this course does not replace them.

**Source note:** The request displayed a System Design URL while its hyperlink target was the Go roadmap. This course follows the actual Go roadmap target: [roadmap.sh/golang](https://roadmap.sh/golang).

[Persian roadmap coverage map](ROADMAP-MAP.md) · [English course index](README.en.md)
