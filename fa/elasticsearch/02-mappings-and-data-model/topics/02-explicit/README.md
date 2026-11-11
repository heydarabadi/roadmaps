# Explicit

[English version](../../../../../en/elasticsearch/02-mappings-and-data-model/topics/02-explicit/README.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 02

## هدف این درس
Explicit mapping typeها را آگاهانه تعیین می‌کند و از استنباط ناخواستهٔ دادهٔ اولیه جلوگیری می‌کند.
## Explicit mapping را طراحی کن

### Explicit mapping را طراحی کن
Explicit mapping یعنی پیش از ورود داده، نوع و قابلیت field را تعریف کنی. این کار مانع حدس اشتباه اولین سند می‌شود و قرارداد قابل‌بررسی بین producer و search index می‌سازد. برای فیلدهای پایدار و پرتکرار، معمولاً انتخاب مطمئن تولیدی است.
برای داده‌ی محصول، sku را keyword، title را text با subfield keyword، price را numeric، active را boolean و created_at را date بگذار. برای objectهای آزاد تصمیم جدا بگیر؛ هر کلید پویا را property جدید نکن.
~~~http
PUT /products-v1
{"mappings":{"dynamic":"strict","properties":{"sku":{"type":"keyword"},"title":{"type":"text","fields":{"raw":{"type":"keyword"}}},"price":{"type":"scaled_float","scaling_factor":100},"active":{"type":"boolean"},"created_at":{"type":"date"}}}}
~~~
dynamic strict سند دارای field ناشناخته را رد می‌کند؛ این مناسب حالتی است که قرارداد ورودی را کنترل می‌کنی. اگر باید fieldهای نامعلوم را در _source نگه داری اما index نکنی، dynamic false را ارزیابی کن. رفتار را در نسخه‌ی خود با نمونه‌ی کوچک تأیید کن.
پیش از deploy سه نمونه‌ی معتبر و چند نمونه‌ی نامعتبر آماده کن. با GET mapping بررسی کن نوع نهایی دقیقاً همان است که انتظار داری. خطای رایج، تعریف mapping از روی نام فیلد به‌جای query واقعی و دامنه‌ی مقدارهاست.

## خودآزمایی
1. مزیت explicit mapping چیست؟ پاسخ: schema پایدار و رفتار پیش‌بینی‌پذیر query/sort/aggregation.
2. فیلد جدید را چطور rollout می‌کنی؟ پاسخ: mapping را سازگار اضافه، template را برای indexهای بعدی بروزرسانی و نسخه‌ها را کنترل می‌کنم.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Explicit)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



