<div dir="ltr" align="left">

# Keep Core Rules Independent of Framework Details

> **Language:** [Read the Persian edition](../../../../../../fa/software-design-and-architecture/01/clean-code/topics/framework-distance/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Identify domain rules that depend unnecessarily on a web framework, ORM, or vendor SDK; describe how an adapter or contract can isolate that dependency; and weigh the benefit against the extra mapping and abstraction work.

## The idea

A framework can be a productive way to build an application. The problem arises when a framework’s request objects, annotations, base classes, or lifecycle rules become part of domain policy even though the policy does not need them.

A useful separation might have a controller translate a request into a use-case input, the use case coordinate application work, and the domain model protect its invariants. A payment or storage adapter can implement the contract the application needs. These boundaries may be packages in one project; extra services or assemblies are not required by the principle.

Source-code dependencies and runtime calls may point in different directions:

```text
Source dependencies:
[Order policy] ---> [Payment contract] <--- [Vendor adapter] ---> [Provider SDK]

Runtime calls:
[Order policy] ---> [Payment contract] ---> [Vendor adapter] ---> [Provider SDK]
```

The application owns the contract, while the adapter translates it to the provider’s API. A framework can still be used directly at the outer boundary when that keeps the implementation simpler.

## Choosing a boundary

Isolate a dependency when it changes independently, prevents meaningful policy tests, or must be replaced without changing the domain rule. For time-sensitive behavior, passing a timestamp or a small clock abstraction can make tests deterministic. Do not introduce an interface for every class; if a dependency is stable and causes no testing or change pressure, a direct call may be clearer.

## Trade-offs and practice

Adapters, mapping, and contracts require maintenance. Hiding useful framework features can also add unnecessary work. Draw the dependencies around one use case and label each as policy or implementation detail. Then write a rule test without starting the web server or database, and explain which integration test is still needed for the real adapter.

## Quiz with answers

1. **Which rules should be kept independent of framework details?**
   **Answer:** Domain and application policies that do not need those details, especially when a tool change would otherwise force unrelated rule changes.

2. **Should every framework be hidden behind an abstraction?**
   **Answer:** No. Abstractions cost code and maintenance. Isolate a real change boundary, test seam, or policy dependency.

3. **What may indicate that a domain rule is too tightly coupled to infrastructure?**
   **Answer:** The rule cannot be tested without starting the ORM or web server, or changing the framework forces the rule itself to change.

4. **Does a unit test of the use case prove that a payment provider works?**
   **Answer:** No. It can test the policy against a contract. An adapter or integration test is needed to check the provider interaction.

## Further reading

- [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) — Dependency direction around stable policy.
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
