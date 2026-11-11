# Mapping Explosion

[English version](README.en.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 04

## هدف این درس
Mapping explosion از رشد بی‌رویهٔ fieldها ناشی می‌شود و cluster state، heap و عملیات را تحت فشار می‌گذارد.
## Mapping explosion را مهار کن

### Mapping explosion را مهار کن
Mapping explosion زمانی رخ می‌دهد که تعداد propertyهای index با سرعت و بدون سقف رشد کند. منبع رایج آن log یا metadataای است که کلیدها از شناسه‌ی مشتری، محصول یا درخواست ساخته می‌شوند. هر field جدید cluster state و metadata اضافه می‌کند و می‌تواند heap، updateهای cluster state و مدیریت را سنگین کند.
برای تشخیص، تعداد fieldها، روند رشد، dynamic fieldها و producerهای عامل را ببین. فقط total_fields.limit را بالا بردن علت را برطرف نمی‌کند. ابتدا مشخص کن آیا هر کلید باید جدا query شود.
راهکارها: dynamic strict/false، dynamic templates با pattern محدود، model کلید/مقدار، flattened برای objectهای متغیر، یا نگهداری فقط در _source. اگر لازم است چند کلید خاص جست‌وجو شوند، آن‌ها را صریح map کن و بقیه را در ساختار منعطف نگه دار.
~~~json
{"attributes":{"color":"black","material":"metal","seller_custom_93814":"value"}}
~~~
در مثال، تولید property برای هر seller_id خطرناک است. به‌جای آن attributes را key/value یا flattened مدل کن. خطای رایج، افزایش سقف limit بدون بودجه‌ی حافظه و برنامه‌ی حذف fieldهای بی‌مصرف است.

## خودآزمایی
1. چرا کلیدهای پویا خطرناک‌اند؟ پاسخ: هر کلید field جدید می‌سازد و شمار mapping را نامحدود می‌کند.
2. چه جایگزینی داری؟ پاسخ: flattened برای metadata متغیر و explicit mapping برای fieldهای queryپذیر.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Mapping%20Explosion)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



