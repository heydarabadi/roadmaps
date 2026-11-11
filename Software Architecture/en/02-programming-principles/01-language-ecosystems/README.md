# Choosing Programming Languages and Ecosystems

## Learning goals

Compare Java, Kotlin, Scala, Python, Ruby, Go, JavaScript/TypeScript, and .NET using team capability and system needs rather than popularity or one benchmark.

## Core idea

A language is a tool for building and operating software. The architect’s question is not “Which language is best?” but “How can this capability be delivered with this team, at the required quality and an acceptable cost?” Consider delivery speed, runtime performance, libraries, concurrency, memory safety, testing and observability tools, hiring, release cadence, and compatibility with existing systems.

| Ecosystem | Common strengths | Costs to evaluate |
| --- | --- | --- |
| Java and Kotlin | Mature ecosystem, enterprise tooling, stable runtime | Memory use, configuration complexity, version compatibility |
| Scala | Functional models and JVM data processing | Learning curve and specialist availability |
| Python and Ruby | Fast feedback, web and data tools | Performance and dependency management at heavy load |
| Go | Network services, straightforward builds, concurrency tools | Different type and abstraction model from some ecosystems |
| JavaScript and TypeScript | Broad web ecosystem for UI and services | Many dependencies and fast-moving tooling |
| .NET | Mature engineering tools and enterprise platform | Deployment and ecosystem choices need specific knowledge |

These are tendencies, not laws. Version, framework, runtime, application design, and team experience affect the result. A representative workload on production-like deployment is more useful than an isolated microbenchmark.

## A step-by-step language decision

Start from the product workload, not a list of languages. A request-driven API, analytical batch job, browser interface, and embedded library have different needs. For each workload, collect:

1. **Load pattern:** CPU-bound, I/O-bound, batch, stream, latency-sensitive, or throughput-heavy?
2. **Runtime environment:** container, serverless, browser, mobile, on-premises, or an existing runtime?
3. **External contracts:** banking SDK, scientific library, legacy .NET/Java, or multi-language interoperability?
4. **Language properties:** type system, concurrency, memory model, error handling, reflection, serialization.
5. **Lifecycle:** build tooling, dependency scanning, debugging, profiling, upgrades, support, and hiring.

Rank criteria and build a small prototype against the real bottleneck. Changing languages rarely fixes database latency. If startup time, memory use, or serialization is the bottleneck, measure those directly. At different load levels, compare tail percentiles and cost per request, not only averages.

## One language or polyglot?

A dominant stack simplifies training, builds, observability, and on-call support. Polyglot has value when a clear workload or capability benefits. Each additional language needs an owner, base image, shared SDKs, patch cadence, and on-call skill. Using several languages for apparent team independence can hide dependencies if contracts and support are unclear.

## Worked decision: catalog search

**Context:** A five-person team must deliver catalog search in six weeks. Most requests are I/O-bound, and the team already knows TypeScript.

- **Node.js/TypeScript:** existing skills and shared web ecosystem; monitor connection pooling and CPU-heavy work.
- **Go:** strong server tooling and concurrency; training and operating a new language add cost.
- **Python:** fast development and data libraries; evaluate execution separately if CPU-heavy processing emerges.

An initial TypeScript choice reduces delivery and integration risk. Define latency and CPU guardrails; revisit the specific service if measured CPU or memory becomes the bottleneck.

## Worked polyglot example

A team building an inventory API evaluates Go because the team can support it and deployment is simple. A separate data team already uses Spark/JVM for reporting. This polyglot design is sound only if each language has a clear boundary, owner, support plan, event contract, and pipeline. A new language for one small service is hidden cost if on-call staff cannot support it.

## Decision checklist

- What computation pattern and latency target apply?
- Which library, protocol, and SDK meet the product requirement?
- What skills does the team have, and how long would training take?
- How will dependencies, vulnerabilities, and versions be managed?
- How mature are build, test, rollout, and observability practices?
- Does the language choice require a formal organizational standard?

~~~text
Context: daily batch processing, not a real-time request path
Options: Python / JVM / Go
Decision: Python, because the analytics team already has libraries and skills
Risk: processing may slow as volume grows
Guardrail: measure time and cost on representative data; revisit when an SLO is missed
~~~

## Common pitfalls

- Choosing polyglot for personal preference without real boundaries.
- Rejecting a language from a benchmark that does not represent the workload.
- Optimizing coding speed while ignoring upgrades and long-term ownership.
- Requiring one language for every problem merely because it is an organizational standard.

## Self-check quiz

1. **Why is team skill part of architecture quality?** It directly affects delivery time, errors, on-call response, review quality, and maintenance cost.
2. **Is one language always best for all services?** A shared stack can reduce organizational complexity, but a justified exception may benefit a distinct workload or ecosystem.
3. **How do you compare two languages’ latency fairly?** Run the same workload, data, hardware, and configuration; compare tail latency and throughput.
4. **What is a major polyglot risk?** Additional toolchains, operational skills, inconsistent libraries, and harder movement between services.

## Exercise and sample answer

Choose a language and deployment boundary for an order API whose team knows TypeScript and a reporting job whose organization already uses Python/Spark. Include workload, latency, security, on-call skills, dependencies, and a review measure.

**Sample answer:** The two workloads do not require one language. TypeScript may fit the order API; Python/Spark may fit analytics. Give each a build and monitoring owner, event contract, serialization policy, dependency security process, and on-call plan. If the reporting job is tiny and disposable, maintaining a second stack may cost more than it saves. Decide using a representative benchmark and the team’s ability to support both.

## Further reading

- Persian: [Software architecture roadmap](https://codingcogs.org/road-maps/software-architecture), [Software architecture fundamentals](https://www.alirostami.com/software-architecture/)
- English: [Software Architect roadmap](https://roadmap.sh/software-architect), [Thoughtworks Technology Radar](https://www.thoughtworks.com/radar), [Java documentation](https://docs.oracle.com/en/java/), [Go documentation](https://go.dev/doc/), [Python documentation](https://docs.python.org/3/), [TypeScript handbook](https://www.typescriptlang.org/docs/), [.NET documentation](https://learn.microsoft.com/en-us/dotnet/), [JVM performance documentation](https://docs.oracle.com/en/java/javase/21/vm/)

