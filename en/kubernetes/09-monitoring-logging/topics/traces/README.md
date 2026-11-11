# Distributed Tracing
[Persian edition](../../../../../fa/kubernetes/09-monitoring-logging/topics/traces/README.md) · [Chapter references](../../../references/README.md#09-monitoring-logging-and-tracing)

[فارسی](../../../../../fa/kubernetes/09-monitoring-logging/topics/traces/README.md) | [Chapter 09](../../README.md)

## Spans and traces

A trace is a chain of spans following one request across services. Each span has a time range, operation, parent, and attributes. Context must propagate from gateway through backend, queues, and external services; otherwise related spans break into unrelated traces.

~~~text
checkout request
  ├── API: 40ms
  ├── inventory: 12ms
  └── payment: 870ms
~~~

Here, the trace shows that most latency comes from payment; adding API CPU probably will not fix it. Sampling controls cost. A fixed rate may miss rare failures. Tail-based sampling can preserve slow/error traces but needs appropriate collector capacity.

## OpenTelemetry

OpenTelemetry provides instrumentation and protocols to create and transfer telemetry; it is not a search/storage backend by itself. A Collector can receive, process, and export data. Keep attributes bounded and exclude secrets and personal data.

## Quiz
1. **What is a span?** One timed operation inside a trace.
2. **Why propagate context?** To preserve parent/child relationships across services.
3. **What can a slow trace reveal?** The slow span or dependency on one request path.
4. **Why sample traces?** To control telemetry volume and cost.

## Further reading
- [OpenTelemetry traces](https://opentelemetry.io/docs/concepts/signals/traces/)
- [OpenTelemetry on Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/)
- [Context propagation](https://opentelemetry.io/docs/concepts/context-propagation/)
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
- [Kubernetes observability](https://kubernetes.io/docs/concepts/cluster-administration/observability/)
