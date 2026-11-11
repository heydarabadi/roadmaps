# MongoDB Self-Study Course Guide

> **Persian edition:** [Read the Persian version](../../fa/mongodb/course-overview.md).

## Who is this course for?

It is for learners with basic programming experience who want to progress from MongoDB fundamentals to production-oriented design and operations. The explanations needed for the core curriculum are included in the lessons. External links are references for further study and for checking version- or product-specific details.

## Prerequisites

- Basic familiarity with variables, objects, arrays, and functions in one programming language.
- Basic JSON and HTTP knowledge is helpful; Chapter 1 reviews what is needed.
- To run the exercises, use `mongosh` with a local MongoDB Server or a disposable development deployment.

## Learning sequence

1. Chapter 1: document model, BSON, Atlas, and tools.
2. Chapter 2: CRUD, filters, updates, cursors, and concerns.
3. Chapter 3: schema design, embedding, and references.
4. Chapter 4: indexes, explain plans, aggregation, and search.
5. Chapter 5: transactions, replica sets, backups, sharding, and capacity.
6. Chapter 6: authentication, authorization, encryption, and auditing.
7. Chapter 7: drivers, connectors, Change Streams, and operations tools.
8. Complete the capstone using written access patterns and measurable goals.

## How to study each lesson

- Read the learning goal and prerequisites first.
- Run the example in a learning database and explain every line in your own words.
- Predict the output before comparing it with the example. ObjectIds and exact timestamps will differ.
- Solve the exercise before reading the answer key.
- If an answer is wrong, identify whether the issue is the data model, BSON type, filter, or version behavior; do not memorize a command without its reason.

## Practice environment

A local development server is suitable for the basic exercises. Atlas can also be used as a disposable learning environment. Use a separate user, protect secrets, and restrict network access. Keep practice data in the `learning` database. Never run broad deletion or replacement examples against production.

## Mastery criteria

For every topic, be able to define it, write a new example, explain its trade-offs, spot a common failure, and identify what should be measured or monitored in production.

## Version and scope

Commands are written for general instruction. Atlas, Enterprise, server, and driver capabilities may depend on product edition or version. The lessons teach the principles, but before applying production configuration or security settings, check the current official manual for the exact environment.

## Three passes through a lesson

1. **Understand:** explain the concept without looking at the code.
2. **Run:** execute the example and predict each result.
3. **Decide:** explain when you would not use the feature and what trade-off it creates.

Keep `mongosh` syntax separate from language-driver APIs. A feature can behave differently across a shell, driver, server version, and Atlas deployment.

## Quiz map

Each lesson has ten answerable prompts: a core set, an applied scenario, and follow-up questions about decisions and troubleshooting. Give a reason with every answer, not only an operator name.
