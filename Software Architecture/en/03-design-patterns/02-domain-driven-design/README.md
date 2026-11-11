# Domain-Driven Design (DDD)

## Learning goals

Understand shared language, subdomains, bounded contexts, and tactical patterns. DDD is primarily a way to understand and model complexity, not a requirement to create a fixed set of classes.

## Core idea

Domain-Driven Design focuses on complex domains and connects the software model to the language of business experts. Domain experts and engineers build a shared vocabulary through conversation, examples, and model reviews. A lightweight approach may be better when the problem is simple.

## Strategic design

- **Subdomain:** an area of business with its own problem and value; it may be core, supporting, or generic.
- **Bounded context:** a boundary in which one model and language have precise meaning. “Customer” may be modeled differently in sales, support, and billing.
- **Context map:** the relationships and dependencies between contexts, such as Customer/Supplier, Conformist, or Anti-Corruption Layer.
- **Event storming:** a collaborative workshop to discover domain events, commands, actors, policies, and open questions.

## Tactical patterns

An **Entity** has persistent identity. A **Value Object** is defined by its values and is often immutable. An **Aggregate** defines the boundary of a business invariant and transaction; mutations go through its root. A **Domain Service** holds behavior that does not naturally belong to one entity. A **Repository** hides storing and retrieving aggregates behind a contract; it should not become a facade for every database table.

## From domain discovery to an executable model

### Step 1: discover language and flow

Review a real business process with domain experts. Ask who initiates it, what decisions are made, what can be rejected, and which event follows success. Define ambiguous words such as “active,” “complete,” or “customer” within each context.

### Step 2: distinguish a subdomain from a bounded context

A subdomain is part of the business; a bounded context is a software-model and language boundary. The payment subdomain may contain contexts for authorization, settlement, and refund. Use rule differences, change ownership, and communication needs to find context boundaries, not the number of entities.

### Step 3: identify invariants

An invariant must hold at commit. For example, one PaymentAttempt with a given provider reference may transition to captured only once. An aggregate should guard such operations so that a caller cannot break the rule by changing fields directly. An aggregate containing thousands of records and owned by multiple teams may be too large.

### Step 4: choose context relationships

When an external model cannot be controlled, an Anti-Corruption Layer translates it into the internal language. If another team provides a stable API, make the consumer contract and version explicit. For event communication, define event meaning and ownership; publishing a database table as an event does not preserve a model boundary.

### Step 5: review the model in code and conversation

Class names alone do not create DDD. Walk through a real use case with domain experts and ask which decision the model enforces. If a rule appears only in documentation and runtime code can violate it, the model is not sufficiently protected.

## Worked example: “order” in three contexts

In sales, an order is a purchase request and price agreement. In warehousing, it is a set of items to pick. In finance, it may be a liability or accounting record. A global CustomerOrder table with dozens of fields may merge all these meanings. Instead, assign data ownership and define the contracts between contexts; transfer only the required data.

| Decision | Fits when | Risk when |
| --- | --- | --- |
| Small aggregate | Invariant is local and concurrency matters | A real consistency rule is left outside the boundary |
| Anti-Corruption Layer | Legacy/vendor model differs from the new domain | It needlessly complicates every data transfer |
| Separate service per context | Ownership and change lifecycle are independent | Services are split only by database table |

## Common pitfalls

- Equating a domain model with a class model.
- Treating a bounded context as automatically a microservice; it can begin as a module.
- Making aggregates so large that they create locks and contention.
- Naming a model without reviewing it with domain experts.

## Self-check quiz

1. **What boundary does a bounded context define?** A scope where a model and its vocabulary have consistent meaning; integration to another model should use an explicit contract.
2. **How do Entity and Value Object differ?** An Entity has identity and continuity; a Value Object is defined by its values and is replaced rather than independently identified.
3. **Why is a context not always a service?** A semantic and ownership boundary need not be a deployment boundary; distribution complexity can wait until there is a need.
4. **What does an Aggregate Root do?** It is the entry point for mutations and guards the aggregate’s invariants.
5. **Why use an Anti-Corruption Layer?** To translate a model you do not control without spreading its terms and assumptions through your domain.

## Exercise

Define possible contexts for ordering, payments, shipping, and invoicing. Explain what “order status” means in each, who owns the data, and which event or contract connects the contexts.

### Sample answer

The Order context owns the commercial order lifecycle. Payment owns attempts, captures, and refunds. Shipping owns fulfillment and tracking. Invoice owns issued financial documents and corrections. Do not share one global meaning of “status.” Connect them through stable identifiers and events such as OrderPlaced, PaymentSettled, and ShipmentDispatched. Each context keeps its own language and persistence model.

## Further reading

- Persian: [Persian DDD guide](https://github.com/hheydarian/Understanding-Domain-Driven-Design), [DDD in DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-1406.pdf)
- English: [Martin Fowler: Bounded Context](https://martinfowler.com/bliki/BoundedContext.html), [Microsoft DDD and microservices guide](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/), [AWS Well-Architected: Domain-driven design](https://docs.aws.amazon.com/wellarchitected/latest/framework/rel_domain_driven_design.html), [Vaughn Vernon: Domain-Driven Design](https://www.dddcommunity.org/)

