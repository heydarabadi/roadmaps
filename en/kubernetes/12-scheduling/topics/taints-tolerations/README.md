# Taints and Tolerations
[Persian edition](../../../../../fa/kubernetes/12-scheduling/topics/taints-tolerations/README.md) · [Chapter references](../../../references/README.md#12-scheduling)

[فارسی](../../../../../fa/kubernetes/12-scheduling/topics/taints-tolerations/README.md) | [Chapter 12](../../README.md)

## The two-sided relationship

A node taint tells the scheduler to keep Pods away unless they have a matching toleration. A Pod toleration allows it past that taint; it does not select or guarantee a node. Add affinity or a selector when placement must be preferred or required.

Effects:
- **NoSchedule:** a new Pod without a matching toleration is not scheduled there.
- **PreferNoSchedule:** the scheduler tries to avoid the node when possible.
- **NoExecute:** an intolerant Pod can be evicted from the node.

~~~sh
kubectl taint nodes NODE_NAME workload=gpu:NoSchedule
kubectl taint nodes NODE_NAME workload=gpu:NoSchedule-
~~~

The first command is for a lab. Check the node and effect before changing a shared cluster; an incorrect taint can block scheduling.

## Uses and traps

Taints can reserve nodes for GPUs, operations, or sensitive workloads. Do not grant every Pod a broad toleration, or the separation becomes ineffective. Pair taints/tolerations with labels and affinity for dedicated placement.

## Quiz
1. **Where is a taint defined?** On a node.
2. **Where is a toleration defined?** In the Pod spec.
3. **Does a toleration assign a Pod to the node?** No; it removes one scheduling barrier.
4. **Which effect can evict an existing Pod?** NoExecute.

## Further reading
- [Taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- [Assign Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- [Pod priority and preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)
