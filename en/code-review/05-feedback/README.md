# Chapter 5 — Feedback, Priority, and Disagreement

**Language:** English · [فارسی](../../../fa/code-review/05-feedback/README.md)

**Goal:** Write actionable and respectful comments, distinguish blockers from preferences, and turn disagreement into a decision.

## Connecting lesson

A useful comment names the observed behavior, explains its effect, and makes the next step clear. Separate facts from assumptions. State severity and certainty honestly. Use the team's style guide and tools for style so personal preference does not become a merge gate. Labels such as blocker, question, suggestion, and nit are useful only when the team gives them a shared meaning.

Resolve technical disagreement with requirements, representative data, an experiment, or an existing design decision—not job title or comment volume. If there is still no agreement, identify the decision owner and record the trade-off. Reviewers should update their position when evidence changes. The goal is a sound change and shared understanding, not a perfect diff or maximum comment count.

## Topics

- [5.1 Constructive and precise comments](01-constructive-comments/README.md)
- [5.2 Severity, style, and conflict resolution](02-priority-conflict/README.md)

## Chapter practice

Rewrite five review sentences. For each, identify the observed behavior, impact, requested action or question, severity, and certainty. Remove judgments about the person.

## Review questions and answer guide

1. What makes a comment actionable? **A specific behavior, a credible impact, a clear request or question, and enough evidence or context to act.**
2. How do you distinguish a blocker from a suggestion or nit? **Block only for a material correctness, security, data, or release risk or a clear policy requirement; label optional improvements as non-blocking.**
3. What evidence moves a disagreement forward? **Requirements, tests, measurements, production constraints, and design records; when unresolved, name the decision owner and document the trade-off.**

## Further reading

- [Google: Writing review comments](https://google.github.io/eng-practices/review/reviewer/comments.html)
- [Google: Handling pushback](https://google.github.io/eng-practices/review/reviewer/pushback.html)
- [Conventional Comments specification](https://conventionalcomments.org/)
- [Characteristics of Useful Code Reviews: Microsoft study](https://www.microsoft.com/en-us/research/publication/characteristics-of-useful-code-reviews-an-empirical-study-at-microsoft/)
- [Persian: Javacup on review methods](https://javacup.ir/code-review-methods/)
