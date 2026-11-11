# فصل 07: تحلیل، تجمیع و عملیات تولید / Search Analyzer

[English version](../../../en/elasticsearch/07-analysis-analytics-and-production/README.md)


## درس فصل
Analyzer از character filter، tokenizer و token filter ساخته می‌شود و سمت index/search باید سازگار باشد. Analyze API خروجی را نشان می‌دهد؛ فارسی را با نیم‌فاصله، ی/ک و اعداد واقعی بسنجید. Inverted index از term به سند می‌رسد. Doc values برای sort/aggregation است؛ fielddata روی text می‌تواند RAM‌بر باشد. Aggregationها metric، bucket و pipeline دارند؛ cardinality تخمینی است. Transform نمایه‌ی خلاصه می‌سازد. BM25 baseline lexical است؛ vector/semantic و hybrid retrieval را با relevance بسنجید. ILM، rollover و tiers چرخه‌ی عمرند؛ snapshot/restore، SLM، CCR و replica کاربردهای متفاوت دارند. امنیت شامل TLS، authentication، role محدود و API key است. Monitoring باید heap، disk، rejected request و shard را پوشش دهد.

## تمرین فصل
متن فارسی را analyze کن، aggregation و ranking را بسنج و runbook امنیت/backup بنویس.

## تدریس کامل فصل: از متن خام تا سرویس عملیاتی

### بخش A — تحلیل متن و ساختمان ایندکس جست‌وجو

#### Analyzer و tokenها
مقدار فیلد text پیش از ثبت در ساختار جست‌وجو تحلیل می‌شود. زنجیرهٔ analyzer سه گام مفهومی دارد: character filter ممکن است HTML یا شکل ورودی را پاک‌سازی کند؛ tokenizer رشته را به token و offset می‌شکند؛ token filter حروف را normalize، lowercase، حذف یا گسترش می‌دهد. analyzer زمان index تعیین می‌کند چه tokenهایی به inverted index برسند؛ search analyzer ورودی query را به tokenهای قابل‌تطبیق تبدیل می‌کند. اغلب این دو باید از نظر قواعد متن سازگار باشند، هرچند search_analyzer می‌تواند متفاوت باشد.

برای تحلیل زبان، فقط اسم زبان را در تنظیمات انتخاب نکن. نمونهٔ واقعی از متن، نیم‌فاصله، نشانه‌گذاری، ی/ک متفاوت، اعداد فارسی/عربی/لاتین، واژه‌های ترکیبی و نام برند بساز و خروجی Analyze API را با انتظار محصول مقایسه کن. تغییر analyzer برای دادهٔ موجود معمولاً نیازمند ساخت index تازه و reindex است؛ تنظیم analysis را پیش از ingest و بر مبنای آزمون طراحی کن.

~~~http
POST /products-v1/_analyze
{"analyzer":"standard","text":"هدفون‌های بی‌سیم، مدل X-200"}
~~~
خروجی را از لحاظ token، position و offset بخوان. اگر اصطلاحی که باید match شود به tokenهای غیرمنتظره تبدیل شده، مشکل را قبل از تولید Query DSL حل کن. Standard Analyzer نقطهٔ شروع عمومی است، نه تضمین‌کنندهٔ کیفیت فارسی یا هر domain خاص.

#### Inverted index، doc values و fielddata
Inverted index نگاشت term به فهرست سندها/موقعیت‌هاست و جست‌وجوی متن را سریع می‌کند. این ساختمان برای یافتن سند از واژه مناسب است، اما به‌تنهایی برای مرتب‌سازی و گروه‌بندی روی مقدار اصلی طراحی نشده. Doc values نمایش ستونی و عمدتاً روی disk برای sort، aggregation و دسترسی ساخت‌یافته فراهم می‌کند. text معمولاً doc values ندارد؛ fielddata می‌تواند مقدارهای text را در heap بارگذاری کند و برای فیلدهای پرکاردینالیتی فشار شدید بسازد. راه رایج برای هم جست‌وجوی متن و هم sort/aggregation، multi-field است: title از نوع text و title.keyword از نوع keyword.

~~~http
PUT /products-v1
{"mappings":{"properties":{"title":{"type":"text","fields":{"keyword":{"type":"keyword"}}},"price":{"type":"long"},"brand":{"type":"keyword"}}}}
~~~
بعداً روی title match بزن؛ روی title.keyword sort یا terms aggregation انجام بده. keyword برای string کامل و مقدار دقیق است، نه تحلیل واژه به واژه. فیلدهای خیلی بزرگ یا بسیار متنوع را بی‌محابا keyword نکن، چون cardinality و اندازهٔ index بالا می‌رود.

### بخش B — aggregation و تحلیل کسب‌وکار

#### Metric، bucket و pipeline
Metric aggregation عددهای خلاصه مانند value_count، avg، sum، min، max، stats و extended_stats می‌سازد. Bucket aggregation سندها را به گروه‌هایی مثل terms، range، date_range و histogram تقسیم می‌کند. Pipeline aggregation خروجی aggregationهای دیگر را می‌گیرد، مثلاً مشتق یا جمع تجمعی. اول query یا filter را برای محدودهٔ سندهای مورد تحلیل مشخص کن؛ aggregation به‌طور پیش‌فرض روی مجموعهٔ سندهای matchشده اجرا می‌شود. پاسخ را از مسیر aggregations بخوان؛ به hits محدود نگاه نکن.

~~~http
POST /products-v1/_search
{"size":0,"query":{"term":{"available":true}},"aggs":{"by_brand":{"terms":{"field":"brand","size":10}},"price_stats":{"stats":{"field":"price"}},"price_ranges":{"range":{"field":"price","ranges":[{"to":2000000},{"from":2000000,"to":5000000},{"from":5000000}]}}}}
~~~
size=0 می‌گوید hitهای سندی را لازم نداریم؛ نتیجهٔ مورد استفاده، aggregationها هستند. terms روی keyword قرار می‌گیرد و فقط bucketهای اول را برمی‌گرداند؛ برای گروه‌های بسیار پرکاردینالیتی، top-N، shard_size و هزینه را آگاهانه تنظیم کن. عدد cardinality معمولاً با الگوریتم تخمینی HyperLogLog++ محاسبه می‌شود: برای dashboard یکتاهای تقریبی سودمند است، ولی برای حسابداری دقیق روی آن تکیه نکن.

Value_count تعداد valueها را می‌شمارد (برای آرایه بیش از یک مقدار در یک سند می‌تواند چند بار شمرده شود)، نه لزوماً تعداد سندهای یکتا. Avg میانگین مقدارهای موجود را می‌دهد، نه لزوماً میانگین همهٔ سندها. missing valueها را در تفسیر نتیجه در نظر بگیر. Nested aggregation برای فیلدهای nested باید وارد nested path شود؛ خروجی nested در واحد child object است و برای شمارش parentها ممکن است reverse_nested لازم باشد.

#### Transform، Pivot و Latest
Transform یک نمای تحلیلی/summary index از دادهٔ خام می‌سازد. Pivot سندها را بر اساس group-by و aggregationها به ردیف‌های خلاصه تبدیل می‌کند؛ latest برای نگه‌داشتن آخرین سند بر اساس کلید و زمان مناسب است. Continuous transform تغییرات را دوره‌ای دنبال می‌کند، پس sync delay و checkpoint را بفهم. خروجی transform مشتق‌شده است؛ منبع خام را حفظ کن و تعداد رکورد، lag، خطا و صحت گروه‌بندی را کنترل کن.

### بخش C — similarity و رتبه‌بندی

#### BM25 و similarity
برای full-text lexical، BM25 از تطبیق اصطلاح، تعداد تکرار اصطلاح، کمیابی term در مجموعهٔ سندها و طول سند استفاده می‌کند. تکرار بیشتر یک واژه معمولاً اثر مثبت دارد اما بازده آن کاهنده است؛ واژه‌ای که در سندهای زیادی هست کمتر تمایز می‌دهد؛ سند خیلی بلند در برابر متن کوتاه جریمهٔ نرمال‌سازی می‌گیرد. score وابسته به query و آمار index است و probability نیست. تغییر k1/b یا similarity را با دادهٔ ارزیابی بسنج؛ تنظیم آن به‌تنهایی synonym، analyzer یا کیفیت محتوا را جایگزین نمی‌کند.

match_phrase برای واژه‌هایی می‌خواهد که در ترتیب و فاصلهٔ مجاز کنار هم باشند؛ slop اجازهٔ جابه‌جایی/فاصله را محدود می‌کند و افزایش آن recall را بالا و precision را ممکن است پایین بیاورد. Boosting query با positive و negative clause نتیجهٔ دارای negative match را صرفاً به اندازهٔ negative_boost تنبیه می‌کند، نه اینکه حذف کند. boost، function_score و decay function برای business signals مثل محبوبیت یا تازگی استفاده می‌شوند؛ امتیاز را سقف/نرمال و با relevance بررسی کن تا محبوبیت، تطبیق متنی را نبلعد.

#### بردار، semantic و hybrid search
Vector search بردار query را با بردارهای ذخیره‌شده بر اساس similarity مقایسه می‌کند. مدل embedding، نسخه/ابعاد، preprocessing، زبان و metric باید بین ingest و query سازگار باشند. k تعداد نتیجهٔ بازگردانده‌شده و num_candidates شمار candidateهای اولیه برای approximate kNN است؛ candidate بیشتر معمولاً recall را بالا و هزینه/latency را افزایش می‌دهد. ارزیابی را با queryهای واقعی و relevance labels انجام بده، نه با چند نمونهٔ خوش‌شانس.

Semantic search می‌کوشد معنا و intent را بازیابی کند، اما به مدل و pipeline تولید embedding وابسته است؛ هزینهٔ inference، زبان فارسی، domain drift و به‌روزرسانی مدل را حساب کن. Hybrid search پاسخ‌های lexical و vector را ترکیب می‌کند. چون مقیاس scoreها یکی نیست، جمع سادهٔ scoreها می‌تواند یک مسیر را غالب کند؛ Reciprocal Rank Fusion بر پایهٔ rankها ترکیب می‌کند. کیفیت lexical، semantic و hybrid را جداگانه و سپس ترکیبی بسنج. Search approaches رسمی Elastic نیز توصیه می‌کند از lexical شروع کنی و پیچیدگی را وقتی نیاز اثبات شد اضافه کنی.

~~~http
POST /products-v1/_search
{"knn":{"field":"embedding","query_vector":[0.12,0.08,0.31],"k":10,"num_candidates":100},"_source":["product_id","title"]}
~~~
این بردار کوچک فقط شکل درخواست را نشان می‌دهد و برای محصول واقعی باید ابعاد mapping با خروجی مدل برابر باشد. کیفیت مدل را با query set و معیارهایی مانند Recall@k یا NDCG ارزیابی کن. Hybrid را با filterهای یکسان مقایسه کن تا تفاوت فقط در retrieval باشد.

### بخش D — segment، پایش و دسترس‌پذیری

#### Segment و عملیات نگهداری
Lucene هر shard را در segmentهای immutable نگه می‌دارد. refresh segment تازه را برای search در دسترس می‌گذارد؛ flush/commit وضعیت را پایدار می‌کند؛ merge در پس‌زمینه segmentهای کوچک‌تر را ادغام و فضای حذف‌شده را آزاد می‌کند. refresh مکرر segmentهای زیادی می‌سازد و merge، CPU و disk را مصرف می‌کند. force merge ابزار routine برای index فعال پرتغییر نیست؛ برای indexهای read-only/آرشیوی و با فهم هزینهٔ I/O/فضای موقت بررسی می‌شود.

CAT API برای مشاهدهٔ سریع انسان‌خوانِ shardها، indexها و allocationها مناسب است؛ برای automation پایدار از APIهای JSON و شاخص‌های Monitoring استفاده کن، چون CAT خروجی جدولی و برای scripting شکننده‌تر است. سلامت cluster، تعداد shard، heap، فشار indexing/search، rejection، disk watermarks، زمان GC، latency صدک‌ها، نرخ خطا و روند snapshot را روی داشبورد ثبت کن. status سبز به‌تنهایی معیار خوب‌بودن latency یا کیفیت نتیجه نیست.

#### Cross-cluster replication، autoscaling و data tiers
CCR از leader به follower تغییرات را replication می‌کند و برای توزیع/بازیابی سناریوهای مشخص مفید است؛ replica shard در همان cluster فقط کپی محلی است، snapshot backup قابل‌بازیابی است و CCR نیز جای تمرین disaster recovery را نمی‌گیرد. latency شبکه، عقب‌ماندگی follower، مجوزهای cross-cluster و رفتار promotion/failover را مانیتور کن.

Autoscaling ظرفیت را بر اساس نیاز و محدودیت platform بالا/پایین می‌برد؛ جای sizing و مراقبت از shard بزرگ، query نامناسب یا دیسک رو به اتمام نیست. Data tiers بر اساس هزینه و الگوی دسترسی (hot/warm/cold/frozen در topologyهای پشتیبانی‌شده) داده را جاگذاری می‌کنند. انتقال tier، replica، searchable snapshot و محدودیت feature/نسخه را با نیاز restore و latency بسنج.

### بخش E — چرخهٔ عمر و backup

#### ILM و rollover
ILM policy transitionهای lifecycle را به مرحله‌هایی مانند hot، warm، cold و delete متصل می‌کند؛ actionها و نام tierها بسته به نسخه/نوع deployment فرق می‌کند. Rollover روی alias یا data stream با شرط‌هایی مثل اندازه، سن یا تعداد سند index write را به backing index تازه می‌برد. policy فقط وقتی درست کار می‌کند که index template، alias/data stream و rollover alias درست باشند. آستانهٔ خیلی کوچک shardهای فراوان می‌سازد؛ آستانهٔ خیلی بزرگ recovery و merge را سخت می‌کند. اجرای policy و explain API را ببین و age را بر اساس rollover index مبنا قرار بده، نه فرض دربارهٔ عمر هر سند.

#### Snapshot و SLM
Snapshot backup از کلاستر فعال بدون توقف طولانی است و می‌تواند data و feature stateهای پشتیبانی‌شده را حفظ کند؛ repository باید جداگانه ثبت شود و خود repository را حذف/overwrite نکن. replica یا reindex جای snapshot نیستند. SLM policy زمان‌بندی snapshot، نگهداری/حذف snapshot قدیمی و مانیتور وضعیت را خودکار می‌کند. تنها پیام success کافی نیست: restore را روی مقصد/محیط جدا تمرین کن، نسخه‌ها و compatibility را بررسی کن و زمان بازیابی/دادهٔ از‌دست‌رفتهٔ قابل‌قبول (RTO/RPO) را ثبت کن.

### بخش F — امنیت و دسترسی

Authentication هویت درخواست‌دهنده را ثابت می‌کند؛ authorization تعیین می‌کند چه داده و عملیاتی مجاز است. امنیت را در production خاموش نکن و cluster را به شبکهٔ عمومی باز نگذار. ارتباط‌ها را با TLS، دسترسی را با roleهای حداقلی و رمز/secret را در secret manager نگه‌دار. User برای هویت انسانی/سرویس، role برای privilegeها، و API key برای دسترسی برنامه‌ای محدود و قابل‌تعویض است. کلید را در کد/مخزن قرار نده، انقضا و rotation تعریف کن، دسترسی را به indexها و actionهای موردنیاز محدود و کلید افشاشده را revoke کن.

~~~http
POST /_security/role/catalog_reader
{"indices":[{"names":["products-*"],"privileges":["read","view_index_metadata"]}]}
POST /_security/user/catalog_app
{"password":"<از secret manager>","roles":["catalog_reader"],"full_name":"Catalog service"}
~~~
نام role نمونه است؛ در deployment واقعی authentication realm، license و مجوز APIهای امنیتی را بررسی کن. privilege cluster-wide به نویسندهٔ query برنامه نده، مگر نیاز روشن داشته باشی.

### کارگاه نهایی فصل
1. از چند متن فارسی Analyze API بگیر و tokenهای مورد انتظار را بنویس. 2. title را text+keyword و price را عددی mapping کن. 3. با size=0، terms/avg/range aggregation بساز و توضیح بده هر عدد کدام جمعیت سند را می‌سنجد. 4. lexical، vector و hybrid را روی فهرست قضاوت‌شده مقایسه کن. 5. سناریوی rollover و ILM برای دادهٔ رخداد تعریف کن. 6. snapshot بگیر و restore را روی مقصد امن تمرین کن. 7. role فقط‌خواندنی و API key محدود بساز و چرخش دسترسی را مستند کن.

### پاسخ‌های کلیدی آزمون فصل
- چرا text را مستقیم sort نمی‌کنیم؟ چون text برای full-text analysis است؛ keyword multi-field و doc values برای sort/aggregation مناسب‌ترند.
- cardinality exact است؟ معمولاً تخمینی است؛ برای شمارش دقیق مالی آن را جایگزین منبع حقیقت نکن.
- score BM25 probability است؟ خیر، امتیاز نسبی رتبه‌بندی در زمینهٔ query/index است.
- snapshot چه چیزی را ثابت می‌کند؟ نسخهٔ بازیابی‌شدنی داده/feature state را؛ موفقیتش زمانی اثبات می‌شود که restore دوره‌ای انجام شود.
- semantic search لزوماً بهتر است؟ خیر؛ معیار، هزینه و مجموعهٔ ارزیابی تصمیم می‌دهند؛ hybrid وقتی واژگان دقیق و معنا هر دو مهم‌اند بررسی می‌شود.
- SLM با ILM یکی است؟ خیر؛ SLM snapshot policy را مدیریت می‌کند، ILM چرخهٔ عمر index/data stream را.

### نمونه‌های واقعی صنعت
Elastic برای Anyone گزارش کرده ۲۱۰ میلیون رکورد را از PostgreSQL در حدود یک‌ونیم هفته منتقل کرده‌اند؛ این نشان می‌دهد انتقال داده به search engine تصمیم معماری و migration plan می‌خواهد، نه صرفاً یک index کردن ساده. در Canals، ترکیب lexical و vector/sparse-dense retrieval در گزارش مشتری با بهبود دقت top-3 از ۶۳٪ به ۹۶٪ همراه بوده است؛ این نتیجهٔ موردی تضمین عمومی نیست و باید با corpus و queryهای خودت بازآزمایی شود. لینک‌ها در فایل مطالعات موردی با زمینه و محدودیت گزارش آمده‌اند.

## موضوع‌های این فصل
- [Search Analyzer](topics/01-search-analyzer/README.md) · [English](topics/01-search-analyzer/README.en.md)
- [Doc values](topics/02-doc-values/README.md) · [English](topics/02-doc-values/README.en.md)
- [fielddata](topics/03-fielddata/README.md) · [English](topics/03-fielddata/README.en.md)
- [The Inverted Index](topics/04-the-inverted-index/README.md) · [English](topics/04-the-inverted-index/README.en.md)
- [The Analyze API](topics/05-the-analyze-api/README.md) · [English](topics/05-the-analyze-api/README.en.md)
- [Standard Analyzer](topics/06-standard-analyzer/README.md) · [English](topics/06-standard-analyzer/README.en.md)
- [Custom Analyzers](topics/07-custom-analyzers/README.md) · [English](topics/07-custom-analyzers/README.en.md)
- [Value Count](topics/08-value-count/README.md) · [English](topics/08-value-count/README.en.md)
- [Avg / Sum / Min / Max](topics/09-avg-sum-min-max/README.md) · [English](topics/09-avg-sum-min-max/README.en.md)
- [Cardinality](topics/10-cardinality/README.md) · [English](topics/10-cardinality/README.en.md)
- [Stats / Extended Stats](topics/11-stats-extended-stats/README.md) · [English](topics/11-stats-extended-stats/README.en.md)
- [Terms](topics/12-terms/README.md) · [English](topics/12-terms/README.en.md)
- [Range / Date Range](topics/13-range-date-range/README.md) · [English](topics/13-range-date-range/README.en.md)
- [Histogram](topics/14-histogram/README.md) · [English](topics/14-histogram/README.en.md)
- [Filter Aggregations](topics/15-filter-aggregations/README.md) · [English](topics/15-filter-aggregations/README.en.md)
- [Pivot](topics/16-pivot/README.md) · [English](topics/16-pivot/README.en.md)
- [Latest](topics/17-latest/README.md) · [English](topics/17-latest/README.en.md)
- [Transform API](topics/18-transform-api/README.md) · [English](topics/18-transform-api/README.en.md)
- [Nested Aggregations](topics/19-nested-aggregations/README.md) · [English](topics/19-nested-aggregations/README.en.md)
- [Pipeline Aggregations](topics/20-pipeline-aggregations/README.md) · [English](topics/20-pipeline-aggregations/README.en.md)
- [Understanding Similarity](topics/21-understanding-similarity/README.md) · [English](topics/21-understanding-similarity/README.en.md)
- [BM25 algorithm](topics/22-bm25-algorithm/README.md) · [English](topics/22-bm25-algorithm/README.en.md)
- [CAT API](topics/23-cat-api/README.md) · [English](topics/23-cat-api/README.en.md)
- [Segment Merging](topics/24-segment-merging/README.md) · [English](topics/24-segment-merging/README.en.md)
- [Cluster Monitoring](topics/25-cluster-monitoring/README.md) · [English](topics/25-cluster-monitoring/README.en.md)
- [Cross-cluster Replication](topics/26-cross-cluster-replication/README.md) · [English](topics/26-cross-cluster-replication/README.en.md)
- [Autoscaling](topics/27-autoscaling/README.md) · [English](topics/27-autoscaling/README.en.md)
- [Boosting Queries](topics/28-boosting-queries/README.md) · [English](topics/28-boosting-queries/README.en.md)
- [Function Score Query](topics/29-function-score-query/README.md) · [English](topics/29-function-score-query/README.en.md)
- [Match Phrase Query](topics/30-match-phrase-query/README.md) · [English](topics/30-match-phrase-query/README.en.md)
- [Synonyms Graph](topics/31-synonyms-graph/README.md) · [English](topics/31-synonyms-graph/README.en.md)
- [ILM](topics/32-ilm/README.md) · [English](topics/32-ilm/README.en.md)
- [Rollover Policies](topics/33-rollover-policies/README.md) · [English](topics/33-rollover-policies/README.en.md)
- [Data Tiers](topics/34-data-tiers/README.md) · [English](topics/34-data-tiers/README.en.md)
- [Vector Search](topics/35-vector-search/README.md) · [English](topics/35-vector-search/README.en.md)
- [Semantic Search](topics/36-semantic-search/README.md) · [English](topics/36-semantic-search/README.en.md)
- [Hybrid Search](topics/37-hybrid-search/README.md) · [English](topics/37-hybrid-search/README.en.md)
- [Snapshots & restore](topics/38-snapshots-and-restore/README.md) · [English](topics/38-snapshots-and-restore/README.en.md)
- [SLM](topics/39-slm/README.md) · [English](topics/39-slm/README.en.md)
- [Authentication](topics/40-authentication/README.md) · [English](topics/40-authentication/README.en.md)
- [Roles & Users](topics/41-roles-and-users/README.md) · [English](topics/41-roles-and-users/README.en.md)
- [API Keys](topics/42-api-keys/README.md) · [English](topics/42-api-keys/README.en.md)

## منابع
- [مستند رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- [Reference کامل Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Roadmap](https://roadmap.sh/elasticsearch)

