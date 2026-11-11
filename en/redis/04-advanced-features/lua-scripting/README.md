<div dir="ltr" align="left">

# Lua Scripting and Redis Functions

> Persian edition: [Read this lesson in Persian](../../../../fa/redis/04-advanced-features/lua-scripting/README.md)

> Path: Chapter 4 · Level: intermediate · Lesson and exercises: 75–120 minutes
>
> Run scripts only against a disposable Redis instance. A long script can delay commands from every client.

## Learning objectives

- Explain the difference between network round trips, pipelining, and server-side script execution.
- Write a short script using `KEYS`, `ARGV`, `redis.call`, and `redis.pcall`.
- Run an atomic check-and-update example and explain both outcomes.
- Account for runtime limits, script SHA caching, error handling, Cluster slots, and version-specific features.
- Distinguish `EVAL`/`EVALSHA` scripts from Redis Functions.

## The central idea

When a client reads a value and then writes based on that value, another client can change the data between the two round trips. Lua runs several commands on the Redis server without interleaving commands from another client. This is useful for short conditional logic; moving heavy work to the server slows everyone else down.

| Tool | What it solves | What it does not guarantee by itself |
| --- | --- | --- |
| Atomic command such as `INCR` | One simple server-side operation | A combined condition and several writes |
| Pipeline | Fewer network round trips | Atomicity; other clients may act between commands in the batch |
| `MULTI/EXEC` | Run a queued sequence without interleaving | General rollback or convenient conditions based on a previous read |
| Lua/Function | Run a condition and several commands as one server-side execution | A transaction with an external database, freedom from errors, or exactly-once effects |

## 1. Parameters and running a script

General form:

```text
EVAL <script> <number-of-keys> <key-1> ... <arg-1> ...
```

Pass the `KEYS` list explicitly so Redis and Cluster know which keys the script accesses. Read non-key inputs such as a quantity from `ARGV`. Do not build hidden key names inside Lua: explicit parameters support Cluster routing and code review.

### Example: decrement stock only when enough is available

On a disposable instance:

```text
SET lab:stock:sku-7 3
EVAL "local n = tonumber(redis.call('GET', KEYS[1]) or '0'); local q = tonumber(ARGV[1]); if not q or q <= 0 then return redis.error_reply('quantity must be positive') end; if n < q then return 0 end; redis.call('DECRBY', KEYS[1], q); return 1" 1 lab:stock:sku-7 2
(integer) 1
GET lab:stock:sku-7
"1"
```

First, `GET` reads the value and `tonumber` converts it for Lua comparison. A missing value is treated as zero. The script then validates the requested quantity. If stock is insufficient, it returns `0` without decrementing; otherwise it runs `DECRBY` and returns `1`.

Run it again with quantity `2`: it returns `0` and stock remains `1`. This teaches an atomic check-and-decrement, but it is not a production purchase flow. Production needs request idempotency, reservation and cancellation, payment consistency, a policy for malformed values, and a persistence/failover design.

## 2. `redis.call`, `redis.pcall`, and errors

`redis.call` raises a Redis command error as a script error. `redis.pcall` returns the error as a value the script can inspect; use it only when you have a defined recovery path. Ignoring an error can silently break an invariant.

A script does not interleave with another script or client command while it runs. That does not mean writes made before a runtime error are automatically rolled back. Validate inputs before writing, check commands that may fail, and design multi-step logic to minimize unintended intermediate state.

## 3. `EVALSHA` and the script cache

`EVAL` sends the script text and Redis calculates its digest. `SCRIPT LOAD` places a script in the server cache, and `EVALSHA` refers to it by digest, reducing repeated source transmission. The script cache is not durable application data. A client must handle `NOSCRIPT` and, when required, send the source again with `EVAL` or reload it with `SCRIPT LOAD`, especially after restart, failover, or a node change.

A typical client flow is:

1. Execute the known script by SHA.
2. If Redis returns `NOSCRIPT`, load or send the known script source.
3. Version the script in the application and make deployment rollback possible.

Do not generate a subtly different script body for every request. Parameterize values through `KEYS` and `ARGV` so the cache remains bounded and code remains reviewable.

## 4. Redis Functions

Redis 7 introduced Redis Functions for loading server-side libraries. A Function has a name and its library is stored in the dataset, unlike `EVAL` scripts, which are invoked using their text or cached SHA. In multi-node deployments, library loading and synchronization must fit the topology and deployment tooling. Functions also run on the server, so keep them short, bounded, testable, and explicit about their keys.

For a small one-off operation or a compatible client, `EVAL` may be simpler. For shared, named logic shipped as a versioned artifact, evaluate Functions. Verify deployment and replication behavior against the Redis version and managed service you operate.

## 5. Cluster and keys

In Cluster, all keys accessed by one script must follow hash-slot constraints. A `{sku-7}` hash tag can place related stock/order keys in one slot, but broad tags can create a hotspot. Declare accessed keys in `KEYS` and detect slot mismatches before production traffic.

```text
inventory:{sku-7}
reservation:{sku-7}:order-501
```

## 6. Choosing, security, and performance

- Keep scripts short and limit the number of keys and members they touch.
- A loop whose length depends on untrusted data, `HGETALL` on a huge Hash, or scanning an entire collection can create a latency spike.
- Do not use scripts to bypass ACLs. Grant the least privilege for commands, keys, and functions.
- The client must handle timeouts, reconnects, `NOSCRIPT`, wrong types, wrong key counts, and application errors.
- Do not write a script merely in the hope that it will be faster. First identify whether the bottleneck is network latency, server CPU, a big key, persistence, eviction, or the client pool.

## Exercises with answer guide

1. Run the example with a request for 2 units from 3. Record the returned value and stock.
2. Run it with a quantity greater than available stock and verify that stock does not change.
3. Why is `KEYS[1]` preferable to constructing a key name inside Lua?
4. Explain pipeline versus script using `GET`, a condition, and `DECR`.
5. What must the client handle for `EVALSHA` after a restart?

<details><summary>Answer guide</summary>

1. The script returns `1`, and one unit remains.
2. It returns `0`; stock remains unchanged.
3. The key is explicit for review and Cluster routing, and script key access is declared.
4. A pipeline batches round trips but does not prevent interleaving. A script performs the read-condition-write sequence in one server-side execution.
5. Handle `NOSCRIPT` and load or re-send the known script with `SCRIPT LOAD` or `EVAL`.

</details>

## Troubleshooting and common pitfalls

- **The script is slow:** Inspect data size, loops, and large commands; split work into bounded jobs.
- **`NOSCRIPT`:** That node does not have the script in its cache; implement a reload fallback.
- **`CROSSSLOT`:** The keys in `KEYS` map to different slots; revisit the key model.
- **A nil value cannot be converted to a number:** The key is missing or malformed; define a default and validation policy.
- **Assuming every error rolls back:** Validate before mutation and analyze possible partial progress.
- **Concatenating client input into Lua source:** Pass parameters through `KEYS` and `ARGV`; never turn untrusted input into executable code.

## Quiz with answers

### 1. Why can a script be better than a pipeline for read-condition-write?

<details><summary>Answer</summary>

The logic runs in one server-side execution, so another client's command cannot interleave between the read and write.

</details>

### 2. Why should a script be short?

<details><summary>Answer</summary>

While it runs, it delays commands from other clients and adds shared latency.

</details>

### 3. What are `KEYS` and `ARGV` for?

<details><summary>Answer</summary>

`KEYS` contains Redis key names used by the script; `ARGV` contains other input values.

</details>

### 4. What should a client do when `EVALSHA` returns `NOSCRIPT`?

<details><summary>Answer</summary>

Reload the script or run the known source with `EVAL`.

</details>

### 5. Can Lua atomically commit to both Redis and PostgreSQL?

<details><summary>Answer</summary>

No. It only covers server-side Redis operations.

</details>

## Published application pattern and security lesson

Redis’s rate-limiter guide uses Lua to keep a token-bucket decision and update on the server, avoiding a client-side read/decide/write race. This is a published implementation pattern for quotas across application instances, not a claim that a named customer uses the example unchanged. Security is part of the design: Redis’s CVE-2025-49844 advisory described a critical Lua use-after-free that required authenticated access and was fixed in specified releases. Keep Redis patched, restrict network access, and grant script execution only to trusted identities that need it. [Redis rate-limiter guide](https://redis.io/docs/latest/develop/use-cases/rate-limiter/) · [CVE-2025-49844 advisory](https://redis.io/blog/security-advisory-cve-2025-49844/)

## References and further reading

### English: official documentation and engineering guides

- [Scripting with Lua](https://redis.io/docs/latest/develop/programmability/eval-intro/) — `EVAL`, atomic execution, parameters, cache behavior, and runtime constraints.
- [Redis Functions introduction](https://redis.io/docs/latest/develop/programmability/functions-intro/) — named, persisted server-side libraries available from Redis 7.
- [Redis programmability overview](https://redis.io/docs/latest/develop/programmability/) — compare scripts and Functions.
- [Redis Lua API reference](https://redis.io/docs/latest/develop/programmability/lua-api/) — supported API and command calls.
- [EVAL command reference](https://redis.io/docs/latest/commands/eval/), [SCRIPT LOAD](https://redis.io/docs/latest/commands/script-load/), and [EVALSHA](https://redis.io/docs/latest/commands/evalsha/) — command syntax and cache workflow.
- [Redis rate-limiter use case](https://redis.io/docs/latest/develop/use-cases/rate-limiter/) — a practical example of atomic state updates.
- [Redis rate-limiting tutorial](https://redis.io/tutorials/howtos/ratelimiting/) — compares scripting and other concurrency approaches.

### فارسی

- [ویدئوی فارسی Pipeline و Lua](https://www.youtube.com/watch?v=m5j4YUvuUmc)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Persian Lua references are more limited than the official documentation. This lesson covers the core use case and trade-offs. Check the differences between Functions and scripts against your version and managed service.

</div>

