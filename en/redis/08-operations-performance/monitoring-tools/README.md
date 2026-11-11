<div dir="ltr" align="left">

# Monitoring Redis: INFO, SLOWLOG, LATENCY, and Tools

> Persian edition: [Read this lesson in Persian](../../../../fa/redis/08-operations-performance/monitoring-tools/README.md)

> Path: Chapter 8 · Level: intermediate · Time: 70–100 minutes
>
> `MONITOR`, `CLIENT LIST`, and command output may contain sensitive payloads/secrets. Use them briefly and with limited access.

## Learning objectives

- Inspect memory, operations, persistence, replication, and keyspace with `INFO`.
- Distinguish server command time from end-to-end latency.
- Choose `SLOWLOG`, `LATENCY`, `CLIENT LIST`, and `redis-cli --stat` for the right question.
- Design low-risk production metrics, alerts, and dashboards.
- Understand that Redis Insight is an inspection tool, not an observability system or security policy.

## Observability model

```text
Application SLI       Redis server metrics          Infrastructure
request p95/error  +  latency/ops/memory/eviction + CPU/RAM/network/disk
             \                |                 /
              -> time-correlated incident view <-
```

Start with the incident question: “Is the user slow?”, “Is the Redis command slow?”, “Is the connection pool exhausted?”, “Is eviction happening?”, or “Is a replica behind?” Each question calls for a different tool.

## 1. `INFO` and key metrics

```text
INFO server
INFO clients
INFO memory
INFO stats
INFO persistence
INFO replication
INFO keyspace
```

| Metric/section | What it shows | Operational question |
| --- | --- | --- |
| `connected_clients`, `blocked_clients` | Connections and blocking commands | Is the pool too large or a worker stuck? |
| `used_memory`, `used_memory_rss`, fragmentation | Redis/process memory | Is headroom and fragmentation acceptable? |
| `keyspace_hits`, `keyspace_misses` | Successful/unsuccessful lookups | Is cache hit rate falling? |
| `evicted_keys`, `expired_keys` | Key removals | What is the effect of `maxmemory` or TTL? |
| `instantaneous_ops_per_sec`, `total_commands_processed` | Command load | Has traffic peaked? |
| `rejected_connections`, error counters | Some connection failures | Is a limit or resource causing errors? |
| `aof_last_write_status`, `rdb_last_bgsave_status` | Persistence status | Did the last save/write succeed? |
| Replication offsets/link | Replica lag | Is stale read/full sync a risk? |
| Per-database keyspace | Key and expiry counts | Has growth/distribution changed? |

Field names may change by version. Trend the metrics: one snapshot says less about risk than growth rate and latency correlation.

## 2. Latency and SLOWLOG

```text
SLOWLOG LEN
SLOWLOG GET 10
LATENCY LATEST
LATENCY DOCTOR
```

SLOWLOG records server-side command execution time, not network round trip, client-pool wait, or application time. The threshold and log length are configurable; some outputs include command arguments/payloads. Restrict access and retention accordingly.

The latency monitor records specific event types when its threshold is enabled. `LATENCY DOCTOR` offers an initial explanation, not a definitive root cause. `redis-cli --latency` is useful for simple client/server sampling; compare it with application endpoint histograms.

## 3. Tools and risks

- **`MONITOR`:** Shows the live command stream. It has significant overhead and may reveal payloads. Use only briefly, in a lab/staging or with explicit authorization, and stop immediately afterward.
- **`CLIENT LIST`:** Helps find blocked/idle clients; addresses, names, and command metadata may be sensitive.
- **`redis-cli --stat`:** Displays a compact text summary for quick observation.
- **`redis-cli --bigkeys`:** Walks the keyspace and samples large keys. Consider scan cost, duplicate semantics, and load on a busy production server.
- **Redis Insight:** Provides GUI data exploration, command execution, profiling/metrics depending on version. Limit admin access and secure remote browser access.
- **Prometheus exporter/managed monitoring:** Ingests metrics; control label cardinality, credentials, TLS, and scrape rate.

## 4. Alert design

Alert on symptoms and trends rather than one absolute number that may change with workload:

- Application p95/p99, timeouts/errors, connection-pool wait.
- Redis latency spikes and SLOWLOG events.
- Memory vs `maxmemory`, RSS/host headroom, eviction rate, hit ratio.
- AOF/RDB failures, free disk, persistence rewrite/child status.
- Replica lag/link and full-sync count.
- Stream-group lag, oldest PEL idle time, pending count (if Streams are used).
- Connected-client count, rejected connections, blocked clients.

Every alert needs a runbook: which read-only command to start with, which team owns it, and which actions are high risk. The metric exporter should not collect secrets or keyspace values.

## Published experience: from correlation to root cause

GitLab published an investigation in which BPF and internal eviction analysis showed that a memory cap/eviction bursts correlated with very slow requests in Redis. The lesson is that `INFO` is only one part of the puzzle; correlate application p99, memory, eviction, CPU, and system-level evidence over time. [GitLab engineering write-up](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

## Slow-request diagnostic runbook

1. Record the incident time/impact, endpoint, Redis endpoint, and version.
2. Separate application pool wait, Redis request duration, and total endpoint duration.
3. Collect `INFO clients/stats/memory/persistence/replication` for the same period.
4. Read SLOWLOG/LATENCY. If empty, do not assume network/client-pool causes are ruled out.
5. Correlate `evicted_keys`, `keyspace_hits/misses`, CPU, disk, fork, and replica sync.
6. Do not use `MONITOR` first. If needed, run it only briefly and with authorization.
7. Make one small change and compare against the before state.

## Troubleshooting

- **SLOWLOG is empty but the API is slow:** Check pool, TLS, network RTT, client serialization, DNS, and retries.
- **Hit ratio falls:** Inspect TTL, eviction, cache-key versioning, and deploy behavior.
- **RSS is high but `used_memory` is steady:** Inspect fragmentation, buffers, child fork, and OS page/allocator use.
- **Replica lag grows:** Check network, full sync, disk, write bursts, and backlog.
- **MONITOR makes everything slower:** Stop it immediately and use lower-overhead metrics/SLOWLOG.
- **Grafana has too many series:** Do not label by high-cardinality key/user/payload.

## Exercises

1. Collect `INFO` memory/stats/keyspace sections in a lab and explain five fields.
2. Inspect SLOWLOG and identify what it does not measure.
3. Design a cache dashboard: hits/misses/evictions + application p95 + database load.
4. Write a `MONITOR` policy with duration, approval role, redaction, and stop condition.

**Answer criteria:** Include application, Redis, and host metrics; latency percentiles; alert action/runbook; and payload protection.

## Quiz with answers

### 1. What time does SLOWLOG record?

<details><summary>Answer</summary>

Server-side execution time for commands above the threshold, not total application latency.

</details>

### 2. Does an empty SLOWLOG rule out a network problem?

<details><summary>Answer</summary>

No. SLOWLOG does not measure network or client queueing.

</details>

### 3. Why is `MONITOR` risky?

<details><summary>Answer</summary>

It adds overhead and may expose command arguments/payloads.

</details>

### 4. Which metrics should be compared with hit ratio?

<details><summary>Answer</summary>

Evictions/expiration, application cache hits, downstream DB QPS, and latency.

</details>

### 5. How should you use `INFO`?

<details><summary>Answer</summary>

Collect selected sections and trend/correlate them; do not claim a root cause from one snapshot.

</details>

### 6. Does Redis Insight replace production alerting?

<details><summary>Answer</summary>

No. It is an inspection/management tool; metrics, alerts, and runbooks are still required.

</details>

## References and further reading

### English: official documentation and incident case

- [INFO command reference](https://redis.io/docs/latest/commands/info/) — server, memory, stats, persistence, replication, and keyspace sections.
- [SLOWLOG command reference](https://redis.io/docs/latest/commands/slowlog/) and [SLOWLOG GET](https://redis.io/docs/latest/commands/slowlog-get/) — inspect slow server-side commands.
- [Redis latency monitoring](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/latency-monitor/) — event-based latency data.
- [Diagnosing Redis latency](https://redis.io/docs/latest/management/optimization/latency/) — distinguish latency sources.
- [Redis Insight documentation](https://redis.io/docs/latest/develop/connect/insight/) — GUI inspection and slow-log tools.
- [Redis observability playbook](https://redis.io/tutorials/redis-software-observability-playbook/) — monitoring guidance.
- [GitLab Redis latency investigation](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/) — production correlation and BPF diagnosis.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ابزارها و ساختار Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی فارسی Redis Insight و مانیتورینگ](https://www.google.com/search?q=Redis+Insight+مانیتورینگ+آموزش+فارسی)

Persian monitoring coverage is limited. This page explains the runbook and metric map directly. Set alert thresholds using your workload baseline and SLO.

</div>

