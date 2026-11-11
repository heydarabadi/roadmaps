# Requirements, Stakeholders, and Quality Attributes

## Learning goals

- Distinguish functional requirements from quality attributes.
- Turn vague requests such as “fast and secure” into measurable scenarios.
- Prioritize architecture work using business impact and risk.

## Core idea

A successful architecture does more than implement the right capability. It delivers that capability at an acceptable quality in a real operating context for specific stakeholders. Availability, performance, security, modifiability, testability, and recovery can conflict. Ask what must happen, for whom, under which load or event, and how well.

A quality-attribute scenario describes six parts:

1. **Source of stimulus:** a user, external system, failure, attacker, or operator.
2. **Stimulus:** a specific request or event.
3. **Environment:** normal operation, peak load, network outage, recovery, and so on.
4. **Affected component:** the service or infrastructure that responds.
5. **Response:** observable system behavior.
6. **Response measure:** a number, duration, error rate, or recovery level.

“The system must scale” is not testable. A clearer example: “During a campaign, as catalog read traffic rises from 500 to 5,000 requests per second, the service keeps errors below 0.5% and p95 latency below 300 ms.” Product data, capacity, and cost must determine the target; these numbers are illustrative.

## Common quality attributes

- **Performance:** response time and throughput, with percentile and message size specified.
- **Availability and resilience:** continued or recovered service under a defined failure.
- **Security and privacy:** protection against named threats and misuse, with verification.
- **Modifiability:** the time and risk required to make a defined kind of change.
- **Scalability:** ability to handle a stated increase in load or data volume.
- **Operability:** ability to deploy, observe, diagnose, and recover the service.
- **Usability and accessibility:** whether intended people can complete tasks, including with assistive technology.
- **Interoperability:** ability to exchange data and behavior through stable contracts.
- **Recoverability:** recovery time and permitted data loss after a specified incident.

Terms such as “real time,” “highly available,” and “secure” need local definitions before they can guide a design.

## Step-by-step: from a vague request to a scenario

Suppose a manager says, “Checkout must be fast and reliable.”

1. Ask which user journey and which step matter: adding an item, creating an order, or receiving a payment result.
2. Identify normal and peak traffic, dependencies, and relevant failures.
3. Ask which outcome is unacceptable: a slow response, a duplicate charge, overselling inventory, or losing an order.
4. Choose a measurable response, such as p95 latency for order acceptance, a duplicate-charge rate, or a reconciliation deadline.
5. Name the owner and the test or production measure that will verify it.
6. Record the trade-offs with other needs. A target without budget or ownership is not an executable requirement.

## Worked example: a sales campaign

**Vague need:** the site must be fast and stable during a campaign.

**Discovery questions:** How many concurrent users are expected? What is the view-to-purchase ratio? Must inventory be exact? Which data may be briefly stale? How much extra capacity cost is acceptable?

**Illustrative scenarios:** during a tenfold traffic peak, product pages respond below 500 ms at p95; reserving the final unit never permits an oversell; analytics may lag by up to two minutes.

**Architectural implication:** cache public product data; protect the inventory invariant during checkout; allow analytics to update asynchronously. The three journeys do not need one consistency or latency strategy.

## Quality trade-offs

| Improving this quality | May increase this cost | Question to ask |
| --- | --- | --- |
| Lower latency | Cache complexity and stale data | How stale may this data be? |
| Higher availability | Replication and reconciliation | Which operations are allowed during a partition? |
| Stronger security | User friction or compute cost | What does the threat model require? |
| Easier modification | Abstractions and indirection | Which changes happen often enough to justify this? |
| Stronger consistency | Latency and coordination | Which invariant must hold immediately? |

When priorities are unclear, ask stakeholders which loss is most costly: lost sales, incorrect amounts, checkout downtime, or delayed reports. That answer should guide the design.

For an invoice system, throughput may be moderate while auditability, compliance, long retention, and traceability matter most. For a public product-search page, latency and read capacity may dominate. “Best architecture” has no meaning without the context.

## Measurement and ownership

- Are the stimulus, environment, and affected component explicit?
- Is the target achievable within budget and team capability?
- Will a load test, security test, or recovery drill measure it?
- Which team owns the alert and improvement work?
- Does production telemetry capture the same quality the requirement describes?

If these questions have no answer, the requirement is not yet ready to drive an architecture choice.

## Common pitfalls

- Listing many quality attributes with no scenarios or priorities.
- Using average latency when users experience the tail of the distribution.
- Choosing 99.999% availability without considering cost or error budget.
- Treating security as login, or resilience as “add more replicas.”
- Capacity-planning for today’s load without understanding growth and seasonal peaks.

## Self-check quiz

1. **What is the difference between a functional requirement and a quality attribute?** A functional requirement describes what capability the system provides; a quality attribute describes how well it behaves in a defined context.
2. **Why is “the system must be secure” insufficient?** It does not name threats, assets, actors, trust boundaries, or expected behavior, so controls cannot be evaluated.
3. **What may be a better measure than user request latency for a nightly report?** Batch completion time, throughput, and output correctness may matter more than single-request latency.
4. **When do extra replicas fail to guarantee availability?** When they share a failure domain or depend on a common network, identity service, or control plane.
5. **Why use p95 or p99 rather than only an average?** Tail users can have a poor experience even when the average looks acceptable.
6. **What makes an SLO actionable?** A defined SLI, time window, target, owner, alert policy, and decision process for the error budget.

## Exercise

Write two quality scenarios each for payment, catalog, and sales reporting. For each, state stimulus, environment, response, and measure. Identify a conflict and propose a design.

### Sample answer

Payment: a verified callback moves the order to paid within a defined window; a timeout leaves an explicit unknown state and triggers reconciliation. Catalog: public pages meet an agreed p95 latency and may use data a few seconds old. Reporting: the daily sales result is complete by a stated time and includes lineage. One conflict is inventory freshness versus catalog latency. Cache for browsing, then validate and reserve inventory authoritatively at checkout. Replace illustrative targets with stakeholder-approved baselines and measures.

## Further reading

- Persian: [Software architecture fundamentals](https://www.alirostami.com/software-architecture/), [Software architecture overview](https://www.amatistech.com/software-architecture/)
- English: [Google Cloud Architecture Framework](https://docs.cloud.google.com/architecture/framework), [AWS Well-Architected definitions and pillars](https://docs.aws.amazon.com/wellarchitected/latest/framework/definitions.html), [Google SRE: Service Level Objectives](https://sre.google/sre-book/service-level-objectives/), [Microsoft design principles for Azure applications](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/), [ISO/IEC 25010 overview](https://iso25000.com/index.php/en/iso-25000-standards/iso-25010)

