<div dir="ltr" align="left">

# Throttling and Rate Limiting — A Fair-Use Budget

**Language:** [فارسی](../../../../fa/backend-performance/08-security/03-throttling-and-rate-limiting/README.md) | **English**

**Learning objective:** Separate request rate, bursts, and concurrency; choose a key and limiting cost that fit the threat; and reason about failures and retries. **Reference review: 2026-11-11.** Algorithms and numbers are illustrative and were not run.

## Definition and mental model

A rate limit determines how much use is accepted in a time interval. Throttling is broader and may reject work, slow it down, or place it in a bounded queue. One request might be a cheap search or an expensive export; counting requests alone does not always represent resource consumption. Rate limiting does not replace authentication, authorization, or network-level protection from volumetric attacks.

| Control | What it limits | What remains |
| --- | --- | --- |
| Rate and burst | Work entering over time | Duration of each job and active-job count |
| Concurrency cap | Active work | Arrival rate of very short jobs |
| Body/page/batch size | Size of one request | Number of requests |
| Deadline/timeout | Time resources stay occupied | Cost of starting work and retrying |
| Money/external-use budget | Paid SMS, API, or processing | Other internal resources |

[OWASP API4:2023](https://api-security.owasp.org/editions/2023/en/0xa4-unrestricted-resource-consumption/) considers size, time, resource use, and cost together. First identify the expensive endpoint and constrained resource; then design the key, rate, burst, and rejection behavior. An unverified identity must not create a fresh quota merely by changing a user-controlled header.

## Choosing an algorithm and understanding the trade-offs

| Algorithm | Property | Common cost or failure |
| --- | --- | --- |
| Fixed window | Simple counter for each interval | Bursts on both sides of a boundary |
| Sliding log/window | More precise view of a moving interval | More memory/compute, or more approximation |
| Token bucket | Bounded burst with a refill rate | Needs atomic updates and a reliable clock |
| Leaky bucket/bounded queue | Smooths outgoing work as designed | Wait time, queue capacity, and deadlines |

An IP is useful for an initial anonymous control, but NAT shares addresses and a distributed attacker spreads across them. Trust forwarded-IP headers only from a trusted proxy. After authentication, tenant, account, credential, and route can be better keys. Coarse edge limits, per-tenant quotas, and a global worker cap complement each other. An unbounded pool or queue does not rescue rejected work; it stores it until it consumes resources.

With several application replicas, a local limiter does not provide an exact global ceiling: per-instance limits add together. A shared service adds latency and operational dependency; its update must be atomic, and the chosen algorithm and synchronization must really provide that guarantee. Define behavior during failure. For an expensive export, temporary suspension or a conservative local budget may be appropriate; unlimited bypass is risky. A limited fail-open mode with an independent budget is a deliberate risk decision for selected paths, not a random failure behavior.

### Turn a requirement into an enforceable limit

1. **Name the protected resource:** CPU, database connection, worker, external-service cost, or a tenant’s fair share. A single counter does not control all of them.
2. **Choose a cost unit:** if a lookup is cheap and an export is expensive, counting each as one request misstates consumption. Weighted cost or a separate concurrency ceiling may help; choose weights through measurement and product policy.
3. **Separate sustained rate from burst:** `C` is the accepted burst capacity and `r` is the long-term refill rate. New tokens follow `tokens = min(C, old_tokens + r × elapsed_seconds)`. A request passes when it has enough tokens for its cost; state must not become negative.
4. **Choose the fairness boundary:** IP, account, credential, tenant, and route create different budgets. An edge control for anonymous traffic and an identity-based control for known callers complement each other; do not use a forgeable header as the final key.
5. **Design rejection, failure, and retry:** 429 and a wait hint, queue behavior, deadlines, retry caps, and store outages are part of the system’s contract. `Retry-After` does not reserve a future token; other callers may consume it first.

### Exact token-bucket calculation

Assume capacity `C=10`, refill `r=2 token/s`, and zero state immediately after a burst. At `t=0.5s`, one token has been created, so one one-unit request can pass. If it consumes that token, state returns to zero. At `t=1s`, one more token is created. If two requests arrive together, only one should take that token; the state read and decrement must be atomic. A “read, then write” sequence can accidentally allow both.

Second example: the bucket is full, eight one-unit requests are accepted, and 1.5 seconds pass. The new state is `min(10, 2 + 1.5×2) = 5`. A six-unit request is rejected and state stays at five, assuming rejection does not consume tokens. If your system uses different semantics, state them explicitly and keep them consistent under concurrency.

## Worked example — Token bucket

Assume bucket capacity is 10 units, refill is 2 units per second, and each search costs one unit. The bucket starts full. Ten concurrent requests consume the tokens; an eleventh is rejected. After half a second, one token arrives. An export may have a separate cost and concurrency limit; tune its cost model to actual consumption.

<div dir="ltr" align="left">

```text
key = (verified_tenant, verified_subject, route_group)
atomic_on_authoritative_store:
    now = trusted_monotonic_or_store_time()
    tokens = min(capacity, old_tokens + rate * max(0, now - old_time))
    if tokens >= request_cost:
        tokens = tokens - request_cost
        persist(tokens, now, bounded_expiry)
        allow
    else:
        persist(tokens, now, bounded_expiry)
        deny_with_bounded_retry_hint()
```

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 1
Content-Type: application/json
Cache-Control: no-store

{"error":"rate_limit_exceeded"}
```

</div>

The hint is a time to wait, not a reserved future token; other requests can consume available tokens. Define time units, state expiry, cost greater than capacity, and coordination among multiple limiters. State expiry must not happen before the bucket would naturally refill, or it can accidentally create free quota. In multiple limiter layers, consuming a token in one layer and being rejected in another needs defined semantics; an uncontrolled refund can corrupt the budget.

## Exercise and expected observation

Using the same bucket, simulate 12 requests at `t=0` and three at `t=1s`, with no other consumption. Expected: initially 10 pass and 2 are rejected; at the next second, 2 pass and 1 is rejected. Then analyze three independent replicas, each with its own full bucket of 10: as many as 30 requests can pass immediately. Finally, retry all 429 responses immediately. Why does this add incoming work without increasing refill capacity?

**Worked solution:** The initial burst empties the bucket. Two tokens are created by the next second, so two of the next three requests pass and one is rejected. With three independent replicas, each starts with 10 tokens; up to 30 requests pass immediately, so this is not a global limit. Immediate retries add network and limiter work and may delay valid traffic. Backoff and jitter spread the pressure but do not replace rate limiting.

## Public evidence and its limits

[Cloudflare’s Have I Been Pwned case study](https://www.cloudflare.com/case-studies/troy-hunt/) reports that Troy Hunt used IP-based request limiting to control traffic spikes, cost, and API abuse. This is a vendor case study containing a customer account; the reviewed page does not clearly state its publication date, and its historical description should not be treated as HIBP’s current configuration. It does not establish a guaranteed improvement or show that IP is sufficient for every API. The token-bucket scenario in this lesson is hypothetical.

## Failure modes, signals, and checklist

Non-atomic read-then-write, synchronized window resets, unbounded key cardinality, clock skew, and an unbounded queue are common failures. View 429 rate alongside valid-request goodput, latency, saturation, and external spend. Lower latency achieved only by rejecting legitimate users is not complete success. Clients should honor a valid `Retry-After` and use bounded backoff with jitter; cap both wait time and attempts. Paid or state-changing requests also need idempotency controls.

- [ ] Rate, burst, cost, and concurrency are separately defined for expensive routes.
- [ ] Keys use verified identity and a trusted-proxy boundary.
- [ ] Local/global guarantees, atomicity, time, and expiry are explicit.
- [ ] Queues, body/page/batch size, timeouts, and paid budgets have independent caps.
- [ ] Store failures have bounded, documented, observable behavior.
- [ ] 429, `Retry-After`, and retry budgets are coordinated between client and server.
- [ ] False rejections, fairness, goodput, and resource use are monitored together.

## Self-check

1. What is the difference between rate and concurrency?
2. Does a limit of 100 requests control the same cost for every route?
3. What global burst could three local limiters with capacity 10 permit?
4. Why is IP alone not enough as the final quota identity?
5. Does `Retry-After` reserve a future token for the client?
6. Why is a lower 429 count not, by itself, proof of better performance?

### Answer key with reasoning

1. Rate is the number of arrivals over time; concurrency is the number of active jobs. Long jobs can create high concurrency at a low rate.
2. No. One export may cost more than hundreds of lookups and may need a different budget.
3. Up to 30, if all three independent buckets start full; a local limit is not a shared global limit.
4. NAT, shared addresses, and distributed attackers make fairness and precision worse; use verified identity and multiple layers.
5. No. It is a wait hint, and other callers continue competing for tokens.
6. The control may be disabled or the store may have failed open; evaluate latency, goodput, and resources too.

## Optional references

- English: [OWASP API4:2023](https://api-security.owasp.org/editions/2023/en/0xa4-unrestricted-resource-consumption/) and [Denial of Service Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Denial_of_Service_Cheat_Sheet.html) — layered resource protections.
- English, case study: [Cloudflare/HIBP](https://www.cloudflare.com/case-studies/troy-hunt/) — public experience with the evidence limits described above.
- English: [MDN — 429 Too Many Requests](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/429) — status-code meaning and rate-limit use.
- English: [MDN — `Retry-After`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Retry-After) — wait-time formats and use with 429/503; clients vary in support.
- English: [NGINX `limit_req` module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) — key-based limits and reject/delay modes in one reverse proxy.
- Persian, official: [OWASP API4:2023 — Unrestricted Resource Consumption](https://api-security.owasp.org/editions/2023/fa/0xa4-unrestricted-resource-consumption/) — official Persian translation on resource use, batch operations, and external-service cost.
- Persian: [Designing a distributed rate limiter](https://learn.mhkarami97.ir/posts/design_rate_limiter/) — concepts and algorithms. The indexed text was reviewed, but direct access in the research tool was limited; claims of global precision depend on atomic implementation and failure behavior.
- Persian, additional: [OpenAI API 429 guide](https://help.openai.com/fa-ir/articles/5955604-troubleshooting-api-rate-limits-and-429-errors) — translated guidance on `Retry-After` and bounded client backoff for that service; it is not the quota configuration for this example.

[Chapter index](../README.en.md) · [Course index](../../README.en.md) · [Previous: Authentication and authorization](../02-authentication-and-authorization/README.en.md) · [Next: Security review](../04-security-review-and-updates/README.en.md) · [Timeouts and retries](../../06-code-optimization/07-timeouts-and-retries/README.en.md) · [Jobs and workers](../../03-asynchronism/01-background-jobs/README.en.md)

</div>
