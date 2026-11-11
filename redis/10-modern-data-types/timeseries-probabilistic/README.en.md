<div dir="ltr" align="left">

# Redis Time Series and Probabilistic Data Structures

> Path: Chapter 10 · Modern data structures · Level: intermediate · Study and practice: 90–140 minutes
>
> This lesson covers two different families: Time Series stores timestamped measurements; probabilistic structures keep compact, approximate summaries. Do not treat an estimate as an exact record.

> Persian edition: [Time Series و ساختارهای احتمالی](README.md)

## Prerequisites and objectives

You should know Redis keys, TTL, core data types, SCAN, and basic memory concepts. After this lesson, you should be able to:

- Insert timestamped measurements and query a time range.
- Design retention, labels, duplicate policy, and downsampling for a workload.
- Choose among Bloom/Cuckoo filters, Count-Min Sketch, Top-K, and t-digest based on the question being asked.
- Identify decisions that must not depend on approximate data alone.
- Run and interpret representative command examples and diagnose common mistakes.

## Part A — Time Series

### 1. Model and timestamp

A time series is a sequence of pairs: time and value, such as (2026-11-11 10:00 UTC, 23.4 °C). Redis Time Series provides commands to add samples, read a range, select series using labels, and aggregate samples into time buckets.

Command timestamps are integer milliseconds since the Unix epoch; an asterisk means the server’s current time. A key usually represents one measurement series. Labels such as site=tehran, sensor=temperature, and unit=celsius help query groups of series.

Time Series began as a module capability. It is integrated into Redis Open Source 8; older installations may require RedisTimeSeries or Redis Stack. “The command exists in a tutorial” does not prove that your deployed endpoint supports it. Check the exact server and service.

### 2. Create, add, and read samples

The following uses the server clock so it can be run without calculating epoch values:

~~~text
DEL lab:ts:temp:1 lab:ts:temp:2 lab:ts:temp:1m
TS.CREATE lab:ts:temp:1 RETENTION 86400000 DUPLICATE_POLICY LAST LABELS site tehran sensor temperature unit celsius
TS.ADD lab:ts:temp:1 * 23.4
TS.ADD lab:ts:temp:1 * 23.8
TS.RANGE lab:ts:temp:1 - +
TS.INFO lab:ts:temp:1
~~~

RETENTION 86400000 means samples older than one day relative to the most recent timestamp are eligible for removal. Retention is not a backup: it intentionally limits how much historical data remains available. Measure the desired time horizon and memory cost before selecting it.

Two writes with the same timestamp are duplicates. A duplicate policy can reject a duplicate or choose/aggregate a value according to the configured rule. LAST may be appropriate for a repeated delivery of the same measurement; it might hide a real disagreement if separate devices incorrectly share a timestamp. Define the event semantics before choosing the policy.

Use TS.RANGE or TS.REVRANGE for one series. TS.MRANGE queries multiple series using label filters:

~~~text
TS.CREATE lab:ts:temp:2 RETENTION 86400000 LABELS site tehran sensor temperature unit celsius
TS.ADD lab:ts:temp:2 * 21.2
TS.MRANGE - + WITHLABELS FILTER site=tehran sensor=temperature
~~~

WITHLABELS includes series labels in the response. Bound the time range and number of series for large queries. Labels should help group data. A unique request ID on every sample creates high cardinality and can inflate index and memory overhead.

### 3. Aggregation and downsampling

Query-time aggregation calculates buckets when a query runs. A compaction rule maintains a second, lower-resolution series as samples arrive. The rule trades write and storage overhead for more compact historical queries.

~~~text
TS.RANGE lab:ts:temp:1 - + AGGREGATION avg 60000
TS.CREATE lab:ts:temp:1m RETENTION 2592000000 LABELS site tehran sensor temperature resolution 1m
TS.CREATERULE lab:ts:temp:1 lab:ts:temp:1m AGGREGATION avg 60000
~~~

The destination retains about 30 days, with one-minute buckets. Usually the most recent bucket is not finalized until the system has enough later data to close it. Create the rule before production ingestion. Keep raw data for as long as required for replay, audit, or recalculation.

Choose an aggregation that answers the question. Average temperature may suit a dashboard; maximum can reveal a brief overheat that the average hides. For request latency, percentiles often matter more than the mean. A sum may be right for interval event counts but wrong for a cumulative counter unless resets and deltas are handled.

Also define bucket alignment, time zone in reports, inclusive range boundaries, out-of-order samples, and late arrivals.

### 4. Design a telemetry series

Suppose 50,000 devices send one temperature sample every 10 seconds:

1. **Key model:** for example, telemetry:{device-42}:temperature, designed with the query and Cluster placement in mind.
2. **Timestamp:** use the measurement time in UTC, not merely arrival time. Monitor device clock skew and future timestamps.
3. **Retention:** perhaps raw data for one week and hourly aggregates for six months. Actual values depend on analysis, legal, and capacity requirements.
4. **Labels:** region, device type, or firmware can be useful. A unique identifier on every sample may be expensive.
5. **Late/duplicate data:** preserve event time, select duplicate semantics intentionally, and test out-of-order behavior on the deployed version.
6. **Durability:** Redis Time Series is not automatically a permanent analytics lake. If exact long-term replay or regulated reporting is needed, retain an authoritative durable source.
7. **Capacity:** estimate sample rate, series count, retention, label index, rules, replication, and persistence using representative data.

For very long retention, large scans, and analytical queries, compare Redis with purpose-built systems such as Prometheus, VictoriaMetrics, TimescaleDB, or ClickHouse. Compare ingest rate, query shape, compression, durability, export, operations, and cost—not one command’s speed.

## Part B — Probabilistic structures

### 5. What approximation buys

A probabilistic structure summarizes a set or stream with much less memory than an exact copy. That saves space or time but introduces a defined kind of error. Write down:

- Which question must be answered?
- Is a false positive, over-count, or approximate percentile acceptable?
- What is the error target and sample window?
- Which exact system will verify a result before a critical action?

Redis 8 integrates several capabilities that earlier deployments may have needed through Redis Stack modules. Check whether the specific commands are enabled.

### 6. Choose the structure by question

| Structure | Question | Approximation behavior | Example use |
| --- | --- | --- | --- |
| Bloom filter | “Might this item have been seen?” | A negative means absent; a positive may be a false positive. No exact item listing. | Avoid some unnecessary cache/database lookups |
| Cuckoo filter | Similar membership question, with supported deletion | False positives remain possible; configure and size it deliberately | Tracking likely-seen identifiers when deletion is needed |
| Count-Min Sketch (CMS) | “How frequent is this item?” | Hash collisions can overestimate; it does not store an exact per-item count | Approximate event or search-term frequencies |
| Top-K | “Which items are most frequent?” | Candidate ranking is compact and can omit or mis-rank close items | Approximate trending terms |
| t-digest | “What percentile is this distribution near?” | A compact quantile estimate; accuracy depends on configuration and distribution | Latency or request-size summaries |

### 7. Short command sketches

Bloom membership:

~~~text
BF.RESERVE lab:seen 0.01 10000
BF.ADD lab:seen user:42
BF.EXISTS lab:seen user:42
~~~

Count-Min Sketch:

~~~text
CMS.INITBYDIM lab:searches 2000 5
CMS.INCRBY lab:searches redis 1 database 1
CMS.QUERY lab:searches redis database
~~~

Top-K and t-digest:

~~~text
TOPK.RESERVE lab:trending 20 50 5 0.9
TOPK.ADD lab:trending redis redis streams latency
TOPK.LIST lab:trending
TDIGEST.CREATE lab:latency
TDIGEST.ADD lab:latency 12 18 25 73 110
TDIGEST.QUANTILE lab:latency 0.5 0.95 0.99
~~~

These are teaching examples. Reserve parameters, command availability, and error behavior must be checked against the target version and workload. The exact source of truth should remain a durable log or database when correctness requires it.

### 8. Safety rules for estimates

- A Bloom positive should trigger an exact lookup before rejecting a signup or payment.
- A sketch count should not become a billing total or authoritative quota without a correction path.
- A Top-K ranking depends on its window. Use time-bucketed keys, scheduled rotation, or another explicit windowing design for “trending now.”
- A t-digest percentile is an estimate, not the exact result of sorting every observation. Report window, sample count, and method.
- Approximation does not make privacy or retention rules disappear; summaries can still reveal sensitive patterns.

## Workshop: telemetry dashboard and trending terms

Design raw device data retained for two days and one-minute aggregates retained for 14 days. The dashboard needs min/max/average. Separately, product wants approximate top search terms for each hour.

1. Define the raw and aggregate keys, labels, retention, and compaction rules.
2. Decide whether average or maximum should drive an overheating alert.
3. Decide how an hour of Top-K state rolls over and how to compare it with an exact sample.
4. Explain what happens to late samples and gaps during a network outage.
5. Identify the durable source used to rebuild a bad aggregate.

**Answer guide:** Maintain raw and compacted series with different retentions; use max for a spike alert and likely avg/min/max for a dashboard; isolate Top-K by time window; buffer or replay late events from a durable source; use an authoritative event log for rebuild.

## Troubleshooting

| Symptom | Likely cause | First checks |
| --- | --- | --- |
| Unknown TS or BF command | Version/module/service lacks the capability | Check product, version, module list, and command info |
| Key is not a Time Series key | Wrong key type or TS.CREATE was skipped | TYPE, key name, and creation order |
| Duplicate sample not inserted | Duplicate timestamp or configured policy | TS.INFO, timestamp, and ON_DUPLICATE |
| Old data is missing | Retention, query range, or unit/time error | Verify millisecond epoch and retention window |
| MRANGE is empty | Labels or filter expression do not match | Compare TS.INFO labels and filter terms |
| Aggregate appears behind | Bucket not complete or rule created late | Check rule, bucket boundaries, and newer samples |
| Bloom says “maybe” but item is absent | False positive | Perform the exact lookup |
| CMS is above exact count | Hash collisions | Compare with an exact sample and review dimensions |

## Exercises

1. 20,000 devices report once every 15 seconds. Calculate samples per second. What else is needed to estimate memory for seven days of raw data?
2. Choose avg, min, max, or a percentile for a chart, an overheat alert, and a latency SLO.
3. A Bloom filter has a 1% false-positive target. Why does a signup system still need a unique constraint in its authoritative database?
4. A CMS estimates more searches for one term than a log sample does. Explain why and describe a calibration check.
5. An approximate p99 changes after a traffic spike. Which metadata should accompany the result?

**Answer guide:** 1) About 1,333 samples/second. Estimate actual encoded sample/chunk size, series count, labels/indexes, replicas, fragmentation, persistence buffers, and allocator headroom. 2) Usually average plus min/max for a chart, max or raw threshold for a spike alert, and p95/p99 for latency SLOs. 3) Bloom can have false positives and concurrent registration races; the authoritative unique constraint decides correctness. 4) CMS collisions can inflate estimates; compare against exact counts for sampled windows. 5) Window, sample count, digest/configuration, units, and approximation caveat.

## Quiz

### 1. Which unit does Redis Time Series use for explicit timestamps?

<details><summary>Answer</summary>

Integer milliseconds since the Unix epoch; an asterisk uses server time.

</details>

### 2. What does a Bloom negative mean?

<details><summary>Answer</summary>

The item is not present in the filter. A positive means probably present and may be a false positive.

</details>

### 3. Does Bloom provide a list of stored members or general deletion?

<details><summary>Answer</summary>

No. A Bloom filter is not an exact member store. A Cuckoo filter supports deletion under its own limits.

</details>

### 4. What error is common with Count-Min Sketch?

<details><summary>Answer</summary>

Hash collisions can cause an item’s estimated frequency to be larger than its true frequency.

</details>

### 5. Is retention the same as backup?

<details><summary>Answer</summary>

No. Retention removes old series samples. A backup is a separately recoverable copy.

</details>

### 6. Why can average hide a latency incident?

<details><summary>Answer</summary>

A short, severe tail can have little effect on the mean. Percentiles or maximum values may better represent the user-facing impact.

</details>

### 7. What should be the authoritative source for an exact billing total?

<details><summary>Answer</summary>

A durable exact record or transactional system, not a probabilistic sketch.

</details>

## Published telemetry and analytics patterns

Redis publishes a Time Series dashboard example that plots rolling sensor measurements, plus data-structure guides for approximate unique visitors and frequent-item summaries. Together they show two practical jobs: time-bucketed measurement and memory-efficient estimation. These are official implementation examples rather than independently audited customer postmortems. Preserve raw data elsewhere when exact replay, audit, or a legal record is required. [Redis Time Series dashboard use case](https://redis.io/docs/latest/develop/use-cases/time-series-dashboard/) · [Redis probabilistic data structures](https://redis.io/docs/latest/develop/data-types/probabilistic/) · [Probabilistic analytics article](https://redis.io/blog/streaming-analytics-with-probabilistic-data-structures/)

## References and further reading

### English: official and engineering sources

- [Redis Time Series](https://redis.io/docs/latest/develop/data-types/timeseries/) — concepts, commands, labels, and aggregation.
- [Time Series development guide](https://redis.io/docs/latest/develop/data-types/timeseries/development/) — ingestion and query patterns.
- [Time Series command reference](https://redis.io/docs/latest/commands/?group=timeseries) — exact command syntax and complexity.
- [Redis probabilistic data types](https://redis.io/docs/latest/develop/data-types/probabilistic/) — family overview and trade-offs.
- [Bloom filter guide](https://redis.io/docs/latest/develop/data-types/probabilistic/bloom-filter/) — membership semantics.
- [Probabilistic data-type command references](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/bloom/commands/) — command families.
- [Redis: what is time-series data?](https://redis.io/blog/what-is-time-series-data/) — introductory applications and concepts.
- [Redis data type comparison](https://redis.io/docs/latest/develop/data-types/compare-data-types/) — choose the right Redis structure.
- [Prometheus data model](https://prometheus.io/docs/concepts/data_model/) — comparison point for metrics and labels.
- [Timescale hypertables](https://docs.timescale.com/use-timescale/latest/hypertables/) — alternative time-series storage model.

### فارسی

- [آموزش Redis در SalamLang](https://www.salamlang.ir/std/db/redis/) — مبانی Redis؛ syntax سری زمانی را با مستند جاری تطبیق بده.
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی فارسی Redis Time Series](https://www.google.com/search?q=آموزش+فارسی+Redis+Time+Series+TS.ADD+TS.RANGE)
- [جست‌وجوی فارسی Bloom Filter و Count-Min Sketch](https://www.google.com/search?q=آموزش+فارسی+Bloom+Filter+Count+Min+Sketch)
- [جست‌وجوی فارسی t-digest و صدک](https://www.google.com/search?q=t-digest+صدک+آموزش+فارسی)

پوشش فارسیِ جزئیات Time Series و sketchهای Redis محدود است؛ این درس نمونه‌ها و خطاهای رایج را خودبسنده آموزش می‌دهد. برای command availability، retention و duplicate policy، نسخهٔ سرور خود را بررسی کن.

</div>

