# Data Types

[English version](../../../../../en/elasticsearch/03-data-types-and-node-roles/topics/01-data-types/README.md)


> فصل 03: نوع داده و نقش نودها · درس 01

## هدف این درس
Type را از عملیات لازم انتخاب کن: full-text، exact، محاسبه، تاریخ، Boolean، geo یا ساختار object.
## تدریس عمیق

### انتخاب data type از روی query
Type تعیین می‌کند مقدار چگونه parse و index شود و چه query و aggregationای روی آن قابل اجرا باشد. سؤال را از query شروع کن: متن باید relevance داشته باشد؟ exact filter یا sort لازم است؟ عدد محاسبه می‌شود؟ زمان histogram می‌خواهد؟ مکان distance query دارد؟
text برای متن تحلیل‌شده، keyword برای مقدار کامل، numeric برای محاسبه، date برای زمان، boolean برای پرچم و geo_point برای مختصات است. Object/nested/flattened مدل‌های JSON تو‌در‌تو هستند. انتخاب نوع روی storage و قابلیت‌ها اثر می‌گذارد و تغییر نوع بعداً migration می‌خواهد.
پیش از ساخت mapping، نمونه‌های داده و queryهای واقعی را بنویس. برای هر فیلد نوع، مقدار نامعتبر، missing/null و cardinality را ثبت کن. خطای رایج آن است که نوع را از نام فیلد حدس بزنند، نه از مقدار و query.

## خودآزمایی
1. برای محاسبهٔ قیمت از چه نوعی استفاده می‌کنی؟ پاسخ: numeric با انتخاب precision مناسب؛ پول و rounding را جدا تعریف کن.
2. برای sort و full-text هم‌زمان روی عنوان؟ پاسخ: text با keyword multi-field.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/field-data-types)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Data%20Types)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



