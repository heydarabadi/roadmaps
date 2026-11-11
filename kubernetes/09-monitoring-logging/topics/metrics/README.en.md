# Metrics
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#09-monitoring-logging-and-tracing)

[فارسی](README.md) | [Chapter 09](../../README.en.md)

## Metric types and uses

A **counter** only increases and is useful for request/error rates. A **gauge** goes up or down, such as active connections. A **histogram** records distributions such as latency or payload size into buckets. For an HTTP service, begin with request rate, error rate, latency distribution, and saturation.

~~~text
RPS = new requests in a time interval
Error rate = failed responses / all responses
Latency = response duration distribution and percentiles
Saturation = how close a constrained resource is to capacity
~~~

Prometheus-style labels help filter by version or service. A high-cardinality label such as user ID can overwhelm the metrics database. Keep labels bounded and meaningful.

## From metrics to alerts

Metrics Server provides current CPU/memory metrics for tools such as top and HPA. Historical queries, dashboards, and alerts require a durable metrics pipeline. Set thresholds over suitable time windows; short, non-actionable alerts create on-call fatigue.

## Practice

Create a learning dashboard for error rate and latency. Deploy a deliberately controlled regression and decide what threshold and duration should alert. Compare metrics with logs and events from the same time.

## Quiz
1. **Counter versus gauge?** A counter increases monotonically; a gauge can move up or down.
2. **Why use a histogram for latency instead of only an average?** It exposes distribution and tail behavior.
3. **What does high cardinality do?** It increases metrics storage and query cost.
4. **Is Metrics Server a historical monitoring system?** No.

## Further reading
- [Resource Metrics Pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [Resource Metrics API](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [OpenTelemetry Metrics](https://opentelemetry.io/docs/specs/otel/metrics/)
- [Prometheus concepts](https://prometheus.io/docs/concepts/)
- [Prometheus instrumentation practices](https://prometheus.io/docs/practices/instrumentation/)
