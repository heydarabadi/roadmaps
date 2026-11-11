# Load Balancers and Reverse Proxies

[فارسی](../../../03-network-edge-communication/12-load-balancing/README.md)

## Learning goals

- Explain the overlapping roles of load balancers and reverse proxies.
- Compare Layer 4 and Layer 7 routing.
- Select a balancing method based on workload behavior.
- Design health checks, connection draining, and session handling.

## Central idea

A load balancer distributes requests or connections among usable backends. The layer, balancing algorithm, health policy, and session design must fit the traffic and failure model.

## Concept map

Client → proxy/load balancer → health and routing decision → backend → drain, retry, or failover.

## Detailed lesson

### Load balancer and reverse proxy roles

A load balancer presents multiple backends as one logical destination and distributes traffic among them. A reverse proxy sits in front of servers and forwards client requests; it may terminate TLS, modify headers, route by host or path, or cache responses.

The terms overlap: a reverse proxy can balance load, but a proxy does not necessarily distribute requests across several backends.

### Layer 4 and Layer 7

Layer 4 decisions use IP addresses, ports, and connections. This is often a simpler, lower-overhead path, but it has less application context.

Layer 7 understands protocols such as HTTP. It can send /api/orders to an order service and /images to a content service, route on host or selected headers, and apply application-level policy. It offers flexibility but requires parsing, may terminate TLS, and introduces more CPU and configuration complexity.

Choose based on routing and operational needs, then measure the resulting latency and capacity.

### Common balancing algorithms

- **Round robin** rotates among backends. It works best when capacity and request cost are similar.
- **Weighted round robin** sends more traffic to higher-capacity servers. Bad weights or changing traffic can create imbalance.
- **Least connections** chooses a backend with fewer active connections. Long-lived connections do not necessarily mean more work.
- **Random or power of two choices** can balance with little shared state.
- **Consistent hashing** maps related keys to stable backends, which can help locality and cache reuse; a hot key can still overload one target.

Test the algorithm with realistic request durations, connection lifetimes, and backend capacity. A more sophisticated algorithm can make worse decisions if its health or load information is inaccurate.

### Health checks, readiness, drain, and sessions

Liveness asks whether a process should restart. Readiness asks whether it can accept new traffic now. A health check that restarts every instance whenever a database briefly slows can create a restart storm.

During deployment, remove an instance from new traffic, allow active connections to finish (drain), and then stop it. Local in-memory sessions require stickiness and make failure handling harder. Prefer an external session store or a signed client token when appropriate.

### Scale-out and downstream capacity

Before adding backends, calculate the limits of the database, connection pool, and external services. If each instance opens 50 connections, 40 instances can create 2,000 connections. The load balancer's connection limits, timeouts, queues, and retry behavior must fit the overall system capacity.

Retries at the client and at the load balancer can multiply one request into several attempts. Define which layer owns retries and use idempotency where an operation can otherwise be applied twice.

## Worked example

An instance may accept TCP connections but take several seconds to complete work. If the health check measures only connectivity, the load balancer may continue sending it traffic. Readiness checks should reflect whether the service can accept work without turning every temporary dependency slowdown into a fleet-wide restart.

## Example configuration

~~~nginx
upstream api {
    least_conn;
    server api-1:8080;
    server api-2:8080;
}
~~~

The exact syntax and behavior depend on the proxy. This example shows only the idea of selecting among two backends.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Layer 4 balancing | Connection-level distribution is enough | No application-aware routing |
| Layer 7 reverse proxy | Host, path, or HTTP-aware routing is needed | Parsing, TLS, and complex rules add work |
| Sticky sessions | A legacy application depends on local session state | Failover and even load distribution become harder |
| Connection draining | Deployments should preserve in-flight requests | Long requests need bounded drain time and cancellation behavior |

## Common pitfalls

- Checking only whether a port accepts connections.
- Retrying at multiple layers without a global attempt budget.
- Keeping user state only on one backend.
- Assuming least-connections reflects CPU or request cost.
- Scaling the front end without checking database connection limits.
- Forgetting the load balancer itself needs redundancy and monitoring.

## Short quiz

1. What extra information can a Layer 7 balancer use compared with Layer 4?
2. Why is least-connections not always the best algorithm?
3. What is the difference between liveness and readiness?
4. What problem does connection draining address?

### Answer key

1. It can inspect application protocol details such as HTTP host, path, and selected headers.
2. Connection count may not represent request duration, CPU cost, or actual capacity.
3. Liveness asks whether a process should restart; readiness asks whether it should receive new traffic.
4. It gives in-flight requests time to finish before an instance is terminated or removed.

## Exercise

Design a deployment for two API instances. Specify layer, algorithm, readiness signal, timeout, retry ownership, draining period, session strategy, and what happens if the database becomes slow. Add a metric that would reveal uneven backend load.

## Summary

A load balancer is part of the request path and failure model. Choose its layer and algorithm for the workload, define readiness and draining, and keep its retries and connection growth within downstream capacity.

## Further reading

- [AWS Elastic Load Balancing](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html) — balancing concepts and managed implementations.
- [Envoy: What is Envoy?](https://www.envoyproxy.io/docs/envoy/latest/intro/what_is_envoy) — modern proxy architecture.
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/) — stable endpoints for changing workloads.
- [Azure: Health Endpoint Monitoring pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) — health-check design considerations.
- [Azure: Design to scale out](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/scale-out) — bottlenecks, state, and horizontal scaling.
