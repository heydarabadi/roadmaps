# Software Architecture: Study Guide

## Scope

This course follows the visible topics in the [Software Architect roadmap](https://roadmap.sh/software-architect) and its [official PDF](https://roadmap.sh/pdfs/roadmaps/software-architect.pdf). It also points to complementary System Design and Software Design & Architecture material where topics overlap.

The lessons are original instructional explanations, not line-by-line translations of books or articles. Each topic connects concepts to a recurring online-store scenario and includes self-check questions, a practice exercise, a sample-answer guide, and curated English and Persian reading.

## Suggested sequence

1. Architecture work, stakeholders, requirements, and quality attributes.
2. Language ecosystems, programming paradigms, and design principles.
3. Patterns, domain modeling, consistency, and testing.
4. Architecture styles and their trade-offs.
5. Security, data, APIs, and integration.
6. Web, mobile, and networking.
7. Cloud operations, reliability, and delivery.
8. Modeling, organizational methods, collaboration tools, enterprise platforms, and the capstone.

## Ways to use the course

### New to architecture

Start with Chapters 1 and 2. Learn the vocabulary before comparing patterns. For each lesson, write down what problem a concept solves and one situation where it would be a poor fit.

### Developer preparing for architecture work

Work through Chapters 1–4 and write a short ADR for each significant choice. Then apply security, data, API, and operational lessons to a system you know. Complete the capstone without copying the reference answer first.

### Experienced architect

Use the security, data, operations, modeling, and enterprise chapters to find gaps. Treat answers as examples of reasoning; verify current provider-specific behavior in official documentation.

## Continuing example

An online store appears throughout the course: product catalog, cart, checkout, payment provider, inventory, fulfillment, reporting, and operations. The same system makes trade-offs visible as it moves from a single process to networked integration and production operations. Example numbers are illustrative and must be replaced with real product requirements.

## Chapter completion criteria

- Explain the concept in your own words and give a counterexample.
- Compare at least two options using the same decision criteria.
- Describe one failure mode and how to observe or recover from it.
- Record a decision with its context, rationale, consequences, and review trigger.
- Complete the exercise and explain why the answer fits the stated context.

## Chapters

- [1. The Architect’s Role and Foundations](01-foundations-role/README.md)
- [2. Programming Languages and Design Principles](02-programming-principles/README.md)
- [3. Patterns and Domain Design](03-design-patterns/README.md)
- [4. Architecture Styles and Structures](04-architecture-styles/README.md)
- [5. Security Architecture](05-security/README.md)
- [6. Data Architecture and Analytics](06-data/README.md)
- [7. APIs and Integration](07-apis-integrations/README.md)
- [8. Web and Mobile](08-web-mobile/README.md)
- [9. Networks and Communication](09-networks/README.md)
- [10. Cloud and Operations](10-cloud-operations/README.md)
- [11. Frameworks and Modeling](11-frameworks-modeling/README.md)
- [12. Management and Agility](12-management-agile/README.md)
- [13. Tools and Collaboration](13-tools-collaboration/README.md)
- [14. Enterprise Platforms](14-enterprise-platforms/README.md)
- [15. Capstone and Final Assessment](15-capstone-assessment/README.md)
- [Glossary](glossary.md)
- [Curated references](sources.md)

## How to study a lesson

1. Read the goals and explanation before looking at the quiz answers.
2. Apply the example to a system you know.
3. Refill the decision table with your own constraints.
4. Complete the exercise, then compare your reasoning with the sample answer.
5. Turn the result into a short ADR, diagram, or testable scenario.

Architecture rarely has one universally correct answer. The important skill is to make assumptions explicit, compare consequences, and revisit a choice when evidence changes.

