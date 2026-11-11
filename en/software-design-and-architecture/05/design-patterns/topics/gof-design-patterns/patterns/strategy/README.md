<div dir="ltr" align="left">

> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/strategy/README.md)Strategy
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

It isolates the replaceable algorithm behind the contract and leaves its selection to composition/configuration.
## Practical example

Pricing is implemented with a normal, wholesale or campaign discount policy.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Do not add class for two static lines.
Strategies must be real variation.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: isolates the replaceable algorithm behind the contract and leaves its selection to composition/configuration.
2. **What does it structure in this example?**   
- Suggested answer: Pricing is implemented with a normal, wholesale or campaign discount policy.
3. **When is it better to go for the simpler option?**   
- Suggested answer: Do not add a class for two fixed lines.
Strategies must be real variation.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Put discount algorithms behind a contract so checkout does not depend on their details.
Select the policy from explicit configuration or a campaign rule.
Avoid classes for hypothetical variation; keep it simple until the need is real.

**Exercise with answer:** Add a seasonal policy and select it through the campaign rule; the payment gateway should not know campaigns.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public interface IDiscountPolicy { Money Calculate(Order order); }

public sealed class MemberDiscount : IDiscountPolicy
{
    public Money Calculate(Order order) => order.Subtotal * 0.05m;
}

var discount = policy.Calculate(order);
~~~


## Resources
### Persian

- [Persian design patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian summaries of GoF patterns and several architecture patterns.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian textbook resource for GoF, GRASP and architectural patterns.
### English

- [Refactoring.Guru; Design Patterns](https://refactoring.guru/design-patterns) — List of GoF patterns and multilingual examples.
- [Patterns.Guru; GoF catalog](https://patterns.guru/) — A catalog and discussion of pattern intent and selection costs.
- [Wiley; POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — An example of architecture and concurrency patterns in the POSA suite.
## Further reading

[Curated references for this chapter](../../../../../../references.md#chapter-05)

</div>
