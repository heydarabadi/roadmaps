# Index Lifecycle Management (ILM)

> Chapter 07: Analysis, Analytics, and Production · Lesson 32

[Read the Persian version](../../../../../fa/elasticsearch/07-analysis-analytics-and-production/topics/32-ilm/README.md)

## Learning goals

- Define phases and actions for an index's lifecycle.
- Attach policy through an index template, alias, or data stream design.
- Inspect policy execution rather than assuming a configured policy is active.

## Automate data lifecycle

Index Lifecycle Management policies can move managed indices through phases such as hot, warm, cold, and delete, and perform actions such as rollover or force merge where appropriate. The exact actions and tier support depend on Elasticsearch version and deployment type. A policy must be associated with the relevant index or data stream through the intended template or lifecycle configuration; creating a policy alone does not prove it is applied.

~~~http
GET /events-*/_ilm/explain
~~~

Inspect current phase, action, step, and errors. For time-series data, age often relates to when an index rolled over rather than the timestamp of every document. Before any delete phase, review retention, legal obligations, snapshot coverage, and restore requirements. Test policy transitions on a lab data stream and check all prerequisites before production rollout.

## Exercise

Design a policy for event data with a rollover threshold, an older low-cost phase, and a defined delete age. Attach it through a template to a disposable data stream. Use ILM explain to confirm each phase and record the intended age origin.

## Quiz with answers

1. **What does ILM manage?** Lifecycle actions and phase transitions for indices or data-stream backing indices.
2. **Does defining a policy apply it automatically?** No; it must be attached to the appropriate index or template.
3. **How can policy execution be diagnosed?** Use ILM explain and inspect the current step and errors.
4. **What must be reviewed before a delete phase?** Retention requirements, ownership, backup/restore, and the policy's age semantics.

## References and further reading

- [Index lifecycle management](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management) — phases and actions.
- [ILM explain API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ilm-explain-lifecycle) — inspect policy progress.
- [Rollover action](https://www.elastic.co/docs/reference/elasticsearch/index-lifecycle-actions/ilm-rollover) — create the next write index.
- [Data tiers](https://www.elastic.co/docs/manage-data/lifecycle/data-tiers) — automatic tier movement.
- [Snapshot and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore) — protect data before retention deletes.
- Persian discovery search (not a verified article): [Persian Elasticsearch ILM tutorials](https://www.google.com/search?q=Elasticsearch+ILM+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

