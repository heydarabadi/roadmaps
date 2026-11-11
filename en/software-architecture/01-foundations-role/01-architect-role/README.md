# The Software Architect’s Role and Responsibilities

## Learning goals

- Explain how architecture differs from local implementation detail.
- Distinguish architecture work from product management, analysis, delivery management, and development.
- Connect technical choices to user needs, organizational constraints, and evidence.

## Core idea

A capable architect does not make every choice alone. The architect exposes decisions with broad consequences, makes feasible options and their costs clear, collaborates with the people affected, and helps teams understand how to deliver the chosen direction. Architecture is continuous work: product evidence, operational experience, and constraints change over time.

Software architecture is the important structure of a system, the relationships among its parts, and the decisions that shape development and evolution. Choosing a sorting algorithm is usually local. Defining who owns order data, how two teams communicate, how a regional failure is recovered from, or how a legacy platform is upgraded may affect the whole system.

The Software Architect roadmap includes technology and architecture choices, requirements discovery, documentation, standards, collaboration, consulting, and developer mentoring. Organizations draw these boundaries differently. In a small company, one architect may write code and shape deployment; in a large organization, an architect may coordinate across products and shared policies.

The work starts with questions: What outcome does the business need? Who is affected? Which quality attributes matter most? What legal, schedule, skill, or cost constraints apply? What is the simplest workable option? What evidence would confirm or reject it? Architecture balances necessary consistency with the local autonomy teams need.

## How to recognize an architectural decision

A decision’s title does not determine its architectural importance. Renaming a local variable has a small scope; deciding who owns payments may change transactions, security, user experience, financial reporting, deployments, and multiple team contracts. Ask:

1. **What is the scope of impact?** One function, or several modules, teams, and systems?
2. **How costly is reversal?** If wrong, how would data, external contracts, or customers move?
3. **Which quality attributes move?** Security, availability, latency, changeability, cost, or operability?
4. **Which assumptions remain untested?** Load, provider limits, or the team’s ability to operate the choice?
5. **What evidence will show the choice works?** An SLO, a business measure, a limited experiment, or operational feedback?

Do not impose a heavy process on low-impact, reversible choices. Review and record decisions early when reversal is expensive or cross-team risk is high. This avoids both extremes: spending too long on local implementation choices and postponing a decision that will become costly to change.

## A practical decision process

**Step 1: State the product problem.** “We need Kafka” is a proposed solution, not a problem. The real issue might be that email must not delay checkout, or that notifications must survive a short service outage.

**Step 2: Identify the boundary and stakeholders.** Who experiences the behavior? How will support see the result? Which system owns the data? What must an on-call operator do at night?

**Step 3: Make the need measurable.** “99.9% of add-to-cart requests respond within 300 ms” is more reviewable than “the cart should be fast.” Product evidence and realistic capacity should determine the number.

**Step 4: Compare options at the same level.** Notification options may include sending inline, using a worker in the same application, using a durable queue with a separate worker, or using a managed service. Compare latency, durability, operating effort, cost, and team skills. Comparing a cloud product with an abstract principle is not a fair comparison.

**Step 5: Test the riskiest assumption cheaply.** A load concern calls for a prototype that tests the expected volume and retry behavior. A provider-compatibility concern may need only a small API experiment. A prototype reduces uncertainty; it is not the final product design.

**Step 6: Record the choice and its review trigger.** Write the reason, alternatives, benefits, drawbacks, owner, and time or condition for review. A sound decision can change later; its record explains which changed conditions justified that change.

## Common architect roles

| Role scope | Typical concern | Example output |
| --- | --- | --- |
| Solution architect | Connecting one initiative to several systems | Integration view and transition plan |
| Software or system architect | Boundaries, data, contracts, and quality of a product | C4 views, ADRs, and test strategy |
| Domain architect | Business vocabulary and capability boundaries | Context map and domain model |
| Enterprise architect | Alignment across products and investments | Current-state, target-state, and transition roadmap |
| Platform architect | Shared capabilities for product teams | Platform API, guardrails, and self-service path |

These are not fixed job boxes. One person may cover several areas. Clarify decision authority, scope, and accountability so two groups do not make contradictory decisions.

## Worked example: payments in an online store

Suppose a store uses an external payment provider. The architect does not start by declaring that everything must be a microservice. The architect reviews successful, declined, and uncertain payment flows with product and engineering; identifies the authoritative transaction record; plans for repeated callbacks, timeouts, and refunds; defines the contract and measures; and asks the team to implement one small vertical slice in a test environment. Ambiguous, risky choices become experiments.

1. **Business outcome:** customers must not be charged twice, and an order must not be shown as paid incorrectly.
2. **Important events:** the customer starts payment; the provider succeeds, declines, or times out; a callback may be late or repeated; the provider may be unavailable.
3. **Source of truth:** payment status is not identical to order status. Store a uniquely identified PaymentAttempt and its provider reference so every attempt is traceable.
4. **Timeout behavior:** a timeout does not prove failure. Put the order into an “unknown / awaiting verification” state; show a clear message; use a status query or reconciliation process to find the outcome.
5. **Repeated callbacks:** enforce uniqueness for the external transaction and process callbacks idempotently. A duplicate has no second effect; retain an audit record.
6. **Execution boundary:** payment can begin as a module in the application while keeping its provider adapter and data boundary. Consider a separate service only when independent scale, ownership, or release needs are evidenced.
7. **Success measures:** track orders in unknown state, duplicate payments, initiation latency, and time to resolve reconciliation gaps.
8. **Review trigger:** a second provider, growing reconciliation volume, or changed regulatory requirements may justify revisiting the attempt model and reconciliation process.

This is a teaching example. A real design must account for the provider’s contract, financial rules, and applicable regulation.

## Deliverables and collaboration

Useful architect outputs include a context map, business flows and risks; options and ADRs; a small executable example rather than a vague mandate; production measures and review plans; and coaching that transfers decision-making skill to the team.

An architect is not usually the owner of product priority unless the organization combines roles. The architect explains technical trade-offs; product owns value and priority; security evaluates threats and controls; operations describes service needs; developers surface implementation constraints.

## Common pitfalls

- Designing an imagined future before there is evidence or a real user.
- Turning the architect into a committee that approves every commit.
- Measuring success by service count, diagrams, or new technologies.
- Ignoring team skills, on-call responsibility, and ownership cost.
- Recording a decision without its rationale, rejected options, or review condition.

## Self-check quiz

1. **What decisions commonly belong to architecture?** Choices with broad impact or high reversal cost, such as system boundaries, data ownership, communication contracts, security, and deployment. A class-level detail is not automatically architecture.
2. **Why should an architect not dictate every decision alone?** Product, implementation, security, and operations knowledge is distributed; collaboration improves the decision and the team’s ability to execute it.
3. **How can a team reduce risk from an unfamiliar technology?** Build a limited, measurable experiment; state the hypothesis and success criteria; then accept, revise, or reject the choice based on evidence.
4. **When does standardization hurt productivity?** When it ignores real differences, moves decisions away from the teams doing the work, or imposes a universal cost for a rare problem.
5. **What should an ADR contain?** Context, realistic alternatives, the chosen option, consequences, and a condition for review.
6. **Does a timeout mean the payment failed?** No. The provider may have committed the payment while the response was lost; query or reconcile the outcome and use idempotency.

## Exercise

For an appointment-booking system, identify three consequential architecture decisions. For each, record stakeholders, options, one benefit, one drawback, and a review trigger.

### Sample answer

For booking, consider **preventing double booking** with a database constraint or lock (possible write contention; revisit when conflict rates change), **integrating an external calendar** through an adapter and asynchronous sync (temporary inconsistency; revisit if immediate confirmation becomes mandatory), and **tenant isolation** through mandatory server-side scoping (more complex authorization; revisit if stronger isolation is required). Stakeholders include customers, operators, support, and operations. Each choice needs measurable criteria and an explicit review trigger.

## Further reading

- Persian: [Software architecture introduction](https://www.alirostami.com/software-architecture/01-introduction), [Software architecture roadmap](https://codingcogs.org/road-maps/software-architecture)
- English: [Software Architect roadmap](https://roadmap.sh/software-architect), [C4 model introduction](https://c4model.com/introduction), [GOV.UK ADR Framework](https://www.gov.uk/government/publications/architectural-decision-record-framework), [Google Cloud Architecture Framework](https://docs.cloud.google.com/architecture/framework), [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar)

