# Doc values

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 02

## هدف این درس
در این مبحث، Doc values را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Doc values ساختار ستونی fieldهاست که عموماً روی disk ذخیره می‌شود و برای خواندن مقدار هر سند هنگام sort، aggregation و script مفید است. این مسیر مکمل inverted index است، نه جایگزین آن. keyword، عدد و date معمولاً doc values دارند؛ text عموماً ندارد.

~~~json
{"properties":{"title":{"type":"text","fields":{"keyword":{"type":"keyword"}}},"price":{"type":"long"}}}
~~~
روی title.keyword و price sort/agg کن، روی title full-text. تمرین: sort روی text را امتحان و خطا/محدودیت را تفسیر کن؛ fielddata را صرفاً برای دورزدن انتخاب mapping روشن نکن.

## خودآزمایی
1. doc values برای چه هستند؟ پاسخ: نمایش ستونی برای sort، aggregation و دسترسی به مقدارهای فیلد.
2. چرا روی text فعال نیست؟ پاسخ: full text با inverted index کار می‌کند؛ keyword multi-field برای sort/agg جداگانه مناسب است.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/doc-values)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Doc%20values)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


