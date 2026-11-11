# 6.2 — Re-review, Approval, and Merge

**Language:** English · [فارسی](../../../../fa/code-review/06-follow-up/02-rereview-merge/README.md)

**Learning outcomes:** Inspect the latest revision, understand review state, and verify merge requirements.

## Core lesson

Approval is evidence about a particular revision, not a permanent property of a pull request. Re-review meaningful new commits, conflict resolution, base changes, or changes required by policy. Compare the new diff with the prior review, inspect whether the author addressed requested behavior, and ensure the CI result belongs to the current head. Reviewers may need to reapprove when repository rules dismiss stale approvals.

Thread state, overall review state, status checks, code owner requirements, branch protections, and merge queue behavior are related but distinct. A resolved thread does not prove its fix. An approval does not override a failing required check. Check the destination branch and repository rules before merging; each platform's interface and exact policy can change.

After merge, confirm deployment state if relevant. A feature flag may remain off; a staged rollout may reveal issues; a database migration may need monitoring. For risky changes, define success and abort signals, an owner, and a recovery action before rollout. Keep a record of the final scope and any known limitations.

## Practical pre-merge sequence

1. Inspect the final diff and base/head revisions.
2. Confirm material feedback has a decision and latest code inspection.
3. Check approvals, code owners, branch protection, and required CI.
4. Confirm conflict resolution and migration order.
5. Merge only through the repository's intended path.
6. Follow release and monitoring requirements for the change's risk.

## Quiz

1. A new commit arrives after approval. What should you check? **The latest diff, current CI, and the repository's stale-approval policy.**
2. Does a resolved discussion thread prove correctness? **No; inspect the code and test outcome.**
3. CI is green on the previous head but red/not run on the current head. Can that check be used? **No; required evidence must refer to the revision being merged.**
4. Does merge mean the feature is live? **Not necessarily; deployment and activation may be separate steps.**

## Further reading

- [GitHub: Reviewing a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [GitHub: Protected branches and stale approvals](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub: About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [GitHub: October 21 post-incident analysis](https://github.blog/news-insights/company-news/oct21-post-incident-analysis/)
- [Persian: Sauleh review guide (PDF)](https://www.sauleh.ir/ap97/static_files/AP97982-CodeReviewGuide.V.1.3.pdf)
