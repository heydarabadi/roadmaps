# Practical Pull Request and Merge Request Workflow

**Language:** English · [فارسی](../../12-pr-workflow/README.md)

This chapter teaches the concepts behind GitHub pull requests and GitLab merge requests. Button names and settings can change or vary by repository; the durable concepts are proposing a diff, discussing it, revising it, checking evidence, approving the intended revision, and merging under policy.

## 1. Prepare a branch

Confirm the repository and destination branch. Common Git commands:

```bash
git status --short
git switch -c feature/search-pagination
# edit files and run relevant tests
git diff --check
git diff --stat
git diff
git add src/search tests/search
git diff --cached
git commit -m "Add stable search pagination"
git push -u origin feature/search-pagination
```

These are examples; use paths and branch names from your repository. Inspect staged changes before committing so secrets, environment files, build output, or unrelated edits are not included. A commit title should describe the change. Separate independent reasons when doing so makes history, review, or rollback clearer.

## 2. Open the PR/MR

1. Verify source and target branches.
2. Complete the description: problem, solution, tests, risk, rollout, and review questions.
3. Use Draft while work is unfinished; request early design feedback when helpful.
4. Request appropriate owners and domain reviewers.
5. Read the diff yourself, including nearby context.
6. Check which revision each CI job analyzed.

GitHub calls this a Pull Request; GitLab uses Merge Request. Both provide discussion and a decision workflow, but approval counts, thread semantics, suggestions, and auto-merge depend on platform configuration and repository policy.

## 3. Review in the platform

1. Read the description and linked requirement.
2. Inspect the changed-file summary and overall diff.
3. Add comments to specific behavior and use suggestions where they are clear.
4. Do not submit a final decision until the intended review is complete.
5. Summarize findings, scope, and remaining limitations.

GitHub supports line comments and suggestions within a review. GitLab keeps discussions and review state in an MR. The exact interface may differ; check the repository's current settings and contribution policy.

## 4. Respond and re-review

The author understands each comment, replies, pushes corrections, and reruns relevant tests. If a useful idea is out of scope, create a follow-up issue and link it. After a meaningful revision, request another review. The reviewer compares the new diff with the prior revision and checks whether the newest CI and approval still apply.

## 5. Merge safely

Before merging, verify:

- required status checks are green for the current head;
- required approvals refer to the current diff or satisfy repository policy;
- comments are handled according to the team's process;
- conflicts and dependencies are resolved;
- high-impact changes have rollout, monitoring, and recovery plans.

Merge is not deployment. Code may be merged with a feature flag off, or deployed gradually. After release, monitor a signal tied to the intended behavior and stop or roll back if the agreed threshold is crossed.

## Stable principles and changing UI details

| Area | Stable principle | Variable implementation |
|---|---|---|
| Approval | A reviewer must see the revision being accepted | Count, eligibility, and dismissal rules |
| Code owners | Ownership must be explicit | File syntax, location, and auto-request behavior |
| Checks | Evidence must be current | Pipeline jobs, gates, and bypass permissions |
| Suggestions | Proposed changes remain inspectable | UI action and how they are committed |
| Resolve | Discussion state should be clear | Who may close a thread |

## Common issues

- **CI is red:** Determine whether the failure is relevant or flaky; do not dismiss it without evidence.
- **Approval disappeared:** The diff or base may have changed; inspect policy and request a fresh review if needed.
- **A comment is attached to an old line:** Find it in the timeline or prior revision and connect the outcome to the new diff.
- **A large PR is stalled:** Revisit purpose, noise, dependencies, and reviewer assignment rather than applying deadline pressure alone.
- **Merge conflict:** Update the branch carefully; resolving conflicts can change behavior and require another review.

## Hands-on practice

In a personal test repository, create a branch and a small change with a test. Self-review the diff, fill in the description, and open a Draft PR. As reviewer, write a question, a suggestion, and a hypothetical blocker. Apply a fix, inspect pipeline status for the latest commit, then merge or close it. Do not submit to a public repository without reading its contribution guide.

## Further reading

- [GitHub: Reviewing a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request)
- [GitHub: Pull request review concepts](https://docs.github.com/en/pull-requests/reference/pull-request-reviews)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [GitHub: Protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub: Code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [Persian: Todayino Code Review guide](https://emrozino.ir/article/code-review-beginners-guide)
- [Persian: Netparadis review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
- [Persian: Hheydarian review process](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
