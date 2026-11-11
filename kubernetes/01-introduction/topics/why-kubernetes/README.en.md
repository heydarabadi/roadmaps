# Why Kubernetes?
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#01-introduction-and-mental-model)

[فارسی](README.md) | [Chapter 01](../../README.en.md)

## Learning objective

Separate Kubernetes' practical value from slogans such as “automatic scaling,” then weigh benefits and operating costs for a real workload.

## The problem before orchestration

When several application copies run across several machines, a team must coordinate process placement, health, releases, traffic changes, and replacement after failure. Manual commands and scattered scripts make the result depend on people and command order.

Kubernetes standardizes parts of this work through APIs and controllers:

- Declare desired state and review changes in Git or a delivery pipeline.
- Use Deployments to manage replicas and releases of stateless workloads.
- Use Services to provide stable discovery for changing Pod addresses.
- Let the scheduler place workloads according to resource requests and constraints.
- Report startup, readiness, and liveness through probes.
- Build automation around a shared API and an ecosystem of extensions.

These benefits have costs. Someone still operates nodes, networking, storage, identities, security, upgrades, capacity, and observability. Kubernetes can also repeat a bad configuration continuously.

## Example: an online store

Imagine a storefront, API, and queue worker:

- A stateless storefront can run as several Deployment replicas.
- A Service discovers API Pods and updates endpoints as replicas change.
- A worker can scale independently, but HPA needs a useful metric and the cluster needs capacity.
- A database is stateful. Running it in the cluster requires backup, storage, replication, and restore design.

A small team might use a managed database and run only application APIs in Kubernetes. “Put everything in the cluster” is not an architecture rule.

## Evaluate total cost of ownership

Direct cost includes control-plane and machine charges. Indirect cost includes engineering time, learning, on-call, add-ons, egress, storage, monitoring, and incidents. Estimate these for your workload and growth. If repeatable releases and standardization do not justify that cost, a simpler option may be better.

## Published case experience

CNCF's Michelin case describes a platform supporting hundreds of applications across several clusters. Such scale can justify investment in self-service and shared operations. Do not infer that every product needs the same architecture; first assess team count, release frequency, and on-call capacity.

## When not to choose Kubernetes

- One small application has infrequent releases.
- A managed container service already meets the requirements.
- The team cannot respond to cluster, network, and storage failures.
- Compliance, budget, or product simplicity conflicts with the platform's complexity.

## Quiz

1. **What does “self-healing” actually repair?** Controllers may replace Pods or restart containers. They do not automatically fix application bugs or external dependency outages.
2. **Why use a Service?** Pod IPs can change; a Service gives clients a stable way to reach a selected set of Pods.
3. **What can happen when HPA has no cluster autoscaler?** HPA can request more Pods, but they may remain Pending if nodes lack capacity.
4. **Give one sign that Kubernetes is a good fit and one sign it is not.** Frequent multi-service releases may justify it; a simple workload with little operational need may be better on simpler hosting.

## Further reading

- [Kubernetes overview](https://kubernetes.io/docs/concepts/overview/)
- [Michelin CNCF case study](https://www.cncf.io/case-studies/michelin/)
- [VSCO's Kubernetes migration experience](https://www.cncf.io/blog/2019/02/20/how-vsco-saved-with-kubernetes/)
- [A production Kubernetes case study](https://mpurayil.com/blog/kubernetes-production-case-study)
- [DevNA: Kubernetes basics](https://devna.ir/articles/kubernetes-basics-for-beginners)
