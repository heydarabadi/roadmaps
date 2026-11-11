<div dir="ltr" align="left">

# Hashes and Record Modeling

> Level: beginner to intermediate · Time: 45–75 minutes
>
> Persian edition: [Hash و مدل رکورد](../../../../fa/redis/03-core-data-structures/hashes/README.md)

## Learning objective

Choose Hashes for small records and update individual fields without rewriting an entire value.

## The lesson

A Hash is one key containing field/value pairs and works well for a small profile or metadata record. `HSET`/`HGET` write and read fields, `HMGET` reads several, `HDEL` removes, `HEXISTS` checks, and `HINCRBY` atomically increments a field. `HGETALL` is convenient for a small Hash but can create a heavy reply for a large one.

A Hash is not schema validation, a secondary index, or a foreign key. The application must manage evolving data, versioning, migrations, and size limits.

## Read and update a record field by field

For a small profile, store independent fields:

```text
HSET user:42 name Sara city Tehran plan free
(integer) 3
HGET user:42 name
"Sara"
HMGET user:42 name plan unknown_field
1) "Sara"
2) "free"
3) (nil)
HEXISTS user:42 city
(integer) 1
```

For a multi-field `HSET`, the integer reply counts newly created fields. Updating an existing field does not add to that count. `HMGET` replies in the same order as requested and returns nil for a missing field. `HGETALL` returns every field/value pair; because work and reply size grow with the number of fields, avoid it on a huge Hash.

## Atomic field updates

```text
HINCRBY user:42 login_count 1
(integer) 1
HINCRBY user:42 login_count 5
(integer) 6
HGET user:42 login_count
"6"
```

If the field is missing, `HINCRBY` starts from zero. It errors if the value is not a valid integer. Use `HINCRBYFLOAT` only when floating-point precision is suitable. For money, integer minor units such as cents are generally safer than floating point.

## Hash versus JSON versus separate keys

- A Hash is a flat field-to-string map; it does not parse nested objects automatically.
- JSON supports nested structure and paths, subject to Redis version/product support.
- Separate keys for hot fields can allow independent updates and TTLs, but increase key count and multi-key operations.

Ask which fields the application reads most often, whether the whole record changes together, and whether the entity or individual fields need expiration. Hashes are useful for small flat records, not as a full replacement for database schemas and validation.

## Scanning large Hashes and field expiration

For a large Hash, evaluate `HSCAN` with a cursor instead of `HGETALL`. Continue until the cursor is zero. `COUNT` is not an exact number of fields per reply, and duplicate results must be tolerated.

Starting with Redis 7.4, Hash fields can have independent expiration. For example:

```text
HSET temporary:profile verification_code 123456 display_name Sara
HPEXPIRE temporary:profile 30000 FIELDS 1 verification_code
HPTTL temporary:profile FIELDS 1 verification_code
```

The last command returns the remaining TTL for that field in milliseconds. Verify syntax and replies against the real version. Field expiry differs from key expiry: if the entire key expires, all its fields disappear. Field-level notifications also depend on version; do not rely on them without checking the documentation.

## Example design: session

For a short-lived session:

- **Key:** `session:{opaque-id}`
- **Fields:** `user_id`, `created_at`, `permission_version`
- **TTL:** expiration of the whole session
- **Update:** change only the needed field with `HSET`
- **Security:** do not use a raw token as a key or log it; restrict ACL access to the session prefix
- **Logout:** `DEL` the key and invalidate the client-side session

If fields need different lifetimes, compare field-level expiry with a multi-key model. A session is not a place to keep an unbounded copy of a user account.

## Guided practice with answers

1. Create `user:42`, read two fields, and use `HMGET` to request a missing field.
2. Update an existing field with `HSET`; compare the reply count with creating a new field.
3. Create a counter with `HINCRBY`, then set nonnumeric text and inspect the error.
4. Create a Hash with 50 fields and use `HSCAN` until cursor zero instead of `HGETALL`.
5. On Redis 7.4+, expire a temporary field with `HPEXPIRE`; otherwise mark the feature unsupported.

**Answers:** `HSET` counts only new fields; `HINCRBY` errors on a non-integer value; `HMGET` puts nil in the requested field's position; `HSCAN` is incremental and is not a fixed snapshot.

## Example and experiment

```text
HSET user:42 name "Sara" city "Tehran" plan "free"
HGET user:42 city
HINCRBY user:42 login_count 1
HMGET user:42 name plan
```

## Practical pattern

Frequently accessed session/profile metadata can avoid fetching a larger document. Keep sensitive data access separate and restricted. This is a general pattern, not a named-company case.

## Common mistakes

- Running `HGETALL` on a huge Hash.
- Assuming that deleting a field also removes its indexes or derived data.

## Practice

1. Run the example locally and explain the output.
2. Write two failure modes or edge cases.
3. Estimate data size, read/write rate, TTL/retention, and outage behavior.
4. Select a metric such as p95 latency, hit rate, RAM, lag, pending count, or restore time.

## Quiz

### 1. What property does `HINCRBY` provide?

<details><summary>Answer</summary>

It atomically increments a Hash field.

</details>

### 2. How do you read several fields in one command?

<details><summary>Answer</summary>

Use `HMGET`.

</details>

### 3. Does a Hash provide relational constraints?

<details><summary>Answer</summary>

No. It is a field/value map.

</details>

## Published session-store example

Redis’s session-store guide models one session per hash, uses key expiry for inactive sessions, and uses sets to track a user’s multiple sessions. Redis also publishes a hybrid-cloud customer solution brief describing shared critical user sessions across on-premises and cloud environments. The brief is vendor-published and does not document the customer’s internal Redis encoding, so use the official session pattern for the Hash details and treat the customer story as deployment context. [Redis session-store pattern](https://redis.io/docs/latest/develop/use-cases/session-store/) · [Hybrid-cloud session solution brief](https://redis.io/wp-content/uploads/2022/08/Caching-for-Hybrid-Cloud-Solution-Brief-20220809.pdf)

## Further reading

### English and official references

- [Redis Hashes](https://redis.io/docs/latest/develop/data-types/hashes/)
- [`HSCAN`](https://redis.io/docs/latest/commands/hscan/)
- [`HINCRBY`](https://redis.io/docs/latest/commands/hincrby/)
- [`HPEXPIRE`](https://redis.io/docs/latest/commands/hpexpire/)
- [Redis JSON](https://redis.io/docs/latest/develop/data-types/json/)
- [Redis data-type comparison](https://redis.io/docs/latest/develop/data-types/compare-data-types/)

### Persian references

- [DNTips overview of Redis data structures (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)

</div>
