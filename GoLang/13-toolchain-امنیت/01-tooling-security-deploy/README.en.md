# 13.1 — Toolchain, code quality, security, and deployment

<div dir="ltr">

**Time:** 180 minutes · **Prerequisite:** tests, modules, HTTP, and context  
**Goal:** Build repeatable artifacts, use analysis tools with clear limits, and operate a Go process safely.

## Core commands

go fmt, go test, go vet, go build, go install, go mod, go doc, and go version cover the everyday toolchain. In Go 1.27, go test runs the stdversion vet check by default to flag standard-library symbols newer than the module language version in force for a file.

Use go generate explicitly; go build does not run generators automatically. Pin external tool versions in CI so results do not drift.

## Formatters and linters

gofmt is the standard formatter. goimports also manages imports. Additional tools include staticcheck, revive, and golangci-lint. Linters can find useful patterns but have false positives and version-specific rules. Pin the version, configuration, and suppression policy.

go vet reports suspicious constructs; it does not prove correctness, race freedom, or security.

## Vulnerability scanning

govulncheck uses Go vulnerability information and analyzes reachable call paths to prioritize relevant findings. It cannot find unknown advisories, all logic bugs, or every insecure configuration. Review affected versions and call paths, update deliberately, and keep scanning in CI.

## Build tags and code generation

Build constraints select files by OS, architecture, or custom tags. Test each supported build target. go generate runs declared generators but is not run automatically by ordinary builds. Record generator versions and inputs so generated output is repeatable.

## Cross-compilation and artifacts

Go can build for many target operating systems and architectures. cgo may require a target C compiler and native libraries. A binary built for another OS cannot normally be executed on the build host.

Record toolchain, dependencies, commit, target, and build options. Remove accidental local paths from artifacts when needed, but do not assume one flag alone makes a build reproducible. Test the artifact in its actual runtime environment.

## Diagnostics and performance

Use benchmarks for focused measurements, CPU/heap profiles for hotspots, and execution trace for scheduling and blocking. Go 1.27 adds a goroutineleak profile that can find some permanently blocked goroutines, not every leak.

Treat profiles as potentially sensitive operational data. Restrict profiling endpoints and retain artifacts according to data policy. Do not profile production without a question and an access plan.

## Deployment and graceful shutdown

Run as a non-root user where possible. Keep secrets outside source, executable, and container image. Configure server timeouts, body limits, health behavior, and dependency limits. On termination, stop accepting new work, drain active requests within a bounded deadline, cancel workers, and close dependencies.

An HTTP listener shutting down does not guarantee every background goroutine has stopped.

## Common mistakes

- Assuming go build runs tests or generators.
- Running a linter version that differs across developer machines and CI.
- Treating govulncheck as proof of security.
- Cross-compiling without considering cgo.
- Exposing pprof publicly.
- Embedding secrets into binaries.
- Forgetting background workers during shutdown.
- Treating 100% coverage as a security guarantee.

## Guided practice with answers

**1. A scanner reports a vulnerable dependency. What should you do?**  
Check the advisory, affected version, reachable path, fixed release, compatibility, and tests; update and document the outcome.

**2. A Go server gets SIGTERM. What is a graceful sequence?**  
Stop new work, cancel or drain active work with a deadline, shut down HTTP, wait for workers, close dependencies, and exit.

**3. Why pin the linter version in CI?**  
To make findings consistent across environments and avoid unexplained tool drift.

## Quiz

### Questions

1. What does gofmt do?
2. What does go vet not guarantee?
3. Does go build run go generate?
4. What does stdversion check in Go 1.27?
5. What does a build constraint select?
6. What can make cross-compilation harder?
7. What does govulncheck add to dependency review?
8. Why can it not prove a program is secure?
9. Why pin linter versions?
10. What does pprof help investigate?
11. Why restrict profiling endpoints?
12. What should graceful shutdown drain?
13. Why is closing only the HTTP listener insufficient?
14. Where should secrets not be placed?
15. What can a build timestamp do to reproducibility?
16. Does a clean race run prove security?
17. What should be recorded for an artifact?
18. Why does go generate need explicit invocation?

### Answer key

1. Standard Go formatting.
2. All bugs, correctness, races, or security.
3. No.
4. Standard-library symbols newer than the file’s effective Go language version.
5. Files included by OS, architecture, or tags.
6. cgo and target native toolchains or libraries.
7. Advisory data and reachable call-path analysis.
8. Unknown advisories, misuse, logic bugs, and configuration may remain.
9. To keep CI and developer findings consistent.
10. CPU, heap, allocation, blocking, or related runtime behavior.
11. It can reveal sensitive structure and impose overhead.
12. Requests and owned worker/resource work in progress.
13. Goroutines and dependencies may remain active.
14. Source, executable, and container image.
15. It may create a different binary on each build.
16. No.
17. Toolchain, dependency state, commit, target, and relevant build options.
18. Builds do not run generators automatically.

## References and further reading

- [Go command documentation](https://go.dev/doc/cmd)
- [Go 1.27 release notes](https://go.dev/doc/go1.27)
- [Go vulnerability management](https://go.dev/doc/security/vuln/)
- [govulncheck documentation](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
- [Go diagnostics](https://go.dev/doc/diagnostics)
- [Go build constraints](https://pkg.go.dev/cmd/go#hdr-Build_constraints)
- [goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports)
- [staticcheck](https://staticcheck.dev/)
- [revive](https://github.com/mgechev/revive)
- [golangci-lint](https://golangci-lint.run/)
- [Go release history](https://go.dev/doc/devel/release)

[Persian version](README.md) · [Next: advanced topics](../../14-مباحث-پیشرفته/01-advanced-runtime/README.en.md)

</div>