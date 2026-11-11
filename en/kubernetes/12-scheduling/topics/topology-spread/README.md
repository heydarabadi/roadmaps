# Pod Topology Spread Constraints
[Persian edition](../../../../../fa/kubernetes/12-scheduling/topics/topology-spread/README.md) · [Chapter references](../../../references/README.md#12-scheduling)

[فارسی](../../../../../fa/kubernetes/12-scheduling/topics/topology-spread/README.md) | [Chapter 12](../../README.md)

## Spread replicas

If every replica is on one node or zone, a failure there can remove all replicas. Topology spread constraints distribute matching Pods across domains, commonly represented by node labels such as zone or hostname.

~~~yaml
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        app: api
~~~

maxSkew is the allowed difference in matching Pod counts between domains. DoNotSchedule is a hard constraint; if no suitable domain exists, a Pod can remain Pending. ScheduleAnyway is a preference and may not achieve an even spread.

## Design and failure domains

Node topology labels must be correct and each zone needs capacity. Topology spread complements replicas and PDBs; it does not replace them or protect against a whole region or shared dependency failing.

Compare topology spread with Pod anti-affinity: anti-affinity can repel Pods, while spread constraints give finer control over skew across domains. Selector labels must match the workload's Pods.

## Quiz
1. **Why add a spread constraint?** Distribute load and reduce failure impact in one domain.
2. **What is the cost of DoNotSchedule?** A Pod may remain Pending without an eligible domain.
3. **How are Pods counted?** With the labelSelector.
4. **Does zone spread protect against region loss?** No. Plan for larger failure domains and shared dependencies too.

## Further reading
- [Topology spread constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/)
- [Pod topology labels](https://kubernetes.io/docs/reference/labels-annotations-taints/)
- [Assign Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- [Introducing PodTopologySpread](https://kubernetes.io/blog/2020/05/introducing-podtopologyspread/)
