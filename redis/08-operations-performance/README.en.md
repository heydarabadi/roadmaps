<div dir="ltr" align="left">

# Chapter 8 — Operations, Monitoring, and Performance

> Persian edition: [فصل ۸ — عملیات، پایش و کارایی](./README.md) · Suggested time: 4–6 hours.

Define “fast” with measurements. This chapter connects memory, latency, instrumentation, and safe configuration changes to an operational runbook.

## Lesson order

1. [Memory and eviction](./memory-eviction/README.en.md): `used_memory`, RSS, overhead, `maxmemory`, and policies.
2. [Latency and benchmarking](./latency-benchmark/README.en.md): RTT, pipelining, throughput, p95/p99, and load tests.
3. [Monitoring tools](./monitoring-tools/README.en.md): `INFO`, `SLOWLOG`, `LATENCY`, `MONITOR`, and visualization tools.
4. [redis.conf](./redis-conf/README.en.md): persistent versus runtime settings, rollout, validation, and rollback.

## Incident-investigation framework

When an API slows down, do not jump to one conclusion. Check the incident timeline, recent changes, command latency, network RTT, CPU/event loop, memory/evictions, replication lag, and application dependencies together. `SLOWLOG` records server-side command execution time; it does not necessarily show client/network waiting. Compare it with end-to-end application latency and client telemetry.

`MONITOR` can expose a huge volume of commands and possibly sensitive data. Use it briefly for a constrained investigation in a safe environment, not as a permanent dashboard. `INFO` provides snapshots; compare over time and do not confuse `used_memory` with RSS.

## Key signals

| Signal | Question it helps answer |
| --- | --- |
| p95/p99 command and client latency | When does the tail affect users, and where does it start? |
| memory used/RSS/maxmemory | How much data pressure or fragmentation exists? |
| evicted and expired keys | Is policy deleting data, or is its TTL ending? |
| rejected connections/connected clients | Is there connection pressure? |
| application cache hit ratio | Is the cache useful, or are misses overloading the database? |
| replication lag/offset | How far behind is a replica? |
| ops/sec and command mix | Which operation or service is causing load? |

For every alert, define an owner, threshold, duration, dashboard, and runbook. Alerting on one snapshot can create noise; consider trends and baselines.

## Practice incident

After a deploy, p99 latency rises and evictions increase. Match the timeline to the deployment; inspect `INFO memory`, `INFO stats`, `SLOWLOG GET`, and client metrics; look for large commands/scans, key-cardinality growth, and TTL distribution; inspect the `maxmemory` policy; then evaluate rollback impact and capacity. Do not simply raise `maxmemory`: the host also needs RSS and system-memory headroom.

## Readiness quiz

1. Why can pipelining reduce latency while increasing server work?
2. How does RSS differ from `used_memory`?
3. Why does a quiet SLOWLOG not prove that user latency is low?
4. Why should MONITOR not be left on continuously?

<details><summary>Answer guide</summary>

Pipelining reduces round trips but does not remove operations, response buffers, or burst load. RSS is process memory from the operating system's perspective and includes allocator/fragmentation/overhead. SLOWLOG measures server command time, not the complete client/network/queueing path. MONITOR is high volume and may reveal sensitive data or add overhead.

</details>

## Further reading

- [Redis benchmarking and optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/benchmarks/)
- [Redis latency troubleshooting](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/latency/)
- [Redis memory optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/)
- [GitLab's Redis latency investigation](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)
- [Redis observability guide](https://redis.io/docs/latest/operate/rs/monitoring/)
- [DNTips Redis overview in Persian (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

</div>
