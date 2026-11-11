<div dir="ltr" align="left">

# Value Objects
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/09/enterprise-patterns/topics/value-objects/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Enterprise Software Patterns](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

value object is known by value and meaning, not independent identifier.
It is usually immutable and preserves the invariant in construction.
## Practical example

`Money(amount, currency)` rejects sums of money in different currencies.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Enterprise Software Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Too many types can make mapping and serialization heavy.
- **Revision:** Do not convert a domain value like Money to a unitless number.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: value object is known by value and meaning, not independent identifier.
It is usually immutable and preserves the invariant in construction.
2. **What decision do you make in the example below and why?**   
- Suggested answer: `Money(amount, currency)` rejects the sum of money with different currencies.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: Many types can make mapping and serialization heavy.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not convert a domain value such as Money to a unitless number.
## In-depth lesson for this topic
### 8. Value Object

Value Object has no independent identity and is equal to value/meaning.
Money includes amount and currency.
EmailAddress can perform basic normalization and validation during construction.
Value object is generally immutable so that hidden change and hash/equality are not unstable.

~~~python
@dataclass(frozen=True)
class Money:
    amount_cents: int
    currency: str

    def add(self, other):
        if self.currency != other.currency:
            raise ValueError("Currencies must match")
        return Money(self.amount_cents + other.amount_cents, self.currency)
~~~

Domain types bring a lot of mapping and serialization.
Do not create a type for any simple string unless it has a specific meaning, validation or operation.
## Worked code example

A Value Object is defined by its value and value-based equality, without independent identity.
Make it immutable and self-validating so units, currency, and valid ranges travel with the data.

**Common pitfall:** Do not represent money as a unitless decimal; adding different currencies must fail or convert through an explicit rate.

**Exercise with answer:** 10 USD is not equal to 10 EUR; currency is part of equality and operation invariants.
This C
# sketch abbreviates supporting types and focuses on the pattern boundary.

~~~csharp
public sealed record Money(decimal Amount, string Currency)
{
    public Money Add(Money other)
    {
        if (Currency != other.Currency) throw new InvalidOperationException();
        return this with { Amount = Amount + other.Amount };
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

Apply value objects to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-09)

</div>
