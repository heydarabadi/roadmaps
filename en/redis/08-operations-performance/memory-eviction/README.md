<div dir="ltr" align="left">

# RAM, `maxmemory`, and Eviction Policies

> Persian edition: [Read this lesson in Persian](../../../../fa/redis/08-operations-performance/memory-eviction/README.md)

> Path: Chapter 8 · Level: intermediate · Time: 70–100 minutes
>
> Test `CONFIG SET` or eviction policies only on disposable Redis. Evicting an in-memory key can destroy data that cannot be recovered.

## Learning objectives

- Distinguish dataset memory from total process RSS and host memory.
- Choose `maxmemory`, policy, and sampling with the data model in mind.
- Monitor `evicted_keys`, hits/misses, and fragmentation together.
- Include cold cache, stampede, background saves, and replication buffers in capacity planning.
- Decide when eviction is useful for a cache and when it is dangerous for primary state.

## The central idea

Redis stores much of its data in RAM, but memory is not only members and values. Key/object metadata, allocator fragmentation, client buffers, replication/AOF buffers, fork copy-on-write, and the OS page cache also matter. `maxmemory` controls eviction behavior; do not set it equal to all RAM on the machine.

```text
Host RAM budget
├── Redis dataset + internal overhead
├── client/replication/persistence buffers
├── fork/copy-on-write headroom
└── OS + sidecars + safety reserve
```

## 1. Measure memory

```text
INFO memory
INFO stats
MEMORY STATS
MEMORY DOCTOR
MEMORY USAGE cache:product:501
```

Inspect `used_memory`, `used_memory_rss`, the peak, fragmentation, and `maxmemory`. `used_memory_rss` describes resident process RAM; `used_memory` describes Redis allocations. High fragmentation is not automatically a leak, but RSS growing out of proportion to dataset needs investigation. `MEMORY USAGE` estimates the cost of one key; multiply representative samples by expected key count and validate against observed data.

Before choosing `maxmemory`, include value serialization cost, Hash field counts, cache TTLs, growth rate, replica/AOF buffers, and save-time peaks in capacity planning.

## 2. Eviction policies

| Policy | Candidate set | Behavior |
| --- | --- | --- |
| `noeviction` | No keys are automatically deleted | Writes that need more memory return an error |
| `allkeys-lru` | Every key | Approximate least-recently-used eviction |
| `allkeys-lfu` | Every key | Approximate least-frequently-used eviction |
| `allkeys-random` | Every key | Random selection |
| `volatile-lru` | Keys with TTL | Approximate LRU among expiring keys |
| `volatile-lfu` | Keys with TTL | Approximate LFU among expiring keys |
| `volatile-random` | Keys with TTL | Random selection from that subset |
| `volatile-ttl` | Keys with TTL | Prefer the key with the shortest TTL |

Check policy names and details against your version. Redis LRU/LFU does not retain an exact access history; its sampling/algorithm is approximate. If a `volatile-*` policy has no eligible expiring key, it can behave like `noeviction` for a write that needs memory.

### Quick selection guide

- **Pure cache, TTL optional:** Compare `allkeys-lru` and `allkeys-lfu` under a representative workload.
- **Every key expires, but persistent state shares the database:** `volatile-*` may fit, though separating data domains can make the policy clearer.
- **Primary state or queue that must not be evicted:** Do not permit automatic deletion in that keyspace. Plan capacity/partitioning and `noeviction` error handling.

If a cache and durable queue share one Redis instance, eviction against the same keyspace may delete important messages or state. Separate workloads or make the eviction boundary explicit.

## 3. What happens at `maxmemory`

When a write would exceed the limit, Redis applies the selected policy to free memory. Under `noeviction`, writes that require additional memory fail, while reads continue. The application must handle this error. Alert on errors such as `OOM command not allowed...`.

```text
CONFIG GET maxmemory
CONFIG GET maxmemory-policy
INFO stats
```

`evicted_keys` counts eviction activity. Compare the hit ratio over time with application hits/misses. A high eviction rate can reduce hits and overload the database behind the cache. Change the policy sample size only after measurement: greater precision can change CPU use and latency pressure.

## 4. Published case: eviction bursts at GitLab

GitLab's production Redis analysis showed that when the cache reached `maxmemory`, evictions happened in bursts alongside very slow requests. The article explains how many individually small operations, rather than one large command, reduced throughput. The practical lesson is that choosing a policy is only the start: monitor memory growth, hits/misses, eviction rate, p95/p99, and database load behind the cache together. [GitLab: Diagnosing Redis latency spikes with BPF](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

## 5. Cache misses and stampedes

If many keys expire at once, concurrent requests can all hit the database. Eviction also reduces cache hits and may intensify this burst. Consider:

- TTL jitter to spread expirations.
- Bounded single-flight/locking for a hot key, with timeout and fencing/idempotency.
- Stale-while-revalidate or soft/hard TTL when the product permits it.
- Rate limiting/circuit breakers and concurrency limits for the origin database.
- Controlled warm-up and cache-miss observability.

A simple lock does not replace source-of-truth correctness. An unbounded fallback can turn a Redis outage into a database outage.

## 6. Lab and pitfalls

In a lab with synthetic data, use a separate container to set a low `maxmemory` and observe the policy. See when `evicted_keys` grows or when `noeviction` returns an error. Then restore the original setting. This lesson does not recommend changing a real Redis policy with these commands.

- **`maxmemory` equals host RAM:** There is no headroom for OS, fork, sidecars, or buffers.
- **Eviction is confused with expiration:** TTL defines an expiration time; eviction can remove a key earlier.
- **`noeviction` is considered “risk-free”:** Writes fail and the application must handle them.
- **Fragmentation is called a leak:** Analyze the trend, allocator, RSS, and workload.
- **Only `used_memory` is checked:** Include RSS and background-operation peaks.
- **LFU/LRU are assumed exact:** They use an approximate algorithm and sampling.
- **A cache outage is treated as harmless:** Database rate limits, circuit breakers, and recovery-load controls may be required.

## Exercises with answer guide

1. Choose separate policies for a rebuildable cache, a queue, and sessions.
2. If `evicted_keys` rises while hit ratio falls, which measurements do you check next?
3. Why can `volatile-lru` be dangerous when important keys have no TTL?
4. Write a hypothetical postmortem: a cold cache after failover fills the database connection pool. Which safeguards were needed?

**Answer guide:** Separate workloads. Compare memory growth, RSS, free RAM, fork, key sizes, access distribution, origin traffic, and error rate. A volatile policy only evicts TTL keys; if its candidate set is empty or the wrong keys have TTLs, writes can fail or the wrong state can be lost.

## Quiz with answers

### 1. What does `allkeys-lru` consider?

<details><summary>Answer</summary>

Every key can be a candidate; recent use is estimated with approximate LRU.

</details>

### 2. How does `volatile-lru` differ?

<details><summary>Answer</summary>

Only keys with a TTL are candidates.

</details>

### 3. What does `noeviction` do?

<details><summary>Answer</summary>

It does not delete keys; a write that requires more RAM may be rejected.

</details>

### 4. Why should `maxmemory` not equal all RAM?

<details><summary>Answer</summary>

The process/OS, buffers, fork, and other services also need memory.

</details>

### 5. Can eviction increase latency beyond the eviction work itself?

<details><summary>Answer</summary>

Yes. Eviction costs work and lowers cache hits; the origin database may see a burst and tail latency may worsen.

</details>

### 6. What is the practical lesson from the GitLab case?

<details><summary>Answer</summary>

Correlate memory threshold and eviction bursts with latency and downstream load; do not infer safety from one `maxmemory` number.

</details>

## References and further reading

### English: official documentation and case study

- [Redis key eviction guide](https://redis.io/docs/latest/develop/reference/eviction/) — `maxmemory` and policy behavior.
- [Redis memory optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/) — memory use and capacity.
- [INFO command reference](https://redis.io/docs/latest/commands/info/) and [MEMORY USAGE](https://redis.io/docs/latest/commands/memory-usage/) — inspect memory.
- [Redis cache-aside use case](https://redis.io/docs/latest/develop/use-cases/cache-aside/) — cache architecture and origin behavior.
- [Redis OOM error guide](https://redis.io/docs/latest/develop/reference/errors/common/oom/) — understand write failures.
- [GitLab Redis latency and eviction investigation](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/) — production observations and diagnosis.

### فارسی

- [مرور فارسی memory و ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [آموزش Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی دربارهٔ Redis eviction و maxmemory](https://www.google.com/search?q=Redis+maxmemory+eviction+آموزش+فارسی)

Technical Persian sources on eviction are limited. This lesson covers policy trade-offs for an initial choice. Size production capacity with a representative load, the target version, and your provider.

</div>

