<div dir="ltr" align="left">

# Microkernel Pattern

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/08/architectural-patterns/topics/microkernel/README.md)

> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.



**Location in the roadmap:** [Architecture Patterns](../../README.md) · [Course Index](../../../../00-index.md)

## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.

## Core idea

A small core provides stable functionality, and plugins add replaceable features. The extension contract is a vital point.


## Practical example

The reporting tool has core authentication and workflow, and CSV/PDF output plugins are added.

This example is educational and does not claim to be an exact implementation for a specific company. A documented industrial example and its background are linked in the "Architectural Patterns" chapter.

## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Plugin versioning and runtime compatibility require ongoing testing and maintenance.
- **Revision:** Do not fix plugin architecture for multiple features. Define the security and failure model of the extension.

## Quiz with descriptive answer

Hide the suggested answer first. Explain the idea in your own words, then compare your reasoning with the model answer.

1. What exactly does this concept solve?
   - Suggested answer: small core provides stable functionality and plugins add replaceable features. The extension contract is a vital point.
2. **What decision do you make in the example below and why?**
   - Suggested answer: The reporting tool has an authentication core and workflow, and CSV/PDF output plugins are added.
3. **When is it inappropriate or expensive to choose?**
   - Suggested answer: Plugin versioning and runtime compatibility require ongoing testing and maintenance.
4. **Which common error do you check before merging the code?**
   - Suggested answer: don't fix the plugin architecture for multiple features. Define the security and failure model of the extension.

## In-depth lesson for this topic

### 5. Microkernel

Microkernel has a small and stable kernel and transfers variable capabilities to plugins or extensions. This template is good for platforms that have third-party extensions or true edition-specific products.

Plugin boundary should have version, permission, lifecycle, error and resource limit. Plugins are only useful when we develop or install behavior outside of core. If all plugins are always released with the app itself, the built-in module might be simpler.
## Architecture diagram and walkthrough

A microkernel combines a small, stable core with extensible plugins. The core owns plugin contracts and lifecycle; define version compatibility, permissions, plugin failure behavior, and isolation costs.


**Common pitfall:** Do not make every feature a plugin; a bloated core or tightly coupled plugins erode the benefit.


**Exercise with answer:** Reject an incompatible plugin at load time by validating its manifest and version constraints before activation.

This is a simplified view; production design must also state ownership, failure, security, and operational constraints.

~~~text
       [Plugin A]       [Plugin B]
            \              /
             v            v
        [Extension contracts]
                 |
            [Microkernel]
                 |
           [Core services]
~~~

## Architecture diagram and walkthrough

A microkernel extends a stable core with plugins. The core owns plugin contracts, permissions, and lifecycle; define version compatibility, plugin failures, and isolation.


**Common pitfall:** If the core contains every feature or plugins are tightly coupled, microkernel adds complexity without flexibility.


**Exercise with answer:** A plugin targets an incompatible version; validate its manifest and reject it before activation.

This simplified view should be supplemented with explicit ownership, failure, security, and operational decisions.

~~~text
       [Plugin A]       [Plugin B]
            \              /
             v            v
        [Extension contracts]
                 |
            [Microkernel]
                 |
           [Core services]
~~~


## Resources

### Persian

- [Persian Guide to Domain-Oriented Design](https://github.com/hheydarian/Understanding-Domain-Driven-Design) — Structured Persian guide to DDD, Common Language and Modeling.
- [DNTips; Software layering architecture](https://www.dntips.ir/post/1264/معماری-لایه-بندی-نرم-افزار-3) — Persian examples in application and data layer.

### English

- [Microsoft Learn; DDD-oriented microservice](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/ddd-oriented-microservice) — domain boundary, layers and domain model.
- [Martin Fowler; CQRS](https://martinfowler.com/bliki/CQRS.html) — CQRS definition and warning about additional complexity.
- [Martin Fowler. Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) — Logging changes as events and replay considerations.

## Summary

Apply the microkernel pattern to solve a specific problem, record the trade-off, and check with visible tests or relevant operational measures whether the design has improved the intended quality.


## Further reading

[Curated references for this chapter](../../../../references.md#chapter-08)
</div>
