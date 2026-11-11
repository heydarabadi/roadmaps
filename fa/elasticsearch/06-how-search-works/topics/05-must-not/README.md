# must_not

[English version](../../../../../en/elasticsearch/06-how-search-works/topics/05-must-not/README.md)


> فصل 06: چگونه جست‌وجو کار می‌کند · درس 05

## هدف این درس
در این مبحث، must_not را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
must_not در filter context سندهای matchکننده را از مجموعهٔ نتیجه حذف می‌کند. برای status پنهان، حذف ممنوع‌ها و استثناها مناسب است. نبود فیلد با مقدار false برابر نیست؛ شرط missing را جدا تعریف کن.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"موبایل"}}],"must_not":[{"term":{"status":"hidden"}}]}}}
~~~
تمرین: سند دارای status=hidden، active و missing بساز؛ مجموعهٔ نتایج را با intent کسب‌وکار تطبیق بده. اگر همهٔ اسناد حذف شدند، ابتدا data/mapping/query preview را بررسی کن.

## خودآزمایی
1. must_not چه می‌کند؟ پاسخ: اسناد matchکننده را حذف می‌کند و score مثبت نمی‌سازد.
2. برای منفی‌سازی همهٔ query مناسب است؟ پاسخ: نه؛ شرط بسیار گسترده یا دادهٔ missing باید با منطق bool و expected set آزموده شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20must_not)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


