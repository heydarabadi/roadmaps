# The Analyze API

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/05-the-analyze-api/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 05

## هدف این درس
در این مبحث، The Analyze API را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Analyze API ابزار تشخیص analyzer است: می‌توان متن را با analyzer نام‌دار یا tokenizer/filter سفارشی تحلیل کرد. خروجی فقط لیست واژه نیست؛ position و offset در phrase query، synonym graph و highlight هم اثر دارند.

~~~http
POST /products-v1/_analyze
{"analyzer":"standard","text":"کتاب‌های برنامه‌نویسی؛ کد ۱۲۳"}
~~~
tokenها را با query مورد انتظار مقایسه کن. تمرین: صورت عربی/فارسی ی، نیم‌فاصله و رقم لاتین را نیز آزمایش و تصمیم normalization را ثبت کن. analyzer custom را ابتدا آزمایشگاهی بساز و پس از تغییر mapping index جدید/reindex را برنامه‌ریزی کن.

## خودآزمایی
1. Analyze API چه چیزی را نشان می‌دهد؟ پاسخ: tokenهای تولیدشده، position، offset و گاهی type با analyzer انتخابی.
2. چرا پیش از ingest فارسی آزمایش می‌کنیم؟ پاسخ: تا تفاوت ی/ک، نیم‌فاصله، اعداد و واژه‌های ترکیبی آشکار شود.

## منابع
- انگلیسی: [راهنمای Text Analysis](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20The%20Analyze%20API)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


