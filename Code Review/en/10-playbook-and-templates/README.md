# Review Playbook and Ready-to-Use Templates

**Language:** English · [فارسی](../../10-playbook-and-templates/README.md)

Use these checklists beside a real PR. Adapt them to the repository's standards, regulatory duties, and risk. They support judgment; they do not replace it.

## Pull request description template

```text
## What changed
Describe the user-visible or system behavior.

## Why
Which problem, requirement, or decision does this address?

## How to verify
- Automated checks actually run:
- Manual verification:
- Screenshot or benchmark (if useful):

## Risk and rollout
- Data / API / security / performance / compatibility:
- Rollout or feature flag:
- Rollback or recovery:

## Reviewer focus
- Please check:
- Open questions or known limitations:
```

### Filling it in well

- Describe the result, not just the changed files.
- Link to the issue or decision; “my manager asked” is not the technical rationale.
- List only checks that actually ran on a relevant revision.
- Name untested or uncertain areas plainly.
- Limit reviewer focus to a few high-value questions.
- Use synthetic or safe data in screenshots.

## Author's pre-review checklist

### Goal and scope

- [ ] The main outcome and acceptance criteria are clear.
- [ ] Unrelated changes are separated.
- [ ] API, schema, configuration, dependency, and rollout effects are considered.
- [ ] Important decisions not visible in the code are explained.

### Change quality

- [ ] Existing architecture and repository standards are followed.
- [ ] A meaningful regression or boundary test is included.
- [ ] Relevant tests ran against the latest revision.
- [ ] Affected docs, examples, and runbooks are current.
- [ ] Debug logs, secrets, generated output, and accidental files are absent.
- [ ] Security, performance, data, and compatibility risks are considered.

### Review request

- [ ] Title and description accurately describe the change.
- [ ] Verification and limitations are reported honestly.
- [ ] Open questions are visible.
- [ ] Reviewers match the changed domains.
- [ ] Time is allowed for review and follow-up.

## Two-pass reviewer checklist

### Pass 1: understand

1. Read the description, issue, acceptance criteria, and relevant design note.
2. Write a one-sentence summary of intended behavior.
3. Group changed files: logic, tests, config, migration, docs, dependency, or infrastructure.
4. Identify scope creep and hidden dependencies.
5. Rank risk by likelihood, impact, blast radius, reversibility, and uncertainty.

### Pass 2: validate

1. Trace the main success path and invariants.
2. Inspect boundary, failure, retry, concurrency, and old-data behavior as relevant.
3. Read tests and ask which regression each assertion would catch.
4. For security, follow inputs to sinks and verify resource authorization.
5. Use CI, local execution, specialist review, or a benchmark where the risk calls for it.
6. Order findings from blockers to optional suggestions.
7. Summarize the review scope and remaining uncertainty.

If reviewing in a web UI, check which revision a comment belongs to and compare before and after each meaningful push.

## Comment template

```text
[priority]: [observed behavior] can cause [impact].
Could we [specific request or question]?
Evidence: [test, invariant, requirement, or reproduction].
```

Example:

```text
blocker: This query filters by order_id but not the authenticated tenant, so a user may read another tenant's order.
Could we scope the query to the current tenant and add a negative test for a foreign order ID?
Evidence: the authenticated tenant is available in the request context.
```

If evidence is incomplete, phrase the point as a question rather than a confirmed exploit.

## Reviewer prompts by change type

| Change | Questions to ask |
|---|---|
| API | Contract, old clients, null/defaults, error semantics, pagination, versioning? |
| Database | Old data, staged migration, index/lock, rollback or forward fix? |
| Authentication/authorization | Where does identity come from? Is access checked for this resource? Negative test? |
| Dependency | Why needed? Source/license? Lockfile, install scripts, maintenance, transitive risk? |
| Performance | Hot path? Representative data? Complexity, query count, p95/p99? |
| Queue/background job | Retry, duplicate, ordering, idempotency, dead letter? |
| Logging/monitoring | Sensitive data omitted? Actionable metric and owner? |
| User interface | Loading/error/empty states, keyboard access, accessibility, safe screenshot? |

## Post-review and pre-merge checklist

- [ ] The author responded to each blocker and material question.
- [ ] The actual fix is visible in the latest diff.
- [ ] A new test has a meaningful assertion.
- [ ] Approval and required checks match the current revision.
- [ ] Code owner, branch protection, and thread policy are satisfied.
- [ ] Risky changes have rollout signals and recovery steps.
- [ ] Review limitations are recorded.

## Suggested status meanings

| Status | Author action | Reviewer action |
|---|---|---|
| Open question | Provide context and evidence | Turn ambiguity into a specific question |
| Blocker | Fix or provide evidence for a decision/escalation | Re-check corrected behavior |
| Suggestion | Decide now or create a follow-up issue | State clearly that it does not block merge |
| Approval | Confirm revision and scope | Summarize what was reviewed and any limits |
| CI failure | Diagnose and fix or explain a known failure | Confirm the result belongs to the latest revision |

## Further reading

- [Google: CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html)
- [GitHub: Incorporating feedback](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/incorporating-feedback-in-your-pull-request)
- [GitHub: Resolving reviews](https://docs.github.com/en/pull-requests/concepts/resolving-reviews)
- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [Persian: Netparadis Code Review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
