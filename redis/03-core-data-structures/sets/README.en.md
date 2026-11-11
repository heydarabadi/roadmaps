<div dir="ltr" align="left">

# Sets and Membership Operations

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [Set و عملیات عضویت](./README.md)

## Learning objective

Use Sets for unique members and set operations.

## The lesson

A Set is an unordered collection of unique members. `SADD` adds, `SREM` removes, `SISMEMBER` checks membership, and `SCARD` counts members. `SINTER`, `SUNION`, and `SDIFF` compute intersection, union, and difference. For a large set, use `SSCAN` to iterate; `SMEMBERS` can create an enormous reply.

Sets fit tags, groups, followers, and membership. Use a Sorted Set when score ordering matters. In Cluster, multi-key operations may require keys to share a hash slot.

## What does a Set model?

A Set is an unordered collection of unique members. Adding the same member once or many times leaves one member. This is useful for “Is this user in the campaign?”, “Does this article have this tag?”, or “Has this user liked this product?” If every repetition must be recorded as a separate event, a Set is the wrong model.

```text
SADD campaign:summer members:user:42 members:user:17 members:user:42
(integer) 2
SISMEMBER campaign:summer members:user:42
(integer) 1
SCARD campaign:summer
(integer) 2
SREM campaign:summer members:user:17
(integer) 1
```

`SADD` returns the number of newly added members, not the total size. `SISMEMBER` returns 1 or 0; `SCARD` returns the set size. These behaviors can make operations idempotent: adding a member repeatedly does not duplicate it.

## Set operations

Combine groups with set operations:

```text
SADD user:42:following user:17 user:99
SADD user:99:following user:17 user:55
SINTER user:42:following user:99:following
1) "user:17"
SUNION user:42:following user:99:following
1) "user:17"
2) "user:99"
3) "user:55"
SDIFF user:42:following user:99:following
1) "user:99"
```

`SINTER` returns the intersection, `SUNION` the union, and `SDIFF` members of the first set absent from the later sets. Do not rely on reply ordering. For large sets, measure combination cost and output size; a huge result can pressure memory and the network. Review the set `STORE` commands when you need to save the result.

## Iteration and type selection

`SMEMBERS` is useful for inspecting a small Set in a lab. For a large Set, continue `SSCAN` with its cursor until zero. Like `SCAN`, `COUNT` is a hint and duplicates may appear. Do not build a routine application query around scanning; use `SISMEMBER` for membership and model bounded listings appropriately.

Compare a Set with:

- **List:** preserves order and duplicates; a Set does neither.
- **Sorted Set:** members are unique but also have scores and ranks.
- **Hash:** stores field/value pairs; a Set stores membership only.

For `likes:product:42`, storing user IDs as members may work. If you must know when each like occurred, a Set alone is insufficient; evaluate a Sorted Set with timestamps or an event log. For richer relationship queries, compare Redis with the primary database.

## Data and Cluster pitfalls

A Set does not preserve insertion order. Do not display `SMEMBERS` output as though it had a stable UI order. In Cluster, multi-key commands such as `SINTER` need keys in compatible slots; hash tags can co-locate keys but may create a hot shard. Duplicate members are handled by the Set, but related keys still need a naming contract.

## Guided practice with answers

1. Add three users to a campaign Set; add one twice and explain the `SADD` reply.
2. Create two following Sets and compute their intersection and union.
3. Remove a member and check `SISMEMBER` again.
4. Iterate with `SSCAN` until cursor zero. Why should you not sort the reply, and why might duplicates need handling?

**Answer:** repeated insertion does not increase the number of newly added members. `SISMEMBER` returns 0 for a removed member. A Set has no order. `SSCAN` is incremental, so continue to cursor zero and tolerate duplicate results.

## Example and experiment

```text
SADD article:42:tags redis database tutorial
SISMEMBER article:42:tags redis
SCARD article:42:tags
SINTER user:42:following user:99:following
SSCAN article:42:tags 0 COUNT 100
```

## Practical pattern

Finding shared followers or a union of tags are common patterns. Keep the result size controlled. This section is a general design pattern, not a named-company case.

## Common mistakes

- Expecting a stable order.
- Calling `SMEMBERS` without bounds on a large set.
- Running a multi-key operation without considering Cluster slots.

## Practice

1. Run the example locally and explain the output.
2. Write two failure modes or edge cases.
3. Estimate workload size, read/write rate, TTL/retention, and outage behavior.
4. Choose a metric such as p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. Does a Set preserve insertion order?

<details><summary>Answer</summary>

No; there is no guaranteed order.

</details>

### 2. Which command checks membership?

<details><summary>Answer</summary>

`SISMEMBER`.

</details>

### 3. Which command incrementally scans a Set?

<details><summary>Answer</summary>

`SSCAN`, continuing the cursor until it reaches zero.

</details>

## Published multi-session pattern

Redis’s session-store reference uses a Set of session IDs for each user, enabling a multi-device session list and explicit logout-all flow with membership operations. This is an applied Redis design published in the official documentation, not a claim that a particular customer uses this exact schema. The key lesson is that a Set answers membership and uniqueness questions; session expiry and cleanup still need to stay consistent with the session keys. [Redis session-store pattern](https://redis.io/docs/latest/develop/use-cases/session-store/)

## Further reading

### English and official references

- [Redis Sets](https://redis.io/docs/latest/develop/data-types/sets/)
- [`SSCAN`](https://redis.io/docs/latest/commands/sscan/)
- [`SINTER`](https://redis.io/docs/latest/commands/sinter/)
- [Compare Redis data types](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)

### Persian references

- [DNTips overview of Redis data structures (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

</div>
