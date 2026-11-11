# Custom Analyzers

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 07

## هدف این درس
در این مبحث، Custom Analyzers را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Analyzer سفارشی سه لایه دارد: character filter پیش‌پردازش، tokenizer شکستن، token filter normalization یا گسترش. برای title ممکن است lowercase و synonym لازم باشد؛ برای exact identifier شاید keyword analyzer. ترتیب را با Analyze API و نمونهٔ query بررسی کن.

~~~http
PUT /products-v1
{"settings":{"analysis":{"analyzer":{"product_text":{"type":"custom","tokenizer":"standard","filter":["lowercase","asciifolding"]}}}},"mappings":{"properties":{"title":{"type":"text","analyzer":"product_text"}}}}
~~~
این مثال قواعد عمومی دارد و پشتیبانی/version را چک کن. تمرین: زنجیره را یکی‌یکی تغییر و خروجی tokenها را ثبت کن؛ تغییر index analyzer برای دادهٔ موجود معمولاً reindex می‌خواهد.

## خودآزمایی
1. اجزای analyzer سفارشی کدام‌اند؟ پاسخ: character filters، یک tokenizer و token filters به ترتیب.
2. چرا ترتیب مهم است؟ پاسخ: هر مرحله خروجی مرحلهٔ قبلی را تغییر می‌دهد و synonym/stop filter رفتار وابسته دارد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/manage-data/data-store/text-analysis/create-custom-analyzer)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Custom%20Analyzers)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


