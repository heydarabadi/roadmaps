# Chapter 07: Resource Management
[Persian edition](README.md) · [Chapter references](../references/README.en.md#07-resource-management)

[فارسی](README.md) | [Course index](../README.en.md)

## Learning objectives
- Distinguish requests from limits and understand their CPU/memory effects.
- Apply ResourceQuota and LimitRange at namespace scope.
- Measure workload use and tune resources against demand.
- Diagnose Pending, CPU throttling, and OOMKilled events.

## Three separate concepts

A **request** affects scheduling and capacity accounting. A **limit** enforces a ceiling. **Actual usage** is observed behavior over time. Requests below real need can cause contention or eviction; oversized requests waste schedulable capacity and can leave Pods Pending.

CPU can be throttled. Memory limits are stricter: exceeding one can cause an OOM kill. 100m CPU is one tenth of a logical CPU. Mi and Gi are binary units and are not identical to MB and GB.

~~~yaml
resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: "1"
    memory: 512Mi
~~~

These are examples only. Suitable values depend on startup, peaks, caches, and latency goals.

## Capacity and QoS

Pod requests contribute to the capacity the scheduler sees. Nodes also need room for the operating system and daemons; do not allocate the machine's nominal capacity entirely to applications. Request/limit combinations affect Pod QoS and eviction behavior under pressure, but a high QoS class does not replace accurate sizing and capacity planning.

## Quotas and measurement

ResourceQuota limits aggregate namespace consumption or object counts. LimitRange sets per-Pod/container defaults or ranges. Raising a quota without adding node capacity can simply turn an admission error into a scheduling problem. Track usage alongside latency, restarts, throttling, OOM, and SLOs; one snapshot is not enough for planning.

## Tuning process
1. Define workload and SLO.
2. Measure normal and peak use under representative load.
3. Compare use against requests and limits.
4. Change one value and inspect latency and capacity.
5. Update dashboards/policy and repeat after application changes.

## Quiz with answers

1. **Which value does the scheduler use for capacity planning?** Requests.
2. **What can a CPU limit do?** Throttle execution and increase latency.
3. **What can happen when memory exceeds its limit?** The container can be OOMKilled.
4. **What does a quota create?** A consumption/object-count boundary, not additional node capacity.
5. **Is average usage enough for requests?** No. Include peaks and workload variation.

## Further reading
- [Manage resources for containers and Pods](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Pod QoS classes](https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/)
- [ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/)
- [Reserve node resources](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/)
- [Kubernetes observability](https://kubernetes.io/docs/concepts/cluster-administration/observability/)
- [DevNA Persian beginner guide](https://devna.ir/articles/kubernetes-basics-for-beginners)
