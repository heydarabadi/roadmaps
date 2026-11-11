# Latency and Throughput

[فارسی](../../../../fa/system-design/01-foundations/03-latency-throughput/README.md)

## Learning goals

- Distinguish the time taken by one unit of work from the rate of completed work.
- Read latency percentiles without relying on averages alone.
- Apply Little’s Law to reason about concurrency and queue growth.
- Explain how batching and saturation affect response time.

## Central idea

Latency is the time a request or job takes to complete. Throughput is the number of jobs completed per unit of time. Improving one does not guarantee improvement in the other.

## Concept map

Arrival rate → work in flight → queue and service time → completion rate → latency distribution and user experience.

## Detailed lesson

### Separate the measurements

Suppose a worker completes 100 jobs per second. That is throughput. If one order takes 250 milliseconds from API receipt to response, its latency is 250 ms.

A system may have high throughput and poor latency because it has a large waiting queue even though workers are fast. A lightly loaded system may have low latency but low total throughput because it has little parallel capacity. Measure both, along with errors and resource saturation.

### Percentiles show the tail

p50 is the median: half of observations are faster. p95 means 95% finish within that time and 5% take longer. p99 describes an even slower tail. At one million requests, 1% still means 10,000 requests, so the tail can affect many users.

Always define the interval, endpoint, population, and method used to calculate a percentile. Percentiles from separate services cannot simply be added to calculate an end-to-end p99. A request that is unusually slow at multiple dependencies is not the same as the percentile of each dependency in isolation.

An average of 100 ms could represent 99 requests at 20 ms and one request at 8,020 ms. For checkout, examine the timeout rate, p95/p99, successful and failed request latency, and number of requests left in flight as well as the average.

### Relate arrival rate, residence time, and concurrency

Little’s Law states that in a stable system:

~~~text
L = λ × W

L = average work in the system
λ = arrival rate
W = average time spent in the system
~~~

At 200 requests per second and 0.3 seconds average residence time, about 60 requests are in flight. If average time grows to 2 seconds at the same arrival rate, around 400 requests are in the system. Those requests consume threads, memory, connections, and other resources.

Little’s Law does not guarantee stability. If arrivals remain above completions, work accumulates and there is no fixed average queue size. Monitor queue depth and the age of the oldest job; new requests can look quick even while older jobs are stuck.

### Understand the saturation point

At low load, workers have idle capacity and new work starts quickly. As arrival rate approaches service capacity, workers stay busy and bursts wait in a queue. If a service can complete 100 jobs per second and receives 98, it has little room for a traffic burst or a slower database query. Adding workers helps only if the next dependency also has room.

Queueing effects can cause latency to rise sharply near capacity. The system may appear healthy at average load and then degrade quickly during short peaks. A bounded queue, admission control, and load shedding can protect resources, but they change what clients observe and should be designed deliberately.

### Measure the whole request budget

The user experiences DNS, TLS, a mobile or internet network, gateway, queue, application, database, and external services. Distributed tracing can show time spent in each span.

Timeouts should fit within an overall deadline. If the full user request has a one-second budget, four sequential internal calls should not each be allowed to wait for a full second. Pass the remaining deadline downstream and reserve enough time to produce a response.

Track error latency too. A fast HTTP 500 is still a failed request; excluding failures can make the successful-request latency look better while users are seeing more errors.

### Batching changes the trade-off

Suppose sending one message has 5 ms of fixed overhead and processing each message costs 1 ms. Sending ten separately might cost about 60 ms of work, while a single batch might cost about 15 ms. But the first message has to wait while the batch fills.

Limit both batch size and maximum wait time. Consider ordering, partial failure, and retry behavior: a failed batch must not silently drop successful items or duplicate business effects.

## Worked example

A payment provider has a median response time of 120 ms but a p99 of four seconds. A client retries every slow request immediately. During a provider slowdown, many clients may send duplicate traffic at once, increasing load and delaying recovery. A safer design uses a deadline, a bounded retry policy with jitter where retry is valid, and an idempotent operation key or a reconciliation path.

## Capacity example

~~~text
Average service time per job: 20 ms
Independent workers: 10
Idealized service capacity: 10 / 0.020 = 500 jobs/second
Real capacity: lower after I/O wait, coordination, dependencies, and headroom
~~~

The estimate assumes work is parallelizable and the workers have independent capacity. It is a starting point for a load test, not a production promise.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Optimize for latency | Interactive user journeys need prompt responses | Low latency targets may require spare capacity and cost |
| Optimize for throughput | Batch or streaming workloads value completed volume | Large batches or queues may delay individual items |
| Add workers | Work is parallelizable and dependencies can accept the extra calls | More concurrency may overload shared storage |
| Buffer in a queue | Work can be deferred and backlog has a defined limit | Queue age can violate freshness or user expectations |

## Common pitfalls

- Optimizing average latency while p99 or timeout rate worsens.
- Retrying without an end-to-end deadline or idempotency.
- Allowing unbounded queues or concurrency.
- Increasing batch size without considering wait time or partial failure.
- Adding workers without checking downstream capacity.
- Combining percentiles from different populations as if they formed one end-to-end percentile.

## Short quiz

1. How do latency and throughput differ?
2. Why can p99 matter even if p50 is excellent?
3. What trade-off does a large batch introduce?
4. If incoming rate remains above completion rate, what happens to the queue?
5. Why should a timeout budget be shared across a request path?

### Answer key

1. Latency is the time for one job to complete; throughput is the number completed per time interval.
2. In a high-volume service, the slowest 1% can still affect many users, and long-tail waits consume resources.
3. Batching can reduce per-item overhead and raise throughput, but items wait for the batch and partial failures are harder to handle.
4. It keeps growing, raising latency and resource use until work is rejected, expires, or the service fails.
5. Independent per-call timeouts can exceed the time the client is willing to wait and leave abandoned work running.

## Exercise

Design latency and throughput objectives for two workloads: an interactive order-status endpoint and a nightly report. Pick the measurement population and interval, define the relevant percentiles or completion rate, and draw how you will trace a slow operation. Include one failure scenario caused by a retry or queue.

## Summary

Latency describes how long individual work takes; throughput describes how much work finishes over time. Percentiles, queue depth, deadlines, and dependency saturation explain the user experience more completely than averages alone.

## Further reading

- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/) — SLI definitions, percentiles, and separate objectives for different workload classes.
- [Google SRE: Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/) — latency distributions, traffic, errors, and saturation.
- [AWS Well-Architected: Distributed system interactions](https://wa.aws.amazon.com/wellarchitected/2020-07-02T19-33-23/wat.question.REL_5.en.html) — timeouts, retries, backoff, jitter, and limiting queues.
- [AWS Builders’ Library: Timeouts, retries, and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/) — practical retry and timeout design.
- [Azure: Design to scale out](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out) — throughput scaling, bottlenecks, and flow control.
- [Google SRE: Effective troubleshooting](https://sre.google/sre-book/effective-troubleshooting/) — correlating traffic, latency percentiles, and resource changes.
