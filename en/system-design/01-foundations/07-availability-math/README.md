# Availability and Downtime Math

[فارسی](../../../../fa/system-design/01-foundations/07-availability-math/README.md)

## Learning goals

- Convert an availability objective into an approximate downtime budget.
- Calculate availability for independent serial and parallel components.
- Identify common-cause failures that invalidate independence assumptions.
- Distinguish time-based availability from request-based availability.

## Central idea

An availability percentage has meaning only when its measurement interval and SLI are clear. Redundancy can improve reliability when failure modes are genuinely independent and the system can detect and use the surviving path.

## Concept map

Availability target → SLI and interval → tolerated errors/downtime → component path → redundancy assumptions → error-budget decisions.

## Detailed lesson

### Turn “nines” into minutes

Time-based availability is available time divided by the total evaluation time. A 30-day month contains 30 × 24 × 60 = 43,200 minutes.

- 99% allows 1% × 43,200 = 432 minutes, or 7 hours 12 minutes.
- 99.9% allows 0.1% × 43,200 = 43.2 minutes.
- 99.99% allows 0.01% × 43,200 = 4.32 minutes.
- 99.999% allows about 25.9 seconds.

| Monthly target | Approximate downtime in 30 days |
| --- | ---: |
| 99% | 7 hours 12 minutes |
| 99.9% | 43 minutes 12 seconds |
| 99.99% | 4 minutes 19 seconds |
| 99.999% | 26 seconds |

Each extra nine usually demands more engineering, operational response, and recovery cost. Choose a target because it protects a meaningful business outcome, not because more nines sound impressive.

If the SLO is based on requests, this conversion is not direct. A 0.1% request failure rate could be one short intense burst, a partial regional issue, or failures concentrated on one customer cohort.

### Components in series

If every request requires both an API and a database, and their failures are independent, path availability is:

~~~text
A_path = A_API × A_database
~~~

If each component is 99.9% available, the theoretical path availability is 0.999 × 0.999 = 0.998001, or about 99.8001%. A request that traverses several required dependencies has less availability margin than each dependency in isolation.

This multiplication assumes consistent definitions and independent failure events. It is not valid if the API and database share a failure mode or if the measurements do not describe the same time and request population.

### Components in parallel

If either of two independent instances can serve the request, the probability that both are unavailable is the product of their individual unavailability:

~~~text
A_parallel = 1 - (1 - A1)(1 - A2)
~~~

For two 99%-available independent instances, both are unavailable with probability 0.01 × 0.01 = 0.0001, giving a theoretical parallel availability of 99.99%.

If both instances share a zone, configuration, control plane, power supply, or defective software release, a common-cause failure can take both down. The formula then overstates the benefit. Failure-domain isolation and tested failover matter as much as replica count.

### Combine redundancy with product behavior

Parallel paths help only when each path is independent and usable. A slow failover detector, shared connection pool, stale DNS cache, or inconsistent data can make the second path ineffective.

Sometimes a degraded path, such as showing the catalog without live inventory, is better than requiring two dependencies to be available for every page view. The interface must communicate what is missing, and operations that rely on the missing data may need to be disabled.

### Time-based versus request-based SLI

A time-based SLI classifies each interval as available or unavailable. A request-based SLI measures the fraction of eligible requests that succeed. For a low-traffic service, a brief outage may dominate the monthly request count. For a high-traffic service with partial failures, request-based availability may better represent user impact.

Write the eligibility rules, success criteria, treatment of maintenance, affected regions, and timeout behavior into the SLI definition.

### Use an error budget to guide work

For a 99.9% SLO, the error budget is 0.1% of the defined measurement. If it is consumed quickly, the team may pause risky releases, fix recurring incident causes, or revisit capacity and dependencies. The error budget is not permission to cause failures; it balances change velocity with evidence of service health.

## Worked example

Checkout relies on inventory, payment, and risk evaluation. Measure the final eligible checkout outcome, not merely whether each virtual machine is running. A component can pass its health check while its dependency makes the user journey fail.

## Example formulas

~~~text
Independent required components in series:
A_series = A1 × A2

Independent alternative paths where either is sufficient:
A_parallel = 1 - (1 - A1)(1 - A2)

Both assume reliable detection, routing, and genuinely independent failure modes.
~~~

## Public engineering guidance

[AWS multi-Region fundamentals](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-multi-region-fundamentals/) discusses use cases and the design, development, and deployment implications of multi-region resilience. Multi-region adds cost and operational complexity; first determine whether multi-zone or single-region recovery meets the workload’s target.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Add a second replica | Failover is automatic or practiced and failure domains differ | Shared configuration or dependencies can still fail together |
| Add a second region | The required recovery boundary is larger than one region | Data replication, routing, operations, and cost become more complex |
| Use a request-based SLI | Partial failure and uneven traffic matter to users | Eligibility and success definitions can be manipulated or misunderstood |
| Use a time-based SLI | Whole-service outages are the primary concern | Partial degradation can be hidden as “up” time |

## Common pitfalls

- Claiming 100% availability or setting an SLO without a measurement definition.
- Applying independence formulas to components with shared failure modes.
- Measuring host uptime instead of successful user operations.
- Assuming replica count equals useful redundancy.
- Treating a request-based error ratio as uptime.
- Ignoring whether health checks and failover routing work during an incident.

## Short quiz

1. How much downtime does 99.9% allow in a 30-day month?
2. Why are required serial component availabilities multiplied?
3. What common failure could invalidate the independence assumption for two replicas?
4. Why can request-based availability describe some systems better than time-based availability?

### Answer key

1. About 43.2 minutes.
2. Every required component must succeed, and independent success probabilities multiply.
3. Shared power, region, configuration, control plane, network route, or faulty deployment.
4. It captures partial failures and uneven traffic instead of treating an entire time interval as simply up or down.

## Exercise

Draw a checkout dependency path and assign sample availability values to each component. Calculate a theoretical series estimate, then identify at least three common-cause failures that make the estimate optimistic. Define one request-based SLI and one user-visible degraded behavior.

## Summary

Availability math makes assumptions visible. Convert a target into a budget, define a user-relevant SLI, and count redundancy only when failure domains, detection, and routing support it.

## Further reading

- [Google SRE: Availability Table](https://sre.google/sre-book/availability-table/) — downtime budgets across common targets and intervals.
- [Google SRE: Embracing Risk](https://sre.google/sre-book/embracing-risk/) — availability definitions and error-budget reasoning.
- [Google SRE: Error Budget Policy](https://sre.google/workbook/error-budget-policy/) — example policy for balancing reliability and changes.
- [AWS multi-Region fundamentals](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-multi-region-fundamentals/) — when multi-region recovery is useful and its implications.
- [AWS Well-Architected: Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html) — recovery, redundancy, and resilience principles.
