# 2.1 — Pull Request Scope and Size

**Language:** English · [فارسی](../../../../fa/code-review/02-author/01-pr-scope/README.md)

**Learning outcomes:** Design a change that is coherent to review, identify risky scope, and split work without creating unsafe intermediate states.

## Core lesson

“Small” is a property of understanding, not merely line count. A reviewable change has a clear purpose, limited conceptual breadth, enough context to assess its effects, and a safe path to integrate. A short authorization edit can be riskier than hundreds of generated formatting changes. Consider number of concepts, files, dependencies, reviewers, data migrations, and reversibility.

Split work when each step has a meaningful boundary. Vertical slices deliver a thin but usable behavior across layers. Horizontal slices can separate a schema, API contract, or shared abstraction when dependencies are explicit. Stacked PRs allow later work to build on an earlier review; explain the dependency and rebase or re-review when the base changes. Mechanical generated changes can be isolated from behavioral changes, with evidence about the generator.

Do not split a transaction so that each PR leaves production broken, or hide a behavioral change in a “refactor.” Avoid mixing unrelated cleanup, formatting, dependency upgrades, and feature logic: they obscure causality and make rollback harder. If a large patch is unavoidable, provide a map, staged commits, a risk summary, and reviewer-specific sections.

## A sizing procedure

1. State the intended outcome and the smallest complete behavior change.
2. List the code, tests, schema, configuration, docs, and rollout it touches.
3. Identify independent parts and their dependency order.
4. Check that each proposed intermediate revision builds and has an understood behavior.
5. Ask the intended reviewer whether the slices are understandable in this repository.

## Worked example: payment retry feature

Instead of one huge PR containing provider API, persistence, UI, retries, and metrics, an order might be: add an idempotency-safe payment contract and storage; integrate one provider path behind a disabled flag; add retry policy and observability; then enable it gradually. The exact split depends on deploy compatibility. Each step should be testable and should not charge a customer twice.

## Common mistakes

- Using a universal line-count limit without considering risk or generated changes.
- Separating production code from the test that explains its behavior.
- Splitting into many tiny commits with no clear outcome.
- Calling a risky behavior change a refactor to avoid scrutiny.

## Checklist

- [ ] The PR has one primary purpose and a coherent boundary.
- [ ] Tests and necessary docs travel with the change.
- [ ] Dependencies and required merge order are visible.
- [ ] Every intermediate state is safe or remains behind a guard.
- [ ] Size, reviewer count, and risk make the patch understandable.

## Quiz

1. What determines reviewability best? **Coherent purpose, impact, and context—not a fixed number of lines.**
2. What is dangerous about a schema-only PR? **The running application may not tolerate the schema transition unless compatibility and deployment order are designed.**
3. Should generated formatting changes be mixed with behavior? **Usually separate them or clearly identify them, so the behavior remains inspectable.**
4. A PR is large but cannot be split safely. What helps? **Explain the structure, provide staged commits and evidence, identify reviewers, and call out risk explicitly.**

## Further reading

- [Google: Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [Google: The CL Author's Guide](https://google.github.io/eng-practices/review/developer/)
- [Microsoft Engineering Playbook: Pull Requests](https://github.com/microsoft/code-with-engineering-playbook/blob/main/docs/code-reviews/pull-requests.md)
- [Expectations, Outcomes, and Challenges of Modern Code Review](https://doi.org/10.1109/ICSE.2013.6606617)
- [Persian: Netparadis on scope and pull requests](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
- [Persian: Hamed Lotf's Code Review guide](https://hamedlotf.ir/blog/code-review-guide)
