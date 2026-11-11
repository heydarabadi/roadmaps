# 9.2 — Synchronization, context, deadlines, and goroutine leaks

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** goroutines and channels  
**Goal:** Protect shared data, coordinate completion, propagate cancellation, and give every goroutine a bounded lifecycle.

## Mutexes protect shared state

A mutex makes a critical section exclusive. Keep the lock scope small and document which data it protects.

~~~go
type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Add(delta int) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value += delta
}
~~~

A mutex protects access only when every access follows the same locking rule. Do not copy a mutex after first use. Prefer ownership through channels when it makes state transitions easier to understand, but channels do not automatically make every design safer.

## WaitGroup coordinates completion

A WaitGroup waits until a group of goroutines finishes. Arrange Add before the goroutines begin and ensure every successful Add has a matching Done. Do not call Wait and Add concurrently without a lifecycle design.

~~~go
var group sync.WaitGroup
group.Add(1)
go func() {
    defer group.Done()
    doWork()
}()
group.Wait()
~~~

A WaitGroup does not carry errors or cancellation. Use a task abstraction such as errgroup when error propagation and context cancellation are needed.

## Context carries cancellation and deadlines

Pass context as the first parameter to operations that may block. A derived context should be canceled to release its timer and parent reference.

~~~go
ctx, cancel := context.WithTimeout(parent, 2*time.Second)
defer cancel()

req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
if err != nil {
    return err
}
~~~

Contexts are for request-scoped cancellation, deadlines, and small values that cross API boundaries. Do not store context in a struct or use it as a general optional-parameter bag. Use typed keys for request metadata when necessary.

Cancellation is cooperative. The operation must observe ctx.Done or use an API that accepts the context. A context does not forcibly kill a goroutine.

## Common uses and lifecycle

Use context for inbound requests, database queries, outbound HTTP, worker jobs, and graceful shutdown. Establish one parent lifecycle, derive narrower deadlines, and stop creating new work when cancellation arrives.

A timeout should bound the entire operation. Nested calls should not each receive a fresh full timeout that exceeds the caller’s deadline.

## Goroutine leaks and Go 1.27

A goroutine leak occurs when work has ended but a goroutine remains blocked or retains state. Common causes include an abandoned channel send, a receive with no producer, or a request context that is not propagated.

Go 1.27 adds a goroutineleak profile in runtime/pprof and a corresponding net/http/pprof endpoint. It can identify some permanently blocked goroutines using reachability analysis, but it is not a complete leak detector. Use it with ownership reasoning, tests, and profiles.

## Common mistakes

- Forgetting to call cancel on a derived context.
- Assuming cancellation forcibly stops arbitrary code.
- Passing context.Background into every layer instead of propagating the caller’s context.
- Storing context in a long-lived struct.
- Calling WaitGroup.Add after work may already be waited on.
- Copying a used mutex or WaitGroup.
- Holding a mutex while performing slow network I/O.
- Treating a goroutine-leak profile as proof that no leaks exist.

## Guided practice with answers

**1. A database query ignores ctx. Does cancel stop it?**  
No. The query API must receive and honor the context.

**2. Why should a timeout context’s cancel function be called even after success?**  
It releases timer and parent references promptly.

**3. A goroutine sends to a channel after the caller stopped receiving. What design change helps?**  
Add cancellation-aware send logic, or ensure the receiver drains the channel until all senders finish.

## Quiz

### Questions

1. What does a mutex protect?
2. Must every code path obey the same lock?
3. What does WaitGroup provide?
4. Does WaitGroup propagate errors?
5. Where should context usually appear in a function signature?
6. What should happen to a derived cancel function?
7. Can context forcibly kill a goroutine?
8. Why should context not be stored in a long-lived struct?
9. What does a deadline limit?
10. Name two common goroutine leak causes.
11. Which diagnostic profile was added in Go 1.27?
12. Does goroutineleak find every leak?

### Answer key

1. Shared data accessed under a consistent locking rule.
2. Yes.
3. Waiting for a known group of tasks to finish.
4. No.
5. As the first parameter.
6. Call it to release associated resources.
7. No; the goroutine must cooperate.
8. Context is request-scoped, not general object configuration.
9. The latest time an operation should continue.
10. Abandoned channel sends, receives without a producer, or missing cancellation propagation.
11. runtime/pprof goroutineleak.
12. No; it detects only some blocked goroutines.

## References and further reading

- [context package](https://pkg.go.dev/context)
- [sync package](https://pkg.go.dev/sync)
- [Go blog: Go Concurrency Patterns: Context](https://go.dev/blog/context)
- [Go blog: Pipelines and cancellation](https://go.dev/blog/pipelines)
- [Go memory model](https://go.dev/ref/mem)
- [errgroup package](https://pkg.go.dev/golang.org/x/sync/errgroup)
- [Go 1.27 release notes](https://go.dev/doc/go1.27)
- [Go diagnostics](https://go.dev/doc/diagnostics)

[Persian version](README.md) · [Next: worker pools and pipelines](../03-worker-pool-pipeline/README.en.md)

</div>