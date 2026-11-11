# Event Query Language (EQL)

> Chapter 04: Indexing and Query Languages · Lesson 17

[Read the Persian version](README.md)

## Learning goals

- Identify event-sequence questions that EQL is designed to express.
- Define sequence keys, time bounds, and event categories.
- Explain how incorrect mappings or timestamps cause missed sequence matches.

## Search for ordered events

EQL is designed for event data and sequence detection. A rule can express that one event type happens and is followed by another within a time window, optionally grouped by host, user, or another key. This is useful for security detection and behavioral investigation where order is meaningful.

~~~text
sequence by host.id with maxspan=5m
  [process where process.name == "powershell.exe"]
  [network where destination.port == 443]
~~~

This example looks for a process event followed by a network event on the same host within five minutes. The actual data must provide compatible event categories, a timestamp field, and fields with appropriate mappings. Late-arriving events, incorrect timestamps, missing sequence keys, and wrong keyword/text behavior can all change matches. EQL is not a replacement for general full-text relevance search or ordinary aggregations.

## Exercise

Create two synthetic events for the same host: process start and outbound connection. Change their order, host ID, and timestamp distance. Determine which cases match a sequence with a five-minute maximum span and explain why.

## Quiz with answers

1. **What is EQL suited for?** Finding patterns and ordered sequences across event data, often for security detection.
2. **What does `maxspan` constrain?** The maximum interval in which a sequence must occur.
3. **Why is a sequence key useful?** It groups related events, for example by host or user.
4. **Name three causes of false negatives.** Bad timestamp parsing, missing or inconsistent keys, and category or field mappings that do not match the EQL conditions.

## References and further reading

- [EQL reference](https://www.elastic.co/docs/reference/query-languages/eql) — syntax and concepts.
- [EQL search API](https://www.elastic.co/docs/reference/query-languages/eql/eql-search) — request usage.
- [EQL sequences](https://www.elastic.co/docs/reference/query-languages/eql/eql-syntax#eql-sequences) — ordered event matching.
- [EQL examples](https://www.elastic.co/docs/reference/query-languages/eql/eql-examples) — event pattern examples.
- [Elastic Security detection rules](https://www.elastic.co/docs/solutions/security/detect-and-alert) — production security detection context.
- Persian discovery search (not a verified article): [Persian articles about Elasticsearch EQL](https://www.google.com/search?q=Elasticsearch+EQL+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

