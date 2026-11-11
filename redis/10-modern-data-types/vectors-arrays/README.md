<div dir="rtl" align="right">

# Vector Sets و Arrays در Redis

> English edition: [Redis Vector Sets and Arrays](README.en.md)

> مسیر: فصل ۱۰، ساختارهای دادهٔ جدید · سطح: میانی تا پیشرفته · زمان: ۱۲۰ تا ۱۸۰ دقیقه
>
> این درس دو موضوع جدا دارد: جست‌وجوی شباهت میان بردارهای embedding و آرایهٔ index-addressable. Vector Set جایگزین Array نیست و Array نیز ابزار جست‌وجوی برداری نیست.

## پیش‌نیاز و هدف یادگیری

پیش از شروع، مفاهیم Hash, JSON, Sorted Set, حافظه، نسخهٔ Redis و API client را مرور کن. در پایان می‌توانی:

- embedding، بُعد، فاصله/شباهت، top-k و recall را با زبان ساده توضیح بدهی.
- بردارها و ویژگی‌هایشان را در Vector Set درج کنی و نزدیک‌ترین عضوها را جست‌وجو کنی.
- محدودیت جست‌وجوی تقریبی، کیفیت مدل، metadata و ارزیابی را در طراحی production لحاظ کنی.
- Vector Sets را از Redis Query Engine و indexهای `FT.*` تمیز دهی.
- با Redis 8.8 Array بسازی، indexها را بخوانی/به‌روز کنی و ring buffer با اندازهٔ ثابت بسازی.
- Array را به‌جای List یا JSON array فقط وقتی به‌کار ببری که دسترسی عددی/بازه‌ای واقعاً مسئله باشد.

## بخش اول: Vector Sets و جست‌وجوی معنایی

## ۱. از متن تا بردار

یک embedding یک نمایش عددی از متن، تصویر یا دادهٔ دیگری است که مدل یادگیری ماشین تولید می‌کند. برای متن، مثلاً مدل برای «کفش پیاده‌روی» و «کفش مناسب قدم زدن» بردارهایی می‌سازد که در فضای هندسی نسبتاً نزدیک‌اند. بردار معمولاً صدها یا هزاران عدد دارد.

Redis embedding را تولید نمی‌کند. برنامه معمولاً متن را به سرویس/مدل embedding می‌فرستد، بردار را دریافت می‌کند و در Redis ذخیره می‌کند. برای query نیز همان مدل/نسخه با همان preprocessing باید query embedding را بسازد؛ پس از آن Redis عضوهای نزدیک را برمی‌گرداند.

**نزدیکی هندسی = حقیقت معنایی نیست.** کیفیت وابسته به مدل، زبان، دامنه، chunking، normalization و metric است. مدل ضعیف یا mismatch بین query و document ممکن است نتایج بد بدهد حتی اگر Redis کاملاً درست کار کند.

## ۲. مفهوم‌های پایه

- **Dimension:** تعداد مؤلفه‌های بردار. تمام بردارهای یک مجموعه باید سازگار باشند. اگر embedding مدل ۳۸۴عددی است، بردار ۷۶۸تایی را در همان set وارد نکن.
- **Metric:** روش سنجش نزدیکی: cosine similarity/distance، L2/Euclidean یا inner product در سیستم‌های vector search. metric باید با مدل و شیوهٔ تولید embedding هم‌خوان باشد.
- **k / top-k:** تعداد نتایج درخواستی.
- **Exact nearest neighbor:** همهٔ بردارها مقایسه می‌شوند؛ دقیق اما با بزرگ‌شدن داده گران‌تر.
- **Approximate nearest neighbor (ANN):** index گرافی مثل HNSW نامزدهای محتمل را سریع پیدا می‌کند؛ ممکن است نزدیک‌ترین عضو واقعی را جا بیندازد.
- **Recall@k:** چند نتیجه از k نزدیک‌ترین واقعی در top-k سیستم پیدا شدند. اگر از ۱۰ نزدیک‌ترین واقعی، ۹ تا آمده‌اند، recall@10 برابر ۰٫۹ است.
- **Latency:** زمان جست‌وجو؛ در production توزیع p50/p95/p99 را در بار واقعی بسنج.
- **Metadata/filter:** ویژگی‌هایی مثل category, tenant, language, price که جست‌وجو را محدود می‌کنند.

در Vector Sets، `EF` میزان جست‌وجو/کاوش گراف را کنترل می‌کند: بالا بردن آن معمولاً recall را بهتر اما latency را بیشتر می‌کند. `M`/پارامترهای ساخت گراف، quantization و نسخه هم روی حافظه، سرعت و کیفیت اثر دارند. هر تنظیم را روی test set واقعی بسنج؛ یک benchmark تبلیغاتی عدد SLA برنامهٔ تو نیست.

## ۳. Vector Set با commandهای اصلی

Vector Set نوع دادهٔ بومی Redis 8.0 است. `VADD` بردار را زیر نام یک element ذخیره می‌کند؛ نام element شناسهٔ سند/محصول است. `VSIM` با یک بردار یا عضو موجود، مشابه‌ها را پیدا می‌کند.

```text
DEL lab:products:vec
VADD lab:products:vec VALUES 3 0.9 0.1 0.0 product:running-shoe
VADD lab:products:vec VALUES 3 0.8 0.2 0.1 product:trail-shoe
VADD lab:products:vec VALUES 3 0.0 0.1 0.9 product:coffee-mug
VCARD lab:products:vec
VDIM lab:products:vec
TYPE lab:products:vec
VSIM lab:products:vec VALUES 3 0.85 0.15 0.05 COUNT 2 WITHSCORES
```

در این دادهٔ سه‌بعدی ساختگی، query به دو کفش نزدیک‌تر است. مقادیر بالا **embedding واقعی نیستند** و معنای زبان طبیعی ندارند؛ فقط برای یادگیری syntax هستند. پاسخ `WITHSCORES` مقدار شباهت/رتبهٔ داخلی برمی‌گرداند، نه درصد احتمال «این محصول حتماً مرتبط است». نمره را با benchmark همان مدل تفسیر کن.

جست‌وجو بر اساس یک عضو ذخیره‌شده:

```text
VSIM lab:products:vec ELE product:running-shoe COUNT 2 WITHSCORES
```

درج مجدد همان `element` می‌تواند بردارش را update کند. اگر text/model عوض شده، متن و embedding باید به‌صورت سازگار update شوند؛ embedding کهنه با سند جدید نتایج گمراه‌کننده می‌دهد.

## ۴. ویژگی و فیلتر

Vector Set می‌تواند attributeهای JSON را کنار element نگه دارد:

```text
VSETATTR lab:products:vec product:running-shoe {"category":"shoes","price":90,"lang":"fa"}
VSETATTR lab:products:vec product:trail-shoe {"category":"shoes","price":120,"lang":"fa"}
VSETATTR lab:products:vec product:coffee-mug {"category":"home","price":15,"lang":"en"}
VGETATTR lab:products:vec product:running-shoe
VSIM lab:products:vec VALUES 3 0.85 0.15 0.05 FILTER '.category == "shoes" && .price < 100' COUNT 5 WITHATTRIBS
```

Filter سادهٔ attribute می‌تواند tenant/category/قیمت را محدود کند، اما برای ACL حساسیت‌بالا باید authorization در برنامه و query design محکم باشد. فیلتر را برای امنیت row-level تنها سد دفاعی فرض نکن. شناسهٔ tenant را از درخواست احراز هویت‌شده بگیر، نه از پارامتر قابل‌دست‌کاری کاربر.

سایر فرمان‌های مفید: `VCARD` تعداد عضوها، `VDIM` dimension، `VEMB` بردار عنصر، `VINFO` وضعیت، `VSETATTR` و `VGETATTR` metadata، `VREM` حذف عضو. در برخی نسخه‌ها فرمان‌های جدیدتری مثل `VISMEMBER` یا `VRANGE` اضافه شده‌اند؛ compatibility را بررسی کن.

## ۵. Vector Sets در برابر Redis Query Engine

Redis دو امکان مرتبط ولی متفاوت دارد. **Vector Sets** نوع دادهٔ بومی با `VADD`/`VSIM` و HNSW داخلی است؛ برای similarity ساده، نمونه‌سازی یا نیازهای سبک مناسب است. **Redis Query Engine** (قبلاً RediSearch؛ در Redis 8 یکپارچه) روی Hash/JSON index می‌سازد و از `FT.CREATE`, `FT.SEARCH`, `FT.HYBRID` و فیلترهای غنی‌تر استفاده می‌کند.

| معیار | Vector Sets | Query Engine روی Hash/JSON |
| --- | --- | --- |
| نگهداری بردار | عضو Vector Set | فیلد vector در Hash/JSON document |
| جست‌وجو | `VSIM` | `FT.SEARCH` و حسب نسخه `FT.HYBRID` |
| ساختار index | داخلی و ساده‌تر | FLAT/HNSW/SVS-VAMANA و تنظیمات/قابلیت‌های وابسته به نسخه |
| فیلتر | JSON attribute expression ساده | فیلترهای structured، متن، tag، numeric، geo و aggregation (بسته به قابلیت نسخه) |
| مناسب برای | similarity سبک و data type ساده | query ترکیبی، full-text + metadata + vector و schema/index کنترل‌شده |

Vector Set را «تمام قابلیت vector search در Redis» ندان. پیش از تصمیم، query واقعی، فیلترها، shard behavior، ظرفیت، backup/restore، client و نسخه/edition را فهرست کن. راهنمای [جست‌وجوی برداری در Redis](https://redis.io/blog/vector-indexes-in-redis/) تفاوت این دو مسیر را توضیح می‌دهد؛ چون مقاله از Redis منتشر شده، benchmarkهایش را مستقل حساب نکن.

## ۶. معماری RAG/جست‌وجوی محصول

یک نمونهٔ self-contained برای جست‌وجوی پرسش روی مستندها:

1. اسناد را از منبع اصلی بخوان و به chunkهایی با اندازهٔ قابل‌جست‌وجو تقسیم کن؛ metadata شامل `doc_id`, `chunk_id`, `tenant_id`, `language`, `updated_at` باشد.
2. متن chunk را با نسخهٔ مشخص مدل embedding به بردار تبدیل کن؛ `model_id` و dimension را ثبت کن.
3. متن و metadata را در منبع authoritative یا Hash/JSON ذخیره کن؛ Vector Set فقط embedding/شناسه/attributeهای لازم برای retrieval را نگه دارد.
4. در query، مجوز tenant را از context احراز هویت‌شده بگیر؛ query را با همان مدل embedding کن و `VSIM` بزن.
5. تعداد نامزدها را بیشتر از تعداد نهایی بخواه (مثلاً top 20)، سپس فیلتر مجوز، حذف duplicate/نسخهٔ منسوخ، reranking یا keyword check انجام بده.
6. متن‌های اصلی را با شناسه از storage بخوان و به مدل پاسخ‌گو بده؛ فقط id/chunkهای مجاز را به context بده.
7. citationها را از doc/chunk source بساز و به کاربر نشان بده؛ embedding score را با حقیقت/منبع یکی ندان.
8. quality dataset بساز: query واقعیِ بی‌نام، پاسخ/سند مرتبط برچسب‌خورده، recall@k, precision@k, nDCG و ارزیابی انسانی.

وقتی مدل را عوض می‌کنی، embeddingهای قبلی لزوماً قابل‌مقایسه نیستند. نسخهٔ index را جدا کن (مثلاً `docs:vec:v2`)، backfill و مقایسه کن، بعد ترافیک را تدریجی جابه‌جا کن. تغییر بعدی را با migration/rollback در [ارتقا و DR](../../09-production-enterprise/upgrade-dr/README.md) بسنج.

## ۷. تجربهٔ واقعی منتشرشده و برداشت درست

Redis داستان مشتری [Docugami](https://redis.io/customers/docugami/) را منتشر کرده است: این شرکت Redis را برای vector store در pipelineهای ML، به‌همراه قابلیت‌های document indexing، search و Auto Tiering ذکر می‌کند. این تجربه نشان می‌دهد vector retrieval می‌تواند جزئی از معماری AI/search یک محصول باشد؛ اما مقالهٔ مشتری که vendor منتشر کرده، مطالعهٔ مستقل یا تضمین عملکرد محصول تو نیست. راهنماهای [Redis برای vector search](https://redis.io/blog/vector-search-guide/) و [vector indexها و الگوریتم‌ها](https://redis.io/blog/vector-indexes-in-redis/) توضیح فنی تکمیلی دارند.

منابع فارسی Redis Vector Sets بسیار محدودتر از مستند انگلیسی است. مقالهٔ فارسی [جستجوی برداری چیست؟ در DNTips](https://www.dntips.ir/exports/news/www.dntips.ir-news-20284.pdf) و مطلب آموزشی [embedding فارسی](https://dsp-lab.ir/wp-content/uploads/2022/11/ML-NLP-HW2-IR-1401-1.pdf) برای فهم مفهوم بردار کمک می‌کنند، اما syntax و محدودیت Redis را پوشش نمی‌دهند. آموزش همان syntax در همین درس است؛ برای نسخهٔ به‌روز به command reference رسمی لینک‌شده در پایان رجوع کن.

## ۸. خطاها و خطرهای بردار

- Dimension متفاوت: همهٔ vectorها باید با schema همان مجموعه سازگار باشند. `ERR vector dimension mismatch` یعنی قبل از retry dimension را با `VDIM`/نسخهٔ مدل کنترل کن.
- مدل/metric mismatch: از یک مدل برای اسناد و مدل دیگر برای query استفاده نکن، مگر cross-model بودن صریحاً آموزش داده شده باشد.
- امتیاز را probability تفسیر نکن: score ranking/distance است؛ calibration می‌خواهد.
- ANN recall را تضمین exact ندان: روی نمونهٔ کوچک exact/brute-force مقابل ANN مقایسه کن.
- زبان فارسی: نیم‌فاصله، نرمال‌سازی «ی/ک»، اعراب، tokenizer، query کوتاه و code-switching در dataset واقعی ارزیابی شود.
- metadata stale: تغییر قیمت/موجودی/دسترسی بدون update index می‌تواند نتیجهٔ غلط بدهد؛ فیلدهای پویا را از منبع فعلی دوباره validate کن.
- privacy: embedding ممکن است اطلاعات حساس را بازتاب دهد؛ retention، دسترسی، log، حذف کاربر و backupها را طراحی کن.
- حافظه: dimension بالا × تعداد بردار، graph، attributeها، replica و fragmentation هزینه دارد؛ index یک میلیون رکورد را با دادهٔ نمونهٔ واقعی اندازه بگیر.
- hot keys / tenant imbalance: یک مجموعهٔ عظیم و query پرتراکم می‌تواند به گلوگاه CPU/RAM یا shard تبدیل شود؛ partition را بر query و داده طراحی کن.

## بخش دوم: Redis Arrays

## ۹. Array در Redis چیست؟

Redis Array نوع دادهٔ جدید Redis 8.8 است: مجموعه‌ای مرتب با index عددی، دسترسی مستقیم `O(1)` برای خواندن یک خانه و نوشتن بلوکی با `ARSET`. برخلاف List که برای push/pop در ابتدا/انتها و queue خوب است، Array برای «عنصر index شمارهٔ i»، خواندن بازه، به‌روزرسانی slotهای مشخص و aggregation ساده ساخته شده است.

یک نکتهٔ ظریف: Array می‌تواند **sparse** باشد. `ARLEN` طول منطقی (بزرگ‌ترین index + 1) است؛ `ARCOUNT` تعداد slotهای پر را می‌دهد. نوشتن در index بزرگ به معنی وجود مقدار در همهٔ indexهای بین آن نیست. دادهٔ sparse را با `ARGETRANGE` گسترده بی‌حساب نخوان؛ ممکن است پاسخ پر از nil و حجیم شود.

## ۱۰. ساختن و خواندن

```text
DEL lab:events
ARSET lab:events 0 login click purchase
ARGET lab:events 0
ARGET lab:events 2
ARGET lab:events 99
ARLEN lab:events
ARCOUNT lab:events
ARGETRANGE lab:events 0 2
```

`ARSET key start-index value...` مقدارهای پشت‌سرهم را از index داده‌شده می‌نویسد. index از صفر شروع می‌شود. `ARGET` در index خالی یا خارج از داده `nil` می‌دهد. range انتهایی را در نسخه/command reference بررسی کن و بازهٔ بزرگ را paginate/محدود کن.

به‌روزرسانی slot یا چند index مستقل:

```text
ARSET lab:events 1 product-view
ARMSET lab:events 0 session-start 4 checkout-start
ARMGET lab:events 0 1 2 3 4 99
```

`ARMSET` چند جفت index/value می‌گیرد؛ `ARMGET` چند index را در یک round trip می‌خواند. این کاهش round trip است، نه تضمین transaction بین چند درخواست. هر فرمان به‌تنهایی در Redis اجرا می‌شود؛ منطق چندفرمانی را با transaction/script طراحی کن.

## ۱۱. درج، حذف، scan و aggregation

`ARINSERT` با cursor درج، `ARNEXT` محل بعدی را می‌گوید و `ARSEEK` cursor را جابه‌جا می‌کند. حذف index/بازه با `ARDEL` و `ARDELRANGE` انجام می‌شود. `ARSCAN` فقط slotهای موجود در بازه را به شکل index/value می‌پیماید. برای aggregation عددی می‌توان از `AROP` مثل `SUM`, `MIN`, `MAX`, `AND`, `OR`, `XOR`, `MATCH` استفاده کرد.

```text
DEL lab:scores
ARSET lab:scores 0 10 20 30 40 50
AROP lab:scores 0 5 SUM
AROP lab:scores 0 5 MAX
AROP lab:scores 0 5 MATCH 30
ARDEL lab:scores 1
ARLEN lab:scores
ARCOUNT lab:scores
```

`AROP` در خود Redis روی محدوده عمل می‌کند و می‌تواند round trip و پردازش برنامه را کم کند، ولی اسکن یک محدودهٔ عظیم همچنان کار دارد. پیچیدگی و رفتار sparse/dense را در مستند همان نسخه بخوان.

## ۱۲. Ring buffer با اندازهٔ ثابت

یک circular/ring buffer آخرین N داده را نگه می‌دارد و دادهٔ جدید با wraparound قدیمی‌ترین slot را overwrite می‌کند. برای آخرین چند رخداد debug یا آخرین نمونه‌های یک session مفید است؛ برای صف durable یا تاریخچهٔ بدون حذف مناسب نیست.

```text
DEL lab:recent:alerts
ARRING lab:recent:alerts 3 alert-1
ARRING lab:recent:alerts 3 alert-2
ARRING lab:recent:alerts 3 alert-3
ARRING lab:recent:alerts 3 alert-4
ARGET lab:recent:alerts 0
ARLASTITEMS lab:recent:alerts 3
```

بعد از چهارمین درج، index حلقه‌ای wrap می‌شود و قدیمی‌ترین مقدار جایگزین می‌گردد. cursor داخلی، ترتیب چرخشی و ترتیب «قدیمی به جدید» را یکی فرض نکن؛ برای مصرف آخرین رویدادها از `ARLASTITEMS` و دستورهای مشاهده استفاده کن. `ARRING key size value...` عملیات insert/wrap را به یک فرمان atomic تبدیل می‌کند. تغییر size هزینهٔ resize دارد؛ اندازه را پایدار انتخاب کن.

## ۱۳. Array یا List یا JSON Array؟

| نیاز | انتخاب ابتدایی | چرا |
| --- | --- | --- |
| صف کار با `LPUSH`/`RPOP` یا push/pop دو سر | List | عملیات queue/deque طبیعی است. |
| آخرین N مقدار ثابت با index و دسترسی سریع به خانه | Array/Ring buffer | index مستقیم و `ARRING` ساده دارد (Redis 8.8+). |
| اعضای یکتا بدون ترتیب/عضویت دقیق | Set | مدل membership است. |
| ترتیب بر اساس score، rank یا range score | Sorted Set | رتبه و score مفهوم اصلی‌اند. |
| سند JSON تو‌در‌تو و array بخشی از document است | Redis JSON | path و ساختار JSON کاربردی است. |
| نمونه‌های زمان‌دار با retention و aggregation | Time Series | timestamp و query زمانی built-in است. |

مقالهٔ معرفی Redis برای Array یک benchmark داخلی Redis 8.8 برای سناریوی ring buffer گزارش می‌کند: `ARRING` در تنظیم آزمایشگاهی Redis از الگوی `RPUSH+LTRIM` سریع‌تر بوده، در عوض Array حدود ۱۸٪ حافظهٔ بیشتر از List مصرف کرده است. این اعداد به سخت‌افزار/نسخه و payload همان تست وابسته‌اند؛ نتیجهٔ تو باید benchmark شود. [مقالهٔ معرفی Redis Arrays](https://redis.io/blog/announcing-redis-8-8/) را به‌عنوان نتیجهٔ vendor بخوان، نه تضمین ثابت.

## ۱۴. تجربهٔ عملی: debug buffer و retrieval معنایی

**Vector retrieval:** Docugami در case منتشرشدهٔ Redis، vector store را بخشی از pipeline یادگیری ماشین و document search خود توصیف می‌کند؛ این معماری حول embedding و دسترسی سریع به chunkهای سند می‌چرخد. برداشت آموزشی: شناسهٔ vector باید به سند اصلی، نسخه و مجوز آن وصل باشد؛ embedding به‌تنهایی پاسخ نهایی نیست.

**Ring buffer:** تیم on-call می‌تواند آخرین چند transition یک دستگاه را در Array ring buffer نگه دارد تا هنگام incident وضعیت اخیر را سریع بخواند. این الگو فقط debug context محدود است؛ برای audit trail، کارهای در صف، یا پیام‌هایی که نباید از دست بروند از stream/queue durable و storage ماندگار استفاده کن. این بخش یک الگوی عملی عمومی است، نه ادعای case study شرکت مشخص.

## ۱۵. کارگاه A: جست‌وجوی محصول با بردار ساختگی

### داده و query

```text
DEL lab:catalog:v1
VADD lab:catalog:v1 VALUES 3 1.0 0.0 0.0 item:red-shoe
VADD lab:catalog:v1 VALUES 3 0.9 0.1 0.0 item:blue-shoe
VADD lab:catalog:v1 VALUES 3 0.0 0.0 1.0 item:coffee
VSETATTR lab:catalog:v1 item:red-shoe {"category":"shoes","active":true}
VSETATTR lab:catalog:v1 item:blue-shoe {"category":"shoes","active":true}
VSETATTR lab:catalog:v1 item:coffee {"category":"drinkware","active":true}
VSIM lab:catalog:v1 VALUES 3 0.95 0.05 0.0 COUNT 3 WITHSCORES WITHATTRIBS
VSIM lab:catalog:v1 VALUES 3 0.95 0.05 0.0 FILTER '.category == "shoes" && .active == true' COUNT 3 WITHSCORES
```

1. نتیجهٔ اول را بخوان و order را با query vector مقایسه کن.
2. نتیجهٔ فیلترشده چرا coffee را حذف می‌کند؟
3. category را اشتباه بنویس یا dimension را به ۴ تغییر بده؛ پیام خطا چه چیزی یاد می‌دهد؟
4. اگر متن کالا تغییر کند ولی بردارش عوض نشود، چه نتیجه‌ای می‌گیری؟
5. برای محصولات فارسی، چه queryها و برچسب‌گذاری انسانی برای سنجش relevance می‌سازی؟

### پاسخ راهنما

بردارهای مصنوعی صرفاً محورهای ساده‌اند و رابطهٔ واقعی متن ندارند. فیلتر attribute نتیجه را به `shoes` محدود می‌کند. dimension باید در همهٔ VADD/VSIM سازگار باشد. تغییر متن نیازمند re-embedding و update منسجم است. مجموعهٔ ارزیابی باید queryهای واقعی فارسی، مترادف‌ها، غلط املایی/نیم‌فاصله و سندهای مرتبط/نامرتبط برچسب‌خورده داشته باشد.

## ۱۶. کارگاه B: Array به‌عنوان ring buffer

```text
DEL lab:device:7:recent
ARRING lab:device:7:recent 4 boot
ARRING lab:device:7:recent 4 connected
ARRING lab:device:7:recent 4 warning
ARRING lab:device:7:recent 4 disconnected
ARRING lab:device:7:recent 4 rebooted
ARLASTITEMS lab:device:7:recent 4
ARLEN lab:device:7:recent
ARCOUNT lab:device:7:recent
```

پنج event در buffer چهارخانه‌ای رخ داده است؛ قدیمی‌ترین را پیدا کن، سپس با `ARGETRANGE` slotها را ببین و ترتیب نمایش را با `ARLASTITEMS` مقایسه کن. `ARCOUNT` تعداد خانه‌های پر و `ARLEN` مرز indexهای پر را نشان می‌دهد، نه یک timestamp یا count قابل‌استفاده به‌عنوان منبع business.

## ۱۷. عیب‌یابی

| نشانه | علت محتمل | تشخیص/رفع |
| --- | --- | --- |
| `unknown command VADD` | Redis قدیمی‌تر از 8.0 یا product بدون feature | نسخه، package و compatibility را بررسی کن. |
| `unknown command ARSET` | Redis قدیمی‌تر از 8.8 یا endpoint فاقد پشتیبانی | نسخهٔ دقیق را با docs command تطبیق بده. |
| dimension mismatch | vectorها با dimension متفاوت ساخته شده‌اند | `VDIM` و metadata مدل/embedding pipeline را بررسی و نسخه‌بندی کن. |
| نتایج بی‌ربط | مدل/metric/query normalization نامتناسب، دادهٔ قدیمی، test ناقص | query evaluation، متن chunkها و embedding model را مرور کن. |
| فیلتر هیچ نتیجه نمی‌دهد | JSON attribute غایب، نوع داده یا expression اشتباه | `VGETATTR` و syntax filter را کنترل کن. |
| آرایه length خیلی بزرگ ولی داده کم است | Array sparse و indexهای خالی زیادند | `ARCOUNT`، index pattern و هزینهٔ scan را اندازه بگیر. |
| حلقه رویداد مورد انتظار را برنمی‌گرداند | cursor wrap یا فهم نادرست ترتیب | `ARLASTITEMS`, `ARGETRANGE`, `ARINFO` و cursor را بررسی کن. |
| client فرمان جدید را نمی‌شناسد | نسخهٔ SDK قدیمی یا command mapping ناقص | raw command را در lab بررسی، SDK سازگار انتخاب و connection را با feature check بالا بیاور. |

## ۱۸. تمرین‌های طراحی و سؤال‌های مصاحبه

1. مجموعهٔ embedding صد هزار مقالهٔ ۷۶۸بُعدی دارد؛ چه داده‌ای برای تخمین RAM علاوه بر ضرب count×dimension لازم داری؟
2. query به فارسی است اما اسناد دو زبانه‌اند؛ چه evaluation set می‌سازی و چه مدل‌هایی را مقایسه می‌کنی؟
3. حذف یک کاربر از سیستم لازم است؛ از vector index، متن اصلی، backup و cache چه چیزهایی باید حذف/بازسازی شوند؟
4. چرا `VSIM` را بدون filter tenant در API عمومی خطرناک می‌دانی؟ جریان authorization را توضیح بده.
5. چه زمانی Vector Set را انتخاب می‌کنی و چه زمانی Query Engine با `FT.SEARCH`/`FT.HYBRID`؟ یک نیاز با full-text، فیلتر قیمت و similarity طراحی کن.
6. برای HNSW، افزایش `EF` چه tradeoffی دارد؟ چگونه نقطهٔ مناسب را از روی داده می‌یابی؟
7. آیا بالاترین `WITHSCORES` برابر ۹۵٪ احتمال مرتبط‌بودن است؟ چرا نه؟
8. یک Array با مقادیر index 0 و 1,000,000 دارد. تفاوت `ARLEN` و `ARCOUNT` را بیان کن و بگو کدام command خطر پاسخ عظیم دارد.
9. ring buffer ۱۰۰۰تایی چه تضمینی دربارهٔ eventهای قدیمی می‌دهد؟ اگر تیم audit به تمام eventها نیاز دارد چه باید کرد؟
10. چرا Array برای queue jobها الزاماً بهتر از List نیست؟ عملیات لازم را با نوع دادهٔ انتخابی تطبیق بده.

### پاسخ‌های راهنما

1. عدد/precision بردار، graph overhead، attributes, key/object overhead, quantization, replicas, fragmentation, persistence buffers و allocator؛ benchmark روی نمونه و headroom.
2. queryهای واقعی فارسی/دو زبانه با قضاوت انسانی، query ساده/مترادف/نیم‌فاصله، relevant docs و معیارهای recall@k/nDCG/latency؛ ارزیابی جدا از انتخاب زیرساخت.
3. منبع اصلی، vector member، metadata/index، replica طبق topology و backupهای نگهداری‌شده طبق سیاست privacy/retention. حذف از cache live به‌تنهایی حذف از backup نیست.
4. کاربر ممکن است شناسه/متن tenant دیگر را با query semantic ببیند. tenant از identity معتبر گرفته شود و در query/filter و validation نتیجه enforce شود.
5. similarity ساده و attributeهای سبک → Vector Set؛ ترکیب semantic + lexical + structured filters/aggregations → Query Engine با قابلیت نسخهٔ لازم.
6. EF بالاتر معمولاً نامزدهای بیشتری را بررسی می‌کند؛ recall بهتر و latency/CPU بیشتر. sweep چند مقدار EF روی مجموعهٔ labeled با concurrency واقعی.
7. score فاصله/شباهت برای ranking است و معمولاً calibrated probability نیست؛ بدون calibration و validation انسانی این تفسیر نادرست است.
8. `ARLEN` طول منطقی تا آخرین index + 1 است؛ `ARCOUNT` تعداد خانه‌های پر. `ARGETRANGE` برای بازهٔ بسیار بزرگ ممکن است پاسخ عظیم شامل nil بسازد؛ `ARSCAN` فقط slotهای موجود را می‌پیماید.
9. فقط آخرین ۱۰۰۰ entry می‌ماند؛ rollover دادهٔ قدیمی را overwrite می‌کند. برای audit، stream durable/log/storage ماندگار و retention جدا لازم است.
10. queue به pop/push و semantics کار/ack/retry نیاز دارد؛ Array بیشتر برای index/random access و buffer محدود است. نوع داده را از عملیات و قرارداد تحویل انتخاب کن.

## کوییز

### ۱. Redis خودش embedding تولید می‌کند؟

<details><summary>پاسخ</summary>

خیر؛ application یا مدل جدا embedding می‌سازد و Redis آن را ذخیره/جست‌وجو می‌کند.

</details>

### ۲. آیا دو embedding با dimension متفاوت را در یک Vector Set می‌توان جست‌وجو کرد؟

<details><summary>پاسخ</summary>

نه؛ dimension باید سازگار باشد. مدل و بُعد را نسخه‌بندی کن.

</details>

### ۳. `VSIM` چه می‌کند؟

<details><summary>پاسخ</summary>

elementهای یک Vector Set را بر اساس شباهت با بردار یا عضو مشخص رتبه‌بندی می‌کند.

</details>

### ۴. `WITHSCORES` یعنی پاسخ به شکل probability است؟

<details><summary>پاسخ</summary>

خیر؛ score برای رتبه‌بندی/فاصله است، نه احتمال کالیبره‌شده مگر جداگانه کالیبره و ارزیابی شود.

</details>

### ۵. Vector Set و Query Engine یک قابلیت واحدند؟

<details><summary>پاسخ</summary>

خیر؛ Vector Set یک نوع دادهٔ بومی ساده‌تر با `VADD`/`VSIM` است؛ Query Engine روی Hash/JSON، index و queryهای متنوع‌تری می‌سازد.

</details>

### ۶. بالا بردن EF چه هزینه‌ای دارد؟

<details><summary>پاسخ</summary>

می‌تواند recall را بهتر کند ولی latency/CPU را هم بالا ببرد؛ باید روی داده و concurrency واقعی tune شود.

</details>

### ۷. Array از کدام Redis release می‌آید؟

<details><summary>پاسخ</summary>

Redis 8.8؛ نصب قدیمی ممکن است فرمان‌های `AR*` را نداشته باشد.

</details>

### ۸. `ARLEN` با `ARCOUNT` چه فرقی دارد؟

<details><summary>پاسخ</summary>

`ARLEN` بالاترین index پر + ۱ (طول منطقی) و `ARCOUNT` تعداد slotهای پر را می‌دهد.

</details>

### ۹. `ARRING` برای چه مناسب است؟

<details><summary>پاسخ</summary>

buffer محدود که با پرشدن ظرفیت قدیمی‌ترین slot را overwrite می‌کند؛ برای event queue یا audit بی‌نهایت نیست.

</details>

### ۱۰. Array را چه وقت به List ترجیح می‌دهی؟

<details><summary>پاسخ</summary>

وقتی random access بر اساس index، range/index operations یا ring buffer ثابت مهم باشد؛ برای push/pop queue، List اغلب طبیعی‌تر است.

</details>

## منابع تکمیلی

### انگلیسی و رسمی

- [مستند Redis Vector Sets](https://redis.io/docs/latest/develop/data-types/vector-sets/) — مفاهیم، فرمان‌ها و filter.
- [`VADD`](https://redis.io/docs/latest/commands/vadd/) و [`VSIM`](https://redis.io/docs/latest/commands/vsim/) — syntax مرجع.
- [راهنمای performance برای Vector Sets](https://redis.io/docs/latest/develop/data-types/vector-sets/performance/) — EF، throughput و quantization؛ اعداد نمونهٔ vendor هستند.
- [Vector indexها در Redis](https://redis.io/blog/vector-indexes-in-redis/) و [راهنمای عملی vector search](https://redis.io/blog/vector-search-practical-guide/) — Query Engine و hybrid search.
- [Redis Arrays](https://redis.io/docs/latest/develop/data-types/arrays/) — کاربرد، range، sparse data، ring buffer و جایگزین‌ها.
- [`ARRING`](https://redis.io/docs/latest/commands/arring/), [`ARSET`](https://redis.io/docs/latest/commands/arset/) و [`ARGET`](https://redis.io/docs/latest/commands/arget/).
- [What’s new in Redis 8.8](https://redis.io/docs/latest/develop/whats-new/8-8/) و [مقالهٔ معرفی Array](https://redis.io/blog/announcing-redis-8-8/).
- [Docugami customer story](https://redis.io/customers/docugami/) — تجربهٔ منتشرشده توسط Redis، نه ارزیابی مستقل.

### فارسی

- [جستجوی برداری چیست؟ — مرور فارسی DNTips](https://www.dntips.ir/exports/news/www.dntips.ir-news-20284.pdf) — مفهوم عمومی vector search، نه راهنمای syntax Redis.
- [یک تمرین/مقالهٔ فارسی دربارهٔ نمایش برداری متن](https://dsp-lab.ir/wp-content/uploads/2022/11/ML-NLP-HW2-IR-1401-1.pdf) — مبانی بردارسازی متون؛ نه Redis Vector Set.
- [آموزش فارسی Redis در SalamLang](https://www.salamlang.ir/std/db/redis/) — مبانی Redis؛ قابلیت Vector Sets/Arrays جدید را کامل پوشش نمی‌دهد.
- [جست‌وجوی فارسی Vector Search و embedding](https://www.google.com/search?q=آموزش+فارسی+جستجوی+برداری+Vector+Search+embedding+Redis).
- [جست‌وجوی فارسی Redis Arrays](https://www.google.com/search?q=Redis+Arrays+8.8+آموزش+فارسی).

برای topicهای تازه، پوشش فارسی Redis محدود است؛ توضیح و تمرین همین درس برای یادگیری پایه و میانی طراحی شده و منابع فارسی فقط مکمل مفهوم عمومی‌اند. جزئیات command/نسخه را از مستند رسمی همان endpoint بگیر.

</div>
