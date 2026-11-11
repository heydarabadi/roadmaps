# 5.2 — Priority, Style, and Conflict Resolution

**Language:** English · [فارسی](../../../../fa/code-review/05-feedback/02-priority-conflict/README.md)

**Learning outcomes:** Label findings proportionately, apply team conventions consistently, and resolve technical disagreement with evidence.

## Core lesson

Teams use severity labels differently, so define them locally. A practical set is: **blocker** for a confirmed release, security, data, or correctness risk or a mandatory policy gap; **suggestion** for a worthwhile but optional improvement; **question** for missing context; **nit** for a minor preference that must not block merge. A stylistic concern already covered by a formatter is rarely a blocker. A high-impact risk should not be downgraded to a nit to avoid an uncomfortable conversation.

Keep severity separate from certainty. “Potential race under concurrent requests” can be high impact but uncertain; ask for a concurrency invariant or test. Severity describes consequence; certainty describes evidence. Conventional Comments can give teams a shared format such as `suggestion (non-blocking): ...`, but a label does not replace reasoning.

When people disagree, restate the requirement, identify the disputed assumption, compare options, and gather evidence: a test, benchmark, security analysis, production constraint, or design record. If neither option is universally correct, state trade-offs and ask the decision owner. Record the resolution in the review or relevant documentation. Respectful disagreement is not a personal conflict.

## Worked example: naming preference

A reviewer wants a shorter variable name. The author prefers the existing name. If the style guide and linter have no rule and the current name is clear, label the idea as optional or drop it. If the name hides a unit or security meaning, explain the concrete risk. Do not use “blocking” to win a subjective choice.

## Checklist

- [ ] Severity matches the impact and local policy.
- [ ] Confidence is not confused with impact.
- [ ] Style guide and automation settle mechanical preferences.
- [ ] Disputed requirements or assumptions are named.
- [ ] An owner and recorded decision exist when consensus fails.

## Quiz

1. A cosmetic rename is optional. What label fits? **A non-blocking suggestion or nit under the team's convention.**
2. A possible race could corrupt money, but evidence is incomplete. What is best? **State the scenario and impact, then request proof or a test; avoid claiming certainty you do not have.**
3. How should style disputes be resolved? **Use the repository's agreed guide and formatter; otherwise treat personal preference proportionately.**
4. What ends a persistent technical disagreement? **A named decision owner, explicit trade-offs, and a recorded resolution—not rank or volume.**

## Further reading

- [Conventional Comments: labels and decorations](https://conventionalcomments.io/docs/labels/)
- [Google: The Standard of Code Review](https://google.github.io/eng-practices/review/reviewer/standard.html)
- [Google: Handling pushback](https://google.github.io/eng-practices/review/reviewer/pushback.html)
- [GitLab Code Review Guidelines](https://docs.gitlab.com/development/code_review/)
- [Microsoft Engineering Playbook: Code Review FAQ](https://microsoft.github.io/code-with-engineering-playbook/code-reviews/faq/)
- [Persian: Javacup on review methods](https://javacup.ir/code-review-methods/)
- [Persian: Netparadis review guide](https://netparadis.com/code-review-practices-pull-request/?rm=pro-skills)
