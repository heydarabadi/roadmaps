<div dir="ltr" align="left">

# Object-Oriented Programming

> **Language:** [Read the Persian edition](../../../../../../fa/software-design-and-architecture/03/object-oriented-programming/topics/object-oriented-programming/README.md)

[Chapter overview](../../README.md) · [Integrated chapter lesson](../../lessons.md) · [Course index](../../../../00-index.md)

## Learning goals

After this lesson, you should be able to explain what object-oriented programming (OOP) organizes, distinguish an object from a class and a value, describe encapsulation and polymorphism, model a small business rule without exposing invalid state, and name the costs that OOP can introduce.

## The central idea

OOP organizes a program around objects that collaborate through contracts. An object combines some state with operations that are meaningful for that state. The purpose is to give related rules a clear owner and to limit how callers can change that state.

A **class** defines a type and its operations. An **object** is a runtime instance of a type. An **entity** has a stable identity through changes. A **value object** is identified by its value and is commonly immutable. These are related ideas, but they are not interchangeable.

OOP is one way to organize a program, not a rule that every noun must become a class. A price calculation may be clearer as a pure function. A simple read-only record may need no behavior. A workflow can combine functions, objects, and declarative queries where each is easiest to follow.

## Four ideas, used for concrete reasons

### Encapsulation

Encapsulation protects an invariant by limiting direct access to state. An invariant is a rule that must remain true after every valid operation. A bank account, for example, should not allow a withdrawal that exceeds its permitted credit limit.

```python
class Account:
    def __init__(self, balance_cents: int, credit_limit_cents: int = 0):
        self._balance = balance_cents
        self._credit_limit = credit_limit_cents

    def withdraw(self, amount_cents: int) -> None:
        if amount_cents <= 0:
            raise ValueError("Amount must be positive")
        if self._balance - amount_cents < -self._credit_limit:
            raise ValueError("Insufficient funds")
        self._balance -= amount_cents
```

The underscore is only a convention in Python. The important decision is that callers use the withdrawal operation, which checks the rule, instead of assigning an arbitrary balance. A test should cover zero, negative, permitted, and rejected withdrawals.

### Abstraction

Abstraction exposes the contract a consumer needs while hiding details that should not affect that consumer. A checkout workflow may need to request authorization; it should not need to know the payment provider's HTTP format or retry headers.

An abstraction is useful when it protects a real change boundary, isolates an external system, or makes a rule easier to test. An interface added only because “every class needs one” creates another name and indirection without protecting anything.

### Inheritance

Inheritance can express a subtype relationship and reuse behavior, but reuse alone is a weak reason to create a subtype. The subtype must preserve the promises made by its base type from the caller's point of view. If a `Square` cannot allow width and height to change independently while `Rectangle` promises that operation, the two types may not fit that inheritance contract.

Base classes also create coupling: subclasses can depend on protected members, method ordering, and implementation details. When behavior varies along independent dimensions, composition is often simpler. An order can receive a `DiscountPolicy` instead of having one subclass for each customer-and-campaign combination.

### Polymorphism

Polymorphism lets a caller use a shared contract while different implementations supply the behavior. In this Python example, checkout depends on the small capability it needs rather than a specific discount implementation:

```python
from typing import Protocol

class DiscountPolicy(Protocol):
    def apply(self, subtotal_cents: int) -> int: ...

def checkout(subtotal_cents: int, policy: DiscountPolicy) -> int:
    return policy.apply(subtotal_cents)
```

If there is only one stable rule and no meaningful boundary, a direct function may be clearer. Introduce polymorphism when implementations are genuinely interchangeable and the variation is important to the design.

## A small domain example: an order lifecycle

Suppose an order may be paid only while it is pending, and a paid order cannot be cancelled through the ordinary cancellation operation. Keep that transition rule with the order instead of scattering checks across controllers and background workers.

```python
from enum import Enum

class OrderStatus(Enum):
    PENDING = "pending"
    PAID = "paid"
    CANCELLED = "cancelled"

class Order:
    def __init__(self, order_id: str):
        self.id = order_id
        self._status = OrderStatus.PENDING

    @property
    def status(self) -> OrderStatus:
        return self._status

    def mark_paid(self) -> None:
        if self._status is not OrderStatus.PENDING:
            raise ValueError("Only a pending order can be paid")
        self._status = OrderStatus.PAID

    def cancel(self) -> None:
        if self._status is not OrderStatus.PENDING:
            raise ValueError("Only a pending order can be cancelled")
        self._status = OrderStatus.CANCELLED
```

This example protects one local invariant. It does not solve payment-provider failures, concurrent requests, persistence, or refunds. Those require application workflows and infrastructure boundaries; a method on an object does not make a distributed operation atomic.

## When OOP helps, and when it adds cost

OOP is a useful fit when state has a lifecycle, several operations must preserve the same invariant, or interchangeable implementations need one stable contract. It can also make ownership clearer when domain behavior is otherwise duplicated among callers.

It adds cost when simple data and transformations are wrapped in many classes, when inheritance creates fragile hierarchies, or when indirection hides the actual call flow. A rich domain model is valuable when important rules need protection; a behavior-light data model can be sufficient for simple CRUD, reporting, and transport.

## Common mistakes

- Turning every noun in a requirement into a class.
- Adding public setters that let callers bypass invariants.
- Using inheritance only to reuse a few lines of code.
- Creating an interface with no consumer need or real change boundary.
- Treating all OOP languages as if they enforce access and dispatch in the same way.
- Assuming an object method makes network calls or multi-database workflows reliable or atomic.

## Practice

Choose an order, reservation, or account from a small application. Write one invariant in plain language. Identify which operation owns that rule, then implement it so callers cannot bypass the check. Add tests for one allowed transition, one rejected transition, and a boundary value. Finally, explain whether the type needs inheritance, composition, or neither.

## Quiz with explained answers

1. **What is the main purpose of encapsulation?**
   **Answer:** To control how state changes so the object's invariants remain true. Hiding a field is useful only if every state-changing path still enforces the rule.

2. **How are a class and an object different?**
   **Answer:** A class defines a type and its possible operations; an object is a runtime instance that has particular state and identity where the domain requires it.

3. **When is inheritance a poor fit?**
   **Answer:** When the subtype cannot preserve the base contract, or when inheritance is being used only to share code. Composition is often clearer for independent behavior choices.

4. **Does OOP require every calculation to be a method on an object?**
   **Answer:** No. A deterministic calculation may be simpler as a function. Choose the representation that makes state ownership and rules easiest to understand.

5. **Does encapsulating an order make a payment workflow atomic?**
   **Answer:** No. Encapsulation protects local state rules. A workflow across a database and a payment provider needs explicit transaction, idempotency, retry, and reconciliation decisions.

## Further reading

- [Microsoft Learn — Object-Oriented Programming in C#](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — A guided overview of abstraction, encapsulation, inheritance, and polymorphism.
- [Oracle Java Tutorials — Object-Oriented Concepts](https://docs.oracle.com/javase/tutorial/java/concepts/) — Classes, objects, inheritance, interfaces, and related vocabulary.
- [Microsoft — Tactical Domain-Driven Design](https://learn.microsoft.com/en-us/azure/architecture/microservices/model/tactical-domain-driven-design) — Entities, value objects, aggregates, and bounded contexts.
- [Curated bilingual reference library](../../../../references.md#chapter-03)

</div>
