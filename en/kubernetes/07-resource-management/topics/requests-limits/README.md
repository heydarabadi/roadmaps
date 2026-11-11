# Resource Requests and Limits
[Persian edition](../../../../../fa/kubernetes/07-resource-management/topics/requests-limits/README.md) · [Chapter references](../../../references/README.md#07-resource-management)

[فارسی](../../../../../fa/kubernetes/07-resource-management/topics/requests-limits/README.md) | [Chapter 07](../../README.md)

## CPU versus memory

A request is the amount used for scheduling. Node capacity is evaluated against the sum of requests; usage above a request can still create contention. A limit is a container ceiling: CPU is typically throttled, while exceeding a memory limit can cause an OOM kill.

~~~yaml
resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: "1"
    memory: 512Mi
~~~

200m means 0.2 logical CPU. Mi is a binary unit. Do not copy example values into production; measure your own service.

## Practical sizing
- Measure startup and peak usage, not only the average.
- Account for heap and cache growth in the memory request.
- A tight CPU limit can worsen tail latency.
- Use node allocatable capacity, not only nominal capacity.
- Monitor ephemeral storage and log volume as well.

## Failure signals

A Pending Pod with an Insufficient CPU/memory event points to requests, capacity, or scheduling constraints. Find OOMKilled in container lastState and Pod events. CPU throttling can slow responses without a restart. Pair logs with resource and latency metrics.

## Quiz with explanations

1. **Requests versus limits?** Requests affect scheduling/capacity accounting; limits enforce a usage ceiling.
2. **Why can CPU request and limit differ?** The request informs placement; the limit controls the ceiling.
3. **Where do you find OOMKilled?** In the container's last state and Pod events.
4. **Why is one measurement not enough?** It may miss peaks, startup behavior, and periodic workloads.

## Further reading
- [Resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- [Pod QoS](https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/)
- [Reserve compute resources for system daemons](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/)
- [Resource metrics pipeline](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
