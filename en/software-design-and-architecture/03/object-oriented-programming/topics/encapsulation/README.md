<div dir="ltr" align="left">

# Encapsulation
> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/encapsulation/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.


**Position in the roadmap:** [Object Oriented Programming](../../README.md) · [Full Course List](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

Encapsulation keeps the data and rules behind controlled operations so that invalid state is not created from the outside.
## Practical example

Only `cancel()` cancels the order and checks the cancellation time.
There is no public state setter.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Object Oriented Programming" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Locking state can make testing or collaboration difficult.
Keep the necessary API on and minimal.
- **Review:** Private field without invariant or contract, encapsulation alone is not meaningful.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: Encapsulation keeps the data and rules behind the controlled operation so that invalid state is not created from the outside.
2. **What decision do you make in the example below and why?**   
- Suggested response: only `cancel()` cancels the order and checks the cancellation timeout.
There is no public state setter.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: locking state can make testing or collaboration difficult.
Keep the necessary API on and minimal.
4. **Which common error do you check before merging the code?**   
- Suggested answer: private field without invariant or contract, encapsulation alone is not meaningful.
## In-depth lesson for this topic
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
## Worked code example

Encapsulation gives the owner of state control over changes and invariant preservation.
A private field is not enough if a public setter or alternate operation can create invalid state.
Make each operation's preconditions, result, and failures explicit.

**Exercise with answer:** Where should an overdraft be rejected?
In Account, the owner of the balance.
Cover zero, exact-balance, and over-balance withdrawals.
This C
# sketch abbreviates supporting domain types so the design decision stays in focus.

~~~csharp
public sealed class Account(Money openingBalance)
{
    public Money Balance { get; private set; } = openingBalance;

    public void Withdraw(Money amount)
    {
        if (amount <= Money.Zero || amount > Balance)
            throw new InvalidOperationException("Invalid withdrawal.");
        Balance -= amount;
    }
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

Apply encapsulation to solve a specific problem, document the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-03)

</div>
