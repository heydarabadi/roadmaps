# 7.1 — Definition of Done, Automation, and Team Health

**Language:** English · [فارسی](../../../07-team-practice/01-process-automation/README.md)

**Learning outcomes:** Set a proportionate review policy, automate dependable checks, and interpret metrics without gaming the process.

## Core lesson

A team's review policy should be clear enough that authors know when to request review and maintainers know when a change is ready. Define the required description, test evidence, review owners, security and data checks, merge conditions, expected response time, escalation path, and production follow-up for risky changes. Apply deeper controls to changes with greater impact rather than imposing unnecessary ceremony on every edit.

Automate stable, repeatable checks: format, lint, build, tests, secret scan, dependency policy, and selected security analysis. Keep controls fast, trustworthy, observable, and owned. Provide a way to fix or explain failures. If a check is flaky or noisy, people will learn to bypass it. Do not equate a tool's pass with complete correctness.

Measure the process to find friction. Queue size, time to first meaningful response, review cycle time, reopened changes, escaped defects, and workload distribution can reveal problems when interpreted together. Do not set individual quotas for comments or approvals. Metrics describe a system and can distort it when used as a personal score.

## Example policy starter

- Every non-trivial change states purpose, verification, and risk.
- Required checks run on the revision being merged.
- Protected code paths require an owner with relevant expertise.
- Blockers have an explicit reason and are rechecked after the fix.
- High-impact data/API/security changes document rollout and recovery.
- Review delays are surfaced early; urgent exceptions are recorded.
- The team reviews process and flaky controls regularly.

Treat this as a template, not universal policy. Adapt it to repository risk, regulatory obligations, team size, and deployment model.

## Quiz

1. What is a bad individual review KPI? **Number of comments or approvals; it rewards activity rather than usefulness.**
2. What should teams do with an unreliable required check? **Assign ownership and repair it, with a transparent temporary policy if necessary.**
3. Should all changes use the same depth of review? **No; the policy can scale controls to risk while keeping basic checks consistent.**
4. What makes a metric useful? **It helps diagnose flow or quality and is interpreted with context, not used as a shallow target.**

## Further reading

- [Google: Speed of code reviews](https://google.github.io/eng-practices/review/reviewer/speed.html)
- [GitLab Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [Microsoft Engineering Playbook: Code Review FAQ](https://microsoft.github.io/code-with-engineering-playbook/code-reviews/faq/)
- [NIST SSDF](https://csrc.nist.gov/pubs/sp/800/218/final)
- [Quality gatekeepers: effects of code review bots](https://link.springer.com/article/10.1007/s10664-022-10130-9)
- [Persian: Anophel on slow code reviews](https://anophel.com/articles/the-reason-of-slow-code-reviews)
- [Persian: DNTips Code Review collection (PDF)](https://www.dntips.ir/exports/newstag/www.dntips.ir-newstag-77.pdf)
