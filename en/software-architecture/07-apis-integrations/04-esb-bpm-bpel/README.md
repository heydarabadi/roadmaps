# ESB, BPM, and BPEL

## Learning goals

- Explain why organizations use integration brokers and process orchestration.
- Distinguish data transport, workflow coordination, and business process modeling.
- Modernize legacy integration without creating a new central bottleneck.

## Enterprise Service Bus

An ESB commonly provides adapters, routing, protocol mediation, transformation, and policy enforcement between heterogeneous systems. This can be valuable when many legacy applications have incompatible interfaces. The risk is a central bus that accumulates business rules, becomes a release bottleneck, and makes every integration depend on one platform and team.

Keep ownership explicit: the system that owns a business fact should define its meaning and contract. Prefer transparent routing and narrowly scoped transformations. Version interfaces, publish operational measures, and avoid making the bus the hidden source of business truth.

## BPM and BPEL

Business Process Management (BPM) describes, executes, measures, and improves workflows that cross people and systems. A process engine can manage long-running state, tasks, timers, escalation, and audit trails. BPEL (Business Process Execution Language) is an XML-based language for specifying orchestration of web services; it appears especially in established enterprise stacks.

Orchestration centralizes the workflow's next-step logic in a coordinator. Choreography lets participants react to events and can reduce central coordination, but the complete process becomes harder to see. Neither is inherently superior. Choose according to process visibility, human tasks, consistency needs, ownership, and operational capability.

Long-running workflows should model timeouts, compensation, retries, and manual intervention. A compensation is a new business action that counteracts an earlier effect, not a true rollback of an already completed external action. For example, refunding a payment compensates a charge; it does not erase the charge from the provider's history.

## Worked example: supplier order

A process may validate the purchase request, check budget, request supplier confirmation, schedule delivery, and notify staff. The BPM engine records process state and audit evidence. The ERP owns purchase order and accounting facts; a supplier adapter maps external protocol details. If supplier confirmation times out, the process waits, retries under policy, or asks an operator rather than creating duplicate orders.

## Modernization decisions

Map existing integrations, owners, data contracts, error rates, and business criticality before replacing a bus. Extract one bounded workflow at a time, use adapters at legacy boundaries, and instrument end-to-end trace IDs. Avoid a “big bang” migration that moves protocols but leaves unclear ownership untouched.

## Self-check quiz

1. What problems can an ESB solve? Protocol mediation, routing, adapters, and integration across heterogeneous systems.
2. What is the danger of a central bus? It can become a bottleneck and an unowned home for business logic.
3. How does orchestration differ from choreography? Orchestration has an explicit coordinator; choreography has participants react to messages/events.
4. Why is compensation not rollback? External effects may already be visible and must be counteracted with a new action.
5. What should be mapped before an ESB migration? Owners, contracts, dependencies, error behavior, traffic, and criticality.

## Exercise

Model a supplier purchase workflow with one external timeout and one failed payment. State process state, retry policy, compensation, and the system of record for each fact.

### Sample answer

The process coordinator owns workflow state and timers; ERP owns the purchase order and ledger. Supplier timeout receives a bounded retry using a stable request ID, then an operator task. A failed payment does not mark the purchase paid; a later payment success triggers the next step. If the supplier order already exists but budget approval is revoked, the workflow requests cancellation and records its outcome rather than pretending to roll back the supplier's system.

## Further reading

- English: [OMG BPMN specification](https://www.omg.org/spec/BPMN/2.0/), [OASIS WS-BPEL specification](https://docs.oasis-open.org/wsbpel/2.0/OS/wsbpel-v2.0-OS.html), [Microsoft integration architecture](https://learn.microsoft.com/en-us/azure/architecture/integration/), [AWS: Saga pattern](https://docs.aws.amazon.com/prescriptive-guidance/latest/cloud-design-patterns/saga.html), [Martin Fowler: Patterns of Distributed Systems](https://martinfowler.com/articles/patterns-of-distributed-systems/), [Camunda process orchestration docs](https://docs.camunda.io/)
- Persian: [DNTips technical articles](https://www.dntips.ir/), [Persian Event-Driven Architecture notes](https://github.com/gloonch/eventdrivenfarsi)
