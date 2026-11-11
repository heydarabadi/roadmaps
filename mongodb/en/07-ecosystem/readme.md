# Chapter 7 — Tools and Ecosystem

> **Persian edition:** [Read the Persian version](../../07-ecosystem/readme.md).

## Lessons

- [Change Streams and event-driven systems](./change-streams/readme.md) — consume events with durable checkpoints, idempotency, and resynchronization.
- [Kafka, Spark, and Elasticsearch connectors](./connectors-detail/readme.md) — understand connector ownership and delivery semantics.
- [Developer tools](./developer-tools/readme.md) — choose shell, GUI, and backup tools for each task.
- [Drivers and connectors](./drivers-connectors/readme.md) — manage pools, timeouts, retries, and data pipelines.
- [Language drivers and connection pools](./language-drivers/readme.md) — use official drivers and a stable application lifecycle.

## Design exercise

Draw one application connection and one event pipeline. Label who owns each component, where retries happen, how duplicates are handled, and how the destination can be rebuilt.
