# Project 3 — Bounded Concurrent URL Checker

<div dir="ltr">

## Problem

Build a CLI that reports status code, response time, and error for each supplied URL. It must bound concurrent requests, define timeouts, stop on Ctrl+C, and print results in input order.

If users provide URLs directly to a local CLI, the risk differs from a public service. An API that fetches arbitrary caller-supplied URLs faces SSRF risks: loopback, private and link-local networks, metadata services, redirects to forbidden hosts, and DNS rebinding. String validation alone is not a complete defense.

## Result contract

~~~go
type Result struct {
    Index      int
    URL        string
    StatusCode int
    Duration   time.Duration
    Err        error
}
~~~

Each input should have exactly one result, including malformed URLs and timeouts. Define whether duplicates remain. HTTP 404 or 500 is a valid HTTP response; it differs from DNS or connection failure.

## Data-flow design

~~~text
input lines -> bounded jobs -> N workers -> result channel -> ordered collector
~~~

Let one collector own the result slice. Workers send results with an index instead of writing shared memory directly.

## Milestone 1: sequential version

Parse URLs and allow only http or https. Use an explicit client timeout, close each response body, measure with time.Since, and print in input order. Limit the number of URLs and input-file size.

HEAD may be cheaper when only status is needed, but some servers do not support it. Define GET fallback behavior and bound or close the response body.

**Acceptance:** distinguish invalid URL, DNS failure, refused connection, timeout, 404, and 200.

## Milestone 2: bounded worker pool

- Require a positive worker count with a configured upper bound.
- Send jobs using a context-aware select.
- Workers read until jobs close or cancellation is observed.
- A coordinator closes results only after all sender workers finish.
- The collector stores each result in its indexed slot.
- Choose buffer capacity for a reason; a large queue is not backpressure.

The component that knows all senders are done should close a channel. Multiple goroutines should not close the same channel.

## Milestone 3: cancellation and lifecycle

Use signal.NotifyContext for Ctrl+C. Pass the root context to the producer, workers, and every HTTP request. Stop submitting new work on cancellation. Preserve completed results and explicitly report canceled or unstarted work. Wait for goroutines owned by main before returning.

Document whether the CLI stops immediately or briefly drains completed work.

## Milestone 4: resource bounds and security

Limit input count and bytes. Do not download unbounded response bodies if only a status is needed. Define redirect behavior. A public service accepting arbitrary URLs must address SSRF and DNS behavior; a CLI should still redact URL userinfo and tokens from logs.

## Milestone 5: deterministic concurrency tests

Use httptest.Server with channel gates and an atomic active-request counter. Hold requests, record maximum concurrency, and release them deliberately. Avoid random sleeps; a timeout is a final hang guard, not the synchronization mechanism.

Test worker bounds, stable output order, invalid URLs, cancellation, HTTP 404 handling, redirect rules, and timeouts. Run race detection when authorized and supported; remember that it sees only executed interleavings.

## Milestone 6: measurement

Benchmark the parser or collector separately from network latency. For network measurements, separate the local server and client, record version/hardware/workload, and use benchmem. Profile only when you have a concrete bottleneck question. More concurrency can reduce throughput or overload remote servers.

## Common failure modes

- Closing results while a worker can still send.
- Never closing results, leaving the collector blocked.
- Calling WaitGroup.Add after workers may already be waited on.
- Letting workers mutate the same slice without synchronization.
- Deferring response-body close in a long outer loop.
- Handling cancellation in main but not passing context to HTTP.
- Logging full URLs that contain credentials or tokens.
- Starting one goroutine per unbounded input.

## Coordinator fragment

~~~go
go func() {
    workerGroup.Wait()
    close(results)
}()

for result := range results {
    ordered[result.Index] = result
}
~~~

This fragment shows only how worker completion can gate result closure. The job producer, job-channel close, cancellation, and collector lifecycle must also be coordinated.

## Real-world engineering lesson

Uber’s study of Go data races describes deploying detection in a large codebase. Its reported numbers apply to that study and period, not every project. The practical lesson is to combine detector runs with ownership, cancellation, and representative workload tests.

## Design exercises with answers

**Why store each result by index?**  
Completion order can differ from input order; the index reconstructs the requested order.

**Why should main not close results?**  
A worker may still send. The coordinator closes results after all senders finish.

**Why is HTTP 500 not a transport error?**  
An HTTP response arrived. DNS failure occurs before the HTTP exchange.

**Why not create one worker per URL?**  
Concurrency becomes unbounded and can overwhelm sockets or remote services.

## Quiz

### Questions

1. Why build the sequential version first?
2. Should a malformed URL still produce a result?
3. Why is 404 not a transport error?
4. Who closes the result channel?
5. Why should several senders not close one channel?
6. What resource does the worker limit control?
7. Does a large buffer remove backpressure?
8. How is input order preserved?
9. Why does every request need context?
10. Why close response bodies?
11. How do request timeout and root cancellation differ?
12. Does the race detector prove there are no races?
13. What is more reliable than a random sleep in a concurrent test?
14. What risk does a public arbitrary-URL API create?
15. Why does redirect policy matter?
16. Why redact credentials from a URL?

### Answer key

1. It provides a simple correct baseline.
2. Yes; return a result with a parse error.
3. It is a real HTTP response.
4. A coordinator that knows every sender is done.
5. Sending to a closed channel panics; closure needs one owner.
6. Concurrent requests, sockets, and downstream pressure.
7. No; it only changes queue capacity.
8. Store each result in the slot identified by Index.
9. To propagate cancellation and deadlines to transport.
10. To release connections and resources.
11. Timeout bounds one operation; cancellation stops shared lifecycle work.
12. No; it observes only executed interleavings.
13. Channel gates, WaitGroup, or an appropriate synchronization tool.
14. SSRF to private, loopback, or metadata destinations.
15. A permitted start host can redirect to a forbidden host.
16. Userinfo or query fields may contain secrets.

## References and further reading

- [net/http package](https://pkg.go.dev/net/http)
- [net/http/httptest package](https://pkg.go.dev/net/http/httptest)
- [context package](https://pkg.go.dev/context)
- [sync package](https://pkg.go.dev/sync)
- [Go data race detector](https://go.dev/doc/articles/race_detector)
- [Uber real-world data race study](https://arxiv.org/abs/2204.00764)
- [Go blog: pipelines and cancellation](https://go.dev/blog/pipelines)
- [OWASP: Server-Side Request Forgery prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)

[Persian project guide](README.md) · [Return to study plan](../../نقشه-مطالعه.en.md)

</div>