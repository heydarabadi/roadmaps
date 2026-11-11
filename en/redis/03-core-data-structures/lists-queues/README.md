<div dir="ltr" align="left">

# Lists and Simple Queues

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [List و صف ساده](../../../../fa/redis/03-core-data-structures/lists-queues/README.md)

## Learning objective

Evaluate Redis Lists for sequences and simple queues, and identify when a List is not enough.

## The lesson

A List is an ordered sequence of strings. `LPUSH`/`RPUSH` insert at opposite ends; `LPOP`/`RPOP` remove from an end; `LRANGE` and `LLEN` inspect it. A simple producer can `RPUSH` and a consumer can `LPOP`. Blocking commands can wait when there is no work.

A List does not by itself provide consumer groups, pending-message recovery, and event replay. If acknowledgements, retries, and multiple consumers matter, evaluate Streams or a dedicated broker. Design atomic transfer, retry, and idempotency too.

## Understand order from the producer and consumer sides

`LPUSH` adds at the head and `RPUSH` adds at the tail. `LPOP` and `RPOP` remove from an end. Two common FIFO combinations are:

- Producer uses `RPUSH` at the tail; consumer uses `LPOP` from the head.
- Producer uses `LPUSH` at the head; consumer uses `RPOP` from the tail.

Do not mix ends accidentally: `RPUSH` with `RPOP` produces LIFO behavior.

```text
RPUSH jobs:ready job:1001 job:1002 job:1003
LRANGE jobs:ready 0 -1
1) "job:1001"
2) "job:1002"
3) "job:1003"
LPOP jobs:ready
"job:1001"
LLEN jobs:ready
(integer) 2
```

`LRANGE` starts at index zero; `-1` means the end. `LRANGE 0 -1` on a huge List creates a large reply. It is useful for a small lab or diagnosis, not a permanent endpoint.

## Blocking and avoiding the lost-message window

When the queue is empty, `BLPOP`/`BRPOP` can wait for a specified time instead of polling repeatedly. But ordinary `LPOP` deletes the task; if a worker crashes just after removing it, the task is no longer in the ready queue.

On Redis 6.2+, `BLMOVE` can atomically move a job from a ready List to a processing List:

```text
RPUSH jobs:ready job:1001
BLMOVE jobs:ready jobs:processing RIGHT LEFT 0
"job:1001"
LRANGE jobs:processing 0 -1
1) "job:1001"
LREM jobs:processing 1 job:1001
(integer) 1
```

Here, a producer uses `RPUSH`; a worker removes the oldest task from the right and moves it to the beginning of `jobs:processing`. A timeout of zero means wait indefinitely. After successful work, the worker removes that ID from `processing`. If a worker dies after the move, the task stays in `processing` and is no longer ready; a sweeper must use a lease or last-activity time to find abandoned tasks and put them back. A List does not store task arrival time or owner, so a production pattern needs separate metadata or Streams.

For same-named tasks, `LREM` could remove the wrong item; use unique IDs. A blocking command occupies a client connection, so configure the worker's connection pool accordingly.

## What a List does not guarantee

- No consumer group, pending list, or `XACK`-like model from Streams.
- No ready-made automatic retry or dead-letter queue.
- No built-in task creation time or processing owner.
- Duplicate requests may create duplicate jobs; handlers still need idempotency.

A List can fit a small, simple queue inside an application. For an event log, multiple consumer groups, replay, pending recovery, and operational message state, read the Streams lesson. Compare a message broker when you need longer retention, partitioning, or a broad connector ecosystem.

## Guided practice with answers

1. Add five tasks with `RPUSH`, take them with `LPOP`, and record the order.
2. Empty a List, run `BLPOP` with a short timeout, and add a task from another connection.
3. Run `BLMOVE` and imagine the worker crashes immediately; show that the job remains in processing.
4. Recover that job and explain why the handler should be idempotent.

**Answer:** `RPUSH` + `LPOP` is FIFO. `BLPOP` returns empty after timeout or delivers a task if one arrives. `BLMOVE` atomically transfers a task from ready to processing and removes the crash window between pop and push, but it does not recover the processing List or prevent duplicate execution by itself.

## Example and experiment

```text
LPUSH jobs:ready "email:101"
LPUSH jobs:ready "email:102"
LLEN jobs:ready
RPOP jobs:ready
LRANGE jobs:ready 0 -1
```

Predict which item `RPOP` returns, then compare the actual reply.

## Practical pattern

A List can begin as a queue for lightweight jobs. Processing where message loss is unacceptable needs acknowledgements, retries, and recovery. This is a general design pattern, not a named-company story.

## Common mistakes

A worker can lose a task if it pops and crashes before processing. A retry without idempotency can perform the same side effect twice.

## Practice

1. Run the example locally and explain each reply.
2. Write two failure modes or edge cases.
3. Estimate workload size, read/write rate, TTL/retention, and outage behavior.
4. Choose a metric such as p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. What does `LPUSH` do?

<details><summary>Answer</summary>

Adds a member to the head of a List.

</details>

### 2. When is a List insufficient?

<details><summary>Answer</summary>

When pending recovery, acknowledgement, replay, or consumer groups are required.

</details>

### 3. Why is idempotency important?

<details><summary>Answer</summary>

A retry may run a job more than once.

</details>

## Published queue design pattern

Redis’s current job-queue guide uses a pending List and a processing List, with an atomic move so a worker crash does not immediately lose the claimed job. It also describes metadata hashes and delayed work. This is Redis’s reference implementation pattern, not a named customer incident. For independent consumer progress, acknowledgements, replay, and pending recovery, compare it with the Streams project later in this course. [Redis job-queue guide](https://redis.io/docs/latest/develop/use-cases/job-queue/)

## Further reading

### English and official references

- [Redis Lists](https://redis.io/docs/latest/develop/data-types/lists/)
- [`BLMOVE`](https://redis.io/docs/latest/commands/blmove/)
- [`BLPOP`](https://redis.io/docs/latest/commands/blpop/)
- [Redis Streams](https://redis.io/docs/latest/develop/data-types/streams/)
- [Redis queue patterns](https://redis.io/docs/latest/develop/use/patterns/)

### Persian references

- [DNTips Redis data-structure overview (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [Persian Redis List/queue video search](https://www.youtube.com/results?search_query=آموزش+فارسی+Redis+List+Queue)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

</div>
