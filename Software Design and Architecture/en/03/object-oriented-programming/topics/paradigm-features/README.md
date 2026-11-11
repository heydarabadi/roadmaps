<div dir="ltr" align="left">

# Features of the object-oriented paradigm — OOP Paradigm Features
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/paradigm-features/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Abstract/concrete classes, access scope and interface are tools for contract definition, reuse and disclosure level control.
## Practical example

The payment module sees `IPaymentGateway` for the use case and provides the infrastructure for the actual implementation.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** The details of languages ​​are different.
Separate meaning from syntax.
- **Review:** Don't interface every class; interface is useful when there is a boundary or multiple real implementations.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: abstract/concrete classes, access scope and interface are tools for contract definition, reuse and disclosure level control.
2. **What decision do you make in the example below and why?**   
- Suggested answer: The payment module sees `IPaymentGateway` for the use case and provides the infrastructure for the actual implementation.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: the details of the languages are different.
Separate meaning from syntax.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't interface every class; interface is useful when there is a boundary or multiple real implementations.
## In-depth lesson for this topic
### 3. Language features: interface, abstract class, concrete class, scope
#### Interface

Interface is a capability contract.
For example, the PaymentAuthorizer tells what to do with the consumer.
Design the interface from the consumer's needs, not from the vendor's entire SDK.
If a large interface provides all payment, refund, reporting, and configuration operations, consumers become dependent on irrelevant operations.
A smaller contract based on roles may be appropriate.
#### Abstract class

An abstract class is not directly instantiated and may have a shared implementation or template algorithm.
Template Method is suitable when the sequence of steps is fixed and one step can be changed.
If the subclasses change order or there are multiple independent axes of variation, composition usually has less coupling.
#### Concrete class

The object class fully implements the contract and is constructible.
StripeGateway is an example of a concrete adapter. composition root or factory must configure sensitive dependencies.
Multiple callers should not update the real port by themselves.
Don't make the interface just for "maybe someday".
#### Scope and visibility

Scope is the range of validity of the name in the language: block, function, module or global.
Visibility is the external access level: private, protected, internal/package or public.
The two are related but not the same.
Start with the lowest required visibility. public member creates an external supported contract, and changing it requires compatibility. protected is also a type of API for inheritors. global mutable state makes it hard to track the change.
Immutable constant is less risky.
## Worked code example

OOP groups related state and operations, hides implementation behind a contract, and uses polymorphic dispatch to select behavior by type.
These are tools; do not turn a simple function or passive data into a class hierarchy without a real need.

**Exercise with answer:** Adding a delivery method should not multiply conditionals in the use case; a shared contract with separate implementations can localize the change.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public interface IDeliveryMethod
{
    DeliveryQuote Quote(Parcel parcel);
}

public sealed class CourierDelivery : IDeliveryMethod
{
    public DeliveryQuote Quote(Parcel parcel) => CalculateCourierQuote(parcel);
}
~~~


## Resources
### Persian

- [Book of object-oriented programming; Programmer's House](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — An introductory Persian reference for object-oriented concepts.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian academic course about object-oriented design and patterns.
### English

- [Microsoft Learn.Object-oriented programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — Object-oriented concepts with C# examples.
- [Oracle Java Tutorials; Classes and Objects](https://docs.oracle.com/javase/tutorial/java/concepts/) — class model, object, inheritance and interfaces.
## Summary

Apply the features of the object-oriented paradigm to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
