<div dir="ltr" align="left">

# Chapter 07: Architectural Styles

> **Language:** [Read the Persian edition](../../../../fa/software-design-and-architecture/07/architectural-styles/README.md)

> [Open the integrated lesson](lessons.md) for styles, communication choices, distributed-system failure modes, practical examples, and an answered quiz.

## What you will learn

- Explain how a style constrains component types and relationships, and how those constraints affect quality attributes.
- Compare layered, component-based, monolithic, client-server, peer-to-peer, and distributed arrangements.
- Distinguish events, messages, queues, and streams, including delivery and failure trade-offs.
- Choose a style based on workload, teams, deployment, security, reliability, and operating requirements.

## Topic lessons

- [Architectural Styles](topics/architectural-styles/README.md)
- [Component-Based Architecture](topics/component-based/README.md)
- [Monolithic Architecture](topics/monolithic/README.md)
- [Layered Architecture](topics/layered/README.md)
- [Structural Styles](topics/structural-style/README.md)
- [Event-Driven Architecture](topics/event-driven/README.md)
- [Publish-Subscribe](topics/publish-subscribe/README.md)
- [Messaging](topics/messaging/README.md)
- [Client-Server](topics/client-server/README.md)
- [Peer-to-Peer](topics/peer-to-peer/README.md)
- [Distributed Systems](topics/distributed/README.md)

## How to study this chapter

Start by drawing components and their communication paths. Mark where state lives, which failures can cross a boundary, and what happens when a dependency is slow or unavailable. Compare candidate styles against a concrete workload and deployment model. Most production systems combine structural ideas; explain each choice instead of trying to find one style that answers every concern.

The Shopify modular-monolith reports and the Prime Video monitoring-service report are examples from particular organizations. The [reference library](../../references.md#chapter-07) also includes primary architecture documentation and Persian reading. The Prime Video result applies to the service and workload described in that report.

## Practice and references

Complete the exercise and quiz in [the integrated lesson](lessons.md). Continue with the [curated bilingual reference library](../../references.md#chapter-07) for architecture styles, queues, distributed failures, and industry reports.
</div>
