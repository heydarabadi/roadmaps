# Scheduling Basics
[Persian edition](../../../../../fa/kubernetes/12-scheduling/topics/basics/README.md) · [Chapter references](../../../references/README.md#12-scheduling)

[فارسی](../../../../../fa/kubernetes/12-scheduling/topics/basics/README.md) | [Chapter 12](../../README.md)

## Filter and score

For a Pod without a node, the scheduler first filters incompatible nodes, then chooses a preferred node from what remains. Resource requests, node conditions, affinity, taints, topology, and volume binding can affect the decision. A scheduling decision does not guarantee the application will remain healthy later.

~~~sh
kubectl get pods
kubectl describe pod demo
kubectl get nodes
kubectl describe node NODE_NAME
~~~

For a Pending Pod, Events often provide a more direct clue than guessing: Insufficient CPU, a taint, a PVC, a node selector, or quota. Lowering requests without checking real need may make scheduling succeed but create an unstable workload.

## Constraints and preference

nodeSelector and required affinity are hard constraints. Preferred affinity is a preference. Agree on node-label ownership and conventions. Changing labels/selectors can affect other workloads.

## Quiz
1. **Does Pending mean the scheduler is broken?** No. There may be no eligible node.
2. **Which resource value mainly guides placement?** Requests, not limits or momentary usage.
3. **How does preferred affinity differ from required affinity?** It does not necessarily block scheduling when no preferred node is available.
4. **Why inspect Events?** They report reasons a Pod could not be scheduled.

## Further reading
- [Scheduling concepts](https://kubernetes.io/docs/concepts/scheduling-eviction/)
- [Assign Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- [Resource requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Scheduler configuration](https://kubernetes.io/docs/reference/scheduling/config/)
