# Deployments
[Persian edition](../../../../../fa/kubernetes/04-running-applications/topics/deployments/README.md) · [Chapter references](../../../references/README.md#04-running-applications)

[فارسی](../../../../../fa/kubernetes/04-running-applications/topics/deployments/README.md) | [Chapter 04](../../README.md)

## What a Deployment manages

A Deployment describes desired state for a stateless application. Its controller creates a ReplicaSet; the ReplicaSet maintains the Pod count. Changing the Pod template creates a new revision. Changing only the replica count usually scales the current ReplicaSet.

## RollingUpdate example

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
        - name: api
          image: example.invalid/api:v2
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
~~~

maxSurge limits extra temporary Pods; maxUnavailable limits how many can be unavailable during an update. Aggressive values may consume extra capacity or reduce availability. A successful readiness check should mean the application can actually serve its intended traffic.

~~~sh
kubectl rollout status deployment/api
kubectl rollout history deployment/api
kubectl rollout undo deployment/api
kubectl describe deployment/api
~~~

## Application releases and data schemas

Old and new application versions may run at the same time. Keep APIs and data schemas compatible during that overlap. A common expand/contract approach is to add a compatible schema, release the new app, stop using the old schema, and only then remove it. Rolling back code does not reverse a migration or external side effect.

## Choosing and troubleshooting a strategy

RollingUpdate usually reduces downtime but needs temporary capacity. Recreate stops the old version first and may cause downtime. If a rollout stalls:

1. Inspect Deployment conditions and status.
2. Inspect the new ReplicaSet and Pods.
3. Read events for image, scheduling, quota, and probe failures.
4. Read application logs.
5. Fix the cause or use a planned rollback; blind rollback will not repair data.

## Quiz with answers

1. **What creates a new revision?** A Pod-template change such as image, command, or environment.
2. **What does readiness do during rollout?** It prevents an unready Pod from receiving traffic and can hold progression.
3. **What is the cost of maxUnavailable=0?** The cluster needs enough capacity for a replacement Pod before an old one is removed.
4. **Does rollback reverse a database migration?** No. Data migrations need their own recovery plan.

## Further reading
- [Deployment concepts](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Update a Deployment](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
- [Deployment API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/)
- [Kubernetes probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
