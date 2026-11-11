# کتابخانهٔ منابع و مقاله‌های Elasticsearch

[English version](../../../en/elasticsearch/references/README.md) · [بازگشت به دوره](../README.md)

این کتابخانه منابع مستقیم و قابل استفاده را در کنار درس‌ها جمع می‌کند. مستندات رسمی انگلیسی مرجع نهایی syntax و رفتار وابسته به نسخه‌اند. مقاله‌ها و دوره‌های فارسی برای یادگیری و توضیح مفاهیم مفیدند، اما تاریخ انتشار و نسخهٔ Elasticsearch آن‌ها را بررسی کن. اعداد مطالعات مشتری، گزارش ناشر همان مطالعه‌اند و نتیجهٔ تضمینی برای سامانهٔ دیگر نیستند.

## راهنمای منابع فارسی

| منبع | موضوع و کاربرد | محدودیت |
|---|---|---|
| [آموزش جست‌وجوی پیشرفته با Elasticsearch در Codity](https://codity.ir/advanced-search-training-with-elasticsearch/) | معرفی Query DSL، `match` و ترکیب `bool` و `filter` با مثال کوتاه | مقالهٔ مقدماتی و ثانویه است؛ JSON و semantics هر API را با مستند رسمی جاری مقایسه کن. |
| [چرا جست‌وجوی فارسی در Elasticsearch درست کار نمی‌کند؟](https://virgool.io/@technotesai/%DA%86%D8%B1%D8%A7-%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C-%D9%81%D8%A7%D8%B1%D8%B3%DB%8C-%D8%AF%D8%B1-elasticsearch-%D8%AF%D8%B1%D8%B3%D8%AA-%DA%A9%D8%A7%D8%B1-%D9%86%D9%85%DB%8C-%DA%A9%D9%86%D8%AF-%D9%88-%DA%86%D8%B7%D9%88%D8%B1-%D8%AF%D8%B1%D8%B3%D8%AA%D8%B4-%DA%A9%D9%86%DB%8C%D9%85-dfsaaev7zebh) | مقالهٔ عملی دربارهٔ normalization، حروف عربی/فارسی، رقم، نیم‌فاصله، synonym و BM25 برای کاتالوگ فارسی | نویسنده ادعای استفادهٔ production دارد، اما پیکربندی مستقل ارزیابی نشده؛ ZWNJ، stopword و BM25 را روی queryهای برچسب‌خورده آزمایش کن. |
| [از MySQL ویرگول به Elasticsearch — قسمت آمار](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B2-%D8%A2%D9%85%D8%A7%D8%B1-bzx5mj16lcqb) | روایت فنی تیم ویرگول دربارهٔ انتقال بخشی از آمار و جست‌وجو به Elasticsearch | حدود ۷ ساله؛ برای فهم تصمیم‌ها بخوان، نه انتخاب نسخه، API یا طراحی امروز. |
| [ادامهٔ تجربهٔ ویرگول دربارهٔ backup](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B3-%D8%A2%D8%AE%D8%B1%D8%A7%DB%8C-%D8%AF%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-y9ioyntxpjue) | ادامهٔ همان تجربه با تمرکز روی backup | قدیمی است؛ مفاهیم را با Snapshot/Restore جاری و تمرین restore تطبیق بده. |
| [باسلام: محاسبهٔ پویا و مقیاس‌پذیر کمیسیون با Percolate](https://virgool.io/%D8%B1%D8%A7%D9%87%DA%A9%D8%A7%D8%B1-%D9%81%D9%86%DB%8C-%D9%85%D9%82%DB%8C%D8%A7%D8%B3-%D9%BE%D8%B0%DB%8C%D8%B1-%D8%A8%D8%B1%D8%A7%DB%8C-%D9%BE%D8%B4%D8%AA%DB%8C%D8%A8%D8%A7%D9%86%DB%8C-%D8%A7%D8%B2-%D9%BE%D9%88%DB%8C%D8%A7%DB%8C%DB%8C-%DA%AF%D8%B3%D8%AA%D8%B1%D8%AF%D9%87-%DB%8C-%D8%B3%DB%8C%D8%B3%D8%AA%D9%85-%DA%A9%D9%85%DB%8C%D8%B3%DB%8C%D9%88%D9%86-%D8%A8%D8%A7%D8%B3%D9%84%D8%A7%D9%85-percolate-%D8%AF%D8%B1-elasticsearch-flsw9db3da3l) | تجربهٔ فارسی استفاده از queryهای ذخیره‌شده برای ارزیابی سفارش | تجربهٔ نویسنده است؛ API و قابلیت‌های امروز را با مستند رسمی Percolator مقایسه کن. |
| [راهنمای Docker برای Elastic Stack در ویرگول](https://virgool.io/%40hadivarposhti/%D8%B1%D8%A7%D9%87%D9%86%D9%85%D8%A7%DB%8C-%D9%86%D8%B5%D8%A8-%D9%88-%D9%BE%DB%8C%D8%A7%D8%AF%D9%87-%D8%B3%D8%A7%D8%B2%DB%8C-%D8%A7%D9%84%D8%B3%D8%AA%DB%8C%DA%A9-%D8%A7%D8%B3%D8%AA%DA%A9-elk-%D8%A8%D8%A7-%DA%A9%D9%85%DA%A9-%D8%AF%D8%A7%DA%A9%D8%B1-qg3gppvfsh3q) | تجربهٔ عملی نصب ELK با Docker | قدیمی‌تر است؛ image، تنظیم امنیت و دستورها را با نسخهٔ جاری تطبیق بده. |
| [اتصال Elasticsearch به Laravel در ویرگول](https://virgool.io/%40vahiiiid/%D8%A8%D9%87%D8%AA%D8%B1%DB%8C%D9%86-%D8%B1%D9%88%D8%B4-%D8%A7%D8%B3%D8%AA%D9%81%D8%A7%D8%AF%D9%87-%D8%A7%D8%B2-%D8%A7%D9%84%D8%B3%D8%AA%DB%8C%DA%A9-%D8%B3%D8%B1%DA%86-%D8%AF%D8%B1-%D9%84%D8%A7%D8%B1%D8%A7%D9%88%D9%84-ncuxvjeilqcl) | مقایسهٔ client و روش همگام‌سازی در Laravel | قدیمی و framework-specific؛ dependency و سازگاری client را دوباره بررسی کن. |
| [دورهٔ مقدماتی Elasticsearch در تاپ‌لرن](https://toplearn.com/c/6112) | دورهٔ ویدیویی فارسی؛ فهرست منتشرشده شامل aggregationهایی مانند `cardinality` است | دسترسی و کامل‌بودن درس‌ها به وضعیت سایت/حساب وابسته است؛ مرجع syntax نسخه نیست. |
| [دورهٔ جامع Elasticsearch و ELK در EngineDevOps](https://enginedevops.com/product/آموزش-جامع-elasticsearch) | سرفصل فارسی از cluster و shard تا bulk، analyzer، inverted index و query | صفحهٔ دوره بخشی از درس‌ها را خصوصی نشان می‌دهد؛ جزوه یا مستند نسخه‌دار محسوب نمی‌شود. |
| [مقالهٔ فارسی نصب و معرفی Elasticsearch در Nadinsoft](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/) | آشنایی تاریخی با کاربرد و اجزای Elastic Stack | منتشرشده در ۱۴۰۰؛ برای نصب و دستورهای اجرایی قدیمی است. |
| [پروژهٔ ParsiAnalyzer](https://github.com/NarimanN2/ParsiAnalyzer) | نمونه‌ای از tokenization، normalization، نیم‌فاصله، عدد و stemming فارسی | README نصب را برای Elasticsearch 7.13.1 نشان می‌دهد؛ برای نسخهٔ جدید بدون build و آزمون سازگاری نصب نکن. |
| [Persian analyzer دیگر در GitHub](https://github.com/mlkmhd/persian-analyzer-elasticsearch) | کد نمونه برای مقایسهٔ analyzer فارسی | مخزن کوچک و کم‌فعالیت است؛ کد آن را به‌عنوان راهنمای مفهومی ببین، نه افزونهٔ پشتیبانی‌شده. |
| [Hazm، ابزار NLP فارسی](https://github.com/roshan-research/hazm) | normalization، tokenization و ابزارهای زبان فارسی برای آماده‌سازی/ارزیابی متن | Elasticsearch plugin نیست؛ هر preprocessing بیرونی باید در زمان index و query یکسان اعمال شود. |

### ویدئوهای فارسی مکمل

- [معرفی Elasticsearch از کانال Bit Code](https://www.youtube.com/watch?v=FpNBpBLodXA) — آشنایی مقدماتی؛ ویدئوی سال ۲۰۲۳.
- [جلسهٔ analyzer در دورهٔ فارسی Elasticsearch](https://www.youtube.com/watch?v=SxI7jPMolKg) — نمونهٔ پیاده‌سازی تحلیلگر؛ نسخهٔ دقیق را از خود ویدئو بررسی کن.
- [جلسهٔ Query DSL در دورهٔ فارسی Elasticsearch](https://www.youtube.com/watch?v=4ylKAaBXHEc) — تمرین query؛ APIهای جدید را با reference جاری تطبیق بده.

## مستندات رسمی انگلیسی بر اساس فصل

### فصل ۱ — مبانی

- [Elasticsearch documentation](https://www.elastic.co/docs/products/elasticsearch)
- [Elasticsearch concepts](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)
- [Distributed nature and architecture](https://www.elastic.co/guide/en/elasticsearch/reference/current/scalability.html)
- [REST API conventions](https://www.elastic.co/guide/en/elasticsearch/reference/current/rest-apis.html)
- [Elastic Stack overview](https://www.elastic.co/what-is/elk-stack)

### فصل ۲ — Mapping و مدل داده

- [Mapping](https://www.elastic.co/docs/manage-data/data-store/mapping)
- [Dynamic mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/dynamic-mapping)
- [Explicit mapping](https://www.elastic.co/docs/manage-data/data-store/mapping/explicit-mapping)
- [Field data types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types)
- [Nested field](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/nested)
- [Mapping limit settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/mapping-limit)

### فصل ۳ — داده و نقش نودها

- [Cluster and node settings](https://www.elastic.co/docs/reference/elasticsearch/configuration-reference/cluster-node-settings)
- [Node roles](https://www.elastic.co/docs/deploy-manage/distributed-architecture/clusters-nodes-shards/node-roles)
- [Cluster coordination](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery.html)
- [Shard allocation](https://www.elastic.co/guide/en/elasticsearch/reference/current/shards-allocation.html)
- [Numeric field types](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number)
- [Date field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date)
- [Geo-point field type](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/geo-point)

### فصل ۴ — Indexing و query languageها

- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [Index API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index)
- [Bulk API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk)
- [Query DSL](https://www.elastic.co/docs/explore-analyze/query-filter/languages/querydsl)
- [ES|QL](https://www.elastic.co/docs/reference/query-languages/esql)
- [EQL](https://www.elastic.co/docs/reference/query-languages/eql)
- [Elasticsearch SQL](https://www.elastic.co/docs/reference/query-languages/sql)
- [Kibana Query Language](https://www.elastic.co/docs/explore-analyze/query-filter/languages/kql)
- [Lucene query syntax in Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)
- [Bulk indexing performance](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html)

### فصل ۵ — Search results و نگهداری

- [Search API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search)
- [Sort search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/sort-search-results)
- [Paginate search results](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)
- [Highlighting](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/highlighting)
- [Reindex API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex)
- [Update by query](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update-by-query)
- [Delete by query](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-by-query)
- [Aliases](https://www.elastic.co/docs/manage-data/data-store/aliases)

### فصل ۶ — Query execution

- [Boolean query](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-bool-query)
- [Query and filter context](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-filter-context)
- [Query DSL](https://www.elastic.co/docs/explore-analyze/query-filter/languages/querydsl)
- [Lucene documentation](https://lucene.apache.org/core/documentation.html)
- [Tune for search speed](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html)

### فصل ۷ — Analysis، aggregation و production

- [Text analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- [Language analyzers, including Persian](https://www.elastic.co/docs/reference/text-analysis/analysis-lang-analyzer)
- [Normalization token filters](https://www.elastic.co/docs/reference/text-analysis/analysis-normalization-tokenfilter)
- [Analyze API](https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze)
- [Doc values](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values)
- [Fielddata](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text#fielddata-mapping-param)
- [Aggregations](https://www.elastic.co/docs/explore-analyze/query-filter/aggregations)
- [Transforms](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview)
- [Similarity and BM25 settings](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity)
- [Index lifecycle management](https://www.elastic.co/docs/manage-data/lifecycle/index-lifecycle-management)
- [Data tiers](https://www.elastic.co/docs/manage-data/lifecycle/data-tiers)
- [Snapshots and restore](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore)
- [Snapshot lifecycle management](https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/snapshot-lifecycle-management)
- [Security](https://www.elastic.co/docs/deploy-manage/security)
- [Roles and privileges](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/role-management)
- [API keys](https://www.elastic.co/docs/deploy-manage/api-keys)

## مقاله‌های فنی، پژوهش و تجربهٔ واقعی

- [Elasticsearch from the Top Down](https://www.elastic.co/blog/found-elasticsearch-top-down) — مقالهٔ معماری از دید مسیر داده و query؛ برای فهم ساختار در کنار docs بخوان.
- [Improve search relevance with Boolean queries](https://www.elastic.co/blog/how-to-improve-elasticsearch-search-relevance-with-boolean-queries) — نمونه‌های عملی رتبه‌بندی با clauseهای bool؛ نتایج را با queryهای خودت دوباره ارزیابی کن.
- [BEIR: a heterogeneous benchmark for information retrieval](https://arxiv.org/abs/2104.08663) — مقالهٔ داوری‌شده/پژوهشی برای ارزیابی روش‌های retrieval؛ نتایج benchmark را به workload محصول خودکار تعمیم نده.
- [Canals: hybrid product search](https://www.elastic.co/customers/canals) — customer story با keyword، dense/sparse vector و مرحلهٔ reranking.
- [Anyone.com: migration of 210 million records](https://www.elastic.co/customers/anyone) — customer story دربارهٔ مهاجرت و index جست‌وجویی.
- [Tinder: real-time recommendations](https://www.elastic.co/customers/tinder) — retrieval چندمرحله‌ای، geo filtering و ranking.
- [Oak Ridge National Laboratory: institutional knowledge search](https://www.elastic.co/customers/ornl) — جست‌وجوی federated و خلاصهٔ منبع‌دار.
- [HSE: ecommerce search](https://www.elastic.co/customers/hse/) — تجربهٔ product discovery و آزمایش A/B.
- [Elastic customer story library](https://www.elastic.co/customers/) — برای یافتن تجربه‌های بیشتر؛ اعداد را به‌عنوان ادعای ناشر و workload خاص همان مطالعه بخوان.

## چطور منبع را ارزیابی کنی

برای API syntax، نسخهٔ دقیق و source-of-truth، مستندات رسمی همان نسخه را انتخاب کن. برای مقالهٔ فنی، تاریخ، نسخه و اینکه benchmark یا نتیجه روی چه داده‌ای اجرا شده را ثبت کن. برای افزونهٔ فارسی، نسخهٔ target، APIهای plugin و روش نصب را پیش از استفاده بررسی کن. لینک‌های جست‌وجوی فارسی که داخل بعضی درس‌ها هستند فقط میان‌بُر discovery هستند؛ جای مقالهٔ مستقیم یا مستند را نمی‌گیرند.
