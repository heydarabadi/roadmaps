<div dir="ltr" align="left">

# Chapter 15: Cluster Operations

**Persian edition:** [فارسی](../../../fa/kubernetes/15-cluster-operations/README.md) · **Reference library:** [Cluster operations resources](../references/README.md#15-cluster-operations)

## Learning objectives

- Compare the responsibilities and costs of self-managed and managed Kubernetes.
- Explain the roles and upgrade paths of the control plane, etcd, and worker nodes.
- Plan drains, upgrades, backups, and restores around disruption and capacity.
- Treat multiple clusters as additional operational boundaries, not just a larger cluster count.

## Day-to-day ownership

A production cluster is more than an API server. Teams must manage versions and patches, certificates, etcd, control-plane availability, node pools, CNI/CSI, DNS, identity, admission, observability, backups, capacity, on-call response, and disaster recovery. A managed service takes on some control-plane work, but application workloads and data remain your responsibility.

## Upgrade cycle

Plan upgrades using release notes, version-skew policy, and compatibility of CNI, CSI, and extensions. Verify backups and restore procedures; upgrade a non-production cluster first; then update the control plane and nodes in the order supported by your provider or bootstrap tooling. Cordon and drain nodes while respecting PodDisruptionBudgets and replacement capacity. Afterward, verify readiness, add-ons, and workload behavior.

## etcd and recovery

etcd stores Kubernetes API state. A snapshot that has never been restored is not a proven recovery plan. Encrypt backup files, limit access, store copies outside the failure domain, and maintain a practiced restore runbook. Application databases and persistent volumes need independent backup plans; an etcd snapshot does not contain all application data.

## Multiple clusters

Separate clusters can isolate environments, regions, tenants, or failure domains. They also multiply identity, DNS, policy, observability, upgrade, and data-replication work. An incorrect kubectl context can send a change to the wrong cluster. Every cluster needs a clear owner, purpose, version target, recovery path, and cost model.

## Real-world case

The CNCF 2025 annual report cites 441 business applications across 62 cloud and on-premises clusters for Michelin; its case-study page reports about 450 applications and the same 62 clusters. These are reported figures from different CNCF publications. The general lesson is that shared platform engineering and standardization matter at fleet scale. Do not infer that the same cluster count or topology suits another organization; use your own workloads, teams, and failure boundaries to decide.

## Quiz

1. Does kubeadm provision every server and add-on? — No. It bootstraps Kubernetes components; infrastructure and many add-ons are separate.
2. What should be planned before an upgrade? — Release notes, version compatibility, tested backup and restore, staging, drain, capacity, and recovery.
3. Why is an etcd snapshot alone insufficient? — Restore must be practiced, and workload volumes and application databases need separate backups.
4. What complexity does multi-cluster add? — Identity, network, policy, telemetry, upgrade, and data-management operations.
5. Why inspect kubectl context before a change? — To avoid applying it to the wrong cluster.

## References

- [Cluster administration](https://kubernetes.io/docs/concepts/cluster-administration/)
- [kubeadm reference](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
- [Upgrading a cluster](https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/)
- [CNCF Annual Report 2025](https://www.cncf.io/wp-content/uploads/2026/03/cncf_ar25_033126a.pdf)
- [Chapter bibliography](../references/README.md#15-cluster-operations)

</div>
