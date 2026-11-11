# Stateful Applications
[Persian edition](README.md) · [Chapter references](../../../references/README.en.md#11-storage-and-volumes)

[فارسی](README.md) | [Chapter 11](../../README.en.md)

## Where does state live?

A stateful application has durable data or local identity. Safe operation requires understanding storage, consistency, membership, leader election, replication, backup, restore, and upgrades. A StatefulSet provides ordinal names and claims; it does not replace the database protocol.

## Operational design
- Read the database's own documentation for replication and quorum behavior.
- Practice node, zone, and volume failures separately.
- Distinguish crash-consistent from application-consistent snapshots.
- Keep backups in a separate failure domain and preferably immutable.
- Define RPO, RTO, retention, and restore procedure.
- Upgrade in stages and plan data rollback separately.
- Monitor replication lag, disk use, and backup age.

## Example

A healthy PostgreSQL Pod is not enough. Know how a primary is elected, how replicas catch up, who takes backups, where WAL is stored, and how to recover from a lost volume. If the team cannot operate that lifecycle, a managed database may be a better choice.

## Quiz
1. **What does StatefulSet provide?** Stable identity and volume association for replicas.
2. **What remains the database's responsibility?** Consistency, quorum, replication, and recovery.
3. **Why isn't a snapshot sufficient by itself?** Restore and snapshot consistency must be tested.
4. **Which backup measures should be defined?** RPO, RTO, retention, and restore drills.

## Further reading
- [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [Storage concepts](https://kubernetes.io/docs/concepts/storage/)
- [Volume snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)
- [CSI snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/)
- [Stateful application example](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)
