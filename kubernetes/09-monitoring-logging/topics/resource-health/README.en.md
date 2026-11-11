# Pod and Cluster Resource Health
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#09-monitoring-logging-and-tracing)

[فارسی](README.md) | [Chapter 09](../../README.en.md)

## Probes and what they mean

A startup probe allows a long initialization period. Until it succeeds, liveness and readiness do not run. Liveness can restart a stuck process. Readiness marks a Pod as unready and changes Service endpoints. Each endpoint must match its purpose. A liveness check that depends on a remote database may restart every Pod during a database outage.

~~~yaml
startupProbe:
  httpGet:
    path: /startup
    port: 8080
  failureThreshold: 30
  periodSeconds: 5
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  periodSeconds: 5
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  periodSeconds: 10
~~~

## Cluster-wide view

Correlate node conditions, restarts, Pending Pods, evictions, quota, error rates, and saturation with user-facing service health. Events are temporary and have limited retention, so important incidents need alerts and a timeline. PodDisruptionBudgets affect some voluntary disruptions but do not prevent node crashes.

## Quiz
1. **What does a readiness failure do?** Marks the Pod unready and removes it from ready endpoints.
2. **What does a liveness failure do?** It can cause kubelet to restart the container.
3. **Why avoid making liveness depend on a remote service?** A dependency outage could restart every Pod at once.
4. **Does Running prove user-facing health?** No. Check probes, Service paths, and real requests.

## Further reading
- [Liveness, readiness, and startup probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
- [Pod lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Node conditions](https://kubernetes.io/docs/concepts/architecture/nodes/)
- [Pod disruptions and PDBs](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
