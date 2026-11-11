# Code Review: Complete Self-Study Course

**Language:** English · [فارسی](../README.md)

This course teaches peer code review as a practical engineering skill. It covers the full change lifecycle, from preparing a small and understandable pull request to reviewing behavior, security, performance, feedback, re-review, merge, and production follow-up.

## How to use the course

1. Start with the [four-week study plan](./11-study-path/README.md); use its prerequisite questions to identify any gaps.
2. Read the seven chapters in order. Each topic has a focused summary, step-by-step lesson, worked examples, common failure modes, a checklist, a four-question quiz with explanations, practice, and further reading.
3. Write your reasoning before reading quiz answers. Explain what evidence would change your decision.
4. Use the [playbook and templates](./10-playbook-and-templates/README.md) beside a real or sample pull request.
5. Finish with the [capstone](./07-team-practice/02-real-world-capstone/README.md) and the [30-question final assessment](./13-final-assessment/README.md).
6. Follow the destination repository's written policy where it is stricter or more specific.

## Chapters

- [1. Foundations](./01-foundations/README.md): purpose, limits, lifecycle, and human versus automated checks.
- [2. Authoring a change](./02-author/README.md): scope, change descriptions, self-review, tests, documentation, and risk.
- [3. Preparing to review](./03-reviewer/README.md): context, impact, risk, reviewer selection, and review depth.
- [4. Technical review](./04-technical-review/README.md): correctness, design, API contracts, testing, security, performance, and operations.
- [5. Feedback and disagreement](./05-feedback/README.md): clear comments, severity, style, and evidence-based resolution.
- [6. Follow-up and merge](./06-follow-up/README.md): addressing feedback, re-reviewing the latest revision, approval, and merge.
- [7. Team practice and real-world cases](./07-team-practice/README.md): team policy, automation, metrics, postmortems, and a capstone.

## Appendices

- [Bilingual glossary](./09-glossary/README.md)
- [Review playbook, templates, and checklists](./10-playbook-and-templates/README.md)
- [Four-week study plan](./11-study-path/README.md)
- [GitHub and GitLab PR/MR workflow](./12-pr-workflow/README.md)
- [Final assessment: 30 explained scenarios](./13-final-assessment/README.md)
- [Curated reference library](./08-resources/README.md)

## Roadmap.sh coverage and source note

The request's Markdown link displayed `roadmap.sh/system-design`, but its actual destination was [roadmap.sh/code-review-best-practices](https://roadmap.sh/code-review-best-practices). The interactive graph did not expose its full content in a text-readable view, so the curriculum was mapped against the public [Code Review checklist PDF](https://roadmap.sh/pdfs/best-practices/code-review.pdf) and expanded with first-party engineering guidance, security standards, research, and incident reports.

The lessons are written to make the core concepts and exercises self-contained. Links are provided for primary references, further reading, and tool-specific behavior that can change. This is a curated research set, not a claim that every page on the internet was read. Research findings and company policies are contextual evidence, not universal laws.

## Coverage map

| Roadmap topic | Course coverage |
|---|---|
| Purpose, Definition of Done, style, automation, turnaround, learning, appreciation, retrospectives, disagreement | Chapters 1, 3, 5, and 7 |
| Author: standards, architecture, tests, small changes, impact, docs, self-review | Chapter 2 |
| Reviewer: requirements, architecture, risk, reviewer selection, review depth | Chapter 3 |
| Technical review: behavior, tests, security, performance, documentation | Chapter 4 |
| Respectful, actionable feedback; priority and nits | Chapter 5 |
| Author response, fixes, re-testing, and re-review | Chapter 6 |
| Approval, merge, production verification, and monitoring | Chapters 6 and 7 |

## Suggested reference trail

The practical baseline is the [Google Engineering Practices code review guide](https://google.github.io/eng-practices/review/), the [GitHub pull request review guide](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-a-pull-request), the [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html), and the [NIST Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final). Research and postmortem reading is indexed in the [reference library](./08-resources/README.md).
