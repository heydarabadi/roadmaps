<div dir="ltr" align="left">

# Meaningful names over comments

> **Language:** [Persian edition](../../../../../../fa/software-design-and-architecture/01/clean-code/topics/meaningful-names/README.md)

[Chapter Clean Code](../../README.md) · [Course List](../../../../00-index.md)

## The purpose of the lesson

After this lesson, you should be able to identify when the idea helps, apply it to an example, and justify your choice and its costs.

## Detailed lesson

A name is the first explanation of code. A good name communicates the domain concept, role, effect, or unit. Vague names such as value or data force readers to inspect the implementation and its call sites. Use an action verb for behavior and a type name for a stable concept.

How to choose a name:
1. Use the domain vocabulary so the team and the code share the same language.
2. Make units and boundaries explicit; for example, use timeoutSeconds instead of timeout.
3. Read the name at the call site. Can a reader understand the intent without opening the function?
4. Use comments to explain the rationale, a non-obvious constraint, or the source of a decision. The name and structure should make the code itself clear.

## Practical scenario

The expression amount * 1.09 does not say whether the amount includes tax, which currency is used, how rounding works, or where the rate comes from. Names such as subtotalCents and taxRateBasisPoints make units explicit. If 9% is a temporary legal rate, a comment should explain why that rate and date were chosen instead of restating the arithmetic.

## Boundary and cost

Overly long names, unfamiliar terms, and comments on every line create noise. Prefer a precise name to an artificially short one, but do not use a name to hide multi-step logic. A stale comment can be more dangerous than no comment.

## Practice

Find five vague names in a payment flow. Rewrite them to communicate role and unit, then remove comments that merely repeat the code and identify any rationale that still needs to be documented.

## Sample code or contract
~~~python
def refund_amount_cents(paid_amount_cents: int, already_refunded_cents: int) -> int:
    return paid_amount_cents - already_refunded_cents
~~~
## Apply and assess

Choose an example of your own code or a tutorial project. Apply the concept in a small change, add a test for boundary behavior, and record in one sentence what made it more readable or safer.

## Quiz with descriptive answer

Write down your reasoning before reading the answer. Compare it with the explanation; another answer may also work if it fits the context and makes its trade-offs clear.

1. **What can a good name achieve?**
   - Descriptive answer: the domain concept, role, effect, unit, scope and level of abstraction.
2. **What do we keep the comment for?**
   - Descriptive answer: explain the rationale, non-obvious constraint, or decision that the code and names do not make clear.
3. **Why is an old comment dangerous?**
   - Descriptive answer: Readers may trust the obsolete description even though the code now behaves differently.

## Optional Persian and English references

This lesson covers the core ideas. Use the references for alternative explanations and optional deeper study.

### Persian

- [DevNA; Clean Code principles](https://devna.ir/articles/clean-code-principles)
- [JavaScript.info; Persian coding style](https://fa.javascript.info/coding-style)

### English

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- [Clean Code JavaScript](https://github.com/ryanmcdermott/clean-code-javascript)



## Further reading

[Curated references for this chapter](../../../../references.md#chapter-01)
</div>
