<div dir="ltr" align="left">

# Choose Language Constructs That Express the Domain

> **Language:** [Read the Persian edition](../../../../../../fa/software-design-and-architecture/01/clean-code/topics/right-constructs/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Choose types and control structures that make valid states and operations clearer, while recognizing that a type alone does not enforce every domain invariant.

## The idea

Programming languages provide more than strings, numbers, and booleans. Enums, tagged unions, value objects, collections, pattern matching, and explicit result types can express the choices a program actually supports.

If order status is an unrestricted string, a typo such as `paied` can enter the system. An enum limits the set of names, but the domain still has to enforce valid transitions: for example, a paid order may be shipped but not returned to a draft state. A `Money` type can keep amount and currency together so that adding dollars to rials is rejected or requires explicit conversion.

```python
from dataclasses import dataclass
from enum import Enum

class OrderStatus(Enum):
    DRAFT = "draft"
    PAID = "paid"
    SHIPPED = "shipped"

@dataclass(frozen=True)
class Money:
    amount_minor_units: int
    currency: str
```

The type choices make the vocabulary visible. They do not replace validation at untrusted boundaries or rules for state transitions and currency conversion.

## Trade-offs and practice

More types can add mapping and serialization work. Use a type when it protects meaning, prevents invalid combinations, or makes a contract easier to use. Do not wrap every primitive automatically.

Find a field stored as a free-form string or a positional boolean. List the valid values and transitions. Choose a type that makes the valid alternatives visible, then test boundary input and invalid transitions.

## Quiz with answers

1. **What risk does an enum reduce compared with an unrestricted string?**
   **Answer:** It limits the values that callers can represent and makes the allowed alternatives visible to tools and readers.

2. **Does an enum guarantee that `PAID` can transition to `SHIPPED` only once?**
   **Answer:** No. The domain operation must enforce the transition rule.

3. **Why might `Money` be clearer than a decimal amount alone?**
   **Answer:** Currency is part of the amount’s meaning, so a value object can preserve units and define valid arithmetic.

## Further reading

- [Python Enum documentation](https://docs.python.org/3/library/enum.html)
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
