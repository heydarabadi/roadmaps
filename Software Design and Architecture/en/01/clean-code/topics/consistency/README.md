<div dir="ltr" align="left">

# Consistency in Code

> **Language:** [Read the Persian edition](../../../../../01/clean-code/topics/consistency/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Choose conventions that make code easier to scan and review, use tools for mechanical consistency, and distinguish a formatting difference from a real difference in behavior or domain meaning.

## Why consistency helps

Code is a shared language for a team. If each module formats dates, represents expected errors, names operations, or orders imports differently, readers must repeatedly learn local conventions. A small set of consistent rules reduces that mental overhead and lets reviews focus on behavior and design.

Good conventions usually cover:

- Formatting and import order.
- Naming and units.
- The shape of expected failures.
- File and module organization.
- Stable API and serialization rules.

Automate rules that can be checked mechanically with a formatter, linter, or schema validator. Document semantic conventions that need judgment, then check them in review and tests. Keep broad formatting-only changes separate from behavior changes so reviewers can see each clearly.

## Example: expected errors

Suppose three endpoints report expected failures in three ways: one returns `null`, another throws an exception, and a third returns a `Result` object. Clients must know which contract applies to each endpoint. Agree on a consistent representation for expected failures, and reserve exceptions for exceptional failures when that fits the language and framework.

Consistency should not erase meaning. “Payment declined” and “configuration file missing” might share a response envelope, but they should keep distinct error codes and recovery guidance because they require different actions.

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Result:
    value: object | None = None
    error_code: str | None = None

    @property
    def ok(self) -> bool:
        return self.error_code is None
```

## Boundaries and costs

Blind consistency can hide differences between domains, and a poor convention can spread mistakes across the repository. Try a proposed rule on real examples before making it universal. Pin or align formatter versions so developers and CI produce the same output.

## Practice

Compare three modules. Propose conventions for dates, expected errors, and API names. Mark which rules a tool can enforce and which require design review. Include one exception that preserves an important semantic difference.

## Quiz with answers

1. **What should a team standardize?**
   **Answer:** Low-value differences such as formatting, units, naming shape, and error envelopes when they express the same contract. Preserve real differences in meaning and recovery behavior.

2. **Why automate formatting rules?**
   **Answer:** Automation applies mechanical rules consistently and avoids repeated review discussion about changes that a tool can make reliably.

3. **How can a team make a broad style change safer?**
   **Answer:** Make it a separate, mechanical change with a focused diff. Do not combine it with behavior changes, and verify that the formatter version is consistent.

4. **Should every error use exactly the same code and message?**
   **Answer:** No. A shared response shape can coexist with different error codes and recovery actions.

5. **What is the risk of enforcing one convention without checking the domain?**
   **Answer:** The convention may flatten meaningful differences or propagate an incorrect contract across the system.

## Further reading

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Clean Code JavaScript](https://github.com/ryanmcdermott/clean-code-javascript)
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
