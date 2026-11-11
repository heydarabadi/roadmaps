# 6.2 — Generics, constraints, and type parameters

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** functions, interfaces, maps, and slices  
**Goal:** Reuse algorithms across types while keeping operations type-safe, and recognize when generics add unnecessary complexity.

## Why generics?

Generics let a function or type operate over a family of types while preserving static checking. Use them when the algorithm is the same across several types. A concrete function is often clearer when there is only one meaningful type. An interface is often better when the variation is behavior at runtime.

## Generic functions and inference

~~~go
func First[T any](values []T) (T, bool) {
    if len(values) == 0 {
        var zero T
        return zero, false
    }
    return values[0], true
}
~~~

T is a type parameter. any is the empty interface constraint and permits every type. At a call site, the compiler can often infer the type argument from the input.

~~~go
first, ok := First([]string{"go", "tool"})
_ = first
_ = ok
~~~

Inference shortens calls but does not remove the need to understand the constraint.

## Constraints and type sets

A constraint describes which types and operations are permitted:

~~~go
type Number interface {
    ~int | ~int64 | ~float64
}

func Sum[T Number](values []T) T {
    var total T
    for _, value := range values {
        total += value
    }
    return total
}
~~~

The tilde includes types whose underlying type matches the listed type. A type set can combine alternatives. The compiler allows only operations valid for every type in the constraint.

The built-in comparable constraint is useful for map keys and equality-based algorithms. It does not necessarily express domain equality. Two records can be structurally comparable yet business-equal only by a selected identifier.

## Generic types

~~~go
type Set[E comparable] map[E]struct{}

func (s Set[E]) Add(value E) {
    s[value] = struct{}{}
}
~~~

The type parameter E applies to the generic type and its methods. The zero value of this map-based Set is nil, so writes require initialization or a method design that returns an initialized value.

## Generic methods in Go 1.27

Go 1.27 adds methods that declare their own type parameters:

~~~go
type List[E any] []E

func (list List[E]) Map[R any](convert func(E) R) List[R] {
    result := make(List[R], len(list))
    for index, value := range list {
        result[index] = convert(value)
    }
    return result
}
~~~

The receiver contributes E; the method declares R. The compiler can infer R from the callback. Interface methods still cannot declare their own type parameters, and a generic method does not implement a generic interface method. Check the module’s language version before using this feature. A standalone generic function remains useful when compatibility with older modules matters.

## Common mistakes

- Using any without a constraint that permits the required operations.
- Adding a generic abstraction for one concrete use.
- Confusing type parameters with runtime interface dispatch.
- Using comparable as a substitute for business equality.
- Making a constraint so complex that users cannot understand allowed types.
- Assuming generic interface methods exist in Go 1.27.

## Guided practice with answers

**1. Why can the compiler not use + for a T constrained by any?**  
The constraint allows types such as structs and maps for which + is invalid.

**2. What does tilde int allow?**  
Types whose underlying type is int, including named types based on int.

**3. When is a generic function less suitable than an interface?**  
When the behavior varies by runtime implementation rather than by a shared compile-time algorithm.

## Quiz

### Questions

1. What problem do generics address?
2. What is a type parameter?
3. What does any allow?
4. What is a constraint?
5. What does a type set describe?
6. What does tilde mean in a constraint?
7. What can type inference determine?
8. What does comparable permit?
9. Does comparable always match domain equality?
10. Can a generic type have methods?
11. Which release added generic methods?
12. Can an interface method declare an independent type parameter in Go 1.27?
13. Why can a generic method fail to satisfy an interface method?
14. When is a concrete implementation clearer than a generic one?
15. When is an interface better than a generic?
16. What should be checked before using a version-specific generic feature?

### Answer key

1. Reusing algorithms and data structures across types with static type checking.
2. A type variable used in a generic declaration.
3. Any type, but it does not guarantee specific operations.
4. A set of types and operations allowed for a type parameter.
5. The types that satisfy a constraint.
6. Types with the listed underlying type.
7. Type arguments from call-site values or context.
8. Equality and inequality operations for permitted types.
9. No; structural equality may differ from domain equality.
10. Yes; methods can use the type parameters of their generic receiver.
11. Go 1.27.
12. No.
13. Interface methods cannot declare their own type parameters.
14. When only one type is needed and the abstraction adds little value.
15. When runtime implementations vary behind a behavior contract.
16. The module language version and official documentation for that version.

## References and further reading

- [Go specification: type parameter declarations](https://go.dev/ref/spec#Type_parameter_declarations)
- [Go specification: interface types and constraints](https://go.dev/ref/spec#Interface_types)
- [Go blog: an introduction to generics](https://go.dev/blog/intro-generics)
- [Go blog: generic methods](https://go.dev/blog/generic-methods)
- [Go 1.27 release notes](https://go.dev/doc/go1.27)
- [cmp package](https://pkg.go.dev/cmp)
- [slices package](https://pkg.go.dev/slices)
- [maps package](https://pkg.go.dev/maps)

[Persian version](README.md) · [Next chapter: packages and modules](../../07-packages-modules/01-packages-modules/README.en.md)

</div>