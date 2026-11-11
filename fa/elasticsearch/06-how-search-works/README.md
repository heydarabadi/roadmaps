# فصل 06: چگونه جست‌وجو کار می‌کند / How Search Works

[English version](../../../en/elasticsearch/06-how-search-works/README.md)


## درس فصل
Search analyzer متن query را به token تبدیل می‌کند؛ coordinator درخواست را به shardها می‌فرستد، هر shard candidate و score می‌سازد و coordinator نتیجه‌ها را reduce می‌کند. latency به fan-out، queue، شبکه و reduce وابسته است. Bool query: must الزامی و scoring؛ should تطبیق/boost کمکی و گاهی الزامی؛ filter شرط بدون score؛ must_not حذف. minimum_should_match رفتار should را روشن می‌کند. Explain برای سند مشخص و Profile برای تحلیل هدفمند مفیدند. relevance را با query-judgment dataset و NDCG@k، MRR یا Recall@k بسنجید.

## تمرین فصل
عنوان را must، قیمت را filter، نام جایگزین را should و کالای پنهان را must_not کن.

## تدریس کامل فصل: مسیر یک درخواست جست‌وجو

### ۱) از متن ورودی تا سندهای نامزد
هنگام index کردن title از analyzer زمان index می‌گذرد: character filterهای اختیاری متن را پیش‌پردازش می‌کنند؛ tokenizer آن را به token می‌شکند؛ token filterها آن‌ها را normalize یا تبدیل می‌کنند. زمان search هم search analyzer ورودی کاربر را تحلیل می‌کند. ناسازگاری این دو مسیر می‌تواند سند را غیرقابل‌یافتن کند. Analyze API tokenها را نشان می‌دهد. در فارسی، ی/ک عربی و فارسی، نیم‌فاصله، اعداد و شکل نوشتاری را با دادهٔ خودت آزمایش کن.

### ۲) fan-out و جمع‌آوری نتیجه
یک node درخواست را می‌پذیرد و معمولاً نقش coordinator دارد. درخواست به shardهای هدف fan-out می‌شود؛ هر shard query را محلی اجرا می‌کند و candidateها، scoreها و aggregationهای جزئی را می‌سازد؛ coordinator پاسخ‌ها را merge/reduce و مرتب می‌کند. تعداد shardهای هدف، صف thread pool، CPU/heap، شبکه، تعداد hitها، sort و aggregation بر latency اثر می‌گذارند. took زمان داخل کلاستر است، نه کل زمان client.

Search در Elasticsearch نزدیک به real-time است: refresh باعث قابل‌جست‌وجو شدن segmentهای جدید می‌شود؛ پس write موفق و Search بلافاصله همیشه یک مشاهدهٔ همسان نیستند. Get by ID مسیر متفاوتی دارد. برای read-after-write راهکار متناسب با نیاز مانند refresh=wait_for را محدود و آگاهانه به‌کار ببر؛ refresh در هر write می‌تواند فشار را زیاد کند.

### ۳) Bool query را با معنا بساز
must شرط لازم و scoring است؛ should می‌تواند نتیجه را امتیاز دهد و بسته به وجود must/filter یا minimum_should_match الزامی می‌شود؛ filter شرط لازم بدون relevance score است و برای term/range ساخت‌یافته مناسب است؛ must_not نتیجهٔ مطابق را حذف می‌کند. متن عنوان و توضیح معمولاً score می‌سازند؛ قیمت، موجودی و دسترسی باید candidateها را محدود کنند، نه اینکه relevance را بالا ببرند.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":{"query":"هدفون بلوتوثی","operator":"and"}}],"should":[{"match":{"brand":"آوا"}}],"minimum_should_match":0,"filter":[{"range":{"price":{"lte":5000000}}},{"term":{"available":true}}],"must_not":[{"term":{"status":"hidden"}}]}}}
~~~
تفسیر: همهٔ واژه‌های عنوان باید match شوند؛ برند آوا امتیاز اضافه می‌دهد ولی اجباری نیست؛ قیمت و موجودی فیلتر می‌شوند؛ کالای hidden حذف می‌شود. از خود بپرس «این شرط قبولی است یا ترجیح رتبه‌بندی؟»

### ۴) relevance را اندازه بگیر
_score احتمال درست‌بودن نیست؛ فقط امتیاز رتبه‌بندی در زمینهٔ query است. Explain برای یک سند نشان می‌دهد اجزای query چگونه در score سهم دارند. Profile breakdown زمان/بخش‌های اجرای query را برای عیب‌یابی می‌دهد، ولی سربار دارد و نباید بی‌هدف روی همهٔ درخواست‌های تولیدی روشن باشد. کیفیت را با queryهای نماینده و قضاوت انسانی بسنج: MRR جایگاه اولین نتیجهٔ مرتبط، Recall@k پوشش نتیجه‌های مرتبط در k نتیجه و NDCG@k ترتیب graded relevance را می‌سنجد. قبل و بعد را روی همان مجموعه مقایسه کن.

### تمرین و جواب مورد انتظار
سه کالا با عنوان «هدفون بی‌سیم آوا»، «هدفون سیمی آوا» و «اسپیکر بی‌سیم» بساز. query بالا باید نتایج عنوان مرتبط را نگه دارد؛ قیمت/موجودی قبولی را تعیین کنند؛ برند فقط رتبه را بهتر کند؛ status مخفی حذف شود. سپس filter را به must منتقل و با Explain مقایسه کن: ممکن است مجموعهٔ hitها تغییر نکند ولی شرط ساخت‌یافته وارد محاسبهٔ score شده باشد.

### خودآزمایی با پاسخ تشریحی
1. چرا قیمت را در filter می‌گذاریم؟ چون شرط ساخت‌یافتهٔ قبولی است و نباید relevance را افزایش دهد.
2. آیا should همیشه اجباری است؟ خیر؛ رفتار پیش‌فرض به وجود must/filter وابسته است؛ intent را با minimum_should_match صریح کن.
3. Profile را چه وقت استفاده می‌کنی؟ برای تشخیص هزینهٔ اجزای query در بازتولید کنترل‌شده؛ خود profiling سربار دارد.
4. refresh فوری چه بهایی دارد؟ تازگی زودتر، ولی هزینهٔ refresh و ساخت/ادغام segment بیشتر؛ فقط با الزام freshness.

### سناریوی واقعی قابل انتقال
در کاتالوگ، واژهٔ کالا relevance می‌سازد اما قیمت، موجودی، دسته‌بندی و مجوز دسترسی باید candidateها را محدود کنند. این جداسازی از بالا و پایین شدن بی‌دلیل score با تغییر سیاست موجودی جلوگیری می‌کند. مجموعه‌ای از جست‌وجوهای واقعی بساز و رتبهٔ مطلوب را برای هرکدام ثبت کن.

## موضوع‌های این فصل
- [How Search Works](topics/01-how-search-works/README.md) · [English](topics/01-how-search-works/README.en.md)
- [must](topics/02-must/README.md) · [English](topics/02-must/README.en.md)
- [should](topics/03-should/README.md) · [English](topics/03-should/README.en.md)
- [filter](topics/04-filter/README.md) · [English](topics/04-filter/README.en.md)
- [must_not](topics/05-must-not/README.md) · [English](topics/05-must-not/README.en.md)

## منابع
- [مستند رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- [Reference کامل Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/)
- [Roadmap](https://roadmap.sh/elasticsearch)

