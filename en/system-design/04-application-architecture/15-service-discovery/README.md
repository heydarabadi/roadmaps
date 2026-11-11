# Service Discovery

[فارسی](../../../../fa/system-design/04-application-architecture/15-service-discovery/README.md)

## Learning goals

- Explain why fixed instance addresses fail in a changing service fleet.
- Compare client-side and server-side discovery.
- Design registration, readiness, expiry, and graceful deregistration.
- Diagnose stale endpoints and discovery control-plane failures.

## Central idea

Dynamic service instances need an up-to-date way to find one another. Discovery can happen in a client library or in a proxy; health, cache lifetime, and identity all matter.

## Concept map

Workload starts → registers endpoint → readiness and health updates → clients or proxies discover → traffic shifts → endpoint expires or drains.

## Detailed lesson

### Why a fixed address is not enough

Instances appear and disappear during deployment, autoscaling, and failure. A client with a permanently configured address such as 10.0.1.12 may connect to a dead instance or an instance that has been replaced.

Service discovery finds usable endpoints by service name and may account for zone, version, health, or shard ownership. DNS may be enough for a relatively stable environment. A rapidly changing fleet may need a registry or orchestration control plane.

### Registration, health, and expiry

An instance can register itself at startup, or the deployment platform can register it. A heartbeat or lease prevents dead instances from remaining registered forever. But a heartbeat only shows that a process or agent responds; it does not prove that the instance can serve a request in time.

Readiness should reflect whether the instance can accept work: initialization is complete, configuration is valid, and critical dependencies are in an acceptable state. During shutdown, remove the instance from discovery first, stop assigning new requests, drain in-flight connections, and then terminate the process.

### Client-side and server-side discovery

With client-side discovery, each caller reads the endpoint list, considers health or zone, and selects a target. This distributes decisions but makes client libraries and caches more complex.

With server-side discovery, a reverse proxy or load balancer selects the instance. Clients are simpler, but the proxy becomes an important capacity and failure-path component.

A service mesh moves routing, mutual TLS, and telemetry policies into proxies such as sidecars. This can standardize behavior across services, but the control plane and debugging surface add operational cost.

### Cache and topology changes

Clients often cache endpoint lists. A very long TTL delays failover; asking the registry on every request can overload it and make it a hard dependency. A short cache, controlled fallback, bounded retry, and refresh after a connection error can help.

Beware of a refresh storm during an outage: if every client refreshes at once, the registry receives a surge exactly when the system is already degraded. Add backoff and avoid making an endpoint list refresh an unbounded retry loop.

### Region, identity, and security

Selecting an endpoint is not only about proximity. Data residency, health, capacity, and shard ownership may matter. Trust discovery responses, authenticate workloads (for example with mutual TLS), and do not publish private endpoints externally.

DNS-based discovery also inherits address caching and IP-change behavior. Keep internal and public naming policies separate.

### Troubleshooting

If a call cannot reach a service, inspect in order: the resolved name, cached endpoint list, registry status, readiness, route or load balancer, network policy, and TLS/workload identity.

A useful dashboard shows healthy endpoint count, stale registrations, publication delay, zone distribution, and failures to resolve or connect.

## Worked example

During a rolling deployment, a new instance should not receive traffic until it has loaded configuration and passed readiness checks. At shutdown, deregister it and drain active requests before process termination.

## Public engineering case study

[Uber: Technology stack foundations](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) describes service discovery and routing concerns in a large platform. Treat its internal tooling as an example of requirements at scale, not as a requirement for a smaller system.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| DNS discovery | The fleet changes infrequently and cached updates are acceptable | TTL and resolver behavior delay topology changes |
| Client-side registry | Callers need local endpoint choice or zone awareness | Client cache and load-balancing logic are duplicated |
| Proxy/load-balancer discovery | A central routing point simplifies clients | Proxy health, capacity, and availability become critical |
| Service mesh | Many services need shared traffic and identity policies | Sidecars and control plane increase resource and operational cost |

## Common pitfalls

- Stale endpoint entries after a deployment.
- Treating heartbeat success as proof of request readiness.
- Querying the registry on every request.
- Refreshing all clients at once during an outage.
- Forgetting graceful deregistration and connection draining.
- Returning private endpoints or unauthenticated service information.

## Short quiz

1. How does client-side discovery differ from server-side discovery?
2. Why does a heartbeat not prove that a service is ready?
3. How should a departing instance be handled?
4. What can happen if every caller refreshes the registry immediately after an outage?

### Answer key

1. A client library selects an endpoint in client-side discovery; a proxy or load balancer does so in server-side discovery.
2. It proves only that a signal was received; the service may still be unable to handle real traffic or a critical dependency may be failing.
3. Deregister it, stop new assignments, drain in-flight requests, then shut it down.
4. A refresh storm can overload the registry and worsen the outage.

## Exercise

Design discovery for a store’s order service. Specify registration owner, readiness signals, endpoint cache duration, client or proxy selection, identity, scale-in procedure, regional policy, and fallback during registry failure. Add a metric for stale registrations.

## Summary

Service discovery turns a changing fleet into routable endpoints. Define who registers instances, what “ready” means, how clients refresh safely, and how shutdown or control-plane failure is handled.

## Further reading

- [HashiCorp Consul: Service discovery](https://developer.hashicorp.com/consul/docs/concepts/service-discovery) — registration, DNS, and discovery concepts.
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/) — stable service abstraction for dynamic Pods.
- [Envoy: What is Envoy?](https://www.envoyproxy.io/docs/envoy/latest/intro/what_is_envoy) — proxy and service communication concepts.
- [Microsoft: Microservices architecture](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) — service communication and boundaries.
- [Uber: Technology stack foundations](https://www.uber.com/us/en/blog/tech-stack-part-one-foundation/) — public platform case study.
