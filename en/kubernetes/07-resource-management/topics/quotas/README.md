# Namespace Quotas and LimitRanges
[Persian edition](../../../../../fa/kubernetes/07-resource-management/topics/quotas/README.md) · [Chapter references](../../../references/README.md#07-resource-management)

[فارسی](../../../../../fa/kubernetes/07-resource-management/topics/quotas/README.md) | [Chapter 07](../../README.md)

## Multi-team consumption

A ResourceQuota limits aggregate resources or object counts in a namespace. A LimitRange defines defaults or allowed ranges for Pods/containers. Together they prevent unbounded consumption, but do not replace capacity planning or cost management.

~~~yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: team-budget
  namespace: team-a
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    pods: "30"
~~~

The values are examples. Align actual quotas with cluster capacity, team count, and service tier. When a quota is exhausted, the API rejects new objects. If a quota is raised but nodes lack capacity, Pods may later remain Pending.

## Design and troubleshoot

Inspect quota status, rejection events, workload requests/limits, and namespace consumption together. Document LimitRange defaults: a bad default can throttle or OOM an application. Allocate quota with bursts and emergency workloads in mind.

## Quiz
1. **At what scope is a ResourceQuota normally applied?** Namespace.
2. **Does quota produce node capacity?** No; it constrains admission and consumption.
3. **What should you assess after raising a quota?** Node capacity and cost impact.
4. **What does LimitRange do?** Applies defaults and bounds to new objects.

## Further reading
- [ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/)
- [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [Resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
