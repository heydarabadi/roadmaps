<div dir="ltr" align="left">

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/08/architectural-patterns/topics/cqrs/README.md)Command Query Responsibility Segregation (CQRS)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The writing model that implements the state change rules is separate from the reading model.
In simple form, both can be in one service and one database.
## Practical example

Order registration is done with aggregate and order list query with projection according to the page.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its background are linked in the "Architectural Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Projection and final adaptation complicates the reading model.
- **Review:** CQRS is not necessarily two databases or two microservices.
Only useful when the read/write model is really different.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the writing model that implements the state change rules is separate from the reading model.
In simple form, both can be in one service and one database.
2. **What decision do you make in the example below and why?**   
- Suggested answer: order registration is done with aggregate and order list query with projection according to the page.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: projection and final adaptation complicates the reading model.
4. **Which common error do you check before merging the code?**   
- Suggested answer: CQRS is not necessarily two databases or two microservices.
Only useful when the read/write model is really different.
## In-depth lesson for this topic
### 10. CQRSCQRS separates the read and write model.
The simple version can be two handlers and two logical models in one process and database. executes write invariant and transaction model; read projection is formed for the page or report.

~~~python
def place_order(command, order_repository):
    order = Order.from_command(command)
    order_repository.save(order)
    return order.id

def get_order_summary(query, read_store):
    return read_store.find_summary(query.order_id)
~~~

CQRS is not necessarily two databases or two services.
Physical isolation is valuable when query load, schema, or scalability are genuinely different.
In that case, projection delay and final adjustment are also part of the contract.
Fowler warns that CQRS adds undue complexity to many systems.
## Architecture diagram and walkthrough

CQRS helps when read and write needs materially differ.
Commands change the write model; queries read a projection.
This separation adds synchronization cost and eventual consistency, and it is not inherently a microservices architecture.

**Common pitfall:** Do not create two models and databases for simple CRUD.

**Exercise with answer:** A dashboard tolerates delay, so an asynchronous projection may fit; return command results from the write side and its commit status.
This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
[Command] ---> [Write model] ---> [Write store]
                       |
                    events
                       v
[Query] <--- [Read projection] <--- [Projector]
~~~


## Architecture diagram and walkthrough

CQRS fits when read and write needs materially differ.
Commands change the write model, while queries read a projection; this adds synchronization cost and eventual consistency and is not inherently microservices.

**Common pitfall:** Do not create separate models and databases for simple CRUD.

**Exercise with answer:** A dashboard tolerates delay, so use an asynchronous projection, but return commit results from the write side.
This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
[Command] ---> [Write model] ---> [Write store]
                       |
                    events
                       v
[Query] <--- [Read projection] <--- [Projector]
~~~


## Resources
### Persian

- [Persian Guide to Domain-Oriented Design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Structured Persian guide to DDD, Common Language and Modeling.
- [DNTips; Software layering architecture](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — Persian examples in application and data layer.
### English

- [Microsoft Learn; DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — domain boundary, layers and domain model.
- [Martin Fowler; CQRS](https://martinfowler.com/bliki/CQRS.html) — CQRS definition and warning about additional complexity.
- [Martin Fowler.Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — Logging changes as events and replay considerations.
## Summary

Apply the separation of command and query responsibilities to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)

</div>
