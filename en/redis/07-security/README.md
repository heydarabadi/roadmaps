<div dir="ltr" align="left">

# Chapter 7 — Redis Security

> Persian edition: [فصل ۷ — امنیت Redis](../../../fa/redis/07-security/README.md) · Suggested time: 2–3 hours.

Security starts with a password but does not end there. Network exposure, ACLs, TLS, secrets, patching, logs, and backups are all part of the trust boundary.

## Lessons

1. [Authentication and ACLs](acl-auth/README.md): separate users, command permissions, key/channel patterns, and least privilege.
2. [Network and TLS](network-tls/README.md): bind addresses, firewalls, private networks, encryption, and certificates.

## A simple threat model

Identify assets: cached data, tokens/sessions, credentials, backups, and administrative commands. A threat may reach an internal network, obtain a leaked secret, use an overprivileged worker, or exploit an accidentally public endpoint. Use layers of control: close public ports, use private networking, enable TLS where needed, create per-service ACLs, and rotate secrets.

An ACL should limit users not only by password, but also by allowed commands, accessible key patterns, and Pub/Sub channels. Do not use the default/admin user for ordinary application traffic. `ACL DRYRUN` can help preview whether a command would be allowed; never place real secrets in a README, ticket, or shell history.

## Practical checklist

- Redis is not reachable from the public Internet; inspect the real network and bind configuration.
- Every service has its own user and least-privilege key/command access.
- Replication, Sentinel, Cluster bus, backup, and exporter paths are included in the network review.
- TLS and certificate lifecycle are defined for required connections.
- Secrets live in a secret manager, are rotated, and are not committed to Git.
- Security advisories and supported versions are monitored; patch and rollback are planned.
- Logs and monitoring do not expose sensitive values; backup encryption and access are controlled.

## Review scenario

An order application needs `GET`, `HGET`, `HSET`, and `XADD` only on `orders:*`. Create a separate user and deny commands such as `FLUSHALL` and `CONFIG SET`. Verify that the patterns cover the actual keys and that transactions/scripts do not require more commands. Test ACLs locally and preserve a working administrative path.

## Readiness quiz

1. Why is a password alone insufficient protection for Redis?
2. What does an ACL key pattern restrict?
3. What does TLS protect, and what does TLS not solve by itself?
4. Which Redis paths besides the application connection need a security review?

<details><summary>Answer guide</summary>

A public endpoint, leaked credential, or overprivileged account remains dangerous. ACLs restrict commands and keys. TLS protects confidentiality/integrity on the connection but does not replace authorization, host security, or secret management. Replicas, Sentinel, Cluster bus, backups/restores, and monitoring also have access paths.

</details>

## Further reading

- [Redis security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/)
- [Redis ACLs](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/)
- [Redis TLS/encryption](https://redis.io/docs/latest/operate/oss_and_stack/management/security/encryption/)
- [ACL command reference](https://redis.io/docs/latest/commands/acl-setuser/)
- [Persian Redis hardening article](https://www.ariaservice.net/blog/%D8%B1%D8%A7%D9%87-%D8%A7%D9%86%D8%AF%D8%A7%D8%B2%DB%8C-%D9%88-%D8%A7%D9%85%D9%86-%D8%B3%D8%A7%D8%B2%DB%8C-redis-%D8%B1%D9%88%DB%8C-%D8%B3%D8%B1%D9%88%D8%B1-%D9%85%D8%AC%D8%A7%D8%B2%DB%8C-%D9%88-%D8%A7%D8%AE%D8%AA%D8%B5%D8%A7%D8%B5%DB%8C)

</div>
