# Elasticsearch Usecases

[English version](../../../../../en/elasticsearch/01-foundations/topics/06-elasticsearch-usecases/README.md)


> فصل 01: مبانی و شناخت · درس 06

## هدف این درس
مورد استفاده را از latency، freshness، نوع query، اندازه و هزینه انتخاب کن؛ search، log، metrics و recommendation نیازهای متفاوت دارند.
## تدریس کامل: کاربرد را از مسئله انتخاب کن

نام Elasticsearch نباید قبل از تعریف مسئله پاسخ باشد. اول مشخص کن کاربران چه می‌پرسند، داده چقدر تازه باید باشد، نرخ ورود و query چقدر است، پاسخ چقدر دقیق باید باشد و دیرشدن داده چه پیامدی دارد.

### کاربردهای متداول

**جست‌وجوی سایت و کاتالوگ:** متن، فیلتر، رتبه‌بندی، autocomplete، synonym، highlight و faceting را ترکیب می‌کند. Mapping و analyzer نقش اصلی دارند.
**تحلیل log و observability:** رخدادهای زمان‌دار را برای فیلتر سرویس/سطح/زمان، نمودار، alert و بررسی incident نگه می‌دارد. حجم، retention و data tier مهم می‌شوند.
**جست‌وجوی مکانی:** نزدیک‌ترین شعبه، محدوده‌ی جغرافیایی یا رخدادهای درون polygon را پیدا می‌کند.
**Aggregation:** تعداد، میانگین، بازه، دسته‌بندی و trend را از سندها محاسبه می‌کند.
**Semantic/vector retrieval:** متن را با embedding نمایش می‌دهد تا اسناد هم‌معنا با واژه‌های متفاوت پیدا شوند. کیفیت مدل و ترکیب رتبه‌بندی باید سنجیده شود.

### تصمیم‌گیری با معیار

برای هر کاربرد این موارد را ثبت کن: نرخ read/write، peak همزمانی، latency هدف، freshness، حجم و رشد داده، کیفیت relevance، مدت نگهداری، هزینه‌ی زیرساخت و فرد/تیمی که عملیات را اداره می‌کند. بعد queryهای واقعی و داده‌ی نمونه بساز تا پیش از انتخاب معماری، fit را بسنجی.

اگر مسئله‌ی اصلی تراکنش و constraint است، پایگاه تراکنشی مناسب‌تر است. اگر نیاز فقط key-value ساده است، cache یا DB موجود ممکن است کافی باشد. افزودن Elasticsearch علاوه بر search، مسئولیت schema sync، backup، security، upgrade و monitoring را هم اضافه می‌کند.

### تمرین

برای جست‌وجوی فروشگاه، جست‌وجوی log incident و نزدیک‌ترین تعمیرگاه یک query نمونه، معیار کیفیت، freshness، retention و failure mode بنویس. مشخص کن کدام داده از کجا قابل بازسازی است.

### آزمون تشریحی با پاسخ

1. **چه ویژگی‌هایی search engine را برای کاتالوگ مناسب می‌کند؟** ترکیب متن، فیلتر، ranking و aggregation.
2. **چرا log به retention نیاز دارد؟** حجم داده رشد می‌کند و الگوی دسترسی به رخداد تازه و قدیمی متفاوت است.
3. **چه وقت انتخاب نامناسب است؟** وقتی DB یا ابزار ساده‌تر همان نیاز را با هزینه‌ی عملیاتی کمتر پوشش دهد.


## خودآزمایی
1. قبل از انتخاب Elasticsearch چه چیزی را benchmark می‌کنی؟ پاسخ: query و write واقعی، حجم/رشد، latency و معیار کیفیت.
2. چرا همهٔ داده‌ها را index نمی‌کنیم؟ پاسخ: fieldهای indexed هزینهٔ disk/CPU و پیچیدگی دارند؛ فقط نیاز واقعی را مدل کن.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/solutions/search/get-started)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Elasticsearch%20Usecases)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



