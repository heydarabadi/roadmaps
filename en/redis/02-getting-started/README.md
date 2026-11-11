<div dir="ltr" align="left">

# Chapter 2 — Installation, Connection, and First Commands

> Persian edition: [فصل ۲ — نصب، اتصال و اولین دستورها](../../../fa/redis/02-getting-started/README.md) · Suggested time: 90–120 minutes.

This chapter starts an isolated local Redis and introduces the client/server relationship, `redis-cli`, keys, types, and TTL.

## Lesson order

1. Complete the [lab setup lesson](../00-start-here/README.md). Use this local lab for all mutating commands.
2. Read [installation and connection](install-run/README.md): Docker state, ports, health, logs, and version.
3. Read [CLI, keys, and TTL](cli-keys-ttl/README.md): RESP replies, namespaces, expiration, and key scanning.

## From command to reply

A client such as `redis-cli` connects to a server and sends a command with separate arguments. `SET greeting salam` is one command; quote values that contain spaces. Replies can be a status, string, integer, error, or collection. In this course, type `text` blocks after entering `redis-cli`; run `powershell` blocks in PowerShell.

Name keys with a namespace, such as `course:session:student-7` or `catalog:product:42`. Prefixes help with targeted discovery, cleanup, and ACL restrictions. A key name is an application contract: if clients use different conventions, the data becomes harder to operate.

TTL defines a key's lifetime. Expiry does not mean the key is guaranteed to disappear at the exact millisecond. Treat expiry semantics carefully in application logic. Use TTL for suitable cache/session values, not for data that must never vanish unexpectedly.

## Chapter lab

```text
PING
SET course:hello "Salam Redis"
GET course:hello
TYPE course:hello
EXPIRE course:hello 60
TTL course:hello
SCAN 0 MATCH course:* COUNT 100
```

Predict the reply for each command, then run it. On the local lab only, run `EXPIRE course:hello 0` and observe that the key is removed and how `TTL` replies for a missing key. Do not copy this cleanup into a shared or production database.

## Initial troubleshooting

- `Connection refused`: the server/container is down, the port is wrong, or the mapping is missing.
- `NOAUTH`: the server requires authentication; do not put secrets in shell history or public logs.
- `WRONGTYPE`: the key exists with another type; inspect it with `TYPE` before choosing a command.
- Incomplete `SCAN` output: continue with the returned cursor until it is zero. One call may not return every key.
- `TTL` equals `-1`: the key exists without an expiry. `-2`: the key does not exist (common `TTL`/`PTTL` behavior).

## Readiness quiz

1. What is the difference between a Redis server and `redis-cli`?
2. Why can `KEYS *` be risky on a large keyspace, and what does `SCAN` not guarantee?
3. How does `TTL` distinguish a key without expiry from a missing key?
4. What happens if `SET x value` is used on a key currently holding a Hash?

<details><summary>Answer guide</summary>

The server manages data and commands; `redis-cli` is a client. `KEYS` searches the whole keyspace in one blocking operation. `SCAN` is incremental, but it is not a fixed snapshot and does not promise a perfectly duplicate-free view while the keyspace changes; continue through the cursor. `TTL` normally returns `-1` for an existing key without expiry and `-2` for a missing key. `SET` may overwrite the existing key with a String; design key names and types deliberately and test destructive behavior only in the lab.

</details>

## Further reading

- [Redis CLI](https://redis.io/docs/latest/develop/tools/cli/)
- [Keyspace and expiration](https://redis.io/docs/latest/develop/using-commands/keyspace/)
- [`SCAN` command](https://redis.io/docs/latest/commands/scan/)
- [Redis protocol specification](https://redis.io/docs/latest/develop/reference/protocol-spec/)
- [SalamLang Redis guide in Persian](https://www.salamlang.ir/std/db/redis/)
- [DNTips overview of Redis data structures in Persian (PDF)](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

</div>
