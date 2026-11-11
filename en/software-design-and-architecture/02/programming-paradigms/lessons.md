<div dir="ltr" align="left">

# Full lesson: Programming paradigms

> **Language:** [Persian edition](../../../../fa/software-design-and-architecture/02/programming-paradigms/lessons.md)

## Learning goals

By the end of this lesson, you should be able to explain what a programming paradigm changes about a program's structure, compare imperative, procedural, object-oriented, functional, declarative, and logic-oriented approaches, and choose a mix of styles based on the shape of a problem.

## What is a programming paradigm?

A programming paradigm is a way to organize computation: how a program represents state, divides responsibilities, expresses control flow, and combines behavior. It is not the name of a language or a particular syntax. Python, Kotlin, C#, and JavaScript support more than one paradigm, so a system can use different styles where each one clarifies a different kind of work.

For example, an order workflow may use an imperative use case to coordinate the steps, an object to protect the order's lifecycle rules, pure functions to calculate totals, and SQL to query a report. The aim is not to select one paradigm for an entire codebase. The aim is to make the relevant rules and effects easy to see.

## 1. Imperative and procedural programming

Imperative code describes actions and state changes in an explicit sequence. Procedural programming groups these actions into procedures or functions. It works well for short workflows with a clear order of operations.

```python
def place_order(request, inventory, payments, repository):
    validate(request)
    inventory.reserve(request.items)
    payment = payments.charge(request.customer, request.total)
    order = build_order(request, payment.id)
    repository.save(order)
    return order.id
```

The sequence is easy to follow. The risk appears when the same business rule is copied into several procedures or callers can change shared state without enforcing an invariant. A procedural function is not inherently poor design; stronger boundaries become useful when the workflow or rules grow.

## 2. Object-oriented programming

Object-oriented programming groups related state and behavior behind objects and lets them collaborate through messages or contracts. It can be useful for concepts with a lifecycle and rules that must stay true, such as an account, order, subscription, or reservation.

In an order flow, the `Order` object can protect valid transitions such as `Draft → Submitted → Paid` or `Submitted → Cancelled`. An application use case can still coordinate inventory, payment, persistence, and notifications. Putting every database call and workflow step inside an entity is not a requirement of object orientation.

Consider OOP when several operations must preserve the same state rules, when behavior and data change together, or when callers should depend on a capability rather than a storage detail. Avoid large objects with many unrelated responsibilities, inheritance used only to share a few lines, a class for every passive record, and public setters that let callers bypass invariants.

See the separate [object-oriented programming lesson](../../03/object-oriented-programming/lessons.md) for deeper coverage of encapsulation, abstraction, inheritance, polymorphism, and domain modeling.

## 3. Functional programming

Functional programming emphasizes functions, explicit data transformation, immutability, and controlled side effects. A **pure function** returns the same result for the same inputs and does not change external state. Small pure functions can be composed into a larger calculation.

```python
eligible = [item for item in cart if item.is_available]
subtotal = sum(item.price_cents * item.quantity for item in eligible)
total = apply_discount(subtotal, discount_policy)
```

This style can make calculations deterministic, testable, and easier to reason about locally. It does not remove real-world effects: a program still reads a clock, calls a payment provider, writes a database, and sends messages. A common approach is to keep the core calculation mostly pure and make the outer layer explicitly perform I/O. This is often called the **functional core, imperative shell** approach.

Immutability and functional composition also have costs: additional allocations or mappings, unfamiliar notation, or awkwardness when the domain is naturally stateful. Use these tools where they make behavior easier to understand, not as a rule that every value must be transformed in a pipeline.

## 4. Declarative and logic-oriented programming

Declarative code describes the result or relationship wanted and delegates the execution strategy to an engine or framework. SQL describes which rows to select; the database chooses a plan for retrieving them. HTML describes document structure, while CSS describes presentation rules. Logic-oriented programming expresses facts and rules from which a system derives answers.

```sql
SELECT order_id, total_cents
FROM orders
WHERE state = 'paid'
ORDER BY created_at DESC;
```

Declarative expressions can separate intent from execution and allow an engine to optimize the work. The implementation details still matter: understand query plans, transaction semantics, evaluation order, and failure behavior. Declarative does not mean “simple” or “free of implementation concerns.”

## 5. Compare paradigms on one problem

Consider calculating an order total and recording payment:

- **Procedural:** An application function shows the steps: validate, price, charge, and save. It is direct for a clear workflow; duplicated pricing rules are a warning sign.
- **Object-oriented:** An order object protects valid state transitions while a use case coordinates external capabilities. This is useful when invariants and lifecycle matter; excessive hierarchy can make the model harder to change.
- **Functional:** Pure functions calculate line totals, discounts, and tax from explicit inputs. This supports testing and composition; rates and time must be passed in rather than read invisibly from global state.
- **Declarative:** SQL retrieves paid orders for a report. It is concise for data selection; the query plan and transaction behavior still need to be understood.

These approaches can coexist. Use the style that makes each rule or effect easiest to locate and review.

## 6. How to choose a style

Ask these questions before adding abstractions:

1. Is the problem mainly a data transformation, lifecycle, workflow, query, or set of rules?
2. Which state may change, and which invariants must remain true?
3. Which effects are involved: network, time, database, file system, message broker, or randomness?
4. Which parts change independently, and which change together?
5. Which form will the team be able to read, test, and maintain?
6. What do existing tools and tests make easy or difficult to observe?

| Problem pressure | Useful starting point | Watch for |
| --- | --- | --- |
| A short, explicit sequence of steps | Procedure or application use case | Duplicated business rules across workflows |
| State with related invariants | Domain model or stateful object | Setters or inheritance that bypass or obscure the rules |
| Pure value transformation | Function or pipeline | Hidden inputs and side effects inside the calculation |
| Data selection and constraints | Declarative language such as SQL | Query-plan, transaction, and null semantics |
| Several genuinely replaceable behaviors | Strategy, interface, or composition | Abstractions added before variation is real |

## 7. Common misconceptions

- **“Object-oriented means everything must be a class.”** Simple values and functions are often the clearest choice.
- **“Functional programming has no state or effects.”** Effects remain, but can be made explicit and concentrated at boundaries.
- **“Declarative code hides every implementation concern.”** Performance, transactions, and failure modes still matter.
- **“The language dictates the paradigm.”** Most commonly used languages support multiple styles.
- **“Mixing paradigms is inconsistent.”** A deliberate mix can make calculations, state, orchestration, and queries clearer than one uniform approach.

## 8. Comprehensive exercise: an invoicing workflow

Design a small invoicing feature. It validates a draft invoice, calculates line totals and tax, records the result, and produces a report of issued invoices.

1. Write the workflow steps as a procedure or use case.
2. Identify the invoice state and transitions that must remain valid.
3. Express amount and tax calculations as pure functions.
4. Write a declarative query for issued invoices.
5. Mark where database, clock, and network effects occur.
6. Review whether each abstraction is justified by the domain and the team's ability to maintain it.

**Worked answer:** The use case loads a draft invoice, checks the caller's permission, invokes domain behavior to issue it, and commits the change. The invoice protects transitions such as `Draft → Issued` and rejects issuing an empty invoice. Pure functions calculate line amounts and tax from explicit prices, quantities, currency, and tax policy. The repository persists the invoice; the clock is passed in when the issue timestamp is needed. SQL or a query builder retrieves issued invoices for the report. For a very small invoice feature with no meaningful lifecycle or changing rules, a transaction script may be enough; introduce a richer model when it clarifies real invariants.

## 9. Answered quiz

1. **What is the difference between imperative and declarative programming?**
   **Answer:** Imperative code describes actions and state changes. Declarative code describes the desired result or relationships and leaves more of the execution strategy to an engine.

2. **Is a function pure if it reads from a database and increments a global counter?**
   **Answer:** No. Its result depends on external state, and it changes external state.

3. **Why might an account be modeled as an object?**
   **Answer:** Its lifecycle and rules—such as withdrawal limits—must remain valid across multiple operations and callers.

4. **Which approach may be enough for a short, three-step workflow?**
   **Answer:** A clear procedure or use case is often enough unless the steps contain stateful or independently changing rules that justify stronger boundaries.

5. **Does functional programming remove side effects?**
   **Answer:** No. It can make effects explicit at the boundary and keep the central calculations easier to test.

6. **Why is it reasonable to combine paradigms?**
   **Answer:** A workflow, state transition, calculation, and query are different problems and may be clearer when expressed with different tools.

7. **Why does a declarative SQL query still need performance review?**
   **Answer:** The database's chosen plan, indexes, data size, transaction isolation, and returned rows determine its real cost and behavior.

## Optional further reading

### English

- [MDN — Programming paradigm](https://developer.mozilla.org/en-US/docs/Glossary/Programming_paradigm) — A concise introduction to the term.
- [Python — Functional Programming HOWTO](https://docs.python.org/3/howto/functional.html) — Iterators, generators, and functional techniques in Python.
- [The Rust Programming Language — Functional Language Features](https://doc.rust-lang.org/book/ch13-00-functional-features.html) — Closures and iterators in a multi-paradigm language.
- [Microsoft — Functional vs. imperative programming](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/linq/functional-programming-vs-imperative-programming) — Examples and a direct comparison of the two styles.
- [SICP — Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/9780262510875/structure-and-interpretation-of-computer-programs/) — A deeper text on abstraction and ways to organize computation.
- [Oracle Java Tutorials — Object-oriented concepts](https://docs.oracle.com/javase/tutorial/java/concepts/) — Objects, classes, inheritance, interfaces, and packages.

### Persian

- [Object-Oriented Programming Handbook](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — Persian notes on object-oriented concepts.
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian course material on paradigms, principles, and patterns.

For additional references grouped by chapter, see the [course reference library](../../references.md#chapter-02).

</div>
