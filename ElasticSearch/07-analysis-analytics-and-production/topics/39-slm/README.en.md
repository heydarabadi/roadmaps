# Snapshot Lifecycle Management (SLM)

> Chapter 07: Analysis, Analytics, and Production · Lesson 39

[Read the Persian version](README.md)

## Learning goals

- Schedule recurring snapshots and retention through SLM policies.
- Monitor snapshot success, age, repository capacity, and policy status.
- Distinguish automated snapshot creation from a verified restore plan.

## Automate backup schedules

Snapshot Lifecycle Management can schedule snapshot creation and retention according to a policy. Define the snapshot repository, schedule, snapshot naming, selected indices or data streams, and retention. Monitor whether each snapshot succeeds and how old the most recent successful snapshot is. Repository capacity and access must also be observed.

~~~http
GET /_slm/status
GET /_slm/policy
~~~

SLM automates snapshot operations; it does not prove the resulting backup can satisfy a recovery objective. Run restore drills separately, test the data and relevant feature state, and record RPO/RTO. Avoid aggressive retention deletion that could remove the only recoverable copy. Keep policy ownership and alert routing clear.

## Exercise

Create a daily policy for a lab repository with a short retention window. Simulate or observe a failed snapshot, then build an alert for the last successful snapshot exceeding your RPO. Restore one scheduled snapshot to a separate test environment.

## Quiz with answers

1. **What does SLM automate?** Snapshot scheduling and retention based on policy.
2. **Does SLM replace ILM?** No. SLM manages snapshots; ILM manages index lifecycle actions.
3. **What should trigger a backup alert?** Snapshot failures, repository problems, or the age of the last successful snapshot exceeding the objective.
4. **Does a successful SLM run prove restore works?** No; restore validation is a separate requirement.

## References and further reading

- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — SLM and repository concepts.
- [Snapshot lifecycle management](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/snapshot-lifecycle-management) — policies and retention.
- [SLM APIs](https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-slm) — policy and status endpoints.
- [Restore from snapshot](https://www.elastic.co/docs/troubleshoot/elasticsearch/restore-from-snapshot) — practice recovery.
- [ILM](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management) — compare index retention policies.
- Persian discovery search (not a verified article): [Persian Elasticsearch SLM tutorials](https://www.google.com/search?q=Elasticsearch+SLM+snapshot+lifecycle+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

