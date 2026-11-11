# Chapter 12: Scheduling, Priority, and Eviction
[Persian edition](../../../fa/kubernetes/12-scheduling/README.md) · [Chapter references](../references/README.md#12-scheduling)

[فارسی](../../../fa/kubernetes/12-scheduling/README.md) | [Course index](../README.md)

## Learning objectives
- Explain how the scheduler filters unsuitable nodes and ranks feasible ones.
- Use requests, affinity, taints, topology, and capacity in placement.
- Distinguish voluntary disruption from forced eviction.
- Design availability with PDBs and failure-domain spreading.

## Scheduler cycle

A new Pod starts without a node. The scheduler filters nodes: is there enough requested capacity? Do selector and affinity constraints match? Are taints tolerated? Can volumes attach in the node topology? It then scores feasible nodes and binds the Pod. If none are suitable, the Pod stays Pending and an event reports why.

The scheduler does not predict actual application usage; requests and constraints guide placement. Incorrect requests can create poor packing or Pending Pods.

## Placement controls
- nodeSelector and required node affinity can constrain placement.
- Preferred affinity is a preference, not a hard requirement.
- A node taint repels Pods without matching tolerations.
- Topology spread distributes replicas across nodes or zones.
- PriorityClass expresses importance; preemption may remove lower-priority Pods.

Every hard constraint can reduce availability if the cluster lacks eligible nodes. Derive constraints from real needs such as GPUs, compliance, or zone separation.

## Disruption and eviction

The kubelet may evict Pods under memory/disk pressure. Draining and some maintenance operations cause voluntary disruption. A PodDisruptionBudget limits voluntary disruptions at a time. It does not stop a sudden node failure and cannot replace replicas or zone spread.

## Operational example

Multi-tenant batch computing needs queueing and capacity policy. Netflix describes its use of Kueue for batch workload queueing and capacity management. The lesson is that scheduling involves tenant fairness and priority as well as whether a Pod fits a node; compare their system scale with yours.

## Practice
1. Create a Pod with a request larger than total node capacity and read its Pending event.
2. Taint a learning node and compare Pods with and without a toleration.
3. Spread replicas across topology domains.
4. Create a PDB and test drain behavior in a local cluster.

## Quiz
1. **When does the scheduler bind a Pod?** After it filters and scores feasible nodes.
2. **Does a toleration guarantee node selection?** No. It only permits the Pod to tolerate a taint.
3. **Does a PDB prevent sudden node/power failure?** No. It mainly governs voluntary disruption.
4. **Does priority create capacity?** No. It changes scheduling importance and possible preemption.
5. **Why spread replicas across zones?** To avoid putting every replica in one failure domain.

## Further reading
- [Scheduling, preemption, and eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/)
- [Topology spread constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/)
- [Taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- [Pod priority and preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)
- [Pod disruptions and PDBs](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [Scheduler configuration and plugins](https://kubernetes.io/docs/reference/scheduling/config/)
- [Kueue overview](https://kueue.sigs.k8s.io/docs/overview/)
- [Netflix production Kueue experience](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c)
