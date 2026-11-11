# Chapter 6 — Response, Re-review, and Merge

**Language:** English · [فارسی](../../../fa/code-review/06-follow-up/README.md)

**Goal:** Address feedback, verify meaningful revisions, and connect approval to the revision that is actually merged.

## Connecting lesson

The author should respond to every material point with a specific change, a reasoned disagreement, or a request for clarification. “Done” is weak evidence; point to the commit, test, or decision. Resolving a thread records the conversation's state but does not prove that the code is correct.

An approval applies to the revision the reviewer saw. After new commits, a changed merge base, conflict resolution, or a material behavior change, check the latest diff, current CI, and repository policy. Before merging, verify required approvals, ownership, and status checks. Merge is not deployment: a high-impact change may still need staged rollout, monitoring, and recovery.

## Topics

- [6.1 Addressing review feedback](01-address-feedback/README.md)
- [6.2 Re-review, approval, and merge](02-rereview-merge/README.md)

## Chapter practice

Imagine that a new commit is pushed after approval. List what author, reviewer, and CI must re-check. Identify policy choices that may stale an approval and explain why the merge must be tied to the current revision.

## Review questions and answer guide

1. How should an author show a comment was handled? **Reference the actual code change and relevant test, or explain the evidence and trade-off behind a disagreement.**
2. Does resolving a thread prove the fix? **No. Thread status tracks discussion; the reviewer must inspect the resulting code and evidence.**
3. When should an old approval be reconsidered? **After a reviewable diff or base change, conflict resolution, or whenever the repository's approval policy requires a fresh review.**

## Further reading

- [GitHub: Incorporating feedback into a pull request](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/incorporating-feedback-in-your-pull-request)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [GitHub: Protected branches and stale reviews](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [Opportunities and Challenges in Repeated Pull Request Revisions](https://doi.org/10.1145/3555208)
- [Persian: Emrozino review guide](https://emrozino.ir/article/code-review-beginners-guide)
