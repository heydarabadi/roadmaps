# Chapter 7 — Monitoring and Logging

**Language:** English | [فارسی](../../../fa/backend-performance/07-monitoring-and-logging/README.md)

Without observability, an optimization can improve one chart while making the user experience worse. This chapter starts with the question: “What share of user work completes correctly and on time?” It then designs the data, collection path, and cost needed to answer that question.

**Sources reviewed: <span dir="ltr">2026-11-10</span>.** Topics follow the Monitoring & Logging section of the [Backend Performance roadmap](https://roadmap.sh/backend-performance-best-practices). Example numbers are hypothetical. Prometheus, Grafana, and ELK are examples, not required products.

Each guide defines its prerequisites, mechanism, decisions, complete example, solved exercise, and quiz answers on the page. External references are for further reading and technical provenance; they are not needed to understand or study a lesson.

## Prerequisites and study order

Knowing HTTP requests, response time, error rate, CPU, databases, and queues is enough. You do not need to install an observability stack to follow the examples.

| Order | Lesson | Learning outcome |
| --- | --- | --- |
| 1 | [Metrics, logs, and traces](01-metrics-logs-and-traces/README.md) | Define useful indicators, correlate events, control cardinality and instrumentation cost |
| 2 | [Monitoring toolchain](02-monitoring-toolchain/README.md) | Separate collection, storage, display, and alerting; inspect monitoring-path failures |
| 3 | [Asynchronous logging](03-asynchronous-logging/README.md) | Calculate queue capacity and choose consciously among waiting, dropping, and durable delivery |

## Connecting scenario

A reporting API accepts a job in 30 ms, but the user receives the result later. The API response-time chart may look good while jobs have waited in the queue for hours. Measure both API acceptance/failure and queue age and elapsed time from acceptance to result. A trace shows one attempt's path; a log provides error details; a job identifier connects multiple attempts.

If log volume grows tenfold during an incident, sending logs directly may slow requests. An asynchronous queue temporarily moves that wait; an unbounded queue consumes memory, while a bounded queue needs a full-queue policy. If the Collector or storage is down, a healthy-looking dashboard does not prove the service is healthy. The three lessons follow this chain from user to data destination.

## Connections to other chapters

- [Background jobs](../03-asynchronism/01-background-jobs/README.md): distinguish fast acceptance from successful completion and measure queue age.
- [Connection pooling](../04-databases/01-connection-pooling/README.md): connection wait, pool saturation, and query execution time are different.
- [Slow-query logging](../04-databases/09-slow-query-logging/README.md): connect database details with request time and context.
- [Scaling](../05-load-balancing-and-scaling/01-horizontal-and-vertical-scaling/README.md): instance count and average CPU alone are not success measures.

## Chapter review checklist

- [ ] The unit of work, request population, time window, and on-time success definition are clear.
- [ ] Counters, gauges, and response-time distributions are chosen and aggregated correctly.
- [ ] Request/trace IDs go in logs, not unlimited-cardinality metric labels.
- [ ] CPU, memory, network, and storage costs have a monitoring budget.
- [ ] Independent visibility exists for no data, Collector outages, and alert-path failures.
- [ ] Each alert has an owner, next action, and investigation link; a chart alone is insufficient.
- [ ] The log queue is bounded and its drop, wait, flush, and crash behavior is defined.
- [ ] Diagnostic logs are not confused with essential business history or durable audit records.

**Navigation:** [Course index](../README.md) · [Lesson 1](01-metrics-logs-and-traces/README.md) · [Load balancing and scaling](../05-load-balancing-and-scaling/README.md)
