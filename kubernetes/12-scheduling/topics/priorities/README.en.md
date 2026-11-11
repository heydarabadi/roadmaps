# Pod Priority and Preemption
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#12-scheduling)

[فارسی](README.md) | [Chapter 12](../../README.en.md)

## Importance and effect

A PriorityClass assigns a numeric priority to Pods. If no suitable node has room for a high-priority Pod, the scheduler may preempt lower-priority Pods to make space. Higher priority does not add capacity; it changes order and possible preemption.

It can make sense for a critical service to outrank a test job, but every team may claim to be critical. Govern class names, ownership, and allocation policy. Preemption can interrupt other work; PDBs affect victim selection and eviction.

## Policy
- Define a small set of named classes with explicit owners.
- Restrict who can use the highest values.
- Use ResourceQuota to limit consumption at sensitive priority levels.
- Test graceful termination and recovery of preempted work.
- Do not rely on priority to compensate for a capacity shortage.

## Quiz
1. **What is PriorityClass for?** Relative Pod importance and scheduling/preemption behavior.
2. **Does high priority add nodes?** No.
3. **Why govern PriorityClasses?** Misuse can evict other workloads or prevent them from scheduling.
4. **Does preemption always work?** No. Constraints, PDBs, and lack of a feasible node may prevent it.

## Further reading
- [Pod priority and preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)
- [Pod disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [ResourceQuota and priority classes](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
