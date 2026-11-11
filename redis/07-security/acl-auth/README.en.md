<div dir="ltr" align="left">

# Redis Security: ACLs, Authentication, and Least Privilege

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 7, security · Level: intermediate · Time: 70–100 minutes
>
> The example secret is a placeholder, not a real credential. Never store a password in shell history, chat, a README, or logs.

## Learning objectives

- Distinguish authentication, authorization, and encryption.
- Create an ACL user limited to the required keyspace and commands.
- Separate read-only and read/write roles.
- Use `ACL WHOAMI`, `LIST`, `GETUSER`, `DRYRUN`, and `LOG` for audit/troubleshooting.
- Apply least privilege to Pub/Sub, scripts, and sensitive commands.

## Security model

A secure connection needs several layers: a trusted network and firewall, TLS on untrusted paths, authentication for identity, ACLs for permissions, secret rotation, encryption at rest for backups, monitoring, and patches. `AUTH` only proves which credential a client supplied; it does not encrypt the connection or limit which keys/commands the user can access.

```text
Client -> network/firewall -> TLS (privacy) -> AUTH (identity) -> ACL (allowed commands/keys/channels)
```

Redis 6 and later provide multiple ACL users and command/key/channel permissions. `requirepass` works with the default ACL user, but separate users are better for application role separation.

## 1. Inspect the identity and rules

```text
ACL WHOAMI
ACL LIST
ACL USERS
ACL CAT
```

`ACL WHOAMI` shows the user for the current connection. `ACL LIST` returns current rules; its output contains credential-related information and must not be logged or shared without protection. `ACL CAT` lists commands by category. Do not grant a whole category blindly because it may include more commands than the application needs.

## 2. Create restricted users

Conceptual examples for two roles with one key pattern:

```text
ACL SETUSER cache-reader reset on >REPLACE_WITH_RANDOM_SECRET ~cache:* +get +mget +ping
ACL SETUSER cache-writer reset on >REPLACE_WITH_RANDOM_SECRET ~cache:* +get +set +del +expire +ttl +ping
```

Replace `REPLACE_WITH_RANDOM_SECRET` with a random credential from a secret manager; do not execute the placeholder as a password. If terminal history is recorded, do not pass a real secret as a CLI command argument. Follow the organization's policy for ACL files and secret injection.

- `reset` clears existing rules; do not run it accidentally on a shared user.
- `on` enables the user.
- `>...` sets a password.
- `~cache:*` allows matching keys.
- `+get`, `+set`, and similar rules allow commands.

Connect as the lab user:

```text
AUTH cache-reader <secret>
GET cache:product:501
SET cache:product:501 value
GET private:salary:42
```

The reader should be able to read a cache key, while the write command and a key outside the pattern should be denied. Recognize the `NOPERM` response. Run this only on a disposable instance.

## 3. Key and channel patterns

ACL rules restrict key access by pattern. Multiple tenants can use separate namespaces, but if the application can construct arbitrary prefixes, validate authorization logic in the service too. ACLs do not replace tenant isolation across every application layer.

Pub/Sub channel permissions use `&pattern`. Allow a publisher or subscriber only the channels it needs. Broad `PSUBSCRIBE` patterns can reveal more messages than expected.

## 4. Special permissions and minimizing attack surface

Some commands have broad power: `CONFIG`, `MODULE`, `FLUSHALL`, `ACL`, `REPLICAOF`/replication controls, `DEBUG`, `SCRIPT`/Functions, `MONITOR`, and client management. Do not grant them to an application user just for convenience. Use separate users per service, rotate credentials, and audit permissions.

Use `ACL DRYRUN` to check permission without executing the operation (Redis 7.0 and later):

```text
ACL DRYRUN cache-reader GET cache:product:501
ACL DRYRUN cache-reader SET cache:product:501 x
```

Inspect `ACL LOG` for permission failures and denied commands, and store that log with security controls. After changing ACLs in a lab, run smoke checks using the same roles as the real application.

## 5. Safe changes and rollout

1. Create a new user with minimum permissions.
2. Connect the application to it in staging and observe denied operations.
3. If using a persistent ACL file, store it with restricted permissions and include it in deployment management.
4. Rotate the secret in a secret manager; remove the old credential only after clients migrate.
5. Disable the default user only after a tested admin break-glass user and recovery method exist.
6. Include lockout and credential-leak procedures in the runbook.

## Published threat evidence

Shadowserver reports hosts it observes with Redis reachable from the Internet; Censys has documented exposed Redis instances and abuse attempts. Counts vary by scan window, and an exposed host count is not the same as the number of successful breaches. The practical lesson is stable: remove public exposure, avoid default/weak authentication, and layer ACL and network restrictions. [Shadowserver Open Redis Report](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/) · [Censys Redis exposure research](https://censys.com/blog/databases-exposed-redis/)

## Common pitfalls and troubleshooting

- **Treating `AUTH` as encryption:** Credentials and data can be intercepted on an unencrypted network path.
- **Sharing one user across every application:** Compromising one service then grants access to all workloads.
- **Only setting a password:** The user may still have `FLUSHALL`, `CONFIG`, or access to the whole keyspace.
- **Granting `+@all`:** This violates least privilege.
- **Confusing key patterns with command permissions:** Both must be restricted separately.
- **Putting a password in process arguments or URLs/logs:** Review secret handling and shell history.
- **Getting `NOPERM` after tightening rules:** Inspect `ACL LOG`, `ACL DRYRUN`, and the requested command/key/channel; add only the necessary rule.
- **Removing the only admin user:** Keep a tested break-glass/recovery path; do not turn off the default user prematurely.

## Exercises

1. Create reader/writer users for `cache:*` and observe what happens for a key outside the prefix.
2. Create another user that can read only `orders:events` with `XREADGROUP`; document its command and key permissions.
3. Decide which role may `PUBLISH` and which may `SUBSCRIBE` to each channel.
4. Design a secure admin role and credential-rotation procedure.

**Answer criteria:** Each user gets only its necessary key/channel patterns and commands; secrets stay out of the repository/logs; denied operations and admin recovery are tested.

## Quiz with answers

### 1. How do `AUTH` and ACLs differ?

<details><summary>Answer</summary>

`AUTH` authenticates identity; ACLs limit which commands, keys, and channels that identity can use.

</details>

### 2. Do ACLs replace TLS?

<details><summary>Answer</summary>

No. ACLs authorize operations; TLS encrypts the communication path and can authenticate peers.

</details>

### 3. Why use a separate user for each service?

<details><summary>Answer</summary>

You can restrict or revoke one service's credential without changing other workloads.

</details>

### 4. How do you troubleshoot `NOPERM`?

<details><summary>Answer</summary>

Use `ACL LOG`/`DRYRUN` and inspect the requested command, key, and channel; add only the necessary rule.

</details>

### 5. Does `~cache:*` grant a command permission?

<details><summary>Answer</summary>

No. Key patterns and command permissions are separate rules.

</details>

### 6. Does the number of exposed Redis hosts equal the number of breaches?

<details><summary>Answer</summary>

No. Exposure detection is not proof of successful access or damage.

</details>

## References and further reading

### English: official documentation and security research

- [Redis ACL documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/) — users, key patterns, channel patterns, and command rules.
- [ACL SETUSER command reference](https://redis.io/docs/latest/commands/acl-setuser/) — create and modify users.
- [ACL DRYRUN command reference](https://redis.io/docs/latest/commands/acl-dryrun/) — test permissions without side effects; available since Redis 7.0.
- [ACL LOG command reference](https://redis.io/docs/latest/commands/acl-log/) and [ACL GETUSER](https://redis.io/docs/latest/commands/acl-getuser/) — investigate denials and inspect a user.
- [Redis security overview](https://redis.io/docs/latest/operate/oss_and_stack/management/security/) — trusted networks, authentication, protected mode, and TLS.
- [Redis security advisory: CVE-2026-81934](https://redis.io/blog/security-advisory-cve-2026-81934/) — an authenticated TLS-processing vulnerability, fixed-version guidance, and defense-in-depth recommendations. Check the advisory for current remediation.
- [Shadowserver Open Redis Report](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/) — internet exposure monitoring.
- [Censys: Redis exposure and abuse attempts](https://censys.com/blog/databases-exposed-redis/) — observed risks of publicly reachable instances.

### فارسی

- [جست‌وجوی راهنمای فارسی ACL و احراز هویت Redis](https://www.google.com/search?q=آموزش+فارسی+Redis+ACL+احراز+هویت)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Persian ACL tutorials are limited. This lesson covers the model and lab directly. Verify ACL syntax and command categories against the official reference for your target version.

</div>

