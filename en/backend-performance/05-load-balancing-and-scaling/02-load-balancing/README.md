<div dir="ltr" align="left">

[فارسی](../../../../fa/backend-performance/05-load-balancing-and-scaling/02-load-balancing/README.md) · English

# 5.2 Load Balancing

A load balancer chooses a destination for requests among available instances. It may distribute work, hide backend addresses, and remove an unavailable destination from routing. It does not create application, database, network, or downstream capacity; it makes use of existing capacity. **The examples are educational and are not measurements from a production service.**

**Sources checked: 2026-11-10; lesson work and added-link checks: 2026-11-11.** This lesson is language- and product-independent except for explicitly named product behavior.

## Learning outcomes

- Explain the difference between Layer 4 connection routing and Layer 7 HTTP-aware routing.
- Compare round robin, weighted, least-connections, and hash/affinity algorithms and their costs.
- Use health checks, readiness, and draining in instance lifecycle.
- Evaluate sessions, long connections, retries, queues, and noisy neighbors against real balance.
- Include load-balancer failure and the no-healthy-destination case in design.

## Mental model: choose a destination, then control the work

~~~mermaid
flowchart LR
    C[Client] --> B[Load balancer]
    H[Health and readiness] -.-> B
    B --> A[Ready instance A]
    B --> D[Ready instance B]
    A --> S[Shared state and dependencies]
    D --> S
~~~

Healthy instances A and B do not mean that shared dependency S has unlimited capacity. A new instance should be registered and ready before it receives traffic. For departure, first stop new work, then drain active work. This lifecycle works with [horizontal scaling](../01-horizontal-and-vertical-scaling/README.en.md), but choosing to add instances is a separate decision.

## Prerequisites: routing layer and connection lifetime

At Layer 4, routing is generally based on network/transport information such as IP, port, and protocol; a TCP/UDP flow is mapped to a destination. At Layer 7, an HTTP proxy may choose by host, path, header, or cookie. Inspecting HTTPS content requires terminating TLS at an appropriate point; define encryption and trust for the backend path too.

Read the implementation’s documentation to learn the unit it selects. One HTTP/2 connection can carry multiple concurrent requests; one WebSocket can remain open for hours. Equal connection counts do not mean equal work, and adding a server does not necessarily redistribute existing long-lived connections.

## Algorithms and trade-offs

| Method | Selection rule | Use and limit |
| --- | --- | --- |
| Round robin | choose destinations in turn | simple start for similar destinations and work; does not measure current cost |
| Weighted round robin | larger weight receives a larger long-run share | different capacities; recheck weights after resource or workload changes |
| Least connections | choose the destination with fewer active connections | useful for connections of varying duration; few connections do not prove low CPU or work |
| Hash / affinity | map a key such as cookie or IP to a destination | stable routing and some state/cache needs; hot keys, NAT, and membership changes can cause imbalance |

These definitions and the possibility of choosing a new destination for a later request match NGINX’s documented behavior. No algorithm knows the actual cost of every request in advance. A heavy tenant may need quotas, concurrency limits, or a separate pool/queue; weighted routing or hashing alone does not guarantee fairness.

## State and sticky sessions

If a login session exists only in instance A’s memory, the next request to B may be unknown. Affinity reduces this problem while A remains available, but does not create durable state or failover recovery. IP hashing behind NAT can concentrate many users on one destination. Shared state can increase routing freedom, but its latency, availability, and consistency need accounting. A live call or long-lived connection may inherently belong to one host and need a reconnect/recovery protocol to move.

## Health checks and destination lifecycle

An active check periodically sends a probe; a passive check infers health from real traffic failures. An open port only proves a process is reachable. Readiness asks whether an instance can handle real expected work now. Do not treat readiness and liveness as interchangeable: repeatedly restarting every process because a shared dependency is down can worsen recovery.

Make health checks low-cost, bounded by a timeout, and explicit about success. Probe intervals and failure thresholds trade detection speed against false removal. A deep probe that makes every API unhealthy when a shared database fails must align with admission control and recovery. Also monitor the real user path or a synthetic request.

Behavior when every destination is unhealthy is product-specific. AWS Application Load Balancer documents a fail-open case when all registered targets are unhealthy; it can send traffic to those targets. A health check therefore does not universally guarantee that all unhealthy destinations stop receiving traffic.

For deploy or scale-in, put a destination in drain: it accepts no new work, existing requests/connections finish within a limit, then the process stops. WebSockets and long jobs cannot rely on an infinite drain time; design controlled disconnect and recovery.

## Worked example: equal requests, unequal work

This is an educational scenario. A and B each have one single-worker slot. Six jobs arrive in the listed order at time zero. Service time is the job cost; ignore network and other overhead.

~~~text
jobs (ms): 100, 10, 100, 10, 100, 10
round robin:
  A -> jobs 1, 3, 5 -> finish at 100, 200, 300 ms
  B -> jobs 2, 4, 6 -> finish at 10, 20, 30 ms
~~~

Each destination receives three requests, but A receives ten times the work. Its queue remains until 300ms. Switching to least connections does not guarantee a fix: its counter must represent actual in-flight work, which may not be true with simultaneous arrivals or multiplexed connections. Compare queues and tail latency per destination as the request mix changes.

In a separate capacity example, A can sustain 100 and B 200 lightweight requests/s. Equal weights send about 120 to each of a 240 requests/s load, exceeding A’s capacity. A 1:2 weight ratio sends about 80:160 over time, assuming similar work and no shared bottleneck. If B fails, only 100 capacity remains and 140 requests/s are excess. Changing the algorithm cannot create capacity; limit admission or provide replacement capacity.

## Worked exercise

1. Redistribute jobs with the order 100, 100, 100, 10, 10, 10 and calculate total service time at each destination.
2. In the weighted A/B example, remove B from the healthy set. Calculate remaining capacity, excess load, and a suitable response.
3. A session is local to B. What data is needed to continue after B is removed, and where must it live?

**Solution:** A gets jobs 1, 3, and 5: 100+100+10=210ms. B gets 100+10+10=120ms. With B removed, capacity is 100 requests/s, so load exceeds it by 140 requests/s. Health detection does not add resources; shed or limit work and provide replacement capacity. A local session needs recoverable or shared state to continue on another instance; without it, continuity is not guaranteed. This is not a test result from a real load balancer.

## First-party evidence: Discord voice placement

In a first-party report dated June 9, 2026, Discord says each voice call has one SFU instance and participants remain connected to that host during the call. Its Iceland experiment improved local calls but made the path worse for non-local participants in mixed calls, so placement had to account for participant geography. In Europe it also investigated application-level send starvation and Softirq contention on vCPUs.

**Learning and limit:** A nearer destination or more instances does not replace suitable placement and queue/scheduling analysis. This is evidence about stateful voice placement, not a comparison of round robin and least-connections for HTTP; its numbers do not transfer to an ordinary API.

## Retries, queues, and common failures

After a proxy timeout, the original instance may still be working or may already have committed. Sending a state-changing request to another destination without idempotency can duplicate its effect. Define an end-to-end time budget, bounded attempts, backoff/jitter, and one clear retry owner. An unbounded proxy or backend queue delays accepted work until clients time out and retry. AWS’s load-shedding guidance explains how overload and retries can reduce successful work.

| Failure | Signal | Inspect or control |
| --- | --- | --- |
| Health probe returns 200 but work fails | real request errors with healthy targets | meaningful readiness and end-to-end monitoring |
| Destinations removed during a short spike | flapping and sudden pressure on survivors | thresholds, timeout, failure capacity, recovery policy |
| Equal split across unequal capacity | high p99 on one destination and spare capacity elsewhere | capacity weights and workload mix |
| Connections counted instead of work | similar connection count but different queue/CPU | active requests, queue, service time per target |
| One tenant consumes shared resources | overall metric looks fine, other tenants slow | quotas and separate pool/queue for sensitive work |
| Load balancer is a bottleneck or failure point | backend idle, errors/queue at ingress | connection/TLS/network capacity, redundancy, ingress failover |

- [ ] Routing unit, protocol, TLS, and affinity need are known.
- [ ] Destination capacity and weights are measured with representative work.
- [ ] Rate, p95/p99, errors, active connections, and per-target queue are visible.
- [ ] Probe, timeout, thresholds, and no-healthy-target policy are defined.
- [ ] Readiness, warm-up, and drain behavior are observable.
- [ ] Sessions and long-lived connections have a recovery path.
- [ ] Queue/concurrency limits, retry budget, and idempotency are explicit.
- [ ] Ingress redundancy and capacity after a failure match the service goal.

## Self-check

1. How does load balancing differ from scale-out?
2. For A at capacity 100 and B at 200 with equal-cost requests, what initial weight ratio fits, and why revisit it?
3. Why does least connections not always choose the lowest-CPU target?
4. Does a healthy check prove all user paths work?
5. In the weighted example, does round robin on A alone handle 240 requests/s after B fails?
6. What risk comes from retrying a reservation-creating request after timeout?
7. How does sticky session differ from recoverable shared state?
8. Why drain a destination before removing it?

### Answers with reasoning

1. The first selects a destination; the second increases the number of instances. Routing can change while capacity stays the same.
2. 1:2 if each request costs the same. Actual capacity, request mix, and resource state change, so weights need review.
3. A connection is not a direct measure of work. Request cost, multiplexing, and I/O wait can differ.
4. No. A probe covers only its tested contract; real paths, data, and dependencies can differ. All-unhealthy behavior also depends on product.
5. No. Only 100 capacity remains, leaving 140 requests/s in excess; an algorithm cannot create capacity.
6. The first destination may already have completed the reservation; a retry may duplicate it. Use idempotency and bounded retry.
7. Sticky routing keeps a preferred path; shared state supplies the data needed by a replacement instance. Affinity alone does not preserve local memory.
8. Stop new work and let accepted work finish or recover. Long connections also need a defined end/reconnect policy.

## Optional further reading

This lesson teaches its mechanisms and worked calculations. External links are optional enrichment, and some behavior is product-specific.

- Persian, complementary: [What is a load balancer? — Mobinhost](https://www.mobinhost.com/mag/what-is-load-balancer/) introduces layers and health checks. Broad availability claims are not guarantees; check the product manual.
- English, official: [NGINX HTTP load balancing](https://nginx.org/en/docs/http/load_balancing.html) documents round robin, least connections, weights, and session affinity.
- English, official: [AWS ALB target health checks](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html) documents thresholds, draining, and ALB-specific fail-open behavior.
- English, official: [Azure load-balancing pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/load-balancing) discusses routing among available instances and design choices.
- English, official: [Google Cloud load-balancing overview](https://cloud.google.com/load-balancing/docs/load-balancing-overview) describes that product’s global and regional layers.
- English, first-party case: [Discord voice at the edge](https://discord.com/blog/how-we-moved-discord-voice-to-the-edge) describes stateful placement and network/scheduling analysis.
- English, operational guidance: [AWS load shedding to avoid overload](https://aws.amazon.com/builders-library/using-load-shedding-to-avoid-overload/) discusses queues, retries, and protecting successful work.

**Navigation:** [Scaling chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Previous: Horizontal and vertical scaling](../01-horizontal-and-vertical-scaling/README.en.md) · [Timeouts and retries](../../06-code-optimization/07-timeouts-and-retries/README.en.md) · [Background jobs](../../03-asynchronism/01-background-jobs/README.en.md) · [Monitoring](../../07-monitoring-and-logging/01-metrics-logs-and-traces/README.en.md)

</div>
