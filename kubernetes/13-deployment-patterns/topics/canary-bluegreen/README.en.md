<div dir="ltr" align="left">

# Full Lesson: Canary and Blue-Green Releases

**Chapter:** [Deployment and delivery patterns](../../README.en.md)  
**Persian edition:** [فارسی](README.md)  
**Prerequisites:** [Running applications](../../../04-running-applications/README.en.md), [Networking](../../../05-services-networking/README.en.md), and [Observability](../../../09-monitoring-logging/README.en.md).  
**More references:** [Deployment bibliography](../../../references/README.en.md#13-deployment-and-delivery)

## The problem and vocabulary

A Pod becoming Ready does not prove that the application behaves correctly. A new version may fail for one type of request, slow down, write an incompatible format, or overload a dependency. Progressive delivery asks how to limit the impact of a candidate and what evidence should determine whether to continue, pause, or return.

- **Stable:** the version receiving primary traffic.
- **Candidate:** the version being evaluated.
- **Promotion:** accepting the candidate as the primary version.
- **Rollback:** returning traffic or workload to a previous version; this does not necessarily restore data.
- **Blast radius:** the users and systems a failing change can affect.
- **Observation window:** the time and volume of evidence used to make the rollout decision.

## Canary releases

A canary initially sends a small share of requests, or a defined cohort, to the candidate. If health signals remain within agreed bounds, exposure increases. If regression appears, the rollout stops or reverts.

| Example step | Candidate share | Observation | Decision |
| --- | ---: | --- | --- |
| Baseline | 0% real traffic | Smoke checks | Verify startup and dependencies |
| Small | 5% | 10 minutes | Check errors and latency |
| Medium | 20% | 15 minutes | Check technical and product signals |
| Large | 50% | 20 minutes | Look for meaningful regression |
| Complete | 100% | Enhanced monitoring | Finish the care window |

These percentages and durations are examples, not universal rules. Ten minutes containing five requests is not strong statistical evidence. The window should account for peak and low traffic, request rate, and how long it takes for a failure to surface. If only one region or payment method fails, global averages can hide it.

### Kubernetes mechanisms

A standard Deployment RollingUpdate controls old and new Pod counts and uses readiness to determine availability. It does not itself implement an exact 5% HTTP request weight, a user-specific cohort, or metric-based automatic rollback.

If versions with different replica counts share a Service, the request split is only approximate. Load balancing operates over endpoints and connections, and affinity or long-lived connections can skew the observed percentage. Precise request weights commonly require a compatible Gateway/Ingress, service mesh, load balancer, or progressive-delivery controller.

Argo Rollouts and Flagger can coordinate steps and metric analysis. Configure and practice the router, metric source, thresholds, observation windows, and rollback action as one system. Installing a tool does not create a safe decision rule automatically.

Conceptual Argo Rollout fragment:

~~~yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: checkout
spec:
  replicas: 10
  selector:
    matchLabels:
      app: checkout
  template:
    metadata:
      labels:
        app: checkout
    spec:
      containers:
        - name: app
          image: example.invalid/checkout:2026-11-10
  strategy:
    canary:
      steps:
        - setWeight: 5
        - pause:
            duration: 10m
        - setWeight: 20
        - pause:
            duration: 15m
        - setWeight: 50
        - pause: {}
~~~

This fragment is not a complete deployable configuration and uses a placeholder image. It omits ports, probes, resources, Services, and traffic-router configuration. With a connected router, setWeight can control request weight; without one, the controller may only change replica ratios. A pause alone does not evaluate metrics; analysis must be configured separately.

## Blue-Green releases

Two environments are prepared at the same time:

- **Blue** is the current version receiving production traffic.
- **Green** is the replacement, tested on a preview path before cutover.

When Green passes checks, switch the primary route. If there is a problem, route back to Blue only if it is still running and compatible with the state created by Green.

Simple example with two Deployments and a Service that selects Blue:

~~~yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
      track: blue
  template:
    metadata:
      labels:
        app: web
        track: blue
    spec:
      containers:
        - name: web
          image: nginx:1.27
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
      track: green
  template:
    metadata:
      labels:
        app: web
        track: green
    spec:
      containers:
        - name: web
          image: nginx:1.28
---
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
      targetPort: 80
~~~

Create a separate, restricted preview Service for Green. For cutover, change the main Service selector from blue to green. A selector change does not instantly move every existing connection; test endpoint readiness, draining, the load balancer, and sessions. In production, pin images and define probes, resources, and configuration.

## Decide whether to continue or stop

Capture a stable baseline under comparable load. For each signal, define its owner, source, evaluation interval, minimum sample, and action. Useful candidate-specific indicators can include:

- 5xx rate and successful request rate.
- p50, p95, or p99 latency.
- Saturation, CPU throttling, memory use, and restart count.
- Queue depth and dependency latency.
- A relevant product outcome, when measurable and appropriate.
- Migration errors, write conflicts, and replication lag.

Illustrative rule: if candidate errors exceed stable by at least one percentage point for two consecutive windows, or candidate p95 is persistently more than 20% above baseline, do not increase exposure; pause or revert according to the runbook. These thresholds are examples only. Set the actual values from the service SLO and normal variability before the rollout, not after seeing the result.

## Compare and choose

| Property | Canary | Blue-Green |
| --- | --- | --- |
| Candidate exposure | Increased in traffic steps | Full replacement environment, then route switch |
| Failure discovery | Gradual under production traffic | Preview first, then after cutover |
| Failure impact | Bounded by share/cohort if routing is correct | Low before switch; potentially broad after switch |
| Capacity | Both versions run, often at partial scale | Often two complete environments |
| Routing need | A precise weight needs compatible routing | Route/selector change, with propagation and connections considered |
| Rollback | Reduce candidate exposure or return it to zero | Route back to Blue if data and old version remain compatible |
| Main operational cost | Routing and metric analysis | Peak capacity and retaining the old stack |
| Best fit | Meaningful traffic splitting and staged evidence | Full preview and a clear cutover path |

Canary is useful when traffic can be divided meaningfully and metrics can be analyzed per version. Blue-Green fits when a complete second environment can be prepared. RollingUpdate is usually simpler for ordinary changes. Recreate may fit an incompatible change if downtime is acceptable. Feature flags decouple capability exposure from image deployment but add code paths and cleanup work. These approaches can be combined.

## Databases and rollback

The old application may require the old database shape. If Green removes a column or writes a format Blue cannot read, routing back to Blue will not restore service. Similar risks apply to queue messages, sessions, cache keys, and files.

A common expand–migrate–contract sequence is:

1. **Expand:** add the new schema while retaining the old shape.
2. **Maintain compatibility:** deploy code that can read and, where needed, write both formats.
3. **Migrate:** move data and verify counts, checksums, and application behavior.
4. **Contract:** remove the old schema only after old app versions are gone and the recovery window closes.

Code rollback does not reverse data. The runbook should identify when to roll back, when to forward-fix, when to restore, and who approves a data recovery action.

## Release checklist

**Before:** unique image identity; correct context and namespace; probes test meaningful readiness; capacity exists for both versions; baseline and stop rule are known; schema, cache, queue, and session compatibility are reviewed; rollback has been exercised.

**During:** advance one step at a time; inspect version-specific dashboards; record time, exposure, and decisions; do not increase traffic after a stop signal; distinguish Pod Running from a healthy user journey.

**After:** keep enhanced alerts through the observation window; then remove the old version only after considering active work, state, and rollback need; review incidents with a timeline, customer impact, and missed signals.

## Hands-on lab

### Native Blue-Green switch

1. Create a disposable namespace in kind or minikube.
2. Deploy two copies with track=blue and track=green labels.
3. Connect the main Service to Blue and a preview Service to Green.
4. Confirm each response using port-forwarding or an in-cluster request.
5. Change the main Service selector to Green; inspect EndpointSlices and selected Pods.
6. Send several requests and switch the selector back to Blue.
7. Explain why the selector cannot move an existing connection or undo a database transaction.

### Canary design and incident scenario

Design steps at 1%, 5%, 20%, 50%, and 100% for a checkout service receiving 20,000 requests per minute. For each step, state the observation duration or sample size, metrics, and stop condition.

Now assume all signals look healthy at 5%, but at 20% the card payment error rate rises for one country while the global average stays nearly flat. Stop exposure, segment metrics by country and dependency, inspect ambiguous or duplicate payment outcomes, and record which signal was missing. This is a teaching scenario, not a claim about a named company incident.

## Troubleshooting

| Symptom | Likely cause | First checks |
| --- | --- | --- |
| Candidate gets no traffic | Wrong selector or route | Compare Services, EndpointSlices, route, and labels |
| Observed percentage is wrong | Only replica ratio changed | Verify the connected traffic router and connection behavior |
| Preview returns the old version | Wrong selector or namespace | Inspect Pod labels and Service selectors |
| Errors rise after cutover | Candidate config, Secret, or dependency is faulty | Stop exposure per runbook; inspect events and release logs |
| Rollback fails | Blue was removed or schema is incompatible | Inspect data compatibility and old-version health separately |
| Canary passes but incident follows | Window, cohort, or signal was insufficient | Revisit sample size, duration, and metric segmentation |

## Quiz with explanations

1. **What does RollingUpdate control, and what does it not?** It controls Pod replacement and surge/unavailable bounds; it does not provide exact request percentages or metric-based rollback by itself.
2. **Why is 10% of Pods not necessarily 10% of requests?** Traffic is distributed over endpoints and connections; affinity and long-lived connections also matter.
3. **What must be true for a Blue-Green rollback?** Blue remains available and compatible with current data.
4. **Why separate metrics by version?** A larger stable population can hide candidate regression in aggregate statistics.
5. **Are five error-free requests enough to promote?** No. A tiny sample may miss rare failures and special cohorts.
6. **Can an app rollback fix a removed database column?** Not by itself. Preserve compatibility and plan expansion, migration, and contraction.
7. **Why define thresholds before rollout?** Choosing a threshold afterward can bias the decision to continue or stop.
8. **Should Blue be deleted immediately after Green reaches 100%?** No. Consider the observation window, active jobs, shared state, and recovery plan.
9. **Do these release patterns replace backups?** No. Backup, restore, and disaster recovery are separate controls.
10. **What if the service has too little traffic for a useful canary?** Use a safer rolling release, staging, a feature flag, or a simple Blue-Green approach according to capacity and evidence. A canary with too little data has limited value.

## References

- [Kubernetes Deployments and RollingUpdate](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Argo Rollouts concepts](https://argoproj.github.io/argo-rollouts/concepts/)
- [Argo Rollouts Canary](https://argoproj.github.io/argo-rollouts/features/canary/)
- [Argo Rollouts Blue-Green](https://argoproj.github.io/argo-rollouts/features/bluegreen/)
- [Argo Rollouts analysis](https://argoproj.github.io/argo-rollouts/features/analysis/)
- [Flagger promotion and rollback](https://docs.flagger.app/usage/how-it-works)
- [Chapter bibliography](../../../references/README.en.md#13-deployment-and-delivery)

</div>
