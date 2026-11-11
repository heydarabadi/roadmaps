# LeSS and SAFe for Large-Scale Agility

## Learning goals

- Explain why scaling agile across many teams is an organizational design problem.
- Compare LeSS and SAFe at a high level and identify their coordination trade-offs.
- Avoid adding ceremonies and hierarchy without improving value flow.

## Scaling is not multiplying meetings

When multiple teams build one product, shared architecture, dependencies, integration, product ownership, and release coordination become central. Adding a framework does not remove those problems. First reduce dependencies and organize around customer value, then add only the coordination mechanisms that solve a real constraint.

LeSS (Large-Scale Scrum) extends Scrum principles to multiple teams working on one product, emphasizing one Product Backlog, one Product Owner, feature teams, and learning across the whole product. It aims to keep the structure relatively simple and uses organizational redesign rather than creating many local backlogs.

SAFe (Scaled Agile Framework) provides roles, events, planning, portfolio, and value-stream constructs for coordinating larger enterprises. It can make cross-team dependencies and investment planning explicit, but may introduce substantial role and ceremony overhead. Tailoring should preserve feedback, team autonomy, and customer outcomes rather than turn the framework into a compliance checklist.

## Design the coordination boundary

Align teams to long-lived value streams where possible. Define shared interfaces and architecture guardrails, maintain integration frequently, and surface dependencies early. Establish a common definition of done and operational responsibility. Use a scaling framework only if it improves decision speed, quality, and delivery predictability compared with lighter coordination.

## Worked example: checkout across teams

If web, payments, and fulfillment teams must coordinate every story, investigate why. They may share one release train because boundaries are entangled. A first improvement may be an explicit payment API and contract tests; the next may be a team boundary around an end-to-end customer outcome. A planning event can reveal dependencies but cannot replace the architectural work to remove them.

## Self-check quiz

1. What is a primary scaling challenge? Coordinating dependencies, architecture, integration, and product ownership across teams.
2. What does LeSS emphasize? Scrum principles, one product focus, and organizational simplification for multiple teams.
3. What can SAFe provide? A broader set of coordination and planning constructs across teams and portfolios.
4. Does adopting a framework automatically improve delivery? No; outcomes depend on team boundaries, practices, feedback, and local constraints.
5. What should scaling metrics focus on? Value flow, quality, customer outcomes, and systemic bottlenecks.

## Exercise

Five teams share one release every six weeks. Identify evidence to gather before choosing LeSS, SAFe, or a lighter coordination approach.

### Sample answer

Map dependency frequency, integration failures, release delay, decision queues, shared components, product ownership, and customer outcomes. Run a small experiment such as trunk-based integration, explicit service contracts, or one value-stream team. Select a framework only if it addresses remaining governance or coordination needs without adding more delay than it removes.

## Further reading

- English: [LeSS framework](https://less.works/), [LeSS principles](https://less.works/less/framework), [Scaled Agile Framework](https://framework.scaledagile.com/), [SAFe 6.0 FAQs](https://support.scaledagile.com/en/articles/9791402-general-safe-6-0-faqs), [DORA: Teams](https://dora.dev/capabilities/), [Martin Fowler: Feature Teams](https://martinfowler.com/bliki/FeatureTeam.html)
- Persian: [Agile Manifesto Persian translation](https://agilemanifesto.org/iso/fa/manifesto.html), [DNTips agile articles](https://www.dntips.ir/)
