<div dir="ltr" align="left">

# Primary OOP Principles
> **Language:** [Persian edition](../../../../../03/object-oriented-programming/topics/primary-principles/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

The four concepts of encapsulation, abstraction, inheritance and polymorphism are tools to protect the status and diversity of behavior.
Their use should solve the needs of the model.
## Practical example

In checkout, the `PaymentMethod` contract gives common behavior, but each method maintains its own validation details.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep the design simpler:** The four concepts solve different problems; no class needs to demonstrate all of them.
- **Revision:** Don't memorize terms.
Show which change or invariant each controls.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: the four concepts of encapsulation, abstraction, inheritance and polymorphism are tools to protect the status and diversity of behavior.
Their use should solve the needs of the model.
2. **What decision do you make in the example below and why?**   
- Suggested answer: In payment, the `PaymentMethod` contract gives common behavior, but each method maintains its own validation details.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: These concepts are independent of each other and it is not necessary for every class to use all four.
4. **Which common error do you check before merging the code?**   
- Suggested answer: don't memorize terms.
Show which change or invariant each controls.
## In-depth lesson for this topic
### 2. Four basic principles of OOP
#### Encapsulation

Encapsulation controls direct access to state to preserve the invariant. invariant is a condition that must be maintained before and after all valid operations.
For example, the account balance after withdrawal should not exceed the allowed credit limit.
Steps: Write the invariant; limit free setter; operation create a domain; change the state only from the same path.
Prevent invalid states from being constructible.

~~~python
class Account:
    def __init__(self, balance_cents, credit_limit_cents=0):
        self._balance = balance_cents
        self._credit_limit = credit_limit_cents

    def withdraw(self, amount_cents):
        if amount_cents <= 0:
            raise ValueError("Amount must be positive")
        if self._balance - amount_cents < -self._credit_limit:
            raise InsufficientFunds()
        self._balance -= amount_cents
~~~

The private field is not enough without mutation control.
If another method modifies the value without the invariant, the encapsulation is broken.
For mutable sets, you should be careful not to leak the internal reference from the property.
#### Abstraction

Abstraction keeps the contract necessary for the consumer and hides irrelevant details.
The order use case needs to know how to reserve the item, not how each database connection and SQL query works.
Abstract from consumer needs: What is needed?
What results and failures are possible?
What details should not reach the caller?
If the API still gives an ORM entity or raw vendor error, the abstraction is not complete.
Not every interface is valuable.
If there is only one implementation, no test seam, and no reason to change, the contract can be just an extra layer.
Premature abstraction guesses the future.
Adequate abstraction limits real change.
#### Inheritance

Inheritance can give type relation, reuse behavior and polymorphism.
But "for reuse" is not enough reason.
The subtype relationship must be correct from the consumer's point of view: wherever the base type is used, the subtype must also maintain the behavioral convention.
If a subtype disables a basic operation, requires a stronger precondition, or changes the meaning of the result, that subtype is probably not a valid substitute.
The subclass depends on the base implementation, order of hooks and protected API.
Changing the base class can break inheritors that are owned by another team.
A classic example: a square is mathematically a kind of rectangle, but a rectangular object whose width and height change independently cannot be replaced with a square.
Conceptual sharing does not always make a subtype agreement.
For behaviors that change to multiple independent axes, composition is more appropriate: order takes a DiscountPolicy, rather than creating a new subclass for each customer type and campaign combination.
#### Polymorphism

Polymorphism means that the consumer works with a common contract and the behavior is selected based on the actual implementation. subtype polymorphism uses interface/base type; parametric polymorphism from generic.
Some languages ​​have dispatch according to overload or pattern matching.

~~~python
class DiscountPolicy(Protocol):
    def apply(self, subtotal_cents: int) -> int: ...

def checkout(subtotal_cents, policy: DiscountPolicy):
    return policy.apply(subtotal_cents)
~~~

This reduces sparse branches if the discounting algorithms are truly different and interchangeable.
If we have only one policy and no specific change driver, the direct function is simpler.
For the common contract, have a test contract so that the implementations follow a minimal behavior.
## Worked code example

The four core ideas work together: encapsulation protects state, abstraction exposes the needed contract, polymorphism selects behavior without type checks, and inheritance models genuine subtypes.
State the problem and invariants before choosing a mechanism.

**Exercise with answer:** Why is a public field not enough for OOP?
State without rule ownership or controlled transitions cannot protect invariants.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public interface IDiscountPolicy
{
    Money Calculate(Order order);
}

public sealed class Order
{
    public Money Total { get; private set; }

    public void Apply(IDiscountPolicy policy)
        => Total -= policy.Calculate(this);
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

Apply the basic principles of object orientation to solve a specific problem, document the trade-offs, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
