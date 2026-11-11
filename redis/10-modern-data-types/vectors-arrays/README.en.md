<div dir="ltr" align="left">

# Redis Vector Sets and Arrays

> Path: Chapter 10 · Modern data structures · Level: intermediate to advanced · Time: 120–180 minutes
>
> These are separate subjects: vector similarity search over embeddings and index-addressable arrays. A Vector Set is not an Array, and an Array is not a vector-search index.

> Persian edition: [Vector Sets و Arrays در Redis](README.md)

## Prerequisites and objectives

Review hashes, JSON, sorted sets, memory, Redis versions, and client libraries. After this lesson, you should be able to:

- Explain embeddings, dimensions, similarity, top-k, and recall.
- Add vectors and attributes to a Vector Set and retrieve similar elements.
- Evaluate approximate search, model quality, metadata, filters, and memory for production.
- Choose between Vector Sets and the Redis Query Engine.
- Use Redis Arrays for indexed access, sparse ranges, and bounded ring buffers.
- Choose Array over List or a JSON array only when the access pattern supports it.

## Part A — Vector Sets and semantic similarity

### 1. From a document to an embedding

An embedding is a numeric representation produced by a machine-learning model for text, an image, or another input. The model may map related phrases such as “walking shoes” and “shoes for long walks” to vectors that are near one another in a mathematical space.

Redis does not create the embedding. An application or model service generates it, then stores it. For a search, the application generates a query embedding with a compatible model and preprocessing pipeline, then asks Redis to find nearby elements.

Geometric proximity is not guaranteed semantic truth. Results depend on model quality, language, domain, text chunking, normalization, and the chosen metric. A weak or mismatched model can return poor results even when Redis stores and ranks vectors correctly.

### 2. Core terms

- **Dimension:** number of numeric components. Vectors in one set need a compatible dimension; version the model and dimension together.
- **Metric:** definition of distance or similarity, such as cosine, Euclidean/L2, or inner product in a vector system. It must suit the embedding model and normalization.
- **k / top-k:** how many results to request.
- **Exact nearest neighbor:** compare every vector; exact but increasingly expensive at larger scale.
- **Approximate nearest neighbor (ANN):** use an index such as HNSW to find likely close candidates faster, while possibly missing the true nearest item.
- **Recall@k:** fraction of the actual k nearest results that the search returns. If it finds 9 of the true top 10, recall@10 is 0.9.
- **Latency:** measure p50, p95, and p99 under realistic concurrency, not only an isolated query.
- **Metadata/filter:** fields such as language, tenant, category, or price that constrain results.

Search parameters affect quality and cost. In HNSW-style search, exploring more candidates can raise recall while using more CPU and latency. Graph size, quantization, vector precision, memory, and version all matter. Benchmark against judged queries from your own domain; a vendor benchmark is not your service-level objective.

### 3. Add vectors and search with VSIM

Redis Open Source 8 includes Vector Sets. The following three-dimensional values are toy numbers to teach syntax; they are not real language embeddings.

~~~text
DEL lab:products:vec
VADD lab:products:vec VALUES 3 0.9 0.1 0.0 product:running-shoe
VADD lab:products:vec VALUES 3 0.8 0.2 0.1 product:trail-shoe
VADD lab:products:vec VALUES 3 0.0 0.1 0.9 product:coffee-mug
VCARD lab:products:vec
VDIM lab:products:vec
TYPE lab:products:vec
VSIM lab:products:vec VALUES 3 0.85 0.15 0.05 COUNT 2 WITHSCORES
~~~

The example query should rank the two shoe elements ahead of the mug. VSIM WITHSCORES gives ranking/similarity scores; it does not mean “this result has a 95% probability of being relevant.” Calibrate relevance separately with human judgments and labeled test data.

Search near a stored element:

~~~text
VSIM lab:products:vec ELE product:running-shoe COUNT 2 WITHSCORES
~~~

Adding an existing element can update its vector. If a document changes or the embedding model changes, update text, metadata, and vector coherently. Stale vectors can produce plausible-looking but incorrect results.

### 4. Attach attributes and filter

~~~text
VSETATTR lab:products:vec product:running-shoe '{"category":"shoes","price":90,"lang":"fa"}'
VSETATTR lab:products:vec product:trail-shoe '{"category":"shoes","price":120,"lang":"fa"}'
VSETATTR lab:products:vec product:coffee-mug '{"category":"home","price":15,"lang":"en"}'
VGETATTR lab:products:vec product:running-shoe
VSIM lab:products:vec VALUES 3 0.85 0.15 0.05 FILTER '.category == "shoes" && .price < 100' COUNT 5 WITHATTRIBS
~~~

Attributes can carry fields used to narrow results. For security-sensitive tenant isolation, do not rely on a user-supplied filter as the only authorization control. Derive tenant identity from the authenticated request, constrain the query, and validate returned records in the application.

Useful commands include VCARD (element count), VDIM (dimension), VEMB (retrieve an element’s vector), VINFO, VSETATTR, VGETATTR, and VREM. Confirm command availability and options on your server version; the feature set evolves.

### 5. Vector Set or Query Engine?

Vector Sets are a native data type with VADD and VSIM. They can suit simpler similarity search and a compact data model. The Redis Query Engine indexes Hash or JSON documents and supports richer query combinations with commands such as FT.CREATE and FT.SEARCH; hybrid search options depend on the version and product.

| Need | Vector Sets | Query Engine on Hash/JSON |
| --- | --- | --- |
| Storage model | Vector Set elements and attributes | Hash/JSON records with an index |
| Search | VSIM | FT.SEARCH and version-dependent hybrid/vector query |
| Filter/query richness | Simpler attribute expressions | Full-text, tags, numeric/geospatial filters, aggregation, and vector search, depending on version |
| Strong candidate | Straightforward similarity workflow | Combined lexical + semantic retrieval and structured filters |
| Main planning cost | Vector storage, attributes, and search quality | Index memory, schema, query planning, and update cost |

Do not confuse vector storage with an embedding service. The system still needs model selection, ingestion, re-embedding, versioning, access control, deletion, evaluation, and result presentation.

### 6. Build an evaluation set

Before tuning an index, create a representative set of real queries. Have people judge relevant documents, including hard negatives, multiple languages, spelling variants, and short/long queries. Measure recall@k or nDCG, p95/p99 latency, throughput, cost, and filter correctness. Run the same set for each model and index configuration.

For production, version:

- embedding model and dimension;
- text normalization, chunking, and document ID;
- index/search parameters;
- metadata schema and tenant boundaries;
- evaluation data and accepted quality thresholds.

When the model changes, plan a backfill and cutover. Do not mix incompatible vector dimensions in one collection.

## Part B — Redis Arrays

### 7. What an Array is for

Redis Arrays, introduced in Redis 8.8, store strings addressed by integer index. They support sparse positions, range operations, scanning, and ring-buffer behavior. Unlike a List, an Array makes random access by an index a primary operation. A sparse array can have a large logical length while only a few positions contain values.

~~~text
DEL lab:arr
ARSET lab:arr 0 first
ARSET lab:arr 3 fourth
ARGET lab:arr 0
ARGETRANGE lab:arr 0 4
ARLEN lab:arr
ARCOUNT lab:arr
ARSCAN lab:arr 0
~~~

ARLEN reports the logical length (highest occupied index plus one); ARCOUNT reports the number of populated slots. In a sparse array, they can differ greatly. A large ARGETRANGE can return many empty positions, so bound the requested range. ARSCAN visits populated slots and is useful when walking sparse data.

### 8. Ring buffer

A ring buffer reuses fixed capacity. When a full ring receives another element, an older slot is overwritten according to the command’s semantics. This is useful for a bounded recent-history window or a fixed-size sample buffer, not an audit log or a durable work queue.

~~~text
DEL lab:recent
ARRING lab:recent 3 one
ARRING lab:recent 3 two
ARRING lab:recent 3 three
ARRING lab:recent 3 four
ARGETRANGE lab:recent 0 2
ARLASTITEMS lab:recent 2
~~~

Verify the exact ARRING argument order and behavior against the Redis 8.8 command reference before using it. Once the ring is full, old information is intentionally discarded. If every event matters, keep an authoritative Stream or durable event log and use the ring only as a recent view.

### 9. Array, List, or JSON array?

| Access pattern | Likely candidate | Why |
| --- | --- | --- |
| Queue-like push/pop processing | List or Stream, depending on acknowledgement/durability needs | Queue semantics are natural; Streams provide consumer groups |
| Fixed-size recent history | Array ring buffer | Old slots can roll over at a bounded capacity |
| Random access by numeric position | Array | Index is a direct address |
| Nested application document | JSON array | The array belongs inside a structured document |
| Exact audit history | Durable log/database, often with Redis Streams as an operational layer | A bounded ring overwrites history |

Choose from the required operations, delivery guarantees, and retention—not from a general “newer is better” assumption.

## Exercises

1. Define a labeled evaluation set for a Persian and English product-search system. Which metrics and human judgments do you need?
2. A user asks to delete personal information. List the copies that must be considered: source text, vector, metadata/index, replica, backup, and cache.
3. Why can a tenant filter in a public API become an authorization vulnerability? Describe how identity should flow into the query.
4. Choose Vector Sets or Query Engine for semantic similarity plus full-text search and a price range filter.
5. Explain why increasing HNSW exploration can improve recall but worsen p99 latency.
6. A sparse Array has values at index 0 and 1,000,000. Compare ARLEN and ARCOUNT. What makes a huge ARGETRANGE risky?
7. What does a 1,000-slot ring buffer guarantee about older events? What should an audit team use instead?
8. Why might a List be more suitable than an Array for a job queue?

**Answer guide:** 1) Use representative bilingual queries, judged relevance, hard negatives, recall@k/nDCG, latency, and filter correctness. 2) Follow deletion and retention policy across live indexes, replicas, and backup retention. 3) A caller could request another tenant’s data; derive the tenant from authenticated identity, constrain the query, and validate results. 4) Query Engine is often a stronger candidate for hybrid full-text, vector, and numeric filtering; verify version support. 5) More candidate exploration costs work. 6) ARLEN is 1,000,001 while ARCOUNT is 2; the range may return a huge number of empty positions. 7) Only a bounded recent window; use a durable log for audit. 8) Queue work may need push/pop, acknowledgement, retries, and pending-state semantics that Lists or Streams model better.

## Quiz

### 1. Does Redis generate embeddings?

<details><summary>Answer</summary>

No. The application or a model service generates them; Redis stores and searches them.

</details>

### 2. Can vectors with different dimensions be searched together in one Vector Set?

<details><summary>Answer</summary>

No. Keep dimensions compatible and version the embedding model and schema.

</details>

### 3. What does VSIM do?

<details><summary>Answer</summary>

It ranks Vector Set elements by similarity to a supplied vector or stored element.

</details>

### 4. Is a WITHSCORES value a probability of relevance?

<details><summary>Answer</summary>

No. It is a search score, not a calibrated probability unless a separate calibration process establishes that interpretation.

</details>

### 5. How do Vector Sets differ from Query Engine?

<details><summary>Answer</summary>

Vector Sets are a native vector-focused data type. Query Engine indexes Hash/JSON documents for richer combinations of text, metadata, and vector queries.

</details>

### 6. What is a common HNSW tuning trade-off?

<details><summary>Answer</summary>

More search exploration can improve recall but increase CPU use and latency.

</details>

### 7. Which Redis version introduced Arrays?

<details><summary>Answer</summary>

Redis 8.8. Earlier versions may not recognize AR commands.

</details>

### 8. What is the difference between ARLEN and ARCOUNT?

<details><summary>Answer</summary>

ARLEN is logical length through the highest occupied index; ARCOUNT counts populated slots.

</details>

### 9. Is ARRING suitable for an infinite audit history?

<details><summary>Answer</summary>

No. A bounded ring overwrites older entries by design. Keep an authoritative durable log for audit.

</details>

### 10. When is an Array a stronger choice than a List?

<details><summary>Answer</summary>

When direct numeric indexing, sparse ranges, or a bounded ring is central. Lists often suit push/pop queues more naturally.

</details>

## References and further reading

### English: official, research, and engineering sources

- [Redis Vector Sets](https://redis.io/docs/latest/develop/data-types/vector-sets/) — current Vector Set model, examples, attributes, and filters.
- [VADD](https://redis.io/docs/latest/commands/vadd/) and [VSIM](https://redis.io/docs/latest/commands/vsim/) — command syntax.
- [Vector Set performance guide](https://redis.io/docs/latest/develop/data-types/vector-sets/performance/) — performance and configuration guidance; vendor measurements are not universal guarantees.
- [Redis vector indexes](https://redis.io/blog/vector-indexes-in-redis/) — vector index design.
- [Practical guide to vector search](https://redis.io/blog/vector-search-practical-guide/) — practical retrieval design.
- [Redis Arrays](https://redis.io/docs/latest/develop/data-types/arrays/) — basic usage, sparse arrays, length/count, and ring buffers.
- [ARRING](https://redis.io/docs/latest/commands/arring/), [ARSET](https://redis.io/docs/latest/commands/arset/), and [ARGET](https://redis.io/docs/latest/commands/arget/) — command references.
- [What’s new in Redis 8.8](https://redis.io/docs/latest/develop/whats-new/8-8/) and [Redis 8.8 announcement](https://redis.io/blog/announcing-redis-8-8/) — release context for Arrays.
- [HNSW paper](https://arxiv.org/abs/1603.09320) — research on approximate nearest-neighbor graphs.
- [Docugami customer story](https://redis.io/customers/docugami/) — vendor-published search and document use case.

### فارسی

- [جست‌وجوی برداری چیست؟ — مرور فارسی DNTips](https://www.dntips.ir/exports/news/www.dntips.ir-news-20284.pdf) — مفهوم vector search؛ نه راهنمای syntax Redis.
- [تمرین فارسی نمایش برداری متن](https://dsp-lab.ir/wp-content/uploads/2022/11/ML-NLP-HW2-IR-1401-1.pdf) — مبانی بردارسازی متن؛ نه Vector Set.
- [آموزش Redis در SalamLang](https://www.salamlang.ir/std/db/redis/) — مبانی Redis؛ پوشش Vector Sets و Arrays جدید محدود است.
- [جست‌وجوی فارسی Vector Search و embedding](https://www.google.com/search?q=آموزش+فارسی+جستجوی+برداری+Vector+Search+embedding+Redis)
- [جست‌وجوی فارسی Redis Arrays](https://www.google.com/search?q=Redis+Arrays+8.8+آموزش+فارسی)

برای موضوع‌های تازه، آموزش فارسی Redis محدود است؛ این درس مفهوم‌ها، طراحی و خطاهای رایج را آموزش می‌دهد و منابع فارسی مکمل مفاهیم عمومی‌اند. رفتار commandها، version و performance را روی endpoint هدف اعتبارسنجی کن.

</div>

