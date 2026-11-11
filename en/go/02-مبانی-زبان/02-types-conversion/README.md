# 2.2 — Types, numeric values, and conversions

<div dir="ltr">

**Time:** 90 minutes · **Prerequisite:** variables and constants  
**Goal:** Choose numeric and text-related types deliberately, understand representation limits, and convert values explicitly.

## Boolean and numeric types

bool has the values true and false. Go does not treat integers as booleans in conditions; comparisons must be explicit.

Common integer types are int, int8, int16, int32, int64, and their unsigned counterparts. int is machine-sized and is usually suitable for indexing and general counts. Use a fixed-width type when width is part of a file format or protocol. Unsigned types are not a general replacement for signed numbers; subtraction below zero can wrap.

float32 and float64 are binary floating-point approximations. Direct equality can be unsuitable for calculations that accumulate rounding error. For money, choose a domain-safe representation such as integer minor units or a decimal type with a documented rounding policy.

complex64 and complex128 represent complex numbers. They are useful in numerical domains and uncommon in ordinary backend business logic.

## Overflow and precision

Integer operations do not automatically report overflow. Validate bounds before conversion or arithmetic when external input can approach a type’s limits.

~~~go
var amount int64 = 9_007_199_254_740_993
approximation := float64(amount)
// Not every adjacent integer is representable at this magnitude.
_ = approximation
~~~

The conversion may lose precision. A successful conversion means the language permits it, not that the exact mathematical value survives.

## Explicit conversion

Go does not silently convert most numeric values between types.

~~~go
var count int64 = 42
small := int32(count)
ratio := float64(count) / 10
_ = small
_ = ratio
~~~

A conversion can narrow a range or lose precision. Validate before converting a wide external number to a narrower type:

~~~go
if count < 0 || count > math.MaxInt32 {
    return fmt.Errorf("count out of range")
}
value := int32(count)
_ = value
~~~

The exact bounds and policy depend on the destination type and domain. A cast is not validation.

## Byte, rune, and text

byte is an alias for uint8 and represents one byte. A byte is not necessarily a complete text character. rune is an alias for int32 and commonly represents one Unicode code point. A user-visible grapheme may contain multiple code points.

A Go string is an immutable sequence of bytes, commonly UTF-8. Indexing a string returns a byte. Use range to decode code points, and use a Unicode segmentation library when a requirement is about user-visible characters.

## Domain-specific named types

A named type can communicate domain intent and prevent unrelated values from mixing accidentally:

~~~go
type UserID int64
type OrderID int64

func LoadUser(id UserID) error {
    return nil
}
~~~

Conversion between UserID and OrderID should be explicit. A named type does not prove that an identifier exists; domain checks remain necessary.

## Common mistakes

- Assuming int has the same width on every architecture.
- Assuming conversion checks whether a value fits.
- Using float equality for computed results.
- Storing financial values as floating point without a rounding policy.
- Treating byte, rune, and visible character as interchangeable.
- Using unsigned arithmetic when negative intermediate values are possible.

## Guided practice with answers

**1. A JSON field can contain an arbitrary int64, but an internal API accepts int32. What should happen?**  
Check the value against the int32 range before conversion; return a validation error if it is outside the range.

**2. Why can arithmetic on decimal fractions fail an exact equality check?**  
Binary floating point cannot represent many decimal fractions exactly, so an operation may return a nearby approximation.

**3. Which type represents a UTF-8 byte and which commonly represents a code point?**  
byte represents one byte; rune commonly represents a Unicode code point.

## Quiz

### Questions

1. Does Go implicitly convert an integer to bool?
2. What is int commonly useful for?
3. When should a fixed-width integer be considered?
4. What does an unsigned integer exclude?
5. Why can float equality be surprising?
6. Is a numeric conversion a range check?
7. What is byte an alias for?
8. What is rune an alias for?
9. Is one rune always one visible character?
10. How should money be represented?
11. What can a named domain type communicate?
12. What should be checked before narrowing a value?

### Answer key

1. No.
2. Indexes and ordinary machine-sized counts.
3. When width is part of a storage or wire format.
4. Negative values.
5. Many decimal fractions are approximations in binary.
6. No. Validate bounds and domain rules.
7. uint8.
8. int32.
9. No; a grapheme may contain several code points.
10. With an explicit policy, commonly integer minor units or an appropriate decimal representation.
11. A distinction between values with the same underlying representation.
12. That the value fits the destination range and satisfies domain rules.

## References and further reading

- [Go specification: numeric types](https://go.dev/ref/spec#Numeric_types)
- [Go specification: conversions](https://go.dev/ref/spec#Conversions)
- [Go specification: string types](https://go.dev/ref/spec#String_types)
- [Go specification: predeclared identifiers](https://go.dev/ref/spec#Predeclared_identifiers)
- [Go blog: constants](https://go.dev/blog/constants)
- [Go blog: strings, bytes, runes, and characters](https://go.dev/blog/strings)
- [math package](https://pkg.go.dev/math)
- [unicode/utf8 package](https://pkg.go.dev/unicode/utf8)
- [Go FAQ: floating-point equality](https://go.dev/doc/faq#Floating_point)

[Persian version](README.md) · [Next: arrays and slices](../../03-ساختار-داده/01-arrays-slices/README.en.md)

</div>