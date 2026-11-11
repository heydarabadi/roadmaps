<div dir="ltr" align="left">

# HyperLogLog: Approximate Distinct Counting

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 4 · Level: beginner to intermediate · Time: 45–70 minutes
>
> HyperLogLog is for approximate analytics. Do not use it for money, billing, authorization, quotas, or legally binding counts.

## Learning objectives

- Define cardinality and distinguish exact counting from estimation.
- Use `PFADD`, `PFCOUNT`, and `PFMERGE`.
- Explain why an HLL does not retain an enumerable member list and cannot remove one specific member.
- Record the error budget, bucket boundaries, timezone, and retention policy in a design.

## The central idea

If the question is “roughly how many distinct users or values did we see?”, storing every identifier in a Set may cost too much. A HyperLogLog (HLL) keeps a compact probabilistic sketch and estimates the number of distinct values, called the **cardinality**. Because it is a sketch rather than a member collection, you cannot list its members or remove one member precisely.

```text
Input: user-1, user-2, user-1, user-3
Exact Set: retains the three actual members
HLL: retains a compact sketch and estimates the cardinality
```

This is a deliberate trade: accept a statistical error in exchange for bounded, small state. It is a poor fit whenever the application needs to answer “which users?” rather than “approximately how many?”.

## Commands and output

```text
DEL lab:visitors:today
PFADD lab:visitors:today user:1 user:2 user:1
(integer) 1
PFADD lab:visitors:today user:2 user:3
(integer) 1
PFCOUNT lab:visitors:today
(integer) 3
```

The return value of `PFADD` does **not** mean “the number of newly added members.” It is a flag indicating whether the internal HLL representation changed as a result of this command. A repeated input may produce `0`; that does not mean Redis consulted an exact member list, because no such list is available.

`PFCOUNT` returns an estimated distinct count. Redis documents a standard error of about 0.81% for its HLL implementation. That is a statistical property, not a promise that every individual answer stays within 0.81%. Evaluate the workload's observed error and the cost of a wrong decision before relying on the estimate.

The commands have different jobs:

| Command | Purpose |
| --- | --- |
| `PFADD key member...` | Feed values into a sketch. |
| `PFCOUNT key...` | Estimate the cardinality of one sketch or the union of several. |
| `PFMERGE destination source...` | Store the union of several sketches under a destination key. |

## Counting buckets and merging sketches

Use a separate key for each day when you need daily analysis and an explicit retention policy. Define the timezone and day boundary consistently across the product:

```text
PFADD lab:visitors:2026-11-09 user:1 user:2
PFADD lab:visitors:2026-11-10 user:2 user:3
PFCOUNT lab:visitors:2026-11-09
PFCOUNT lab:visitors:2026-11-10
PFCOUNT lab:visitors:2026-11-09 lab:visitors:2026-11-10
```

`PFCOUNT key1 key2 ...` estimates the union without creating a new key. `PFMERGE destination source...` stores a union:

```text
PFMERGE lab:visitors:week lab:visitors:2026-11-09 lab:visitors:2026-11-10
PFCOUNT lab:visitors:week
```

If a user appeared on both days, the union estimates that person once. Adding the two daily counts would count that user twice. The sketch merge is what makes a range-level distinct estimate possible without retaining every ID.

## HLL or an exact structure?

| Requirement | Better starting point |
| --- | --- |
| Approximate unique visits on a dashboard, with small error acceptable | HyperLogLog |
| List people to grant a reward or contact them | Set or an exact database table |
| Remove one user or correct one specific value | Exact storage, or rebuild a sketch from exact source data |
| Financial or quota count that drives a legal or commercial decision | Durable exact counting |
| Exact intersection of two groups | Exact member data; HLL does not expose members |

A dense Redis HLL uses about 12 KB per sketch. Small datasets may use a more memory-efficient encoding. Include key overhead, replication, persistence, and the number of time buckets in capacity estimates; “compact” does not mean free.

## Designing a unique-visitor metric

1. Define what “user” means: account ID, cookie, IP address, or a deliberate combination.
2. Produce a canonical identifier. Specify case normalization, whitespace, anonymous-to-signed-in transitions, and account deletion behavior.
3. Choose the time range and timezone, then version the key naming scheme.
4. Run `PFADD` on the event path while honoring privacy and retention requirements.
5. Cache `PFCOUNT` results for dashboards if the same expensive-to-compute view is requested frequently.
6. Keep a small exact sample or comparison metric so that you can measure observed error.

Hashing an identifier for privacy does not by itself make it impossible to track a person. Define data protection, access, and retention policies separately. `PFMERGE` combines compatible sketches; do not accidentally merge buckets from different tenants, identifier schemes, or schema versions.

## Guided exercises

1. Add repeated users to two daily keys. Compare `PFCOUNT key1 key2` with the sum of their individual counts.
2. Observe `PFADD` on repeated inputs. Do not turn its reply into a `new_unique_user` metric.
3. Give one use case where 1% error is acceptable and one where it would be dangerous.
4. Decide whether a 30-day report remains possible after daily keys expire.

**Answer guide:** Daily counts may count the same person on several days; the union estimates distinct people across the whole period. A product analytics dashboard is a reasonable approximate use. Financial settlement or definitive reward eligibility is not. Retention determines whether historical reports can still be built.

## Common pitfalls

- **Treating the `PFADD` reply as `new_unique_user`:** It is not a count of newly seen members.
- **Adding daily counts for a monthly unique count:** Shared users are counted repeatedly; union the sketches.
- **Expecting a list of members:** HLL targets estimated cardinality, not enumeration.
- **Deleting one member:** HLL does not support precise per-member deletion. Rebuild from exact data or retain a different representation.
- **Using it for money or quotas:** Statistical error can change a business outcome.
- **Ignoring identity normalization:** `user:7` and `7`, or anonymous and logged-in identifiers, may become separate values unintentionally.
- **Forgetting bucket retention:** Once source sketches expire, they cannot be merged into a new historical range.

## Quiz with answers

### 1. What does an HLL retain and return?

<details><summary>Answer</summary>

It retains a probabilistic sketch used to estimate cardinality. It does not retain a recoverable list of members.

</details>

### 2. Does `PFADD` return the number of new distinct members?

<details><summary>Answer</summary>

No. It reports whether the sketch's internal state changed after processing the input.

</details>

### 3. How do you estimate the union of several days?

<details><summary>Answer</summary>

Pass all keys to `PFCOUNT`, or store the union using `PFMERGE destination source...`.

</details>

### 4. Can you remove one identifier from an HLL?

<details><summary>Answer</summary>

No. Per-member deletion is not supported.

</details>

### 5. Why is summing daily unique counts wrong for a monthly distinct count?

<details><summary>Answer</summary>

A person who appeared on multiple days is present in several daily counts. Estimate the union of the sketches instead.

</details>

### 6. Does the documented standard error of 0.81% cap the error of every result?

<details><summary>Answer</summary>

No. It is a statistical error characteristic, not a hard upper bound for every individual answer.

</details>

## Published analytics example

Redis documents anonymous unique visits per page and time period as a HyperLogLog use case; the same pattern can estimate distinct listeners or viewers. Keep one sketch per entity/window and merge compatible windows when appropriate. This is an official design example, not a measured customer case. The documentation also warns that identifiers such as IP addresses can be personal data, so privacy and retention requirements still apply. [Redis HyperLogLog guide](https://redis.io/docs/latest/data-types/probabilistic/hyperloglogs/) · [Probabilistic analytics with Redis](https://redis.io/blog/streaming-analytics-with-probabilistic-data-structures/)

## References and further reading

### English: official documentation and research

- [Redis HyperLogLog data type guide](https://redis.io/docs/latest/develop/data-types/probabilistic/hyperloglogs/) — representation, accuracy, and usage.
- [PFADD command reference](https://redis.io/docs/latest/commands/pfadd/) — input semantics and return value.
- [PFCOUNT command reference](https://redis.io/docs/latest/commands/pfcount/) — single-key and multi-key estimates.
- [PFMERGE command reference](https://redis.io/docs/latest/commands/pfmerge/) — union behavior.
- [HyperLogLog: The Analysis of a Near-Optimal Cardinality Estimation Algorithm](https://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf) — the foundational paper by Flajolet, Fusy, Gandouet, and Meunier.
- [HyperLogLog in Practice: Algorithmic Engineering of a State of the Art Cardinality Estimation Algorithm](https://research.google/pubs/hyperloglog-in-practice-algorithmic-engineering-of-a-state-of-the-art-cardinality-estimation-algorithm/) — practical engineering refinements and error analysis.
- [HyperLogLog security: inflating cardinality estimates](https://arxiv.org/abs/2011.10355) — a research perspective on adversarial input and sketch limitations.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/) — مفاهیم و فرمان‌های Redis.
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf) — مرور مجموعه‌ای از نوع‌داده‌ها.
- [جست‌وجوی تکمیلی فارسی دربارهٔ HyperLogLog](https://www.google.com/search?q=HyperLogLog+Redis+آموزش+فارسی) — برای یافتن آموزش‌های تازه‌تر؛ کیفیت هر نتیجه را جداگانه ارزیابی کن.

Deep Persian coverage of Redis HyperLogLog is limited. This lesson teaches the core concept, commands, and design decisions directly; use the official documentation for version-specific behavior.

</div>

