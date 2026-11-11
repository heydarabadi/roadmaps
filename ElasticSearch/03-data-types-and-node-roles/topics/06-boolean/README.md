# Boolean

[English version](README.en.md)


> فصل 03: نوع داده و نقش نودها · درس 06

## هدف این درس
Boolean برای وضعیت دوحالته است؛ ورودی producer را normalize کن تا null/missing با false اشتباه نشود.
## تدریس عمیق

### Boolean برای وضعیت‌های دوتایی
Boolean دو مقدار true و false را برای وضعیت‌هایی مانند active یا available نمایش می‌دهد. در Elasticsearch از آن برای شرط‌های filter استفاده کن؛ معمولاً relevance مستقل ندارد.
قبل از ingest قرارداد تبدیل بساز. مقدارهای ورودی مثل "yes"، "Y"، "1" یا null را در producer به true/false یا missing مشخص تبدیل کن. داده‌ی مبهم در چند سرویس ممکن است mapping یا منطق نتایج را ناهماهنگ کند.
~~~http
POST /products-v1/_search
{"query":{"term":{"available":true}}}
~~~
بررسی کن آیا missing به معنی false است یا «نامعلوم». این دو نباید بی‌دلیل یکی شوند. خطای رایج، فرض false بودن فیلد غایب بدون تصمیم محصول است.

## خودآزمایی
1. missing با false یکسان است؟ پاسخ: نه؛ برای missing از exists یا منطق جدا استفاده کن.
2. چرا boolean را keyword رشته‌ای نمی‌گیریم؟ پاسخ: boolean معنای نوعی، فیلتر و storage سازگارتر دارد.
## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/boolean)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Boolean)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



