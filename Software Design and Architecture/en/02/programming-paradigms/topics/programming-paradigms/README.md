<div dir="ltr" align="left">

# Programming Paradigms

> **Language:** [Persian edition](../../../../../02/programming-paradigms/topics/programming-paradigms/README.md)

> [Continue with the full chapter lesson](../../lessons.md) for a broader comparison, decision method, and additional practice.



**Roadmap location:** [Programming Paradigms](../../README.md) · [Full course index](../../../../00-index.md)

## Learning goals

After this topic, you should be able to:

- Explain what a programming paradigm changes about a program's organization.
- Distinguish procedural, object-oriented, functional, and declarative approaches.
- Identify state and side effects in a small workflow.
- Choose a style based on the problem and explain the trade-offs.

## Core idea

A programming paradigm is a way of organizing computation: how state is represented, how behavior is divided, how control flows, and how results are produced. It is not the name of a language. Most commonly used languages support several paradigms, so a program can combine them where they make different parts clearer.

For example, a checkout use case can coordinate the order of operations procedurally, an `Order` object can protect valid state transitions, a pure function can calculate a discount, and SQL can select paid orders for a report.

## 1. Imperative and procedural styles

Imperative code describes actions and state changes in a sequence. Procedural programming groups those actions into procedures or functions. This is direct and readable when a workflow has a small number of clear steps.

```python
def place_order(request, inventory, payments, repository):
    validate(request)
    inventory.reserve(request.items)
    payment = payments.charge(request.customer, request.total)
    order = build_order(request, payment.id)
    repository.save(order)
    return order.id
```

The sequence is visible. The design becomes harder to maintain when the same business rule is copied into several procedures or callers can mutate shared state without enforcing an invariant. A procedural function is not inherently a design flaw.

## 2. Object-oriented style

Object-oriented programming groups related state and behavior behind objects that collaborate through contracts or messages. It can be useful when an idea has a lifecycle and rules that callers must not bypass.

An `Order` object can own valid transitions such as `Draft → Submitted → Paid` or `Submitted → Cancelled`. A use case can still coordinate inventory, payment, and persistence. The entity does not need to perform every network call or workflow step.

Use this style when behavior and state change together or when several operations must preserve the same invariant. Avoid large objects with unrelated jobs, inheritance used only for small code reuse, and public setters that allow invalid state.

## 3. Functional style

Functional programming emphasizes functions, explicit transformations, immutable data, and controlled side effects. A pure function returns the same result for the same inputs and does not change external state.

```python
eligible = [item for item in cart if item.is_available]
subtotal = sum(item.price_cents * item.quantity for item in eligible)
total = apply_discount(subtotal, discount_policy)
```

Pure calculations are usually easy to test. They should receive inputs such as rates and dates explicitly rather than reading hidden global state. Real effects still exist: an application must read requests, call payment providers, store orders, and send messages. A common design keeps calculations in a mostly pure core and performs I/O at visible boundaries.

Immutability can make reasoning easier, but may add allocations and data mapping. Functional notation is a cost if the team cannot read it. Apply it where it clarifies transformations and rules.

## 4. Declarative and logic-oriented styles

Declarative code states the result or relationship wanted and leaves more of the execution strategy to a framework or engine. SQL is declarative: it describes which paid orders to retrieve, while the database selects a query plan.

```sql
SELECT order_id, total_cents
FROM orders
WHERE state = 'paid'
ORDER BY created_at DESC;
```

HTML describes document structure and CSS describes presentation rules. Logic-oriented programming expresses facts and relationships from which a system derives answers. Declarative code still has costs: understand query plans, transaction semantics, evaluation rules, and failures.

## 5. Compare the styles on one task

For calculating an order total and recording payment:

| Style | How it expresses the task | What to watch for |
| --- | --- | --- |
| Procedural | Show validation, pricing, payment, and persistence as ordered steps. | Keep shared business rules from spreading across procedures. |
| Object-oriented | Let the order protect its valid state and transitions. | Avoid deep inheritance and objects that own unrelated work. |
| Functional | Calculate line totals, discounts, and tax from explicit inputs. | Do not hide rates, time, or other inputs in global state. |
| Declarative | Query paid orders for the report. | Review query plans, transaction behavior, and data volume. |

No one style has to control the whole system. Choose the clearest expression for each responsibility.

## 6. Choosing a paradigm

Before adding abstractions, ask:

1. Is this mainly a calculation, a lifecycle, a workflow, a query, or a set of rules?
2. Which state can change, and which invariants must remain true?
3. Which effects are involved: network, time, database, file, messages, or randomness?
4. Which parts change independently, and which usually change together?
5. Can the team read, test, and operate the resulting design?

Use a simple procedure for a short workflow, an object or domain model for stateful invariants, pure functions for transformations, and declarative queries for data selection. Add an abstraction when actual variation or a boundary makes it valuable.

## Practice with answer

Design a simple invoice feature that validates a draft, calculates line amounts and tax, saves the invoice, and produces a report.

1. Write the workflow steps.
2. Name the invoice states and valid transitions.
3. Separate amount and tax calculations from I/O.
4. Write a query for issued invoices.
5. Identify where the database, clock, and network are accessed.

**Suggested answer:** A use case coordinates authorization, loading a draft, issuing the invoice, and committing the transaction. The invoice protects its state transition. Pure functions calculate amounts from explicit prices, quantities, currency, and tax policy. A repository or persistence adapter saves the invoice, and a query retrieves issued invoices for the report. If the feature has only a few simple rules, a transaction script can be enough; use a richer model when it protects meaningful invariants.

## Answered quiz

1. **What is a programming paradigm?**
   **Answer:** A way to organize state, behavior, control flow, and computation. It is not a specific language.

2. **How does imperative programming differ from declarative programming?**
   **Answer:** Imperative code describes actions and state changes. Declarative code describes a desired result or relationships and delegates more of the execution strategy to an engine.

3. **Is a function pure if it reads a database and increments a global counter?**
   **Answer:** No. Its result depends on external state, and it changes state outside the function.

4. **Why can an order be modeled as an object?**
   **Answer:** Its lifecycle and invariants must remain valid across several operations and callers.

5. **Does functional programming remove side effects?**
   **Answer:** No. It makes them explicit and can keep the central calculations easier to test.

6. **Why is it reasonable to combine paradigms?**
   **Answer:** A calculation, state transition, workflow, and query are different problems and may be clearer with different tools.

## Further reading

### English

- [MDN — Programming paradigm](https://developer.mozilla.org/en-US/docs/Glossary/Programming_paradigm) — A concise explanation of the term.
- [Python — Functional Programming HOWTO](https://docs.python.org/3/howto/functional.html) — Iterators, generators, and functional techniques.
- [The Rust Programming Language — Functional language features](https://doc.rust-lang.org/book/ch13-00-functional-features.html) — Closures and iterators in a multi-paradigm language.
- [Microsoft — Functional vs. imperative programming](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/linq/functional-programming-vs-imperative-programming) — Examples and a direct comparison.
- [SICP — Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/9780262510875/structure-and-interpretation-of-computer-programs/) — A deeper text on abstraction and computation.

### Persian

- [Object-Oriented Programming Handbook](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — Persian notes on object-oriented concepts.
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian course material on design and programming styles.

For the chapter bibliography, see the [course reference library](../../../../references.md#chapter-02).

</div>
