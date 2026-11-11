# Failover: Active-Active and Active-Passive

[فارسی](../../../../fa/system-design/02-fault-tolerance-and-replication/08-failover/README.md)

## Learning goals

- Distinguish failure detection from proof that a component has failed.
- Relate RTO and RPO to an operational recovery sequence.
- Compare active-passive and active-active designs.
- Explain why fencing, failback, and recovery exercises matter.

## Central idea

Failover moves work to healthy capacity after a failure. The design must cover detection, write ownership, recovery speed, data eligibility, routing, and prevention of split brain.

## Concept map

Signal of failure → decision and fencing → candidate selection → promotion → route change → data validation → failback and learning.

## Detailed lesson

### Failure detection is not the same as failure

If a health check does not receive a response, we know only that the response did not arrive before the deadline. The application might have crashed, the network may be delayed, or the health checker itself may be unhealthy.

A very short timeout can trigger a false failover. A long timeout can detect a real outage too late. Use multiple probes, clear thresholds, dependency-aware checks, and hysteresis to prevent rapid switching. A health detector should provide evidence to a control plane; it should not let each node independently decide that it is now the only leader.

### Turn RTO and RPO into a recovery plan

RTO is the target maximum time to restore service. RPO is the maximum targeted data-loss window. If the targets are an RTO of ten minutes and RPO of one minute, the plan must show how detection, fencing, promotion, routing, and data validation fit inside ten minutes. The replica must also be no more than one minute behind for the affected writes.

Measure those targets in recovery exercises. “We have two regions” proves neither recovery time nor data loss.

### Active-passive

One primary handles normal traffic and a standby takes over when the primary is unavailable. A hot standby usually receives changes continuously and can be promoted more quickly; a cold standby uses fewer resources but needs longer to start.

The procedure must define which node is allowed to write, what happens to writes that have not reached the standby, and how clients discover the new endpoint. Fence the old writer before enabling the new one. Otherwise, the old primary might still accept requests from clients that have not learned about the failover.

### Active-active

Several regions accept traffic at the same time. This can reduce geographic latency and keep more capacity available during some failures. It also makes ownership and conflict resolution more complex: two regions may update the same entity, and a client can be routed to different versions across requests.

Approaches include assigning each record a single writer or owner, using a merge strategy suitable for the data, coordinating with a quorum, or using distributed transactions. These choices have different latency, availability, and operational costs. For many businesses, explicit ownership is easier to reason about than unrestricted multi-writer access.

### Failover is more than changing a route

A typical process includes:

1. Detect and classify the failure.
2. Fence the previous writer to prevent concurrent leadership.
3. Select a replica that satisfies the recovery objective.
4. Promote it and validate data consistency.
5. Change routing and allow traffic to settle.
6. Warm capacity and monitor error and latency signals.
7. Record data loss or uncertainty and communicate the incident.

DNS can direct clients to another region, but resolver and client caches can delay the change. A load balancer or control plane also has its own dependencies and failure domain.

### Failback is another failover

Returning to the original region is not a simple switch-back. Data created in the recovery region must be reconciled. Route changes should be gradual; the team should check for conflicts and verify the old region is safe to receive writes.

Practice a tabletop scenario, a bounded failure exercise, and a real restore when feasible. Restore backups and compare record counts or checksums. A drill should be conducted in a safe environment with business impact understood.

## Worked example

A reporting service may use active-passive recovery because it can tolerate a longer RTO. A payment service operating in several regions needs clear key ownership and protection from duplicate execution before it accepts writes in more than one place.

## Public engineering case study

[Uber: Modernizing artifact storage](https://www.uber.com/us/en/blog/modernizing-artifact-storage/) discusses storage and cross-data-center recovery concerns. Use its design decisions as an example to question your own recovery objective, not as a template.

## Design choices

| Choice | A good fit when | Risk to watch |
| --- | --- | --- |
| Active-passive | One writer is simpler and recovery can tolerate a promotion step | Promotion time and tail-write loss must meet the objective |
| Active-active | Low regional latency or continuous service across regions is required | Conflicts, duplicated operations, and route changes are harder |
| Hot standby | Fast recovery is valuable and the data can be kept sufficiently current | Cost and replication lag remain |
| Cold standby | Cost matters more than immediate recovery | Startup and provisioning time may miss the RTO |

## Common pitfalls

- Promoting a standby based on a single missed health check.
- Failing over without fencing the old writer.
- Assuming DNS changes are immediate.
- Planning recovery but not practicing it.
- Switching back before data has converged.
- Treating RTO/RPO as marketing values instead of measured targets.

## Short quiz

1. What is the difference between RTO and RPO?
2. What makes active-active harder than active-passive?
3. Why must the previous writer be fenced?
4. Why should failback be tested as a separate operation?

### Answer key

1. RTO is the targeted maximum service-restoration time; RPO is the targeted maximum data-loss window.
2. Multiple regions can accept changes to the same data and can disagree during a partition.
3. A detached old primary may still serve clients; fencing prevents both old and new leaders from writing.
4. Data may have changed in the recovery region, so returning traffic requires reconciliation, validation, and staged routing.

## Exercise

Design failover for order reporting and for payment processing. Give each a different RTO/RPO, identify the writer, detection signals, fencing mechanism, routing steps, verification, and failback plan. Include one test that measures whether the objective is achievable.

## Summary

Failover is a complete recovery workflow, not just a routing change. Decide how to detect failure, prevent two writers, select valid data, restore traffic, and return safely; then measure the recovery with drills.

## Further reading

- [AWS multi-Region fundamentals](https://docs.aws.amazon.com/prescriptive-guidance/latest/aws-multi-region-fundamentals/) — when multi-region recovery is useful and what it changes.
- [AWS Well-Architected: Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html) — recovery, testing, and fault isolation.
- [Azure: Health Endpoint Monitoring pattern](https://learn.microsoft.com/en-us/azure/architecture/patterns/health-endpoint-monitoring) — health checks and dependency visibility.
- [PostgreSQL: Warm standby and streaming replication](https://www.postgresql.org/docs/current/warm-standby.html) — primary/standby replication and recovery concepts.
- [Uber Engineering: Modernizing artifact storage](https://www.uber.com/us/en/blog/modernizing-artifact-storage/) — public storage and recovery case study.
