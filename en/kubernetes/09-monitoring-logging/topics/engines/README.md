# Observability Engines and Tools
[Persian edition](../../../../../fa/kubernetes/09-monitoring-logging/topics/engines/README.md) · [Chapter references](../../../references/README.md#09-monitoring-logging-and-tracing)

[فارسی](../../../../../fa/kubernetes/09-monitoring-logging/topics/engines/README.md) | [Chapter 09](../../README.md)

## Tools and their roles

Prometheus scrapes and queries metrics; Grafana visualizes dashboards; Loki or cloud logging stores/searches logs; Jaeger or Tempo handles traces; and the OpenTelemetry Collector receives and exports telemetry. Kubernetes itself is not a full observability product. Choose tools based on volume, retention, privacy, team skills, and cost.

## A durable architecture

1. Instrument the application and keep labels bounded.
2. Collect telemetry with node or application agents.
3. Buffer and reliably forward it to storage.
4. Set retention and role-based access.
5. Build dashboards, alerts, and runbooks that lead to action.

Metrics Server is useful for current resource metrics and HPA. Prometheus or a similar system provides history and queries. They do not have the same role.

## Operations

Telemetry backends need resource requests, storage, and backup too. Control cost with cardinality, ingest rate, retention, and sampling. Review alerts periodically and assign every alert an owner and action. A dashboard nobody trusts during an incident is not complete observability.

## Quiz
1. **What does OpenTelemetry provide?** Instrumentation and collection/transport; not necessarily the storage backend.
2. **What is Grafana's role?** Queries and visualization over data sources.
3. **Why define retention?** Balance data needs, cost, privacy, and audit requirements.
4. **What provides historical metrics?** A metrics backend/pipeline, not Metrics Server alone.

## Further reading
- [Kubernetes observability](https://kubernetes.io/docs/concepts/cluster-administration/observability/)
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
- [Prometheus overview](https://prometheus.io/docs/introduction/overview/)
- [OpenTelemetry Kubernetes observability blueprint](https://opentelemetry.io/docs/platforms/kubernetes/getting-started/)
- [How Datadog approaches Kubernetes autoscaling in production](https://www.datadoghq.com/blog/how-we-saved-with-kubernetes-autoscaling/)
- [Persian EnginDevOps resource](https://enginedevops.com/)
