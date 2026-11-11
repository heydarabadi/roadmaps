# 4.2 — Functions, multiple results, variadic parameters, and closures

<div dir="ltr">

**Time:** 120 minutes · **Prerequisite:** control flow and types  
**Goal:** Design functions with clear contracts, understand value passing, and use closures without hiding ownership or lifetime.

## Function signatures and call-by-value

A function groups behavior behind inputs and outputs. Go passes arguments by value. For a slice, map, pointer, or interface, the copied value may still refer to shared data; the value itself is copied.

~~~go
func add(a, b int) int {
    return a + b
}

func update(value int) {
    value = 99
}
~~~

Calling update with an integer does not change the caller’s variable. Pass a pointer or return a new value when mutation is part of the contract. A pointer is not automatically better; explicit return values are often easier to reason about.

## Multiple results and errors

Multiple return values are commonly used for a result plus an error:

~~~go
func parseCount(input string) (int, error) {
    value, err := strconv.Atoi(input)
    if err != nil {
        return 0, fmt.Errorf("parse count: %w", err)
    }
    return value, nil
}
~~~

Inspect the error before using a result whose validity depends on success. Returning a zero value on error is a useful convention, but document it when callers might misunderstand it.

## Variadic functions

A variadic parameter accepts zero or more values of one type:

~~~go
func sum(values ...int) int {
    total := 0
    for _, value := range values {
        total += value
    }
    return total
}
~~~

Inside the function the variadic parameter behaves like a slice. A slice can be expanded into variadic arguments with Go’s expansion syntax. Do not add a variadic parameter if the caller always supplies one fixed collection.

## Function values and closures

Functions can be stored in variables, passed as arguments, and returned. A closure is a function value that refers to variables from an enclosing scope.

~~~go
func counter() func() int {
    value := 0
    return func() int {
        value++
        return value
    }
}
~~~

The returned function keeps the captured variable alive. A closure captures a variable, not a frozen snapshot. Concurrent calls to this counter need synchronization because they mutate shared state.

Callbacks can represent a policy or extension point. Too many callbacks can make control flow harder to follow; use them when they clarify a real need.

## Anonymous functions and named results

An anonymous function has no declared function name. It can be useful as a short callback or local helper. Named results may document a simple API but can make longer functions harder to understand.

~~~go
func divide(a, b float64) (quotient float64, err error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    quotient = a / b
    return quotient, nil
}
~~~

Prefer explicit return values when named-result control flow would be confusing. Avoid naked returns in long functions.

## defer and function lifetime

defer schedules a call when the surrounding function returns. Deferred calls run in last-in, first-out order. Arguments are evaluated when the defer statement executes.

~~~go
file, err := os.Open(path)
if err != nil {
    return err
}
defer file.Close()
~~~

This is appropriate for local cleanup. In a long-running loop, a defer inside the outer function may postpone many closes; move one iteration into a helper so each resource closes promptly.

## Common mistakes

- Assuming passing a slice or map copies all its elements.
- Mutating caller data without making the behavior clear.
- Ignoring an error result.
- Using named returns and naked return in complex functions.
- Capturing mutable state in a closure and calling it concurrently.
- Deferring cleanup inside a large loop.
- Creating callback APIs where a direct function is clearer.

## Guided practice with answers

**1. Does assigning to an int parameter change the caller’s variable?**  
No. The parameter is a copy.

**2. What does this closure retain?**  
~~~go
func makeReader() func() int {
    n := 0
    return func() int { n++; return n }
}
~~~
**Answer:** The returned function keeps access to n in its enclosing activation.

**3. Why can defer file.Close be wrong inside a large loop?**  
The close may wait until the containing function returns. Use a helper per iteration or close explicitly after the operation.

## Quiz

### Questions

1. How are function arguments passed in Go?
2. Does passing a slice copy all its elements?
3. What common pair of results does a Go function return?
4. Why inspect an error before using a result?
5. How does a variadic parameter appear inside the function?
6. What is a closure?
7. Does a closure capture a variable or a snapshot?
8. What can go wrong when a closure mutates shared state concurrently?
9. In what order do deferred calls execute?
10. When are defer call arguments evaluated?
11. Why can defer inside a long loop retain resources?
12. When are named return values useful?

### Answer key

1. By value.
2. No. The copied slice descriptor may still refer to shared backing storage.
3. A value and an error.
4. The value may be invalid if the operation failed.
5. As a slice.
6. A function value that refers to variables in an enclosing scope.
7. A variable.
8. A data race or inconsistent result unless synchronized.
9. Last-in, first-out.
10. When the defer statement executes.
11. The containing function may not return until the loop ends.
12. When they clearly document a simple result contract; otherwise explicit returns may be clearer.

## References and further reading

- [Go specification: function declarations](https://go.dev/ref/spec#Function_declarations)
- [Go specification: calls](https://go.dev/ref/spec#Calls)
- [Go specification: return statements](https://go.dev/ref/spec#Return_statements)
- [Go specification: defer statements](https://go.dev/ref/spec#Defer_statements)
- [Effective Go: functions](https://go.dev/doc/effective_go#functions)
- [Go blog: Defer, Panic, and Recover](https://go.dev/blog/defer-panic-and-recover)
- [A Tour of Go: function values and closures](https://go.dev/tour/moretypes/25)
- [Go Code Review Comments: error strings](https://go.dev/wiki/CodeReviewComments#error-strings)

[Persian version](README.md) · [Next chapter: pointers and memory](../../05-pointer-memory/01-pointers-memory-gc/README.en.md)

</div>