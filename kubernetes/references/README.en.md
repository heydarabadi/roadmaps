<div dir="ltr" align="left">

# Kubernetes Course: Curated Reference Library

[Persian resource guide](README.md) · [English course index](../README.en.md) · [فهرست فارسی](../README.md)

This topic-based collection adds official documentation, maintained project guides, technical articles, research, and production case studies to the lessons. Prefer official documentation for version-dependent behavior. Case-study numbers and architectures are context-specific examples, not universal recommendations. This is a curated bibliography, not an exhaustive crawl of the web.

<a id="01-introduction-and-mental-model"></a>
## 01. Introduction and the mental model

- [Kubernetes overview](https://kubernetes.io/docs/concepts/overview/) — capabilities, scope, and what Kubernetes does not provide.
- [Concepts index](https://kubernetes.io/docs/concepts/) · [cluster architecture](https://kubernetes.io/docs/concepts/architecture/) · [components](https://kubernetes.io/docs/concepts/overview/components/).
- [Official glossary](https://kubernetes.io/docs/reference/glossary/) and [interactive Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/).
- [Kubernetes at GitHub — GitHub Engineering](https://github.blog/engineering/kubernetes-at-github/) — production migration and operating-model lessons.
- [Spotify case study — CNCF](https://www.cncf.io/case-studies/spotify/) — platform adoption and developer workflow.
- فارسی: [مستندات رسمی فارسی Kubernetes](https://kubernetes.io/fa/docs/home/) · [آموزش مقدماتی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="02-containers-and-images"></a>
## 02. Containers and images

- [Images](https://kubernetes.io/docs/concepts/containers/images/) and [container runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/) — Kubernetes image and runtime behavior.
- [OCI Runtime Specification](https://github.com/opencontainers/runtime-spec) · [containerd documentation](https://containerd.io/docs/).
- Docker: [build best practices](https://docs.docker.com/build/building/best-practices/) · [multi-stage builds](https://docs.docker.com/build/building/multi-stage/).
- [NIST SP 800-190: Application Container Security Guide](https://csrc.nist.gov/pubs/sp/800/190/final) — security across the container stack.
- فارسی: [آموزش مقدماتی Kubernetes از DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="03-setting-up-kubernetes"></a>
## 03. Setting up Kubernetes

- [Official setup guide](https://kubernetes.io/docs/setup/) · [production environment planning](https://kubernetes.io/docs/setup/production-environment/).
- [kubeadm installation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) — bootstrap a self-managed cluster.
- Local clusters: [kind quick start](https://kind.sigs.k8s.io/docs/user/quick-start/) · [minikube start](https://minikube.sigs.k8s.io/docs/start/).
- Managed platforms: [Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) · [GKE](https://docs.cloud.google.com/kubernetes-engine/docs/about) · [AKS](https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts).
- فارسی: [محیط یادگیری رسمی](https://kubernetes.io/fa/docs/setup/learning-environment/) · [راهنمای فارسی Docker و Kubernetes](https://blog.pasargadmizban.com/blog/amoozesh-docker-kubernetes).

<a id="04-running-applications"></a>
## 04. Running applications

- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/) · [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) · [ReplicaSets](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/).
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) · [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) · [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/).
- [Startup, readiness, and liveness probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/) · [Pod disruptions and PDBs](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/).
- [Kubernetes at GitHub](https://github.blog/engineering/kubernetes-at-github/) — production workload migration and deployment experience.
- فارسی: [DevNA: Pod، Deployment و Service](https://devna.ir/articles/kubernetes-basics-for-beginners) · [دورهٔ فارسی Kubernetes برای توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="05-services-and-networking"></a>
## 05. Services and networking

- [Networking concepts](https://kubernetes.io/docs/concepts/services-networking/) · [Service](https://kubernetes.io/docs/concepts/services-networking/service/) · [EndpointSlices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/).
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) requires an implementation; compare with the [Gateway API](https://gateway-api.sigs.k8s.io/).
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) · [cluster networking requirements](https://kubernetes.io/docs/concepts/cluster-administration/networking/).
- [Celonis networking across 150+ clusters — CNCF case study](https://www.cncf.io/case-studies/celonis/) — fleet-wide CNI standardization and migration.
- فارسی: [آموزش Service در راهنمای DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="06-configuration-management"></a>
## 06. Configuration management

- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) · [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).
- [Secret good practices](https://kubernetes.io/docs/concepts/security/secrets-good-practices/) · [encrypt API data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).
- [Projected volumes](https://kubernetes.io/docs/concepts/storage/projected-volumes/) · [External Secrets Operator](https://external-secrets.io/latest/).
- فارسی: [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ فارسی توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="07-resource-management"></a>
## 07. Resource management

- [Resource requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) · [Pod QoS](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/).
- [ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/) · [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/) · [node-pressure eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/).
- [GKE scalability testing lessons — Google Cloud](https://cloud.google.com/blog/products/containers-kubernetes/lessons-learned-from-scalability-testing-google-kubernetes-engine/) — test bottlenecks and observability before production scale.
- [Datadog engineering case: Kubernetes autoscaling](https://www.datadoghq.com/blog/how-we-saved-with-kubernetes-autoscaling/) — resource optimization and reliability tradeoffs.
- فارسی: [دورهٔ فارسی توسعه‌دهندگان Kubernetes](https://faragiri.com/learning/kubernetes-developer/).

<a id="08-security"></a>
## 08. Security

- [Kubernetes security concepts](https://kubernetes.io/docs/concepts/security/) and [security checklist](https://kubernetes.io/docs/concepts/security/security-checklist/).
- [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) · [Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/).
- [RBAC good practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/) · [Secret good practices](https://kubernetes.io/docs/concepts/security/secrets-good-practices/).
- [Admission webhook good practices](https://kubernetes.io/docs/concepts/cluster-administration/admission-webhooks-good-practices/).
- [NSA/CISA Kubernetes Hardening Guidance](https://www.nsa.gov/Press-Room/News-Highlights/Article/Article/2716980/nsa-cisa-release-kubernetes-hardening-guidance/) · [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes).
- فارسی: [مستندات رسمی فارسی Kubernetes](https://kubernetes.io/fa/docs/home/) · [راهنمای فارسی Docker و Kubernetes](https://blog.pasargadmizban.com/blog/amooz-docker-kubernetes).

<a id="09-monitoring-logging-and-tracing"></a>
## 09. Monitoring, logging, and tracing

- [Observability concepts](https://kubernetes.io/docs/concepts/cluster-administration/observability/) · [resource-usage monitoring](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/).
- [Logging architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/) · [debugging applications](https://kubernetes.io/docs/tasks/debug/).
- [OpenTelemetry on Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/) · [Prometheus with OpenTelemetry](https://prometheus.io/docs/guides/opentelemetry/).
- [Monitoring distributed systems — Google SRE Workbook](https://sre.google/workbook/monitoring/) — SLI, monitoring, and alerting principles.
- فارسی: [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ فارسی توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="10-autoscaling"></a>
## 10. Autoscaling

- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) · [Vertical Pod Autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/vertical-pod-autoscale/).
- [Cluster Autoscaler](https://kubernetes.io/docs/concepts/cluster-administration/node-autoscaling/) · [Karpenter](https://karpenter.sh/docs/) — node provisioning; check provider and version support.
- [KEDA](https://keda.sh/docs/) — event-driven workload scaling and scaler documentation.
- [Datadog autoscaling engineering case](https://www.datadoghq.com/blog/how-we-saved-with-kubernetes-autoscaling/) · [GKE scale testing lessons](https://cloud.google.com/blog/products/containers-kubernetes/lessons-learned-from-scalability-testing-google-kubernetes-engine/).
- فارسی: [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ فارسی Kubernetes](https://faragiri.com/learning/kubernetes-developer/).

<a id="11-storage-and-volumes"></a>
## 11. Storage and volumes

- [Storage concepts](https://kubernetes.io/docs/concepts/storage/) · [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
- [Persistent Volumes and Claims](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) · [StorageClasses](https://kubernetes.io/docs/concepts/storage/storage-classes/).
- [Container Storage Interface](https://kubernetes-csi.github.io/docs/) · [Volume snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/).
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) · [CERN Kubernetes case study](https://v1-34.docs.kubernetes.io/case-studies/cern/) (older case study; review its publication context).
- فارسی: [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ فارسی توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="12-scheduling"></a>
## 12. Scheduling

- [Scheduling, preemption, and eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/) · [assign Pods to nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
- [Taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) · [priority and preemption](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).
- [Topology spread constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) · [Pod disruptions and PDBs](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/).
- [Kueue overview](https://kueue.sigs.k8s.io/docs/overview/) · [Netflix engineering: simplifying batch compute with Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c).
- فارسی: [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ فارسی Kubernetes](https://faragiri.com/learning/kubernetes-developer/).

<a id="13-deployment-and-delivery"></a>
## 13. Deployment and delivery

- [Deployments and rollout behavior](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).
- [Helm documentation](https://helm.sh/docs/) · [chart best practices](https://helm.sh/docs/chart_best_practices/).
- GitOps: [Argo CD](https://argo-cd.readthedocs.io/en/stable/user-guide/) · [Flux](https://fluxcd.io/flux/) · [OpenGitOps principles](https://opengitops.dev/).
- Progressive delivery: [Argo Rollouts](https://argoproj.github.io/argo-rollouts/) · [Flagger](https://docs.flagger.app/).
- Supply chain and CI: [SLSA framework](https://slsa.dev/) · [GitHub Actions deploy to Kubernetes](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-kubernetes).
- فارسی: [مستندات رسمی فارسی Kubernetes](https://kubernetes.io/fa/docs/home/) · [آموزش مقدماتی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="14-advanced-topics-and-extensibility"></a>
## 14. Advanced topics and extensibility

- [Extending Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/) · [custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/).
- [CRD authoring task guide](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/) · [controller pattern](https://kubernetes.io/docs/concepts/architecture/controller/).
- [Kubebuilder Book](https://book.kubebuilder.io/) · [Operator SDK](https://sdk.operatorframework.io/docs/).
- [Admission controllers](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) · [webhook good practices](https://kubernetes.io/docs/concepts/cluster-administration/admission-webhooks-good-practices/).
- [Scheduling Framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/).
- فارسی: [مستندات رسمی فارسی Kubernetes](https://kubernetes.io/fa/docs/home/) (همهٔ مباحث پیشرفته ترجمه نشده‌اند).

<a id="15-cluster-operations"></a>
## 15. Cluster operations

- [Cluster administration](https://kubernetes.io/docs/concepts/cluster-administration/) · [cluster upgrade](https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/) · [safely drain a node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/).
- [kubeadm upgrades](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/) · [etcd recovery guide](https://etcd.io/docs/v3.5/op-guide/recovery/) (match it to the deployed etcd version).
- [Michelin CNCF case study](https://www.cncf.io/case-studies/michelin/) · [CNCF Annual Report 2025](https://www.cncf.io/wp-content/uploads/2026/03/cncf_ar25_033126a.pdf) — platform and multi-cluster experience.
- [Pinterest Kubernetes case study](https://v1-32.docs.kubernetes.io/case-studies/pinterest/) · [Spotify CNCF case study](https://www.cncf.io/case-studies/spotify/) · [GitHub engineering migration](https://github.blog/engineering/kubernetes-at-github/).
- [GKE scalability testing lessons](https://cloud.google.com/blog/products/containers-kubernetes/lessons-learned-from-scalability-testing-google-kubernetes-engine/) · [Mutiny! Kubernetes failure-pattern research](https://arxiv.org/abs/2404.11169).
- فارسی: [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [آموزش و تمرین روی سرور](https://blog.pasargadmizban.com/blog/amooz-docker-kubernetes).

## Persian learning links

These provide Persian-language orientation and practice. They are supplementary; use the official sources above for current API details and version-sensitive behavior.

- [مستندات رسمی Kubernetes به فارسی](https://kubernetes.io/fa/docs/home/)
- [آموزش و گواهی‌های رسمی Kubernetes به فارسی](https://kubernetes.io/fa/training/)
- [DevNA — کوبرنتیز برای مبتدی‌ها؛ از Pod تا Service](https://devna.ir/articles/kubernetes-basics-for-beginners)
- [Faragiri — کوبرنتیز برای توسعه‌دهندگان در ۴۴ درس](https://faragiri.com/learning/kubernetes-developer/)
- [EasyEnv — آموزش فارسی Kubernetes از Pod تا Production](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
- [پاسارگاد میزبان — Docker و Kubernetes و تمرین روی سرور](https://blog.pasargadmizban.com/blog/amooz-docker-kubernetes)

</div>
