# Chapter 5 — Reliability and Scale

> **Persian edition:** [Read the Persian version](../../../fa/mongodb/05-reliability/README.md).

## Lessons

- [Backup and recovery](backup-recovery/README.md) — set RPO/RTO and test a restore.
- [Replica sets and failover](replication/README.md) — understand elections, replication lag, and read policies.
- [Sharding, scaling, and tuning](sharding-scaling/README.md) — evaluate distribution and routing before choosing a shard key.
- [Multi-document transactions](transactions/README.md) — use transactions for cross-document invariants.
- [Transactions, atomicity, and read/write concerns](transactions-concerns/README.md) — select consistency and retry behavior to match the application.

## Chapter exercise

Write a failure plan for one checkout: unavailable primary, unknown commit outcome, duplicate request, failed backup, and a search index that must be rebuilt. For each case, name the invariant, retry rule, and recovery evidence.
