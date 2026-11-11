# Performance and Scalability

[فارسی](../../../../fa/system-design/01-foundations/02-performance-scalability/README.md)

## Learning goals

- Distinguish performance at the current workload from scalability as workload grows.
- Find the limiting resource in an end-to-end path.
- Compare vertical and horizontal scaling with their costs.
- Explain when caching, replication, partitioning, or queues can help and what they do not fix.

## Central idea

Performance describes the quality of a system under a particular load. Scalability describes how well it preserves that quality as load, data, or users grow. A service can be fast today and still fail to scale when its dataset or concurrency increases.

## Concept map

User-facing quality → workload shape → resource consumption → bottleneck and contention → scaling choice → measurement under representative load.

## Detailed lesson

### Define what “better” means

Performance includes request latency, completed throughput, CPU and memory use, storage and network I/O, cost per operation, and error rate. These measures can move in different directions. Batching may improve throughput but make each individual item wait longer. Before changing a design, define the SLI and its scope: which endpoint, payload size, cache-hit or miss path, request class, and percentile?

A benchmark with a tiny dataset and a warm cache may not resemble production. Record the baseline and use representative data, concurrency, and arrival patterns.

### Find the limiting resource

A request consumes several resources. Suppose an API makes four database queries per request, and the database can safely handle 2,000 such queries per second. The theoretical upper bound for this path is about 500 API requests per second. The real limit may be lower because the connection pool, locks, storage I/O, or another dependency saturates first.

Capacity planning also needs headroom. If a team reserves 30% for bursts and failover, a rough working ceiling might be around 350 requests per second. That percentage is only an example; load tests and failure tests should determine the actual margin.

A useful form of Amdahl’s law intuition is that optimizing a small fraction of the total time has a small effect on the whole. If the database accounts for 80% of request time and application CPU accounts for 20%, doubling application CPU efficiency cannot halve end-to-end latency. Fix the dominant part first, then measure again because the bottleneck may move.

### Vertical versus horizontal scaling

Vertical scaling gives one machine more CPU, memory, or I/O capacity. It is often easy to operate and may require little code change. Its drawbacks include a hardware or instance-size ceiling, potentially nonlinear cost, and a larger failure domain.

Horizontal scaling adds instances. It can increase throughput and provide redundancy, but it also raises questions about shared state, load distribution, coordination, and dependency capacity. API instances are easier to add when they are stateless: any healthy instance can handle a request, while durable state lives in a database or another shared service.

Horizontal scaling is not automatically linear. Two times as many API instances do not yield twice the throughput if they all wait for one database or lock.

### Analyze reads and writes separately

Suppose a service receives 1,000 requests per second and 85% are reads. If a cache actually serves 80% of those reads, database reads fall from 850 to about 170 per second. Adding 150 writes yields roughly 320 simple database operations rather than 1,000.

That estimate ignores query cost, invalidation, concurrent misses, and write amplification. A write-heavy workload may gain little from a cache; partitioning, batching, or a different data model might matter more. A cache also changes freshness behavior, so it needs a clear invalidation or expiry policy.

### Why scaling out can make things worse

More application instances often create more database connections. If every instance opens a pool of 100 connections, 20 replicas could try to maintain 2,000 connections. The database may run out of connection-management capacity before its CPU is fully used.

Network hops, coordination, locks, and cross-node data movement also cost time. A global lock can serialize otherwise parallel requests behind a hidden queue. Scaling one component raises end-to-end capacity only when that component is the bottleneck and its dependencies can support the added load.

### A practical performance investigation

1. Define a representative workload and capture a baseline.
2. Compare latency percentiles, throughput, error rate, and saturation across the path.
3. Follow a slow request with a trace and separate time spent in each dependency.
4. State one bottleneck hypothesis and make one bounded change.
5. Repeat the workload and compare user quality, cost, and failure behavior.

Do not infer a cause solely from high CPU or an average response time. Correlate symptoms across time, request classes, and dependencies.

## Worked example

An item-detail page is read-heavy, so caching stable catalog fields may reduce database load. The inventory value used to accept an order has a stronger correctness requirement: the checkout path must confirm it against the authoritative inventory workflow. The same data may therefore have different freshness requirements in the catalog display and order acceptance paths.

## Example capacity model

~~~text
Per-request database work: 4 queries
Database safe query rate: 2,000 queries/second
Theoretical request ceiling: 2,000 / 4 = 500 requests/second
Practical limit: lower, after connection, lock, I/O, and failover headroom
~~~

## Public engineering case study

[Uber: Modernizing artifact storage](https://www.uber.com/us/en/blog/modernizing-artifact-storage/) describes a storage-system evolution under real operational demands. Read it as a case study in workload, durability, and operational constraints rather than as a generic scaling recipe.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Vertical scaling | A small or legacy service needs a short-term capacity increase | Hard ceiling and concentrated failure domain |
| Horizontal scaling | Work can be distributed and state is shared or partitioned deliberately | Coordination, hot spots, and dependency overload |
| Caching | Reads repeat and bounded staleness is acceptable | Invalidation errors or stale business decisions |
| Queue-based workers | Work can finish later and arrival bursts should be decoupled from processing | Backlog growth, queue age, and delayed user outcomes |

## Common pitfalls

- Adding instances before measuring the bottleneck.
- Autoscaling without protecting the database or downstream API.
- Assuming averages reveal saturation or tail behavior.
- Caching every value without defining freshness or invalidation.
- Treating a hot key as if uniform load distribution will fix it.
- Forgetting that scale-in also interrupts work and connections.
- Calling theoretical maximum capacity the safe production capacity.

## Short quiz

1. What is the difference between performance and scalability?
2. Why might adding API replicas fail to increase write capacity?
3. Which measurements would you capture before introducing a cache?
4. When can a queue help with scalability, and what new problem does it create?

### Answer key

1. Performance describes quality at a given workload; scalability describes how quality changes as workload grows.
2. The database, a lock, a connection pool, or another serial dependency may remain the bottleneck.
3. Request rate and p95/p99, database query/lock time, CPU/I/O, cacheable read ratio, and the acceptable freshness window.
4. It can absorb bursts and let consumers process at a controlled rate when work need not complete inline. It introduces backlog, delivery, expiry, and recovery responsibilities.

## Exercise

For a store service, estimate a peak workload and draw its request path. Mark which component limits throughput, the authoritative data source, cache freshness, failure behavior, and key dashboard metrics. Propose one scaling change, then define a load test that could prove the change is ineffective or harmful.

## Summary

Measure the end-to-end workload, identify its current bottleneck, and scale the constrained part while protecting its dependencies. Vertical and horizontal scaling solve different constraints; caches and queues add their own correctness and operational requirements.

## Further reading

- [Azure Architecture Center: Design to scale out](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out) — bottlenecks, state, flow control, and workload decomposition.
- [Azure autoscaling guidance](https://learn.microsoft.com/en-us/azure/architecture/best-practices/auto-scaling) — startup, scale-in, dependency capacity, and load testing.
- [Google SRE: Capacity planning](https://sre.google/sre-book/software-engineering-in-sre/) — demand forecasting and capacity as an engineering problem.
- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/) — workload-specific latency, throughput, and percentile objectives.
- [Azure cloud application best practices](https://learn.microsoft.com/en-us/azure/architecture/best-practices/index-best-practices) — API, caching, partitioning, and transient-fault guidance.
- [Uber Engineering: Modernizing artifact storage](https://www.uber.com/us/en/blog/modernizing-artifact-storage/) — public real-world storage case study.
