# Monitor and Optimize Resources
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#07-resource-management)

[فارسی](README.md) | [Chapter 07](../../README.en.md)

## From measurement to tuning

Startup, normal load, peak load, and dependency failure can all change resource behavior. Observe CPU, memory, restarts, OOM, throttling, latency, and saturation over time. If you only look at CPU, a network or storage bottleneck can be misdiagnosed as a resource problem.

## Optimization workflow
1. Define the SLO and expected load.
2. Measure baseline and peak under representative traffic.
3. Compare usage with requests/limits and replica count.
4. Change one value and measure latency and capacity again.
5. Update dashboards, alerts, and runbooks.

kubectl top is a snapshot, not historical monitoring. Long-term tuning needs a metrics pipeline and dashboards. Raising a limit to hide a memory leak is not a fix; trace repeated restarts and memory growth to their cause.

## Example

An API uses little CPU most of the day, but at peak its tail latency rises and CPU throttling appears. Check concurrency, replicas, CPU requests/limits, and HPA together. If memory steadily grows, compare heap, cache, active requests, and container memory.

## Quiz
1. **What should be considered together?** Usage, latency, restarts/throttling, SLO, and capacity.
2. **Why is an average insufficient?** It hides peaks and variation.
3. **When can raising a limit be wrong?** When a leak or inefficient algorithm causes memory growth.
4. **Why change gradually?** The cause and effect stay clearer and rollback is easier.

## Further reading
- [Resource Metrics Pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [Resource management concepts](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Kubernetes observability](https://kubernetes.io/docs/concepts/cluster-administration/observability/)
- [Prometheus Kubernetes monitoring](https://prometheus.io/docs/introduction/overview/)
