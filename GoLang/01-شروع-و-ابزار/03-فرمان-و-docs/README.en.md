# 1.3 — Go commands, modules, and documentation

<div dir="ltr">

**Time:** 75 minutes · **Prerequisite:** [Installation](../02-نصب-و-hello-world/README.en.md)  
**Goal:** Use core Go commands, understand module boundaries, and find documentation for packages and symbols.

## 1. The go command

Go provides one command with subcommands that share module and toolchain behavior.

| Command | Purpose |
|---|---|
| go run . | Compile and run the current package during development |
| go build ./... | Build packages and produce executables for main packages |
| go install example.com/tool@version | Install a versioned command-line tool |
| go fmt ./... | Format Go source |
| go test ./... | Build and run package tests |
| go vet ./... | Report suspicious constructs |
| go mod init | Start a new module |
| go mod tidy | Reconcile imports and module requirements |
| go mod vendor | Copy dependencies into vendor when repository policy requires it |
| go clean | Remove selected build or cache artifacts |
| go version | Print the selected toolchain version |
| go doc package.Symbol | Read package or symbol documentation |

Use go help command for command-specific options. Output and flags can change; the installed toolchain is the final reference.

## 2. Package, module, and workspace

A package is a set of source files compiled together. A module is a versioned collection of packages described by go.mod. A Go workspace, go.work, can coordinate multiple local modules during development. It does not replace each module’s own dependency declaration.

~~~text
my-service/
  go.mod
  cmd/server/main.go
  internal/store/store.go
  internal/httpapi/handler.go
~~~

Run most commands at the module root so package patterns such as ./... have a clear meaning. The pattern recursively includes packages under the current module according to Go package rules.

## 3. Dependency workflow

~~~powershell
go get example.com/library@v1.2.3
go mod tidy
go list -m all
go mod graph
~~~

Review changes to both go.mod and go.sum. A dependency upgrade changes the software supply chain and may affect compatibility. Pinning a version makes builds more repeatable; it does not mean that version should never be updated.

go mod vendor is useful for offline or hermetic builds when the repository requires vendoring. It is not necessary for every application. go mod tidy is not a general cleanup button: review the dependency changes it makes.

## 4. Documentation workflow

~~~powershell
go doc fmt.Printf
go doc net/http.Client
go doc example.com/module/package@v1.2.3.Symbol
~~~

Use go doc for documentation available to the current module and toolchain. Use [pkg.go.dev](https://pkg.go.dev/) to browse published package documentation and versions. Check that the documentation version matches the version your module uses.

Official docs answer API details. The Go specification defines language behavior. Blog posts and examples explain design intent and practice but can age.

## 5. A repeatable local check

~~~powershell
go fmt ./...
go vet ./...
go test ./...
go build ./...
~~~

Some repositories use a strict formatting check or additional linters and security scanners. Match the project’s CI. Passing go vet is not proof of correctness, and tests cover only the cases they execute.

## Common mistakes

- Running commands from the wrong module root.
- Treating go.work as a replacement for go.mod.
- Installing a package intended to be imported as if it were a command.
- Running go mod tidy and accepting dependency changes without review.
- Reading docs for a newer library than the module version.
- Assuming go build runs tests or go generate.

## Guided practice with answers

**1. Add an import, then run go mod tidy. What should you inspect?**  
Review go.mod and go.sum, and confirm that added or removed modules match the intended imports.

**2. You need docs for a dependency at v1.2.3. How can you ask go doc?**  
Use version-qualified documentation such as go doc example.com/module/package@v1.2.3.Symbol when supported; otherwise inspect the dependency’s tagged docs.

**3. Does go test ./... run a code generator automatically?**  
No. Run go generate explicitly when the project requires it.

## Quiz

### Questions

1. What does go fmt change?
2. What does go test ./... do?
3. What is the role of go.mod?
4. What does go mod tidy reconcile?
5. Must every Go project use go mod vendor?
6. What does go.work coordinate?
7. Where should you run go build ./... for a module?
8. How is a CLI tool different from an importable library dependency?
9. What does go doc help you find?
10. Does go vet prove a program has no bugs?
11. Does go build run tests?
12. Why should module-file changes be reviewed?

### Answer key

1. It applies standard source formatting.
2. It builds and runs tests for packages recursively under the current module.
3. It identifies the module and records language and dependency information.
4. Dependencies required by imports and stale requirements or sums under module rules.
5. No. Use it when repository or build requirements call for it.
6. Multiple local modules in a development workspace.
7. At a suitable module root.
8. A tool installs an executable; a library is imported and tracked as a project dependency.
9. Package and symbol documentation for the current environment or a version-qualified module.
10. No. It reports selected suspicious patterns.
11. No.
12. They affect dependency selection and the software supply chain.

## References and further reading

- [Go command documentation](https://go.dev/doc/cmd)
- [Go modules reference](https://go.dev/ref/mod)
- [Go module tutorial](https://go.dev/doc/tutorial/create-module)
- [Go workspaces tutorial](https://go.dev/doc/tutorial/workspaces)
- [Go specification](https://go.dev/ref/spec)
- [cmd/go package documentation](https://pkg.go.dev/cmd/go)
- [Go 1.27 release notes](https://go.dev/doc/go1.27)

[Persian version](README.md) · [Next chapter: language basics](../../02-مبانی-زبان/01-variables-constants/README.en.md)

</div>