# 6.1 — Methods and interfaces

<div dir="ltr">

**Time:** 150 minutes · **Prerequisite:** structs, pointers, and functions  
**Goal:** Choose receiver semantics, satisfy interfaces implicitly, and use interfaces at meaningful boundaries.

## Methods and receivers

A method is a function associated with a receiver type.

~~~go
type Counter struct {
    Value int
}

func (c Counter) Current() int {
    return c.Value
}

func (c *Counter) Increment() {
    c.Value++
}
~~~

A value receiver operates on a copy. A pointer receiver can mutate the original and avoid copying a large value. A pointer receiver may also be required when copying the type would be unsafe or semantically wrong.

The method set differs between T and *T. Go may automatically take an address for a direct method call on an addressable value, but that convenience does not change interface method-set rules.

## Interfaces are implicit contracts

An interface describes methods a value can provide. A type satisfies it implicitly by implementing the required method set.

~~~go
type Reader interface {
    Read(p []byte) (n int, err error)
}
~~~

Prefer small interfaces defined near the code that consumes the behavior. This makes dependencies easy to replace and tests focused. Do not create an interface for every concrete type merely to follow a pattern.

Returning a concrete type is often better when callers need its specific API and no real substitution boundary exists. Abstraction has a cost.

## Type assertions and type switches

~~~go
value, ok := input.(string)
if !ok {
    return errors.New("expected string")
}
_ = value
~~~

The two-result assertion avoids panic. A type switch can branch across several concrete types. Keep such code near a genuine dynamic boundary; ordinary application logic should usually use explicit types.

## Nil interfaces and typed nil

An interface value conceptually contains a dynamic type and dynamic value. A nil pointer stored in an interface is not the same as a nil interface.

~~~go
var pointer *MyError
var err error = pointer
fmt.Println(err == nil) // false
~~~

This is a common reason for a function to appear to return a non-nil error despite a nil pointer. Prefer concrete error values or avoid returning typed nils.

## Embedding interfaces and method sets

An interface can embed smaller interfaces to compose a contract:

~~~go
type ReadWriter interface {
    Reader
    Writer
}
~~~

The resulting interface requires the union of the embedded method sets. Keep the resulting contract as small as the consumer needs.

A compile-time assertion can document intended implementation:

~~~go
var _ io.Reader = (*FileReader)(nil)
~~~

## Common mistakes

- Choosing a pointer receiver without considering mutation, copying, and method sets.
- Assuming an addressable value’s automatic method call means T satisfies an interface requiring pointer methods.
- Defining a broad interface far from its consumer.
- Using a type assertion without checking its result.
- Returning typed nil through an interface.
- Embedding a large public interface unnecessarily.
- Treating interfaces as a class hierarchy.

## Guided practice with answers

**1. Why does a nil *MyError inside an error interface compare non-nil?**  
The interface contains a dynamic type, even though its dynamic pointer value is nil.

**2. A function needs only Close. Should it accept a 20-method storage interface?**  
Usually no. Define the minimal interface near the consumer or accept a concrete type if substitution is unnecessary.

**3. How do you check that *FileReader satisfies io.Reader at compile time?**  
Add a compile-time assertion with a blank variable assignment.

## Quiz

### Questions

1. What is a method receiver?
2. What does a value receiver receive?
3. What are two reasons to use a pointer receiver?
4. How do method sets differ for T and *T?
5. How does a Go type declare that it implements an interface?
6. Where should a small interface often be declared?
7. What benefit does a small interface provide?
8. What does the two-result type assertion return?
9. What is any?
10. Why can a typed nil make an error interface non-nil?
11. What does interface embedding do?
12. Is embedding class inheritance?
13. What does a compile-time interface assertion check?
14. When may returning a concrete type be preferable?
15. Why is an oversized interface harmful?
16. What should guide interface design?

### Answer key

1. The value or pointer associated with a method.
2. A copy of the value.
3. Mutate the original or avoid copying a large value.
4. Pointer-receiver methods generally belong to the pointer method set, not the value set.
5. Implicitly, by implementing the required methods.
6. Near the package that consumes the behavior.
7. It reduces coupling and makes focused test doubles easier.
8. The concrete value and a boolean indicating success.
9. An alias for the empty interface, available since Go 1.18.
10. The interface has a dynamic type, so the interface itself is not nil.
11. Combines method requirements from embedded interfaces.
12. No; it is composition.
13. Whether the concrete type satisfies the interface at compile time.
14. When callers need concrete behavior and there is no real substitution boundary.
15. It forces unnecessary methods and increases coupling.
16. The actual behavior the consumer needs.

## References and further reading

- [Go specification: method declarations](https://go.dev/ref/spec#Method_declarations)
- [Go specification: method sets](https://go.dev/ref/spec#Method_sets)
- [Go specification: interface types](https://go.dev/ref/spec#Interface_types)
- [Effective Go: interfaces and methods](https://go.dev/doc/effective_go#interfaces)
- [Go Code Review Comments: interfaces](https://go.dev/wiki/CodeReviewComments#interfaces)
- [Go FAQ: nil error values](https://go.dev/doc/faq#nil_error)
- [io package](https://pkg.go.dev/io)
- [Go blog: errors are values](https://go.dev/blog/errors-are-values)

[Persian version](README.md) · [Next: generics](../02-generics/README.en.md)

</div>