<div dir="ltr" align="left">

# Sorted Sets and Ranking

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [Sorted Set و رتبه‌بندی](./README.md)

## Learning objective

Design rankings, top-N queries, and schedules with scores.

## The lesson

A Sorted Set stores unique members ordered by numeric score. `ZADD` adds or updates, `ZRANGE` reads a range, `ZRANK` gets a position, `ZREM` removes, and `ZINCRBY` increments a score. Use reverse-range commands for the highest scores. Equal scores have a tie-break rule; verify that it matches the product.

Leaderboards and scheduled work are common examples, but TTL applies to the key, not an individual member. Design range deletion or cleanup. For newer syntax, check the documentation for the version installed.

## From score to rank

A Sorted Set holds two concepts: a unique member and a numeric score. Redis orders members by score. Adding an existing member again does not create a second member; its score is updated.

```text
ZADD game:season:9 1200 user:42 1850 user:17 1430 user:99
(integer) 3
ZCARD game:season:9
(integer) 3
ZREVRANGE game:season:9 0 2 WITHSCORES
1) "user:17"
2) "1850"
3) "user:99"
4) "1430"
5) "user:42"
6) "1200"
ZREVRANK game:season:9 user:17
(integer) 0
```

`ZREVRANGE` indexes start at zero; 0 to 2 returns three top members. `WITHSCORES` includes scores. `ZREVRANK` gives the top member rank zero; `ZRANK` starts from the lowest score. Define whether the product UI displays rank starting at 1 before showing it to users.

## Change scores, filter, and handle ties

```text
ZINCRBY game:season:9 25 user:42
"1225"
ZRANGEBYSCORE game:season:9 1200 1500 WITHSCORES
1) "user:42"
2) "1225"
3) "user:99"
4) "1430"
ZCOUNT game:season:9 1200 1500
(integer) 2
```

`ZINCRBY` atomically updates the score and returns the new score. `ZRANGEBYSCORE` reads a score range; newer versions also support `ZRANGE ... BYSCORE`. Boundaries are normally inclusive; use the supported exclusive-bound syntax if needed. Use `LIMIT` for large ranges, but offset pagination can shift or duplicate entries while scores change concurrently.

If two members share a score, Redis orders them lexicographically by member. If the product requires a different tie-break, such as arrival time, encode it in the score/member or store it separately and document the rule. Do not assume equal scores produce an arbitrary order.

## Maintenance commands

- `ZSCORE` reads one member's score.
- `ZREM` removes a member.
- `ZCARD` returns the number of members in the key.
- `ZCOUNT` counts members within a score range.
- `ZPOPMIN`/`ZPOPMAX` remove and return the minimum/maximum score member.
- `ZADD NX` inserts only a new member; `XX` updates only an existing member.

Before using a pop in a queue-like design, consider whether deleting the job before processing can lose it. A Sorted Set sorts by score; it does not provide acknowledgements or automatic retries.

## Three usage models

1. **Leaderboard:** member=user ID, score=points; define season reset and tie policy.
2. **Scheduled work:** member=job ID, score=execution epoch; a worker queries due jobs by score.
3. **Priority queue:** score=priority; dequeue with `ZPOPMIN` or `ZPOPMAX` according to the chosen contract.

In all three, TTL applies to the whole key. If every job expires at a different time, a worker can remove old score ranges or you can choose another model. Timestamp scores also require a consistent unit; do not mix seconds and milliseconds.

## Guided practice with answers

1. Add three players with different scores and read the top two with scores.
2. Change a player's score with `ZINCRBY` and inspect rank again.
3. Add two players with the same score and observe the tie order.
4. Decide whether a Sorted Set alone is sufficient for a retryable/acknowledged work queue.

**Answer:** `ZREVRANK` gives rank zero to the highest score. Changing a score can change rank. Ties are broken lexicographically by member. A reliable queue needs pending/ack/retry handling; Streams or a durable broker may be more suitable.

## Example and experiment

```text
ZADD game:season:9 1200 user:42 1850 user:17 1430 user:99
ZREVRANGE game:season:9 0 9 WITHSCORES
ZREVRANK game:season:9 user:17
ZINCRBY game:season:9 25 user:42
```

## Practical pattern

A game leaderboard is a common pattern, but pagination may shift during concurrent score updates. Measure member count and top-N workload before choosing the design.

## Common mistakes

- Expecting a TTL for each member.
- Leaving the equal-score tie-break undefined.

## Practice

1. Run the example in local Redis and explain the replies.
2. Write two failure modes or edge cases.
3. Estimate workload size, read/write rate, TTL/retention, and outage behavior.
4. Select a metric such as p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. Are members unique in a Sorted Set?

<details><summary>Answer</summary>

Yes. A member is unique; `ZADD` updates its score.

</details>

### 2. Which type is a starting point for top scores?

<details><summary>Answer</summary>

A Sorted Set.

</details>

### 3. Does each member have an independent TTL?

<details><summary>Answer</summary>

No. Expiration is at the key level.

</details>

## Published real-time ranking example

Redis and Databricks published a real-time personalization design where a continuously refreshed ranking is served from a Sorted Set, while a Hash provides the product metadata. The article reports a specific test setup and throughput result; it is vendor-published and those numbers are not a general benchmark or a promise for another workload. It is a concrete example of separating the rank index from the display record. [Databricks and Redis personalization article](https://redis.io/blog/delivering-real-time-personalization-with-databricks-and-redis/) · [Redis leaderboard guide](https://redis.io/docs/latest/develop/use-cases/leaderboard/)

## Further reading

### English and official references

- [Redis Sorted Sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/)
- [`ZADD`](https://redis.io/docs/latest/commands/zadd/)
- [`ZRANGE`](https://redis.io/docs/latest/commands/zrange/)
- [`ZINCRBY`](https://redis.io/docs/latest/commands/zincrby/)
- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis leaderboard use case](https://redis.io/docs/latest/develop/use-cases/leaderboard/)

### Persian references

- [DNTips Redis data-structure overview (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [Persian video search for Sorted Sets and leaderboards](https://www.youtube.com/results?search_query=آموزش+فارسی+Redis+Sorted+Set+leaderboard)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

</div>
