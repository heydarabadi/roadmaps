# فصل 05: کنترل نتایج و نگهداری داده / Controlling Search Results

[English version](README.en.md)


## درس فصل
پاسخ search را برای UI کنترل کنید: sort پایدار، فیلدهای لازم، highlight و pagination. from/size برای صفحه‌ی کم‌عمق مناسب است؛ search_after با sort یکتا برای پیمایش عمیق مناسب‌تر است و PIT برای دید پایدار مفید است. Scroll را برای export batch در نظر بگیرید. match متن را تحلیل می‌کند؛ term مقدار دقیق را می‌سنجد. wildcard و prefix ممکن است پرهزینه باشند. Reindex را migration بدانید: صحت، شمارش، تغییر همزمان، alias cutover و برگشت را بسنجید. Update/Delete by Query شرط و پایش task می‌خواهند.

## تمرین فصل
نتایج کاتالوگ را با match، filter، sort، highlight و search_after طراحی کن.

## تدریس کامل فصل: از سؤال کاربر تا نتیجهٔ پایدار

### ۱) پاسخ Search را چگونه بخوانیم؟
در درخواست _search، query مجموعهٔ سندهای واجد شرایط و score رتبه‌بندی را تعیین می‌کند. پاسخ معمولاً شامل took، timed_out، _shards و hits است. took زمان پردازش گزارش‌شده در کلاستر است و کل زمان تجربهٔ کاربر را با شبکه و برنامه اندازه نمی‌گیرد. hits.total ممکن است دقیق یا با relation برابر gte کران‌دار باشد؛ tracking تعداد دقیق hitها هزینه دارد. پیش از نمایش صفحه، بررسی کن timed_out=false باشد و خطاهای shard پنهان نمانده باشند.

~~~http
POST /products-v1/_search
{"track_total_hits":true,"size":2,"query":{"match":{"title":"هدفون بی‌سیم"}},"sort":[{"_score":"desc"},{"product_id":"asc"}],"_source":["product_id","title","price","available"]}
~~~
در مثال، match متن عنوان را تحلیل می‌کند، size تعداد hitها را محدود می‌کند، sort ترتیب را تعیین می‌کند و source filtering فقط فیلدهای لازم UI را می‌گیرد. فیلد یکتای product_id در sort ترتیب دو hit با score برابر را پایدار می‌کند.

### ۲) صفحه‌بندی کم‌عمق و عمیق
from/size برای صفحه‌های ابتدایی ساده است، اما هر shard باید نامزدهای لازم تا from+size را نگه دارد؛ offset بزرگ کار و حافظه بیشتری مصرف می‌کند و max_result_window جلوی صفحه‌بندی خیلی عمیق را می‌گیرد. برای پیمایش عمیق تعاملی از sort پایدار و search_after استفاده کن و sort values آخرین hit را به درخواست بعدی بده. اگر داده حین پیمایش تغییر می‌کند، Point In Time (PIT) نمای ثابتی فراهم می‌کند. PIT را کوتاه‌مدت نگه دار و پس از پایان ببند. Scroll برای export دسته‌ای/پردازش مناسب است، نه الگوی معمول UI.

~~~http
POST /products-v1/_pit?keep_alive=1m
POST /_search
{"pit":{"id":"<PIT_ID>","keep_alive":"1m"},"size":2,"query":{"match_all":{}},"sort":[{"product_id":"asc"}],"search_after":["sku-002"]}
~~~
در پاسخ، آرایهٔ sort آخرین hit را عیناً به درخواست بعدی منتقل کن. اگر پاسخ PIT ID تازه داد، شناسهٔ تازه را نگه‌دار. query و sort نباید در صفحات عوض شوند؛ برای نتیجهٔ قطعی از tie-breaker یکتا استفاده کن و به ترتیب داخلی Lucene تکیه نکن.

### ۳) Query، sort و فیلدهای نمایشی
match متن تحلیل‌شونده را با analyzer جست‌وجو می‌کند؛ term برای مقدار دقیق روی keyword، شناسه، Boolean یا عدد است؛ range برای بازهٔ عدد/تاریخ و exists برای وجود مقدار مناسب است. Prefix و wildcard را با شناخت هزینه استفاده کن؛ الگوی wildcard آغازشونده با ستاره ممکن است termهای زیادی را بکاود. برای sort و aggregation معمولاً keyword/numeric/date دارای doc values انتخاب می‌شود. روی text، به‌جای fielddata یک multi-field از نوع keyword تعریف کن.

Highlighting snippetهایی را که به query مرتبط‌اند علامت می‌زند؛ خودش اثبات relevance نیست و ممکن است همهٔ matchها را نشان ندهد. متن ورودی به HTML را escape کن. اندازهٔ snippet، تعداد fragmentها و هزینهٔ آن را بسنج.

### ۴) تغییر schema با Reindex
Mapping فیلد موجود را همیشه نمی‌توان آزادانه عوض کرد. برای مهاجرت، مقصد تازه با mapping/settings درست بساز؛ از منبع به مقصد _reindex کن؛ شمارش، نمونه‌سندها، خطاها و queryها را بسنج؛ نوشتن همزمان را با replay/dual-write یا پنجرهٔ کنترل‌شده sync کن؛ سپس alias را جابه‌جا و rollback را آماده کن. _reindex تغییرات بعدی منبع را خودکار دنبال نمی‌کند. Update/Delete by Query هم task چندسندی‌اند؛ version conflict، throttling، cancel و poll کردن task را مدیریت کن.

~~~http
POST /_reindex
{"source":{"index":"products-v1"},"dest":{"index":"products-v2"}}
~~~
نتیجه را فقط با تعداد نسنج: mapping، نسخهٔ سند، اسناد ردشده و چند جست‌وجوی کسب‌وکاری را هم بررسی کن. هنگام cutover همهٔ نویسنده‌ها و retryها را در نظر بگیر.

### کارگاه پایان فصل
روی کالاها سه صفحهٔ اول را با sort یکتا بساز؛ سپس نسخهٔ عمیق را با PIT و search_after پیاده کن. انتظار: صفحهٔ اول sort values می‌دهد؛ صفحهٔ بعد همان query/sort و مقادیر آخرین hit را می‌فرستد؛ PIT دید ثابت‌تری از index می‌دهد. در آزمایش دوم، index مقصد را با mapping جدید بساز، reindex کن، شمارش و نمونه‌سندها را مقایسه و پس از تأیید alias را عوض کن.

### خودآزمایی با پاسخ تشریحی
1. چرا from=50000,size=20 مناسب نیست؟ چون shardها نامزدهای offset قبلی را هم پردازش می‌کنند؛ search_after برای عبور عمیق مناسب‌تر است.
2. چرا sort به tie-breaker نیاز دارد؟ score یا تاریخ ممکن است برابر باشند؛ فیلد یکتا ترتیب را قطعی می‌کند.
3. آیا _reindex به‌تنهایی cutover امن است؟ خیر؛ نوشتن‌های همزمان را دنبال نمی‌کند، پس sync و برگشت لازم است.
4. آیا replica backup است؟ خیر؛ حذف اشتباه به replica هم می‌رسد؛ snapshot قابل‌بازیابی را جداگانه طراحی کن.

### مطالعهٔ موردی و سنجه‌ها
فروشگاه برای جست‌وجوی تعاملی به latency کم و صفحه‌بندی پایدار نیاز دارد؛ export موجودی نیز باید تمام داده را به batch بخواند. برای این دو workload، روش یکسان انتخاب نکن. latency، timeout، shard failure، حجم پاسخ و کیفیت صفحه‌های بعدی را اندازه بگیر. مهاجرت نسخهٔ index با alias برگشت سریع‌تری می‌دهد، ولی backup محسوب نمی‌شود.

## موضوع‌های این فصل
- [Controlling Search Results](topics/01-controlling-search-results/README.md) · [English](topics/01-controlling-search-results/README.en.md)
- [Pagination](topics/02-pagination/README.md) · [English](topics/02-pagination/README.en.md)
- [Sorting](topics/03-sorting/README.md) · [English](topics/03-sorting/README.en.md)
- [Source Filtering](topics/04-source-filtering/README.md) · [English](topics/04-source-filtering/README.en.md)
- [Highlighting](topics/05-highlighting/README.md) · [English](topics/05-highlighting/README.en.md)
- [Match Query](topics/06-match-query/README.md) · [English](topics/06-match-query/README.en.md)
- [Term Query](topics/07-term-query/README.md) · [English](topics/07-term-query/README.en.md)
- [Range Query](topics/08-range-query/README.md) · [English](topics/08-range-query/README.en.md)
- [Exists Query](topics/09-exists-query/README.md) · [English](topics/09-exists-query/README.en.md)
- [ID Query](topics/10-id-query/README.md) · [English](topics/10-id-query/README.en.md)
- [Prefix Query](topics/11-prefix-query/README.md) · [English](topics/11-prefix-query/README.en.md)
- [Wildcard Query](topics/12-wildcard-query/README.md) · [English](topics/12-wildcard-query/README.en.md)
- [Reindex API](topics/13-reindex-api/README.md) · [English](topics/13-reindex-api/README.en.md)
- [Update by Query](topics/14-update-by-query/README.md) · [English](topics/14-update-by-query/README.en.md)
- [Delete by Query](topics/15-delete-by-query/README.md) · [English](topics/15-delete-by-query/README.en.md)

## منابع
- [مستند رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- [Reference کامل Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Roadmap](https://roadmap.sh/elasticsearch)

