# 6.7 — Timeouts, Deadlines, and Retries

**Language:** English | [فارسی](README.md)

A timeout limits how long one operation waits. A deadline is the last permitted time for all work in a request. A retry is another attempt at an operation that may have failed temporarily. These tools release resources and tolerate faults, but unlimited retries can overwhelm an already saturated service.

**Learning goal:** divide an end-to-end budget, bound attempt count and duration, use backoff and jitter, and retry side effects only under an idempotency contract. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

A timeout is the maximum wait for an operation. A deadline is one shared end time for queueing, attempts, delays, and response construction. A transient error may recover on another attempt; a validation failure usually will not. **Idempotency** means repeating the same operation under the same identity does not create a new business effect. **Jitter** adds randomness to retry delay so clients do not all retry at once.

## Mental model and policy

| Concept | What it limits | Note |
| --- | --- | --- |
| Connection timeout | Waiting to establish a connection | DNS/TLS coverage depends on the library |
| Per-attempt timeout | Duration of one attempt | Must not exceed remaining budget |
| Overall deadline | Queues, attempts, backoff, and response delivery | Propagate through every layer |
| Retry budget | Number or share of extra attempts | Limits load during overload |
| Backoff + jitter | Delay and synchronization of attempts | Spreads coordinated immediate retries |

The [AWS Builders' Library](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/) describes Amazon's experience choosing timeouts from downstream latency, limiting retries, and spreading attempts. A value that is too short creates false timeouts and extra traffic; one that is too long holds resources. There is no universal number.

[gRPC Deadlines](https://grpc.io/docs/guides/deadlines/) explains how a deadline limits client waiting and that propagation depends on language and settings. When cancellation is received, application work must also stop. Returning an error to the client does not prove that queries and side effects have stopped. Use a monotonic clock for local elapsed-time calculations. Propagate remaining time according to the protocol/library so raw wall-clock differences do not cause problems.

## Worked example: a 600 ms budget

**Instructional assumption:** the request has a 600 ms budget from entry to response. Authorization uses 50 ms and 50 ms is reserved for encoding/delivery, leaving at most 500 ms for dependencies and their waits.

| Part | Hypothetical cap | Worst-case total used |
| --- | ---: | ---: |
| First attempt | 200 ms | 200 ms |
| Jittered backoff | Up to 100 ms | 300 ms |
| Second attempt | 150 ms | 450 ms |
| Coordination margin | 50 ms | 500 ms |

“Two attempts” includes the first attempt, not two retries after it. Recheck remaining time before sleeping and before the second attempt. If earlier queueing used some budget, lower the caps or cancel the attempt. These margins are a model; the scheduler does not guarantee a hard completion time.

~~~text
for attempt in 1..max_attempts:
    remaining = deadline - monotonic_now() - response_reserve
    if remaining < minimum_useful_attempt: stop
    timeout = min(attempt_limit[attempt], remaining)
    result = call(timeout, cancellation, idempotency_key)
    if success: return result
    if not retryable(result) or not safe_to_repeat: stop
    if attempt == max_attempts: stop
    cap = min(max_backoff, base * 2^(attempt - 1))
    delay = random_uniform(0, cap)  # full jitter
    if delay + minimum_useful_attempt > remaining_now(): stop
    sleep_cancellable(delay)
~~~

Guard attempt counts and delays against overflow and invalid values. This pseudocode describes a general policy; account for retries inside a driver or SDK so policies do not stack invisibly. If each of five layers makes three attempts, the lowest layer could receive <code>3^5 = 243</code> calls per request in the worst case. Choose one retry owner and a shared budget.

## Safe repetition and unknown outcomes

A timeout may happen after an operation took effect. For a payment, “I got no response” does not mean “the payment did not happen.” Idempotency needs a stable key for the same operation, durable result storage, and concurrency control; generating a new key on each attempt defeats deduplication. The same key with a different payload should be rejected or handled under an explicit contract. Retention must cover the real retry window. For an unknown outcome, checking status or reconciling may be safer than blindly repeating.

Do not automatically retry validation or authorization errors. Some overload or transient errors are retryable only under the service's contract; include <code>Retry-After</code> and rate limits in the total budget. Jitter does not authorize unlimited retries. A read may also be expensive or hide side effects.

## Exercise with worked solution

Ten hypothetical clients fail at the same moment. First, let all retry exactly 100 ms later; then draw random delays between 0 and 100 ms.

**Solution:** in the fixed-delay case, all ten retries arrive together. With jitter, each chooses a time in the interval, so the peak is spread out but the total can still be ten retries. Now add 120 ms of queue delay to the example budget: of the 500 ms dependency budget, only 380 ms remain, while <span dir="ltr">200 + 100 + 150 = 450 ms</span> may be required. Shorten or omit the second attempt; do not restart the overall deadline.

## Firsthand operational evidence

In the same **2019** [AWS report](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/), a short timeout included creating a fresh secure connection and caused trouble after deployment; preparing connections before receiving traffic was the reported remedy. The lesson is to inspect what a timeout covers, not to use the article's value universally. This lesson's 600 ms scenario is independent and hypothetical.

## Failures and signals

| Failure | Signal | What to inspect |
| --- | --- | --- |
| Retries at multiple layers | Calls per request and errors both rise | One retry owner and shared budget |
| Timeout too short | False timeouts and many retries | Latency distribution, network, connection coverage |
| Deadline only at the edge | Work continues after error response | Propagation and actual cancellation downstream |
| Write retried with a new key | Duplicate side effect | Stable key and durable result |
| Backoff without jitter | Regular retry waves | Bounded random delay and cancellation |

### Operational checklist

- [ ] Budget includes queues, connection, request, backoff, and delivery.
- [ ] Maximum-attempt meaning and retryable errors are explicit.
- [ ] Retries in SDKs, proxies, and drivers are counted.
- [ ] Deadline and cancellation reach the actual work.
- [ ] Idempotency, concurrency, payload, and key retention are defined.
- [ ] Attempts/request, timeouts, success-after-retry, and downstream load are monitored.

## Quiz

1. What is the difference between an end-to-end deadline and a timeout per attempt?
2. Why does a payment timeout not prove that payment failed?
3. With three attempts at each of five layers, how many lowest-level calls may occur?
4. What does jitter reduce, and what does it not reduce?
5. Why must an idempotency key stay the same across retries?
6. If 40 ms remain and the minimum useful attempt needs 70 ms, what should happen?

### Explained answers

1. A deadline limits the entire path, including attempts and waits; a per-attempt timeout limits only that attempt.
2. The server may have completed the operation while the response was lost or late. The outcome is unknown; query status or repeat safely.
3. 243. Attempts multiply across layers and can amplify an outage.
4. Jitter spreads synchronization and retry peaks; it does not reduce attempt count or the actual cost of each attempt.
5. The system must recognize a repeated operation; a new key can look like a new operation.
6. Do not start another attempt; there is insufficient budget. Return a controlled error or use an allowed fallback.

## Summary

Propagate one end-to-end deadline and use remaining time to set each attempt's timeout. Retry only permitted failures and safe operations, with attempt/time bounds and jitter. After a write timeout, the result may be unknown; retain the same idempotency key and provide a way to check status.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and technical provenance.

- **Persian, Go-specific:** [Retry and timeout patterns in Go](https://book.gofarsi.ir/chapter-9/concurrency-patterns/go-concurrency-pattern-retry-timeout/). Shows Go context and cancellation; production policy still needs a shared budget and idempotency.
- **English, firsthand AWS guidance:** [Timeouts, retries, and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/). Operational experience with transient failures, timeouts, and overload amplification.
- **English, official AWS pattern:** [Retry with backoff](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/retry-backoff.html). Idempotency, transient failures, and backoff cost; examples depend on call patterns.
- **English, official Microsoft guidance:** [HTTP resilience in .NET](https://learn.microsoft.com/en-us/dotnet/core/resilience/http-resilience). Example layering of total/attempt timeouts, rate limits, and retries for HttpClient; defaults apply only to that stack.
- **English, official AWS framework:** [Limit retry calls](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/rel_mitigate_interaction_failure_limit_retries.html). Recommends jitter, maximum attempts, and choosing a retry layer to limit amplification; adapt the guidance to the service contract.
- **English, official gRPC guide:** [Deadlines](https://grpc.io/docs/guides/deadlines/). Deadline behavior, propagation, and responsibility for stopping work; details vary by language and configuration.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Previous: Service Decomposition](../06-service-decomposition/README.en.md) · [Next: Batching](../08-batching-and-round-trips/README.en.md)

**Related lessons:** [Connection reuse](../../10-network/02-connection-reuse/README.en.md) · [Message brokers](../../03-asynchronism/02-message-brokers/README.en.md) · [Throttling](../../08-security/03-throttling-and-rate-limiting/README.en.md)
