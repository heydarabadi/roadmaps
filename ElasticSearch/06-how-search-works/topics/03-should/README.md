# should

[English version](README.en.md)


> فصل 06: چگونه جست‌وجو کار می‌کند · درس 03

## هدف این درس
در این مبحث، should را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
should به سندهای match شده امتیاز می‌دهد؛ اگر bool فقط should داشته باشد، معمولاً حداقل یکی لازم است. در حضور must/filter، shouldها ممکن است اختیاری شوند. برای synonym، brand preference یا عنوان جایگزین، intent را با minimum_should_match مشخص کن.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"هدفون"}}],"should":[{"term":{"brand":"آوا"}}],"minimum_should_match":0}}}
~~~
برند فقط boost می‌دهد. اگر می‌خواهی دست‌کم یکی از نام‌های جایگزین حاضر باشد، مقدار مناسب را صریح تنظیم کن. تمرین: دو should بساز و رفتار 0، 1 و درصد را بسنج.

## خودآزمایی
1. should چه نقشی دارد؟ پاسخ: تطبیق اختیاری برای boost یا شرط اجباری بسته به minimum_should_match/وجود must-filter.
2. چرا minimum_should_match را می‌نویسیم؟ پاسخ: تا روشن باشد چند clause اختیاری واقعاً باید match شوند.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20should)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


