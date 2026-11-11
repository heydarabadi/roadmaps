# Chapter 2 — Preparing a Change for Review

**Language:** English · [فارسی](../../02-author/README.md)

**Goal:** Make a change focused, understandable, testable, and easy for a reviewer to evaluate.

## Connecting lesson

The author owns the quality of the review handoff. State one primary outcome, keep the patch coherent, follow the repository's architecture and conventions, add meaningful tests, update affected documentation, and expose risks the code itself does not make obvious. A small change is not defined by a fixed line count: it is a coherent unit that a reviewer can understand and that can be merged or rolled back safely.

Before requesting review, read the final diff as if you did not write it. Look for accidental files, debug output, incomplete error handling, missing configuration, an absent negative test, and documentation that now lies. The description should explain what changed, why, how it was checked, and what remains uncertain. Report only checks actually run against the relevant revision.

## Topics

- [2.1 Pull request scope and size](./01-pr-scope/README.md)
- [2.2 Description, evidence, and self-review](./02-pr-description/README.md)
- [2.3 Tests, documentation, and change risk](./03-tests-docs-risk/README.md)

## Chapter practice

Take a feature from a project you know. Split it into reviewable steps. For each step, write the user-visible outcome, dependencies, tests, documentation, risks, rollout order, and rollback or recovery path. Reject any split that leaves the system in an unusable intermediate state.

## Review questions and answer guide

1. What makes a pull request “small enough”? **A single understandable purpose, useful review context, and safe intermediate state matter more than line count alone.**
2. What should its description include? **Problem, intended behavior, implementation outline, tests and evidence, risk, rollout, and unresolved questions.**
3. What does self-review catch? **Unintended diff, missing tests or docs, incorrect assumptions, debug residue, and claims not supported by evidence; it complements rather than replaces peer review.**

## Further reading

- [Google: Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [Google: CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
- [Microsoft Engineering Playbook: Pull Requests](https://github.com/microsoft/code-with-engineering-playbook/blob/main/docs/code-reviews/pull-requests.md)
- [Persian: Netparadis review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
- [Persian: Hamed Lotf's review guide](https://hamedlotf.ir/blog/code-review-guide)
