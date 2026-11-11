# 7.1 — Metrics, Logs, and Traces

**Language:** English | [فارسی](README.md)

**Instrumentation** means adding measurement points and context to a program; **telemetry** is the data those points emit. The goal is to understand the impact of a problem and form a testable hypothesis about its cause. Having all three signal types does not, by itself, prove a cause.

**Sources reviewed: <span dir="ltr">2026-11-10</span>.** The booking scenario and calculations are instructional; Discord's experience is cited separately.

## Learning outcomes

- Choose an operational signal for a practical question.
- Define rates, error ratios, and latency distributions with a clear population and window.
- Estimate cardinality and instrumentation cost before release.
- Correlate logs and traces through context and explain sampling limits.

## Prerequisites for this lesson

An **eligible request** is work received that the measurement contract says should be counted; first decide whether invalid-input rejections belong in the population. A **rate** is a count over a stated interval divided by that interval’s duration. A **percentage** is a numerator divided by its denominator, multiplied by 100. **p95** is a percentile of a duration distribution, not an average. This page defines metrics, logs, traces, counters, gauges, histograms, and related identifiers below; no previous reading is required.

## Mental model: three views of behavior

| Signal | What it records | Suitable question | Limitation |
| --- | --- | --- | --- |
| Metric | Numeric, aggregated measurements over time | When did the error rate rise? | Usually loses individual-event detail |
| Log | A timestamped event with severity and structured fields | What happened when a connection failed? | Volume, sensitive data, and expensive search |
| Trace | Related spans and their relationships for an operation | Where did this request spend time? | Coverage and sampling may be incomplete |

[OpenTelemetry Signals](https://opentelemetry.io/docs/concepts/signals/) explains these signal types. OpenTelemetry standardizes instrumentation and transport; using it does not automatically provide a storage system, dashboard, or unlimited retention.

## From user goal to measurement points

1. **Define the unit of work.** For a booking, “an eligible request with a correct result within 500 ms” is an instructional definition. Decide whether invalid-input rejections belong in the population; arbitrarily excluding failures makes an attractive but useless metric.
2. **Measure the edge.** Record request rate, outcome, duration, and in-flight count. Server time is not client time; DNS, network, and pre-application waits may matter. For jobs, separate completion duration from acceptance and queue wait.
3. **Separate dependencies.** Pool acquisition, query execution, and external calls are distinct spans. Use operational labels such as route templates; do not indiscriminately record raw SQL or user URLs.
4. **Propagate context.** Trace and span IDs in logs make related events easier to find. Propagate context across HTTP, queue, and worker boundaries with a clear trust policy. For a delayed job or several attempts, choose parent relationships or span links according to the model. A business ID, trace ID, and attempt ID are three different concepts.
5. **Check data quality.** Use a monotonic clock for local duration. Wall-clock time and clock synchronization matter when correlating events from different machines. Do not add overlapping spans and call the result end-to-end time.

## Metric types and correct aggregation

| Type | Example | Correct interpretation |
| --- | --- | --- |
| Counter | Completed request count | Increase/rate over a window; account for process resets |
| Gauge | Busy connections or waiting jobs | Current value; do not apply a counter rate to it |
| Histogram | Request-duration distribution | Observation counts in duration buckets; distributions can be aggregated |

A name such as <code>booking_http_request_duration_seconds</code> makes the unit clear. A cumulative count named <code>booking_http_requests_total</code> is distinct from a current value. [Prometheus naming guidance](https://prometheus.io/docs/practices/naming/) is an example contract for units and labels, not a required name for every product.

**The mean hides the tail.** p95 means approximately 95% of observations finished by that duration, subject to the tool's definition and precision. Do not average two p95 values; even a weighted average of percentiles is not the combined percentile. Aggregate compatible histograms before estimating a percentile. For classic Prometheus histograms, bucket boundaries should match and be near important thresholds; the percentile between buckets is estimated. A precomputed Summary percentile cannot be aggregated to produce a population-wide percentile. Current [Histogram and Summary guidance](https://prometheus.io/docs/practices/histograms/) prefers Native Histograms if the pipeline supports them; the classic example explains existing systems and bucket boundaries, not a permanent recommendation.

## Cardinality and overhead: telemetry is not free

Each distinct label combination creates a time series. With 6 routes, 4 methods, 5 status classes, and 8 instances, one counter has at most 960 combinations; not all must occur. Adding 100,000 user IDs can make this space enormous. A classic histogram creates multiple bucket series plus count and sum per combination. Label the template <code>/orders/{id}</code>, not <code>/orders/8453</code>. Do not use request ID, email, or trace ID as metric labels. Keep them in access-controlled, retention-limited logs or traces; indexing there also has a cost.

On a hot path, label construction, time reads, allocation, serialization, and export can have an effect. In a simple assumption, 10,000 events/s with 5 microseconds of added CPU each uses 50 ms CPU per second, or 5% of one core. This is not a measurement of any SDK. Bound volume, attributes, and event size; consider filtering before message construction and batch export. [Prometheus instrumentation guidance](https://prometheus.io/docs/practices/instrumentation/) discusses high-cardinality labels and instrumentation in sensitive loops.

Sampling traces/logs reduces volume, but an unobserved error is not proof that no error occurred. Random 1% sampling may omit a rare event. Head sampling decides at the start; tail sampling can consider the final result but needs more buffering, memory, and collection. [OpenTelemetry's sampling guidance](https://opentelemetry.io/docs/concepts/sampling/) describes these trade-offs. Without a sampling-correction model, do not call the error percentage among sampled traces the actual percentage of all requests.

## Worked example: a slow booking flow

Over five minutes, 12,000 eligible requests completed: 240 failed, 360 succeeded but took longer than 500 ms, and 11,400 succeeded within the deadline. These groups are separate and exhaustive. Average completion rate is 40 requests/s; failure ratio is 2%; on-time success is 95%. Overall success is 98%, so error rate alone misses late successful responses. These counts do not reveal the exact p95.

One sample trace shows 900 ms total and 680 ms waiting for the connection pool. This observation prioritizes checking pool saturation but does not prove the cause for all requests. A gauge of busy connections and a log correlated with this trace can strengthen or disprove the hypothesis.

~~~json
{"timestamp":"2026-11-10T10:00:00Z","level":"WARN","event":"db_pool_wait_exceeded","service":"booking-api","route":"/bookings","wait_ms":680,"trace_id":"example-trace-42","attempt":1}
~~~

This record is fabricated for teaching; it contains no token, request body, or customer data. The event name is stable and fields are searchable. The example trace ID is for lookup, not a metric label.

## Exercise with worked solution

Assume a one-minute window with 600 eligible completed requests, 18 failures, and 42 successful but late results. Calculate completion rate, failure percentage, and on-time success. Then count label combinations for a counter with 3 routes, 2 methods, and 4 instances before adding a customer identifier.

**Solution:** completion rate is <span dir="ltr">600 ÷ 60 = 10</span> requests/s. Failure ratio is <span dir="ltr">18 ÷ 600 = 3%</span>. On-time success is <span dir="ltr">(600 − 18 − 42) ÷ 600 = 540 ÷ 600 = 90%</span>. Label combinations before adding a customer ID are <span dir="ltr">3 × 2 × 4 = 24</span>. An unbounded ID continually creates new series; use a route template and search for the ID in a log instead. If two concurrent spans each last 400 ms, simply summing them to 800 ms is not a valid total duration. This is a calculation exercise; no SDK or service was run.

## Operational evidence: finding latency in Discord

> **Firsthand report, June 9, 2026:** [Discord's Voice-to-Edge account](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge) describes latency spikes in some European regions. A timed probe in the network path, CPU sampling, and a flame graph led investigation inside the VM and then to application output starvation and SoftIRQ contention.
>
> **Limit of inference:** several independent observations narrowed the area to investigate. This report does not prove one tool is superior or that every trace must be recorded. The booking values and 5-microsecond instrumentation cost above are not from Discord.

## When to use each signal and its trade-offs

Use metrics for trends and alerts, logs for events, and traces for relationships across stages. A small application may begin with a few user-focused metrics and limited structured logs; enabling every span and body without a question creates volume and risk. During an incident, temporarily increase detail with a limit and a defined time to return to normal. Instrumentation is not a replacement for CPU profiling or query-plan analysis.

| Mistake | Operational signal | Next action |
| --- | --- | --- |
| Only average response time | User complaints despite a healthy mean | Inspect distributions, percentiles, and on-time success |
| Raw user ID or URL in a label | Series and monitoring memory grow | Use bounded labels and route templates |
| Sum parallel span durations | Dependency duration exceeds request duration | Inspect timeline and overlap |
| Trace context lost in queue | Worker chain is disconnected | Propagate context and link attempts |
| Log complete bodies and headers | High volume or data exposure | Allowlist, redact, and cap event size |
| Synchronous export on request path | Latency follows telemetry destination | Bounded buffer, export budget, and overhead measurement |

## Operational checklist

- [ ] Population, window, unit, and failure/late definitions are documented.
- [ ] Counter rate accounts for resets and correct aggregation.
- [ ] Percentiles come from compatible distributions; percentiles are not averaged.
- [ ] Label-value cardinality and series growth have a budget.
- [ ] Context, clock, sampling, and incomplete coverage are considered.
- [ ] CPU, allocations, and network output from instrumentation are measured.
- [ ] Sensitive fields, event size, access, and retention are controlled.

## Review quiz

1. Which signals would you use for the error trend and details of one error?
2. Why is a request ID unsuitable as a metric label?
3. Why is the mean of two p95 values not the overall p95?
4. In the 600-request example, what is overall success, and what does it hide?
5. Does a trace that was not recorded show that the request had no error?
6. Is the sum of two parallel calls the request duration?
7. With 10,000 events/s and 5 microseconds CPU per event, what is the approximate CPU cost?

### Explained answers

1. **Metric and correlated log.** A metric shows the population and trend; a log provides event detail. A trace helps find the path/stage, but none alone proves a cause.
2. **It has too many possible values and creates many series.** Put it in a log/trace with access policy; labels should be bounded and meaningful.
3. **A percentile cannot be averaged to reconstruct a distribution.** Aggregate compatible histograms first, then estimate the population percentile.
4. **97%.** Overall success counts the 42 late successes; it shows only 18 failures. On-time success is 90%.
5. **No.** Sampling, dropped data, incomplete instrumentation, or export failure may omit it; check coverage.
6. **No.** Overlapping intervals cannot be added directly; use the timeline and execution relationships.
7. **50 ms CPU per second, about 5% of one core.** This is a simple assumption; contention, allocation, and export can change the actual result.

## Summary

Start with the user goal and a defined population. Metrics show trends/distributions, logs explain events, and traces show relationships among stages. Keep labels bounded, compute percentiles from compatible distributions, and report sampling or missing data as uncertainty.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading, official definitions, and technical provenance.

- **Persian, complementary:** [Metrics, logs, and tracing compared](https://watchlog.ir/blogs/metrics-logs-traces-difference). Terms and relationships among the signals. Its shop scenario is instructional, not independent production evidence for this lesson.
- **English, official OpenTelemetry documentation:** [Signals](https://opentelemetry.io/docs/concepts/signals/). Signal definitions and their relationship to instrumentation.
- **English, official Prometheus guidance:** [Instrumentation](https://prometheus.io/docs/practices/instrumentation/) and [Naming](https://prometheus.io/docs/practices/naming/). Measurement choices, cost, units, and labels.
- **English, official Prometheus guidance:** [Histograms and summaries](https://prometheus.io/docs/practices/histograms/). Aggregation, estimate error, and distribution choices.
- **English, official OpenTelemetry documentation:** [Sampling](https://opentelemetry.io/docs/concepts/sampling/). Trade-offs among sampling approaches.
- **English, firsthand engineering report:** [Discord Voice at the Edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge). A latency investigation using evidence from several layers.

**Navigation:** [Chapter index](../README.en.md) · [Course index](../../README.en.md) · [Next: Monitoring Toolchain](../02-monitoring-toolchain/README.en.md) · [Asynchronous Logging](../03-asynchronous-logging/README.en.md) · [Connection pooling](../../04-databases/01-connection-pooling/README.en.md)
