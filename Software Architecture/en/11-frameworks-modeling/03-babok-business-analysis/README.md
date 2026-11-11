# BABOK and Business Analysis

## Learning goals

- Explain business analysis as enabling change by defining needs and recommending value.
- Use BABOK knowledge areas to organize discovery, requirements, solution evaluation, and stakeholder work.
- Connect requirements to architecture decisions and verifiable outcomes.

## Business analysis in architecture

Business analysis is the practice of enabling change in an enterprise by defining needs and recommending solutions that deliver value to stakeholders. It is not limited to writing requirement documents. Analysts elicit, verify, validate, prioritize, and manage information while working with business, users, operations, and technical teams.

The Business Analysis Body of Knowledge (BABOK) from IIBA organizes practice into knowledge areas such as business analysis planning, elicitation and collaboration, requirements life-cycle management, strategy analysis, requirements analysis and design definition, and solution evaluation. These areas are a guide for thinking, not a mandatory linear phase sequence.

Separate a **need** from a proposed **solution**. “Reduce checkout abandonment” is a need; “build a new mobile app” is one possible solution. Discover the context, measure the baseline, identify constraints and stakeholders, and compare options. Requirements should be traceable from business objective to capability, solution component, acceptance evidence, and owner.

Use models, prototypes, examples, and scenarios to reveal ambiguity. Record assumptions, constraints, dependencies, and nonfunctional requirements, especially availability, privacy, performance, auditability, and recoverability. Prioritize by value, risk, and cost of delay; a long unranked list is not a strategy.

## Worked example: faster refunds

Stakeholders include customers, support agents, finance, risk, and payment operations. Clarify which refund cases are eligible, target time, fraud constraints, source of truth, and exception path. Compare automated policy checks, agent-assisted workflow, and provider integration. Define acceptance measures such as refund completion time, error rate, and audit completeness.

## Self-check quiz

1. Is business analysis just writing requirements? No; it includes understanding needs, stakeholder collaboration, solution evaluation, and value.
2. Why distinguish need from solution? It prevents prematurely locking into one implementation before comparing alternatives.
3. What is traceability used for? Connecting objectives, requirements, design, delivery, and validation evidence.
4. Why include nonfunctional requirements? They affect solution viability, risk, cost, and user outcomes.
5. How should a framework such as BABOK be used? Tailor it as a shared practice guide to the organization's context.

## Exercise

Create an analysis brief for reducing order refund time. Include need, stakeholders, current evidence, constraints, options, measurable outcome, and architecture questions.

### Sample answer

Need: reduce median eligible refund time from current measured baseline while preserving fraud and audit controls. Include customers, support, finance, risk, and payment operations. Compare policy automation, workflow changes, and provider integration. Clarify idempotency, approval threshold, data retention, timeout/reconciliation, and exception ownership. Measure elapsed time, error/reversal rate, and audit completeness before choosing a design.

## Further reading

- English: [IIBA: BABOK Guide](https://www.iiba.org/standards-and-resources/babok/), [IIBA: What is business analysis?](https://www.iiba.org/business-analysis-blogs/what-is-business-analysis/), [IIBA: Business Analysis Competency Model](https://www.iiba.org/business-analysis-competency-model/), [GOV.UK Service Manual: user needs](https://www.gov.uk/service-manual/user-research/start-by-learning-user-needs), [NASA Systems Engineering Handbook](https://www.nasa.gov/reference/systems-engineering-handbook/)
- Persian: [IIBA Persian resources](https://www.iiba.org/), [DNTips](https://www.dntips.ir/)
