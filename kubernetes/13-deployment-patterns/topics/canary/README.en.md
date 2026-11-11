<div dir="ltr" align="left">

# Canary Releases

**Chapter:** [Deployment and delivery patterns](../../README.en.md) · **Persian:** [فارسی](README.md) · **Full lesson and lab:** [Canary and Blue-Green](../canary-bluegreen/README.en.md) · **More references:** [Deployment bibliography](../../../references/README.en.md#13-deployment-and-delivery)

## Mental model

A canary release does not expose every user to a new version at once. A small share of requests, or a carefully chosen cohort, reaches the candidate first. The team observes real behavior, then gradually increases exposure if predeclared health checks pass. If regression appears, exposure stops and the candidate can be rolled back. The purpose is to limit impact and collect evidence early; it is not a promise that a release cannot fail.

Stable and candidate versions must run side by side. Metrics should identify the version so a larger healthy stable population cannot hide a candidate failure.

## What Kubernetes does and does not do

A Kubernetes Deployment RollingUpdate controls Pod replacement through maxSurge and maxUnavailable. It does not, by itself, guarantee that exactly 5% of HTTP requests reach the new version. Putting two Deployments behind one ordinary Service and changing replica counts gives only an approximate request split; endpoint selection, connections, affinity, and traffic patterns affect the actual share.

Precise weights or user cohorts usually require a compatible Gateway/Ingress, service mesh, load balancer, or progressive-delivery controller such as Argo Rollouts or Flagger. The traffic router, metric provider, analysis rules, and rollback action all need to be configured and tested together.

A sample progression could be 5%, 20%, 50%, then 100%. Each step needs a defined observation duration or minimum sample size, metrics, and stop criteria. For example, wait at 5%, compare candidate 5xx rate and p95 latency with stable, and proceed only when the SLO rule holds. A short window with too few requests is weak evidence.

## Define before rollout

- **Baseline:** stable error rate, latency percentiles, resource use, queue depth, and dependency behavior.
- **Pass and stop thresholds:** thresholds and consecutive evaluation windows chosen before seeing the result.
- **Observation window:** duration or request count sufficient for the normal traffic pattern and delayed failures.
- **Segmentation:** metrics labeled by version and, where relevant, region, route, or customer cohort.
- **Decision owner:** the person or automation allowed to pause, abort, or promote.
- **State compatibility:** both versions must work with shared schema, cache, queue, sessions, and storage.
- **Capacity:** enough headroom to run the candidate and stable version together.

Illustrative rule: if the candidate breaches the service SLO in two consecutive windows, stop increasing exposure and follow the runbook. Tune thresholds to the service’s actual SLO and natural variance; there is no universal percentage.

## Common failure modes

1. **Mistaken traffic weights:** replica ratio is treated as an exact request percentage.
2. **Small or unrepresentative sample:** the canary sees only low load or misses a vulnerable cohort.
3. **Aggregated metrics:** healthy stable traffic hides candidate errors.
4. **Weak readiness:** the Pod is Ready although a user journey or critical dependency fails.
5. **Irreversible data writes:** the old version cannot read a format written by the candidate.
6. **Insufficient headroom:** running both versions overloads nodes or shared dependencies.

## Exercise

Design a canary for a test API with two versions. Make the candidate deliberately slower or error-prone. Write the traffic steps, metric labels, minimum sample, observation window, and stop rule. Explain why a standard Kubernetes Service does not split traffic by cookie or guarantee a precise request percentage.

## Quiz

1. Does a built-in Deployment guarantee that 10% of requests go to the candidate? — No. It manages Pod replacement; precise traffic splitting needs a compatible routing data plane or controller.
2. Why label metrics by version? — Stable traffic can hide a regression in the candidate’s aggregate statistics.
3. Is five healthy requests enough to promote? — Usually not; the sample may be too small and unrepresentative.
4. What do you do after an SLO breach? — Stop increasing exposure, pause or roll back according to the runbook, and inspect the signal.
5. Does rolling back the image undo data it wrote? — No. Data and schema compatibility need a separate design.

## References

- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Canary strategy in Argo Rollouts](https://argoproj.github.io/argo-rollouts/features/canary/)
- [Analysis in Argo Rollouts](https://argoproj.github.io/argo-rollouts/features/analysis/)
- [How Flagger analyzes and promotes](https://docs.flagger.app/usage/how-it-works)
- [Full lesson and lab](../canary-bluegreen/README.en.md)

</div>
