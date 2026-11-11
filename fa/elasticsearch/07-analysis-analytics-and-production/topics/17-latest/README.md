# Latest

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/17-latest/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 17

## هدف این درس
در این مبحث، Latest را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Latest transform یک سند جدیدتر برای هر entity را انتخاب می‌کند، مثلاً آخرین وضعیت دستگاه بر اساس device_id و event time. کلید entity و sort field باید mapping و semantics روشن داشته باشند؛ eventهای out-of-order روی نتیجه اثر دارند.

~~~json
{"unique_key":["device_id"],"sort":"@timestamp"}
~~~
این تنظیم مفهومی است و body کامل وابسته به API/نسخه است. تمرین: دو رخداد با زمان معکوس ورود بده و ببین کدام latest می‌شود. checkpoint delay و منبع تکراری را اندازه بگیر؛ خروجی جایگزین event log نیست.

## خودآزمایی
1. latest transform چه نگه می‌دارد؟ پاسخ: جدیدترین سند هر کلید بر اساس زمان مرتب‌کننده.
2. timestamp دیررس چه اثری دارد؟ پاسخ: اگر زمان/کلید نامعتبر باشد latest نادرست یا دیر به‌روز می‌شود؛ lateness و sync را پایش کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/explore-analyze/transforms/transform-overview)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Latest)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


