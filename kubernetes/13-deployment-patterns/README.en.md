<div dir="ltr" align="left">

# Chapter 13: Deployment and Delivery Patterns

**Persian edition:** [فارسی](README.md) · **Reference library:** [Deployment and delivery resources](../references/README.en.md#13-deployment-and-delivery)

## Learning objectives

By the end of this chapter, you should be able to:

- Separate continuous integration, artifact creation, deployment, and environment promotion.
- Choose GitOps and Helm for the problems they solve, without treating either as a security guarantee.
- Design rolling, canary, and blue-green releases around readiness and measurable health.
- Explain why application rollback does not undo database, queue, or external side effects.

## From source code to production

A safer delivery chain makes the artifact tested in CI the same artifact promoted to production:

1. Run lint, unit, integration, and policy checks.
2. Build an immutable container image; scan dependencies and generate a software bill of materials where appropriate.
3. Record the image digest and provenance. A mutable tag such as latest is not a reliable release identity.
4. Version the manifest or Helm chart that declares the deployment.
5. Promote through staging with review, smoke checks, and telemetry.
6. Use a narrowly scoped identity for production deployment; prefer short-lived credentials or workload identity where supported.
7. Observe the rollout and practice a rollback or forward-fix procedure.

A CI job should not hold a permanent cluster-admin credential. Restrict identities by namespace and action, protect production environments, and make sure pipeline logs do not print tokens or Secret values.

## GitOps and Helm

GitOps treats a versioned repository as the declared desired state and uses a controller to reconcile the cluster toward it. It gives teams a reviewable change history and helps detect drift. It does not make application code correct, encrypt repository secrets automatically, or recover data.

Helm packages Kubernetes resources as charts, renders templates from values, and tracks releases. It helps manage reusable configuration. It does not validate the security of a chart or make a database migration reversible. Pin chart dependencies, inspect rendered manifests, and keep sensitive values out of plaintext Git.

## Choosing a release strategy

- **RollingUpdate:** gradually replaces Pods. Old and new versions coexist temporarily, so capacity and API/schema compatibility matter.
- **Canary:** exposes a limited share or cohort to a candidate, then expands based on predeclared health signals. Precise request-level weighting requires a compatible traffic router or progressive-delivery controller.
- **Blue-Green:** prepares a separate candidate environment, tests it, and switches the main route. It can require capacity for both environments and still does not rewind shared state.
- **Recreate:** stops the old workload before starting the new one; it can cause downtime.

No strategy guarantees rollback of data. Prefer backward-compatible migrations such as expand–migrate–contract, and test the operational recovery path.

## Practical exercise

Pick a small stateless service. Write down the artifact identity, the staging checks, the production identity and permissions, the rollout health signals, the pause/rollback threshold, and the owner who makes the decision. Include one data migration failure mode and its recovery plan.

## Quiz with answers

1. What should CI produce? — A tested, versioned artifact with a traceable identity, ideally referenced by digest.
2. What does a GitOps controller reconcile? — Actual cluster state toward the desired state declared in version control.
3. Does Helm guarantee a chart is safe? — No. Review templates, permissions, images, dependencies, and rendered output.
4. What is a canary for? — Limiting candidate exposure while collecting enough representative evidence to promote or stop.
5. Why design migrations separately from application rollout? — Code rollback does not undo writes, schema changes, messages, payments, or other external effects.
6. Does a Deployment RollingUpdate send exactly 5% of HTTP requests to the new version? — No. It controls Pod replacement, not precise request traffic weights.

## Real-world perspective

Progressive delivery is a control loop: define what “healthy” means, gather version-specific evidence, then promote, pause, or revert. A rollout tool cannot compensate for weak signals, an unrepresentative sample, or an incompatible data change. Netflix’s engineering write-up on Kueue is a useful capacity-management case study; it concerns batch scheduling rather than a canary deployment, so use it for operational lessons about queueing and capacity, not as evidence for a release strategy.

## Continue learning

- [Kubernetes Deployment documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Helm documentation](https://helm.sh/docs/)
- [Argo CD User Guide](https://argo-cd.readthedocs.io/en/stable/user-guide/)
- [Argo Rollouts](https://argoproj.github.io/argo-rollouts/)
- [Expanded Canary and Blue-Green lesson](topics/canary-bluegreen/README.en.md)
- [Curated chapter bibliography](../references/README.en.md#13-deployment-and-delivery)

</div>
