<div dir="ltr" align="left">

# Chapter 08: Architectural Patterns

> **Language:** [Read the Persian edition](../../../../fa/software-design-and-architecture/08/architectural-patterns/README.md)

> [Open the integrated lesson](lessons.md) for DDD, MVC, microservices, CQRS, event sourcing, messaging, worked examples, and an answered quiz.

## What you will learn

- Identify the recurring problem and forces addressed by an architectural pattern.
- Explain how DDD, MVC, microservices, SOA, serverless, and microkernel designs assign responsibilities and boundaries.
- Describe the consistency, replay, coordination, and operational concerns introduced by CQRS, event sourcing, queues, and streams.
- Select patterns based on domain, scale, team, and operating needs rather than popularity.

## Topic lessons

- [Domain-Driven Design (DDD)](topics/domain-driven-design/README.md)
- [Model-View-Controller (MVC)](topics/mvc/README.md)
- [Microservices](topics/microservices/README.md)
- [Blackboard Pattern](topics/blackboard/README.md)
- [Microkernel Pattern](topics/microkernel/README.md)
- [Serverless Architecture](topics/serverless/README.md)
- [Message Queues and Streams](topics/queues-streams/README.md)
- [Event Sourcing](topics/event-sourcing/README.md)
- [Service-Oriented Architecture (SOA)](topics/soa/README.md)
- [Command Query Responsibility Segregation (CQRS)](topics/cqrs/README.md)

## How to study this chapter

For each pattern, state the problem it is intended to solve and the decision it moves into a boundary. Then trace the data and control flow, including failure, consistency, retries, and recovery. Patterns such as CQRS and event sourcing can be valuable, but they bring additional contracts and operational work; choose them only when those costs solve an observed need.

## Practice and references

Complete the scenario exercise and quiz in [the integrated lesson](lessons.md). The [curated bilingual reference library](../../references.md#chapter-08) includes Microsoft architecture material, Martin Fowler articles, Persian DDD and event-driven resources, and implementation examples.
</div>
