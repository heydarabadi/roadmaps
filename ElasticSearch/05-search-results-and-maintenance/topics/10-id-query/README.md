# ID Query

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 10

## هدف این درس
در این مبحث، ID Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
IDs query چند `_id` را در یک درخواست match می‌کند؛ برای lookup مجموعه‌ای محدود از شناسه‌ها مفید است. ID متادیتای سند است و لزوماً یک field عادی نیست؛ اگر نیاز به sort/aggregation روی business ID داری، فیلد keyword جداگانه map کن.

~~~http
POST /products-v1/_search
{"query":{"ids":{"values":["sku-100","sku-200"]}}}
~~~
تمرین: شناسه را به‌صورت `_id` و `product_id` جست‌وجو کن و رفتار هرکدام را مقایسه کن. فهرست عظیم IDها query را بزرگ می‌کند؛ bulk mget یا lookup store ممکن است مناسب‌تر باشد.

## خودآزمایی
1. ids query چه چیز را جست‌وجو می‌کند؟ پاسخ: `_id` سندها را در indexهای هدف.
2. برای فهرست هزاران ID مناسب است؟ پاسخ: ممکن است clause/درخواست بزرگ و گران شود؛ دسته‌بندی و روش lookup مناسب را طراحی کن.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20ID%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


