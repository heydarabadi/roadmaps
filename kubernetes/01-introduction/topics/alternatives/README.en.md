# Kubernetes Alternatives and How to Choose
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#01-introduction-and-mental-model)

[فارسی](README.md) | [Chapter 01](../../README.en.md)

## Learning objective

Compare options by workload, operational responsibility, and cost instead of assuming the most popular tool is the default choice.

## Families of alternatives

| Option | Consider it when | Cost or limitation to assess |
| --- | --- | --- |
| A VM or traditional platform | One small service has a simple release process | You design capacity and failover |
| Docker Compose | Development or a simple single-host workload | Multi-host coordination and cluster-wide policy are limited |
| Managed container app | You want the provider to hide orchestration operations | Provider features and contract create dependencies |
| Nomad | You want a lighter orchestrator or need mixed workload types | Evaluate its ecosystem and fit with team tooling |
| Docker Swarm | Simple operations and existing Docker integration matter | Check feature and ecosystem fit for the actual requirements |
| OpenShift | You want Kubernetes with an integrated enterprise platform | You accept a more opinionated product and operating model |
| Managed Kubernetes | You need Kubernetes APIs and ecosystem but want the provider to operate part of the control plane | Calculate provider cost and the responsibilities that remain |

This is not a permanent ranking. Projects and managed services change. Review current product documentation and contracts before deciding.

## Build a decision matrix

Score each option from 1 to 5 and weight criteria by product priorities:

- Time to production
- Availability and recovery
- On-call skills and staffing
- Portability and provider dependency
- Control-plane, node, storage, networking, and add-on cost
- Security, audit, and compliance
- Need for autoscaling and progressive rollout
- Total operational effort

A team with many microservices and frequent releases may benefit from a shared API. A team with one scheduled job and low traffic might keep things simpler with a managed container job.

## Migrate in stages

Do not rewrite a working application solely to make it “cloud-native.” Pick a low-risk service, define success criteria, package its image, write manifests, test load and rollback, and measure operational cost. Expand only after the pilot proves value.

## Common traps

- Comparing technical features but ignoring 24/7 operational ownership.
- Estimating machine cost without engineering time, network, or storage.
- Assuming easy cloud migration because each provider exposes Kubernetes APIs.
- Moving a stateful database before designing backup and restore.
- Treating Kubernetes as a cure for an unsuitable application architecture.

## Quiz

1. **When is Compose reasonable?** When a single host or development environment is sufficient and multi-host orchestration is not worth its cost.
2. **What does managed Kubernetes usually simplify?** Some control-plane operations; workload, data, access, and cost still need owners.
3. **Name one non-price criterion.** On-call capacity, team skills, audit, portability, or time to product.
4. **How can you prove a migration is worthwhile?** Run a low-risk pilot with measurable success criteria, tested rollback, and total-cost measurement.

## Further reading

- [Kubernetes production environments](https://kubernetes.io/docs/setup/production-environment/)
- [Kubernetes concepts](https://kubernetes.io/docs/concepts/)
- [Managed Kubernetes provider options](https://kubernetes.io/docs/setup/production-environment/turnkey-solutions/)
- [DevNA: Kubernetes basics](https://devna.ir/articles/kubernetes-basics-for-beginners)
- [Kubernetes roadmap](https://roadmap.sh/kubernetes)
