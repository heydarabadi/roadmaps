<div dir="ltr" align="left">

# Redis Latency, Pipelining, and Benchmarking

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 8, operations and performance · Level: intermediate · Time: 70–110 minutes
>
> Run benchmarks on disposable Redis or dedicated staging. Load testing a shared server can disrupt other services.

## Learning objectives

- Separate one command's server time, a network round trip, and a complete application-request latency.
- Use pipelining to reduce RTT while understanding its batch-size and atomicity limits.
- Compare `redis-benchmark`, `redis-cli --latency`, and tests using a real workload.
- Interpret p50/p95/p99, throughput, concurrency, and saturation.
- Write a reproducible, comparable benchmark report.

## Where latency is spent

```text
Application -> pool/serialize -> network RTT -> Redis queue/command -> network -> parse -> app logic
```

A fast server-side command does not guarantee a low end-to-end request time. Pool exhaustion, DNS/TLS, RTT, packet loss, server queueing, slow commands, CPU, persistence/eviction, and client serialization all matter. Average latency can hide a long tail; p95 and p99 better show what some users experience.

## 1. Pipelining and round trips

If a client sends 100 commands one at a time, it makes a round trip for each one. A pipeline sends several commands in sequence and then receives their replies, reducing RTT cost per command. Redis still executes the commands, and the client buffers replies.

```text
SET lab:pipeline:a 1
INCR lab:pipeline:a
GET lab:pipeline:a
```

Send these three with a pipeline in a client library; each line typed separately in `redis-cli` is a separate round trip. A pipeline is **not atomic**. Other clients may run between its commands. If command semantics need to be atomic, consider a command such as `INCR`/`MGET`, or a transaction/script.

### Batch size

- **Small batch:** Less RTT savings, less memory, and easier tail-latency control.
- **Large batch:** May improve throughput up to a point, but replies consume buffers, memory/CPU rise, and one request may wait longer for the batch.
- Instead of an unlimited pipeline, set batch size, maximum outstanding bytes, timeout, and backpressure.

## 2. Benchmark tools and limits

On a local environment, check the flags supported by your installed version:

```text
redis-benchmark -t set,get -n 100000 -c 50 -P 16 --csv
redis-cli --latency
```

`-t` selects command tests, `-n` the number of requests, `-c` concurrency, and `-P` the number of pipelined requests in the benchmark client. Check `redis-benchmark --help` for exact flags in your version. This is synthetic: key/value sizes, hit ratio, TLS, persistence, eviction, data type, geographic RTT, and the production client may not be represented.

A better benchmark process:

1. Record a baseline with the same Redis version, CPU/memory, network/TLS, and configuration.
2. Model read/write mix, payload bytes, key distribution/hot keys, TTL, and data types.
3. Start with low concurrency and increase it step by step.
4. Record throughput (ops/s) against p50/p95/p99 latency.
5. Collect CPU, memory/RSS, evictions, persistence, replication lag, and network too.
6. Change one factor at a time and repeat runs.
7. Reduce/stop load and check the lab data and service health.

Maximum ops/s alone is not a useful target. The goal is latency within the SLO on the real workload.

## 3. End-to-end measurement

`redis-cli --latency` samples the client/server path, but it is not a complete application metric. Add histograms in the application for:

- Time spent acquiring a connection from the pool.
- Redis request/response duration.
- Command name/operation class, not payload or secret.
- Timeout, error, and retry count.
- Total endpoint/business-operation duration.

SLOWLOG records server-side command execution time; it does not include network RTT, client queueing, or connection-pool wait. An empty SLOWLOG does not prove an endpoint is fast. Conversely, a slow end-to-end request with a low SLOWLOG time may point to network/client trouble.

## Published case: GitLab and eviction-driven latency

In a technical GitLab article, one-second Redis latency bursts correlated with reaching `maxmemory` and bursts of eviction. The team used BPF to investigate the behavior and found that many small evictions and a feedback loop hurt throughput. This was not a `redis-benchmark` result; it is a production example of why you need to inspect the system under load, eviction, tail latency, and queueing. [GitLab engineering investigation with BPF](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/)

## Step-by-step troubleshooting

1. Confirm whether the bottleneck is Redis, the pool, the network, or the application.
2. Compare p95/p99 with SLOWLOG and `LATENCY` results.
3. Inspect `INFO stats`, `INFO memory`, `INFO persistence`, and `INFO replication` over the same incident window.
4. Check command complexity and collection size for big keys/results.
5. Inspect concurrency, retry storms, and head-of-line blocking.
6. Test a change on a fixed workload; do not trade latency improvement for unmeasured error or durability cost.

## Exercises

1. Run two lab benchmarks with `-P 1` and `-P 16`. Compare latency and throughput.
2. Compare average with p95/p99. How many users experience the tail?
3. Test small/large payloads and concurrency in a lab.
4. Write a report with environment, commands, version, configuration, throughput, p50/p95/p99, CPU/RSS, eviction, and a bounded conclusion.

**Answer criteria:** Report more than ops/s: include settings, percentiles, operation mix, resources, and a reproducible environment.

## Common pitfalls

- **Using a laptop result as production capacity:** Hardware, network, TLS, payload, and concurrency differ.
- **Looking only at average:** Tail latency and error rate may still be unacceptable.
- **Assuming a pipeline is atomic:** It only reduces round trips.
- **Making the pipeline too large:** Buffers and tail latency may worsen.
- **Benchmarking at peak:** It interferes with service and contaminates results.
- **Changing several settings at once:** You cannot identify what caused improvement/regression.
- **Reading SLOWLOG as end-to-end latency:** It excludes network/client/application time.

## Quiz with answers

### 1. What does pipelining usually reduce?

<details><summary>Answer</summary>

The number of network round trips per command batch.

</details>

### 2. Is a pipeline atomic?

<details><summary>Answer</summary>

No. Another client's commands may run between them.

</details>

### 3. Why measure p95/p99?

<details><summary>Answer</summary>

They reveal tail latency that the average can hide.

</details>

### 4. Does high ops/s prove production readiness?

<details><summary>Answer</summary>

No. Workload, errors, latency targets, resources, failure behavior, and deployment must be representative.

</details>

### 5. What does SLOWLOG not measure?

<details><summary>Answer</summary>

Network RTT, client-pool wait, and total endpoint duration.

</details>

### 6. Why read the GitLab article?

<details><summary>Answer</summary>

It is a real case where eviction bursts and latency correlated under production load; it is not a benchmark number to copy.

</details>

## References and further reading

### English: official documentation and case study

- [Redis pipelining guide](https://redis.io/docs/latest/develop/using-commands/pipelining/) — reducing round trips and managing pipeline behavior.
- [Redis benchmark guide](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/benchmarks/) — `redis-benchmark` and repeated runs.
- [Diagnosing Redis latency](https://redis.io/docs/latest/management/optimization/latency/) — latency sources and measurement.
- [Redis latency monitoring subsystem](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/latency-monitor/) — server-side latency events.
- [INFO command reference](https://redis.io/docs/latest/commands/info/) and [SLOWLOG command reference](https://redis.io/docs/latest/commands/slowlog/) — observe workload and slow server commands.
- [GitLab: Redis latency spikes diagnosed with BPF](https://about.gitlab.com/blog/how-we-diagnosed-and-resolved-redis-latency-spikes/) — production incident investigation.
- [Redis troubleshooting pocket guide](https://redis.io/faq/doc/2c2rhstokc/redis-troubleshooting-pocket-guide) — diagnostic entry points.

### فارسی

- [ویدئوی فارسی Pipeline و Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Persian material on reproducible Redis benchmarking is limited. The lab and report criteria are included here. Record tool version and configuration with your results.

</div>

