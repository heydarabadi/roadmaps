# Logs
[Persian edition](../../../../../fa/kubernetes/09-monitoring-logging/topics/logs/README.md) · [Chapter references](../../../references/README.md#09-monitoring-logging-and-tracing)

[فارسی](../../../../../fa/kubernetes/09-monitoring-logging/topics/logs/README.md) | [Chapter 09](../../README.md)

## What should you log?

Logs describe discrete events. Applications should usually write structured records to stdout/stderr so a node agent can collect them. Include timestamp, severity, service, version, and request/trace ID for search and correlation. Log for debugging and purposeful audit; do not dump every variable.

~~~sh
kubectl logs deployment/api --since=10m
kubectl logs pod/api-abc -c server
kubectl logs pod/api-abc --previous
~~~

These commands help with short-term diagnosis. Production needs centralized collection, retention, access control, redaction, and storage capacity. Previous logs may preserve the last clue before a container restart.

## Structure and privacy

Structured JSON makes search and filtering easier. Never log tokens, passwords, cookies, sensitive payloads, or unnecessary personal data. Bound log volume; repeated stack traces can increase storage and cost. Design sampling for noisy events carefully so important errors remain visible.

## Collection pipeline

An agent commonly reads container output on each node and forwards it to a backend such as Loki or a cloud logging service. If logs disappear, verify the process writes to stdout/stderr, the agent is healthy, the disk is not full, and the parser has not discarded fields. Logs are not infinite archives; define retention and audit requirements.

## Quiz
1. **Why use stdout/stderr for containers?** Runtimes and agents can collect output without a special file inside the Pod.
2. **What should never be logged?** Credentials and unnecessary sensitive data.
3. **Why use previous logs?** They show output from a container before it restarted.
4. **What does production add?** Aggregation, retention, access control, alerting, and redaction.

## Further reading
- [Kubernetes logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)
- [kubectl logs reference](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_logs/)
- [OpenTelemetry Logs data model](https://opentelemetry.io/docs/specs/otel/logs/)
- [OpenTelemetry Collector](https://opentelemetry.io/docs/collector/)
- [Persian EnginDevOps guide](https://enginedevops.com/)
