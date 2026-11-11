# 14.1 — Runtime internals, reflection, unsafe, cgo, and plugins

<div dir="ltr">

**Time:** 180 minutes · **Prerequisite:** all earlier lessons  
**Goal:** Recognize advanced tools and boundaries, measure before optimizing, and understand the portability and safety costs.

## Runtime and memory management

The runtime schedules goroutines, manages memory, performs garbage collection, and supports timers and network polling. Exact scheduler, stack, allocation, and GC implementation details can change between releases. Write to language and package contracts, not assumptions about a particular compiler layout.

Escape analysis and allocation diagnostics can help explain a performance profile. They do not define correctness. Measure CPU, heap, allocation, blocking, and latency under a representative workload before changing data layout.

## Reflection

The reflect package inspects type and value metadata at runtime and can construct or update values when type information is dynamic. It is useful for serializers, frameworks, and generic tooling. It can make code harder to understand and may fail at runtime when a value is unsettable or unexported.

Prefer static types, interfaces, or generics when the shape is known at compile time. Validate reflect.Value before reading or setting it, and check CanSet before mutation.

## unsafe

unsafe bypasses ordinary type-safety guarantees and can create memory corruption, lifetime bugs, and architecture-specific behavior. Use it only for a narrow measured need and review the exact rules for the current Go release.

Converting pointers through uintptr is not a general way to keep objects alive. uintptr is an integer, not a GC pointer. Do not retain Go pointers in C memory beyond permitted lifetimes.

## cgo

cgo connects Go code to C libraries and ABIs. It can require a C compiler, target libraries, headers, and platform-specific build configuration. C allocations and Go allocations have different ownership; free C memory explicitly. Use runtime/cgo.Handle when C needs to retain a reference to a Go value according to the documented rules.

cgo can complicate cross-compilation, deployment images, debugging, and reproducibility. Consider a process or RPC boundary when isolation or independent upgrades matter.

## Compiler and linker flags

Compiler and linker options can affect diagnostics, inlining, symbols, binary size, and debugability. Keep build commands documented and stable. Stripping symbols may make production debugging harder; retain appropriate symbols or separate debug artifacts according to policy.

## Plugins and dynamic loading

Go plugins are supported only on selected operating systems and require compatible build conditions. They share the process and are not a security sandbox. Plugin unloading is not a general supported lifecycle. Use a separate process and RPC when you need a stronger isolation or version boundary.

## Historical performance cases

Twitch documented work on reducing garbage-collection latency in an older Go version; Allegro described profiling a large cache service. These cases teach that teams profile real workloads and collaborate on runtime behavior. They are historical and should not be read as measurements of current Go.

## Common mistakes

- Optimizing based on a compiler message rather than an end-to-end profile.
- Assuming a local value always stays on the stack.
- Using reflection when static type information is available.
- Ignoring invalid or unsettable reflect.Value cases.
- Treating uintptr as a GC-managed pointer.
- Retaining Go pointers in C beyond documented rules.
- Forgetting to free C allocations.
- Assuming cgo cross-compilation is automatic.
- Treating a plugin as a sandbox for untrusted code.
- Stripping symbols without preserving debug evidence.

## Guided practice with answers

**1. A parser consumes a small fraction of CPU and an unsafe rewrite is complex. Should you proceed?**  
First measure end-to-end impact and compare maintenance and safety costs. A small local improvement may not matter to the product.

**2. Should a generic sort over known slice types use reflection?**  
Usually use standard libraries or generics; reflection is justified when type shape is dynamic at runtime.

**3. Who frees a C.CString allocation?**  
The Go caller must release the C allocation with the documented C.free pattern.

**4. Is a Go plugin safe for untrusted code?**  
No. It runs inside the process and is not a sandbox.

## Quiz

### Questions

1. Which runtime details are not stable language guarantees?
2. What does escape analysis help explain?
3. Why should compiler diagnostics not become API contracts?
4. What does the garbage collector reclaim?
5. Why must a file be explicitly closed?
6. When is reflection appropriate?
7. What does reflect.Value.CanSet indicate?
8. What does TypeOf(nil) return?
9. Why does unsafe need careful review?
10. Is uintptr a GC pointer?
11. What external toolchain may cgo need?
12. Who releases C-allocated memory?
13. Can C retain arbitrary Go pointers after a call?
14. What does runtime/cgo.Handle support?
15. What platforms support Go plugins?
16. Are plugins a security sandbox?
17. Can a plugin generally be unloaded?
18. What must be compatible between a program and plugin?
19. What engineering lesson do historical GC cases teach?
20. What should justify an unsafe optimization?

### Answer key

1. Layout, stack/heap placement, scheduler internals, GC implementation, and exact compiler diagnostics.
2. Whether values need to outlive a function activation and may require heap storage.
3. Compiler implementation can change across releases.
4. Unreachable heap objects.
5. A file is an external resource that needs explicit cleanup.
6. When type information is genuinely dynamic at runtime.
7. Whether a reflected value can be set.
8. A nil Type result; ValueOf(nil) creates an invalid Value.
9. It may violate memory safety, portability, or lifetime guarantees.
10. No.
11. A C compiler, linker, headers, and native libraries as needed.
12. The caller that owns the allocation, using the C allocation’s release function.
13. No; documented pointer and pinning rules apply.
14. A safe handle mechanism for passing a Go value reference through C.
15. Selected platforms such as Linux, FreeBSD, and macOS.
16. No; plugin code shares the process.
17. Not as a general supported lifecycle.
18. Toolchain, build configuration, dependencies, and shared API assumptions.
19. Profile real workloads and treat results as version- and workload-specific.
20. A measured bottleneck that justifies the maintenance and safety cost.

## References and further reading

- [Go GC guide](https://go.dev/doc/gc-guide)
- [Go FAQ: stack or heap](https://go.dev/doc/faq#stack_or_heap)
- [reflect package](https://pkg.go.dev/reflect)
- [unsafe package](https://pkg.go.dev/unsafe)
- [cgo documentation](https://pkg.go.dev/cmd/cgo)
- [runtime/cgo package](https://pkg.go.dev/runtime/cgo)
- [plugin package and warnings](https://pkg.go.dev/plugin)
- [Go compiler documentation](https://pkg.go.dev/cmd/compile)
- [Go diagnostics](https://go.dev/doc/diagnostics)
- [Twitch: low-latency GC experience](https://blog.twitch.tv/en/2016/07/05/gos-march-to-low-latency-gc-a6fa96f06eb7/)
- [Allegro: profiling a fast cache](https://blog.allegro.tech/2016/03/writing-fast-cache-service-in-go.html)

[Persian version](../../../../fa/go/14-%D9%85%D8%A8%D8%A7%D8%AD%D8%AB-%D9%BE%DB%8C%D8%B4%D8%B1%D9%81%D8%AA%D9%87/01-advanced-runtime/README.md) · [Return to the course index](../README.md)

</div>