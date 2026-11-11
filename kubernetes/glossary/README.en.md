<div dir="ltr" align="left">

# Kubernetes Glossary

**Persian edition:** [واژه‌نامهٔ فارسی](README.md) · **Reference library:** [Kubernetes references](../references/README.en.md)

| Term | Meaning |
| --- | --- |
| Cluster | The control plane and the machines that run workloads |
| Control plane | Components that expose the API and manage cluster state |
| Node | A machine on which Pods run |
| API server | The Kubernetes API endpoint and front door for resource operations |
| etcd | Key-value store for Kubernetes API state |
| Scheduler | Component that selects a node for an unscheduled Pod |
| Controller | A loop that moves actual state toward desired state |
| Reconciliation | Repeatedly comparing and converging actual and desired state |
| Pod | Scheduling unit that contains one or more containers |
| Container | An isolated process using the host kernel |
| Image / registry | Application package / repository that stores and distributes images |
| Deployment | Controller for stateless application rollouts and replica management |
| ReplicaSet | Controller that maintains a desired number of matching Pods |
| StatefulSet | Workload controller for stable identity and persistent storage patterns |
| Job | Controller for finite work that should run to completion |
| Service | Stable network abstraction for accessing a group of endpoints |
| EndpointSlice | Scalable list of backends associated with a Service |
| Ingress | HTTP(S) routing API that requires an implementation/controller |
| CNI / CSI | Container Network Interface / Container Storage Interface |
| ConfigMap / Secret | Object for non-confidential configuration / object for sensitive data |
| Namespace | Logical scope for names and some resource policies |
| RBAC | Role-based access control |
| Request / limit | Resource amount used for scheduling / upper consumption bound |
| Probe | Check that reports a container or Pod condition |
| Readiness / liveness | Whether a Pod should receive traffic / whether a container should be restarted |
| HPA / VPA | Horizontal Pod Autoscaler / Vertical Pod Autoscaler |
| GitOps | Reconciliation of declared state from a version-controlled source |
| CRD / Operator | Custom API type / operational pattern built around controllers and custom resources |
| Eviction / PDB | Voluntary Pod removal / policy for permitted voluntary disruption |
| Rollout / rollback | Release progression / return to an earlier version; not necessarily data recovery |
| Observability | Understanding system behavior using signals such as logs, metrics, and traces |
| Cordon / drain | Mark node unschedulable / evict eligible Pods for maintenance |
| Canary / Blue-Green | Gradual candidate exposure / separate candidate environment and route cutover |
| SLO / SLI | Service-level objective / service-level indicator used to measure it |
| Desired state | The declared configuration the control loops should converge toward |

## Further reading

- [Official Kubernetes glossary](https://kubernetes.io/docs/reference/glossary/)
- [Kubernetes concepts](https://kubernetes.io/docs/concepts/)
- [Course reference library](../references/README.en.md)

</div>
