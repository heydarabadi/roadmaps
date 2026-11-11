# Four-Week Study Plan and Mastery Guide

**Language:** English · [فارسی](../../11-study-path/README.md)

Suggested pace: 45–75 minutes a day, five days a week. If you have less time, keep the exercises and add days rather than skipping practice.

## Prerequisites

You do not need expertise in one particular language, but you should recognize:

- how code is organized into files and functions;
- how a request moves from input through logic to storage or response;
- how Git records changes in commits and branches;
- that a test checks an expected property;
- that an API is a contract between system components;
- the basic idea of authentication and a database.

### Starting self-assessment

If you cannot answer a question, find a small example in a repository and practice that concept first. Missing a prerequisite is a learning map, not a judgment.

1. How do staged and unstaged diffs differ?
2. What does a test prove if it only calls a mock?
3. How is authentication different from authorization?
4. How can a migration conflict with an older application version still running?
5. How can you tell which tests and CI checks ran on the latest commit?

## Week 1 — Understand PRs and author responsibilities

- **Day 1:** Read Chapter 1. Write your own examples of review, testing, linting, and QA.
- **Day 2:** Trace the review lifecycle. Read a closed PR from its description through merge.
- **Day 3:** Split a hypothetical change into two focused PRs and explain the boundary.
- **Day 4:** Fill in the PR description template for a small feature, including tests and risk.
- **Day 5:** Self-review a diff without relying on memory. Find accidental or unrelated files.

## Week 2 — Reviewer perspective and technical checks

- **Day 1:** Draw the requirement and data path for a PR.
- **Day 2:** Identify three boundary cases, two failure modes, and one invariant.
- **Day 3:** Read a test and explain which regression its assertion would catch.
- **Day 4:** Perform a basic security review: identity, permission, source, and sink.
- **Day 5:** Review a performance or operations concern using a query, timeout, or cache example.

## Week 3 — Conversation, revisions, and merge

- **Day 1:** Rewrite five harsh or vague comments using observation + impact + ask.
- **Day 2:** Classify findings as blocker, suggestion, question, or nit.
- **Day 3:** Write three author responses, including one reasoned disagreement.
- **Day 4:** Compare a diff before and after revision; decide which approvals still apply.
- **Day 5:** Use the pre-merge checklist for checks, owners, rollout, and recovery.

## Week 4 — Real project and reflection

- **Day 1:** Find a small, active public repository and read its contribution guide.
- **Day 2:** Study a small PR only to understand its purpose and scope.
- **Day 3:** Inspect tests and edge cases; write three questions but do not publish them yet.
- **Day 4:** Compare your questions with existing review discussion and project docs; correct your assumptions.
- **Day 5:** Write one blocker, one question, one suggestion, and one specific praise comment. If you are ready, follow that project's contribution rules before participating.

Do not post speculative comments on someone else's project. Practice privately first and respect contribution policies.

## Spaced review

After each chapter, write a short note that day. One day later, recite its checklist without looking. Three days later, apply it to another PR. The next week, re-read only the difficult cases. The goal is risk recognition and evidence selection, not memorizing phrases.

## Mastery levels

| Level | Observable ability |
|---|---|
| 0 — Familiar | Recognizes a term but cannot yet give an example |
| 1 — Guided | Uses a checklist to ask initial questions |
| 2 — Independent | Explains a finding with behavior, impact, and evidence |
| 3 — Advanced | Assesses cross-system risk, trade-offs, and evidence limits |
| 4 — Team lead | Designs workable policy, automated gates, and improvement process |

You do not need level 4 in every topic. A good reviewer knows what they do not know and when to involve a specialist.

## How to measure progress

Do not score yourself by comment count. Sample reviews and ask: Did I identify the right issue? Was the comment actionable? Did I block only when justified? Did the author understand the evidence needed? Did I miss a security or compatibility concern? Use the answers for learning, not a quota.

## Further reading

- [Google Engineering Practices](https://google.github.io/eng-practices/review/)
- [Microsoft study of useful reviews](https://www.microsoft.com/en-us/research/publication/characteristics-of-useful-code-reviews-an-empirical-study-at-microsoft/)
- [Curated reference library](../08-resources/README.md)
- [Persian: Netparadis review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
- [Persian: Hheydarian review process](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
