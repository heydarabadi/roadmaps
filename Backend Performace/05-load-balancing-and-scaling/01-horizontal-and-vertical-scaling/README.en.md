<div dir="ltr" align="left">

[فارسی](README.md) · English

# 5.1 Horizontal and Vertical Scaling

Scaling changes available resources to handle required load. Vertical scaling makes one instance larger or smaller; horizontal scaling changes the number of instances. The goal is to keep response time and errors within acceptable bounds at a reasonable cost, not merely to increase CPU or server count.

**Sources checked: 2026-11-10; lesson work and added-reference checks: 2026-11-11.** The lesson is language- and product-independent except where a named system is cited.

## Learning outcomes

After this lesson, you can:

- Distinguish Scale Up, Scale Down, Scale Out, and Scale In.
- Choose a larger instance or more instances from evidence about the bottleneck.
- Explain how state, sessions, connection pools, and queues affect multi-instance growth.
- Include failure capacity and autoscaling delay in a simple capacity calculation.
- Recognize expensive growth that does not result in more successful work.

## Mental model and comparison

| Decision | Change | Often suitable for | Cost and limit |
| --- | --- | --- | --- |
| Scale Up / Down | More or fewer CPU, memory, or I/O resources on one instance | Work that is hard to divide or bottlenecked on one resource | Hardware ceiling, possible restart, larger failure domain |
| Scale Out / In | More or fewer instances | Requests or jobs that can be distributed | Requires routing, state, coordination, and multi-instance operations |

Eight CPU cores do not guarantee an eightfold speedup for single-threaded work. Scaling out also does not help if every request waits on a lock for the same database row; it can only add more waiters. A combination may be appropriate: a reasonable instance size and enough instances for demand and failure capacity. Microsoft’s scaling/partitioning guidance connects the choice to divisibility of work and dependency limits.

## Step-by-step decision path

1. **Describe the load unit.** Two hundred light requests are not equivalent to two hundred heavy reports. Record route mix, data size, concurrency, and p95 goal.
2. **Find the bottleneck.** Is it instance CPU, memory, disk, network, a lock, or dependency wait? Low average CPU can hide one saturated core or a database wait.
3. **Define what can be replicated.** Identify the API, worker, or resource group that needs to grow together. Sum connection pools and queue capacity. Two processes on one host still share its CPU and network.
4. **Set growth limits.** More instances must not exceed database, external-service, licensing, budget, or network limits. Usable throughput is bounded by the weakest required dependency.
5. **Design both growth and reduction.** A new instance must start, warm its cache, and become ready before receiving work. During scale-in, stop accepting new work and drain active work or transfer ownership clearly. AWS dynamic scaling guidance emphasizes choosing a signal appropriate to the load and evaluating both directions.

**Poor-fit cases:** Scale Up does not create redundancy against loss of the only server and does not fix an external-service limit. Scale Out before clarifying state ownership, or while a shared database is saturated, may add cost and contention. Fix or bound the constraint first.

## State and sessions: prerequisites for growth

Stateless means the next request’s correctness does not depend on the previous instance’s local memory; it does not mean the system has no data or database. A session or cart can live in a shared store or, under a clear security contract, suitable client-side state. A shared store itself needs availability, TTL, capacity, and concurrency rules.

For a stateful component such as a database, durable queue, or live-call coordinator, duplicating processes does not duplicate state correctly. Define ownership, synchronization, failover, and partitioning. Sticky sessions only prefer the same instance; they do not copy local state or protect it if that instance fails. The same issue applies to files on local disks and scheduled jobs that every instance might run. Non-duplicated work needs explicit ownership/locking and idempotency.

**Noisy neighbor:** One tenant or job may consume shared CPU, I/O, cache, or connections. Separate queues, quotas, concurrency limits, or pools for sensitive workloads can be more useful than indiscriminate scaling. Adding workers without a downstream limit can saturate a dependency.

## Worked example: capacity with a dependency constraint

Assume an educational reservation API has a p95 target below 250ms, incoming load of 180 requests per second, and measured stable capacity of 100 requests per second per instance at that target. Assume traffic is balanced and the database supports 220 similar requests per second.

~~~text
normal minimum = ceil(180 / 100) = 2 instances
one-instance failure: (N - 1) * 100 >= 180
therefore N >= 3

3 instances: application capacity = 300 req/s
shared database capacity = 220 req/s
system upper bound <= min(300, 220) = 220 req/s
~~~

Two instances meet normal load; three meet the stated one-instance-failure constraint. This is only a starting bound: uneven distribution, capacity variation, retries, and request mix still matter. The 220 figure is a hypothetical dependency ceiling, not a p95 guarantee for every load.

If each instance’s pool allows 60 connections, three instances may offer 180 connections. If this API’s database budget is only 120, the pool limits and instance count must be reconciled; extra instances do not authorize unlimited connections. If Scale Up raises one instance’s capacity to 150, it still cannot serve load of 180 alone and does not provide redundancy after losing that only instance. Cost, restart time, and shared capacity affect the choice.

For a queue, compare arrival and completion rates: 120 jobs/s arriving and 100 jobs/s completing grows the backlog by about 20 jobs/s, before retries. A queue buys time; it does not create permanent processing capacity. The oldest-job age, as well as queue length, shows whether the user’s deadline is at risk.

## Worked exercise

For a per-instance capacity of 80 requests/s, load of 130 requests/s, and shared dependency limit of 150 requests/s:

1. Calculate instance minimum for normal load and for one-instance failure.
2. With four instances, calculate the theoretical chain limit and explain why 320 requests/s is not a valid promise.
3. A new instance takes 90 seconds to become ready. Suggest one preventive action and one overload control for a sudden spike.

**Solution:** Normal minimum is ceil(130/80)=2. For one-instance failure, (N−1)×80 must be at least 130, so N must be 3; two remaining instances provide 160. Four instances offer 320 at the application layer, but total sustainable capacity is at most min(320,150)=150 due to the shared dependency. Reactive scaling cannot remove the 90-second startup delay; pre-provisioned headroom and bounded admission or a bounded queue for suitable work are defensible. These are calculations from the stated assumptions, not a load test.

## First-party evidence: Threads and capacity lead time

In a first-party report dated December 19, 2023, Meta described ZippyDB adding machines to its pool and rebalancing data after hardware allocation; capacity approval/provisioning could take days. For short-lived spikes, Meta used available pool headroom and multi-tenant isolation. Resharding was prepared to increase state capacity. Async work was controlled against downstream capacity.

**Learning and limit:** More machines, correct movement of state, and controlled consumption are separate problems. The report describes a mature platform with prebuilt tools; it does not establish the same provisioning time or capacity for another system. The reservation example is not taken from Meta.

## Common failures and signals

| Failure | Operational signal | What to inspect |
| --- | --- | --- |
| Scaling API to fix a slow database | instance count rises while pool wait and p95 worsen | queries, locks, and connection budget |
| Autoscaling only on average CPU | queue ages while CPU is low | I/O wait, oldest-job age, successful work |
| Scale-in without draining | partial jobs, dropped connections, repeated jobs | stop admission, drain, and recover ownership |
| Capacity repeatedly rises and falls | instance churn and cold caches | stabilization time, min/max, startup delay |
| Replicas all run on one host | host failure removes all instances | placement and shared failure domain |
| Retry on every timeout | actual load exceeds user demand | retry budget, backoff, concurrency ceiling |

AWS’s load-shedding experience explains how overload and retries can form a feedback loop. A useful success measure is work completed within a useful client deadline, not just request count.

- [ ] Record load mix, p95/p99, errors, successful work, and baseline cost.
- [ ] Identify the limiting resource with CPU, I/O, queue, or trace evidence.
- [ ] Define ownership for sessions, local files, duplicate jobs, and durable state.
- [ ] Reconcile aggregate connections/concurrency with dependencies.
- [ ] Know failure capacity, readiness delay, and measured headroom.
- [ ] Define min/max capacity, scaling signals, safe reduction, and rollback.
- [ ] Control noisy tenants, retries, and worker pressure.

## Self-check

1. What kind of scaling is adding RAM to one server versus adding three API instances?
2. Why does four times the instance count not guarantee four times the throughput?
3. Does stateless mean the system stores no durable data?
4. At 250 requests/s and stable capacity 100 per instance, how many are needed to tolerate one instance failure?
5. The queue grows and workers mostly wait for the database. Is adding unlimited workers appropriate?
6. What does sticky session solve, and what risk remains?
7. Why is a scaling policy incomplete without scale-in and a maximum?

### Answers with reasoning

1. Scale Up and Scale Out. Down and In are their respective reverse operations.
2. Shared dependencies, serial work, and coordination impose limits.
3. No. Request processing must not rely on the prior instance’s local memory; durable state can live elsewhere.
4. Four. After losing one, three provide 300, above 250, subject to headroom.
5. No. They increase pressure on the connection/database bottleneck; check capacity and queue age first.
6. It prefers the same route for a user; it does not persist or replicate state, so instance failure may lose local session data.
7. It leaves costs and lifecycle uncontrolled. Unsafe reduction can interrupt work; unbounded growth can exhaust budget and dependency capacity.

## Optional further reading

This lesson contains the capacity method and examples. Links are optional and some describe product-specific behavior.

- Persian, supplemental: [Software scalability: horizontal and vertical scaling](https://www.hostragons.com/fa/وبلاگ/مقیاس-پذیری-نرم-افزار-مقیاس-بندی-افقی-و/) introduces terminology. Treat claims of nearly unlimited horizontal growth as non-guarantees; use the dependency limits taught here.
- English, official: [Microsoft scaling and partitioning](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/scale-partition) compares approaches and dependency constraints.
- English, official: [AWS dynamic compute scaling](https://docs.aws.amazon.com/wellarchitected/latest/performance-efficiency-pillar/perf_compute_hardware_scale_compute_resources_dynamically.html) discusses scaling signals and policy direction.
- English, official: [Azure autoscale overview](https://learn.microsoft.com/en-us/azure/azure-monitor/autoscale/autoscale-overview) describes reactive and scheduled autoscale in Azure Monitor.
- English, first-party case: [Meta: Threads infrastructure](https://engineering.fb.com/2023/12/19/core-infra/how-meta-built-the-infrastructure-for-threads/) covers capacity, state, and downstream limits at Meta.
- English, operational case: [AWS: load shedding to avoid overload](https://aws.amazon.com/builders-library/using-load-shedding-to-avoid-overload/) describes queues, retries, and protecting successful work.

**Navigation:** [Scaling chapter, English](../README.en.md) · [Course index, English](../../README.en.md) · [Next: Load balancing](../02-load-balancing/README.en.md) · [Replication](../../04-databases/10-replication/README.en.md) · [Sharding](../../04-databases/11-sharding/README.en.md) · [Service decomposition](../../06-code-optimization/06-service-decomposition/README.en.md)

</div>
