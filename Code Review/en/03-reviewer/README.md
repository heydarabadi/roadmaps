# Chapter 3 — Preparing to Review

**Language:** English · [فارسی](../../03-reviewer/README.md)

**Goal:** Build enough context to assess impact and choose a reviewer and review depth that match the risk.

## Connecting lesson

A reviewer should understand before judging. Read the requirement and change description; map the files and their roles; follow inputs, outputs, callers, data, and external contracts; then assess likelihood, severity, blast radius, and reversibility. This prevents comments that are technically plausible but irrelevant to the actual behavior.

Choose reviewers by the expertise and risk areas needed, not by title alone. File ownership is useful for routing but does not guarantee a thorough or current review. A cross-cutting change may need several complementary reviewers. If you lack the time or expertise to review an authentication, privacy, data, or infrastructure change, say so early and involve the appropriate owner instead of guessing.

## Topics

- [3.1 Context and risk analysis](./01-context-risk/README.md)
- [3.2 Reviewer selection and review planning](./02-reviewer-selection/README.md)

## Chapter practice

For a database-backed endpoint, sketch its caller, authorization check, query, stored data, consumers, failure modes, and rollback path. Select two reviewers with complementary expertise and state which question each will answer.

## Review questions and answer guide

1. Why is reading only the diff risky? **Effects may appear in callers, persistent data, APIs, permissions, and operational behavior outside the changed lines.**
2. How should reviewers be selected? **Match domain knowledge and ownership to the change's risk, and add complementary expertise for cross-cutting concerns.**
3. What if you lack time or expertise? **Notify the author early, limit and state your review scope, and request a qualified reviewer for the high-risk part.**

## Further reading

- [Google: How to do a code review](https://google.github.io/eng-practices/review/reviewer/)
- [Google: What to look for](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [Review of code reviewer recommendation studies](https://doi.org/10.1016/j.scico.2021.102652)
- [Persian: Gitab code review process](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
