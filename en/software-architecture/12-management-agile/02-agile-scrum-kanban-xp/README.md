# Agile, Scrum, Kanban, and Extreme Programming

## Learning goals

- Understand Agile values and the feedback loop behind iterative delivery.
- Compare Scrum's timeboxed framework, Kanban's flow system, and XP engineering practices.
- Use outcomes and quality evidence instead of activity metrics.

## Agile values and iteration

The Agile Manifesto values collaboration, working software, customer partnership, and adaptation. These values do not remove planning, contracts, documentation, or architecture; they ask teams to use them in ways that support delivery and learning. A useful iteration delivers a thin, tested increment and gets feedback before assumptions harden.

Scrum defines a Product Owner, Scrum Master, and Developers within a Scrum Team; events and artifacts create a recurring inspect-and-adapt rhythm. The 2020 Scrum Guide is the official current guide at the time of writing. A Sprint is not a mini-waterfall: the team collaborates toward a Product Goal and creates a usable Increment that meets its Definition of Done.

Kanban visualizes workflow, limits work in progress, manages flow, and improves the system using measures such as cycle time, throughput, and work-item age. It can be introduced incrementally without replacing all roles or ceremonies. A board without explicit policies or WIP discipline is only a visualization.

Extreme Programming (XP) emphasizes technical practices such as test-driven development, continuous integration, small releases, refactoring, collective ownership, and close customer feedback. These practices reduce the cost of change and make frequent delivery safer. They do not excuse missing architecture or operational readiness.

## Metrics and pitfalls

Velocity is a local planning aid, not a productivity target for comparing teams. Story points are estimates, not business value. Track outcomes, flow, defects, customer impact, and quality. Avoid starting more work than the team can finish; context switching and long queues delay feedback.

## Worked example: checkout improvement

Use a short hypothesis such as reducing address-entry abandonment. Slice one change, define acceptance and telemetry, and release safely. Scrum may organize work in Sprints; Kanban may manage continuous flow with WIP limits; XP practices keep code releasable. Review the customer outcome and adapt the next change.

## Self-check quiz

1. What is the point of an Agile iteration? Deliver a useful increment and learn from feedback.
2. What does Kanban's WIP limit improve? Flow and focus by constraining started-but-unfinished work.
3. What is the Definition of Done for? A shared quality bar for an increment.
4. Name two XP engineering practices. Test-driven development, continuous integration, refactoring, pair programming, and small releases are examples.
5. Why should velocity not be used to rank teams? It is a local estimation convention and is easily distorted by comparison incentives.

## Exercise

Choose Scrum, Kanban, or a tailored combination for a team handling planned feature work and unpredictable production incidents. Define how urgent work enters and how quality is preserved.

### Sample answer

If planned goals and regular stakeholder review dominate, Scrum may provide a useful cadence, with an explicit incident policy and capacity reservation. If work arrives continuously, Kanban with WIP limits and service classes may fit better. In both cases, protect unplanned work visibility, test fixes, maintain a Definition of Done, and examine flow and outcomes rather than output volume.

## Further reading

- English: [Agile Manifesto](https://agilemanifesto.org/), [The Scrum Guide 2020](https://scrumguides.org/scrum-guide.html), [Open Guide to Kanban 2025.7](https://kanbanguides.org/open-guide-to-kanban/2025.7/), [Extreme Programming: a gentle introduction](http://www.extremeprogramming.org/), [Martin Fowler: Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html), [DORA capabilities](https://dora.dev/capabilities/)
- Persian: [Agile Manifesto Persian translation](https://agilemanifesto.org/iso/fa/manifesto.html), [DNTips agile articles](https://www.dntips.ir/)

Version note: the linked Scrum Guide page labels November 2020 as the official version; check its download page for later revisions before relying on exam content.
