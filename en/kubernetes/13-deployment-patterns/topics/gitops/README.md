<div dir="ltr" align="left">

# GitOps

**Chapter:** [Deployment and delivery patterns](../../README.md) · **Persian:** [فارسی](../../../../../fa/kubernetes/13-deployment-patterns/topics/gitops/README.md) · **More references:** [Deployment bibliography](../../../references/README.md#13-deployment-and-delivery)

## Desired state in version control

In a GitOps model, a version-controlled repository declares the desired state. A controller in or connected to the cluster reads that declaration and reconciles the cluster toward it. This gives teams reviewable changes, history, auditability, repeatability, and a way to detect drift. Git is not the runtime state store, and a Git repository does not automatically protect Secrets.

A common separation is:

- **Application repository:** source code, tests, image build, and release artifact.
- **Environment repository:** image digest, replicas, configuration references, and environment policies.
- **Reconciliation controller:** pulls or watches the declared configuration and applies it.
- **Secret delivery:** encryption, a secret manager, or workload identity as appropriate.
- **Observability:** sync health, drift, rollout health, and alerts.

## Reconciliation and manual changes

A manual cluster change can become drift. Depending on controller policy, it may be overwritten or may remain until someone reconciles it. For an emergency fix, record the change back in the source repository after stabilizing the incident; otherwise the fix may disappear or leave the source of truth misleading.

A Git revert changes declared configuration. It does not reverse a database migration, a message already consumed, a payment, or a write performed by the application. Data recovery needs its own plan.

## Access and rollback

Protect branches, require review for production changes, and consider signed commits and policy checks when your threat model calls for them. Keep repository write permissions separate from cluster-controller permissions. Limit what the controller can change.

Rollback is often a revert or a previous image/chart version, followed by reconciliation. Test the behavior, including what happens if the old code cannot read data written by the new code.

## Exercise

Change a Deployment replica count in Git and observe the controller syncing it. Then make a manual replica change in a disposable cluster and watch drift detection or reconciliation. Revert the repository commit and confirm that the cluster converges again.

## Quiz

1. What is the source of desired state in GitOps? — A versioned repository or another declared source configured for reconciliation.
2. What does GitOps not guarantee? — Correct software, safe secret handling, or data recovery.
3. What can happen to a manual cluster edit? — It may be detected as drift and reconciled back to the declared configuration.
4. Does reverting a Git commit restore a database? — No. Schema and data require a separate recovery or forward-fix plan.
5. Why separate repository and controller permissions? — A compromised identity should not automatically gain broad access to both source and cluster.

## References

- [Argo CD User Guide](https://argo-cd.readthedocs.io/en/stable/user-guide/)
- [Flux documentation](https://fluxcd.io/flux/)
- [Kubernetes declarative object management](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/)
- [OpenGitOps principles](https://opengitops.dev/)
- [Chapter bibliography](../../../references/README.md#13-deployment-and-delivery)

</div>
