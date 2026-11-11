# 2.1 — Variables, zero values, constants, and scope

<div dir="ltr">

**Time:** 90 minutes · **Prerequisite:** a basic Go program  
**Goal:** Declare and update values deliberately, understand zero values, and avoid accidental shadowing.

## Declarations

A variable is a named storage location with a type. Go checks whether operations are valid for that type. A local variable that is declared but never used usually causes a compile error.

~~~go
var count int = 4
var name string
count = 5

limit := 12 // short declaration, only inside a function
~~~

Use var when the type or package-level declaration should be explicit, or when assignment comes later. Use := for a local value initialized from an expression. := declares; = assigns to an existing variable.

## Zero values

Every variable has a zero value before explicit assignment:

| Type | Zero value |
|---|---|
| integer and floating-point types | 0 |
| bool | false |
| string | empty string |
| pointer, map, slice, channel, function, interface | nil |
| struct | a struct whose fields each have their own zero value |

~~~go
var count int
var enabled bool
var label string
var values []int
var lookup map[string]int

values = append(values, 7) // append accepts a nil slice
lookup = make(map[string]int)
lookup["ready"] = 1
~~~

Reading a nil map is allowed and returns the value type’s zero value. Writing to a nil map panics. Appending to a nil slice is allowed and returns a usable slice. These are different rules; do not infer that every nil collection is writable.

## Scope and shadowing

Scope is the region where a name is visible. Functions, if statements, loops, and explicit blocks create scopes. A declaration in an inner scope can shadow an outer name.

~~~go
status := "pending"
if true {
    status := "paid" // a new variable in the inner block
    fmt.Println(status)
}
fmt.Println(status) // still "pending"
~~~

To update the outer variable, assign to it:

~~~go
status := "pending"
if ready {
    status = "paid"
}
~~~

A common error trap:

~~~go
var err error
if ready {
    result, err := doWork() // this may declare a new inner err
    _ = result
    _ = err
}
// The outer err may still be nil.
~~~

At least one name must be new for := to be valid in the current scope. Ask whether each name on the left side refers to the variable you intended. Static analysis may find likely mistakes, but understanding scope remains important.

## Constants and iota

A constant is an immutable compile-time value. Go constants can be boolean, string, rune, or numeric. A runtime value such as time.Now() cannot be a constant.

~~~go
const maxRetries = 4
const serviceName = "catalog"

const (
    StatusUnknown = iota // 0
    StatusQueued          // 1
    StatusPaid            // 2
    StatusSent            // 3
)
~~~

iota increments at each specification in a const block. It is useful for local enumerations. Do not reorder values if their numeric representation is stored in a database, protocol, or public API. Use explicit values for stable contracts.

## Names and the blank identifier

An exported name begins with an uppercase letter. A lowercase name is package-private. Go commonly uses MixedCaps rather than underscores in identifiers.

The blank identifier _ intentionally discards a value. Ignoring an error should be a deliberate decision, not a shortcut.

## Common mistakes

- Using := at package scope.
- Expecting a nil map to accept writes.
- Defining a runtime expression as a constant.
- Accidentally shadowing err or another outer variable.
- Ignoring an error without documenting why.
- Reordering iota values that have become a persistent contract.

## Guided practice with answers

**1. Declare a counter with an explicit type, then update it.**  
Use var count int = 0, followed by count = count + 1 or count++.

**2. Why may this fail to update the outer error?**  
~~~go
var err error
if ready {
    _, err := doWork()
}
~~~
**Answer:** The short declaration is inside the if block and can introduce an inner err. If err already exists in the same scope, use assignment or restructure the code so the binding is clear.

**3. What should you do before persisting an iota value?**  
Define a stable explicit mapping and treat it as a versioned contract.

## Quiz

### Questions

1. What does := do?
2. Where can a short declaration be used?
3. What is the zero value of bool?
4. What is the zero value of string?
5. Can append operate on a nil slice?
6. Can you write to a nil map?
7. What is scope?
8. What is shadowing?
9. What can go wrong with err inside a nested block?
10. What does iota provide?
11. Can a constant call time.Now()?
12. What does the blank identifier mean?

### Answer key

1. It declares and initializes one or more local variables.
2. Inside a function, not at package scope.
3. false.
4. The empty string.
5. Yes; append returns the resulting slice.
6. No; writing to a nil map panics.
7. The region where a name can be referenced.
8. An inner declaration hides a same-named outer value.
9. A new inner error variable may be created, leaving the outer error unchanged.
10. An incrementing constant value within a const block.
11. No; that is a runtime value.
12. A value is intentionally discarded.

## References and further reading

- [Go specification: declarations and scope](https://go.dev/ref/spec#Declarations_and_scope)
- [Go specification: variable declarations](https://go.dev/ref/spec#Variable_declarations)
- [Go specification: constant declarations](https://go.dev/ref/spec#Constant_declarations)
- [Go specification: iota](https://go.dev/ref/spec#Iota)
- [Go Code Review Comments: mixed caps](https://go.dev/wiki/CodeReviewComments#mixed-caps)
- [Go FAQ: unused variables](https://go.dev/doc/faq#unused_variables)
- [A Tour of Go: short declarations](https://go.dev/tour/basics/10)

[Persian version](README.md) · [Next: types and conversions](../02-types-conversion/README.en.md)

</div>