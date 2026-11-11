<div dir="ltr" align="left">

# Identity Map
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/09/enterprise-patterns/topics/identity-map/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

In a unit of work, the identity map ensures that a row/identity is mapped to an instance of the object in memory and that duplicate loading does not result in another instance.
## Practical example

In one transaction, two queries for `Customer#42` return the same managed object.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** The memory and life of the work unit should be limited.
Old state can get confusing.
- **Review:** Don't consider identity map as a global or inter-request cache.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: In a unit of work, identity map ensures that a row/identifier is mapped to an instance of the object in memory and that repeated loading does not result in another instance.
2. **What decision do you make in the example below and why?**   
- Suggested answer: In a transaction, two queries for `Customer#42` return the same managed object.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: memory and working unit life should be limited.
Old state can get confusing.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't consider identity map as a global or inter-request cache.
## In-depth lesson for this topic
### 2. Identity Map

Identity Map in a unit of work ensures that an identity/identifier is mapped to an instance in memory.
If Customer with the same ID is queried twice, we will not get two independent mutable versions whose changes are incompatible with each other.
ORMs usually behave like this in the scope of a context/session.
This pattern is not global cache.
Limit its life to transaction/request or unit of work.
Global cache has the problem of invalidation, race and stale state.
Database concurrency and identity are independent of object reference.
## Worked code example

An Identity Map keeps one in-memory instance per identity within a unit of work.
This supports consistent updates and fewer queries, but cache lifetime, concurrency, and stale data must be controlled.

**Common pitfall:** Do not turn a long-lived identity map into a global cache.

**Exercise with answer:** Two queries in one transaction load the same OrderId; return the tracked instance to avoid conflicting updates.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public sealed class OrderIdentityMap
{
    private readonly Dictionary<OrderId, Order> _orders = [];

    public Order GetOrAdd(OrderId id, Func<Order> load)
    {
        if (!_orders.TryGetValue(id, out var order))
            _orders[id] = order = load();
        return order;
    }
}
~~~


## Resources
### Persian

- [Persian guide to domain-oriented design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — vocabulary of domain, model, entity and object value.
- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian description of DTO, CQRS and related patterns along with GoF.
### English

- [Martin Fowler; Patterns of Enterprise Application Architecture](https://martinfowler.com/eaaCatalog/index.html) — Reference catalog of Repository, Identity Map, Mapper and other patterns.
- [Microsoft Learn; Applying CQRS and DDD](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/apply-simplified-microservice-cqrs-ddd-patterns) — tutorial example of order and command/query separation.
## Summary

Apply the identity map to solve the specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
