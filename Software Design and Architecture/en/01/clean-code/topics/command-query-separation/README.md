<div dir="ltr" align="left">

# Command-Query Separation (CQS)

> **Language:** [Read the Persian edition](../../../../../01/clean-code/topics/command-query-separation/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Explain the difference between a command and a query, identify operations that have surprising side effects, and distinguish the local method-level principle CQS from the larger architectural pattern CQRS.

## The principle

Command-Query Separation says that an operation should either change state or return information, so a caller can predict its effect from the name and contract. A **command** requests a state change. A **query** returns information without changing domain state.

This separation makes call sites easier to read and tests easier to write. Queries can often be retried or cached when their dependencies and freshness rules allow it. A command may need duplicate protection when it is delivered over a network or queue that can retry; idempotency should be designed for that delivery contract, not assumed for every local method.

## CQS and CQRS are different in scope

CQS is usually applied to a method, object, or API contract. It does not require separate services or databases. CQRS separates the models used to handle commands and queries when the read and write responsibilities genuinely need different shapes or scaling. CQRS can add projections, synchronization, eventual consistency, and operational work.

Consider `get_or_create_user()`. The name sounds like a read, but it may create state. Prefer explicit operations such as `find_user()` and `register_user()`. If the application must guarantee “find or create” as one atomic operation, name and document it as a command with that behavior.

## Example

```python
def get_balance(account_id):
    """Query: return the current balance without changing domain state."""
    return repository.load(account_id).balance_cents

def withdraw(account_id, amount_cents):
    """Command: apply a withdrawal and persist the resulting state."""
    account = repository.load(account_id)
    account.withdraw(amount_cents)
    repository.save(account)
```

Logging or metrics may still occur around a query. CQS is concerned with the domain state and the behavior the caller relies on; it does not prohibit every technical side effect. Make meaningful freshness, authorization, and audit behavior explicit in the contract.

## Practice

List the read and write operations in an API. Find any method that both changes state and returns data, or whose name hides a mutation. Rename or split it when that makes the contract clearer. Decide separately whether the read and write models differ enough to justify CQRS.

## Quiz with answers

1. **What does CQS separate?**
   **Answer:** Operations that change state from operations that return information without changing domain state.

2. **Does CQS require two databases?**
   **Answer:** No. It can be a method-level rule in one class, service, and database.

3. **What additional complexity may CQRS introduce?**
   **Answer:** Separate read and write models, projections, synchronization, eventual consistency, and their monitoring and repair processes.

4. **Is `get_or_create_user()` a query?**
   **Answer:** Not if it can create a user. It performs a state change and should be named and handled as a command.

5. **Does CQS forbid logs or metrics?**
   **Answer:** No. It makes the domain effect predictable; technical observation can still happen around an operation.

## Further reading

- [Martin Fowler: CQRS](https://martinfowler.com/bliki/CQRS.html) — Scope, motivation, and cautions about the larger pattern.
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
