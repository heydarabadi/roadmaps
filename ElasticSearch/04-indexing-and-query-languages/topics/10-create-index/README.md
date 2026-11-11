# Create Index

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 10

## هدف این درس
در این مبحث، Create Index را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Create Index بستر ذخیرهٔ سندها و رفتار search را تعریف می‌کند: shard، analyzer، mapping و alias. در production پیش از ingest mapping صریح و template را آماده کن؛ در غیر این‌صورت dynamic type بر اساس دادهٔ اولیه انتخاب می‌شود.

~~~http
PUT /products-v1
{"settings":{"number_of_shards":1,"number_of_replicas":0},"mappings":{"properties":{"product_id":{"type":"keyword"},"title":{"type":"text"},"price":{"type":"long"}}}}
~~~
تنظیم shard این مثال آزمایشگاهی است. تمرین: اضافه کردن زمان ایجاد و برند را با نوع مناسب کامل کن و یک template برای indexهای ماهانه بساز. قبل از اجرای دوباره، وجود index را بررسی و درخواست را idempotent طراحی کن.

## خودآزمایی
1. چه چیزهایی با Create Index تعریف می‌شوند؟ پاسخ: settings، mapping و aliasهای اولیه.
2. چرا dynamic mapping بی‌برنامه خطر دارد؟ پاسخ: اولین مقدار ممکن است نوع نامطلوب را تثبیت کند و افزایش fieldهای پویا mapping explosion بسازد.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Create%20Index)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


