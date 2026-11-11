# 7.1 — Packages, modules, and dependencies

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** functions, types, and interfaces  
**Goal:** Organize a Go codebase, manage dependencies, and publish a module without confusing package and module boundaries.

## Package and module

A package is a set of source files compiled together under one package name. A module is a versioned collection of packages identified by a module path and described by go.mod.

~~~text
shop/
  go.mod
  cmd/server/main.go
  internal/catalog/item.go
  internal/httpapi/handler.go
~~~

Imports use the module path plus package directory. A repository may contain multiple packages, and a module may contain many packages. A directory normally contains one package, with test files following Go’s test conventions.

## Package boundaries and imports

Names beginning with an uppercase letter are exported. Lowercase names are package-private. Avoid import cycles: package dependencies should form a directed acyclic graph.

The internal directory rule restricts imports to a permitted parent subtree. It is useful for implementation details that should not become public API. Do not split packages solely to increase directory count; package boundaries should express responsibility and reduce dependency coupling.

## Module workflow

~~~powershell
go mod init example.com/author/project
go get example.com/library@v1.2.3
go mod tidy
go list -m all
~~~

go.mod declares the module path, Go language version, and requirements. go.sum records checksums for downloaded module content. Review both files after adding or upgrading dependencies.

go mod tidy reconciles module requirements with imports. go mod vendor copies dependencies when a repository requires it for offline or controlled builds. Vendoring is a policy choice, not a requirement for every application.

## Semantic versioning and v2 modules

Semantic versions communicate compatibility expectations. For a module that reaches major version 2 or higher, the module path normally includes the major version suffix such as /v2. This lets old and incompatible new major versions be imported distinctly.

Use tagged releases and document breaking changes. Avoid publishing a moving default branch as the only version contract.

## Initialization and dependency design

Package-level variables are initialized before init functions. init runs automatically and can obscure ordering and side effects. Prefer explicit constructors and main-level wiring when they make lifecycle and dependency creation clearer.

A third-party dependency should earn its place. Consider maintenance, license, security response, transitive dependencies, API fit, and migration cost. The standard library may be enough for a small feature.

## Publishing a module

Before publishing:

1. Confirm the module path matches the repository’s intended import path.
2. Add package documentation and examples.
3. Choose semantic version tags.
4. For v2+, use a major-version suffix in the module path.
5. Verify that consumers can resolve the tagged version.
6. Review exported API and compatibility implications.
7. Track dependency advisories and release ownership.

A public module is an API whether or not it is called a library.

## Common mistakes

- Confusing repository, package, and module.
- Creating an import cycle.
- Exposing every implementation package publicly.
- Ignoring the /v2 major-version path convention.
- Treating go mod tidy as permission to accept every dependency change.
- Using init for complex hidden dependency wiring.
- Adding a dependency without checking its maintenance and license.

## Guided practice with answers

**1. A project has cmd/server and internal/store directories. Is each directory automatically a separate module?**  
No. They can be packages within one module described by the root go.mod.

**2. A v2 release breaks compatibility. How should the import identity change?**  
Use a /v2 suffix in the module path and publish a v2 semantic version.

**3. Why might an implementation package live under internal?**  
To limit imports to the allowed subtree and avoid making an implementation detail public.

## Quiz

### Questions

1. What is a package?
2. What is a module?
3. What does go.mod identify?
4. What does go.sum record?
5. What can create an import cycle?
6. What does the internal directory convention restrict?
7. What does go mod tidy do?
8. Is vendoring mandatory for every project?
9. What path convention applies to a v2 module?
10. Why can init make a program harder to understand?
11. Name two dependency review concerns besides feature fit.
12. What makes a published module an API?

### Answer key

1. Source files compiled together as one unit.
2. A versioned collection of packages with a module path.
3. The module path and dependency/language-version metadata.
4. Checksums for downloaded module content.
5. Packages importing each other, directly or indirectly.
6. Which subtree may import the package.
7. Reconciles dependencies with source imports.
8. No.
9. Normally include /v2 in the module path.
10. It performs hidden side effects and makes initialization order less explicit.
11. Maintenance, license, security response, transitive dependencies, or migration cost.
12. Other programs can depend on its exported surface.

## References and further reading

- [Go modules reference](https://go.dev/ref/mod)
- [Developing and publishing modules](https://go.dev/doc/modules/developing)
- [Go module tutorial: create a module](https://go.dev/doc/tutorial/create-module)
- [Go module version numbering](https://go.dev/doc/modules/version-numbers)
- [Package naming guidance](https://go.dev/blog/package-names)
- [Go Code Review Comments: package comments](https://go.dev/wiki/CodeReviewComments#package-comments)
- [Go vulnerability management](https://go.dev/doc/security/vuln/)
- [Go module proxy documentation](https://proxy.golang.org/)

[Persian version](README.md) · [Next chapter: error handling](../../08-error-resilience/01-errors/README.en.md)

</div>