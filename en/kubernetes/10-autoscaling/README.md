# Chapter 10: Autoscaling
[Persian edition](../../../fa/kubernetes/10-autoscaling/README.md) · [Chapter references](../references/README.md#10-autoscaling)

[فارسی](../../../fa/kubernetes/10-autoscaling/README.md) | [Course index](../README.md)

## Learning objectives
- Distinguish horizontal Pod scaling, vertical Pod scaling, and node scaling.
- Connect metrics, requests, and capacity to autoscaling control loops.
- Account for startup delay and cloud/provider limits.
- Diagnose scaling oscillations and Pending Pods.

## Three controllers, three problems

- **HPA:** adjusts workload replica count from metrics.
- **VPA:** recommends or applies per-Pod resource requests/limits.
- **Cluster Autoscaler:** adjusts node capacity when unschedulable Pods require it.

HPA and node autoscaling complement each other: HPA can create Pods, but they remain Pending if nodes lack room until more capacity arrives. VPA and HPA can conflict if both act on CPU or memory; define clear metrics and ownership.

## Metrics and replicas

For utilization, HPA compares actual metrics with a target and estimates a desired replica count. CPU utilization is usually measured relative to CPU requests; missing or unrealistic requests can produce poor behavior. Custom or external metrics need an adapter and correct units and freshness.

## Capacity and delay

A Pod can become available faster than a new node—or the node can arrive later than expected. Measure startup, image pulls, provider quotas, node size, and warm-up time. Set minimum/maximum replicas, cost limits, and scale-down behavior. Draining a node can be blocked by PDBs, storage, or lack of replacement capacity.

## Practice

Generate test load and inspect HPA. Constrain replicas and observe scaling. In a local cluster, simulate missing metrics and Pending Pods. In cloud labs, check quotas and cost before creating capacity.

## Quiz
1. **What does HPA change?** The target workload's replica count.
2. **Why does CPU HPA need requests?** CPU utilization is calculated relative to the request.
3. **What does HPA not provide for Pending Pods?** Physical node capacity.
4. **When can HPA/VPA oscillate?** When both modify related resource/count signals using the same metrics.
5. **What can block scale-down?** Disruption constraints, PDBs, storage, or lack of a destination node.

## Further reading
- [Autoscaling concepts](https://kubernetes.io/docs/concepts/workloads/autoscaling/)
- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Vertical Pod Autoscaling](https://kubernetes.io/docs/concepts/workloads/autoscaling/vertical-pod-autoscale/)
- [Cluster Autoscaler project](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler)
- [Karpenter documentation](https://karpenter.sh/docs/)
- [Datadog's Kubernetes autoscaling case study](https://www.datadoghq.com/blog/how-we-saved-with-kubernetes-autoscaling/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
