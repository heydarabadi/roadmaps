# 3.1 — Understand Context and Analyze Risk

**Language:** English · [فارسی](../../../../fa/code-review/03-reviewer/01-context-risk/README.md)

**Learning outcomes:** Read beyond the changed lines, trace important behavior, and prioritize review by evidence-based risk.

## Core lesson

Start from the problem statement, acceptance criteria, design notes, and the code's surrounding conventions. Map what changed: logic, tests, API, schema, configuration, dependency, docs, or infrastructure. Follow important inputs through transformations to side effects and consumers. Ask how the system behaves on normal, missing, malformed, unauthorized, duplicate, concurrent, and unavailable paths.

Risk is not a single score. Consider likelihood, impact, affected users and data, blast radius, exposure, detectability, reversibility, and uncertainty. A five-line permission change or data deletion may be high risk. A generated rename may be large but low risk if its transformation is trustworthy and behavior is unchanged. Spend review time on the most consequential and least evidenced assumptions.

Use a two-pass review. Pass one understands the change's intent and broad structure. Pass two follows high-risk paths, compares tests to requirements, looks for failure conditions, and checks whether controls match the claim. If evidence is incomplete, distinguish a finding from a question: do not present speculation as a confirmed defect.

## Worked example: a cache lookup for tenant data

An endpoint replaces a database query with a cache lookup by `invoiceId`. Trace whether the key includes tenant identity, whether the cached payload can outlive permission changes, whether an old cache format is still present, and what happens on a miss or stale value. A performance improvement may create a cross-tenant data leak if authorization is only applied on the old query path.

## Checklist

- [ ] I understand the requirement and expected behavior.
- [ ] I followed callers, data, APIs, and downstream effects.
- [ ] I assessed severity, scope, reversibility, and unknowns.
- [ ] I prioritized risk above style and mechanical issues.
- [ ] Findings include evidence; uncertainty is phrased as a question.

## Quiz

1. Why is a diff-only reading insufficient? **A changed line can alter callers, data, permissions, compatibility, and operations elsewhere.**
2. Which change deserves deeper review: a 500-line generated rename or a five-line auth rule? **Usually the auth rule, because impact and blast radius matter more than size.**
3. You suspect a race but cannot establish it. How should you comment? **Describe the concurrency scenario and ask for the invariant or test that demonstrates safety.**
4. What comes first in a complex review? **Understand the goal and map the change before commenting on individual implementation details.**

## Further reading

- [Google: What to look for in a code review](https://google.github.io/eng-practices/review/reviewer/looking-for.html)
- [OWASP Secure Code Review Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secure_Code_Review_Cheat_Sheet.html)
- [NIST SSDF](https://csrc.nist.gov/pubs/sp/800/218/final)
- [GitLab Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [Persian: Hheydarian on review process](https://hheydarian.github.io/Gitab/books/book2/Book/02/Code-Review-Process-and-Importance/)
- [Persian: Netparadis review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
