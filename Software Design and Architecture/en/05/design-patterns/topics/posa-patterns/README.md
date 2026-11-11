<div dir="ltr" align="left">

# POSA patterns — Pattern-Oriented Software Architecture (POSA)
> **Language:** [Persian edition](../../../../../05/design-patterns/README.md)
> [Continue with the full chapter lesson](../../lessons.md) — examples, trade-offs, and a comprehensive quiz.

**Location in the roadmap:** [Design Patterns](../../README.md) · [Course Index](../../../../00-index.md)
## Learning goals

After this lesson, you will be able to define the concept in your own language, recognize it in a domain example, and explain the cost of choosing or leaving it aside.
## Core idea

POSA patterns capture recurring architectural forces and structures, including concurrency and distributed-system concerns.
They typically describe collaboration at a larger scale than the object-level patterns in the GoF catalog.
## Practical example

For parallel processing, compare a Broker design with a direct alternative. Record the change pressure, control flow, and failure boundaries before choosing.
This example is educational and does not claim to be an exact implementation for a specific company.
A documented industrial example and its context are linked in the "Design Patterns" chapter.
## Design choices and trade-offs

- **Use it when:** the need described above occurs and the trade-offs fit your system; validate the choice with a test, design review, or operational evidence.
- **When to keep it simple:** Architectural catalogs are influenced by technology and problem type.
The name of a pattern does not guarantee compatibility.
- **Review:** Do not introduce the POSA model as a framework or a fixed organizational version.
## Quiz with descriptive answer

Hide the suggested answer first.
Explain the idea in your own words, then compare your reasoning with the model answer.
1. What exactly does this concept solve?   
- Suggested answer: POSA patterns capture recurring architectural forces and structures, including concurrency and distributed-system concerns.
They typically describe collaboration at a larger scale than the object-level patterns in the GoF catalog.
2. **What decision do you make in the example below and why?**   
- Suggested answer: Compare a Broker design with a direct alternative, then state which change pressure it addresses and where control and failures flow.
3. **When is it inappropriate or expensive to choose?**   
- Suggested answer: architectural catalogs are influenced by technology and problem type.
The name of a pattern does not guarantee compatibility.
4. **Which common error do you check before merging the code?**   
- Suggested answer: Do not introduce the POSA model as a framework or fixed organizational version.
## In-depth lesson for this topic
### 5. POSA and architectural patterns

POSA stands for Pattern-Oriented Software Architecture.
Broadly speaking, GoF patterns focus on object and class collaborations, while POSA patterns can describe subsystem structure, concurrency, network communication, and runtime flow.
When studying an architectural pattern, ask:
- What type of component and connector does it have?
- How does control and data flow?
- Which quality attribute does it support, such as concurrency, fault isolation, or variability?
- What is the assumption about process, network, failure and deployment?
- What operational cost does it create and is there a simpler option?
POSA is a collection of pattern volumes rather than one fixed catalog with a universal taxonomy.
Compare each pattern with the system's actual constraints.
See the [design-patterns chapter lesson](../../lessons.md) and the [chapter reference library](../../../../references.md#chapter-05).
## Worked architecture sketch: Broker

In a Broker architecture, a client sends through an intermediary; the broker locates a service and routes the message.
The client need not know the server location, but discovery, serialization, timeouts, and broker failures are real costs.
This is one simplified form; brokers differ.

**Common pitfall:** Do not design a central broker without capacity, availability, and retry policies.

**Exercise with answer:** If a server does not respond, the broker should report a timeout or apply bounded retries; unlimited retries silently grow queues and latency.
This diagram is illustrative; production systems need explicit contracts, trust boundaries, and failure semantics.

~~~text
[Client] -- request --> [Broker]
                           |
                  service discovery / route
                           v
                   [Server instance]
                           |
[Client] <-- response -- [Broker]
~~~


## Resources
### Persian

- [Persian Design Patterns](https://alireza-haeri.github.io/Persian-Design-Patterns/) — Persian summaries of GoF patterns and several architectural patterns.
- [Intelligent software engineering laboratory; Principles and Patterns](https://www.m-zakeri.ir/lab/courses/software_engineering_patterns/) — Persian textbook resource for GoF, GRASP and architectural patterns.
### English

- [Refactoring.Guru; Design Patterns](https://refactoring.guru/design-patterns) — List of GoF patterns and multilingual examples.
- [Patterns.Guru; GoF catalog](https://patterns.guru/) — A catalog and discussion of pattern intent and selection costs.
- [Wiley; POSA Volume 3 excerpt](https://catalogimages.wiley.com/images/db/pdf/9780470845257.excerpt.pdf) — An example of architecture and concurrency patterns in the POSA suite.
## Summary

Apply POSA patterns to solve a specific problem, document the trade-offs, and check with visible tests or relevant operational measures whether the design has improved the intended quality.
## Further reading

[Curated references for this chapter](../../../../references.md#chapter-05)

</div>
