# Containers and Service Mesh

## Learning goals

- Explain images, containers, registries, orchestration, and isolation boundaries.
- Identify what a service mesh adds and the costs it introduces.
- Design health checks, graceful shutdown, resource limits, and secure workload identity.

## Containers

A container image packages an application and its dependencies in a layered filesystem. A container is an isolated process using operating-system primitives, not a separate kernel or a complete virtual machine. Images should be reproducible, minimal, traceable to source, scanned, signed where possible, and promoted through environments rather than rebuilt differently at each stage.

Run as non-root, use read-only filesystems where practical, set CPU/memory requests and limits appropriate to workload, drop unnecessary capabilities, and avoid privileged mode. Do not put credentials in image layers. Keep state outside ephemeral containers unless persistence is explicitly designed. A container restart is not a recovery strategy for lost data.

An orchestrator schedules workloads, restarts failing processes, routes traffic, and manages configuration and secrets. Readiness determines whether a workload should receive traffic; liveness determines whether it should restart; startup probes can protect slow initialization. A readiness check that depends on an optional system may unnecessarily remove healthy instances during a partial outage.

## Service mesh

A service mesh commonly places a proxy beside or in front of each workload to provide service identity, encrypted transport, routing, retries, and telemetry. It can standardize policies across many services, but adds proxies, configuration, certificate lifecycle, resource use, failure modes, and operational expertise. Many small systems can implement needed resilience in a gateway and libraries without a mesh.

Do not blindly retry at multiple layers: retries multiply load and can cause cascading failures. Set one retry owner, per-hop deadlines, bounded attempts, and idempotency guarantees. Mesh telemetry observes network calls but does not automatically explain business outcomes.

## Worked example: checkout service

Build an immutable image, run it with a non-root identity and bounded resources, and configure a startup probe while schema migrations complete. Readiness begins only after the service can accept traffic. During termination, it stops receiving new requests and drains existing work. A mesh can encrypt and identify service calls, while the application continues to authorize business actions.

## Self-check quiz

1. Is a container a virtual machine? No; it is an isolated process sharing the host kernel.
2. Why should images be immutable and promoted? The same tested artifact can be traced and deployed consistently.
3. What is the distinction between readiness and liveness? Readiness controls traffic; liveness signals whether restart is needed.
4. What does a mesh not automatically provide? Correct business logic, authorization policy, or immunity from cascading failure.
5. Why avoid retries at every network layer? Multiplication can overwhelm a recovering dependency.

## Exercise

Specify secure runtime settings and deployment health behavior for an API container. Add a service-mesh decision with reasons for and against.

### Sample answer

Use a pinned, signed minimal image, non-root UID, read-only root filesystem, explicit writable temp path, dropped capabilities, secret injection, and resource requests/limits. Configure startup/readiness/liveness separately and graceful drain. Add a mesh only if consistent workload identity, mTLS, routing, or telemetry across many teams outweighs its proxy and operations cost.

## Further reading

- English: [Docker security](https://docs.docker.com/engine/security/), [Kubernetes probes](https://kubernetes.io/docs/concepts/configuration/liveness-readiness-startup-probes/), [Kubernetes security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/), [CNCF Cloud Native Landscape](https://landscape.cncf.io/), [Istio documentation](https://istio.io/latest/docs/), [Linkerd documentation](https://linkerd.io/2/overview/)
- Persian: [Kubernetes Persian guide](https://kubernetes.io/fa/docs/home/), [DNTips container articles](https://www.dntips.ir/)
