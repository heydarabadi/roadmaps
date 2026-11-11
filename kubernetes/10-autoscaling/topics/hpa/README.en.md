# Horizontal Pod Autoscaler
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#10-autoscaling)

[فارسی](README.md) | [Chapter 10](../../README.en.md)

## HPA control loop

HPA periodically reads a target metric and changes replica count to move toward the target. If the target is CPU utilization, CPU requests are the denominator. HPA needs a metrics API, a scalable workload, and fresh metrics.

~~~yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
~~~

Custom metrics require an API/adapter and correct units. In production, tune scale-up/down policies and stabilization windows, then load-test the behavior.

## Common traps
- Requests are missing or unrealistic.
- Metrics are stale or unavailable.
- CPU is not the bottleneck; extra replicas may make a database problem worse.
- Slow application startup delays scaling benefit.
- Fast scale-down creates oscillation.
- maxReplicas exceeds capacity or budget.

## Quiz
1. **What does HPA control?** The desired replica count.
2. **What is CPU utilization a percentage of?** CPU request.
3. **Replicas increase but Pods are Pending. What is missing?** Node capacity or a schedulable configuration.
4. **Are more metrics always the answer?** No. Identify the bottleneck and downstream impact first.

## Further reading
- [HPA task and example](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [HPA concepts](https://kubernetes.io/docs/concepts/workloads/autoscaling/horizontal-pod-autoscale/)
- [Resource Metrics Pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
- [External metrics for HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)
- [EasyEnv Persian course](https://easyenv.io/engineering/courses/catalog/kubernetes/fa)
