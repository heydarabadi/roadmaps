# Numeric

[English version](../../../../../en/elasticsearch/03-data-types-and-node-roles/topics/05-numeric/README.md)


> فصل 03: نوع داده و نقش نودها · درس 05

## هدف این درس
Numeric type را بر اساس precision، range، sort و aggregation انتخاب کن؛ برای پول، representation و rounding را صریح کن.
## تدریس عمیق

### Numeric types، precision و range
Numeric field برای range، sort و aggregation عددی است. نوع را با دامنه و نیاز دقت انتخاب کن: شمارنده‌ی کوچک نیاز float ندارد؛ مبلغ اعشاری ممکن است با scaled_float یا نمایش واحد صحیح مثل ریال/سنت دقیق‌تر مدل شود.
اگر قیمت را به صورت رشته map کنی، مرتب‌سازی و range واژه‌ای خواهد بود و sum/avg عددی قابل استفاده نیست. در ورود داده، هزارگان و نماد واحد پول را از عدد جدا کن؛ مقدار نرمال‌شده را نگه دار و واحد را در schema معلوم کن.
تمرین: تصمیم بگیر مبلغ را با چه واحدی ذخیره می‌کنی، بیشینه‌ی ممکن چقدر است و آیا اعشار دارد. بعد range و avg aggregation را روی چند مقدار مرزی بررسی کن.

## خودآزمایی
1. float و long چه تفاوتی دارند؟ پاسخ: float تقریبی است؛ integer دقیق برای واحد کوچک پول/شمارنده مناسب‌تر است.
2. scaled_float چه می‌کند؟ پاسخ: مقدار را با scaling_factor به integer تقریبی/مقیاس‌شده نگه می‌دارد؛ precision باید کافی باشد.
## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Numeric)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



