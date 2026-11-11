# 2.2 — PR Description, Evidence, and Self-Review

**Language:** English · [فارسی](../../../../fa/code-review/02-author/02-pr-description/README.md)

**Learning outcomes:** Write a useful handoff, state verification accurately, and inspect the actual patch before requesting review.

## Core lesson

A reviewer did not live through the implementation. The description supplies the missing product and decision context. A strong PR description answers: What behavior changes? Why is this needed? How was it verified? What risks, compatibility issues, rollout steps, or uncertainties remain? What should reviewers focus on? Link relevant issues and design records. Describe outcomes rather than listing files.

Evidence must be truthful and revision-specific. Name tests actually run, the environment where they ran, and any manual checks. “Tests pass” is not useful if they ran before the last commit or do not cover the changed behavior. Screenshots should use safe sample data. Benchmarks need a baseline, environment, workload, and method. If a check was not run, say so and explain what remains.

Self-review means inspecting the final diff as another developer. Compare against the base, inspect staged and unstaged changes, check generated files and migrations, and read the description against the implementation. Look for accidental secrets, logs, dead code, missing negative tests, stale docs, incomplete flags, and unrelated formatting.

## PR description template

```text
What changed:
Why it changed:
How to verify (commands/checks and results):
Risks and compatibility:
Rollout / recovery:
Reviewer focus / open questions:
```

## Worked example: cache invalidation

Weak: “Fix stale data.” Strong: “When a product price changes, the product cache can keep the old price for up to 30 minutes. This change invalidates the product and category keys after the transaction commits. Verified with a regression test for update, rollback, and missing cache entries. Risk: older workers use a legacy key; rollout keeps dual invalidation for one release. Please check key construction and category fan-out.” The latter explains behavior, evidence, compatibility, and review scope.

## Checklist and common mistakes

- [ ] State the user or system behavior, not only implementation details.
- [ ] Connect the change to a requirement or issue.
- [ ] Report checks and limitations precisely.
- [ ] Disclose data, API, security, performance, and rollout risks.
- [ ] Review the final diff and remove unrelated changes.

Avoid “fix,” “done,” unverified green claims, screenshots containing real customer data, and a long file list with no rationale.

## Quiz

1. What is missing from “fix bug”? **The failure, intended behavior, verification, risk, and context.**
2. Why self-review after the last edit? **The final diff may contain accidental or untested changes that were not part of the author's original mental model.**
3. A test was run before a new commit. Can the description say the latest revision passed? **No; rerun the relevant check or disclose the exact revision tested.**
4. What belongs in reviewer focus? **A small number of concrete, high-risk questions, not an instruction to re-read the whole project blindly.**

## Further reading

- [Google: CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
- [GitHub: Helping others review your changes](https://docs.github.com/en/pull-requests/concepts/helping-others-review-your-changes)
- [The Value of Effective Pull Request Descriptions](https://arxiv.org/abs/2602.14611)
- [Microsoft Engineering Playbook: Pull Requests](https://github.com/microsoft/code-with-engineering-playbook/blob/main/docs/code-reviews/pull-requests.md)
- [Persian: Todayino on descriptions and review](https://emrozino.ir/article/code-review-beginners-guide)
- [Persian: Netparadis Code Review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
