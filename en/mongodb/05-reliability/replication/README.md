# Replica Sets and Failover

> **Persian edition:** [Read this lesson in Persian](../../../../fa/mongodb/05-reliability/replication/README.md).

> **Learning goal:** Understand primary/secondary replication, elections, lag, and the application behavior required during failover.

## How a replica set works

A replica set is a group of `mongod` processes that maintain the same dataset. The primary accepts ordinary writes and records changes in its oplog. Secondary members apply those operations. If the primary becomes unavailable, eligible members hold an election and one can become the new primary.

## What failover means to an application

During an election, writes may fail or time out briefly. Use a topology-aware connection string so the driver can discover members and a new primary. A direct connection to one fixed node can prevent normal discovery and failover behavior. Handle selection timeouts and retry only operations that are safe to retry.

~~~javascript
rs.status()
rs.conf()
~~~

These `mongosh` commands inspect status and configuration; they do not replace monitoring or a recovery plan.

## Reads from secondaries

Read preference can send some reads to secondaries and reduce primary load, but asynchronous replication means the result may be stale. A page that must show the state immediately after a purchase may need read-your-writes behavior. A less time-sensitive report may accept lag. Choose per use case, not as a global performance shortcut.

## Voting members and failure domains

Elections depend on votes and connectivity. Putting every voting member in one host or availability zone does not protect against loss of that failure domain. A distant member may add network latency and replication lag. Design votes, priority, geography, and any arbiter around the supported deployment topology rather than copying an arbitrary example.

## Monitor and rehearse

Monitor member state, election frequency, replication lag, oplog window, disk latency, CPU, connections, and backup outcomes. Rehearse a primary loss and confirm application retry behavior. Replication improves availability; it is not a backup because accidental deletes and corrupt writes can replicate too.

## Exercises

1. Draw a three-member replica set across failure domains.
2. Choose a read policy for a product listing and a just-completed purchase.
3. Describe how an application should respond while a new primary is elected.

## Common mistakes

- Treating a secondary as an independent backup.
- Ignoring stale reads when using secondary read preference.
- Placing all voters in the same failure domain.
- Connecting the application directly to one fixed member.
- Failing to alert on lag or repeated elections.

## Quiz and answer key

1. **What does the primary do?** Accepts ordinary writes.
2. **How do secondaries learn changes?** They read and apply the oplog.
3. **Is replication a backup?** No. Unwanted changes replicate too.
4. **Why should a secondary not be called a backup?** Replication copies the same unwanted deletes or corrupt writes; keep independent backups and test restores.
5. **Applied task: draw a three-member set.** Place voters across appropriate failure domains, provide a topology-aware driver connection, and rehearse election behavior.
6. **What may happen during an election?** Temporary write failures or timeouts while a new primary is selected.
7. **What is the risk of reading from a secondary?** It may lag behind the primary.
8. **Why use an SRV or replica-set connection URI?** It enables topology discovery and failover handling by the driver.
9. **What does an oplog window affect?** How far behind a member can fall and still catch up from retained operations.
10. **Which signals should be monitored?** Member states, elections, lag, oplog window, storage and resource health, and backups.

## Further reading

- [Replication](https://www.mongodb.com/docs/manual/replication/)
- [Replica Set Elections](https://www.mongodb.com/docs/manual/core/replica-set-elections/)
- [Replica Set Read and Write Semantics](https://www.mongodb.com/docs/manual/applications/replication/)
- [Replica Set Members](https://www.mongodb.com/docs/manual/core/replica-set-members/)
- [Persian replica set guide — Urhoba](https://www.urhoba.net/fa/post/mongodb-6)
- [Curated reference library: replication](../../reference-library.md#reliability-replication)

---
Sources reviewed: 2026-11-11. Topology and election behavior depend on deployment configuration.
