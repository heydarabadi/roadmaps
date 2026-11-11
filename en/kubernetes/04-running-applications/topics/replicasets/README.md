# ReplicaSets
[Persian edition](../../../../../fa/kubernetes/04-running-applications/topics/replicasets/README.md) · [Chapter references](../../../references/README.md#04-running-applications)

[فارسی](../../../../../fa/kubernetes/04-running-applications/topics/replicasets/README.md) | [Chapter 04](../../README.md)

## What the controller does

A ReplicaSet maintains a desired number of Pods matching its selector. If fewer matching Pods exist than spec.replicas, it creates them; if there are too many, it reduces the count. It maintains interchangeable replicas rather than preserving a specific Pod identity.

For normal releases, a Deployment owns ReplicaSets so it can manage revisions. Creating a ReplicaSet directly is useful for learning, but usually loses the rollout, rollback, and history features provided by Deployments.

## Selector and template

A ReplicaSet selector must match its Pod-template labels. An overly broad selector can accidentally adopt unrelated Pods. Establish a clear label convention.

~~~yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: worker
spec:
  replicas: 2
  selector:
    matchLabels:
      app: worker
  template:
    metadata:
      labels:
        app: worker
    spec:
      containers:
        - name: task
          image: busybox:stable
          command: ["sh", "-c", "sleep 3600"]
~~~

## Observe self-healing

~~~sh
kubectl get rs
kubectl get pods --show-labels
kubectl delete pod -l app=worker
kubectl get rs,pods --watch
~~~

After deletion, the ReplicaSet sees fewer Pods and creates replacements. If the image is bad, the replacement will also fail: the controller maintains count, not application correctness.

## How it differs from a Deployment

A Deployment creates and manages ReplicaSets, versions the Pod template, and provides rollout and rollback controls. When the template changes, it creates a new ReplicaSet and scales the old one down gradually. Usually you inspect ReplicaSets for diagnosis rather than editing them directly.

## Quiz
1. **What state does a ReplicaSet reconcile?** The count of Pods matching its selector.
2. **Does a deleted Pod come back with the same identity?** No. A replacement can have a new identity.
3. **Why prefer a Deployment?** It adds release history and rollout management.
4. **Replicas increased but Pods remain Pending. What might be wrong?** Node capacity, quota, or scheduling constraints.

## Further reading
- [ReplicaSet concepts](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
- [Deployment concepts](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Owner references and dependents](https://kubernetes.io/docs/concepts/overview/working-with-objects/owners-dependents/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
