<div dir="ltr" align="left">

# Rolling Updates and Rollback

**Chapter:** [Deployment and delivery patterns](../../README.md) · **Persian:** [فارسی](../../../../../fa/kubernetes/13-deployment-patterns/topics/rolling-updates/README.md) · **More references:** [Deployment bibliography](../../../references/README.md#13-deployment-and-delivery)

## Gradual replacement

A Deployment using RollingUpdate gradually starts new Pods and scales down old ones. maxSurge limits temporary extra Pods; maxUnavailable limits how many desired replicas may be unavailable during the update. Readiness must represent actual ability to serve requests. A process that is merely running may still be unready.

~~~yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
~~~

This example keeps the desired number available according to Deployment availability rules and permits one extra Pod during rollout. If nodes have no spare capacity, rollout can remain Pending. Recreate terminates old Pods before creating the new ones and may cause downtime.

## Observe and revert

~~~sh
kubectl rollout status deployment/api
kubectl rollout history deployment/api
kubectl rollout undo deployment/api
~~~

An undo restores an earlier Pod template revision. Update the source manifest or Git repository as well so the declared desired state does not immediately reapply the bad version. Make rollback decisions using agreed signals such as sustained error-rate or latency regression; a noisy alert alone may not justify a revert.

When rollout stalls, inspect Deployment conditions, ReplicaSets, Pod events, image pulls, probes, quota, capacity, and dependencies.

## Compatibility while versions overlap

Old and new versions coexist during a rolling update. APIs, schemas, cache formats, and messages must tolerate this overlap. Design database changes using expand–migrate–contract and practice them in staging. Reverting the container cannot remove a message already published or restore a database automatically.

## Exercise

Set maxUnavailable to zero in a disposable cluster, deploy a version with a failing readiness probe, and inspect rollout status and events. Fix the probe and observe recovery. Record which desired-state file must also be corrected after undo.

## Quiz

1. What does maxSurge control? — The number or proportion of additional Pods allowed during a rollout.
2. Why does readiness matter? — It determines whether a Pod should be counted as available for serving.
3. A rollout is stuck. What should you inspect? — Conditions, events, Pods, image, probes, capacity, quota, and dependencies.
4. What should be updated after kubectl rollout undo in a GitOps setup? — The declared source of truth, so reconciliation does not restore the bad version.
5. Do old and new Pods ever overlap? — Yes, unless a different strategy or configuration changes that behavior.

## References

- [Deployment and RollingUpdate](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Kubernetes tutorial: updating a Deployment](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
- [Deployment API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/)
- [Chapter bibliography](../../../references/README.en.md#13-deployment-and-delivery)

</div>
