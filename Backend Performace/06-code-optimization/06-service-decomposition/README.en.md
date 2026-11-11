# 6.6 — Service Decomposition and Its Performance Effects

**Language:** English | [فارسی](README.md)

Decomposition moves some behavior behind an independent boundary, usually a separate process or service. Motivations can include independent scaling, resource isolation, or clearer ownership. **Microservices are not the default performance solution**: a network boundary adds serialization, round trips, partial failures, and operational work.

**Learning goal:** state a measurable reason to extract a component, estimate boundary costs, recognize a distributed monolith, and plan a limited migration. Sources reviewed: **2026-11-10**.

## Prerequisites defined here

A process is a running program with its own resources and execution space. A module is a code boundary inside one process; an independent service also has a network boundary and a separate failure mode. A queue stores work for later consumption. A hop is one more crossing of a communication boundary; it usually adds network time, encoding/decoding, and another possible failure. A **distributed monolith** has separately deployed components that still depend on coordinated calls or changes; a process boundary alone does not create architectural independence.

## Mental model: logical boundary versus execution boundary

| Option | Potential benefit | Cost and limit |
| --- | --- | --- |
| Module in the same application | Clear code interface; local calls | Mostly shared scaling and failure domain |
| Separate worker | Isolate heavy or deferrable work | Queue, durable storage, and completion delay |
| Independent service | Independent scaling and rollout | Network, versioned contract, and more operations |

The official [Azure microservices guidance](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices) describes independent scaling alongside added complexity, communication, and data-consistency challenges. A good boundary follows behavior, data, and change patterns; not every function or table needs its own service. If multiple services require coordinated deployment and global transactions to work, the promised independence has not been achieved.

1. Use a profile to establish which component creates queues or resource contention; adding services does not fix one slow query.
2. First clarify module boundaries and data contracts. Assess whether concurrency limits or a worker in the same stack would suffice.
3. Compare scaling/isolation benefits with hops, serialization, retries, connections, observability, and team cost.
4. Define data ownership, consistency, idempotency, and contract versioning. Direct access by every service to each other's tables weakens independence.
5. Extract a limited path in stages and compare load and correctness. Shadow reads may help; shadow writes without side-effect controls can duplicate actions.

## Worked example: a heavy report beside checkout

**Instructional model:** a single application handles 100 checkout requests/s at 5 ms CPU each and 10 reports/s at 200 ms CPU each. CPU demand is 0.5 and 2 CPU-seconds/s, respectively, or 2.5 in total. Allocated capacity is 2 cores. In practice, inspect queues, time slices, and overhead too. Adding a network hop does not create capacity.

The first options are to limit report work, optimize its algorithm, or run it in a worker with a separate resource share. The second option is extracting reporting for independent scaling. It still needs about 2 CPU-seconds/s of computation, but load can be isolated from checkout. If the report need not be returned synchronously, a <code>202 Accepted</code> response and job-status contract can move waiting off the interactive response; this does not mean the report finished at acceptance time.

For a separate synchronous path, suppose a local call takes 5 ms. Extracting it with a hypothetical 6 ms of network and encoding/decoding overhead makes that part 11 ms if computation is unchanged. This is not a measurement; it illustrates that deployment independence may increase latency. Measure the actual environment.

## Exercise with worked solution

For a hypothetical sales service, draw three capabilities: checkout, monthly report generation, and customer-name lookup. Write down each rate, CPU use, data dependency, and whether the result is needed synchronously. Compare a module, worker, and separate service.

**Example solution:** using the example values, checkout demand is <span dir="ltr">100 × 5 ms = 0.5 CPU-second/s</span>; reporting demand is <span dir="ltr">10 × 200 ms = 2 CPU-second/s</span>. Reporting accounts for <span dir="ltr">2 / (0.5 + 2) = 80%</span> of their combined CPU demand. First consider a resource limit or separate worker. A service is justified only if independent scaling or rollout is worth the network and operational cost. If 100 names are fetched separately, that can create 100 hops; compare a batch or local/combined fetch. These figures are hypothetical; the final decision depends on the real workload.

## Firsthand operational evidence

On **March 6, 2023**, [Discord](https://discord.com/blog/how-discord-stores-trillions-of-messages) placed data services between the API monolith and database to coalesce simultaneous requests for the same data; routing by key also supported that goal. The specific goal was protecting the database from hot traffic. This is evidence for a targeted extraction, not proof that every decomposition helps; database migration and other changes were part of the story.

## Failures and signals

| Failure | Operational signal | Action |
| --- | --- | --- |
| Boundary is too fine-grained | Trace full of short serial hops | Use a coarser interface and appropriate batching |
| Shared database remains the bottleneck | More services, same saturated database | Fix data access and queries |
| Retries in every layer | Request amplification during an outage | Assign retry ownership and a shared budget |
| Deployments remain coupled | Every change needs a coordinated rollout | Use compatible contracts and clear ownership |
| No tracing or on-call owner | Delay is hard to explain | Establish observability and responsibility before extraction |
| Duplicate side effects during migration | Repeated payment or notification | Control write paths and durable deduplication |

Decomposition also increases base cost for multiple processes, deployments, and connections. For a small team or low load, clear modules in one application may reduce cost and change time. For heterogeneous workloads with evidenced resource contention, independent scaling may help; test with load and operations.

### Operational checklist

- [ ] The limit the new boundary will address is recorded with metrics/profiles.
- [ ] Modules, concurrency limits, and workers were compared.
- [ ] Hops, contracts, data ownership, and compatibility are clear.
- [ ] Deadlines, cancellation, idempotency, and partial failures are designed.
- [ ] Connection, baseline memory, deployment, tracing, and on-call costs are estimated.
- [ ] A limited rollout, correctness review, and rollback without duplicate side effects are possible.

## Quiz

1. Does separating a service automatically reduce the same computation?
2. What is the difference between a module boundary and a process boundary?
3. Why can fetching each separate field from another service be slow?
4. If the database is the bottleneck and every service sends the same query, what is likely?
5. What does a <code>202</code> response for a report fail to guarantee?
6. What makes Discord's extraction a comprehensible decision?

### Explained answers

1. No. The same work may run with more overhead. The benefit might be resource isolation, not less computation.
2. A module is a logical boundary in one execution; a separate process adds communication, independent failure, and operational cost.
3. Round trips and serialization grow; small delays accumulate along the chain.
4. The database remains saturated, and more concurrency may worsen the condition. Change the load or query plan.
5. It does not guarantee completion at response time; acceptance needs durable job storage and a status contract.
6. It addressed an evidenced hot-data traffic constraint with specific coalescing/routing mechanics. The name “microservices” alone is not a reason.

## Summary

Extract a service only when it addresses a specific constraint, such as resource contention or a need for independent scale. Compare a module and worker using the same measure. A separate boundary costs hops, data-contract work, deadlines, idempotency, and operations. Do not confuse accepting background work with completing it.

## Optional further reading and technical sources

Opening these links is not required to understand the lesson or solve the exercise; they provide additional reading and technical provenance.

- **Persian, complementary:** [Monolith or microservices?](https://netparadis.com/monolith-vs-microservices-clean-architecture/). Compares module and service boundaries with a Node example; treat it as supplemental.
- **English, official Azure guidance:** [Microservices architecture](https://learn.microsoft.com/en-us/azure/architecture/guide/architecture-styles/microservices). Use cases, costs, and boundary choices.
- **English, official AWS guidance:** [Microservices on AWS](https://docs.aws.amazon.com/whitepapers/latest/microservices-on-aws/microservices-on-aws.html). Discusses data stores, asynchronous communication, and service discovery in AWS contexts; decide based on the system's own requirements.
- **English, architecture analysis:** [Martin Fowler on microservices](https://martinfowler.com/articles/microservices.html). Decomposition motivations and team trade-offs; an analytical article, not a standard or measurement for this example.
- **English, architecture analysis:** [Microservice trade-offs](https://martinfowler.com/articles/microservice-trade-offs.html). Latency, communication, consistency, and operational costs; validate general arguments against real workload.
- **English, firsthand engineering report:** [Discord message storage](https://discord.com/blog/how-discord-stores-trillions-of-messages). A data-layer extraction aimed at reducing database pressure, alongside other changes.

**Navigation:** [Chapter 6](../README.en.md) · [Course index](../../README.en.md) · [Previous: Language and Runtime](../05-language-and-runtime-choices/README.en.md) · [Next: Timeouts and Retries](../07-timeouts-and-retries/README.en.md)

**Related lessons:** [Background jobs](../../03-asynchronism/01-background-jobs/README.en.md) · [Scaling](../../05-load-balancing-and-scaling/README.en.md) · [Batching](../08-batching-and-round-trips/README.en.md)
