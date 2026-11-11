<div dir="ltr" align="left">

# `redis.conf`, Configuration as Code, and Safe Rollouts

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 8 · Level: intermediate · Time: 70–100 minutes
>
> The configuration below is a lab template, not a production file to copy directly. Size memory and network access for the real environment.

## Learning objectives

- Explain the difference between a configuration file, runtime values, and managed-service settings.
- Keep configuration reproducible, version-controlled, and safe for secrets.
- Connect network, persistence, `maxmemory`, ACL/TLS, and Cluster settings.
- Roll out a change with pre-checks, staged deployment, metrics, restart planning, and rollback.
- Distinguish `CONFIG GET`, `CONFIG SET`, and `CONFIG REWRITE`.

## Configuration model

Redis commonly starts from a configuration file, but CLI options, environment/entrypoint, or a managed control plane may also determine behavior. `CONFIG GET` reads runtime values. `CONFIG SET` changes some supported parameters in the running process; that does not guarantee the file or IaC is updated. `CONFIG REWRITE` attempts to write runtime configuration back to a file, but can conflict with configuration management, a read-only file, or a provider's deployment model.

For each setting, identify the source of truth: runtime or file? Does it need a restart? Where does the secret come from? How is it distributed across nodes?

## 1. Example lab configuration

This lesson does not create a `redis.conf` file in your course folder. Write this only in your own lab and inspect the values:

```conf
port 6379
protected-mode yes
dir /data
dbfilename dump.rdb
save 60 1
appendonly yes
appendfsync everysec
maxmemory 256mb
maxmemory-policy allkeys-lru
loglevel notice
```

Notes:

- Enabling RDB and AOF together uses more disk/CPU/RAM; study each separately while learning.
- `256mb` must not equal the container limit. Process overhead, buffers, fork headroom, and the OS need extra space.
- `allkeys-lru` is only for a cache where deleting any key is acceptable.
- Keep `protected-mode yes`; map the host port locally only.
- Do not put secrets in this file or repository; manage ACL/TLS secrets separately with restricted permissions.

### Run the Docker lab from PowerShell

After creating `lab.redis.conf` in the mounted path and a `data` folder:

```powershell
docker run -d --name redis-config-lab `
  -p 127.0.0.1:6379:6379 `
  -v ${PWD}/lab.redis.conf:/usr/local/etc/redis/redis.conf:ro `
  -v ${PWD}/data:/data `
  redis:8 redis-server /usr/local/etc/redis/redis.conf
docker exec redis-config-lab redis-cli CONFIG GET maxmemory
docker exec redis-config-lab redis-cli CONFIG GET appendonly
docker exec redis-config-lab redis-cli INFO persistence
```

The `redis:8` tag teaches the version family; it is not a production pin. For deployment, choose a specific tag/digest, patch policy, and rollback image. The port is local-only; do not publish a server port directly to the public Internet.

## 2. Runtime configuration and persistence

Inspect before changing anything:

```text
CONFIG GET maxmemory
CONFIG GET maxmemory-policy
CONFIG GET appendonly
CONFIG GET appendfsync
INFO persistence
```

If supported, `CONFIG SET` changes a runtime parameter. Read the active value afterward and determine whether it survives a restart. Do not run `CONFIG REWRITE` under IaC or read-only file management; edit the source file in version control/secret management and use the standard rollout.

Some settings can change without a restart; others depend on startup options, restart, or provider workflow. Exact behavior differs by version and managed service. Read the official docs/provider contract.

## 3. Grouping and maintaining configuration

- **Base configuration:** Common, safe parameters.
- **Environment overlay:** Capacity, endpoint, features, and source of truth for dev/staging/prod.
- **Secret material:** ACL credentials, TLS keys, and passwords belong in a secret manager/secure mount, not Git.
- **Node role:** Primary/replica, Sentinel, and Cluster topology may need different configuration.
- **Configuration history:** Record owner, date, intent, rollback, version, and change approval according to the team's workflow.
- **Drift detection:** Compare runtime state with desired configuration.

Avoid changing each node manually; automated rollout and validation help prevent drift. Do not confuse Cluster slot/topology or Sentinel state with a simple config file.

## 4. Configuration-change matrix

| Category | Example | Before/after checks |
| --- | --- | --- |
| Memory | `maxmemory`, policy | RSS/host headroom, evictions, write errors |
| Persistence | `save`, AOF/fsync | RPO, disk, status, restart/restore time |
| Network | bind/port/TLS | Client/replica/Sentinel/Cluster connectivity |
| ACL | User/key/channel rules | `NOPERM`, access path, break-glass login |
| Latency | Timeout/SLOWLOG/latency monitor | App p95, CPU, overhead, alert noise |
| Replication/HA | Role, backlog, Sentinel | Lag, failover time, data-loss test |

## 5. Real incident lesson

GitLab described a database outage where a backup job failed due to a mismatched binary version and its email alert went unnoticed. This was a PostgreSQL incident, not Redis. The operational configuration lesson is to check version pins, startup configuration, logs, alerts, and recovery tests as one chain. [GitLab postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

## Rollout runbook

1. Confirm the target and version.
2. Export/record current config/runtime values and review the diff.
3. Document effects on durability, memory, security, clients, and restart needs.
4. Test with representative data/workload in staging.
5. Change one node/replica at a time; observe health and errors.
6. Run read/write, p95, memory, replication, persistence, and TLS/ACL smoke checks.
7. Continue or roll back; avoid changing several layers simultaneously.
8. Update desired configuration and the runbook so drift does not return.

## Common pitfalls and troubleshooting

- **Assuming `CONFIG SET` is persistent:** A restart may restore the old value.
- **Assuming `CONFIG REWRITE` edits the Git source:** Know the source of truth and whether the file is managed/read-only.
- **Setting `maxmemory` to the container limit:** No process/host headroom remains.
- **Putting passwords in `redis.conf` or command history:** Use secret rotation and secure mounts.
- **Changing the primary but not the replica:** Check drift and Sentinel/Cluster reconfiguration.
- **A reload unexpectedly disconnects clients:** Plan restart/config compatibility and connection draining.
- **The server config changed but the deployment manifest did not:** The next deploy may undo the runtime change.

## Exercises

1. Make one lab configuration for a cache and another for a Stream/queue. Why do `maxmemory` and persistence differ?
2. Write a rollback plan before changing `appendfsync`.
3. Classify each setting as runtime, restart-required, secret, or provider-controlled.
4. Design a configuration-drift report.

## Quiz with answers

### 1. Does `CONFIG SET` always persist to the configuration file?

<details><summary>Answer</summary>

No. It changes runtime; persistence depends on the configuration workflow.

</details>

### 2. When should you avoid `CONFIG REWRITE`?

<details><summary>Answer</summary>

When the provider/IaC manages the file or it is read-only/managed.

</details>

### 3. Why should a secret not be in the repository?

<details><summary>Answer</summary>

History and artifacts may expose it for a long time; use a secret manager/secure mount and rotation.

</details>

### 4. Why should `maxmemory` not equal all RAM?

<details><summary>Answer</summary>

The process overhead, buffers, fork, and OS need memory too.

</details>

### 5. How do you measure rollout success?

<details><summary>Answer</summary>

Confirm desired runtime configuration, health/application checks, SLO, persistence/replication, and rollback readiness.

</details>

## References and further reading

### English: official documentation and incident report

- [Redis configuration guide](https://redis.io/docs/latest/operate/oss_and_stack/management/config/) — configuration file and runtime settings.
- [CONFIG GET](https://redis.io/docs/latest/commands/config-get/), [CONFIG SET](https://redis.io/docs/latest/commands/config-set/), and [CONFIG REWRITE](https://redis.io/docs/latest/commands/config-rewrite/) — inspect/change/write configuration.
- [Redis Security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/) — secure network and deployment settings.
- [Redis Persistence](https://redis.io/docs/latest/management/persistence/) — save/AOF configuration context.
- [Redis latency optimization](https://redis.io/docs/latest/management/optimization/latency/) — effects of config and persistence choices.
- [GitLab database backup postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/) — a PostgreSQL version/alert failure, not a Redis incident.

### فارسی

- [مرور فارسی Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [جست‌وجوی فارسی redis.conf](https://www.google.com/search?q=آموزش+فارسی+redis.conf+پیکربندی+Redis)

Persian coverage of secure configuration and IaC is limited. This lesson explains a rollout framework. Verify managed-service and version-specific settings with your provider's documentation.

</div>

