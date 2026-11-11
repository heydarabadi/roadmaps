# Git and GitHub

## Learning goals

- Understand commits, branches, merges, rebases, tags, and remote repositories.
- Use pull requests and automation to improve review, traceability, and release safety.
- Avoid common collaboration failures such as oversized changes and force-push confusion.

## Git's object model

Git records snapshots as commits connected through parent references. A branch is a movable name pointing to a commit; it is not a separate copy of every file. A merge creates a commit that joins histories, while rebase reapplies commits onto a different base and changes their IDs. Do not rewrite shared history without agreement.

Keep commits focused and understandable. Use a branch for isolated work, sync regularly, resolve conflicts with knowledge of behavior, and run relevant checks. Tags can mark releases; protect them and tie them to immutable build artifacts. Never commit secrets: removing a key from the latest commit does not erase it from history or revoke it.

## Pull requests and repository controls

A pull request is a discussion and review boundary. Describe why the change exists, its behavior, risks, migration/rollback considerations, and evidence. Keep diffs small enough to review. Use required checks for linting, tests, security scanning, and policy; require human review for decisions that automation cannot assess.

GitHub adds issues, projects, Actions workflows, branch protection, CODEOWNERS, releases, and security features around Git repositories. Workflow permissions should follow least privilege. Pin action versions, protect deployment environments, and use short-lived credentials where available. A green workflow proves only the checks that actually ran.

## Worked example: database migration

Submit the migration and compatible application change with a rollout plan. Automated checks verify forward migration and contract compatibility. Reviewers assess locks, backfill load, rollback limits, and old/new app coexistence. Deploy the expand step first; contract only after all old readers are retired.

## Self-check quiz

1. What is a Git branch? A movable reference to a commit.
2. What does rebase change? It creates new commits with different parent history and therefore different commit IDs.
3. Does deleting a leaked secret from the current tree make it safe? No; revoke and rotate it, then clean history if needed.
4. Why keep pull requests reviewable? Reviewers can understand behavior, risk, and evidence more reliably.
5. What does a green CI check prove? Only that the configured checks passed for the checked revision and environment.

## Exercise

Plan a pull request for a backward-compatible API change and database migration. Include branch strategy, checks, reviewer focus, deployment order, and secret handling.

### Sample answer

Create a focused branch and commit the additive API/schema change with tests and migration notes. CI runs unit, compatibility, migration, and security checks. Reviewers inspect old-client behavior, database lock/backfill risks, authorization, and rollback/forward recovery. Deploy expansion before dependent code, monitor, and delay contract changes. Keep credentials in protected environment secrets and rotate any exposed key immediately.

## Further reading

- English: [Pro Git book](https://git-scm.com/book/en/v2), [Git documentation](https://git-scm.com/doc), [GitHub pull requests](https://docs.github.com/en/pull-requests), [GitHub Actions security hardening](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions), [GitHub engineering blog](https://github.blog/engineering/), [DORA: Version control](https://dora.dev/capabilities/version-control/)
- Persian: [Pro Git Persian translation](https://git-scm.com/book/fa/v2), [Quera Git course](https://quera.org/college)
