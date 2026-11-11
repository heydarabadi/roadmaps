<div dir="ltr" align="left">

# Observer
> **Language:** [Persian edition](../../../../../../../05/design-patterns/topics/gof-design-patterns/patterns/observer/README.md)
> [Continue with the full chapter lesson](../../../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Family:** behavioral · 

**Chapter:** [Design Patterns](../../../../README.md)
## Pattern intent

Notifies multiple subscribers of the topic change.
Fan-out is separated from direct dependency.
## Practical example

After the price is published, the cache and the search list are updated.
## When to use it and limitations

Use this pattern when its intent matches the problem and its structure makes the design easier to understand or change.

**Important limitations:** Handle indeterminate ordering, leaked subscribers, and hidden streams.
## Test questions with answers

1. **Which problem does it solve?**   
- Suggested answer: informs many subscribers about the change of topic.
Fan-out is separated from direct dependency.
2. **What does it structure in this example?**   
- Suggested answer: After the price is published, the cache and the search list are updated.
3. **When is it better to go for the simpler option?**   
- Suggested answer: Control the unspecified order, leaked subscribers and hidden flow.
## Pattern family context

This is one of the GoF behavioral patterns. The [integrated chapter lesson](../../../../lessons.md#3-gof-behavioral-patterns) compares this family and explains how to choose among similar patterns.

## Worked implementation

After shipment, an order publishes a change event for independent subscribers.
Keep event data immutable and define synchronous or asynchronous handling.
Durable cross-process delivery needs a broker and retries; subscribers must also unsubscribe.

**Exercise with answer:** Email failure does not undo shipment; record and retry it separately because shipment is already a committed fact.
The code sample is an educational sketch; supporting domain types are abbreviated.

~~~csharp
public event EventHandler<OrderShippedEventArgs>? Shipped;

public void MarkShipped(string trackingCode)
{
    ValidateTransition();
    Status = OrderStatus.Shipped;
    Shipped?.Invoke(this, new OrderShippedEventArgs(trackingCode));
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
