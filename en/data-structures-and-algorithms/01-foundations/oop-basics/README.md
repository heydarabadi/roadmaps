# Object-Oriented Programming Basics for DSA

> Path: [Chapter 1 — Foundations and Algorithm Analysis](../README.md) · Prerequisite: functions, data types, and collections  
> Language: English · [Read this lesson in Persian](../../../../fa/data-structures-and-algorithms/01-foundations/oop-basics/README.md)

## Prerequisites and mental model

Object-oriented programming organizes related state and operations into classes and objects. In DSA, a class can implement a node, stack, or graph; an interface/API specifies the operations, while the representation remains an implementation detail. Encapsulation lets the representation change without breaking callers.

## The idea from first principles

A class defines a type and behavior; an object is an instance; fields hold state; methods implement behavior. A constructor establishes the initial invariant. Composition means one object contains or uses another; inheritance defines a subtype relationship. For data structures, composition and encapsulation are often clearer than deep inheritance.

An invariant is a statement that must remain true for an object's state. Each public method must preserve it.

## Step-by-step example: a stack API

Expose `push`, `pop`, `peek`, and `isEmpty`, while hiding whether the implementation uses an array or linked list. After each method, the stack's invariant—such as a valid top index—must hold. Callers should not mutate internal fields in a way that breaks the invariant.

Define behavior for an empty pop and for capacity exhaustion. Specify whether the method throws, returns an optional result, or reports failure some other way.

## Worked comparison

Two stack implementations can use a dynamic array or linked list. The same client can call `push` and `pop` on both because their LIFO contract is the same, even though their costs differ. This is the relationship between an abstract data type and its implementation.

For a trace, record the public operation, internal state change, invariant check, and returned value.

## Why the design remains correct

The constructor creates a valid state; each public method obeys its preconditions and postconditions. If a method throws, the object should remain valid or the failure behavior must be documented. Encapsulation prevents external code from bypassing those checks.

## Time and space analysis

OOP does not automatically change asymptotic complexity. Virtual dispatch is typically constant overhead, while object allocation and pointer indirection can matter for large workloads. Abstraction adds some cost but can improve maintainability and correctness.

## Practical use

Collection libraries, graph nodes, domain models, and replaceable implementations all use these ideas. Simple records may be enough in a contest solution; stable APIs and testability are important in a product.

## Common mistakes and edge cases

- Inheritance used only for code reuse can create tight coupling.
- Exposing mutable fields lets callers break invariants.
- Many small allocations can affect cache locality.
- Excessive abstraction can hide the data path.
- Consider constructor failure, empty structures, and exception safety.

## Step-by-step exercises

1. Design a stack class with both array and linked-list representations.
2. Define its invariant and behavior for `pop` on an empty stack.
3. Compare composition and inheritance for a graph and its vertices.

First write a correct baseline, analyze the design, and add edge cases. Trace a small sequence of method calls and check the resulting state.

## Comprehensive quiz with explained answers

1. **What is the difference between a class and an object?** A class defines a type and behavior; an object is a constructed instance.
2. **What is encapsulation for?** Hiding representation and protecting invariants.
3. **What does an interface provide?** An operation contract independent of implementation.
4. **Does OOP automatically change algorithmic complexity?** No; semantics and representation still determine cost.
5. **What is composition?** Building behavior by holding or using other objects.

## Recall checklist

Explain the class/object distinction, contract, invariant, representation choice, and one cost trade-off from memory. If callers can directly invalidate the state, revisit encapsulation.

## Further reading and references

- [Python Tutorial — Classes](https://docs.python.org/3/tutorial/classes.html) — objects, classes, and methods.
- [Oracle Java Tutorials — Classes and Objects](https://docs.oracle.com/javase/tutorial/java/javaOO/classes.html) — class structure and object behavior.
- [Microsoft Learn — Object-Oriented Programming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/tutorials/oop) — C# classes, encapsulation, and object design.
- [MIT 6.006 — Lecture Notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/pages/lecture-notes/) — data structures and algorithm reasoning.
- [Persian supplementary course — Data Structures and Algorithms](https://valinejad.ir/courses/data-structures-algorithms/index.html).
- [Roadmap reference](https://roadmap.sh/datastructures-and-algorithms).

## Mastery checklist

- [ ] I can define a class invariant and protect it through the API.
- [ ] I can distinguish interface from representation.
- [ ] I can compare composition and inheritance.
- [ ] I have completed and reviewed the exercises independently.
