<div dir="ltr" align="left">

# Chapter 09: Enterprise Application Patterns

> **Language:** [Read the Persian edition](../../../../fa/software-design-and-architecture/09/enterprise-patterns/README.md)

> [Open the integrated lesson](lessons.md) for application, domain, and data-access patterns, a worked order example, exercises, and an answered quiz.

## What you will learn

- Explain how patterns clarify responsibilities and contracts among use cases, domain rules, and persistence.
- Choose between a transaction script and a behavior-rich domain model based on rule complexity and change.
- Distinguish entities, value objects, DTOs, commands, queries, repositories, mappers, and identity maps.
- Evaluate query, mapping, transaction, and maintenance costs introduced by an ORM or persistence abstraction.

## Topic lessons

- [Data Transfer Object (DTO)](topics/dto/README.md)
- [Identity Map](topics/identity-map/README.md)
- [Use Cases](topics/use-cases/README.md)
- [Repository](topics/repositories/README.md)
- [Mappers](topics/mappers/README.md)
- [Transaction Script](topics/transaction-script/README.md)
- [Commands and Queries](topics/commands-queries/README.md)
- [Value Objects](topics/value-objects/README.md)
- [Domain Models](topics/domain-model-enterprise/README.md)
- [Entities](topics/entities/README.md)
- [Object-Relational Mappers (ORMs)](topics/orms/README.md)

## How to study this chapter

Follow an order operation from its external request through use-case coordination, domain rules, and persistence. At each boundary, name the data contract and the owner of its invariants. Compare a direct query or transaction script with added repositories, mapping layers, or an ORM; keep the extra abstractions only when they make change, testing, or persistence behavior easier to control.

## Practice and references

Complete the order scenario and quiz in [the integrated lesson](lessons.md). The [curated bilingual reference library](../../references.md#chapter-09) includes Martin Fowler’s enterprise-pattern catalog, Microsoft persistence guidance, and Persian learning sources.
</div>
