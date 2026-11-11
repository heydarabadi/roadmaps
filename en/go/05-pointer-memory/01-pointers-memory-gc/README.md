# 5.1 — Pointers, memory, and garbage collection

<div dir="ltr">

**Time:** 120 minutes · **Prerequisite:** structs, slices, and functions  
**Goal:** Use pointers for clear ownership and mutation, and reason about memory without depending on compiler implementation details.

## Address and dereference

A pointer stores the address of a value. The address operator takes an address; dereferencing reads or updates the pointed-to value.

~~~go
value := 10
pointer := &value
*pointer = 12
fmt.Println(value) // 12
~~~

The zero value of a pointer is nil. Dereferencing nil panics. Check nil when it is part of the API contract; do not add redundant checks where a non-nil value is guaranteed by construction.

## Go still passes pointers by value

Function arguments are passed by value, including pointer values. Copying a pointer copies the address, so both copies may refer to the same object.

~~~go
type User struct {
    Name string
}

func rename(user *User, name string) {
    user.Name = name
}
~~~

Use a pointer receiver or pointer parameter when mutation of the original object is intended, or copying a large value would be undesirable. Value semantics are often simpler for small immutable values.

## Slices and maps already refer to shared data

A slice value contains a descriptor referring to a backing array. A map value refers to shared map data. Passing either by value copies its descriptor or map value but may still allow mutation of shared elements. A pointer to a slice or map is not automatically needed.

Pointer questions are really ownership questions: who may mutate the data, how long does it live, and who synchronizes concurrent access?

## Stack, heap, escape analysis, and GC

Go’s compiler and runtime decide where values are stored. Escape analysis determines whether a value’s lifetime must extend beyond a function activation. A value that escapes may be allocated on the heap, but stack/heap placement is an implementation detail and may change across compiler versions.

The garbage collector reclaims unreachable heap objects. It does not close files, sockets, database transactions, or goroutines. Use explicit cleanup such as Close and context cancellation.

~~~go
file, err := os.Open(path)
if err != nil {
    return err
}
defer file.Close()
~~~

Do not rely on an exact collection time. Keep allocations bounded and measure heap behavior under realistic load.

## Diagnose before tuning

The compiler can print escape and inlining diagnostics, but those messages are not a language contract. Use benchmarks and heap profiles to determine whether allocations matter to the workload.

A production service may have a high allocation rate without a memory leak. A leak is often a reachable object retained longer than intended, such as a small subslice keeping a large array alive or a goroutine retaining request state.

## Common mistakes

- Dereferencing nil.
- Returning a pointer only because another language uses references.
- Assuming pointer passing is pass-by-reference rather than passing an address value.
- Assuming a local variable always lives on the stack.
- Depending on escape-analysis messages for correctness.
- Expecting the GC to close external resources.
- Tuning GOGC or using unsafe before profiling.

## Guided practice with answers

**1. Two variables contain copies of the same pointer. Can one mutate the object observed by the other?**  
Yes. Both pointer values refer to the same address.

**2. A function returns a pointer to a local value. Is that automatically a dangling pointer?**  
No. Go keeps the value alive as needed. The compiler/runtime handle lifetime, though allocation placement is not guaranteed.

**3. A service’s heap grows. What should you inspect before tuning the GC?**  
Heap profiles, retained objects, request lifetime, caches, goroutine stacks, and realistic load patterns.

## Quiz

### Questions

1. What does a pointer store?
2. What is the zero value of a pointer?
3. What happens when a nil pointer is dereferenced?
4. Are Go function arguments passed by value?
5. Why can copying a pointer still expose shared mutation?
6. Do slices and maps necessarily need an extra pointer parameter?
7. What does escape analysis help decide?
8. Is stack versus heap placement a stable language guarantee?
9. What does the garbage collector reclaim?
10. Does garbage collection close a file?
11. What should be used to clean up a file?
12. What evidence should guide memory tuning?

### Answer key

1. The address of a value.
2. nil.
3. It panics.
4. Yes.
5. Both copies can contain the same address.
6. No; their values already refer to shared backing data.
7. Whether a value’s lifetime extends beyond a function activation.
8. No; it is an implementation detail.
9. Unreachable heap objects.
10. No.
11. Explicit Close, often scheduled with defer.
12. Benchmarks and profiles from realistic workloads.

## References and further reading

- [Go FAQ: stack or heap allocation](https://go.dev/doc/faq#stack_or_heap)
- [Go GC guide](https://go.dev/doc/gc-guide)
- [Go memory model](https://go.dev/ref/mem)
- [Compiler optimization diagnostics](https://pkg.go.dev/cmd/compile)
- [Go blog: Go slices: usage and internals](https://go.dev/blog/slices-intro)
- [Go blog: Profiling Go programs](https://go.dev/blog/pprof)
- [Allegro: fast cache service and GC profiling](https://blog.allegro.tech/2016/03/writing-fast-cache-service-in-go.html)
- [Twitch: Go’s march to low-latency GC](https://blog.twitch.tv/en/2016/07/05/gos-march-to-low-latency-gc-a6fa96f06eb7/)

[Persian version](README.md) · [Next: methods and interfaces](../../06-متد-interface-generics/01-methods-interfaces/README.en.md)

</div>