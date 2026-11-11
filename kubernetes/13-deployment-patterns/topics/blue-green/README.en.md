<div dir="ltr" align="left">

# Blue-Green Deployments

**Chapter:** [Deployment and delivery patterns](../../README.en.md) · **Persian:** [فارسی](README.md) · **Full lesson and lab:** [Canary and Blue-Green](../canary-bluegreen/README.en.md) · **More references:** [Deployment bibliography](../../../references/README.en.md#13-deployment-and-delivery)

## Mental model

Maintain two application stacks or Pod sets. **Blue** is the version serving primary traffic. **Green** is the candidate version, deployed separately and tested through a preview route. When Green is ready, switch the main route. If problems appear, route back to Blue only if Blue is still available and compatible with current data.

This gives a clear preview and controlled cutover. It temporarily requires capacity for both versions. A routing switch does not move open connections or reverse database schema changes.

## A simple Service-selector example

Give both Deployments the same application label and a distinct track label. The primary Service initially selects Blue:

~~~yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  selector:
    app: web
    track: blue
  ports:
    - port: 80
      targetPort: 8080
~~~

Run Green with track=green and create a separate, access-controlled preview Service. After successful checks, change the primary Service selector to track=green and apply it. Inspect EndpointSlices to confirm the expected ready backends are selected. To revert, point the selector to Blue, provided Blue remains healthy and compatible.

For production, use a unique or immutable image reference and configure resources, readiness, security, and dependencies. Do not accidentally expose a preview route publicly; it may alter real data or reveal an unfinished endpoint.

## Operational sequence

1. Deploy the candidate with production-compatible configuration.
2. Verify Pod readiness and dependencies; Running alone is not proof of service health.
3. Run smoke and integration checks through the preview path.
4. Record the stable baseline and error/latency thresholds.
5. Switch the main route and watch endpoints and user-facing behavior.
6. If health criteria fail, follow the runbook to route back and inspect candidate-written data separately.
7. Keep Blue through the agreed observation window; remove the extra stack only after rollback risk and active jobs are considered.

## State and connection risks

Suppose Green writes a database format Blue cannot read. Switching the Service back can make every request fail. Preserve old/new schema compatibility during rollout, delay destructive changes until the rollback window ends, and apply the same care to queue messages, cache keys, and sessions.

Changing a Service selector changes which endpoints receive new connections as control-plane updates propagate. It does not necessarily move existing connections. Test readiness, EndpointSlice propagation, draining, load balancers, and session affinity. Blue-Green alone does not guarantee zero downtime.

## When to use it

Consider this strategy when a complete preview is valuable, you can afford two environments temporarily, and the cutover and rollback path are explicit. It may not fit if the extra capacity is unavailable or shared state is incompatible.

## Quiz

1. Which version is Blue? — The current version serving primary traffic.
2. Is a running Green sufficient for cutover? — No. Test the user path, dependencies, readiness, and health signals.
3. What is the rollback advantage? — If the old Blue version is preserved and compatible, traffic can be routed back.
4. Does switching the Service back restore the schema? — No. Routing and data recovery are different operations.
5. What is a major cost? — Running and maintaining both stacks at once.
6. Is a selector change instantaneous for every connection? — No. Endpoint propagation and existing connections matter.

## References

- [Kubernetes Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Blue-Green strategy in Argo Rollouts](https://argoproj.github.io/argo-rollouts/features/bluegreen/)
- [Argo Rollouts analysis](https://argoproj.github.io/argo-rollouts/features/analysis/)
- [Full lesson and lab](../canary-bluegreen/README.en.md)

</div>
