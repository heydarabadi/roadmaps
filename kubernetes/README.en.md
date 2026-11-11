# Kubernetes: Complete Self-Study Course

**Languages:** [English](README.en.md) | [فارسی](README.md)

This course follows the topic structure of the [Kubernetes roadmap](https://roadmap.sh/kubernetes), cross-checked against the [official roadmap PDF](https://roadmap.sh/pdfs/roadmaps/kubernetes.pdf). Every roadmap chapter and topic has its own lesson in this folder. The English editions sit beside their Persian counterparts as README.en.md files.

The lessons teach the concepts, show worked examples, offer labs and troubleshooting guidance, and include quizzes with explained answers. External references are supplementary reading and the authoritative place to check version-specific API behavior, provider features, or an add-on's current configuration.

## How to study

1. Read Chapters 01–03 in order to build the mental model, understand containers, and prepare a cluster.
2. Read each lesson before applying its manifests in a disposable learning cluster.
3. Check your current context and namespace before every command that changes cluster state.
4. Answer the quiz before reading its key. Explain why each answer is correct.
5. Work through the [capstone lab](labs/capstone/README.en.md) while studying.
6. Use the [Persian–English glossary](glossary/README.en.md) to connect Kubernetes vocabulary across languages.
7. Consult the [curated reference library](references/README.en.md) for additional official documentation, maintainer guides, engineering articles, and case studies.

## Chapter map

| Chapter | Subject | Lesson |
| --- | --- | --- |
| 01 | Introduction, mental model, and alternatives | [01-introduction](01-introduction/README.en.md) |
| 02 | Containers and runtime foundations | [02-containers](02-containers/README.en.md) |
| 03 | Cluster setup and the first application | [03-setting-up-kubernetes](03-setting-up-kubernetes/README.en.md) |
| 04 | Applications and workload controllers | [04-running-applications](04-running-applications/README.en.md) |
| 05 | Services and networking | [05-services-networking](05-services-networking/README.en.md) |
| 06 | Configuration and sensitive data | [06-configuration-management](06-configuration-management/README.en.md) |
| 07 | Requests, limits, and resource planning | [07-resource-management](07-resource-management/README.en.md) |
| 08 | Cluster and workload security | [08-security](08-security/README.en.md) |
| 09 | Observability, logs, metrics, and traces | [09-monitoring-logging](09-monitoring-logging/README.en.md) |
| 10 | Horizontal, vertical, and node autoscaling | [10-autoscaling](10-autoscaling/README.en.md) |
| 11 | Storage and stateful workloads | [11-storage-volumes](11-storage-volumes/README.en.md) |
| 12 | Scheduling, priority, and Pod eviction | [12-scheduling](12-scheduling/README.en.md) |
| 13 | CI/CD, GitOps, Helm, and progressive delivery | [13-deployment-patterns](13-deployment-patterns/README.en.md) |
| 14 | CRDs, controllers, and Kubernetes extensions | [14-advanced-topics](14-advanced-topics/README.en.md) |
| 15 | Cluster operations and multi-cluster design | [15-cluster-operations](15-cluster-operations/README.en.md) |

Each chapter has a lesson and a topics directory. Each roadmap node has a dedicated README in both languages.

## Learning outcomes

By the end of the course, you should be able to:

- Explain the control plane, nodes, Pods, controllers, API objects, and reconciliation.
- Deploy workloads, expose them with Services, and keep configuration separate from images.
- Apply least-privilege access, network controls, resource requests and limits, autoscaling, and persistent storage.
- Use probes, events, logs, metrics, and traces to investigate ImagePullBackOff, Pending Pods, CrashLoopBackOff, and missing Service endpoints.
- Plan releases, rollbacks, GitOps workflows, node maintenance, and cluster upgrades while accounting for capacity and data compatibility.
- Recognize when built-in Kubernetes APIs are enough and when a provider or extension is required.

## Reference cases

The course discusses published operational experience, including [Michelin's Kubernetes platform case study from CNCF](https://www.cncf.io/case-studies/michelin/), [Netflix's Kueue batch-compute experience](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c), and [VSCO's Kubernetes migration story](https://www.cncf.io/blog/2019/02/20/how-vsco-saved-with-kubernetes/). These examples illustrate decisions made in specific organizations; evaluate their scale and constraints before applying them elsewhere.

The main teaching material is in this course. The reference links help verify current behavior and explore additional perspectives. The course does not claim to contain every page on the internet or every provider-specific operating procedure.

## Navigation

- [Persian main index](README.md)
- [English–Persian glossary](glossary/README.en.md)
- [Capstone lab](labs/capstone/README.en.md)
- [Curated reference library](references/README.en.md)
