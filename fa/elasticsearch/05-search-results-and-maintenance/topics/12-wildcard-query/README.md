# Wildcard Query

[English version](../../../../../en/elasticsearch/05-search-results-and-maintenance/topics/12-wildcard-query/README.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 12

## هدف این درس
در این مبحث، Wildcard Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Wildcard pattern مثل `sku-?00*` روی termهای indexشده ارزیابی می‌شود؛ `?` یک نویسه و `*` چند نویسه را می‌پوشاند. این full-text search نیست و الگوی `*suffix` می‌تواند costly باشد. فیلد keyword و محدودیت ورودی انتخاب معمول امن‌تری است.

~~~http
POST /products-v1/_search
{"query":{"wildcard":{"product_id":{"value":"sku-1*"}}}}
~~~
تمرین: همین query را با prefix و pattern آغازشونده با wildcard مقایسه و latency/نتیجه را ثبت کن. برای identifierهای دلخواه شاید normalizer یا ساخت فیلد کمکی مناسب‌تر باشد.

## خودآزمایی
1. چرا wildcard آغازشونده با * پرهزینه است؟ پاسخ: می‌تواند تعداد زیادی term را بررسی کند چون ابتدای مشخصی برای محدودکردن lookup ندارد.
2. برای جست‌وجوی متن از wildcard استفاده کنیم؟ پاسخ: عموماً match بهتر است؛ wildcard را برای نیاز الگوی term و با اندازه‌گیری به‌کار ببر.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Wildcard%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


