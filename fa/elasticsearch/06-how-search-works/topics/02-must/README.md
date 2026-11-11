# must

[English version](../../../../../en/elasticsearch/06-how-search-works/topics/02-must/README.md)


> فصل 06: چگونه جست‌وجو کار می‌کند · درس 02

## هدف این درس
در این مبحث، must را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
must در bool query باید match شود و در query context score تولید می‌کند. آن را برای متن یا ویژگی‌ای به‌کار ببر که هم قبولی و هم ارتباطش در رتبه اهمیت دارد. چند must یعنی همه لازم‌اند.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must":[{"match":{"title":"هدفون"}},{"match":{"description":"noise cancelling"}}]}}}
~~~
این دو شرط هر دو لازم‌اند. تمرین: یکی را به should تبدیل و hitها و score را مقایسه کن. شرط سادهٔ ساخت‌یافته را برای relevance بالا نبر؛ در filter بگذار.

## خودآزمایی
1. must چه می‌کند؟ پاسخ: شرط لازم می‌سازد و match آن می‌تواند در relevance score سهم داشته باشد.
2. قیمت را must می‌گذاری؟ پاسخ: معمولاً نه؛ range در filter، مگر عمداً score ساخت‌یافته بخواهم.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20must)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


