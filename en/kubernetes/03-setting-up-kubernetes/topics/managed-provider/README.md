# Choose a Managed Kubernetes Provider
[Persian edition](../../../../../fa/kubernetes/03-setting-up-kubernetes/topics/managed-provider/README.md) · [Chapter references](../../../references/README.md#03-setting-up-kubernetes)

[فارسی](../../../../../fa/kubernetes/03-setting-up-kubernetes/topics/managed-provider/README.md) | [Chapter 03](../../README.md)

A managed provider operates part of the control plane or cluster lifecycle. Scope depends on the product and mode: EKS, GKE, or AKS alone does not tell you who manages nodes, networks, upgrades, backups, or incidents. Teams usually still own application code and images, workload security, identity, RBAC, data, capacity, and application on-call.

## Comparison criteria
1. **Control plane:** API availability, SLA, supported versions and retirement dates, upgrades, maintenance windows.
2. **Identity:** enterprise identity, short-lived credentials, and separation of cloud IAM from Kubernetes RBAC.
3. **Networking:** CNI, IP plan, DNS, egress/NAT, load balancers, private access, NetworkPolicy.
4. **Storage:** CSI, snapshots, encryption, zone topology, performance, reclaim behavior.
5. **Nodes:** node pools or serverless modes, autoscaling, OS images, draining, GPUs.
6. **Operations:** audit logs, metrics, alerts, support, and responsibility boundaries.
7. **Cost:** nodes, disks, load balancers, IPs, egress, NAT, logs, support, and engineering time.
8. **Portability:** identity, storage, ingress, CNI, and telemetry may create provider dependencies.
9. **Compliance:** region, data location, encryption, audit, and recovery needs.

Compare providers with one representative workload and the same assumptions about Pod count, CPU, memory, I/O, egress, logs, zones, and backups. VM price alone is not total cost; regional prices and features change.

## Decision example
An organization with strict audit requirements first sets required regions and operator-access rules, then compares identity, private networking, recovery, and version support. A small team may delegate the control plane but still needs owners for database backups, network policy, alerts, workload upgrades, and on-call.

- Who owns failures in the control plane, nodes, network, app, and database?
- Is API access private? How are administrator actions audited?
- When does the version lose support and how is it upgraded?
- When was a real restore last tested?
- Which components are provider-specific, and what is the exit plan?
- How are egress, NAT, load balancers, disks, and log retention priced?
- Who reviews workload health and cost?

## Quiz with explanations
1. **Does managed mean no SRE/on-call?** No. Workloads, data, network, security, capacity, and incident response still need owners.
2. **Does a standard Kubernetes API guarantee easy migration?** No. Identity, storage, load balancing, logging, and automation may be provider-specific.
3. **Why compare the same workload?** Different assumptions about I/O, egress, logs, and zones mislead.
4. **What should you read about shared responsibility?** The product/mode responsibility matrix, official operating guide, and support contract.
5. **Does a managed control plane necessarily include app database backups?** No. Cluster state and application data have separate backup responsibilities.

## Further reading
- [Kubernetes production environment](https://kubernetes.io/docs/setup/production-environment/)
- [Kubernetes provider options](https://kubernetes.io/docs/setup/production-environment/turnkey-solutions/)
- [Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [Google Kubernetes Engine](https://docs.cloud.google.com/kubernetes-engine/docs/about)
- [Azure Kubernetes Service concepts](https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts)
- [Learning environment in Persian](https://kubernetes.io/fa/docs/setup/learning-environment/)
- [Darvag Cloud Persian learning path](https://darvagcloud.com/blog/learning-kubernetes/)
