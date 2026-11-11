<div dir="ltr" align="left">

# Adapter

> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/adapter/README.md)

> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Family:** structural · 

**Chapter:** [Design Patterns](../../../../README.md)

## Pattern intent

It transforms the inconsistent interface into the convention that the consumer expects.

## Practical example

The adapter maps the payment SDK response to the domain's standard result.

## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.



**Important limitation:** error and meaning mapping must be explicit. Do not hide the details of the error.

## Test questions with answers

1. **Which problem does it solve?**
   - Suggested answer: Converts the incompatible interface to the convention that the consumer expects.
2. **What does it structure in this example?**
   - Suggested response: The adapter maps the payment SDK response to the domain's standard result.
3. **When is it better to go for the simpler option?**
   - Suggested answer: error and meaning mapping should be clear. Do not hide the details of the error.

## Pattern family context

This is one of the GoF structural patterns. The [integrated chapter lesson](../../../../lessons.md#2-gof-structural-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Translate the vendor payment SDK behind an application contract; preserve request shape and failure meaning. The use case should not know SDK types. Test success, decline, timeout, and malformed replies separately.


**Exercise with answer:** When the vendor changes, the adapter and its tests should change. If the use case changes too, vendor details crossed the boundary.

The C# block is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed class VendorPaymentAdapter(IVendorSdk sdk) : IPaymentGateway
{
    public async Task<PaymentResult> Capture(Money amount, CancellationToken ct)
    {
        var reply = await sdk.ChargeAsync(amount.MinorUnits, amount.CurrencyCode, ct);
        return reply.Approved
            ? PaymentResult.Success(reply.TransactionReference)
            : PaymentResult.Declined(MapReason(reply.Code));
    }
}
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
