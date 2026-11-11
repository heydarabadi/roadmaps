<div dir="ltr" align="left">

# Indentation and Code Style

> **Language:** [Read the Persian edition](../../../../../01/clean-code/topics/indentation-style/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Use consistent formatting to reveal code structure, distinguish mechanical style rules from semantic design decisions, and keep formatting changes reviewable.

## Why style matters

Formatting turns syntax into visual cues. Consistent indentation, line breaks, and block structure help readers see nesting and control flow before they inspect each token. Formatting does not prove that the logic is correct, but it makes the logic cheaper to read and compare.

Use a formatter for rules it can apply mechanically. Avoid hand-aligning code in ways that a formatter will undo. Keep language conventions consistent, and keep generated files or project-specific exceptions explicit.

## Example

Deep nesting and several unrelated tasks inside one branch can hide the behavior. A guard clause can make an early rejection visible; extracting a cohesive operation can name a domain decision. Formatting helps expose the structure, but it cannot decide whether the branch belongs in this function.

```text
format: run on save and before commit
lint: run in CI and report violations
semantic rules: explain in review guidance and cover with tests
```

## Trade-offs and practice

Style is partly a team and language convention. Do not spend review time debating low-value whitespace once a formatter can settle it. Avoid a repository-wide formatting change mixed with behavior changes: reviewers need to distinguish the logic change from mechanical output.

Run the project formatter and linter. Put their changes in a separate diff and note which rules the tools enforce and which still need judgment.

## Quiz with answers

1. **Does formatting prove that a function is correct?**
   **Answer:** No. It makes structure easier to see, but correctness still requires reasoning and appropriate tests.

2. **Why use an automated formatter?**
   **Answer:** It applies mechanical style rules consistently and keeps reviewers focused on behavior and design.

3. **How should a broad formatting change be reviewed?**
   **Answer:** Keep it separate from behavioral edits and use a focused diff so the logical change remains visible.

## Further reading

- [Google Style Guides](https://google.github.io/styleguide/)
- [PEP 8: Python Style Guide](https://peps.python.org/pep-0008/)
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
