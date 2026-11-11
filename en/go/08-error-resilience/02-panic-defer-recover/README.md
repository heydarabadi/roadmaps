# 8.2 — defer, panic, recover, and process boundaries

<div dir="ltr">

**Time:** 90 minutes · **Prerequisite:** errors and functions  
**Goal:** Use defer for cleanup and reserve panic/recover for exceptional programmer or process-boundary cases.

## defer is for cleanup

A defer call runs when the surrounding function returns, including when it returns through panic. Multiple deferred calls run in last-in, first-out order. Arguments are evaluated when the defer statement executes.

~~~go
file, err := os.Open(path)
if err != nil {
    return err
}
defer file.Close()
~~~

Check errors from cleanup when they matter, especially for writes and flushes. A single deferred Close is not always enough to report a failed final write.

## panic is not ordinary error handling

panic begins unwinding the current goroutine and runs deferred calls. If no recover stops it, the panic terminates the program. Use returned errors for expected failures such as invalid user input, missing records, or network timeouts.

A panic is appropriate for violated internal invariants that the program cannot safely continue from, or in a deliberately designed boundary that converts a panic into a controlled failure.

## recover is goroutine-local

recover is useful only when called directly by a deferred function in the same goroutine that is panicking. It does not catch panics from another goroutine.

~~~go
func protect(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        defer func() {
            if recovered := recover(); recovered != nil {
                log.Printf("handler panic: %v", recovered)
                http.Error(w, "internal server error", http.StatusInternalServerError)
            }
        }()
        next.ServeHTTP(w, r)
    })
}
~~~

A recovery boundary should log enough diagnostic context for operators, avoid leaking internal data to clients, and decide whether process health is still trustworthy. It must not silently turn corrupted state into success.

## Panic in goroutines

A panic in a child goroutine is not recovered by a defer in the parent goroutine. If worker goroutines may panic, define who owns their lifecycle and whether the process should fail. Recovering every panic globally can hide serious invariant violations.

## Common mistakes

- Using panic for expected validation or I/O failures.
- Expecting a parent goroutine to recover a child’s panic.
- Calling recover outside a deferred function.
- Recovering and then returning a success-shaped response.
- Ignoring Close or Flush errors on important writes.
- Logging sensitive request data while reporting a panic.

## Guided practice with answers

**1. A user enters an invalid quantity. Should the parser panic?**  
No. Return a validation error.

**2. Can recover in main catch a panic in a worker goroutine?**  
No. Recovery is goroutine-local.

**3. What should an HTTP recovery middleware do?**  
Stop the request’s panic from crashing the whole process, record controlled diagnostics, send a safe 500 if possible, and preserve evidence of the failure.

## Quiz

### Questions

1. When does a deferred call execute?
2. In what order do multiple defers execute?
3. When are defer arguments evaluated?
4. What does panic do?
5. How should expected failures usually be represented?
6. Where must recover run to catch a panic?
7. Can one goroutine recover another goroutine’s panic?
8. Why is blanket recovery dangerous?
9. What should an HTTP recovery boundary avoid sending to the client?
10. When should cleanup errors be checked?

### Answer key

1. When the surrounding function returns or unwinds.
2. Last-in, first-out.
3. When the defer statement executes.
4. Unwinds the current goroutine and runs deferred calls.
5. Returned error values.
6. Directly in a deferred function in the panicking goroutine.
7. No.
8. It can hide invariant violations or corrupted state.
9. Internal stack traces, secrets, and sensitive request data.
10. When closing or flushing can fail in a way that affects correctness.

## References and further reading

- [Go specification: defer statements](https://go.dev/ref/spec#Defer_statements)
- [Go specification: handling panics](https://go.dev/ref/spec#Handling_panics)
- [Go blog: Defer, Panic, and Recover](https://go.dev/blog/defer-panic-and-recover)
- [runtime package: panic and recover](https://pkg.go.dev/runtime#Panic)
- [net/http package](https://pkg.go.dev/net/http)
- [Go Code Review Comments: errors](https://go.dev/wiki/CodeReviewComments)

[Persian version](README.md) · [Next chapter: goroutines and channels](../../09-concurrency/01-goroutines-channels/README.en.md)

</div>