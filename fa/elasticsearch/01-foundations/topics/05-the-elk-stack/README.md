# The ELK Stack

[English version](../../../../../en/elasticsearch/01-foundations/topics/05-the-elk-stack/README.md)


> فصل 01: مبانی و شناخت · درس 05

## هدف این درس
نقش Elasticsearch، Logstash/ingest، Beats/Agent و Kibana را در pipeline داده تشخیص بده؛ ترکیب محصولات تابع نسخه است.
## تدریس کامل: اجزای Elastic Stack چه مسئولیتی دارند؟

ELK نام رایج ترکیب Elasticsearch، Logstash و Kibana است. Elasticsearch سندها را index و search می‌کند؛ Logstash داده را از ورودی‌ها می‌خواند، parse و transform می‌کند و به مقصد می‌فرستد؛ Kibana رابطی برای جست‌وجو، dashboard، visualization و مدیریت فراهم می‌کند.

### مسیر نمونه‌ی log

1. سرویس برنامه رخداد ساخت‌یافته تولید می‌کند.
2. عامل دریافت داده آن را از فایل، queue یا منبع دیگری می‌خواند.
3. pipeline فیلدهای زمان، سطح، سرویس و پیام را parse و normalize می‌کند.
4. سند به data stream یا index دارای الگوی زمانی وارد می‌شود.
5. کاربر در Kibana رخداد را فیلتر می‌کند، نمودار می‌سازد و alert تعریف می‌کند.

دریافت داده می‌تواند با Logstash، Elastic Agent، Beats، OpenTelemetry Collector یا producer سفارشی انجام شود. انتخاب به نوع منبع، plugin، buffering و نحوه‌ی اداره بستگی دارد. همه‌ی سامانه‌ها به Logstash نیاز ندارند؛ اگر برنامه JSON استاندارد می‌فرستد، client یا ingest pipeline می‌تواند کافی باشد.

### مسئولیت‌ها را جدا نگه دار

- Elasticsearch: ذخیره‌سازی نمایه‌شده، query و aggregation.
- Logstash: pipeline مستقل ingest و transform.
- Kibana: رابط تعامل، visualization و dashboard.
- Agent و integration: جمع‌آوری telemetry و پیکربندی عامل‌ها.

در production، schema consistency، retry، back-pressure و dead-letter را تعیین کن. اگر ingest عقب افتاد، باید بدانی گیر در منبع، queue، parser یا Elasticsearch است. Event time را از ingest time جدا نگه دار تا تأخیر را اندازه بگیری.

### تمرین و آزمون

جریان log یک سرویس را رسم کن؛ منبع، collector، parser، بافر، index و dashboard را مشخص کن. برای هر نقطه بنویس اگر مقصد خاموش شد چه می‌شود و خطای parse کجا دیده می‌شود.

1. **Elasticsearch چه می‌کند؟** Index، search و تحلیل داده‌ی نمایه‌شده را انجام می‌دهد.
2. **Logstash چه وقت لازم می‌شود؟** وقتی pipeline مستقل دریافت و تبدیل داده به قابلیت‌هایش نیاز دارد؛ همیشه اجباری نیست.
3. **Kibana جای چه چیزی نیست؟** جای موتور ذخیره‌سازی و جست‌وجوی Elasticsearch نیست.


## خودآزمایی
1. Kibana دادهٔ اصلی را کجا ذخیره می‌کند؟ پاسخ: عمدتاً به Elasticsearch متصل است و UI/visualization می‌دهد.
2. چه زمانی ingest pipeline یا Logstash می‌خواهی؟ پاسخ: برای parse/transform/route داده؛ انتخاب با پیچیدگی و مالکیت pipeline است.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/solutions/search/get-started)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20The%20ELK%20Stack)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



