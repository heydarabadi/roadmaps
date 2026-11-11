# 6.1 — Addressing Review Feedback

**Language:** English · [فارسی](../../../../fa/code-review/06-follow-up/01-address-feedback/README.md)

**Learning outcomes:** Triage comments, respond with evidence, implement changes safely, and keep discussion understandable.

## Core lesson

Treat each material comment as a decision to make. Classify it as a defect/blocker, question, optional improvement, or disagreement. Ask for clarification when the request is ambiguous. For a fix, change the code and add or update a regression test. For a reasonable disagreement, explain the constraint, alternative, and evidence. For optional work outside the agreed scope, create a follow-up issue when useful.

Respond in a way a future reader can understand: “Added tenant filter and negative test in commit `abc123`; the test verifies tenant B cannot read tenant A's invoice.” Batch related fixes when the result stays reviewable. Do not silently dismiss a material concern or mark it resolved before the fix is visible. The author owns the response; the reviewer owns checking the result.

After significant revisions, summarize what changed and what needs another look. Avoid repeatedly rewriting history in a way that makes the review impossible to compare. Follow the repository's convention for commits and thread resolution. Be respectful when rejecting a comment; disagreement with an idea is not rejection of the person.

## Worked example

Reviewer: “Could this retry create a second charge after a timeout?” Author: add provider idempotency key, persist the request identifier, and add a test simulating a timeout after provider acceptance. Response cites the code and test. The reviewer then checks both the changed path and any new persistence behavior before resolving the thread.

## Checklist

- [ ] Every blocking comment has a visible response.
- [ ] Fixes include evidence and a regression test where appropriate.
- [ ] Disagreements state reasons and alternatives.
- [ ] Optional scope is tracked rather than silently forgotten.
- [ ] Resolved threads correspond to an inspected outcome.

## Quiz

1. What is stronger than “done”? **A pointer to the change and its verification.**
2. You disagree with a request. What should you provide? **Context, constraints, a considered alternative, and evidence; ask for clarification if needed.**
3. Should an author resolve a thread before pushing the fix? **Usually no; keep the issue open until the result is visible and checked under team policy.**
4. When is a follow-up issue appropriate? **When an optional or out-of-scope improvement is deliberately deferred and needs traceable ownership.**

## Further reading

- [Google: Handling review comments](https://google.github.io/eng-practices/review/developer/handling-comments.html)
- [Google: Handling pushback](https://google.github.io/eng-practices/review/reviewer/pushback.html)
- [GitHub: Incorporating feedback in a pull request](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/incorporating-feedback-in-your-pull-request)
- [Opportunities and Challenges in Repeated Pull Request Revisions](https://doi.org/10.1145/3555208)
- [Persian: Todayino on responding to code review](https://emrozino.ir/article/code-review-beginners-guide)
- [Persian: Hheydarian review process](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
