<div dir="rtl" align="right">

# کتابخانهٔ منابع دورهٔ Kubernetes

[نسخهٔ انگلیسی این کتابخانه](README.en.md) · [فهرست دوره به فارسی](../README.md) · [Course index](../README.en.md)

این فهرست برای تکمیل درس‌ها گردآوری شده است: مستندات رسمی، راهنمای پروژه‌های نگهداری‌شده، مقاله‌های فنی، پژوهش و تجربه‌های تولیدی. برای رفتار وابسته به نسخه، مستند رسمی را در اولویت بگذارید. آمار و معماری مطالعه‌های موردی متعلق به زمینهٔ همان سازمان‌اند و نسخهٔ عمومی برای همه نیستند. این کتابخانه گزیدهٔ موضوعی است، نه فهرست تمام اینترنت.

## روش استفاده

1. ابتدا درس متناظر را بخوانید و سپس برای پرسش مشخص به منابع مراجعه کنید.
2. رفتار API و جزئیات نسخه را از مستندات رسمی Kubernetes بررسی کنید.
3. تاریخ انتشار و نسخهٔ Kubernetes مثال‌های قدیمی را بسنجید.
4. از تجربهٔ سازمان‌ها برای فهم trade-off و شیوهٔ عملیات استفاده کنید؛ معماری آن‌ها را بدون نیاز مشابه کپی نکنید.
5. منابع آموزشی فارسیِ ثالث تکمیلی‌اند؛ دستورهای نسخه‌حساس را با مستند رسمی تطبیق دهید.

<a id="01-introduction-and-mental-model"></a>
## 01. مقدمه و مدل ذهنی

- [مرور کلی Kubernetes — رسمی](https://kubernetes.io/docs/concepts/overview/) — قابلیت‌ها، مرز مسئولیت و چیزهایی که Kubernetes فراهم نمی‌کند.
- [مفاهیم رسمی](https://kubernetes.io/docs/concepts/) · [معماری کلاستر](https://kubernetes.io/docs/concepts/architecture/) · [اجزای Kubernetes](https://kubernetes.io/docs/concepts/overview/components/).
- [واژه‌نامهٔ رسمی](https://kubernetes.io/docs/reference/glossary/) · [آموزش تعاملی Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/).
- [تجربهٔ GitHub از Kubernetes](https://github.blog/engineering/kubernetes-at-github/) — مهاجرت تولیدی و مدل عملیاتی.
- [مطالعهٔ موردی Spotify در CNCF](https://www.cncf.io/case-studies/spotify/) — سکوی داخلی و جریان کاری توسعه‌دهندگان.
- [مستندات رسمی فارسی Kubernetes](https://kubernetes.io/fa/docs/home/) · [آموزش مقدماتی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="02-containers-and-images"></a>
## 02. کانتینر و Image

- [Imageها در Kubernetes](https://kubernetes.io/docs/concepts/containers/images/) · [Container Runtimeها](https://kubernetes.io/docs/setup/production-environment/container-runtimes/).
- [مشخصات OCI Runtime](https://github.com/opencontainers/runtime-spec) · [مستندات containerd](https://containerd.io/docs/).
- راهنمای Docker: [روش‌های ساخت image](https://docs.docker.com/build/building/best-practices/) · [ساخت چندمرحله‌ای](https://docs.docker.com/build/building/multi-stage/).
- [راهنمای امنیت کانتینر NIST SP 800-190](https://csrc.nist.gov/pubs/sp/800/190/final).
- [آموزش مقدماتی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="03-setting-up-kubernetes"></a>
## 03. آماده‌سازی Kubernetes

- [راهنمای شروع رسمی](https://kubernetes.io/docs/setup/) · [برنامه‌ریزی محیط تولید](https://kubernetes.io/docs/setup/production-environment/).
- [نصب kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/).
- کلاستر محلی: [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) · [minikube](https://minikube.sigs.k8s.io/docs/start/).
- سرویس مدیریت‌شده: [EKS](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html) · [GKE](https://docs.cloud.google.com/kubernetes-engine/docs/about) · [AKS](https://learn.microsoft.com/en-us/azure/aks/core-aks-concepts).
- [راهنمای رسمی فارسی محیط یادگیری](https://kubernetes.io/fa/docs/setup/learning-environment/) · [آموزش Docker و Kubernetes](https://blog.pasargadmizban.com/blog/amooz-docker-kubernetes).

<a id="04-running-applications"></a>
## 04. اجرای برنامه‌ها

- [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) · [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) · [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/).
- [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) · [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) · [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/).
- [Probeها](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/) · [اختلال Pod و PDB](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/).
- [تجربهٔ Kubernetes در GitHub](https://github.blog/engineering/kubernetes-at-github/) — مهاجرت و اجرای workload در محیط واقعی.
- فارسی: [آموزش DevNA: Pod، Deployment و Service](https://devna.ir/articles/kubernetes-basics-for-beginners) · [دورهٔ ۴۴ درسی توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="05-services-and-networking"></a>
## 05. Service و شبکه

- [مفاهیم شبکه در Kubernetes](https://kubernetes.io/docs/concepts/services-networking/) · [Service](https://kubernetes.io/docs/concepts/services-networking/service/) · [EndpointSlice](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/).
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) به پیاده‌سازی نیاز دارد؛ آن را با [Gateway API](https://gateway-api.sigs.k8s.io/) مقایسه کنید.
- [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) · [نیازمندی‌های شبکهٔ کلاستر](https://kubernetes.io/docs/concepts/cluster-administration/networking/).
- [مطالعهٔ CNCF: استانداردسازی شبکه در ۱۵۰+ کلاستر Celonis](https://www.cncf.io/case-studies/celonis/).
- فارسی: [آموزش Service در DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="06-configuration-management"></a>
## 06. مدیریت پیکربندی

- [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) · [Secret](https://kubernetes.io/docs/concepts/configuration/secret/).
- [روش امن مدیریت Secret](https://kubernetes.io/docs/concepts/security/secrets-good-practices/) · [رمزنگاری داده در حالت سکون](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).
- [Projected Volume](https://kubernetes.io/docs/concepts/storage/projected-volumes/) · [External Secrets Operator](https://external-secrets.io/latest/).
- [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ توسعه‌دهندگان به فارسی](https://faragiri.com/learning/kubernetes-developer/).

<a id="07-resource-management"></a>
## 07. مدیریت منابع

- [درخواست و محدودیت منابع](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) · [کیفیت سرویس Pod](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/).
- [ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/) · [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/) · [تخلیه در فشار منابع Node](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/).
- [درس‌های آزمون مقیاس‌پذیری GKE](https://cloud.google.com/blog/products/containers-kubernetes/lessons-learned-from-scalability-testing-google-kubernetes-engine/) — کشف گلوگاه و اهمیت مشاهده‌پذیری پیش از مقیاس تولید.
- [تجربهٔ Datadog در autoscaling](https://www.datadoghq.com/blog/how-we-saved-with-kubernetes-autoscaling/) — بهینه‌سازی مصرف با ملاحظهٔ پایداری.
- فارسی: [دورهٔ Kubernetes برای توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="08-security"></a>
## 08. امنیت

- [مفاهیم امنیتی Kubernetes](https://kubernetes.io/docs/concepts/security/) · [چک‌لیست امنیت](https://kubernetes.io/docs/concepts/security/security-checklist/).
- [استانداردهای امنیت Pod](https://kubernetes.io/docs/concepts/security/pod-security-standards/) · [اعمال سیاست امنیتی](https://kubernetes.io/docs/concepts/security/pod-security-admission/).
- [روش‌های مناسب RBAC](https://kubernetes.io/docs/concepts/security/rbac-good-practices/) · [روش‌های امن Secret](https://kubernetes.io/docs/concepts/security/secrets-good-practices/).
- [راهنمای سخت‌سازی NSA/CISA](https://www.nsa.gov/Press-Room/News-Highlights/Article/Article/2716980/nsa-cisa-release-kubernetes-hardening-guidance/) · [CIS Benchmark برای Kubernetes](https://www.cisecurity.org/benchmark/kubernetes).
- [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [آموزش Docker و Kubernetes به فارسی](https://blog.pasargadmizban.com/blog/amooz-docker-kubernetes).

<a id="09-monitoring-logging-and-tracing"></a>
## 09. پایش، لاگ و Trace

- [مفاهیم مشاهده‌پذیری](https://kubernetes.io/docs/concepts/cluster-administration/observability/) · [پایش مصرف منابع](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-usage-monitoring/).
- [معماری Logging](https://kubernetes.io/docs/concepts/cluster-administration/logging/) · [روش‌های عیب‌یابی](https://kubernetes.io/docs/tasks/debug/).
- [OpenTelemetry روی Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/) · [Prometheus و OpenTelemetry](https://prometheus.io/docs/guides/opentelemetry/).
- [پایش سامانه‌های توزیع‌شده در Google SRE Workbook](https://sre.google/workbook/monitoring/) — SLI، پایش و هشدار.
- فارسی: [مستندات رسمی Kubernetes](https://kubernetes.io/fa/docs/home/) · [دورهٔ توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="10-autoscaling"></a>
## 10. مقیاس‌پذیری خودکار

- [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) · [Vertical Pod Autoscaler](https://kubernetes.io/docs/concepts/workloads/autoscaling/vertical-pod-autoscale/).
- [Cluster Autoscaler](https://kubernetes.io/docs/concepts/cluster-administration/node-autoscaling/) · [Karpenter](https://karpenter.sh/docs/) — نسخه و پشتیبانی provider را بررسی کنید.
- [KEDA](https://keda.sh/docs/) — مقیاس‌پذیری بر پایهٔ رویداد و triggerها.
- [تجربهٔ مهندسی Datadog](https://www.datadoghq.com/blog/how-we-saved-with-kubernetes-autoscaling/) · [آزمون مقیاس GKE](https://cloud.google.com/blog/products/containers-kubernetes/lessons-learned-from-scalability-testing-google-kubernetes-engine/).
- فارسی: [مستندات Kubernetes به فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="11-storage-and-volumes"></a>
## 11. Storage و Volume

- [مفاهیم Storage](https://kubernetes.io/docs/concepts/storage/) · [Volumeها](https://kubernetes.io/docs/concepts/storage/volumes/).
- [PersistentVolume و Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) · [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/).
- [Container Storage Interface](https://kubernetes-csi.github.io/docs/) · [Snapshot Volume](https://kubernetes.io/docs/concepts/storage/volume-snapshots/).
- [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) · [تجربهٔ CERN در Kubernetes](https://v1-34.docs.kubernetes.io/case-studies/cern/) (منبع قدیمی‌تر است؛ زمینهٔ انتشار را در نظر بگیرید).
- فارسی: [مستندات Kubernetes به فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="12-scheduling"></a>
## 12. زمان‌بندی

- [Scheduling، Preemption و Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/) · [انتخاب Node برای Pod](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
- [Taint و Toleration](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) · [اولویت و پیش‌دستی](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/).
- [Topology Spread Constraint](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) · [اختلال Pod و PDB](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/).
- [مقدمهٔ Kueue](https://kueue.sigs.k8s.io/docs/overview/) · [تجربهٔ Netflix در ساده‌سازی Batch با Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c).
- فارسی: [مستندات Kubernetes به فارسی](https://kubernetes.io/fa/docs/home/) · [دورهٔ توسعه‌دهندگان](https://faragiri.com/learning/kubernetes-developer/).

<a id="13-deployment-and-delivery"></a>
## 13. الگوهای انتشار و تحویل

- [Deployment و rollout](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).
- [مستندات Helm](https://helm.sh/docs/) · [بهترین روش نگارش Chart](https://helm.sh/docs/chart_best_practices/).
- GitOps: [Argo CD](https://argo-cd.readthedocs.io/en/stable/user-guide/) · [Flux](https://fluxcd.io/flux/) · [اصول OpenGitOps](https://opengitops.dev/).
- انتشار تدریجی: [Argo Rollouts](https://argoproj.github.io/argo-rollouts/) · [Flagger](https://docs.flagger.app/).
- امنیت زنجیرهٔ ساخت: [SLSA](https://slsa.dev/) · [استقرار Kubernetes با GitHub Actions](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-kubernetes).
- فارسی: [مستندات رسمی فارسی](https://kubernetes.io/fa/docs/home/) · [آموزش مقدماتی DevNA](https://devna.ir/articles/kubernetes-basics-for-beginners).

<a id="14-advanced-topics-and-extensibility"></a>
## 14. موضوعات پیشرفته و توسعه‌پذیری

- [گسترش Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/) · [Custom Resource](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/).
- [راهنمای ساخت CRD](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/) · [الگوی Controller](https://kubernetes.io/docs/concepts/architecture/controller/).
- [کتاب Kubebuilder](https://book.kubebuilder.io/) · [مستندات Operator SDK](https://sdk.operatorframework.io/docs/).
- [Admission Controllerها](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/) · [روش‌های مناسب Webhook](https://kubernetes.io/docs/concepts/cluster-administration/admission-webhooks-good-practices/).
- [Scheduling Framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/).
- فارسی: [مستندات رسمی فارسی Kubernetes](https://kubernetes.io/fa/docs/home/) (همهٔ مباحث پیشرفته ترجمه نشده‌اند).

<a id="15-cluster-operations"></a>
## 15. عملیات کلاستر

- [مفاهیم مدیریت کلاستر](https://kubernetes.io/docs/concepts/cluster-administration/) · [ارتقای کلاستر](https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/) · [تخلیهٔ امن Node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/).
- [ارتقای kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/) · [بازیابی etcd](https://etcd.io/docs/v3.5/op-guide/recovery/) (با نسخهٔ etcd خود تطبیق دهید).
- [مطالعهٔ موردی Michelin در CNCF](https://www.cncf.io/case-studies/michelin/) · [گزارش سالانهٔ CNCF 2025](https://www.cncf.io/wp-content/uploads/2026/03/cncf_ar25_033126a.pdf) — پلتفرم و چندکلاستری.
- [تجربهٔ Pinterest](https://v1-32.docs.kubernetes.io/case-studies/pinterest/) · [Spotify در CNCF](https://www.cncf.io/case-studies/spotify/) · [مهاجرت Kubernetes در GitHub](https://github.blog/engineering/kubernetes-at-github/).
- [درس‌های مقیاس‌پذیری GKE](https://cloud.google.com/blog/products/containers-kubernetes/lessons-learned-from-scalability-testing-google-kubernetes-engine/) · [پژوهش الگوهای خرابی Kubernetes: Mutiny!](https://arxiv.org/abs/2404.11169).
- فارسی: [مستندات رسمی](https://kubernetes.io/fa/docs/home/) · [آموزش و تمرین روی سرور](https://blog.pasargadmizban.com/blog/amooz-docker-kubernetes).

## منابع آموزشی فارسی

این منابع برای آشنایی و تمرین فارسی هستند. برای جزئیات API و رفتار وابسته به نسخه، مستند رسمی انگلیسی/فارسی بالا را ملاک قرار دهید.

- [مستندات رسمی Kubernetes به فارسی](https://kubernetes.io/fa/docs/home/)
- [آموزش و گواهی‌های رسمی Kubernetes به فارسی](https://kubernetes.io/fa/training/)
- [DevNA — کوبرنتیز برای مبتدی‌ها؛ از Pod تا Service](https://devna.ir/articles/kubernetes-basics-for-beginners)
- [Faragiri — کوبرنتیز برای توسعه‌دهندگان در ۴۴ درس](https://faragiri.com/learning/kubernetes-developer/)
- [EasyEnv — آموزش Kubernetes از Pod تا Production](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
- [پاسارگاد میزبان — Docker، Kubernetes و تمرین روی سرور](https://blog.pasargadmizban.com/blog/amooz-docker-kubernetes)

</div>
