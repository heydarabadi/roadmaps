<div dir="ltr" align="left">

# Redis JSON: Nested Documents and Path-Based Updates

> Path: Chapter 10 · Modern data types · Level: intermediate · Lesson and lab: 70–110 minutes
>
> Redis Open Source 8 includes JSON as an integrated data type. Earlier installations may require RedisJSON or Redis Stack. Verify the commands on the target endpoint.

> Persian edition: [Redis JSON: سند تو‌در‌تو و کار با path](README.md)

## Learning objectives

- Explain how a Redis JSON value differs from a string containing JSON text and from a hash.
- Create and read a nested document with JSON commands.
- Read and update a selected path without rewriting the whole document in the client.
- Plan schema validation, versioning, memory, indexes, privacy, and concurrent updates.
- Diagnose common command, key-type, path, and compatibility errors.

## Mental model: three ways to represent a record

A Redis JSON key stores a hierarchical value: objects, arrays, strings, numbers, booleans, or null. JSON commands can inspect and update parts of the document using a path.

| Representation | Strength | Trade-off |
| --- | --- | --- |
| String containing JSON text | Simple, portable, every client can parse it | The client commonly reads and rewrites the entire value; partial updates need coordination |
| Hash | Convenient flat field/value record | Does not naturally model nested objects and arrays |
| Redis JSON | Path-based operations on nested documents | Adds its own commands, memory and query/index considerations, and version dependency |

The bytes of a string that happen to look like JSON do not turn it into Redis’s JSON data type. Use TYPE and command availability to inspect the actual key and server.

## 1. Create and read a document

Run against Redis with JSON support:

~~~text
DEL lab:product:42
JSON.SET lab:product:42 $ '{"name":"keyboard","price":25,"tags":["office","usb"],"inventory":{"stock":8}}'
JSON.GET lab:product:42
JSON.GET lab:product:42 $.name
~~~

The dollar sign selects the document root in JSONPath. The root form returns the document. A JSONPath query can return a list of matches; even one match may be wrapped in an array. This can surprise a client that expects a scalar. Legacy path syntax and JSONPath behavior differ across command generations, so use the current path guide for the server version you operate.

## 2. Read and mutate selected paths

~~~text
JSON.GET lab:product:42 $.inventory.stock
JSON.NUMINCRBY lab:product:42 $.inventory.stock 2
JSON.SET lab:product:42 $.price 29
JSON.GET lab:product:42 $.price
JSON.DEL lab:product:42 $.tags[0]
~~~

- JSON.NUMINCRBY changes numeric nodes at the selected path.
- JSON.SET key path value replaces or creates a node where the path rules permit it.
- JSON.DEL removes the selected node. Deleting the root deletes the document.
- JSON.TYPE reports node types. JSON.ARRLEN, JSON.ARRAPPEND, JSON.ARRINSERT, JSON.ARRTRIM, and JSON.ARRPOP operate on arrays.
- A JSON string value must be valid JSON. For example, the string “hardware” is encoded as the JSON literal "hardware", including its quotes.

One server-side JSON command is one command. A client sequence of JSON.GET followed by JSON.SET is not automatically an atomic read-modify-write transaction. If the update depends on a prior value, consider WATCH/MULTI/EXEC, Lua, Redis Functions, or an atomic command that matches the rule.

## 3. Schema and application correctness

Redis JSON is a storage type, not a complete application schema-validation system. The application should validate required fields, types, ranges, ownership, and payload size before writing.

For evolving documents:

1. Record a schema version, either in the document or the key namespace.
2. Make readers tolerant of fields they do not use.
3. Define how old documents are upgraded: lazy migration, background rewrite, dual read, or full backfill.
4. Test mixed-version readers and writers during rollout.
5. Make retries safe. A blind JSON.SET can overwrite a newer document with an older payload.

Redis 8 integrates JSON and search capabilities that were previously supplied through Redis Stack modules. An older server may need the module separately. Search and secondary indexes are a separate design decision: index memory, update cost, query syntax, authorization filters, and version support all matter.

## 4. Capacity and choosing a representation

Choose JSON when records are genuinely nested and the application benefits from path-level access. A small flat session may be simpler as a hash. If every operation reads and overwrites the entire document, a JSON type may add complexity without a useful benefit.

Measure realistic documents. Large, frequently mutated documents can increase serialization and update costs. Include index overhead, replicas, persistence, allocator fragmentation, and the number of copies in memory estimates. Apply key-pattern ACL rules and keep sensitive data out of documents or indexed fields unless the access and retention policies permit it.

Key TTL applies to the key as a whole. Do not assume a nested field has its own expiry. If individual values need independent lifecycle or contention control, model them as separate keys or verify an explicitly supported feature.

## Example: product catalog

1. Store a cacheable document under a key such as lab:product:42.
2. Keep fast-changing inventory separate if inventory updates need stronger concurrency control than the larger product document.
3. Use JSON.NUMINCRBY for a simple numeric change; do not use client-side read-then-set without concurrency protection.
4. Add a schema version and plan how old consumers read the new shape.
5. If queries such as “all products under this price” are required, test an index and query engine with realistic cardinality and update traffic.
6. Treat cache deletion as separate from deletion of backups and other retained copies.

## Published customer example

Redis’s Docugami customer story discusses using Redis in AI and search-related data flows, including document and vector use. It illustrates one product deployment, not a rule that every document workload belongs in Redis. The article is published by Redis and should be treated as a customer story rather than independent comparative research. [Docugami customer story](https://redis.io/customers/docugami/)

## Lab and troubleshooting

~~~text
JSON.SET lab:customer:42 $ '{"id":42,"profile":{"city":"Tehran"},"tags":[]}'
JSON.GET lab:customer:42 $.profile.city
JSON.ARRAPPEND lab:customer:42 $.tags '"learner"'
JSON.GET lab:customer:42
~~~

| Symptom | Likely cause | Check |
| --- | --- | --- |
| Unknown JSON command | The installed server, module, or service does not expose JSON | Check version, product, module list, and command info |
| WRONGTYPE | The key already contains a string, hash, or another type | Check TYPE and the key naming model |
| Path not found or empty response | Path syntax, root selector, array index, or absent value | Check the path dialect and inspect the document |
| Result has unexpected array wrapper | JSONPath can return multiple matches | Adjust client decoding and use the intended path syntax |
| Memory increased unexpectedly | Large documents, arrays, indexes, replicas, or duplicate copies | Measure document sizes and memory usage; inspect index and replica count |

## Exercises

1. Create a product document and read only its price and stock.
2. Increase stock with JSON.NUMINCRBY. Explain why two clients that both read first and later write with JSON.SET can lose one another’s update.
3. Design a schema version 2 while an older application version is still running.
4. Choose JSON or a hash for a ten-field flat session record and explain the operational trade-off.

**Answer guide:** The numeric command executes as one server operation. Two client-side read/modify/write sequences can race and overwrite. Versioned schemas need compatible readers and a migration plan. A flat, small record often fits a hash; nested arrays or objects can justify JSON.

## Quiz

### 1. Is a Redis string containing JSON the same type as Redis JSON?

<details><summary>Answer</summary>

No. A string is an opaque string value. Redis JSON has its own type and path-oriented commands.

</details>

### 2. Why can a JSONPath response be wrapped in an array?

<details><summary>Answer</summary>

JSONPath can select one or more matches and returns a match collection; a single match can still be represented as a collection.

</details>

### 3. Does Redis JSON automatically enforce an application schema?

<details><summary>Answer</summary>

No. Validate and version documents in the application, and migrate old shapes deliberately.

</details>

### 4. What changed for JSON in Redis Open Source 8?

<details><summary>Answer</summary>

JSON became an integrated capability in Redis Open Source 8; older installations may need RedisJSON or Redis Stack.

</details>

### 5. Does a JSON field get an independent key TTL?

<details><summary>Answer</summary>

The normal expiry applies to the key. Model a separately expiring value separately unless the target product explicitly supports the required behavior.

</details>

### 6. Is JSON.SET always a safe retry?

<details><summary>Answer</summary>

Not if a stale full-document payload can overwrite a newer state. Make the operation idempotent and protect conditional updates.

</details>

## References and further reading

### English: official and engineering sources

- [Redis JSON guide](https://redis.io/docs/latest/develop/data-types/json/) — data type and commands.
- [JSON paths](https://redis.io/docs/latest/develop/data-types/json/path/) — root selectors and path behavior.
- [JSON.SET command reference](https://redis.io/docs/latest/commands/json.set/) — argument details and examples.
- [JSON.GET command reference](https://redis.io/docs/latest/commands/json.get/) — response formats.
- [Redis data type comparison](https://redis.io/docs/latest/develop/data-types/compare-data-types/) — choose JSON, hashes, strings, and other types.
- [Redis Open Source 8.0 release notes](https://redis.io/docs/latest/operate/oss_and_stack/stack-with-enterprise/release-notes/redisce/redisos-8.0-release-notes/) — integrated feature and version context.
- [Redis transactions](https://redis.io/docs/latest/develop/interact/transactions/) — multi-command coordination.
- [Redis JSON customer story: Docugami](https://redis.io/customers/docugami/) — vendor-published use case.

### فارسی

- [آموزش فارسی Redis در SalamLang](https://www.salamlang.ir/std/db/redis/) — مبانی Redis؛ پوشش عمیق Redis JSON محدود است.
- [مرور فارسی ساختارهای Redis در DNTips](https://www.dntips.ir/exports/posts/www.dntips.ir-posts-3088.pdf)
- [جست‌وجوی فارسی Redis JSON و JSON.SET](https://www.google.com/search?q=آموزش+فارسی+Redis+JSON+JSON.SET)
- [جست‌وجوی فارسی JSONPath](https://www.google.com/search?q=آموزش+فارسی+JSONPath+path+JSON)

منابع تخصصی فارسی Redis JSON کم‌اند؛ مدل، تمرین و خطاهای متداول در این درس توضیح داده شده‌اند. برای syntax و نسخه از مستند رسمی همان endpoint استفاده کن.

</div>

