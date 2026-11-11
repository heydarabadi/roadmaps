<div dir="ltr" align="left">

# CI/CD Integration

**Chapter:** [Deployment and delivery patterns](../../README.md) · **Persian:** [فارسی](../../../../../fa/kubernetes/13-deployment-patterns/topics/cicd/README.md) · **More references:** [Deployment bibliography](../../../references/README.md#13-deployment-and-delivery)

## Separate build from deployment

Continuous Integration (CI) validates source code and creates a release artifact. Continuous Delivery/Deployment (CD) moves that artifact into an environment and checks the deployed result. Promote the same immutable image from development to staging to production. Rebuilding separately at every stage weakens the evidence that production is running the exact artifact that passed tests.

## A practical pipeline

1. Run formatting, lint, unit, integration, and policy checks.
2. Build the image from a reviewed Dockerfile and locked dependencies.
3. Scan dependencies and the image; generate an SBOM and provenance when your supply-chain policy requires them.
4. Push with a unique release tag and record the immutable digest.
5. Render and validate Kubernetes manifests or Helm output.
6. Deploy to a staging environment and run smoke or integration checks.
7. Promote the same digest using a narrowly scoped production identity.
8. Watch rollout status, application health, error rate, latency, and dependency health; pause or revert according to a written rule.

## Identity and permissions

A permanent CI token with cluster-admin access turns a pipeline compromise into a cluster compromise. Prefer short-lived credentials, OIDC federation or workload identity where the provider supports it, and least-privilege RBAC scoped to the workload namespace. Keep production credentials separate from test environments. Redact secrets from logs and protect the path that changes deployment configuration.

CI success does not prove production health: production has real traffic, external dependencies, data, and configuration that tests may not reproduce.

## Exercise

Build a versioned image, record its digest in a manifest, deploy it to a local cluster, and inspect rollout status. In a disposable branch, deliberately use a bad image reference and identify the failure using Pod events. Document which credential the pipeline needs and which permissions it does not need.

## Quiz

1. Why keep an artifact identical across promotion stages? — To make the tested artifact the one that is ultimately released.
2. Why use short-lived deployment credentials? — A leaked credential has a shorter useful lifetime and can be restricted by identity and scope.
3. Does a green CI run prove production is healthy? — No. Real traffic, external services, configuration, and data introduce conditions tests may not cover.
4. What should be observed after deployment? — Rollout progress, readiness, user-facing errors and latency, and critical dependencies.
5. Why is cluster-admin usually excessive for app deployment? — The pipeline typically needs to update a bounded set of resources, not administer the whole cluster.

## References

- [Kubernetes container images](https://kubernetes.io/docs/concepts/containers/images/)
- [GitHub Actions: Deploying to Kubernetes](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-kubernetes)
- [SLSA supply-chain security framework](https://slsa.dev/)
- [OpenID Connect in GitHub Actions](https://docs.github.com/en/actions/concepts/security/openid-connect)
- [Chapter bibliography](../../../references/README.md#13-deployment-and-delivery)

</div>
