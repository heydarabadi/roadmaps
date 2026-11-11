# Understanding Similarity

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/21-understanding-similarity/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 21

## هدف این درس
در این مبحث، Understanding Similarity را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Similarity function تعیین می‌کند match متنی چگونه امتیاز بگیرد. Elasticsearch برای متن عموماً BM25 را به‌کار می‌برد؛ token frequency، rarity و document length مهم‌اند. analyzer و query ساختار داده را تعیین می‌کنند، similarity رتبهٔ matchهای موجود را.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":"wireless noise cancelling"}},"explain":true}
~~~
Explain علت score یک سند را نشان می‌دهد. تمرین: دو سند کوتاه/بلند با واژهٔ مشترک بساز، scoreها را ببین و مطلق‌گرایی نکن. تنظیم similarity را روی مجموعهٔ relevance قضاوت‌شده ارزیابی کن؛ score احتمال نیست.

## خودآزمایی
1. similarity چه چیزی را تعیین می‌کند؟ پاسخ: محاسبهٔ relevance score برای matchهای متنی.
2. score دو query مختلف قابل‌مقایسهٔ مستقیم است؟ پاسخ: معمولاً خیر؛ score به query و آمار index وابسته است.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Understanding%20Similarity)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


