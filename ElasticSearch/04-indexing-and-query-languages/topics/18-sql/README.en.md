# Elasticsearch SQL

> Chapter 04: Indexing and Query Languages · Lesson 18

[Read the Persian version](README.md)

## Learning goals

- Use SQL-like syntax to inspect Elasticsearch data.
- Understand that SQL syntax runs on Elasticsearch's distributed index model.
- Check supported functions, type behavior, and driver requirements before integrating.

## Familiar syntax over a search engine

Elasticsearch SQL provides a SQL-like interface for querying and analyzing some Elasticsearch data. It can be useful for users familiar with `SELECT`, `WHERE`, `GROUP BY`, and `ORDER BY`, and can work with supported JDBC or ODBC drivers. The SQL interface does not change the underlying mapping, shards, refresh behavior, or consistency model. It is not a general relational database with every SQL feature, transaction, and join behavior.

~~~text
SELECT brand, AVG(price) AS average_price
FROM products-v1
WHERE available = true
GROUP BY brand
ORDER BY average_price DESC
~~~

Before moving an existing report, check whether its functions, null behavior, type casts, joins, and result volume are supported for the Elasticsearch SQL version. Compare results with Query DSL aggregations. For applications where full control over ranking, filters, and search features matters, Query DSL or a supported client may be a better fit.

## Exercise

Run a grouped sales query using Elasticsearch SQL and reproduce it with a terms aggregation and average metric. Compare result ordering, null handling, and how each request is embedded in your application.

## Quiz with answers

1. **What does Elasticsearch SQL provide?** A SQL-like query interface for supported Elasticsearch operations.
2. **Does it make Elasticsearch relational?** No. The underlying index, mapping, shard, and refresh model remains.
3. **What should be checked before migrating a report?** Supported syntax, functions, types, null behavior, driver compatibility, and result equivalence.
4. **When might Query DSL be preferable?** When the application needs detailed control over relevance scoring, search clauses, and native search features.

## References and further reading

- [Elasticsearch SQL](https://www.elastic.co/docs/reference/query-languages/sql) — overview and syntax.
- [SQL REST API](https://www.elastic.co/docs/reference/query-languages/sql/sql-rest) — submit SQL statements.
- [SQL supported commands](https://www.elastic.co/docs/reference/query-languages/sql/sql-commands) — capabilities and syntax.
- [JDBC driver](https://www.elastic.co/docs/reference/elasticsearch/clients/java/jdbc) — connect compatible tools.
- [Query DSL aggregations](https://www.elastic.co/docs/reference/aggregations) — compare native aggregation requests.
- Persian discovery search (not a verified article): [Persian Elasticsearch SQL tutorials](https://www.google.com/search?q=Elasticsearch+SQL+%D8%A2%D9%85%D9%88%D8%B2%D8%B4+%D9%81%D8%A7%D8%B1%D8%B3%DB%8C).


## Curated bilingual reading map

- [Persian sources, courses, and examples](../../../references/README.md) · [English technical documentation and case studies](../../../references/README.en.md)

Google search links above are discovery shortcuts; they are not verified article citations.

