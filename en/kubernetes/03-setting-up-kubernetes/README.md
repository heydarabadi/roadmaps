# Chapter 03: Setting Up Kubernetes
[Persian edition](../../../fa/kubernetes/03-setting-up-kubernetes/README.md) · [Chapter references](../references/README.md#03-setting-up-kubernetes)

[فارسی](../../../fa/kubernetes/03-setting-up-kubernetes/README.md) | [Course index](../README.md)

## Learning objectives
- Create a local cluster and identify its active context.
- Deploy a first application and inspect its Service.
- Compare managed and self-managed clusters by cost and responsibility.
- Distinguish a learning cluster from production.

## Workflow
Install kubectl and a local-cluster tool; create the cluster; inspect nodes; apply a Deployment and Service; inspect status, events, logs, and endpoints; then remove practice resources.

## Context and namespace safety

kubectl uses a kubeconfig and context to select the cluster and identity. Before every state-changing command, check the active context and namespace. A production context or wrong namespace can make a typo costly.

~~~sh
kubectl config get-contexts
kubectl config current-context
kubectl cluster-info
kubectl get nodes
~~~

## Managed or self-managed?

| Area | Managed | Self-managed |
| --- | --- | --- |
| Control plane | Provider operates part of its lifecycle | Team installs, provides HA, backs up, and upgrades |
| Workers | Team still manages node pools and workloads | Team also owns node OS, runtime, and lifecycle |
| Cloud integration | IAM, load balancers, and CSI may be integrated | More flexibility and more integrations to operate |
| Responsibility | Workloads, data, RBAC, cost, and app recovery remain with the team | Most infrastructure layers also remain with the team |

Check current provider features, SLA, region, identity model, and price. These change; use live provider documentation.

## Operational experience

Self-managed clusters need practiced recovery procedures for etcd, certificates, upgrades, and networking. Without drills, more control can mean slower recovery. CNCF's Michelin case illustrates why shared platform patterns matter across clusters.

## Quiz with answers

1. **What does the kubectl context select?** — The cluster and identity used for requests; the namespace can also come from context configuration or a command flag.
2. **Is a local cluster suitable for production?** — It is usually for learning and development; production requires availability, security, backup, capacity, and support planning.
3. **Does managed Kubernetes remove application responsibility?** — No. Teams still own workload behavior, data, access, cost, and application recovery.
4. **What should you check before a state-changing kubectl command?** — The active context and target namespace.
5. **Can provider features and prices be assumed from an older guide?** — No. Check current provider documentation and contracts.
## Further reading
- [Kubernetes learning environment](https://kubernetes.io/docs/setup/learning-environment/)
- [Kubernetes learning environment in Persian](https://kubernetes.io/fa/docs/setup/learning-environment/)
- [Production environment guidance](https://kubernetes.io/docs/setup/production-environment/)
- [Turnkey/provider solutions](https://kubernetes.io/docs/setup/production-environment/turnkey-solutions/)
- [kind Quick Start](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [minikube Start](https://minikube.sigs.k8s.io/docs/start/)
- [Michelin CNCF case study](https://www.cncf.io/case-studies/michelin/)
