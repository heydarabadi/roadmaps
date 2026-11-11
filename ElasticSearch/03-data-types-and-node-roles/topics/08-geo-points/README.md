# Geo Points

[English version](README.en.md)


> فصل 03: نوع داده و نقش نودها · درس 08

## هدف این درس
geo_point مکان را به‌شکل lat/lon نگه می‌دارد و distance/geo bounding query را ممکن می‌کند؛ ترتیب مختصات مهم است.
## تدریس عمیق

### Geo point و جست‌وجوی مکانی
geo_point یک نقطه‌ی جغرافیایی را با latitude و longitude index می‌کند تا distance query، sort بر اساس فاصله و فیلتر محدوده‌ی جغرافیایی قابل اجرا باشد.
در JSON آرایه‌ای معمولاً ترتیب longitude, latitude است؛ در object می‌توان نام فیلدها را مشخص کرد. قرارداد producer را تثبیت و نقاط را روی نقشه بررسی کن. خطای جابه‌جایی دو مقدار ممکن است مختصات را به مکان دیگری ببرد یا نامعتبر کند.
Use case نمونه، شعبه‌های نزدیک کاربر است: ابتدا محدوده را filter کن، بعد بر اساس فاصله مرتب کن. برای polygon، geo_shape مناسب‌تر از geo_point است. خطای رایج، نگهداری مختصات به شکل دو عدد بدون mapping مکانی و بدون اعتبارسنجی دامنه است.

## خودآزمایی
1. ترتیب coordinate در array چیست؟ پاسخ: `[lon, lat]`؛ در object نام‌های `lat` و `lon` ابهام را رفع می‌کنند.
2. چرا جابه‌جایی lat/lon خطر دارد؟ پاسخ: نقطه‌ای کاملاً متفاوت یا مقدار خارج از محدوده ایجاد می‌کند.
## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/geo-point)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Geo%20Points)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



