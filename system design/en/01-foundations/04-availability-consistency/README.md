# Availability and Consistency

[فارسی](../../../01-foundations/04-availability-consistency/README.md)

## Learning goals

- Define availability as a contract for a user-visible operation.
- Distinguish SLI, SLO, SLA, and error budget.
- Describe a consistency guarantee in terms of reads and writes.
- Choose appropriate degraded behavior for different kinds of data.

## Central idea

Availability asks whether a useful response arrives within the contract. Consistency asks whether that response reflects the required version and ordering of data. A stale successful response may be acceptable for a feed and dangerous for an account balance.

## Concept map

User operation → success definition → SLI and SLO → data freshness contract → dependency and replica behavior → graceful degradation.

## Detailed lesson

### Define which operation is available

Saying “the service is 99.9% available” is not enough. Define which requests count in the numerator and denominator, how timeouts are treated, which region and users are included, the measurement window, and what counts as success. A process that is alive but returns an error is not useful to a customer. A stale or partial response may count as success only if the product contract says it does.

An SLI is a measured indicator, such as the fraction of valid checkout requests that succeed. An SLO is an internal target for that indicator over a period, for example 99.9% over 30 days. An SLA is an external agreement with business or legal consequences. It is often less ambitious than the internal SLO so the team has room to act before breaching its commitment.

An error budget is the tolerated SLI miss implied by an SLO. It can inform release and risk decisions, but it does not replace incident response.

### Define consistency in terms of operations

“Every server has the same data” is not an operational guarantee. Ask what a client must observe:

- After a successful write, must the next read see that value?
- How are concurrent writes ordered?
- If a read replica is unreachable, should the request wait, fail, or return an older value?
- Does the user need to see their own change immediately?

A slightly stale post count may be acceptable. A stale account balance could trigger a duplicate payment or an overdraft. Consistency is a property of a data operation and its path; a database guarantee does not automatically carry through a cache, replica, or application read model.

### Choose degraded behavior deliberately

When a dependency is unavailable, the system can return an explicit error, serve stale or partial data, or accept work into a queue and report a pending result. Choose based on the business meaning of the data and the user's expectation.

A stale inventory value can lead a shopper to buy an unavailable item. A slightly stale social feed may be acceptable. If a fallback returns incomplete data, communicate that honestly in the interface; do not make a degraded response look authoritative.

### Translate SLOs into architecture

A strict checkout objective may require fewer synchronous dependencies, bounded timeouts, fast failures, and safe recovery. A freshness allowance of several seconds may permit an asynchronous read replica that reduces read latency or cost. In both cases, the SLO should measure the user journey, not only whether virtual machines report healthy.

## Worked example

A like counter can lag briefly because a delayed update does not change payment or access rights. A charge must use an authoritative payment workflow that prevents the same intent from being applied twice. “Availability” and “consistency” are therefore defined differently for the two operations.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Return stale data | The consumer can tolerate a documented freshness window | Users may make a business decision on old values |
| Fail clearly | Incorrect data is more harmful than temporary unavailability | Callers need a recovery and retry path |
| Accept work asynchronously | The user can receive a pending state | A queue backlog may delay or expire the work |
| Stronger read-after-write behavior | The same user must immediately see their change | Coordination or primary reads may raise latency |

## Common pitfalls

- Claiming 100% availability without defining a measurement.
- Calling an HTTP 200 response successful when the business operation failed.
- Saying data is “eventually consistent” without a useful freshness or conflict policy.
- Treating a read replica or cache as if it has the writer’s freshness.
- Counting host health instead of user-visible outcomes.

## Short quiz

1. What must be specified in an availability SLO?
2. What does a read replica do before it has received a new write?
3. Why might stale feed data be acceptable while stale inventory is not?
4. How is an SLA different from an SLO?

### Answer key

1. The SLI, eligible request population, success criteria, measurement period, and treatment of errors/timeouts.
2. It may return the earlier value, depending on the replication and read policy.
3. A small delay in a feed may have little business effect; stale inventory can cause overselling or failed checkout.
4. An SLO is an internal target. An SLA is an external commitment, often with contractual or financial consequences.

## Exercise

For a store, define separate availability and freshness contracts for catalog display, order submission, inventory, and payment status. For each, choose error, stale response, or pending state during a dependency failure. Explain what the user sees and how the system later recovers.

## Summary

Availability is about meeting a response contract; consistency is about the version and ordering users are allowed to observe. Define both for each important operation, then choose degraded behavior according to the cost of stale, missing, or delayed information.

## Further reading

- [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/) — SLI and SLO definitions, distributions, and workload classes.
- [Google SRE: Production Services Best Practices](https://sre.google/sre-book/service-best-practices/) — error budgets and balancing reliability with change.
- [Google SRE: Availability Table](https://sre.google/sre-book/availability-table/) — time-based versus aggregate availability.
- [Amazon Dynamo paper](https://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf) — availability-oriented storage design and eventual consistency.
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html) — reliability and availability design questions.
