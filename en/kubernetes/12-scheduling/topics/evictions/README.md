# Eviction and Pod Disruption
[Persian edition](../../../../../fa/kubernetes/12-scheduling/topics/evictions/README.md) · [Chapter references](../../../references/README.md#12-scheduling)

[فارسی](../../../../../fa/kubernetes/12-scheduling/topics/evictions/README.md) | [Chapter 12](../../README.md)

## Separate voluntary and involuntary disruption

Under memory or disk pressure, kubelet may evict a Pod. A node drain or some maintenance operations cause voluntary disruption. A PodDisruptionBudget specifies minimum availability or the maximum voluntary disruptions at a time, preventing maintenance from removing too many replicas at once.

A PDB does not prevent involuntary failure, process crashes, or a sudden node outage. If a service has one replica, a PDB cannot create a replacement. Replicas, topology spread, resource requests, and graceful shutdown are still required.

~~~yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-budget
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: api
~~~

If the workload has only two replicas, minAvailable=2 can block a drain. Align replica count and maintenance policy.

## Quiz
1. **Which disruption does a PDB mainly control?** Voluntary disruptions through the eviction API.
2. **Can a PDB stop a node crash?** No.
3. **A drain is blocked by a PDB; what do you review?** Replicas, minAvailable/maxUnavailable, Pod health, and spare capacity.
4. **Why does involuntary eviction happen?** Node resource pressure or another emergency condition.

## Further reading
- [Pod disruptions and PDBs](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [Node-pressure eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/)
- [kubectl drain](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_drain/)
- [PodDisruptionBudget API reference](https://kubernetes.io/docs/reference/kubernetes-api/policy/pod-disruption-budget-v1/)
- [Safely drain a node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)
