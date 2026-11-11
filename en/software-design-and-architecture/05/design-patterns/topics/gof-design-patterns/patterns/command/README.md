<div dir="ltr" align="left">

# Command
> **Language:** [Persian edition](../../../../../../../../fa/software-design-and-architecture/05/design-patterns/topics/gof-design-patterns/patterns/command/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

Converts the request to an object/message to enable queuing, scheduling, retry, or undo.
## Practical example

The `ApproveRefund` command is processed with a unique queue ID and idempotent.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Commands can add boilerplate classes.
Manage order and repetition.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested response: Converts the request into an object/message to enable queuing, scheduling, retry or undo.
2. **What does it structure in this example?**   
- Suggested answer: The `ApproveRefund` command is processed with a unique queue ID and idempotent.
3. **When is it better to go for the simpler option?**   
- Suggested answer: Commands can override boilerplate classes.
Manage order and repetition.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

Represent the request as data so it can be queued, logged, retried, or undone.
Queue delivery may repeat, so handlers need idempotency, and command effects should remain separate from queries.

**Exercise with answer:** A worker crashes after charging; retry with the same idempotency key must return the prior result instead of charging again.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public sealed record CapturePayment(Guid CommandId, Guid OrderId, Money Amount);

public sealed class CapturePaymentHandler(IPaymentGateway gateway)
{
    public Task<PaymentResult> Handle(CapturePayment command, CancellationToken ct)
        => gateway.Capture(command.Amount, ct);
}
~~~


## Resources
### Persian

- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian summaries of GoF patterns and several architectural patterns.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian textbook resource for GoF, GRASP and architectural patterns.
### English

- [Refactoring.Guru; Design Patterns](https://refactoring.guru/design-patterns) — List of GoF patterns and multilingual examples.
- [Patterns.Guru; GoF catalog](https://patterns.guru/) — A catalog and discussion of pattern intent and selection costs.
- [Wiley; POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — An example of architecture and concurrency patterns in the POSA suite.
## Further reading

[Curated references for this chapter](../../../../../../references.md#chapter-05)

</div>
