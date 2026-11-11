# Chapter 04: Applications and Workloads
[Persian edition](../../../fa/kubernetes/04-running-applications/README.md) · [Chapter references](../references/README.md#04-running-applications)

[فارسی](../../../fa/kubernetes/04-running-applications/README.md) | [Course index](../README.md)

## Learning objectives
- Distinguish a Pod from its containers.
- Explain how a Deployment manages ReplicaSets and Pods.
- Choose the right workload for stateless services, stateful data, and finite tasks.
- Troubleshoot rollout, readiness, and workload failures using status and events.

## Mental model

~~~text
Deployment → ReplicaSet → Pod → Container
StatefulSet → Pods with stable identities + PVCs
Job → Pods that run finite work
~~~

A Pod is the smallest scheduling unit; containers run inside it. A Deployment manages replica count and releases for stateless apps. A ReplicaSet maintains matching Pods. A StatefulSet assigns stable ordinals and claims. A Job tracks batch work until it completes. These resources are not interchangeable.

## Choose a workload

| Workload | Suggested resource | Key consideration |
| --- | --- | --- |
| Always-on, scalable API or worker | Deployment | Define readiness, rollout, and resource requirements |
| Replica needs a stable identity or dedicated volume | StatefulSet | The application still needs replication and backup design |
| Migration or finite processing | Job | Make retries and side effects safe |
| Scheduled batch work | CronJob creating Jobs | Control overlap and concurrency |
| Disposable debugging Pod | Direct Pod | No controller replaces it after deletion |

## Deployment example

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: example.invalid/shop/api:v1
          ports:
            - name: http
              containerPort: 8080
          readinessProbe:
            httpGet:
              path: /ready
              port: http
          resources:
            requests:
              cpu: 200m
              memory: 256Mi
~~~

The Deployment selector must match the Pod-template labels. The example image is a placeholder. maxUnavailable=0 may stall an update in a small cluster because the new Pod must become ready before an old one is removed.

## Observe and control releases

~~~sh
kubectl rollout status deployment/api
kubectl rollout history deployment/api
kubectl describe deployment/api
kubectl get deploy,rs,pods
~~~

Changing the Pod template, such as its image, creates a new revision. Changing replica count usually just scales the existing ReplicaSet. Readiness controls whether a Pod receives traffic; liveness can restart a stuck container. A bad probe can stall a healthy rollout or keep a broken Pod alive.

Rollback restores an earlier template. It does not undo a database migration, queue message, or external side effect. Two application versions may run together during rollout, so design compatible APIs and data migrations.

## Practical scenario: online store

Deploy the order API; scale queue workers independently. Run migrations as Jobs and make repeated execution safe. Use a StatefulSet for a database only when the team can operate backups, restores, quorum, upgrades, and alerts. A managed database can be a valid alternative.

## Troubleshooting sequence

1. Check Deployment, ReplicaSet, and Pod status.
2. Describe resources to read conditions and scheduling, image, or probe events.
3. Read current and previous container logs.
4. Compare selectors with labels.
5. For a StatefulSet, inspect PVC and storage status.
6. For a Job, check retries, exit code, deadline, and idempotency.

## Quiz with answers

1. **What happens when you delete a Pod owned by a Deployment?** Its controller notices the replica deficit and creates a replacement; a standalone Pod has no such owner.
2. **When is a StatefulSet needed?** When stable identity, ordering, or a dedicated claim is needed—not merely because the application is a database.
3. **Why should a Job be idempotent?** A retry can repeat an external side effect.
4. **Does rollout undo reverse a migration?** No. Code and data have separate recovery procedures.

## Real-world experience and further reading

Netflix describes batch-compute queuing and capacity management in its [Kueue production article](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c). The transferable lesson is that multi-tenant batch workloads need queueing, capacity policy, and fair sharing. Do not copy Netflix's architecture without considering its scale.

- [Kubernetes workload concepts](https://kubernetes.io/docs/concepts/workloads/)
- [Workload management](https://kubernetes.io/docs/concepts/workloads/management/)
- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [Jobs and CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- [Kueue overview](https://kueue.sigs.k8s.io/docs/overview/)
- [Netflix: Simplifying batch compute with Kueue](https://netflixtechblog.com/how-netflix-simplified-batch-compute-with-kueue-87860682629c)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
- [Persian workload workshop](https://www.youtube.com/watch?v=eDbCM6sbcXY)
