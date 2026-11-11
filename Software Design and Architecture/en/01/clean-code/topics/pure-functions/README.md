<div dir="ltr" align="left">

# Pure Functions

> **Language:** [Read the Persian edition](../../../../../01/clean-code/topics/pure-functions/README.md)

[Clean Code chapter](../../README.md) · [Course index](../../../../00-index.md)

## Learning goals

Define a pure function, distinguish calculation from I/O, identify hidden dependencies, and explain how explicit inputs make behavior easier to test and reason about.

## The principle

A pure function returns the same result for the same inputs and has no externally visible side effects. It does not read or change hidden state such as a global variable, the current clock, a file, a network service, or shared mutable data.

If a calculation depends on time, configuration, a tax rate, or randomness, pass that value as an input. For randomness, pass a generator or seed explicitly. The caller can then control the conditions and reproduce the result.

Purity does not mean that an application has no I/O. Applications must read and write data, send messages, and interact with users. Keep those effects at explicit boundaries and keep the parts that can be pure as ordinary calculations.

## Tax example

A tax calculation should not fetch its own rate. An application boundary can select the applicable rate, then pass it into a calculation. Here the rate uses basis points, where 10,000 basis points equal 100 percent. Rounding is to the nearest cent for nonnegative values.

```python
def tax_cents(subtotal_cents: int, rate_basis_points: int) -> int:
    return (subtotal_cents * rate_basis_points + 5_000) // 10_000

tax = tax_cents(subtotal_cents=12_345, rate_basis_points=825)
```

This function is deterministic for a given subtotal and rate. Test zero, the rounding boundary, representative amounts, and invalid inputs according to the product’s policy. If negative amounts are possible, define how refunds and rounding work rather than relying on this formula without review.

## Trade-offs and limits

Separating I/O can add parameters or small adapters. That is useful when it exposes a meaningful dependency, but a generic context object that hides every dependency can make the function harder to understand. Purity also does not prove that a result is secure, correct for the business, or financially valid; the inputs, rules, and boundaries still need review.

## Practice

Find a function that reads the clock, configuration, a global, or a database. Move the read to its caller or an adapter and pass the value into the calculation. Write cases for boundaries and explain which side effects still belong outside the pure function.

## Quiz with answers

1. **Why is a pure function usually straightforward to test?**
   **Answer:** Its result depends only on explicit inputs, so a test does not need real time, network access, files, or shared state.

2. **What makes a function impure?**
   **Answer:** Reading hidden state or producing a visible effect, such as changing shared state, writing a file, or sending a message.

3. **Should an entire system be pure?**
   **Answer:** No. I/O is necessary. Keep effects explicit and isolate the calculations that can be deterministic.

4. **How should a calculation use the current time?**
   **Answer:** Read the time at an outer boundary and pass the selected timestamp into the calculation.

5. **Does purity guarantee that a tax calculation is correct?**
   **Answer:** No. It only makes the behavior deterministic. The rate, rounding policy, valid range, and legal/product rules must still be correct.

## Further reading

- [Python Functional Programming HOWTO](https://docs.python.org/3/howto/functional.html) — Functions, iterators, and functional techniques in Python.
- [Curated bilingual reference library](../../../../references.md#chapter-01)
</div>
