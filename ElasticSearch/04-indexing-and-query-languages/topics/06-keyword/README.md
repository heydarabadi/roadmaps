# Keyword

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 06

## هدف این درس
در این مبحث، Keyword را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
keyword رشته را به یک مقدار دقیق index می‌کند؛ normalizer می‌تواند lowercase یا تغییر کنترل‌شده انجام دهد. این نوع برای term query، sort، aggregation و شناسه‌های متنی مناسب است. از keyword برای متن بلند و پرتنوع بی‌برنامه استفاده نکن؛ حجم termها و cardinality را بسنج.

~~~http
POST /products-v1/_search
{"query":{"term":{"brand":{"value":"آوا"}}},"sort":[{"brand":{"order":"asc"}}]}
~~~
عبارت باید با مقدار indexشده و normalizer سازگار باشد. تمرین: برای title هم text و هم title.keyword بساز و تفاوت match را ببین. اگر exact بدون حساسیت به بزرگی/کوچکی لازم است normalizer را پیش از ingest طراحی و آزمایش کن.

## خودآزمایی
1. keyword چه زمانی مناسب است؟ پاسخ: برای رشتهٔ کامل و exact مانند کد، وضعیت و برندی که باید فیلتر، sort یا group شود.
2. keyword عنوان را جست‌وجوی واژه‌ای می‌کند؟ پاسخ: نه؛ معمولاً کل مقدار یک term است؛ متن طبیعی به text نیاز دارد.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Keyword)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


