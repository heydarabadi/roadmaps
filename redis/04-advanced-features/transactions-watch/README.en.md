<div dir="ltr" align="left">

# Transactions, WATCH, and Optimistic Concurrency

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 4, advanced features · Level: intermediate · Lesson and exercises: 75–120 minutes
>
> Run these commands only on test data. The inventory reservation example is not a production payment algorithm.

## Learning objectives

- Explain `MULTI`, `EXEC`, `DISCARD`, and `WATCH` step by step.
- Distinguish atomic execution from relational-database rollback.
- Design optimistic locking and bounded retries for a read-modify-write operation with concurrent writers.
- Decide when one atomic command or Lua is simpler than a transaction.
- Account for Redis Cluster's multi-key transaction constraints.

## Mental model

`MULTI` opens a command queue for the current connection. Commands are not executed until `EXEC`. At `EXEC`, Redis runs the queued commands sequentially without interleaving commands from other clients. `WATCH` marks keys before the queue is created. If a watched key changes before `EXEC`, Redis aborts the optimistic transaction so the application can read fresh values and decide again.

```text
WATCH key(s) -> GET/READ -> MULTI -> queue writes -> EXEC
       |                                  |
       +-- any watched key changes ------+--> EXEC returns nil / retry policy
```

This is not general SQL-style rollback. Redis confines a queue-time command error to that command; an execution error inside `EXEC` does not necessarily undo earlier or later commands in the queue. If an invariant needs “all or nothing” despite business errors, validate inputs and conditions before writing, and consider a short Lua script or Function for conditional logic.

## 1. A basic transaction

```text
SET lab:counter 0
MULTI
INCR lab:counter
INCR lab:counter
GET lab:counter
EXEC
```

After `MULTI`, replies for queued commands are usually `QUEUED`. `EXEC` returns three replies in order: two increments followed by the read. No other client can run between commands in that list, but there is no undo log that rolls them back.

Before `EXEC`, `DISCARD` drops the queue:

```text
MULTI
SET lab:flag ready
DISCARD
GET lab:flag
```

If `lab:flag` did not exist before, the last command returns nil. `DISCARD` is useful when the application chooses not to continue before committing.

## 2. Optimistic locking with WATCH

Suppose `inventory:{sku-7}` stores an integer, and multiple requests may compete for the last unit. `WATCH` protects the read-and-decide step. Try this on one `redis-cli` connection:

```text
SET inventory:{sku-7} 1
WATCH inventory:{sku-7}
GET inventory:{sku-7}
MULTI
DECR inventory:{sku-7}
EXEC
```

In isolation, `EXEC` changes the value to zero. Now create a conflict:

1. In Terminal A, run `SET inventory:{sku-7} 1`, then `WATCH inventory:{sku-7}` and `GET`.
2. Before Terminal A executes, change the value in Terminal B: `SET inventory:{sku-7} 0`.
3. In Terminal A, run `MULTI`, `DECR`, and `EXEC`.

On conflict, `EXEC` returns nil/null instead of the command reply array; `DECR` was not applied. The application must read again and return “out of stock” if the value is no longer sufficient. In this manual experiment, blindly retrying `DECR` would make the count negative. The business condition belongs inside each retry attempt.

### More resilient pseudocode

```text
for attempt from 1 through 5:
    WATCH inventory:{sku-7}
    stock = GET inventory:{sku-7}
    if stock <= 0:
        UNWATCH
        return "out of stock"
    MULTI
    DECR inventory:{sku-7}
    replies = EXEC
    if replies != null:
        return "reserved in this example"
    wait briefly with jitter
return "concurrency conflict; try again"
```

The watch remains active until `EXEC`, `DISCARD`, or `UNWATCH`. Do not return a pooled connection while it is still watching keys. `WATCH` suits optimistic concurrency; under heavy contention, retries can themselves add load. Bound retries, use backoff/jitter, and return a clear result.

## 3. Three meanings of atomicity

| Term | Meaning here |
| --- | --- |
| Atomic sequence execution | Commands between `MULTI` and `EXEC` do not interleave with another client's commands while executing. |
| Conflict detection | `WATCH` detects a changed key and prevents queued writes from running at `EXEC`. |
| Rollback | Automatically restore all writes to their prior state after an error; this is not a general Redis transaction guarantee. |

If a command fails at `EXEC` because of a wrong data type, inspect each command's reply independently; do not treat the result as relational-database rollback. Reduce errors by validating types, values, ACL permissions, slots, and conditions before queueing, and by using appropriate atomic commands.

## 4. Choose among a command, transaction, and Lua

- If one atomic command is enough (`INCR`, `SET ... NX`, `ZINCRBY`), prefer it.
- If several commands must run sequentially and do not depend on a prior read, `MULTI/EXEC` may be enough.
- If a write must be rejected when a value read earlier has changed, use `WATCH`.
- If a short condition and several updates must run as one server-side unit, evaluate a Lua script or Redis Function. A long script blocks other server activity.
- If Redis and an external system such as SQL must commit together, neither `MULTI/EXEC` nor Lua creates a distributed transaction. Consider application-level patterns such as an outbox, saga, or idempotent compensation.

## 5. Redis Cluster

In Cluster, multi-key transactions and scripts depend on the keys sharing a compatible hash slot. Choose hash tags deliberately for the keys in one reservation:

```text
inventory:{sku-7}
reservation:{sku-7}:order-501
```

These keys can share a slot, but putting too much data behind one hash tag can turn one shard into a hotspot. Check slot routing, client support, and Redis version before production. `{...}` affects sharding; do not treat it as decorative text.

## Practical example: reservation versus purchase

This example only decrements a Redis inventory counter. In a real system, decide whether Redis is the source of truth or a projection/cache of the primary database; how duplicate `order_id` requests are neutralized; how a reservation is released if payment fails; and what happens if a Redis failover loses the latest change. “Atomic on one Redis primary” does not answer those questions.

## Troubleshooting and common pitfalls

- **`EXEC` returns nil/null:** A watched key changed. Read it again and recalculate the business decision.
- **Inventory becomes negative:** The read/condition was outside the retry transaction, or retry bypassed the condition. Recheck the invariant every time.
- **A transaction errored but earlier data was not restored:** That expectation assumed rollback. Inspect each reply and design around predictable command errors.
- **Retries continue indefinitely:** There may be contention or a hot key. Set a retry limit, define a failure response, and revisit the data model.
- **Multi-key command fails with `CROSSSLOT`:** Check hash tags and slots; forcing all work into one slot can create a hotspot.
- **A pooled connection remains in WATCH mode:** Ensure the client runs `UNWATCH` or otherwise resets the connection before returning it to the pool.

## Exercises with answer guidance

1. Increment a counter twice with `MULTI/EXEC` and observe that the queued commands run only at `EXEC`.
2. Run the two-terminal race and record the nil response.
3. Design a hypothetical service with a 30% conflict rate: retry cap, backoff, metric, and API response?
4. Name inventory and reservation keys for Cluster, then inspect their hash slots with a suitable command.
5. Explain why Redis and PostgreSQL writes cannot become one atomic commit with `MULTI/EXEC`.

<details><summary>Answer guidance</summary>

In exercise 2, the second writer changes the watched key, so the first `EXEC` aborts and must not decrement. For exercise 3, the outcome should be bounded and observable—for example, a small retry count with jitter, a conflict counter, and a final conflict/retryable response. For exercise 5, a Redis transaction controls only Redis commands; PostgreSQL is not part of the Redis queue and there is no shared automatic two-phase commit.

</details>

## Quiz with answers

### 1. Does `MULTI` execute commands immediately?

<details><summary>Answer</summary>

No. It queues them for `EXEC`.

</details>

### 2. Does `EXEC` perform a general rollback if any command fails?

<details><summary>Answer</summary>

No. Inspect command replies independently; do not rely on global rollback.

</details>

### 3. What kind of control does `WATCH` provide?

<details><summary>Answer</summary>

Optimistic concurrency control. A watched-key change before `EXEC` aborts the transaction.

</details>

### 4. What should you do when `EXEC` returns nil?

<details><summary>Answer</summary>

Read current values, reevaluate the business condition, and retry within a defined limit.

</details>

### 5. Can one `MULTI` commit to two databases?

<details><summary>Answer</summary>

No. It manages commands for that Redis deployment only.

</details>

### 6. How many transactional round trips does a simple increment need?

<details><summary>Answer</summary>

None beyond the atomic `INCR` command itself.

</details>

## Published inventory-reservation example

Redis’s inventory-reservation tutorial demonstrates a checkout flow using WATCH/MULTI to hold stock, confirm or release a reservation, and append audit events to a Stream. It is a reproducible vendor tutorial, not independent evidence that Redis alone should own a financial inventory ledger. Use it to study optimistic conflict handling; decide separately which system is authoritative and how the application reconciles after failure. [Redis inventory-reservation tutorial](https://redis.io/tutorials/inventory-reservation-in-real-time-with-redis/)

## References and further reading

### English: official documentation and engineering patterns

- [Redis Transactions guide](https://redis.io/docs/latest/develop/interact/transactions/) — isolation, command queueing, and `WATCH` behavior.
- [MULTI command reference](https://redis.io/docs/latest/commands/multi/), [EXEC command reference](https://redis.io/docs/latest/commands/exec/), and [DISCARD command reference](https://redis.io/docs/latest/commands/discard/).
- [WATCH command reference](https://redis.io/docs/latest/commands/watch/) and [UNWATCH command reference](https://redis.io/docs/latest/commands/unwatch/).
- [Redis Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/) — hash slots and multi-key constraints.
- [Redis rate-limiter guide](https://redis.io/docs/latest/develop/use-cases/rate-limiter/) — a concrete atomic-update use case.
- [Redis rate-limiting tutorial](https://redis.io/tutorials/howtos/ratelimiting/) — discusses transaction and Lua approaches, contention, and trade-offs.
- [Martin Fowler: Patterns for Distributed Systems](https://martinfowler.com/articles/patterns-of-distributed-systems/) — background for outbox, sagas, and coordination boundaries.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [ویدئوی فارسی دربارهٔ هم‌زمانی در Redis](https://www.youtube.com/watch?v=e5Q_RUwviaE)
- [ویدئوی فارسی Transaction و Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc)

Detailed Persian material about rollback boundaries and `WATCH` is limited. This lesson is self-contained for the core model and experiment. Verify command and Cluster behavior against the Redis version you run.

</div>

