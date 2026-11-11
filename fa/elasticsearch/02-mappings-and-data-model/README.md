# فصل 02: Mapping و مدل‌سازی داده / Mappings

[English version](../../../en/elasticsearch/02-mappings-and-data-model/README.md)


## درس فصل
Mapping نوع و رفتار field را تعیین می‌کند و روی query، sort، aggregation و تحلیل اثر دارد. Dynamic mapping برای prototype سریع است؛ در تولید mapping صریح یا dynamic محدود جلوی حدس اشتباه را می‌گیرد. تغییر نوع معمولاً به reindex نیاز دارد. text برای full-text و keyword برای exact match/sort مناسب است؛ multi-field هر دو را می‌دهد. object، nested و flattened trade-off دارند. nested رابطه‌ی شروط در آرایه را حفظ می‌کند اما هزینه دارد. mapping explosion از فیلدهای آزاد و نامحدود می‌آید؛ flattened یا key/value می‌تواند کمک کند.

## تمرین فصل
برای کاتالوگ mapping بساز و text، keyword، nested و رفتار فیلد ناخواسته را بررسی کن.

## موضوع‌های این فصل
- [Mappings](topics/01-mappings/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/01-mappings/README.md)
- [Explicit](topics/02-explicit/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/02-explicit/README.md)
- [Dynamic](topics/03-dynamic/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/03-dynamic/README.md)
- [Mapping Explosion](topics/04-mapping-explosion/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/04-mapping-explosion/README.md)
- [Cluster (System)](topics/05-cluster-system/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/05-cluster-system/README.md)
- [Node (Instance)](topics/06-node-instance/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/06-node-instance/README.md)
- [Index (Database)](topics/07-index-database/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/07-index-database/README.md)
- [Document (Row)](topics/08-document-row/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/08-document-row/README.md)
- [ID (Primary Key)](topics/09-id-primary-key/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/09-id-primary-key/README.md)
- [Running with Docker](topics/10-running-with-docker/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/10-running-with-docker/README.md)
- [Elastic Cloud](topics/11-elastic-cloud/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/11-elastic-cloud/README.md)
- [Kibana Console](topics/12-kibana-console/README.md) · [English](../../../en/elasticsearch/02-mappings-and-data-model/topics/12-kibana-console/README.md)

## منابع
- [مستند رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- [Reference کامل Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Roadmap](https://roadmap.sh/elasticsearch)

## تدریس کامل فصل: قرارداد شکل داده در Elasticsearch

Mapping پاسخ می‌دهد هر field چه نوع داده‌ای دارد، چگونه تحلیل می‌شود و برای چه queryهایی قابل استفاده است. Mapping شبیه schema است اما از نظر تغییر نوع انعطاف DB رابطه‌ای را ندارد: پس از index شدن میلیون‌ها سند، تغییر text به date یا number را معمولاً با ساخت index جدید و reindex انجام می‌دهیم.

### Mapping صریح و پویا

Dynamic mapping وقتی سندی می‌رسد field ناشناخته را از نمونه‌ی مقدار حدس می‌زند. این برای آزمایش سریع است، اما اگر نخستین price به صورت رشته بیاید، نوع رشته‌ای می‌تواند برای داده‌ی بعدی مشکل درست کند. در تولید، mapping را پیش از ingest تعریف کن و برای فیلدهای ناپیدا سیاست مشخص بگذار: پذیرش خودکار، ثبت در source بدون index، یا ردکردن سند.

~~~http
PUT /products-v1
{"mappings":{"dynamic":"strict","properties":{"sku":{"type":"keyword"},"title":{"type":"text","fields":{"raw":{"type":"keyword"}}},"price":{"type":"scaled_float","scaling_factor":100},"available":{"type":"boolean"},"created_at":{"type":"date"}}}}
~~~

text برای جست‌وجوی واژه‌ای تحلیل می‌شود؛ keyword مقدار کامل را برای تطبیق دقیق، sort و bucket نگه می‌دارد. multi-field مثل title.raw امکان استفاده از یک مقدار به دو شکل را می‌دهد. price را عددی map کن تا range و aggregation درست کار کند؛ date را با قالب و timezone معلوم بفرست.

### آرایه‌ها و داده‌ی منعطف

object معمولی برای ساختار تو‌در‌تو مفید است، اما آرایه‌ی object ممکن است شرط چند فیلد را بین عضوهای مختلف ترکیب کند. nested هر عضو را جداگانه قابل query می‌کند و رابطه‌ی آن را حفظ می‌کند؛ هزینه‌اش افزایش تعداد سندهای داخلی و پیچیدگی aggregation است. flattened برای objectهایی با کلیدهای آزاد مناسب است، وقتی query روی زیرکلیدهای ساده می‌خواهیم ولی نمی‌خواهیم هر کلید mapping مستقل بسازد.

### Mapping explosion

اگر داده‌ی ورودی نام field را آزادانه تعیین کند، mapping ممکن است هزاران field بسازد. این رشد cluster state و حافظه را سنگین می‌کند. برای جلوگیری: نام field را از مقدار کاربر نساز، schema را کنترل کن، dynamic strict/false یا dynamic template مناسب انتخاب کن و metadata کلیدمتغیر را در ساختار key/value یا flattened نگه دار. افزایش سقف تعداد fieldها فقط وقتی مفید است که رشد واقعاً کنترل‌شده باشد.

### تغییر schema بدون توقف سرویس

1. mapping جدید را در products-v2 بساز.
2. داده‌ی موجود را با Reindex API منتقل کن.
3. هنگام انتقال، تغییرات تازه را با dual-write کنترل‌شده یا event replay جبران کن.
4. تعداد سند، خطا، mapping و queryهای مهم را بین v1 و v2 مقایسه کن.
5. alias خواندن/نوشتن را به نسخه‌ی جدید ببر.
6. نسخه‌ی قبلی را تا پایان پنجره‌ی rollback نگه دار.

### تمرین فصل

برای سفارش، کالا و ویژگی‌های دلخواه فروشنده mapping طراحی کن. مشخص کن کدام فیلد text، keyword، numeric، date، nested یا flattened می‌شود. سه سند نامعتبر بفرست و تصمیم بگیر رد شوند یا ذخیره‌ی محدود داشته باشند. سپس تغییر نوع price را با v2 و reindex روی داده‌ی آزمایشی تمرین کن.

### آزمون فصل

1. **چرا تغییر نوع معمولاً reindex می‌خواهد؟** چون داده و index داخلی با نوع/تحلیل قبلی ساخته شده‌اند.
2. **چرا title ممکن است multi-field داشته باشد؟** برای full-text روی text و exact/sort روی keyword.
3. **چه وقت nested را انتخاب می‌کنیم؟** وقتی شروط چند field باید روی همان عنصر آرایه برقرار باشند.
4. **راه اصلی کاهش mapping explosion چیست؟** کنترل schema و جلوگیری از تولید field name نامحدود؛ نه صرفاً افزایش limit.




