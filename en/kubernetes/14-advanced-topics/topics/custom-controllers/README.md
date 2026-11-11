<div dir="ltr" align="left">

# Building a Custom Controller

**Chapter:** [Advanced topics](../../README.md) · **Persian:** [فارسی](../../../../../fa/kubernetes/14-advanced-topics/topics/custom-controllers/README.md) · **More references:** [Advanced topics bibliography](../../../references/README.md#14-advanced-topics-and-extensibility)

## The reconciliation loop

A controller is a client of the Kubernetes API. It watches relevant objects, queues work keys when changes happen, reads current API state, observes external or child resources, and takes safe steps toward the desired state. Events can repeat or arrive together, so a controller must reason from current state rather than assume a perfect history of event order.

~~~text
read desired spec → inspect actual state → perform one safe action
→ update status → retry/reconcile until converged
~~~

For example, a BackupPolicy custom resource might describe a schedule and destination. A controller could create Jobs and update status with the last successful backup. It must reference credentials securely and avoid exposing them in logs or status.

## Design rules

- Keep reconciliation short, repeatable, and safe to retry.
- Protect external side effects with idempotency keys or recorded state.
- Use finalizers when external cleanup must occur before object deletion; make cleanup retryable.
- Update status conditions and observedGeneration so users can tell what has been processed.
- Scope RBAC to the exact resources and verbs required.
- Export metrics and logs for queue depth, errors, and reconciliation latency.
- Define behavior for process restarts and unavailable APIs or dependencies.

Kubebuilder and Operator SDK provide scaffolding, but generated code does not prove the business logic is correct. Use unit tests, envtest or equivalent API tests, and cluster-level lifecycle tests for install, upgrade, retry, and deletion.

## Exercise

Sketch a controller for a custom BackupPolicy. Define its desired fields, status conditions, child resources, finalizer behavior, and retry strategy. Simulate an external backup service returning a timeout twice before success; show why retries do not create duplicate backups.

## Quiz

1. Does a controller merely execute each event once? — No. It reconciles state again and again until observed state converges.
2. When is a finalizer useful? — When retryable cleanup of an external resource must finish before the Kubernetes object is removed.
3. Why should duplicate events be harmless? — Controllers can receive retries and repeated notifications; idempotence preserves the intended state.
4. Where should an external dependency error be reported? — In status conditions and operational logs/metrics, with a defined retry policy.
5. What should observedGeneration indicate? — Which generation of the desired object the controller has processed.

## References

- [Kubernetes controller pattern](https://kubernetes.io/docs/concepts/architecture/controller/)
- [Extending Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/)
- [Kubebuilder Book](https://book.kubebuilder.io/)
- [Operator SDK documentation](https://sdk.operatorframework.io/docs/)
- [Chapter bibliography](../../../references/README.en.md#14-advanced-topics-and-extensibility)

</div>
