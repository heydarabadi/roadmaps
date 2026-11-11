# Backup and Recovery

> **Persian edition:** [Read this lesson in Persian](../../../05-reliability/backup-recovery/readme.md).

> **Learning goal:** Design backups around recovery objectives and prove they work by restoring them.

## Define recovery before choosing a tool

- **RPO (Recovery Point Objective):** how much recent data the business can lose.
- **RTO (Recovery Time Objective):** how long service can remain unavailable.

Write these targets for each dataset and service tier. A daily backup may meet a 24-hour RPO but cannot meet a five-minute RPO without a more frequent or continuous recovery mechanism. The backup interval, retention, encryption, off-site copy, and restore duration all matter.

## Backup options

- Atlas automated backups and point-in-time options depend on cluster tier and settings.
- `mongodump`/`mongorestore` are logical database tools that export and reload BSON collections and metadata.
- Filesystem or storage snapshots need a consistent capture method and a tested restore process.
- A replica set increases availability but does not protect against an accidental delete or destructive application write.

Choose a method based on dataset size, consistency requirements, portability, restore time, and operational skill. For a sharded cluster, use a backup approach that preserves a consistent point across shards.

## Logical backup example

~~~bash
mongodump --uri="$MONGODB_URI" --archive=learning.archive.gz --gzip --db=learning
mongorestore --uri="$RESTORE_URI" --archive=learning.archive.gz --gzip --nsFrom='learning.*' --nsTo='learning_restore.*'
~~~

Use a protected secret source for URIs. Restore into an isolated target, not over production. Verify the namespace mapping and inspect the restored database before cutover. A dump command completing successfully is not evidence that the recovery objective is met.

## The restore drill

1. Create a backup and record its time, source, and encryption status.
2. Restore into an isolated environment using the documented runbook.
3. Check collection counts, indexes, sample records, and application behavior.
4. Measure actual restore time and data loss window against RTO/RPO.
5. Record failures and update both the procedure and owner list.
6. Repeat periodically and after major topology or version changes.

Protect backup credentials, restrict who can restore, keep copies independent from the primary environment, and define retention and deletion. A backup that no one can decrypt or restore is not a recovery plan.

## Practical case

MongoDB's published Victoria’s Secret story discusses Atlas operations including backup automation. Use it to ask which tasks are managed and which recovery responsibilities still belong to the application team. It is not an independent benchmark. [Victoria’s Secret story](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret)

## Common mistakes

- Treating replication as the only backup.
- Assuming a successful backup job proves that a restore will work.
- Storing backup files beside the only database copy.
- Forgetting indexes, users, configuration, or encryption keys.
- Never measuring restore time against the stated RTO.

## Exercises

1. Set RPO and RTO for an online shop and a reporting archive.
2. Choose a backup plan for each and justify interval, retention, and restore method.
3. List five checks to run after restore.

## Quiz and answer key

1. **What does RPO describe?** The maximum acceptable data-loss window.
2. **What does RTO describe?** The maximum acceptable time to restore service.
3. **Does replication replace a backup?** No. Deletions and bad writes can replicate.
4. **Why does every backup plan need a restore drill?** A backup may be incomplete, unreadable, or too slow to restore; only a drill reveals whether objectives are met.
5. **Applied task: plan a store backup.** Define RPO/RTO, retention, protected copies, credentials and encryption, then restore into an isolated environment and validate data.
6. **What does `mongodump` produce?** A logical export of database data and metadata.
7. **Why restore to an isolated target first?** To validate recovery without overwriting active data.
8. **What extra concerns apply to sharded backup?** Coordinating a consistent recovery point across shards and preserving configuration/metadata.
9. **What if an encryption key is lost?** Encrypted backup data may become unrecoverable.
10. **What should be measured during a drill?** Actual restore duration, data-loss window, and correctness checks.

## Further reading

- [Backup and Restore with MongoDB Tools](https://www.mongodb.com/docs/manual/tutorial/backup-and-restore-tools/)
- [mongodump](https://www.mongodb.com/docs/database-tools/mongodump/)
- [mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/)
- [Atlas Backup](https://www.mongodb.com/docs/atlas/backup/cloud-backup/overview/)
- [MongoDB Backup and Restore](https://www.mongodb.com/docs/manual/core/backups/)
- [Percona Backup for MongoDB documentation](https://docs.percona.com/percona-backup-mongodb/)
- [Persian MongoDB backup series — Urhoba](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [Curated reference library: backup and recovery](../../reference-library.md#reliability-replication)

---
Sources reviewed: 2026-11-11. Backup capabilities and commands depend on edition, topology, and version.
