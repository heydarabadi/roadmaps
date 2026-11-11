<div dir="ltr" align="left">

# Helm Charts

**Chapter:** [Deployment and delivery patterns](../../README.en.md) · **Persian:** [فارسی](README.md) · **More references:** [Deployment bibliography](../../../references/README.en.md#13-deployment-and-delivery)

## What is a chart?

A Helm chart packages Kubernetes templates and metadata. Values provide configurable inputs. A **release** is an installed instance of a chart in a cluster. Helm renders and manages that release; it does not make the chart secure or its application behavior correct.

## A review-first workflow

~~~sh
helm lint ./chart
helm template shop ./chart -f values-staging.yaml
helm upgrade --install shop ./chart -n shop --create-namespace
helm history shop -n shop
helm rollback shop 2 -n shop
~~~

Before installing or upgrading, inspect rendered YAML for image references, privileged settings, RBAC, Secrets, resource requests/limits, selectors, ports, and security context. Pin chart dependencies and keep chart and app-image versions traceable.

## Values and environment overlays

Defaults should be safe and understandable. Do not put plaintext credentials in values.yaml or commit secret-bearing overrides to Git. Use an approved secret-management flow. Structure shared values and environment-specific overlays so that a development setting cannot accidentally reach production. Track chart-version changes separately from application-image changes.

## Common mistakes

- Installing an unknown chart without reviewing its templates and dependencies.
- Building complicated template logic that is hard to validate.
- Assuming Helm rollback undoes a database migration or external side effect.
- Forgetting how removed or renamed resources behave during an upgrade.
- Using API versions unavailable in the target Kubernetes release.
- Treating successful rendering as proof that the workload will be healthy.

## Exercise

Render a chart for staging and production into separate files. Compare image digest, replicas, resource settings, ingress exposure, and secret references. Explain which differences are intentional and who reviews them.

## Quiz

1. How do a chart and a release differ? — A chart is the package; a release is an installed instance of it.
2. Why run helm template before upgrade? — To inspect the YAML that Helm will submit before changing the cluster.
3. Does Helm rollback undo a data migration? — No.
4. Where should sensitive values go? — Into an approved secret-management system or encrypted delivery path, not plaintext Git.
5. What can helm lint prove? — It can catch some chart issues, but it does not prove runtime health or security.

## References

- [Helm documentation](https://helm.sh/docs/)
- [Helm chart best practices](https://helm.sh/docs/chart_best_practices/)
- [Helm template command](https://helm.sh/docs/helm/helm_template/)
- [Chapter bibliography](../../../references/README.en.md#13-deployment-and-delivery)

</div>
