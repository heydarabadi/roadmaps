# Pagination

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 02

## هدف این درس
در این مبحث، Pagination را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
from/size برای صفحه‌بندی کم‌عمق آسان است، اما offsetهای بزرگ پرهزینه‌اند و max_result_window محدودیت دارد. search_after با sort پایدار برای ادامه از آخرین hit است؛ شناسهٔ یکتا tie-breaker مناسب است. اگر داده حین پیمایش عوض می‌شود، PIT دید ثابت‌تری می‌دهد. Scroll برای پیمایش batchهای export کاربرد دارد.

~~~http
POST /products-v1/_search
{"size":2,"query":{"match_all":{}},"sort":[{"product_id":"asc"}],"search_after":["sku-002"]}
~~~
مقادیر باید عین sort array آخرین hit قبلی باشند؛ query و sort را عوض نکن. تمرین: 5 سند را در دو صفحه بخوان و duplicate/skip را بررسی کن. PIT را ببند وقتی تمام شد.

## خودآزمایی
1. چرا offset بزرگ گران است؟ پاسخ: shardها تا from+size نامزد لازم را نگه/مرتب می‌کنند.
2. search_after به چه چیز نیاز دارد؟ پاسخ: query و sort ثابت، و sort values آخرین hit؛ برای نمای ثابت PIT نیز به‌کار می‌رود.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/paginate-search-results)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Pagination)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


