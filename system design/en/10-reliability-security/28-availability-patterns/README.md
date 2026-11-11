# Availability Patterns

[فارسی](../../../10-reliability-security/28-availability-patterns/README.md)

## Learning goals

- Explain how stamps, regional deployments, throttling, health checks, and queues affect availability.
- Estimate whether a surviving region can absorb failover traffic.
- Distinguish admission control from queueing.
- Identify common dependencies that can undermine isolation.

## Central idea

High availability comes from limiting blast radius, providing usable alternate paths, and controlling load. A pattern name by itself is not a guarantee.

## Concept map

Failure domain → independent capacity → health and routing → admission or buffering → user-visible success.

## Detailed lesson

### Deployment stamps

A deployment stamp is a relatively independent unit of application, storage, and capacity assigned a tenant or slice of traffic. If one stamp fails, impact can stay within that boundary and healthy stamps may keep serving—if reserved capacity is available.

Tenant assignment should be stable or safely movable. Deployments and upgrades across stamps need compatible contracts. Very small stamps raise operating cost; very large stamps increase blast radius.

### Geodes and regional deployment

A geode is a regional instance that serves nearby users. Routing should account for region, capacity, and health. The hardest issue is often data: which region owns each entity, how much replication lag is allowed, and what happens if two regions write at once?

Data residency and backup locations may also have legal constraints. Active deployments across regions without clear ownership can create conflicting data.

### Throttling and admission control

Throttling limits request rates to protect essential work under overload. A token bucket permits bounded bursts while enforcing an average rate. A leaky bucket smooths output. A fixed window is simple but can allow bursts at window boundaries; a sliding window is more precise but can cost more.

Set limits by user or tenant, endpoint, and request cost. Define the response, such as HTTP 429, and whether Retry-After is included. Match the limit to downstream capacity and ensure internal or privileged bypasses are controlled.

### Health endpoint monitoring

Liveness asks whether a process should restart; readiness asks whether it should receive traffic. A startup probe can allow a long initialization period.

Make health checks only as deep as necessary. If every probe synchronously checks every dependency, a dependency outage can create more load and mark the whole fleet unhealthy. A synthetic user-path check can reveal combined DNS, TLS, API, and database problems.

### Queue-based load leveling

A queue buffers work between arrival rate and worker capacity. Track depth, oldest message age, and work validity. If a task is useful for only two minutes but the oldest item is ten minutes old, the system is not usefully available for that task.

Define a backlog ceiling, admission policy, worker scaling, and dead-letter path together. Decide what happens when the queue itself is unavailable: reject clearly, use a limited durable fallback, or enter a documented degraded mode.

### Combine patterns without hiding shared failures

Stamps can isolate tenants, geodes can separate regions, throttling can protect capacity, health signals can detect readiness, and queues can absorb short bursts. Then inspect common dependencies such as identity, control plane, shared storage, or a single routing layer; any one may affect all stamps.

## Worked example

If one region fails, the surviving region must have enough tested capacity for the shifted load. Without it, failover can create a second outage.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Deployment stamps | Tenant or workload isolation limits blast radius | Shared control plane or database may remain common |
| Regional geodes | Geographic latency or regional continuity matters | Data ownership and replication conflicts |
| Throttling | Excess requests threaten core operations | Limits can be unfair or reject important work |
| Queue leveling | Work can wait within a defined deadline | Queue may hide overload as growing delay |

## Common pitfalls

- Failover capacity has never been load-tested.
- Health endpoints reveal sensitive details or make expensive checks.
- A queue merely moves an outage into a growing backlog.
- Throttling ignores cost differences among requests.
- Several isolated stamps still share one fragile identity provider.

## Short quiz

1. What boundary does a deployment stamp create?
2. Why must failover capacity be tested?
3. How does throttling differ from queueing?
4. Why can a deep health check worsen an incident?

### Answer key

1. A relatively independent deployment, capacity, and possibly data boundary.
2. The surviving region must absorb shifted peak load without becoming overloaded.
3. Throttling limits or rejects incoming work; queueing accepts work and adds delay while workers process it later.
4. It can put more load on an unhealthy dependency and mark many instances unhealthy at once.

## Exercise

Design availability for a regional sale. Define tenant/stamp boundaries, routing, health signals, request limits, queue capacity and oldest-job deadline. Calculate expected failover traffic and identify shared dependencies that could still cause a broad failure.

## Summary

Availability patterns protect a user journey only when isolation, capacity, routing, and data behavior agree. Test the surviving path and make overload visible rather than allowing it to turn into silent delay.

## Further reading

- [Azure Architecture Center: Reliability patterns](https://learn.microsoft.com/en-us/azure/architecture/patterns/category/resiliency) — pattern catalog for reliability.
- [Azure: Throttling pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/throttling) — admission and request-rate control.
- [Azure: Health Endpoint Monitoring](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) — readiness and endpoint checks.
- [Azure: Queue-Based Load Leveling](https://learn.microsoft.com/en-us/azure/architecture/patterns/queue-based-load-leveling) — buffering work.
- [AWS multi-Region fundamentals](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-multi-region-fundamentals/) — when regional recovery is justified.
- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/) — setting measurable availability expectations.
