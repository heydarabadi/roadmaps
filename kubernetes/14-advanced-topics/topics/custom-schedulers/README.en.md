<div dir="ltr" align="left">

# Custom Schedulers and the Scheduling Framework

**Chapter:** [Advanced topics](../../README.en.md) · **Persian:** [فارسی](README.md) · **More references:** [Advanced topics bibliography](../../../references/README.en.md#14-advanced-topics-and-extensibility)

## Prove the need first

Most placement needs can be expressed with resource requests, node affinity, taints and tolerations, topology spread, and PriorityClass. Model the requirement with these built-in controls before creating another scheduler. A custom scheduler or plugin means your team owns compatibility, policy, telemetry, leader/failure behavior, and upgrades.

The Scheduling Framework exposes extension points such as filtering and scoring nodes. A scheduler extender is more limited; consult the current documentation for its supported functions. Running a separate scheduler can complicate scheduling behavior and create conflicts between schedulers.

## Example

Suppose a Pod needs a particular accelerator and a minimum amount of local memory. First check the device plugin and extended resource, node labels, and affinity. If built-in constraints express the policy, a custom scheduler adds cost without providing necessary capability. If a complex policy is truly required, implement the smallest plugin possible and measure its behavior.

## Production requirements

Before shipping, define high availability, metrics, failure fallback, schedulerName ownership, access control, and upgrade compatibility. Test unschedulable workloads and scheduler restart behavior. A scheduler decision must be explainable to operators through events and diagnostics.

## Quiz

1. What should you try first for custom placement? — Built-in controls such as affinity, taints, and topology spread.
2. What is a benefit of the Scheduling Framework over forking the scheduler? — It provides defined extension points that are easier to keep compatible than a maintained fork.
3. What should be checked before using an extender? — Current documented capabilities and limitations for the Kubernetes version in use.
4. What does production operation require? — High availability, metrics, failure behavior, access control, and tested upgrades.

## References

- [Scheduling Framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)
- [Kubernetes extension concepts](https://kubernetes.io/docs/concepts/extend-kubernetes/)
- [Scheduler configuration reference](https://kubernetes.io/docs/reference/scheduling/config/)
- [Chapter bibliography](../../../references/README.en.md#14-advanced-topics-and-extensibility)

</div>
