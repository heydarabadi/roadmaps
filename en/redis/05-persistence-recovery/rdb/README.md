<div dir="ltr" align="left">

# RDB: Point-in-Time Redis Snapshots

> Persian edition: [Read this lesson in Persian](../../../../fa/redis/05-persistence-recovery/rdb/README.md)

> Path: Chapter 5, persistence and recovery · Level: intermediate · Lesson and lab: 60–90 minutes
>
> Configuration names and paths vary by image and service. Run the lab on local Redis; do not edit a production configuration file.

## Learning objectives

- Explain what a snapshot is and when it captures the dataset.
- Interpret `BGSAVE`, `LASTSAVE`, `INFO persistence`, and `save` settings.
- Evaluate RAM, CPU, and disk trade-offs, snapshot intervals, and RPO.
- Distinguish an RDB file from an off-host backup and a tested restore.

## Mental model

RDB writes a point-in-time image of the dataset. On restart, Redis loads a snapshot file; writes made after that snapshot and before a failure may not be in the image. The model is simple and can fit rebuildable caches or periodic backups. Do not rely on RDB alone when the latest writes must be preserved.

```text
Time:   ---- write ---- write ---- [fork/snapshot point] ---- write ---- crash
RDB:                              |<--- this point is restored --->|
So a write after the snapshot point may not be recovered.
```

## 1. Scheduled and manual snapshots

The `save` configuration says to take an automatic snapshot when a threshold number of changes occurs within a time window. It does not mean “a snapshot will happen exactly every X seconds”: traffic, save errors, and busy operations also matter.

```text
CONFIG GET save
INFO persistence
LASTSAVE
```

`BGSAVE` starts a background snapshot:

```text
BGSAVE
INFO persistence
```

Watch `rdb_bgsave_in_progress`, `rdb_last_bgsave_status`, and `rdb_last_save_time`. `BGSAVE` typically creates a child process to write the snapshot. The `fork()` and copy-on-write work has a cost. Under heavy mutation, changed memory pages are copied and RSS/memory pressure can rise; slow disks increase the time needed as well.

`SAVE` is synchronous and blocks the main server until it finishes. It can be useful in a clearly isolated experiment, but do not run it ad hoc on a production dataset without a runbook.

## 2. Where is the snapshot file?

Inspect configured location and filename:

```text
CONFIG GET dir
CONFIG GET dbfilename
```

Common installations use `dump.rdb`, but inspect the active runtime/configuration for the actual path. Docker and managed Redis differ in host paths, volumes, snapshot policies, and permissions. Do not copy a file while it is being written. Redis writes a new file under a temporary name and finalizes it when complete. Use the backup path or filesystem snapshot process documented for that environment.

If both AOF and RDB are enabled, Redis uses AOF to rebuild the dataset at startup because it is generally more current/complete. Therefore, the presence of `dump.rdb` does not prove that Redis will use that file after a restart.

## 3. Capacity and limitations

Measure the following before selecting a snapshot schedule:

- Actual dataset size and serialized snapshot size, not only `used_memory`.
- RAM headroom for fork/copy-on-write at peak write volume.
- CPU used for snapshot creation and disk throughput/free space.
- Time to create, transfer, load, and validate a file.
- Number of snapshots, acceptable RPO, and off-host retention cost.

If RDB succeeds hourly, that does not guarantee that no writes from the previous hour can be lost. Failure can happen at any point, and the latest snapshot may be older than its nominal interval. Investigate `rdb_last_bgsave_status:err` or save warnings promptly.

## 4. Published operational experience

In a technical account of GitLab Geo, GitLab describes how retries in an early notification/job queue could fill Redis disk when the remote destination was unavailable, and in some cases require resynchronization. A later generation put part of the event queue and durable cursor in PostgreSQL so transactions and a persistent log made retry and restore easier to manage. This is not a report about RDB specifically. It shows that a snapshot alone does not create a durable event log or a complete disaster-recovery design. [GitLab: How we built GitLab Geo](https://about.gitlab.com/blog/how-we-built-gitlab-geo/)

## Safe lab

This lab creates a test key and reads persistence status:

```text
SET lab:rdb:message "before snapshot"
BGSAVE
INFO persistence
LASTSAVE
```

Do not report success until `rdb_bgsave_in_progress` is zero and `rdb_last_bgsave_status:ok` is visible. To test restore, load the file in a separate instance and test directory. This lab does not stop the server or move/overwrite a live file.

## Troubleshooting and common pitfalls

- **Assuming the snapshot has the latest write:** Check `rdb_last_save_time` and the actual RPO.
- **`BGSAVE` failed:** Check `INFO persistence`, server logs, disk space, directory permissions, and fork/OS errors.
- **The server refuses writes with `MISCONF`:** Fix the persistence failure. Do not set `stop-writes-on-bgsave-error no` merely to silence the warning.
- **RAM rises during a snapshot:** Measure copy-on-write and peak mutation; adjust headroom and scheduling.
- **The only backup is on the same volume:** Disk or host failure may destroy both live data and backup.
- **A replica is used as a backup:** Logical errors, `DEL`, or flushes can replicate. Keep an independent backup and run restore drills.
- **`SAVE` is run at peak:** Remember that synchronous work stops the server; do not improvise on production.

## Exercises

1. Read `CONFIG GET save` and explain each threshold pair in your own words.
2. Run `BGSAVE` in the lab and record persistence metrics before and after.
3. Set separate RPOs for a rebuildable cache and an important session store.
4. Write a daily-backup plan that includes versioning, checksums, off-host transfer, retention, and a restore test.

**Answer criteria:** Consider the last successful snapshot time, risk to writes after it, resource headroom, independent backup location, and recovery time.

## Quiz with answers

### 1. What does RDB create?

<details><summary>Answer</summary>

A point-in-time image of the dataset at the snapshot time.

</details>

### 2. What is the advantage of `BGSAVE` over `SAVE`?

<details><summary>Answer</summary>

Snapshot creation runs in the background; `SAVE` blocks the server until complete.

</details>

### 3. Why can RDB alone lose recent writes?

<details><summary>Answer</summary>

The file represents the last snapshot, so writes after that point are not in it.

</details>

### 4. What cost can copy-on-write create?

<details><summary>Answer</summary>

Higher memory pressure and CPU use during a snapshot, especially with frequent mutations.

</details>

### 5. Is a file on the same disk enough as a backup?

<details><summary>Answer</summary>

No. Keep a copy outside that failure domain and test restore.

</details>

### 6. How do you know whether the latest `BGSAVE` succeeded?

<details><summary>Answer</summary>

Inspect `INFO persistence`, including `rdb_last_bgsave_status` and the last-save time.

</details>

## References and further reading

### English: official documentation and engineering articles

- [Redis persistence documentation](https://redis.io/docs/latest/management/persistence/) — RDB snapshots and AOF overview.
- [BGSAVE command reference](https://redis.io/docs/latest/commands/bgsave/) and [SAVE command reference](https://redis.io/docs/latest/commands/save/).
- [INFO command reference](https://redis.io/docs/latest/commands/info/) — inspect the persistence section.
- [Redis common errors: MISCONF](https://redis.io/docs/latest/develop/reference/errors/common/misconf/) — snapshot failure and write protection.
- [Redis at Scale: persistence and durability](https://redis.io/tutorials/operate/redis-at-scale/persistence-and-durability/) — configuration and recovery walkthrough.
- [Redis latency optimization guide](https://redis.io/docs/latest/management/optimization/latency/) — persistence operations and latency investigation.
- [GitLab Geo engineering article](https://about.gitlab.com/blog/how-we-built-gitlab-geo/) — durable event/cursor design; not specifically an RDB case.

### فارسی

- [مرور فارسی RDB و AOF در Urhoba](https://www.urhoba.net/fa/post/redis-persistence-snapshot)
- [آموزش فارسی Redis در زبان سلام](https://www.salamlang.ir/std/db/redis/)
- [مرور فارسی ساختارها در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)

Persian articles cover copy-on-write and failure details less deeply. This lesson is self-contained for basic understanding and practice. Match operational settings to your version, operating system, and managed service.

</div>

