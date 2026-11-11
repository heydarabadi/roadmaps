# Vertical Pod Autoscaler (VPA)
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#10-autoscaling)

[فارسی](README.md) | [Chapter 10](../../README.en.md) | [Resource management](../../../07-resource-management/README.en.md)

## What problem does VPA solve?

VPA recommends or manages CPU/memory resources for each Pod. The goal is right-sizing: requests that are too low create contention; requests above need waste schedulable capacity. VPA does not change the number of Pods—use HPA for replica count. Node capacity is a separate autoscaling concern.

VPA is installed as an extension/CRD and usually uses the metrics API:
- **Recommender:** analyzes recent/historical use, variation, and events such as OOM to produce target, lower-bound, and upper-bound recommendations.
- **Updater:** decides when an update should be applied; depending on mode and support, it may evict/recreate or resize a Pod.
- **Admission controller:** applies recommendations when a Pod is created.

Check Metrics Server and VPA compatibility with the Kubernetes version before rollout.

## Update modes

- **Off:** calculates recommendations but does not apply them automatically; useful for review.
- **Initial:** applies resources when a Pod is created, not to existing running Pods.
- **Recreate:** may evict Pods so a controller recreates them with new resources. Capacity, replicas, readiness, and PDBs matter.
- **InPlaceOrRecreate:** tries an in-place change; falls back to eviction/recreation when that is not possible.
- **InPlace:** behavior and availability depend on Kubernetes/VPA version and feature gates. Current Kubernetes documentation marks this mode alpha with specific version prerequisites; verify before relying on it.

The Auto mode is deprecated in newer VPA releases. Use an explicit update mode supported by your installed version.

## Safer start with recommendations

This example collects recommendations but does not automatically change resources:

~~~yaml
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
  name: api-vpa
  namespace: shop
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  updatePolicy:
    updateMode: Off
  resourcePolicy:
    containerPolicies:
      - containerName: api
        minAllowed:
          cpu: 100m
          memory: 128Mi
        maxAllowed:
          cpu: "2"
          memory: 2Gi
        controlledResources:
          - cpu
          - memory
        controlledValues: RequestsOnly
~~~

minAllowed/maxAllowed are guardrails, not performance goals. Inspect status recommendations and compare them with peak traffic, latency, throttling, OOM, and node capacity. If VPA never observed the peak, its recommendation may be too low.

RequestsOnly changes requests while leaving limits unchanged. Usage above a fixed limit can still cause throttling or OOM. RequestsAndLimits also adjusts limits according to policy. Choose based on the application and resource model.

## VPA, HPA, and disruption

CPU-based HPA utilization is relative to request. If VPA changes that CPU request, HPA's denominator changes and replica count may change; the VPA recommendation then observes the new load. This feedback loop can oscillate. If both are needed, separate signals and ownership—for example, HPA on request rate/queue length and VPA in recommendation mode.

Recreate can interrupt Pods. Check replicas, PDB, replacement capacity, and rollout health. A PDB does not prevent every failure, and VPA does not provide high availability.

## Rollout plan
1. Start with Off and collect recommendations under representative load.
2. Compare recommendations with requests, peak use, OOM/throttling, and node capacity.
3. Define min/max bounds and controlled resources.
4. Test on a low-risk workload and observe restarts and changes.
5. If using HPA, test controller interactions and watch for oscillation.
6. Measure node use, Pending Pods, SLOs, and cost after each change.

## Quiz with answers
1. **VPA versus HPA?** VPA sizes resources per Pod; HPA changes replica count.
2. **Why begin with Off?** Observe recommendations before enabling disruptive changes.
3. **What is the risk of Recreate?** A Pod may be evicted and replaced to apply resources.
4. **Does VPA add nodes?** No. Scheduling and node autoscaling are separate.
5. **How can VPA affect CPU-based HPA?** Changing CPU request changes utilization and can cause a feedback loop.
6. **Is InPlace always non-disruptive and available?** No. Version, feature gates, and resize limits matter; it may be alpha.

## Further reading
- [Kubernetes Vertical Pod Autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/vertical-pod-autoscale/)
- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/)
- [VPA project and source code](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)
- [Kubernetes resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
