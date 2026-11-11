<div dir="ltr" align="left">

# Make Optional Values and Boolean Choices Explicit

> **Language:** [Read the Persian edition](../../../../../../fa/software-design-and-architecture/01/clean-code/topics/avoid-null-booleans/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

After this lesson, you should be able to explain why positional booleans and ambiguous `null` values make contracts difficult to understand, choose clearer representations, and preserve the difference between “not provided,” “empty,” and “delete” when those meanings matter.

## The problem

Consider this call:

```python
create_invoice(order, True, None)
```

The reader cannot tell what `True` enables or what `None` means. Does the flag issue the invoice, send it, or do both? Does `None` mean “use the default,” “no customer name,” or “the caller omitted a value”? The function declaration may reveal the meaning, but every caller still requires that context.

`null` and `None` are also overloaded in many APIs. They may represent a missing value, an unknown value, an empty value, an explicit deletion, or a not-yet-loaded value. Those states are not interchangeable when the domain or protocol assigns them different behavior.

## A clearer design

Choose the representation that matches the domain:

1. Use an optional type when a value is either present or absent and absence has one clear meaning.
2. Use an enum or tagged union when there are several named modes.
3. Use separate operations when the behaviors are meaningfully different.
4. In JSON or another patch protocol, document whether an omitted field and an explicit `null` have different effects.
5. Validate incoming data at the boundary so invalid combinations do not enter the domain model.

For example:

```python
from enum import Enum

class InvoiceAction(Enum):
    SAVE_DRAFT = "save_draft"
    ISSUE = "issue"
    ISSUE_AND_SEND = "issue_and_send"

def create_invoice(order, action: InvoiceAction):
    ...

create_invoice(order, action=InvoiceAction.ISSUE_AND_SEND)
```

The call now names the choice. The function still has to validate the invoice’s state and allowed transitions; an enum makes the requested action explicit, but does not enforce the domain rules by itself.

## `null`, omitted fields, and updates

An update API may need to distinguish these requests:

```json
{}
```

```json
{"customerName": null}
```

```json
{"customerName": "Mina"}
```

One possible contract is:

- Omitted `customerName`: leave the existing name unchanged.
- `customerName: null`: clear the name, if clearing is allowed.
- A string value: replace the name after validation.

Another API may assign different meanings. State the contract explicitly and test each case. Do not infer the behavior from a language’s default null handling.

## Trade-offs and limits

Named enums and option types add types, mapping, and serialization work. Use them when they make an important state or choice clearer. If a boolean truly has one obvious meaning at every call site, adding a wrapper type may add ceremony without helping. Do not hide absence when it is a meaningful domain state, and do not use `null` to represent several unrelated states.

## Practice

Find an API that accepts `true`, `false`, or `null`. List every possible value and its effect. Redesign the call using a named option, a small request type, or separate operations. Include the expected behavior for omitted and explicit-null fields, then write a test for each case.

## Quiz with answers

1. **Why is `create_invoice(order, true, null)` hard to review?**
   **Answer:** Neither the boolean nor `null` describes its meaning. The caller’s intent and the valid combinations are hidden.

2. **When is `null` an acceptable value?**
   **Answer:** When the contract defines its meaning as a real state, such as an optional value or an explicit deletion, and that meaning is distinct from omission where necessary.

3. **When is an enum clearer than a boolean?**
   **Answer:** When a choice has multiple meaningful modes or when the boolean’s effect is not obvious at the call site. An enum names the alternatives.

4. **Does an enum guarantee that a requested transition is valid?**
   **Answer:** No. The domain still has to validate the current state and enforce the transition rules.

5. **In a patch request, how should an omitted field differ from a field whose value is `null`?**
   **Answer:** The API must specify this. A common contract treats omission as “leave unchanged” and `null` as “clear,” but this is a design choice that must be documented and tested.

## Further reading

- [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html) — Naming and API conventions in a large language-specific project.
- [Clean Code JavaScript](https://github.com/ryanmcdermott/clean-code-javascript) — Examples of clearer function arguments and API design.
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
