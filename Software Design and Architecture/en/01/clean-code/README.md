<div dir="ltr" align="left">

# Chapter 01: Clean Code

> **Language:** [Read the Persian edition](../../../01/clean-code/README.md)

## What you will learn

By the end of this chapter, you should be able to:

- Make code easier to understand, change, and review without treating short lines or personal style as ends in themselves.
- Choose names, types, functions, and module boundaries that make intent and constraints visible.
- Reduce unnecessary decision paths and isolate side effects so that behavior is easier to test.
- Keep tests reliable by removing dependencies on execution order, clocks, networks, and leftover data.
- Explain the trade-offs behind a refactoring and identify evidence that would justify a larger boundary.

## The central idea

Clean code reduces the effort and risk involved in understanding and changing software. “Clean” is not a universal formatting style, a fixed maximum line count, or a demand to create an abstraction for every repeated expression. It is a set of choices that helps a teammate discover what the code does, where a rule belongs, and how a change can be made safely.

These choices operate at different levels. Names and control flow help within a function. Types and interfaces clarify contracts. Modules group rules that change together. Tests provide evidence that behavior still holds. Architecture begins when decisions about ownership, dependencies, deployment, or communication cross component boundaries. Start at the smallest level that addresses the actual problem, then move outward only when the evidence calls for it.

## Learning path and topic lessons

Read the topics in this order. First make code locally readable; then clarify units, effects, and decision paths; finally connect those choices to testing and refactoring.

1. [Consistency](topics/consistency/README.md) — Agree on naming, formatting, error handling, and file organization so that routine differences do not slow down reading or review.
2. [Meaningful names](topics/meaningful-names/README.md) — Use names that reveal intent, domain meaning, and units. Write comments to explain important reasons or constraints, not to narrate the syntax.
3. [Indentation and code style](topics/indentation-style/README.md) — Use consistent formatting to make blocks and control flow visible at a glance.
4. [Small, cohesive units](topics/small-units/README.md) — Keep functions, classes, and files focused around related behavior; size alone is not a measure of quality.
5. [Pure functions](topics/pure-functions/README.md) — Isolate calculations from clocks, networks, files, randomness, and shared state to make reasoning and tests simpler.
6. [Cyclomatic complexity](topics/cyclomatic-complexity/README.md) — Reduce or clarify independent decision paths so that fewer cases need to be understood and tested at once.
7. [Avoiding ambiguous nulls and booleans](topics/avoid-null-booleans/README.md) — Make optional data and behavioral choices explicit in types, named options, or distinct operations.
8. [Keeping core logic independent of frameworks](topics/framework-distance/README.md) — Keep domain rules from depending unnecessarily on framework annotations, request objects, or lifecycle details.
9. [Choosing appropriate language constructs](topics/right-constructs/README.md) — Use types, enums, collections, and control structures to express valid states and operations clearly.
10. [Fast, independent tests](topics/fast-independent-tests/README.md) — Make tests deterministic and independent of order, wall-clock time, network availability, and residual state.
11. [Organizing code around ownership](topics/organize-by-actor/README.md) — Group rules around the role, business capability, or team that owns and changes them.
12. [Command-query separation (CQS)](topics/command-query-separation/README.md) — Make it clear whether an operation changes state or returns information. This does not by itself require separate services or databases.
13. [Simplicity and continuous refactoring](topics/simple-refactor/README.md) — Keep the design proportionate to current needs, improve it in small steps, and preserve behavior with tests.

Each topic page is a standalone lesson with explanations, examples, limitations, practice questions, and an answered quiz. The integrated exercise below connects them.

## An integrated example: changing an order cancellation rule

Suppose a store changes its order-cancellation policy. A useful design conversation starts with questions rather than a pattern name:

1. **What changes?** Identify the policy, the states of an order, and any deadlines or payment consequences.
2. **Who owns the rule?** Put the decision with the domain behavior that can enforce it consistently; do not make the controller the only place that knows the policy.
3. **What is the smallest clear boundary?** A cohesive module and a direct test may be enough inside one application.
4. **What evidence would justify more separation?** Independent team ownership, release cadence, scaling, security, or fault-isolation needs may justify a component or service boundary. Each adds contracts, deployment work, monitoring, and failure modes.
5. **How will we know the change helped?** Compare review and change time, regressions, boundary violations, deployment impact, and operating cost against the original problem.

The point is not that one boundary is always correct. A controller calling a policy object may be sufficient today; independent deployment may be useful later if separate ownership and operational evidence support it.

### A small pure calculation

```python
from decimal import Decimal

def subtotal(lines):
    return sum(
        (line.quantity * line.unit_price for line in lines),
        Decimal("0"),
    )
```

This calculation reads only its input and returns a value. It does not read the clock, query a database, or send a message. That makes it straightforward to test for empty orders, multiple lines, decimal precision, and invalid quantities. The function is not “clean” merely because it is short; its input-output contract is explicit and the behavior is isolated.

## Documented industry experience

Shopify has published accounts of modularizing a large Rails application. The reports describe how explicit component boundaries and dependency checks helped teams reason about ownership and change within a shared codebase. Read them as reports about Shopify’s stated goals, design, and operating context—not as proof that every organization should use the same tools or structure.

- [Shopify Engineering: Deconstructing the Monolith](https://shopify.engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity) — The original account of the modularization effort and its goals.
- [Shopify Engineering: Under Deconstruction](https://shopify.engineering/shopify-monolith) — A follow-up on the modular monolith and the company’s continuing work.
- [Shopify Engineering: Enforcing Modularity with Packwerk](https://shopify.engineering/enforcing-modularity-rails-apps-packwerk) — A description of tooling used to make some module boundaries enforceable.

When reading a company case study, record the original problem, the scale and team structure, the alternatives considered, the costs introduced, and the outcomes the authors actually measured. Separate reported observations from your own conclusions.

## Common mistakes

- Treating a rule of thumb—such as “all functions must be tiny”—as a universal acceptance criterion.
- Merging code solely because its syntax looks similar, even when the business rules have different owners or change for different reasons.
- Introducing interfaces, layers, services, or queues before a real change pressure requires them.
- Hiding a meaningful distinction behind `true`, `false`, or `null` when a named type or operation would clarify intent.
- Letting tests depend on shared state, order, network access, random values, or the current time without controlling those dependencies.
- Copying a successful company’s structure without comparing its team, workload, deployment, and operational constraints.
- Optimizing a proxy such as line count, class count, or service count instead of the outcome that matters to users and maintainers.

## Chapter quiz with answers

1. **A tax function reads the current time, fetches a rate from a database, calculates tax, and stores the result. How could you improve its design?**
   **Answer:** Pass the relevant time and rate into a calculation function and keep the calculation pure. Put database reads and writes at an application or infrastructure boundary. Test time boundaries, rounding rules, and persistence separately.

2. **What is hard to understand about `process(order, true, null)`? Give two ways to make the call clearer.**
   **Answer:** The boolean and null do not reveal their meaning or valid combinations. Use named arguments, an enum or option type, a request object with explicit fields, or separate operations. Define separately what an omitted field and an explicit `null` mean in a serialized API.

3. **Should every function contain fewer than ten lines?**
   **Answer:** No. Evaluate cohesion, abstraction level, decision paths, side effects, readability, and testability. A short function can still hide a confusing contract; a longer function can be clear when it tells one coherent story.

4. **A test passes alone but fails when the whole suite runs. What should you investigate?**
   **Answer:** Look for shared mutable state, order dependence, leftover data, clock or time-zone assumptions, randomness, concurrency, network use, and incomplete cleanup. Reproduce and remove the dependency, then run the affected tests together.

5. **Should all similar-looking code be extracted into one shared function?**
   **Answer:** No. First check whether the code represents the same rule, has the same owner, and changes for the same reason. If two copies evolve independently, forcing them into one abstraction can couple unrelated behavior.

6. **Why is it often useful to separate formatting-only edits from behavior-changing refactoring?**
   **Answer:** Reviewers can see the behavior change more clearly, history remains easier to interpret, and reverting or diagnosing a change is more targeted. A formatter can handle mechanical changes consistently.

## Practical exercise

Choose a small sales, booking, or invoicing application. Pick three requirements that change regularly. For each one, identify the rule’s owner, write a small contract and a test, and draw the current boundary. Then explain what evidence would justify moving that rule into another module or service. Record any consequential choice using an [Architecture Decision Record (ADR)](https://adr.github.io/).

## Further reading

**Persian resources**

- [DevNA: Clean Code Principles](https://devna.ir/articles/clean-code-principles) — Naming, functions, errors, dependencies, and incremental improvement.
- [JavaScript.info: Coding Style (Persian)](https://fa.javascript.info/coding-style) — Readability conventions illustrated with JavaScript.
- [Roka: What Is Clean Code?](https://rokaweb.ir/clean-code/) — A Persian introduction to readable, maintainable code.
- [Clean Code Persian repository](https://github.com/Kaaveh/clean-code-persian) — A community translation to compare with the original English wording.
- [Intelligent Software Engineering Lab: Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian course material on code quality, principles, and patterns.

**English resources**

- [Google Style Guides](https://google.github.io/styleguide/) — Examples of language-specific conventions used by large projects.
- [PEP 8: Python Style Guide](https://peps.python.org/pep-0008/) — The Python community’s style convention.
- [Martin Fowler: Refactoring](https://martinfowler.com/books/refactoring.html) — Behavior-preserving changes made in small steps.
- [Martin Fowler: Code Smell](https://martinfowler.com/bliki/CodeSmell.html) — Why a smell is a prompt to investigate rather than proof of a defect.
- [Refactoring Catalog](https://refactoring.com/catalog/) — Common refactorings, their motivations, and their mechanics.
- [Google Testing Blog: Test Sizes](https://testing.googleblog.com/2010/12/test-sizes.html) — Test categories based on execution cost and resource use.
- [Microsoft: C# Coding Conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions) — An example of documented conventions for a language and platform.

For more sources grouped by chapter, see the [bilingual reference library](../../references.md#chapter-01).
</div>
