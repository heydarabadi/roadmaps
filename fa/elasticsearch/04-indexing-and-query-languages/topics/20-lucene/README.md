# Lucene

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/20-lucene/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 20

## هدف این درس
در این مبحث، Lucene را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Lucene query string متن query قابل‌parse است؛ field، operator، phrase، wildcard و گروه‌بندی دارد. این syntax با Query DSL JSON و KQL یکی نیست. مزیتش فشردگی برای جست‌وجوی دستی است، اما خطاهای parse و ورود syntax ناخواسته برای ورودی آزاد کاربر ممکن است.

~~~text
title:(wireless headphones) AND available:true AND price:[0 TO 5000000]
~~~
تمرین: معادل bool DSL را بساز و تفاوت parser/error handling را بررسی کن. برای query تولیدی با شرط‌های قابل‌اعتماد، DSL ساختاریافته معمولاً کنترل و اعتبارسنجی روشن‌تری فراهم می‌کند.

## خودآزمایی
1. Lucene query string چیست؟ پاسخ: syntax متنی query مانند `title:elastic AND status:active` که parser آن را به query تبدیل می‌کند.
2. آیا امن است هر ورودی کاربر را مستقیم در آن بگذاری؟ پاسخ: خیر؛ syntax، escaping و امکان گسترش query ناخواسته را کنترل کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-query-string-query)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Lucene)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


