<div dir="ltr" align="left">

# AOF: Write Logging, fsync, and Rewrite

> Persian edition: [Read this lesson in Persian](README.md)

> Path: Chapter 5 · Level: intermediate · Time: 70–110 minutes
>
> Never manually delete or edit an active AOF file. Make configuration or repair changes with a backup and the matching Redis version.

## Learning objectives

- Explain how AOF records writes and replays them at startup.
- Compare `appendfsync always`, `everysec`, and `no` in durability and latency.
- Understand `BGREWRITEAOF`, multipart AOF from Redis 7 onward, manifests, and write status.
- Troubleshoot a full disk, corrupt AOF, failed rewrite, and restart.

## Mental model

An Append Only File (AOF) is a log of data-changing operations. After a restart, Redis replays the required commands to rebuild the dataset. For changing data, AOF can be more current than a snapshot; in return, you must manage file size, rewrite work, and recovery duration.

```text
write --> in-memory dataset
   \\--> AOF buffer --> OS/file cache --> disk (fsync policy)

restart: read AOF records -> replay -> dataset
```

A successful Redis reply is not the same as a physical flush to storage media. `fsync` and the underlying storage, power protection, controller, and filesystem all affect durability.

## 1. Three `appendfsync` policies

Read the configured policy:

```text
CONFIG GET appendonly
CONFIG GET appendfsync
INFO persistence
```

| Policy | General behavior | Cost and risk |
| --- | --- | --- |
| `always` | Attempts to make each write durable with fsync; Redis may group concurrent writes | Better durability, more latency and I/O |
| `everysec` | Flushes periodically, about once a second | Common compromise; recent writes may be lost in some system/disk crashes. Do not treat one second as a universal hard limit. |
| `no` | Leaves fsync timing to the operating system | Less direct Redis I/O work, but the loss window depends on the OS and storage. |

Choose based on RPO and a benchmark of the real workload. “`always` means every write survives every failure” is false; replication/HA, storage durability, backup, and application consistency are separate concerns.

## 2. Inspect files and status

```text
CONFIG GET dir
CONFIG GET appenddirname
CONFIG GET appendfilename
INFO persistence
```

Names and file layout depend on configuration and Redis version. Redis 7 and later use multipart AOF with base/incremental files and a manifest. Do not concatenate or delete an older single AOF file using shell commands. Monitor AOF write/rewrite state and counters in `INFO persistence`; exact fields can change by version.

When both RDB and AOF are enabled, startup uses AOF to rebuild state because it usually contains newer changes. To test RDB recovery, test that path independently in an isolated environment; having both files does not mean both are replayed together.

## 3. Rewrite the AOF

The log can grow with change history. Rewrite creates a more compact set of commands sufficient to reconstruct the current state, rather than retaining the whole historical log. In a lab, run `BGREWRITEAOF` and inspect `INFO persistence` before and after:

```text
BGREWRITEAOF
INFO persistence
```

Background rewrite involves fork/copy-on-write and disk I/O. New writes must still be preserved during the rewrite, and temporary/required files need free space. Running snapshotting, replica synchronization, and AOF rewriting at the same time can pressure resources. Rewriting too frequently is wasteful; tune thresholds based on AOF size and data growth.

## 4. Disk, errors, and repair

If the disk is full or Redis cannot write due to permissions, AOF writes may fail and Redis may reject writes with `MISCONF`, depending on configuration. Inspect `aof_last_write_status` in `INFO persistence`, Redis/system logs, and filesystem capacity. Fix the underlying problem. Turning off write protection while persistence is broken only hides the issue.

If startup fails because the AOF is truncated or corrupt, take a raw copy and checksum before repair, record the Redis version, and use the matching version's official repair tool, such as `redis-check-aof`, only on a copy. The `--fix` option may discard a corrupt tail and lose the newest writes. Coordinate repair with the data owner and RPO.

## Published experience: trust must be verified

In its official postmortem for a 2017 database outage, GitLab reported that PostgreSQL backups were unavailable because a backup job failed with the wrong utility version and the alert was not properly noticed. This involved PostgreSQL, not Redis or AOF. It is a concrete operations lesson: “configured” or “usually produces a file” is not enough. Verify exit status, alert on failure, and test restore. [GitLab postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/)

## Lab and decision exercise

In the lab, inspect status only. Enable AOF on a separate instance, never on a shared production server:

```text
INFO persistence
SET lab:aof:counter 1
INCR lab:aof:counter
INFO persistence
```

Use a hypothetical comparison: at a peak of 2,000 writes/second, what data window should your RPO tolerate if the disk or host fails under `everysec`? There is no universally fixed answer without testing. Document the policy, failure type, and storage. Measure restart time, file size, and load duration using a realistic dataset.

## Common pitfalls and troubleshooting

- **Calling `appendfsync everysec` lossless:** It is a trade-off, not a zero-loss guarantee.
- **AOF is too large:** Inspect rewrite status/thresholds, write rate, and free disk.
- **`aof_last_write_status:err`:** Check filesystem, quota, permissions, path, and logs; fix the cause and verify status afterward.
- **Rewrite runs on a large dataset at peak:** Include fork, CPU, I/O, and copy-on-write in capacity planning.
- **Repairing the original file:** Make a raw copy first; a fix operation can truncate the tail.
- **Multipart files were deleted manually:** The manifest and atomic rewrite state may be broken; follow version-specific official steps.
- **Treating AOF as a backup:** It does not replace replication outside the failure domain or a restore drill.

## Exercises with answer guidance

1. Compare `always`, `everysec`, and `no` for a cache, session store, queue, and financial source of truth.
2. Which metrics do you inspect after `BGREWRITEAOF`?
3. What does `aof_last_write_status:err` mean, and what dangerous action should not be used as a “fix”?
4. If AOF and RDB are both enabled, which recovery file does Redis normally use at restart?
5. Why is a backup on the same volume insufficient?

<details><summary>Answer guidance</summary>

1. Decide from loss impact, latency, rebuildability, and recovery time. A cache may not need persistence; an operational queue or critical message needs a smaller RPO and a backup plan.
2. Rewrite state, AOF size/growth, free disk, RSS/CPU, latency, and restart/load time.
3. Writing the file failed. Fix disk/permission/path/log causes; do not simply disable failure protection.
4. Normally AOF, because it contains the latest dataset state.
5. Host/volume failure can destroy both the live data and the local backup.

</details>

## Quiz with answers

### 1. What is AOF?

<details><summary>Answer</summary>

A log of data-changing operations that Redis replays during startup.

</details>

### 2. What trade-off does `everysec` make?

<details><summary>Answer</summary>

It balances durability against fsync work; some crashes can lose the most recent writes.

</details>

### 3. What does rewrite do?

<details><summary>Answer</summary>

It compacts the log into a smaller sequence sufficient to rebuild the current state.

</details>

### 4. Why does Redis 7 and later use a manifest?

<details><summary>Answer</summary>

AOF can have a base file and multiple incremental files; the manifest tracks the active set.

</details>

### 5. If the AOF is corrupt, what should you do first?

<details><summary>Answer</summary>

Preserve/copy the files, record the version and error, and evaluate official repair on a copy.

</details>

### 6. Does AOF replace an off-host backup?

<details><summary>Answer</summary>

No. AOF is one persistence mechanism in the same deployment.

</details>

## References and further reading

### English: official documentation and incident report

- [Redis persistence documentation](https://redis.io/docs/latest/management/persistence/) — RDB/AOF behavior and startup recovery.
- [Redis at Scale: persistence and durability](https://redis.io/tutorials/operate/redis-at-scale/persistence-and-durability/) — AOF/RDB setup and recovery walkthrough.
- [BGREWRITEAOF command reference](https://redis.io/docs/latest/commands/bgrewriteaof/) — rewrite command and status.
- [Redis common errors: MISCONF](https://redis.io/docs/latest/develop/reference/errors/common/misconf/) — persistence failure and write protection.
- [Redis latency optimization guide](https://redis.io/docs/latest/management/optimization/latency/) — persistence and fsync effects on latency.
- [GitLab database outage postmortem](https://about.gitlab.com/blog/postmortem-of-database-outage-of-january-31/) — PostgreSQL backup failure, not a Redis/AOF case.

### فارسی

- [راهنمای فارسی persistence در Urhoba](https://www.urhoba.net/fa/post/redis-persistence-snapshot)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Deep Persian explanations of multipart AOF are limited. This lesson is self-contained for the core model and troubleshooting. Match your durability settings to the documentation for your Redis version and actual storage provider.

</div>

