<div dir="ltr" align="left">

# Chapter 5 — Persistence, Backups, and Recovery

> Persian edition: [فصل ۵ — ماندگاری، backup و بازیابی](./README.md) · Suggested time: 4–6 hours, plus one lab restore drill.

“Redis restarted” is not a complete recovery plan. RPO, RTO, valid backup files, version compatibility, and a tested restore path must be designed together.

## Concepts before the lessons

- **Persistence:** writes state to disk so it can be loaded after a restart.
- **Backup:** an independently recoverable copy; a file on the same disk is not an off-host backup.
- **RPO:** the maximum amount or time window of lost data the business accepts.
- **RTO:** the maximum time to return the service to an acceptable state.
- **Restore drill:** a real restore in an isolated environment, with data validation and timing.

## Lesson order

1. [Choose persistence modes](./persistence-modes/README.en.md): compare no persistence, RDB, AOF, and combinations against data importance and risk tolerance.
2. [RDB snapshots](./rdb/README.en.md): point-in-time snapshots, `BGSAVE`, fork/copy-on-write cost, and file handling.
3. [AOF](./aof/README.en.md): append logs, fsync policies, rewrite, and damaged tail recovery.
4. [Backup and restore](./backup-restore/README.en.md): independent copies, checksums, transfer, isolated restore, and a runbook.

## From requirement to configuration

Suppose an order counter may lose at most one second of writes and the service must recover within 15 minutes. That is not yet a configuration. Determine dataset size, load time, persistence mode, off-host backup schedule, write latency, failure domains, and application dependencies. A highly durable AOF policy may add write cost; an RDB may not include changes since the last snapshot. A backup is proven by restoring it, not by seeing a file with a familiar name.

## Required chapter output

For a cache, a session, and order state, write a table with: source of truth, acceptable loss, RPO, RTO, RDB/AOF/rebuild path, backup location, encryption, checksum, restore steps, and runbook owner. If Redis contains only rebuildable cache, persistence may be unnecessary. For operationally important data, record and test the decision.

## Review quiz

1. What is the difference between replication and a backup?
2. Why is an RDB file on the same volume not an off-site backup?
3. How do you prove that a backup can be restored?
4. Which metric measures recovery time, and which describes acceptable data loss?

<details><summary>Answer guide</summary>

A replica can copy accidental deletion or corruption; a backup provides a separate point-in-time copy. A volume may share the same disk or host failure domain. Restore into an isolated instance, check integrity and expected data, and measure the time. RTO measures time to recovery; RPO describes the acceptable amount/time window of lost data.

</details>

## Chapter exit criterion

Restore a backup in a lab, read expected data, and record the steps and elapsed time. Running `BGSAVE` or noticing an `appendonly.aof` file does not prove disaster recovery.

## Further reading

- [Redis persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
- [RDB persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/#rdb)
- [AOF persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/#aof)
- [Redis backup and restore patterns](https://redis.io/docs/latest/operate/oss_and_stack/management/backup/)
- [Persian article on Redis snapshots](https://www.urhoba.net/fa/post/redis-persistence-snapshot)

</div>
