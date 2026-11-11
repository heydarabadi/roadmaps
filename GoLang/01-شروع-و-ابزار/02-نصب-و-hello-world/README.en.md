# 1.2 — Install Go and run Hello World

<div dir="ltr">

**Time:** 60 minutes · **Prerequisite:** [Go overview](../01-معرفی-go/README.en.md)  
**Goal:** Install a toolchain, inspect its configuration, create a module, run code, and distinguish source files from built executables.

## 1. Install a toolchain

Download an official release for your operating system and architecture from [go.dev/dl](https://go.dev/dl/). On managed machines, follow the organization’s installation policy. Avoid mixing an old system package and a newer manual install in PATH.

On Windows, the official installer usually configures PATH. Close and reopen PowerShell after installation, then check:

~~~powershell
go version
go env GOROOT GOPATH GOMOD GOTOOLCHAIN
where.exe go
~~~

On macOS or Linux, use the official installer or a package manager that tracks a supported release, then check which go and go version. If multiple Go binaries appear, inspect PATH order before changing files.

GOROOT identifies the Go distribution. GOPATH is used for caches and installed tools; modern source projects do not need to live under GOPATH. GOMOD points at the active module file. go env shows the configuration that the command actually uses.

## 2. Create a module

~~~powershell
mkdir hello-go
cd hello-go
go mod init example.com/hello
~~~

A module is a versioned collection of Go packages. The module path is an import identity; it does not have to be a public website for local learning. go mod init creates go.mod, which records the module path and language version.

Create main.go:

~~~go
package main

import "fmt"

func main() {
    fmt.Println("Hello, Go")
}
~~~

## 3. Run, format, and build

~~~powershell
go run .
go fmt ./...
go build -o hello.exe .
.\hello.exe
~~~

go run compiles and runs for development. go fmt formats packages. go build creates an executable. The output extension depends on the target OS. A successful build says the compiler could construct the program; it does not prove the behavior is correct.

For a quick scratch file, go run main.go works, but a module directory is a better starting point for multi-file projects and dependencies.

## 4. Understand installation paths

- go version identifies the selected command version.
- go env GOROOT shows the installation tree. Do not normally edit files inside it.
- go env GOPATH shows cache and installed-tool locations.
- go env GOBIN can override where go install puts tools; when empty, the default is usually GOPATH/bin.
- where.exe go or which go can reveal multiple installations.

Installing Go tools and importing Go libraries are different operations. A tool executable may be installed with go install; a project library is added and tracked as a module dependency.

## 5. Troubleshooting checklist

**“go is not recognized” or “command not found”:** reopen the terminal, inspect PATH, and confirm the installer completed.

**Unexpected Go version:** inspect every path returned by where.exe go or which -a go; fix PATH order through the normal installer or environment settings.

**Network or proxy failure:** check corporate proxy, DNS, certificate configuration, and GOPROXY policy. Do not disable TLS verification as a shortcut.

**Permission error:** choose a user-writable project directory and install location rather than running the editor as administrator.

**Build works on one machine only:** record the Go version, OS, architecture, build tags, and cgo use.

## Guided practice with answers

**1. Run go env GOMOD outside and inside the module. What changes?**  
Outside, it may report no active module. Inside, it should point to this project’s go.mod.

**2. go run . succeeds but there is no executable file. Why?**  
go run runs a temporary build. Use go build to create a persistent artifact.

**3. The wrong Go version is selected. What do you inspect first?**  
The full path resolution from where.exe go or which -a go, and PATH order.

## Quiz

### Questions

1. Where should an official Go release be obtained?
2. What does go version tell you?
3. What is GOROOT for?
4. Must modern projects be stored under GOPATH?
5. What file does go mod init create?
6. What is the difference between go run and go build?
7. What does go fmt do?
8. Why might PATH select the wrong Go installation?
9. Does a successful build prove the program is correct?
10. Why should TLS verification not be disabled to fix a module download issue?

### Answer key

1. The official download page or an organization-approved package source.
2. The version of the go command selected by the shell.
3. It identifies the installed Go distribution.
4. No.
5. go.mod.
6. go run builds and executes for development; go build produces an executable artifact.
7. Formats Go source consistently.
8. Multiple installations may be present, and the first matching PATH entry wins.
9. No. It proves compilation succeeded, not behavioral correctness.
10. It removes an important protection and can enable interception; fix the proxy or trust configuration instead.

## References and further reading

- [Official Go downloads](https://go.dev/dl/)
- [Getting started with Go](https://go.dev/doc/tutorial/getting-started)
- [Go installation guide](https://go.dev/doc/install)
- [Go environment variables](https://go.dev/doc/gopath)
- [Go command documentation](https://go.dev/doc/cmd)
- [Go modules reference](https://go.dev/ref/mod)
- [go env command reference](https://pkg.go.dev/cmd/go#hdr-Environment_variables)

[Persian version](README.md) · [Previous: overview](../01-معرفی-go/README.en.md) · [Next: commands and docs](../03-فرمان-و-docs/README.en.md)

</div>