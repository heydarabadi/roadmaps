# 7.2 — The Monitoring Toolchain

**Language:** English | [فارسی](../../../../fa/backend-performance/07-monitoring-and-logging/02-monitoring-toolchain/README.md)

A monitoring toolchain turns application data into observation and action: production, collection, processing, storage, querying, display, and alerting. Installing a dashboard is only one step. **This lesson designs responsibilities and failure boundaries; Prometheus, Grafana, and ELK are examples, not a required stack.**

**Sources reviewed: <span dir="ltr">2026-11-10</span>.** Scenarios and numbers are hypothetical; official operational documentation is cited with its evidence limits.

## Prerequisites defined here

A metric is a numeric measurement that can be aggregated; a log is a timestamped event; a trace is a set of related stages in one operation. A collector receives data from an application or host and forwards it to a destination. Storage keeps data and enables queries; a dashboard displays results. This page explains the boundaries, so you do not need another lesson or a product installation.

## Learning outcomes

- Separate the roles of instrumentation, collector, storage, query, and dashboard.
- Choose a toolchain suitable for a small or multi-service system.
- Calculate telemetry delay, retention capacity, and monitoring-path failure.
- Design actionable alerts and independent monitoring of the tools themselves.

## Mental model and example components

| Responsibility | Example tool or mechanism | What it does not solve by itself |
| --- | --- | --- |
| Produce data | Metrics/logs/spans in the application; host exporter | Central storage and search |
| Collect data | Scrape, agent, or OpenTelemetry Collector | Correct signal meaning and secure access |
| Store and query | Time-series database, log-search engine, trace store | Automatic root-cause diagnosis |
| Display | Grafana or a product interface | Fresh and complete data |
| Evaluate and notify | Rule evaluator and alert router | Human action without owner and runbook |

Prometheus can scrape targets, store/query metrics, and evaluate rules; Alertmanager is an example of grouping and routing alerts. Grafana queries data sources such as Prometheus or another database; its official [Data Sources documentation](https://grafana.com/docs/grafana/latest/datasources/) explains this separation. Grafana also supports alerting, but a graph is not itself storage for every signal.

The historical name **ELK** comes from Elasticsearch, Logstash, and Kibana: search/storage, processing/forwarding, and viewing, respectively. Current [Elastic logging documentation](https://www.elastic.co/docs/solutions/observability/logs) describes several collection paths; not every deployment requires Logstash. A managed service, another agent, or a simpler toolchain may suffice. OpenTelemetry can send standardized data to a compatible destination; it is not itself that storage destination.

## Decision process

1. **Start with a question and objective.** For example, “Are successful bookings on time?” and “Which dependency used the time?” Assign a signal, owner, and retention period to each question. A long tool list does not make these decisions.
2. **Define minimum data at the source.** Standardize service, environment, route template, duration unit, deployment version, and needed context. Do not put customer IDs in metric labels. Host CPU and user time differ; both may be useful.
3. **Match collection to workload.** Periodic scrape suits a live service; a short job may finish before it is scraped and need another collection path. Periodic export, event shipping, and intermediate queues have their own delays and failure modes. Multiple agents or duplicate log paths can create duplicates.
4. **Budget resources.** Series count, log rate, span size, retention, replication, indexing, and concurrent queries all cost resources. A fast-refresh dashboard with expensive queries can saturate monitoring storage. Separate monitoring resources from sensitive application paths where appropriate; choose quotas and query limits for system size.
5. **Define delivery and access.** Use encrypted connections, agent identity, restricted data-source access, and protected metric endpoints. Remove or mask tokens, cookies, and sensitive data before export; hiding them on the dashboard does not remove stored copies. Choose retention by need, not always for maximum duration.
6. **Turn data into action.** An alert should state impact and scope, start time, owner, dashboard link, and next investigation action. User-visible errors and delays are usually better page triggers than every CPU fluctuation. Choose thresholds, time window, minimum sample count, and hold duration for the service; this lesson's numbers are not standards.

## Worked example: data volume and detection delay

Assume 1,000 logs/s with an average 500-byte payload. Raw volume is 43.2 GB/day and 302.4 GB for seven days using decimal units. This excludes indexes, replicas, metadata, compression, temporary space, and transfer overhead. Add peak rate and factors measured for the actual pipeline when planning. Traces and metrics also need separate budgets.

Now assume a 15-second scrape interval, rules evaluated every 30 seconds, and alert delivery within 10 seconds. If a condition is visible in the first sample, the rule has no persistence delay, and other delays are zero, phase alignment could make discovery take up to about 55 seconds: up to 15 seconds to scrape, 30 seconds to evaluate, then 10 seconds to deliver. Rate-window calculation, a <code>for</code> condition, jitter, timeouts, and network interruption can add time. This is not a product guarantee; refreshing a dashboard every second does not necessarily speed up this discovery path.

For an error ratio, numerator and denominator must refer to the same population and window. Do not automatically call zero requests “100% success”; traffic may be low or collection may be broken. Define no data, zero, stale sample, and query failure separately. A latency panel must also show time range and aggregation; averaging p95 samples is invalid.

## Monitor the monitoring path and define its guarantees

The Collector is a service too: monitor its CPU, memory, queue length/capacity, data age, input/output rates, drops, and export failures. A healthy process is different from fresh data arriving at its destination. A small test event with a production timestamp can measure time from production to searchability. Test the complete alert delivery path too, not just rule evaluation.

Do not observe every failure from the same failure domain. When the whole internal chain is disconnected, an external probe or independent alert path can reveal missing data or heartbeat. [Prometheus alerting guidance](https://prometheus.io/docs/practices/alerting/) emphasizes user impact and end-to-end checks of the monitoring system itself.

> **Official operational documentation and its limit:** [OpenTelemetry Collector resiliency](https://opentelemetry.io/docs/collector/resiliency/) explains that an in-memory sending queue can absorb a short destination outage, but a full queue, exhausted retry budget, or crash can lose data. Persistent storage-backed queues improve recovery but do not eliminate disk failure, finite capacity, or non-retryable errors.
>
> This is official operational documentation about a tool, not a company incident report or a “zero data loss” guarantee. No production study comparing multiple stacks under this lesson's load is offered; volume and delay numbers here are assumptions.

## When the choice fits or does not

A small service can begin with a few user-facing indicators, limited structured logs, and one alert route. Central storage and tracing become more useful when several services share context and teams investigate related incidents. Self-hosting offers control and flexibility but requires operations, versioning, capacity, and recovery. A managed service removes some operations, but volume cost, access control, and provider dependence remain. Installing every component before identifying a question is a poor fit; disabling all monitoring to save cost prevents diagnosis.

## Exercise with worked solution

On paper, draw a chain containing application, agent/collector, storage, query, dashboard, and alert. Mark buffers and durable boundaries. Separately analyze a two-minute storage outage and a Collector crash. Calculate the raw daily volume for 200 logs/s with a 1,000-byte payload. Write one no-data alert and one user-impact alert.

**Solution:** <span dir="ltr">200 × 1000 × 86,400 = 17,280,000,000</span> decimal bytes, or <span dir="ltr">17.28 GB</span> of raw data per day, before indexes, replicas, and overhead. An in-memory buffer can absorb an outage only up to its capacity and budget; a crash can lose it. A disk buffer also needs a capacity and acknowledgment contract. A no-data alert detects missing observation; an impact alert detects a failure/delay ratio. Neither replaces the other. Give both an owner and an investigation step. No real outage or alert delivery was performed in this exercise.

| Failure | What is seen? | Control or next check |
| --- | --- | --- |
| Green dashboard with stale samples | Last-data time is old | Freshness and no-data checks |
| Unbounded labels and indexing | High RAM/disk and slow queries | Series/field budget and retention |
| CPU-only monitoring | User is slow, CPU is low | End-to-end time, queues, and dependencies |
| All alerts on one failed path | Incident has no notification | An appropriate independent probe/path |
| Two agents export the same source | Counts/volume exceed input | Collection ownership and duplication |
| Collector retries indefinitely | Old queue, memory or disk full | Queue cap, retry policy, visible drop count |

### Operational checklist

- [ ] Each tool has a clear role and fits system size/needs.
- [ ] Fresh data, no data, and query failures are distinguishable.
- [ ] Raw volume, index, replicas, and queries are measured; retention is defined.
- [ ] Sensitive data is handled at source and management endpoints are restricted.
- [ ] Queues, drops, and end-to-end delivery delay are visible.
- [ ] Alerts have an owner, action, and link; delivery can be checked.
- [ ] Collector/destination failure and recovery behavior are defined.

## Review quiz

1. Does Grafana alone mean all data is stored?
2. What is the difference between a metric exporter and a trace store?
3. In the 1,000 logs/s at 500 bytes example, why is 43.2 GB not the full disk budget?
4. Why does a one-second dashboard refresh not guarantee one-second incident discovery?
5. Is no sample the same as zero errors?
6. Why should the alert delivery path be checked?
7. Does a Collector disk queue guarantee no data loss?

### Explained answers

1. No. Grafana reads a data source; collection and storage paths must be defined separately. Other product capabilities do not replace designing that path.
2. The exporter exposes/sends measurements for collection; a trace store retains spans and supports queries. Production, transport, and storage are separate responsibilities.
3. That is raw payload only. Add indexes, replicas, temporary space, and peak volume based on measurement; compression may reduce storage.
4. Collection, rule windows, evaluation, and delivery each take time. Fast display of old data does not make production faster.
5. No. Distinguish no traffic, stale samples, query failure, and collection outage from a true zero.
6. An active rule without delivery does not notify anyone. End-to-end testing and, if needed, an independent path make alert failure visible.
7. No. Capacity, disk failure, retries, and acceptance/acknowledgment contracts remain limits; define the failure scenarios and drop behavior.

## Summary

Start with a question, signal, and owner. Then build the path from production to alert with capacity, freshness, security, and failure boundaries in mind. Monitor the Collector and alert delivery separately. A small reliable stack is more useful than a complete but unstable one.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and operational documentation.

- **Persian, complementary course directory:** [Monitoring with Grafana and Prometheus](https://www.m-fozouni.ir/courses/monitoring-grafana-prometheus/). Introduces metrics, dashboards, and Alertmanager. The page is public, but full course lessons were not confirmed accessible in the earlier review. Its “production ready” marketing phrase is not independently verified here.
- **English, official Grafana documentation:** [Data sources](https://grafana.com/docs/grafana/latest/datasources/). Relationship between visualization and data backends.
- **English, official Elastic documentation:** [Log monitoring](https://www.elastic.co/docs/solutions/observability/logs). Collection options and log investigation; product example, not a required architecture.
- **English, official Prometheus guidance:** [Alerting](https://prometheus.io/docs/practices/alerting/). User impact and monitoring the tools themselves.
- **English, official OpenTelemetry operational documentation:** [Collector resiliency](https://opentelemetry.io/docs/collector/resiliency/). Queue, retry, persistence, and data-loss boundaries.

**Navigation:** [Chapter index](../README.md) · [Course index](../../README.md) · [Previous: Signals](../01-metrics-logs-and-traces/README.md) · [Next: Asynchronous Logging](../03-asynchronous-logging/README.md) · [Scaling](../../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md)
