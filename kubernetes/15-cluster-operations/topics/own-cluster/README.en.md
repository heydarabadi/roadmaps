<div dir="ltr" align="left">

# Should You Manage Your Own Cluster?

**Chapter:** [Cluster operations](../../README.en.md) · **Persian:** [فارسی](README.md) · **More references:** [Cluster operations bibliography](../../../references/README.en.md#15-cluster-operations)

## Start with responsibility

Self-managed Kubernetes gives greater infrastructure control and places more work directly on your team: control plane, certificates, etcd, upgrades, CNI/CSI, node operating system, backups, and incidents. A managed service takes on some of that work, but it does not remove responsibility for workloads, data, IAM, policy, cost, or application recovery.

## Decision matrix

| Question | If yes |
| --- | --- |
| Does the on-call team know how to operate the control plane and network? | Self-management may be more practical |
| Do you require unusual infrastructure or organizational control? | Self-management may offer needed flexibility |
| Are engineering time and operational skills limited? | A managed offering may reduce maintenance work |
| Do you have a region, SLA, or policy constraint? | Compare current providers and alternatives against the requirement |
| Is the workload small and low traffic? | Compare a simpler container platform as well |

Total cost includes compute, storage, egress, support, add-ons, engineering time, and downtime. Provider prices and features change; evaluate them against current requirements instead of relying on a static estimate.

## Checklist before choosing

- Is an owner defined for each platform layer and incident?
- Have backup and restore been tested?
- Are upgrades, certificate rotation, and node replacement documented?
- Are CNI/CSI support and compatibility understood?
- Can the team respond at the level of availability the product needs?
- Is provider-specific identity, networking, and storage acceptable?

## Exercise

Create a responsibility matrix for one managed and one self-managed option. For each platform layer, mark who patches, monitors, backs up, restores, and responds to incidents. Include labor and outage costs in the comparison.

## Quiz

1. What does managed Kubernetes not remove? — Responsibility for application behavior, data, IAM, cost, and workload recovery.
2. What is a hidden cost of self-management? — Skilled staffing, incident response, and ongoing maintenance cycles.
3. When should a simpler platform be compared? — When the workload does not gain enough from Kubernetes orchestration to justify its operational cost.
4. Why test backup restore? — It proves the recovery path, while the existence of a snapshot alone proves little.

## References

- [Kubernetes production environment options](https://kubernetes.io/docs/setup/production-environment/turnkey-solutions/)
- [Production environment planning](https://kubernetes.io/docs/setup/production-environment/)
- [Amazon EKS concepts](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Google Kubernetes Engine overview](https://docs.cloud.google.com/kubernetes-engine/docs/about)
- [Azure Kubernetes Service concepts](https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts)
- [Chapter bibliography](../../../references/README.en.md#15-cluster-operations)

</div>
