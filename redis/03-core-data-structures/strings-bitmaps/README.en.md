<div dir="ltr" align="left">

# Strings, Counters, and Bitmaps

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [String، شمارنده و Bitmap](./README.md)

## Learning objective

Choose Strings for text/counters and Bitmaps for compact indexed flags.

## The lesson

A Redis String is a binary-safe value suitable for text, serialized data, and counters. Common commands include `SET`/`GET`, `MGET`/`MSET`, `APPEND`, and `INCR`/`DECR`. `INCR` is atomic on Redis and safer than reading a value into an application and writing an updated value back. A Bitmap uses `SETBIT`/`GETBIT` to store flags as bits in a String; `BITCOUNT` and `BITOP` count and combine bits.

Bitmaps fit binary state with a predictable index. Their size depends on the highest offset, so validate input offsets. Do not repeatedly rewrite a large, frequently changing JSON value inside a String without considering the cost.

## Understand Strings from the beginning

A Redis String is not simply a language-level text string. It is a binary-safe value that can contain UTF-8 text, a textual number, serialized JSON, or bytes from a small file. Redis does not understand the meaning inside a String unless a command is designed for it. If you store JSON using `SET`, `GET` returns the whole text; a Hash command cannot read an inner field.

A key has one type at a time. `SET` on an existing key replaces the old value, even if it used another type, and plain `SET` also clears the existing TTL. Use `SET key value NX` for insert-only behavior. Consider `KEEPTTL` when you need to preserve an expiry; for a lock, ownership and safe release require separate design.

## String commands and replies

```text
SET page:42:title "Redis basics"
OK
GET page:42:title
"Redis basics"
STRLEN page:42:title
(integer) 12
APPEND page:42:title " — intro"
(integer) 22
GET page:42:title
"Redis basics — intro"
```

`STRLEN` returns the String's byte length, not necessarily its visible character count. Persian letters and emoji can use multiple UTF-8 bytes. `APPEND` adds to the end and returns the new length. Do not use a client-side `GET` and calculation for a counter; use `INCR`/`INCRBY`:

```text
INCR article:42:views
(integer) 1
INCRBY article:42:views 5
(integer) 6
GET article:42:views
"6"
```

`INCR` treats a missing key as zero. It errors if the current value is not a valid integer. The increment command is atomic: simultaneous increments from two clients are both applied. That guarantee covers this command, not a multi-command workflow such as “increment only if below a limit.”

`MGET`/`MSET` can reduce round trips for related keys. For a missing key, `MGET` returns nil in that position, and result order matches the requested key order. A pipeline also batches commands, but it does not itself provide a transaction.

## Picture a Bitmap with daily activity

A Bitmap is a String whose positions are bits set to zero or one. For example, bit 1200 can indicate whether user ID 1200 was active on a given date:

```text
SETBIT active:2026-11-10 1200 1
(integer) 0
GETBIT active:2026-11-10 1200
(integer) 1
BITCOUNT active:2026-11-10
```

`SETBIT` returns the previous value of that bit. A reply of zero means it was previously off and is now on. Running the same command again returns one, while the user still occupies one bit. `BITCOUNT` counts the set bits. Use `BITOP` for AND/OR/XOR across daily keys, with a deliberate naming and ordering convention.

**Model warning:** memory usage depends on the highest offset even when only a few bits are set. If user IDs are huge or user-controlled, using them directly as offsets may allocate a large value. Map IDs to dense indexes or consider a Set. A Bitmap does not store a list of users or additional metadata.

## Choose among String, Hash, and JSON

- One token or counter: String.
- Several independent fields for a small record: Hash.
- A nested document with path updates and JSON features: native Redis JSON, if the version/service supports it.
- A large serialized String where one field changes often: measure serialization and full-value rewrite cost.

Record payload size, update frequency, and required queries. Choose a Redis type based on common operations, not merely the shape of a class in application code.

## Guided practice

1. Create a counter at zero and run `INCR` three times. Predict the final value.
2. Replace that key with text using `SET`, then run `INCR`. Explain the error.
3. Set an expiry, then use plain `SET` and inspect the TTL.
4. Record several dense user IDs in a daily Bitmap, count bits, and explain why a very large sparse ID is risky.
5. Run `MGET` with an existing and missing key; identify the nil position.

**Answers:** after three increments the value is 3. If you replace it with non-numeric text, `INCR` errors. Plain `SET` clears the existing TTL. A Bitmap counts set bits, not events; setting the same user's bit again does not add another active user.

## Example and experiment

```text
SET visits:today 0
INCR visits:today
SETBIT active:2026-11-10 12345 1
GETBIT active:2026-11-10 12345
BITCOUNT active:2026-11-10
```

## Practical pattern

Visit counters and daily activity flags are common patterns. The selected Persian video explains `INCR` and atomic counters with a store example; it is an educational demonstration, not a named-company case.

## Common mistakes

A client-side GET then SET can lose an update. `INCR` alone does not enforce a conditional inventory purchase or a complex reservation workflow.

## Practice

1. Run the example in a local Redis lab and explain the output.
2. Write two failure modes or edge cases.
3. Estimate data size, read/write rate, TTL/retention, and outage behavior for your workload.
4. Choose a metric: p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. Why is `INCR` safer than application-side read-modify-write?

<details><summary>Answer</summary>

The increment is atomic on the Redis server.

</details>

### 2. What is a Bitmap useful for?

<details><summary>Answer</summary>

Compact binary flags at known indexes.

</details>

### 3. What controls the size of a Bitmap?

<details><summary>Answer</summary>

The highest offset that has been addressed.

</details>

## Published bitmap design example

The Redis bitmap guide demonstrates representing a sensor’s “checked in this hour” state as one bit, then counting or combining those states. It also shows daily-visit streaks. These are Redis-published engineering examples rather than a named customer postmortem. If the bit represents a person’s activity, avoid embedding raw personal identifiers and set a retention policy for the time buckets. [Redis bitmap guide](https://redis.io/docs/latest/develop/data-types/strings/bitmaps/)

## Further reading

### English and official references

- [Redis Strings](https://redis.io/docs/latest/develop/data-types/strings/)
- [Redis Bitmaps](https://redis.io/docs/latest/develop/data-types/bitmaps/)
- [`INCR`](https://redis.io/docs/latest/commands/incr/)
- [`SETBIT`](https://redis.io/docs/latest/commands/setbit/)
- [Redis pipelining](https://redis.io/docs/latest/develop/using-commands/pipelining/)
- [Redis data types and command examples](https://redis.io/docs/latest/develop/data-types/)

### Persian references

- [Persian video on Strings and `INCR`](https://www.youtube.com/watch?v=e5Q_RUwviaE)
- [DNTips Redis overview (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

</div>
