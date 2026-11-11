<div dir="ltr" align="left">

# Chain of Responsibility
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/chain-of-responsibility/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

The request passes through a chain of handlers until one of them processes it or passes it on to the next.
## Practical example

Payment request validation steps go through authentication and risk filters.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitation:** Clarify chain order and completion.
The request should not disappear silently.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: The request passes through a chain of handlers so that one processes it or hands it over to the next.
2. **What does it structure in this example?**   
- Suggested answer: The payment request validation steps go through authentication and risk filters.
3. **When is it better to go for the simpler option?**   
- Suggested answer: Clarify the order and completion of the chain.
The request should not disappear silently.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

A request passes through authentication, rate-limit, and validation handlers; each continues or stops it.
Ordering is a security decision and should be tested.
Define what happens when no handler handles the request.

**Exercise with answer:** A rate-limited request must not reach the endpoint; test the pipeline order.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public delegate Task<Response> Handler(Request request, Func<Task<Response>> next);

Handler endpoint = request => HandleRequest(request);
Handler validate = (request, next) =>
    IsValid(request) ? next() : Task.FromResult(Response.BadRequest());
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
