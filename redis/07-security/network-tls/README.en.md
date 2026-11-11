<div dir="ltr" align="left">

# Redis Networking, Bind, Firewall, and TLS

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 7 · Level: intermediate · Time: 60–90 minutes
>
> Do not expose Redis directly to the Internet. A network/TLS change on a live service can disconnect every client; plan the rollout.

## Learning objectives

- Expose a Redis listener only on the required interface/network.
- Distinguish bind, firewall, protected mode, authentication, and TLS.
- Include client, replica, Sentinel, and Cluster-bus paths in the threat model.
- Test TLS from a client and manage certificate expiry/rotation.
- Choose the correct layer to investigate for a TLS error or connection timeout.

## Layer model

```text
Application identity/ACL  = who can run which command/key operations?
TLS                       = is traffic encrypted and is the peer authenticated?
Private network/firewall  = which hosts can open a socket at all?
Host hardening/patching   = what attack surface remains if Redis is reachable?
```

No layer replaces the others. A Redis password on a public Internet endpoint is still exposure; TLS on a public host without ACLs is not enough either. Protected mode is a startup guard for unsafe configurations, not a permanent firewall.

## 1. Listener and network access

For a developer lab, binding the published port to the host loopback interface allows only local access:

```powershell
docker run -d --name redis-local -p 127.0.0.1:6379:6379 redis:8
```

For a server, put Redis in a private subnet, keep port 6379 unroutable from the Internet, allowlist clients in a security group/firewall, and allow access only from the application network. In the configuration, bind only required interfaces and preserve protected mode as documented. On a public host, `0.0.0.0` means listen on every interface; do not use it as a shortcut.

Cluster also has a cluster-bus port, usually the client port plus 10,000. Sentinel commonly uses port 26379. Allow required control/data paths only between the specific nodes and clients, not from the Internet.

## 2. TLS in Redis Open Source

Redis can support TLS for client connections, replication, and the Cluster bus. The build/package must include TLS support and the configuration must supply valid certificates. Conceptual example:

```text
port 0
tls-port 6379
tls-cert-file /run/redis/tls/server.crt
tls-key-file /run/redis/tls/server.key
tls-ca-cert-file /run/redis/tls/ca.crt
tls-auth-clients yes
```

`port 0` disables the ordinary non-TLS listener. Do not apply this before confirming that every client supports the transition. Managed-service options and TLS endpoints may be controlled by the provider.

Example CLI client:

```text
redis-cli --tls --cacert ca.crt -h redis.internal -p 6379 --user app-reader
```

With mutual TLS, a client certificate and private key may also be required. Verify CA chain, SAN/hostname, expiration, trust store, and certificate rotation in a lab. Using `--insecure` or disabling certificate checks as a workaround removes server identity verification.

## 3. Which communication paths are covered?

Enabling only the client socket is insufficient if nodes communicate in plaintext. Create a matrix:

| Connection | Security question |
| --- | --- |
| Application → Redis | TLS? Dedicated ACL user? Private subnet? |
| Primary → replica | TLS replication link? Dedicated credential? |
| Client → Sentinel | Port 26379 limited to app/admin network? ACL/TLS? |
| Redis Cluster node → node | Bus port restricted and Cluster-bus TLS enabled? |
| Backup storage | Encryption at rest, private access, credential rotation? |

Each path needs its own least-privilege user/ACL and firewall rule.

## 4. Connection troubleshooting

From the application network:

1. Do DNS and routing resolve correctly?
2. Is the TCP port reachable from an allowed host?
3. Do TLS handshake, CA chain, and hostname verification succeed?
4. Are `AUTH`/ACL user and command/key permissions correct?
5. Does the client use the correct endpoint protocol/Cluster/Sentinel mode?

| Symptom | Inspect |
| --- | --- |
| Connection refused | Process/listener/port or firewall rejection |
| Timeout | Route, security group, dropped packets, congestion |
| TLS unknown CA / hostname | Trust chain, SAN, or certificate configuration |
| `NOAUTH` or `WRONGPASS` | Username/password and secret rotation |
| `NOPERM` | ACL command/key/channel pattern |
| All clients disconnect after TLS is enabled | Clients, replication/Sentinel/Cluster paths, and rollout |

## Published threat evidence and security advisory

Shadowserver and Censys have tracked Redis hosts reachable from the public Internet; Censys has also documented abuse attempts against exposed Redis. These are scan-based reports, so “exposed” does not mean every host was compromised. [Shadowserver](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/) · [Censys research](https://censys.com/blog/databases-exposed-redis/)

Redis also publishes security advisories. For example, its 2026 TLS-processing advisory describes an authenticated vulnerability under specific conditions. It is a reminder that TLS does not remove the need to patch or follow advisories. Check the official advisory for affected and fixed versions at the time you operate your deployment. [Redis security advisory: CVE-2026-81934](https://redis.io/blog/security-advisory-cve-2026-81934/)

## Roll out without locking clients out

1. Issue and test certificates and chains in staging.
2. Inventory every client library and replication/monitoring path.
3. Introduce the TLS port and credentials in parallel; migrate clients in stages.
4. Monitor handshake and ACL metrics.
5. After every client has migrated, close the plaintext listener in a maintenance window.
6. Prepare certificate/endpoint rollback and expiry alerts.

## Common pitfalls

- **Binding port 6379 to `0.0.0.0`:** Scanners can find a public port; use private networking and a firewall.
- **Treating `requirepass` as enough:** Identity, network, ACL, and TLS remain separate concerns.
- **Treating protected mode as a firewall:** Do not rely on it for network access control.
- **Encrypting only the application connection:** Do not forget replication, Cluster, and Sentinel management paths.
- **Disabling TLS verification:** A client may connect to an impersonating endpoint.
- **Expired certificate:** Add alerts and routine rotation.
- **Changing host, network, and configuration at once:** Root-cause analysis becomes difficult; roll out in stages.
- **Password in URL/log:** Keep credentials secret and enable redaction.

## Exercises

1. Draw which services can access the Redis port; remove every public ingress path.
2. Write a TLS/ACL matrix for clients, replicas, and Sentinel.
3. After a hypothetical wrong-CA outage, record the troubleshooting order.
4. Threat-model a staging Redis with real data accidentally bound to a public IP. Which controls limit access and damage?

**Answer criteria:** Restricted network access, TLS verification enabled on untrusted paths, least-privilege ACLs, secrets outside the repository, patch alerts, and a tested rollout/rollback.

## Quiz with answers

### 1. What does TLS solve?

<details><summary>Answer</summary>

Encryption in transit and, when configured, peer authentication.

</details>

### 2. What do ACLs solve?

<details><summary>Answer</summary>

They restrict an identity to allowed commands, keys, and channels.

</details>

### 3. Is protected mode a replacement for a firewall?

<details><summary>Answer</summary>

No. Use a firewall and private subnet for network controls.

</details>

### 4. Why not expose port 6379 directly to the Internet?

<details><summary>Answer</summary>

Any reachable service has an attack surface, and default or configuration errors can expose serious access. Redis should be reachable only from trusted networks.

</details>

### 5. Is TLS on the Cluster application socket enough?

<details><summary>Answer</summary>

No. Evaluate replication, Cluster-bus, and Sentinel paths too.

</details>

### 6. What should remain enabled after a certificate error?

<details><summary>Answer</summary>

Certificate/hostname verification. Fix the CA chain or SAN instead of disabling verification.

</details>

## References and further reading

### English: official documentation and security research

- [Redis Security overview](https://redis.io/docs/latest/operate/oss_and_stack/management/security/) — network exposure, protected mode, authentication, and secure deployment.
- [TLS support in Redis Open Source](https://redis.io/docs/latest/operate/oss_and_stack/management/security/encryption/) — client, replication, Sentinel, and Cluster-bus TLS.
- [Redis ACL documentation](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/) — authorization and user rules.
- [Redis security advisory: CVE-2026-81934](https://redis.io/blog/security-advisory-cve-2026-81934/) — affected/fixed versions and defense-in-depth guidance.
- [Shadowserver Open Redis Report](https://www.shadowserver.org/what-we-do/network-reporting/open-redis-report/) — internet exposure observations.
- [Censys: Redis exposure and abuse attempts](https://censys.com/blog/databases-exposed-redis/) — research on publicly reachable instances.

### فارسی

- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی راهنمای فارسی Redis TLS و امنیت شبکه](https://www.google.com/search?q=آموزش+فارسی+Redis+TLS+امنیت+شبکه)
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Persian material specific to Redis TLS is limited. Security advisories are version-sensitive; check the official advisory and provider configuration at the time of operation.

</div>

