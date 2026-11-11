<div dir="ltr" align="left">

# Chapter 14: Advanced Topics and Extensibility

**Persian edition:** [فارسی](../../../fa/kubernetes/14-advanced-topics/README.md) · **Reference library:** [Advanced Kubernetes resources](../references/README.md#14-advanced-topics-and-extensibility)

## When should you extend Kubernetes?

Kubernetes is designed for automation and offers extension points such as custom resources, controllers, admission, API aggregation, and scheduling plugins. Every extension also adds a dependency, security boundary, upgrade path, and on-call responsibility. First ask whether built-in APIs, policy tools, or a small external service solve the problem with less operational cost.

## Custom resources and controllers

A CustomResourceDefinition (CRD) introduces an API kind with a group, version, scope, and schema. The API server validates and stores instances of that kind. A controller or operator adds behavior by observing desired state and reconciling real resources toward it.

Controllers should be idempotent because events can repeat. Keep reconciliation retryable, report status and conditions, and design deletion cleanup that can recover after restarts. A CRD without a controller is declarative data, not an automated operational feature.

## Scheduling and API extensions

Use a custom scheduler plugin only when existing placement tools—resource requests, affinity, taints, tolerations, and topology spread—cannot express a stable policy. A plugin or separate scheduler brings version compatibility, metrics, failure handling, and support costs.

API aggregation proxies selected API groups to a separate API server; CRDs are usually simpler for common declarative types. Admission webhooks can validate or mutate requests, but availability and latency of the webhook can affect API writes. Define timeout, failure policy, scope, certificate rotation, and recovery deliberately.

## Responsible extension design

- Name an owner, support model, upgrade path, and API deprecation policy.
- Grant the extension the least RBAC permissions it needs.
- Add logs, metrics, alerts, timeouts, and explicit failure behavior.
- Plan CRD version conversion, storage version migration, and backup/restore.
- Test retries, process restarts, dependency outage, and deletion.
- Remove unused extensions and document API migrations.

## Quiz

1. Does a CRD alone operate a custom resource? — No. A controller usually implements the reconciliation behavior.
2. Why should reconcile be idempotent? — Events and retries can happen more than once.
3. CRD or API aggregation? — A CRD adds a type to the main API server; aggregation proxies an API group to a separate API server.
4. Why is a custom scheduler expensive to own? — It must remain compatible with scheduler versions and be operated, secured, observed, and recovered.
5. What is an admission-webhook operational risk? — A slow or unavailable webhook can delay or reject API requests, depending on policy.

## References

- [Extending Kubernetes](https://kubernetes.io/docs/concepts/extend-kubernetes/)
- [Custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- [Admission controllers](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)
- [Scheduling Framework](https://kubernetes.io/docs/concepts/scheduling-eviction/scheduling-framework/)
- [Chapter bibliography](../references/README.md#14-advanced-topics-and-extensibility)

</div>
