# فصل 01: مبانی و شناخت / Introduction

[English version](README.en.md)


## درس فصل
Elasticsearch موتور جست‌وجو و تحلیل توزیع‌شده بر پایه‌ی Apache Lucene است. سندها را به شکل JSON می‌گیرد و با HTTP/REST قابل استفاده است. index مجموعه‌ی منطقی اسناد، document یک رکورد و node نمونه‌ی اجرایی است. Search engine برای retrieval متن، ranking و aggregation بهینه است؛ جایگزین خودکار دیتابیس تراکنشی نیست. GET خواندن، PUT ساخت/جایگزینی، POST جست‌وجو یا bulk و DELETE حذف را انجام می‌دهد. ELK به Elasticsearch، Logstash و Kibana اشاره دارد؛ برای هر سامانه لازم نیست هر سه جزء نصب شوند. الگوی متداول، دیتابیس به عنوان منبع حقیقت و Elasticsearch به عنوان نمایه‌ی جست‌وجوی قابل‌بازسازی است.

## تمرین فصل
سه کالا با ID ثابت وارد کن، آن‌ها را با ID بخوان و عنوان را جست‌وجو کن.

## تدریس کامل فصل: یک درخواست از ابتدا تا پاسخ

### مدل mental و واژه‌ها
Elasticsearch یک engine توزیع‌شده برای جست‌وجوی متن/ساخت‌یافته، رتبه‌بندی و تحلیل است که روی Lucene بنا شده. برنامه سندهای JSON را از طریق HTTP می‌فرستد. Index یک مجموعهٔ منطقی با mapping/settings است؛ document یک رکورد؛ shard قسمت قابل‌توزیع یک index؛ node یک process اجرایی عضو cluster است. این واژه‌ها هم‌معنی database/table/row/server نیستند، هرچند برای ذهنیت ابتدایی شباهت‌هایی دارند.

### جریان داده و search
فرض کن محصول «هدفون بی‌سیم» را با قیمت و موجودی وارد می‌کنی. Mapping می‌گوید title متن، price عدد و available Boolean است. سند با ID پایدار روی primary shard قرار می‌گیرد؛ replicaها برای availability/خواندن تکثیر می‌شوند. Analyzer واژه‌ها را token می‌کند و inverted index ارتباط واژه با سند را نگه می‌دارد. بعد از refresh، Search سند را می‌بیند؛ query متن را تحلیل می‌کند و اسناد نامزد را رتبه می‌دهد. Coordinator پاسخ shardها را merge می‌کند و hits را برمی‌گرداند.

~~~http
PUT /products-v1/_doc/sku-101
{"title":"هدفون بی‌سیم آوا","price":4200000,"available":true}
POST /products-v1/_search
{"query":{"match":{"title":"هدفون"}}}
~~~
برای اجرای واقعی ابتدا index و mapping مناسب بساز؛ این مثال روی mapping صریح قابل‌پیش‌بینی‌تر است. نتیجهٔ Search ممکن است تا refresh بعدی دیده نشود. Get by ID و Search دو مسیر متفاوت‌اند.

### Search index کنار منبع حقیقت
قیمت/موجودی/سفارش را معمولاً در سیستم تراکنشی نگه می‌دارند و Elasticsearch projection جست‌وجویی را ارائه می‌کند. CDC، outbox یا job تغییرها را می‌رساند؛ ID پایدار، retry را idempotent می‌کند؛ reconciliation اختلاف را پیدا می‌کند؛ Reindex امکان rebuild می‌دهد. Dual-write بی‌برنامه خطر divergence دارد. برای تصمیم نهایی پرداخت، مجوز یا موجودی لحظه‌ای، منبع حقیقت را بخوان.

### ELK و ابزارها
Elasticsearch داده را index/search می‌کند؛ Logstash یا ingest pipeline داده را parse/transform می‌کند؛ Beats/Elastic Agent جمع‌آوری می‌کند؛ Kibana visualization و Console می‌دهد. برای هر معماری همهٔ اجزا لازم نیست. Kibana Console برای یادگیری و بررسی REST مناسب است؛ درخواست‌های production را در کد/نسخه‌بندی و با client مناسب مدیریت کن.

### کوییز فصل با پاسخ
1. Index و shard چه رابطه‌ای دارند؟ پاسخ: index مجموعهٔ منطقی است و به primary shard تقسیم می‌شود تا داده و کار توزیع شود.
2. چرا یک سند پس از موفقیت write در Search دیده نمی‌شود؟ پاسخ: Search near-real-time است و refresh visibility را فعال می‌کند.
3. چرا پایگاه اصلی و Elasticsearch معمولاً جدا هستند؟ پاسخ: اولی منبع تراکنش و consistency است؛ دومی projection برای retrieval/ranking است و می‌تواند rebuild شود.
4. در query عنوان و قیمت، کدام شرط امتیاز relevance می‌سازد؟ پاسخ: متن عنوان؛ قیمت معمولاً filter eligibility است.
5. retry با ID ثابت چه فایده‌ای دارد؟ پاسخ: از ایجاد رکورد تکراری جلوگیری می‌کند، به شرط semantics صحیح index/create/update.
6. Kibana چیست؟ پاسخ: رابط مشاهده/مدیریت/search و visualization که با Elasticsearch کار می‌کند؛ خود آن نقش search engine را ندارد.

## موضوع‌های این فصل
- [Introduction](topics/01-introduction/README.md) · [English](topics/01-introduction/README.en.md)
- [JSON](topics/02-json/README.md) · [English](topics/02-json/README.en.md)
- [REST API Basics](topics/03-rest-api-basics/README.md) · [English](topics/03-rest-api-basics/README.en.md)
- [Search Engines vs Relational DBs](topics/04-search-engines-vs-relational-dbs/README.md) · [English](topics/04-search-engines-vs-relational-dbs/README.en.md)
- [The ELK Stack](topics/05-the-elk-stack/README.md) · [English](topics/05-the-elk-stack/README.en.md)
- [Elasticsearch Usecases](topics/06-elasticsearch-usecases/README.md) · [English](topics/06-elasticsearch-usecases/README.en.md)

## منابع
- [مستند رسمی فصل](https://www.elastic.co/docs/solutions/search/get-started)
- [Reference کامل Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Roadmap](https://roadmap.sh/elasticsearch)




