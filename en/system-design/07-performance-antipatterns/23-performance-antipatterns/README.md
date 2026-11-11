# Performance Antipatterns

[فارسی](../../../../fa/system-design/07-performance-antipatterns/23-performance-antipatterns/README.md)

## Learning goals

- Recognize common performance antipatterns in data access, I/O, concurrency, and retries.
- Connect symptoms to traces, query plans, and resource saturation.
- Choose a targeted fix and measure effects on latency, errors, and cost.

## Central idea

Performance antipatterns often signal a poor choice about data, I/O, or concurrency. Find the cause in evidence such as traces and metrics instead of guessing from one graph.

## Concept map

User symptom → request trace and query plan → dominant cost → targeted correction → before/after measurements.

## Detailed lesson: ten common antipatterns

Do not diagnose an antipattern from one dashboard alone. For each, identify the symptom, cause, impact, and a measurement. Several causes can coexist: a small connection pool, slow queries, and unlimited retries can all raise latency.

### 1. Improper instantiation

Creating an expensive object, client, thread, or connection for every request can add allocation, garbage collection, handshakes, and contention. For example, constructing a new HTTP client on every call can prevent connection reuse.

Reuse immutable and thread-safe resources where appropriate. Match pool lifetime to resource lifecycle and shut pools down cleanly. An unbounded pool can exhaust resources by itself.

### 2. Monolithic persistence

One large database or schema for unrelated domains can create coupling, risky migrations, resource contention, and unclear ownership. But making a separate database for every table can break shared queries and transactions.

Start with module boundaries and clear data ownership. Split a datastore only when isolation, load, security, or independent lifecycle provides a concrete benefit.

### 3. Noisy neighbor

A tenant or job consumes CPU, I/O, connections, or cache capacity and raises latency for other users. Measure by tenant or workload using labels with controlled cardinality. Consider quotas, concurrency caps, priority, or separate pools.

Full isolation costs more; low-risk tenants may share resources if fair-use limits are defined.

### 4. Synchronous I/O

A thread waiting for network or disk work remains occupied while making no progress. Async I/O can release the thread, but if a dependency stays slow, queued tasks can still grow.

Combine async I/O with bounded concurrency, deadlines, backpressure, and cancellation. Converting everything to async without a capacity limit is not a fix.

### 5. Extraneous fetching

The application reads more data than needed or fetches the same data repeatedly. N+1 queries, huge payloads, excessive fields, and unlimited pagination are examples.

Align query shape and endpoint response with the actual page or operation. Batching, projections, cursor pagination, and caching can help in the right place. “Fetch everything in case we need it” wastes memory and network.

### 6. Busy database

Expensive queries, too many indexes, lock contention, excess connections, or write bursts overload the database. Examine query plans, slow-query logs, lock waits, buffer/cache behavior, I/O, and pool utilization.

Improve queries and indexes, shorten transactions, or consider read replicas or partitioning when measurements support them. A replica does not reduce primary write work and cannot rescue an inefficient query by itself.

### 7. Busy frontend

Large assets and expensive browser computation slow loading and rendering, especially on low-powered devices. Examine bundle size, long tasks, Core Web Vitals, lazy loading, code splitting, image size, and hydration work.

Reducing JavaScript must not break accessibility or offline behavior the product requires.

### 8. Chatty I/O

Many small round trips to a service or database add network latency repeatedly. N+1 service calls create the same problem across microservices.

Consider a batch API, bulk operation, or combined query. Compare payload size and atomicity; an oversized batch can create memory pressure, timeout, and expensive retries.

### 9. Retry storm

After an outage, many clients retry together and overwhelm the recovering service. Retry only transient errors, bound attempts, use exponential backoff and jitter, and enforce a deadline and retry budget. Choose one layer to own retries.

Circuit breakers, rate limits, and load shedding can help. Check for hidden retry behavior in SDKs and load balancers.

### 10. No caching

Frequently read, stable, low-sensitivity data is fetched from an expensive source on every request. A cache may lower latency and load, but invalidation, TTL, privacy, and stale behavior need a policy.

For private or critical data, a shared cache may be unsafe. Sometimes an index or better query is more effective than introducing a cache.

## Troubleshooting workflow

1. Narrow the issue by endpoint, tenant, payload, and percentile.
2. Use traces and query plans to find the dominant part of the path.
3. Write a falsifiable hypothesis, such as “N+1 queries account for 80% of request time.”
4. Apply the smallest change that can test that hypothesis.
5. Compare latency, errors, cost, and correctness; define a rollback condition.

## Worked example

An order-detail page issues one query per line item. A hundred items can create many database round trips. Test a bounded page size and batched query, then compare database time, response size, and p95 latency.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Batch requests | Round-trip overhead dominates and the combined work is bounded | Large payload, timeout, and partial failure |
| Pool a resource | Setup cost is high and safe reuse is supported | Leaked or unbounded pools exhaust capacity |
| Cache a read | Values repeat and freshness is explicit | Stale or cross-tenant data |
| Split noisy workloads | One tenant or job harms others measurably | Isolation costs and idle capacity |

## Common pitfalls

- Adding a cache before fixing a wasteful query.
- Using an unbounded connection pool.
- Retrying every slow request.
- Optimizing the average while tail latency worsens.
- Treating all frontend delay as backend latency.
- Assuming one symptom has one cause.

## Short quiz

1. Which antipattern commonly causes N+1 database calls?
2. How can a retry storm form?
3. What controls can reduce noisy-neighbor impact?
4. Why is async I/O alone not enough?

### Answer key

1. Extraneous fetching or chatty I/O.
2. Many clients observe a failure and retry together, adding load while the dependency is already unhealthy.
3. Rate limits, concurrency quotas, fair scheduling, or separate pools by workload/tenant.
4. Tasks can still queue without bound if the dependency is slow; concurrency, deadlines, and backpressure are needed.

## Exercise

Trace a slow store request and identify which of the ten antipatterns may apply. Record evidence, choose one change, define a representative load, and compare p50/p95/p99, error rate, database load, and cost.

## Summary

Antipatterns are hypotheses, not fixes. Use traces and resource measurements to isolate the cause, then test a bounded change against the same workload.

## Further reading

- [Microsoft Azure: Performance antipatterns](https://learn.microsoft.com/en-us/azure/architecture/antipatterns/) — common performance defects in cloud applications.
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/) — latency tails, traffic, and saturation.
- [Azure: Design to scale out](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out) — bottlenecks, coordination, and flow control.
- [AWS Builders’ Library](https://aws.amazon.com/builders-library/) — operational performance and reliability articles.
- [Google SRE: Effective Troubleshooting](https://sre.google/sre-book/effective-troubleshooting/) — forming hypotheses from time-correlated signals.
