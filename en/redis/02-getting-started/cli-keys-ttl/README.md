<div dir="ltr" align="left">

# `redis-cli`, Commands, Keys, and TTL

> Level: beginner to intermediate · Time: 50–80 minutes
>
> Persian edition: [redis-cli، دستورها، کلیدها و TTL](../../../../fa/redis/02-getting-started/cli-keys-ttl/README.md)

## Learning objective

Run basic commands and design keys with useful namespaces and expiration.

## The lesson

`PING`, `SET`/`GET`, `DEL`, `EXISTS`, `TYPE`, `TTL`, `EXPIRE`, `SCAN`, and `INFO` are foundational tools. Use `SCAN` for incremental key traversal; `KEYS *` can block the server while scanning a large keyspace. A TTL of `-2` means the key is missing; `-1` means it exists without expiration. A name such as `shop:prod:product:42:summary` makes the namespace and record type visible.

TTL is part of freshness, not a replacement for invalidation. TTL jitter can spread expiry when many cache keys were created at once. In Cluster, a hash tag such as `cart:{42}:items` can put related keys in the same hash slot.

## Command and reply shape

In the CLI, each line is usually a command. Read the reply before sending the next command. Replies are typed: integer, status text such as `OK`, bulk value, or a multi-part collection.

```text
SET course:demo "hello"
OK
GET course:demo
"hello"
TYPE course:demo
string
EXISTS course:demo
(integer) 1
```

Redis keys are case-sensitive: `course:demo` and `Course:demo` are different keys. A key name is not arbitrary decoration; keep it understandable, stable for the application, and safe with respect to privacy.

## Key-naming pattern

A possible project convention is:

```text
<app>:<environment>:<entity>:<id>:<subresource>
shop:prod:product:42:summary
shop:prod:session:9cd8...
```

Colons are only a readability convention; Redis does not interpret them as real folders or namespaces. An application/environment prefix reduces collisions. Avoid putting sensitive values such as phone numbers or raw tokens in a key name; keys may appear in logs or monitoring tools. Agree on naming early because changing prefixes later can require migration or dual-read/dual-write behavior.

## Read TTL replies correctly

```text
SET course:ttl "short-lived"
TTL course:ttl
-1
EXPIRE course:ttl 120
(integer) 1
TTL course:ttl
(integer) 120
```

`-1` means the key exists but has no expiry. `-2` means it does not exist or has expired. A positive value is the approximate number of seconds remaining and may decrease between reads. Use `PTTL` for milliseconds and `EXPIREAT` for an absolute expiration time.

If a TTL must be set with a write, use `SET` with `EX` or `PX` in one command:

```text
SET cache:item:42 "value" EX 300
```

That removes the gap between `SET` and `EXPIRE`. Important: a successful `SET` on an existing key replaces its value and removes the old TTL unless you use `KEEPTTL` or set a new TTL in the same command. In contrast, operations such as `INCR`, `HSET`, and `LPUSH` usually preserve the key's TTL while changing the value inside its data type.

## Delete, persist, and inspect a type

```text
SET course:ttl "short-lived" EX 120
PERSIST course:ttl
(integer) 1
TTL course:ttl
(integer) -1
DEL course:ttl
(integer) 1
EXISTS course:ttl
(integer) 0
TTL course:ttl
(integer) -2
```

`PERSIST` removes an expiry and leaves the key without a timeout; `DEL` removes the key. A reply of `1` means a change was made; `0` usually means the key was absent or no change occurred. Avoid accidentally persisting a cache key so it never expires.

`TYPE` tells you which data-type commands to use:

```text
SET course:type "x"
TYPE course:type
string
HSET course:record name Sara
(integer) 1
TYPE course:record
hash
```

Redis usually does not convert a key from one type to another automatically; an incompatible command returns `WRONGTYPE`. Keys with similar prefixes are still separate keys; `TYPE` identifies the value type.

## Why `KEYS *` is risky and how `SCAN` works

`KEYS *` returns all key names at once and may occupy the server event loop for a long time on a large keyspace. Do not use it to discover data in a real application.

`SCAN` is cursor-based. Start with cursor zero, pass the returned cursor to the next call, and finish only when the cursor is zero again:

```text
SCAN 0 MATCH shop:prod:product:* COUNT 100
1) "12"
2) 1) "shop:prod:product:42:summary"
```

The `12` is only the next cursor in this example; the actual value on your server can differ. Continue:

```text
SCAN 12 MATCH shop:prod:product:* COUNT 100
```

`COUNT` is a work hint, not a promise of exactly 100 results. A page may be empty while the cursor is nonzero. Some keys may appear more than once, so actions on results should be duplicate-safe. `SCAN` does not create a fixed snapshot; while the keyspace changes, the whole scan is not necessarily a single point-in-time list. Do not design an application's normal query around a later `SCAN`.

## Logical databases, namespaces, and Cluster

Some standalone deployments allow `SELECT` to switch a logical database. These are spaces inside the same server and share memory/resources; they are not a security or tenant-isolation boundary. Redis Cluster does not support switching databases with `SELECT`, so distributed applications should use key prefixes and ACL users rather than DB numbers for tenant boundaries.

In Cluster, keys with the same hash tag, such as `cart:{42}:items` and `cart:{42}:total`, are assigned to the same slot. This can help with compatible multi-key operations, but unplanned co-location can make a shard hot.

## Guided practice and answers

1. Create a String key, inspect its type, set a TTL, and read the TTL again.
2. Replace the value with plain `SET` and inspect TTL. Why did it change?
3. Store one key without TTL and one with `EX`; compare `TTL` replies.
4. Create three keys with a lab prefix and traverse using `SCAN` until cursor zero.
5. Create a Hash and try `GET`; read the type error, then run `TYPE` and `HGETALL`.

**Answer:** Plain `SET` removes the previous TTL. `EXPIRE` or `SET EX` sets an expiry. An existing key without expiry returns `-1`; a missing key returns `-2`. Continue `SCAN` until cursor zero even if one call returns no keys. Read a Hash with `HGETALL`, not `GET`.

## Example and experiment

```text
SET cache:product:42 '{"id":42,"name":"keyboard"}' EX 300
TTL cache:product:42
SCAN 0 MATCH cache:* COUNT 100
DEL cache:product:42
TYPE cache:product:42
```

## Practical operating pattern

In real operations, inspect the endpoint, database, and namespace before scanning or deleting data. This is a general practice, not a company-specific case study.

## Common mistakes

- Running `KEYS` on a large database.
- Forgetting TTL.
- Running `FLUSHALL` against a real service.
- Using a key-pattern scan instead of an application's actual query model.

## Practice

1. Run the example in local Redis and explain each reply.
2. Write two failure modes or edge cases.
3. Estimate workload size, read/write rate, TTL/retention, and outage behavior.
4. Choose a metric such as p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. What do TTL replies `-1` and `-2` mean?

<details><summary>Answer</summary>

`-1` means the key exists without expiry; `-2` means it does not exist.

</details>

### 2. Why prefer SCAN to KEYS?

<details><summary>Answer</summary>

It traverses incrementally and avoids one long blocking lookup.

</details>

### 3. What does a hash tag do?

<details><summary>Answer</summary>

It places multiple keys in the same hash slot.

</details>

## Further reading

### English and official references

- [Redis CLI](https://redis.io/docs/latest/develop/tools/cli/)
- [`SCAN`](https://redis.io/docs/latest/commands/scan/)
- [`KEYS`](https://redis.io/docs/latest/commands/keys/)
- [`EXPIRE`](https://redis.io/docs/latest/commands/expire/)
- [`TTL`](https://redis.io/docs/latest/commands/ttl/)
- [Keyspace and expiry behavior](https://redis.io/docs/latest/develop/using-commands/keyspace/)

### Persian references

- [DNTips Persian overview of keys and commands (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [Introductory Redis article in Persian](https://virgool.io/@baloochmohammadreza/%D9%85%D8%B2%D8%A7%DB%8C%D8%A7-%D9%88-%D8%AF%D9%84%D8%A7%DB%8C%D9%84-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D9%BE%D8%A7%DB%8C%DA%AF%D8%A7%D9%87-%D8%AF%D8%A7%D8%AF%D9%87-redis-jmqtn9xmz3rh)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

The official command references document version-specific behavior. The lab and explanations above cover the fundamentals without requiring outside material.

</div>
