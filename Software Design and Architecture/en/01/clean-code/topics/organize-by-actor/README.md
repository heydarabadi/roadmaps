<div dir="ltr" align="left">

# Organize Code Around Ownership and Change

> **Language:** [Read the Persian edition](../../../../../01/clean-code/topics/organize-by-actor/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Explain how grouping code around a stakeholder, business capability, or coherent owner can localize change; identify when technical-layer folders scatter one feature across many places; and use change history and domain ownership as evidence for a boundary.

## The idea

In the Single Responsibility Principle, an **actor** is a group of people or stakeholders who request a particular kind of change. In practice, teams often use a related business capability—such as billing, shipping, or customer support—as a stable way to group its rules, data, tests, and use cases. The two ideas are related, but they are not always identical.

If every feature is divided only into folders such as `Controllers`, `Services`, and `Helpers`, one change may require edits across all three. Grouping by capability can make ownership and the likely change surface easier to discover. A folder name alone does not enforce a boundary: dependencies, data access, and public contracts still need rules.

## Example: order and shipping capabilities

An order capability might own order state, cancellation policy, and the use cases that place or cancel an order. A shipping capability might own carrier selection and delivery estimates. The order module may request a shipping quote through a contract without depending on every implementation detail of a carrier SDK.

```text
orders/
  domain/       # order rules and invariants
  application/  # place, pay, and cancel use cases
  api/          # public order contract
  tests/        # order behavior

shipping/
  domain/       # delivery rules
  application/  # quote and dispatch use cases
  api/          # shipping contract
  tests/        # shipping behavior
```

This is an example organization, not a required folder template. A small, stable application may not need this separation. Two capabilities may also share a rule or data owner, so use domain language and change history rather than making a module for every role.

## How to look for evidence

1. Review recent requirements or commits and identify which rules changed together.
2. Ask who requests each type of change and who owns the rule and its data.
3. Look for scattered edits, repeated policies, or callers that depend on internal details.
4. Propose a boundary only when it gives a coherent owner, contract, and test surface.
5. Recheck the result after future changes; the organization should follow actual ownership, not preserve outdated assumptions.

## Practice

Choose ten recent changes from a project. Group them by stakeholder request or business capability. Identify one repeated change that crosses technical folders and propose a focused boundary. State which files and contracts would move, what should remain shared, and what evidence would show that the change helped.

## Quiz with answers

1. **What does “actor” mean in this design principle?**
   **Answer:** A group of stakeholders that requests a related kind of change. A business capability can be a useful grouping when it matches the code’s ownership and change pattern.

2. **What evidence would support a new capability boundary?**
   **Answer:** A coherent owner for rules and data, a repeated change pattern, a meaningful contract, and tests that can check the behavior at that boundary.

3. **Why can folders organized only by technical layer be costly?**
   **Answer:** One business change may be spread across several folders, making the change harder to locate, review, and test.

4. **Does every stakeholder or user role need its own module?**
   **Answer:** No. Roles may share rules and data ownership; a module is useful when its responsibility and change boundary are coherent.

## Further reading

- [Martin Fowler: Code Ownership](https://martinfowler.com/bliki/CodeOwnership.html) — How module ownership and team practices can shape who changes code.
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
