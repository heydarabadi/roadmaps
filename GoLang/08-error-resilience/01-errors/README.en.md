# 8.1 — Error handling, wrapping, retry, and debugging

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** functions, interfaces, and context  
**Goal:** Return and classify errors, preserve useful causes, and use retries only when the operation and system budget allow them.

## Errors are values

The built-in error interface has one method, Error() string. A function reports an ordinary failure by returning an error.

~~~go
func loadConfig(path string) (Config, error) {
    data, err := os.ReadFile(path)
    if err != nil {
        return Config{}, fmt.Errorf("read config: %w", err)
    }
    return parseConfig(data)
}
~~~

The caller should check the error before using a result that is invalid on failure. Returning a useful zero result is a convention, not proof that the result is meaningful.

## Add context and preserve the cause

Use fmt.Errorf with %w when callers need to inspect the underlying error. Each layer should add the operation that failed without repeating irrelevant details.

~~~go
if err != nil {
    return fmt.Errorf("load account %d: %w", id, err)
}
~~~

Use errors.Is to detect a known sentinel cause and errors.As to find a typed error. Do not compare error strings; wording can change and does not express identity.

~~~go
if errors.Is(err, os.ErrNotExist) {
    return ErrConfigMissing
}
~~~

## Sentinel errors and typed errors

A sentinel error is a stable package-level value used when callers need to branch on a specific condition. A typed error carries structured fields, such as an invalid field name or a retry delay. Expose only the distinctions that callers genuinely need.

Too many exported sentinel values can freeze an implementation. Too many custom types can make a simple API hard to use. Keep messages useful to people and classification useful to code.

## Stack traces and debugging

Ordinary Go errors do not automatically carry a full stack trace. Wrap errors with operation context. Use debugger breakpoints, logs, traces, and profiles to understand the failing path. For recovered panics at a deliberate process boundary, runtime/debug.Stack can capture diagnostic stack data. Do not print stack traces or secrets to public clients.

## Retry is a policy

Retry only if the operation is safe to repeat or has an idempotency mechanism. Network timeout does not prove the remote side did no work. Use bounded attempts, exponential backoff with jitter, an overall deadline, and a retry budget. Honor server retry hints when appropriate.

Retries can amplify overload. Google’s SRE guidance describes retry budgets as a way to keep retry traffic from consuming all capacity. Three attempts at each of two nested layers can multiply into more attempts than a caller intended. Place retry ownership at a clear layer.

Classify errors before retrying:

- Permanent validation or authorization errors should not be retried.
- Temporary network or overload failures may be retried within a deadline.
- A timeout after a write may have an unknown outcome and needs idempotency or reconciliation.
- Cancellation should stop retry loops.

~~~go
for attempt := 0; attempt < maxAttempts; attempt++ {
    err := perform(ctx)
    if err == nil {
        return nil
    }
    if !isTemporary(err) || attempt+1 == maxAttempts {
        return err
    }
    if err := waitBackoff(ctx, attempt); err != nil {
        return err
    }
}
~~~

## Common mistakes

- Ignoring an error or using the result before checking it.
- Wrapping with %v when callers need the underlying cause.
- Matching error text instead of using errors.Is or errors.As.
- Retrying non-idempotent operations without a deduplication key.
- Retrying forever or without an overall deadline.
- Retrying permanent errors.
- Returning SQL, file paths, or stack traces to an untrusted caller.

## Guided practice with answers

**1. A file read fails. Why wrap the error with the operation name?**  
The caller or operator can distinguish which stage failed while errors.Is can still inspect the underlying cause.

**2. A payment request times out. Is it safe to send the same charge again?**  
Not without an idempotency key or reconciliation strategy; the remote service may have completed the charge.

**3. Where should retry policy usually live?**  
At one clearly owned layer that understands idempotency, deadline, and dependency budget.

## Quiz

### Questions

1. What does the error interface require?
2. How does a function usually report ordinary failure?
3. What does %w preserve?
4. What does errors.Is test?
5. What does errors.As find?
6. Why should code avoid matching error strings?
7. What is a sentinel error?
8. What information can a typed error carry?
9. Do ordinary errors automatically contain full stack traces?
10. When can a timeout have an unknown outcome?
11. What makes an operation safe to retry?
12. Why are retry budgets useful?
13. Should cancellation be retried?
14. What can runtime/debug.Stack capture at a recovery boundary?
15. What should never be exposed in a public error response?

### Answer key

1. An Error() string method.
2. Return an error value.
3. The underlying cause in the error chain.
4. Whether an error chain contains a matching error.
5. A value assignable to a requested error type.
6. Text can change and does not model error identity.
7. A stable package-level error value used for classification.
8. Structured details such as field, code, or retry metadata.
9. No.
10. When the request may have reached and completed on the remote side.
11. Idempotency or a deduplication/reconciliation mechanism.
12. They limit retry amplification under overload.
13. No; cancellation should stop the retry loop.
14. A diagnostic stack trace.
15. Secrets, internal SQL/path detail, or sensitive stack data.

## References and further reading

- [Go blog: working with errors](https://go.dev/blog/go1.13-errors)
- [Errors package](https://pkg.go.dev/errors)
- [fmt package and error wrapping](https://pkg.go.dev/fmt)
- [Go Code Review Comments: error strings](https://go.dev/wiki/CodeReviewComments#error-strings)
- [Google SRE Book: handling overload](https://sre.google/sre-book/handling-overload/)
- [Google SRE Book: cascading failures](https://sre.google/sre-book/addressing-cascading-failures/)
- [runtime/debug package](https://pkg.go.dev/runtime/debug)
- [Go diagnostics](https://go.dev/doc/diagnostics)

[Persian version](README.md) · [Next: panic, defer, and recover](../02-panic-defer-recover/README.en.md)

</div>