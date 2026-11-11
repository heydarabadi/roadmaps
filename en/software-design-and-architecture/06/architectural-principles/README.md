<div dir="ltr" align="left">

# Chapter 06: Architectural Principles

> **Language:** [Read the Persian edition](../../../../fa/software-design-and-architecture/06/architectural-principles/README.md)

> [Open the integrated lesson](lessons.md) for boundaries, policy and detail, component principles, coupling and cohesion, documented case studies, and an answered quiz.

## What you will learn

- Describe architecture through boundaries, dependencies, control flow, and data ownership.
- Separate stable policy from implementation detail and choose a dependency direction that protects policy.
- Use cohesion, coupling, and component principles to reason about change and release boundaries.
- Evaluate architecture against required quality attributes and evidence about change, operation, and team ownership.

## Topic lessons

- [Architectural Principles](topics/architectural-principles/README.md)
- [Component Principles](topics/component-principles/README.md)
- [Policy versus Detail](topics/policy-vs-detail/README.md)
- [Coupling and Cohesion](topics/coupling-cohesion/README.md)
- [Boundaries](topics/boundaries/README.md)

## How to study this chapter

For a proposed boundary, name the policy it protects, the data it owns, the contract it exposes, and the quality attribute it is meant to improve. Consider the costs too: versioning, coordination, deployment, testing, monitoring, and recovery. A process or network boundary is justified only when its benefits outweigh those costs for the system in question.

Shopify’s modularization reports and the Prime Video monitoring-service report are included as bounded case studies. The [reference library](../../references.md#chapter-06) records their sources and context; the Prime Video finding concerns that particular service and should not be generalized to all systems.

## Practice and references

Complete the exercise and quiz in [the integrated lesson](lessons.md). Use the [curated bilingual reference library](../../references.md#chapter-06) for architecture documentation, decision records, Persian materials, and further industry reports.
</div>
