# Chapter 09: Monitoring, Logging, and Observability
[Persian edition](README.md) · [Chapter references](../references/README.en.md#09-monitoring-logging-and-tracing)

[فارسی](README.md) | [Course index](../README.en.md)

## Learning objectives
- Distinguish logs, metrics, and traces, then correlate them.
- Assess Pod, node, and service health from application and user perspectives.
- Collect, store, search, and alert on telemetry.
- Define operational questions; installing a dashboard is not enough.

## Three signal types

- **Logs:** individual events and error details, such as why a payment returned 500.
- **Metrics:** numeric measurements over time, such as error rate, latency, and saturation.
- **Traces:** a request's path across services, including slow spans and failure boundaries.

Each signal answers a different question. Trace and log IDs can correlate the signals; propagate request and trace IDs through the application. Telemetry may contain sensitive data, so redact or restrict it.

## From health checks to SLOs

Readiness decides whether a Pod should receive Service traffic. Liveness can restart a stuck process. Startup checks protect apps with long initialization from premature liveness failures. Also observe node conditions, restarts, Pending Pods, evictions, and resource saturation. These conditions do not by themselves prove that users are healthy.

An SLO states a service objective. Connect alerts to user impact and error budget where possible. A brief CPU spike can be noisy; sustained user-facing errors and latency are usually more actionable.

## Telemetry pipeline

~~~text
Application / kubelet / node
→ agents and exporters
→ collector or storage
→ queries and dashboards
→ alert
→ runbook and action
~~~

Kubernetes does not retain all historical application logs and metrics for you. Design retention, sampling, cardinality, access, and cost. Metrics Server serves some current resource metrics and supports autoscaling use cases; it is not a complete historical monitoring system.

## Correlated troubleshooting

Use the alert time range, inspect the error metric, find slow traces, and search related logs for the same request. Compare the release events and Pod state to the incident timeline. Clock synchronization, environment/version labels, and correlation IDs matter.

## Practical example

During a checkout release, the API error rate may look normal while traces show that latency is concentrated in an external payment service. Looking only at cluster metrics might lead you to add nodes and increase cost without fixing the cause. Dashboards should include application health and dependencies.

## Quiz
1. **Which signals help diagnose one request?** A trace correlated with its logs.
2. **Which signal shows an error-rate trend over an hour?** A counter-derived metric rate.
3. **Why aren't Pod logs enough?** Pods may be deleted and local logs do not provide durable centralized retention.
4. **Are liveness and readiness the same?** No. Restarting and receiving traffic are different purposes.
5. **What makes an alert useful?** It reflects user impact and points to an owner and runbook.

## Further reading
- [Kubernetes observability concepts](https://kubernetes.io/docs/concepts/cluster-administration/observability/)
- [Kubernetes logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
- [Liveness, readiness, and startup probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
- [OpenTelemetry on Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/)
- [Prometheus concepts](https://prometheus.io/docs/concepts/)
- [OpenTelemetry Kubernetes observability blueprint](https://opentelemetry.io/docs/platforms/kubernetes/getting-started/)
- [Persian EnginDevOps guide](https://enginedevops.com/)
