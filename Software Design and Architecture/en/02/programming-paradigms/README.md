<div dir="ltr" align="left">

# Chapter 02: Programming Paradigms

> **Language:** [Persian edition](../../../02/programming-paradigms/README.md)

> [Read the full chapter lesson](lessons.md) for detailed explanations, examples, practice, and an answered quiz.

## Learning goals

By the end of this chapter, you should be able to:

- Explain how a paradigm organizes computation, state, and control flow.
- Compare procedural, object-oriented, functional, and declarative approaches.
- Separate calculations from I/O where it improves testing or reasoning.
- Combine styles deliberately and explain the resulting trade-offs.

## Chapter map

- [Programming Paradigms](topics/programming-paradigms/README.md) — How to choose and combine styles for workflows, state, transformations, and queries.

## Central idea

Programming languages often support multiple paradigms. Choose the expression that best fits the problem: a procedure can make a short workflow obvious; an object can protect lifecycle rules; a pure function can make a calculation predictable; and a declarative query can state which data is needed.

No paradigm removes the need to understand effects, performance, or data. A pure function still needs explicit inputs. A SQL query still needs a suitable plan and transaction. An object still needs a clear contract and useful invariant.

## One order workflow, several styles

Suppose checkout validates an order, calculates the total, charges a payment method, and saves the result.

| Responsibility | Possible expression | What to consider |
| --- | --- | --- |
| Coordinate validation, payment, and persistence | Imperative application use case | Make the sequence and failure handling explicit. |
| Protect order status transitions | Object or domain model | Keep callers from bypassing valid transitions. |
| Calculate item totals and discounts | Pure functions | Pass rates, time, and other inputs explicitly. |
| Retrieve paid orders for a report | Declarative SQL query | Review query plans, transaction semantics, and data volume. |

These choices can coexist. The goal is to keep each rule and effect easy to locate, test, and change.

```python
def line_total(price_cents: int, quantity: int) -> int:
    if price_cents < 0 or quantity < 1:
        raise ValueError("Invalid line item")
    return price_cents * quantity

subtotal = sum(line_total(item.price_cents, item.quantity) for item in items)
total = apply_discount(subtotal, discount_policy)
```

The calculation is isolated from payment and persistence. The surrounding use case still coordinates those effects and must handle provider failures and transaction boundaries.

## Decision checklist

Before introducing an abstraction, ask:

1. Is the problem primarily a transformation, lifecycle, workflow, query, or set of rules?
2. Which state is mutable and which invariants must remain true?
3. Which effects are involved: network, clock, database, files, messages, or randomness?
4. Which parts change independently, and which usually change together?
5. Can the team read, test, and maintain the design?

Use the simplest approach that makes the important rules explicit. Add a boundary when it limits a real change or risk; do not add a class, interface, or pipeline solely to match a paradigm label.

## Common mistakes

- Turning every record into a class with behavior it does not need.
- Treating functional programming as if applications have no side effects.
- Hiding time, rates, or global state inside a supposedly pure calculation.
- Assuming that declarative code removes the need to understand execution and performance.
- Using one paradigm everywhere even when different tasks benefit from different forms.
- Adding abstractions before the need for variation is known.

## Practice with answer

Design a small invoicing feature. It validates a draft, calculates line amounts and tax, stores the invoice, and returns issued invoices in a report. Decide how to express the workflow, invariants, calculations, and report query.

**Suggested answer:** Use a procedure or application use case to coordinate authorization, issuing the invoice, and committing the change. Let an invoice object protect a meaningful state transition such as `Draft → Issued`. Put amount and tax rules in functions with explicit prices, quantities, currency, and tax policy. Use a query to select issued invoices. If the rules are few and stable, a transaction script may be enough; move behavior into a richer model when it protects real invariants.

## Answered quiz

1. **What is a programming paradigm?**
   **Answer:** A way to organize state, behavior, control flow, and computation; it is not the name of a language.

2. **How does imperative programming differ from declarative programming?**
   **Answer:** Imperative code describes actions and state changes; declarative code describes the result or relationships wanted and delegates more of the execution strategy.

3. **When is object-oriented modeling useful?**
   **Answer:** When state and related operations must preserve lifecycle rules or invariants across multiple callers.

4. **What makes a function pure?**
   **Answer:** Its result depends only on explicit inputs, and it does not change state outside the function.

5. **Does functional programming remove I/O?**
   **Answer:** No. It makes effects explicit and can keep central calculations easier to test.

6. **Why can a program mix paradigms?**
   **Answer:** A calculation, query, state transition, and workflow are different tasks and may be clearer with different tools.

## Further reading

### English

- [MDN — Programming paradigm](https://developer.mozilla.org/en-US/docs/Glossary/Programming_paradigm) — A concise introduction to the term.
- [Python — Functional Programming HOWTO](https://docs.python.org/3/howto/functional.html) — Iterators, generators, and functional techniques.
- [The Rust Programming Language — Functional language features](https://doc.rust-lang.org/book/ch13-00-functional-features.html) — Closures and iterators in a multi-paradigm language.
- [Microsoft — Functional vs. imperative programming](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/linq/functional-programming-vs-imperative-programming) — Examples and a direct comparison.
- [SICP — Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/9780262510875/structure-and-interpretation-of-computer-programs/) — A deeper text on abstraction and computation.

### Persian

- [Object-Oriented Programming Handbook](https://programmershouse.ir/Syllabus/Files/OOP.pdf) — Persian notes on object-oriented concepts.
- [Intelligent Software Engineering Lab — Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian course material on programming and design styles.

For the full bibliography grouped by chapter, see the [course reference library](../../references.md#chapter-02).

</div>
