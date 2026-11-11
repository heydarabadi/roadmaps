# 1.2 — Review Lifecycle and the Review Pyramid

**Language:** English · [فارسی](../../../../fa/code-review/01-foundations/02-lifecycle-pyramid/README.md)

**Learning outcomes:** Describe the normal review cycle and allocate each kind of check to an appropriate control.

## Core lesson

A practical change lifecycle is: clarify the goal; design and implement; run local checks; self-review the final diff; publish a focused PR/MR with evidence; receive human and automated review; address findings; re-review the latest revision; merge under repository policy; then deploy and monitor where needed. A change can loop through authoring, CI, and review several times. Keep the status of the revision visible.

Think of assurance as layers rather than a strict pyramid that every team must copy. Cheap, repeatable checks belong close to the author: formatting, lint, unit tests, type checks, and secret or dependency scanning. Integration and end-to-end tests cover important interactions. Humans assess intent, architecture, unusual edge cases, security context, and trade-offs. Release controls and monitoring cover risk that cannot be settled before merge.

Automate a check when the rule is stable, the signal is trustworthy, and failures have an owner. Human review is scarce and slower; use it where context matters. A flaky test or noisy scanner can teach people to ignore the entire pipeline, so repair and measure controls rather than accumulating badges.

## Step-by-step workflow

1. Confirm the requirement and acceptance criteria.
2. Make one coherent change, including its tests and relevant docs.
3. Run focused local checks and inspect the diff.
4. Publish the change with the exact revision, evidence, risks, and reviewer focus.
5. Review broad structure first, then follow high-risk paths and edge cases.
6. Resolve each material comment with a change or a reasoned decision.
7. Verify current CI, review policy, and the exact diff before merge.
8. Use staged rollout, telemetry, and recovery for meaningful production risk.

## Worked example: deleting an endpoint

Deleting `/v1/export` may look trivial. First search clients, scheduled jobs, dashboards, API documentation, and old app versions. Add or verify deprecation telemetry, coordinate a removal date, preserve compatibility during rollout, then remove the endpoint and tests. A one-line deletion can need more context than a larger isolated refactor.

## Common mistakes

- Assuming a larger test suite automatically means stronger evidence.
- Running checks on one revision and approving another.
- Treating merge as the end of a risky change.
- Making each split PR unusable or unsafe in isolation.

## Checklist

- [ ] The purpose and acceptance criteria are understood.
- [ ] Local and CI checks map to specific claims.
- [ ] Human review covers decisions the tools cannot evaluate.
- [ ] The release plan covers material risks beyond merge.

## Quiz

1. Which step should happen before line-by-line comments? **Understand the goal and broad shape of the change.**
2. Where should stable formatting rules live? **In an agreed automated formatter or lint check.**
3. A flaky CI check repeatedly fails without code defects. What is the right response? **Assign ownership and repair or quarantine it under a clear policy; do not train the team to ignore all failures.**
4. What does merge finish? **Integration into a branch, not necessarily deployment, activation, or production verification.**

## Further reading

- [Google: Navigating a CL in review](https://google.github.io/eng-practices/review/reviewer/navigating-cl.html)
- [Google: Speed of code reviews](https://google.github.io/eng-practices/review/reviewer/speed.html)
- [GitHub: Reviewing a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request)
- [GitLab: Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [NIST SSDF: secure review and analysis practices](https://csrc.nist.gov/pubs/sp/800/218/final)
- [Persian: Gitab review process](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
