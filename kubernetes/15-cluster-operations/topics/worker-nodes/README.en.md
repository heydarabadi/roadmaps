<div dir="ltr" align="left">

# Adding and Managing Worker Nodes

**Chapter:** [Cluster operations](../../README.en.md) · **Persian:** [فارسی](README.md) · **More references:** [Cluster operations bibliography](../../../references/README.en.md#15-cluster-operations)

## Node readiness

A node needs a compatible kubelet, container runtime, network plugin, and allocatable capacity. In a managed cluster, a node pool is integrated with the provider; in a self-managed cluster, the team also manages the operating system, patches, certificates, and join process.

Node condition Ready does not prove every workload is healthy. Check DiskPressure, MemoryPressure, PIDPressure, and networking. Labels, taints, topology, and device plugins also affect scheduling.

## Maintenance and upgrades

For maintenance, cordon a node so new Pods are not scheduled there, then drain it so eligible Pods are evicted and can move elsewhere. Check PodDisruptionBudgets and replacement capacity. After patching or upgrading, verify runtime and CNI health before uncordoning.

Drain may be blocked by a PDB, local storage, or missing capacity. Force deletion is a last resort because it can cause data loss or violate application availability.

~~~sh
kubectl cordon NODE_NAME
kubectl drain NODE_NAME --ignore-daemonsets
kubectl get nodes
kubectl uncordon NODE_NAME
~~~

Use these commands only on a training or maintenance target after understanding their effects. In production, follow the provider and workload runbooks.

## Exercise

In a local cluster with a disposable node, record which Pods move during drain, which DaemonSets remain, and what happens when a PDB prevents voluntary disruption. Restore the node and confirm workloads are healthy.

## Quiz

1. What does cordon do? — Marks a node unschedulable for new Pods.
2. What does drain do? — Evicts eligible Pods so the node can be maintained.
3. Why can drain be blocked? — PDBs, local storage, or lack of replacement capacity.
4. What should be checked after an upgrade? — Ready condition, version, kubelet/runtime, CNI, and workloads.
5. Do DaemonSet Pods normally move off a node during drain? — They are managed per node and are normally ignored by the drain command.

## References

- [Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)
- [Safely drain a node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)
- [Upgrade a cluster](https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/)
- [kubectl drain reference](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_drain/)
- [Chapter bibliography](../../../references/README.en.md#15-cluster-operations)

</div>
