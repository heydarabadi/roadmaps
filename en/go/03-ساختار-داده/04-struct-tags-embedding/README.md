# 3.4 — Structs, JSON tags, and embedding

<div dir="ltr">

**Time:** 120 minutes · **Prerequisite:** types and packages  
**Goal:** Model named fields, control JSON boundaries, and use embedding as composition rather than inheritance.

## Structs and zero values

A struct combines named fields of specified types. Its zero value is a struct whose fields each have their own zero values. Prefer keyed literals because adding fields does not silently change their positional meaning.

~~~go
type Point struct {
    X int
    Y int
}

p := Point{X: 3, Y: 7}
origin := Point{}
~~~

An uppercase field name is exported; an unexported field is generally inaccessible to another package. Packages such as encoding/json commonly process exported fields.

## Struct tags are metadata

A struct tag is a string attached to a field. A package interprets it according to its own rules. A tag does not validate input or provide authorization.

~~~go
type Product struct {
    ID       int64  `json:"id"`
    Name     string `json:"name"`
    Note     string `json:"note,omitempty"`
    Internal string `json:"-"`
}
~~~

The tag uses a Go raw string literal. omitempty follows encoder rules and may omit zero values; it is not suitable when explicit zero or false must be represented. A JSON exclusion tag is not an access-control boundary: another code path may still expose the field.

## Decode, validate, and encode

~~~go
type CreateProduct struct {
    Name  string `json:"name"`
    Price int64  `json:"price"`
}

func validate(req CreateProduct) error {
    if strings.TrimSpace(req.Name) == "" {
        return errors.New("name is required")
    }
    if req.Price < 0 {
        return errors.New("price must not be negative")
    }
    return nil
}
~~~

A JSON decoder may ignore unknown fields by default. DisallowUnknownFields can make input stricter, though that may affect forward compatibility. After decoding one object, check for a second JSON document or trailing content when the contract allows only one value. Parse success is not business validation or authorization.

## Embedding is composition

~~~go
type AuditFields struct {
    CreatedAt time.Time
    UpdatedAt time.Time
}

type Customer struct {
    ID   int64
    Name string
    AuditFields
}
~~~

A selector such as customer.CreatedAt can be promoted from the embedded field. The field still belongs to AuditFields. This is composition, not class inheritance: Go does not add parent-child object behavior or virtual overrides. Promoted selector conflicts at the same depth are ambiguous.

Embedding an exported type in a public struct can expose methods through the public method set. Design the resulting API, not only the shorter field access.

Since Go 1.27, a keyed struct literal can name any valid field selector, including a promoted field from an embedded struct:

~~~go
customer := Customer{
    ID:        7,
    Name:      "Ada",
    CreatedAt: time.Now(),
}
~~~

The value still resides in the embedded field. On older language versions, initialize the nested field explicitly. Check the module language version before using this syntax.

## Separate request, domain, and response types

An HTTP request, database row, and domain object may have different fields and invariants. Reusing one type for every boundary can expose secrets or couple a database change to a public API. Separate DTOs when their contracts differ; do not add layers without a real boundary.

## Common mistakes

- Expecting an unexported field to be encoded from another package.
- Assuming a tag performs validation.
- Treating omitempty as correct for every zero value.
- Using positional literals in evolving public code.
- Treating embedding as inheritance.
- Decoding untrusted JSON without size limits or validation.
- Reusing one struct for private domain data and public response data.

## Guided practice with answers

**1. Design a public user response that cannot expose a password hash.**  
Use a response DTO that does not contain the hash. An exclusion tag may be extra protection but should not replace separate response types.

**2. A numeric zero is valid and must be present in JSON. Why might omitempty be wrong?**  
The encoder may omit it. Use a presence representation, such as a pointer or custom DTO behavior, when absence differs from zero.

**3. When is embedding appropriate?**  
When composition is meaningful and promoted fields or methods are suitable for the resulting API.

## Quiz

### Questions

1. How is a struct zero value formed?
2. What does an uppercase field name imply?
3. Does a struct tag validate a value?
4. Which fields does encoding/json commonly process?
5. What does omitempty affect?
6. Why is a JSON exclusion tag not a security boundary?
7. What does embedding promote?
8. Is embedding class inheritance?
9. Why are keyed literals usually safer?
10. Why might an HTTP DTO differ from a domain type?
11. Does successful decoding mean business input is valid?
12. What decoder option rejects unknown fields?
13. What changed for promoted fields in keyed struct literals in Go 1.27?

### Answer key

1. Each field receives its own zero value.
2. The field is exported.
3. No. A package interprets it as metadata.
4. Exported fields.
5. It may omit fields that satisfy the encoder’s empty-value rules.
6. Another code path may expose the value; the tag controls one encoding path only.
7. Selected fields and methods from the embedded type.
8. No. It is composition.
9. Field-order changes are less likely to change literal meaning.
10. API contracts, persistence, and domain invariants may differ.
11. No. Validation and authorization remain separate.
12. Decoder.DisallowUnknownFields.
13. A promoted field selector may be named directly as a keyed literal field.

## References and further reading

- [Go specification: struct types](https://go.dev/ref/spec#Struct_types)
- [Go specification: struct literals](https://go.dev/ref/spec#Composite_literals)
- [encoding/json package](https://pkg.go.dev/encoding/json)
- [Go 1.27 release notes](https://go.dev/doc/go1.27)
- [Go blog: JSON and Go](https://go.dev/blog/json)
- [Go Code Review Comments: copying](https://go.dev/wiki/CodeReviewComments#copying)
- [Effective Go: embedding](https://go.dev/doc/effective_go#embedding)
- [A Tour of Go: structs](https://go.dev/tour/moretypes/2)

[Persian version](README.md) · [Next chapter: control flow](../../04-کنترل-و-توابع/01-loops-conditionals/README.en.md)

</div>
