<div dir="ltr" align="left">

# Kubernetes API Extension Points

**Chapter:** [Advanced topics](../../README.en.md) · **Persian:** [فارسی](README.md) · **More references:** [Advanced topics bibliography](../../../references/README.en.md#14-advanced-topics-and-extensibility)

## Extension options

- **CRD:** The main API server stores and validates a custom declarative type. This is a common choice for new resource kinds.
- **API aggregation:** The API server proxies a selected group/version to a separate extension API server.
- **Admission webhook:** A service validates or mutates API write requests before persistence.
- **Controller:** A client watches resources and reconciles desired state into action.

A simplified write path includes authentication, authorization, admission, validation, and persistence. Exact ordering and extension behavior can depend on the API operation and version; consult the documentation for the release you operate.

## Production-grade webhooks

An unavailable or slow webhook can delay or block API requests. Keep its scope narrow, use accurate selectors, rotate certificates, and monitor latency, errors, and availability. Choose timeout and failurePolicy deliberately:

- **Fail-open** can permit a request when a webhook is unavailable, which may bypass a desired policy.
- **Fail-closed** can reject matching requests during an outage, which may block workloads and operators.

Neither setting is universally correct. Choose based on threat model and recovery requirements. Test webhook failure behavior before production.

## How to choose

Use a CRD when the need is a declarative resource type. Use aggregation when a separate API server implementation is needed. Use admission to enforce or mutate request-time policy. Use a controller for work that should happen after objects are stored. Before building an extension, check existing built-in APIs and maintained controllers.

## Quiz

1. Which extension point validates or mutates API requests? — Admission.
2. How do CRDs and API aggregation differ? — A CRD is served by the main API server; aggregation proxies a group to another API server.
3. What can fail-closed behavior do during an outage? — Reject matching requests and interrupt API operations.
4. Why keep webhook scope narrow? — To reduce its impact on API availability and limit unnecessary processing.
5. Does a mutating webhook replace a controller? — No. It changes the admitted request; a controller reconciles ongoing state.

## References

- [Extending the Kubernetes API](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/)
- [Dynamic admission control](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/)
- [Admission webhook good practices](https://kubernetes.io/docs/concepts/cluster-administration/admission-webhooks-good-practices/)
- [API aggregation layer](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/apiserver-aggregation/)
- [Chapter bibliography](../../../references/README.en.md#14-advanced-topics-and-extensibility)

</div>
