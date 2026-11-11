# Cluster Autoscaling
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#10-autoscaling)

[فارسی](README.md) | [Chapter 10](../../README.en.md)

## Pod scaling versus node scaling

HPA increases Pod count. Cluster Autoscaler or node provisioning adds capacity when Pods cannot be scheduled because no suitable node exists. A new node takes time to provision, join, become Ready, and pull images.

Removing a node is also not trivial: Pods must move. PDBs, local storage, taints, PVC topology, DaemonSets, and lack of spare capacity can block scale-down. Account for provider quota and maximum node limits.

## Troubleshoot

~~~sh
kubectl get pods -A --field-selector=status.phase=Pending
kubectl describe pod POD_NAME
kubectl get nodes
kubectl get events -A --sort-by=.metadata.creationTimestamp
~~~

Read the scheduling event to learn why a Pod is Pending. Insufficient CPU, an incompatible selector/taint, a PVC, cloud quota, and image pull are different causes. Adding a node fixes only capacity problems, not a bad selector or missing image.

## Quiz
1. **HPA versus cluster autoscaler?** HPA changes workload replicas; node autoscaling changes cluster capacity.
2. **Why is scale-up not immediate?** Provisioning, boot, joining, and readiness take time.
3. **What can block scale-down?** PDBs, volumes, constraints, or no suitable destination.
4. **A node was added but the Pod is still Pending. Why?** The cause may not be capacity; read the event.

## Further reading
- [Cluster Autoscaler project](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)
- [Kubernetes scheduling and eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/)
- [Autoscaling concepts](https://kubernetes.io/docs/concepts/workloads/autoscaling/)
- [Karpenter documentation](https://karpenter.sh/docs/)
- [Datadog production autoscaling experience](https://www.datadoghq.com/blog/how-we-saved-with-kubernetes-autoscaling/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
