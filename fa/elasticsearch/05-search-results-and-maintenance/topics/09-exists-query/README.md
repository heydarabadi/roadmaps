# Exists Query

[English version](../../../../../en/elasticsearch/05-search-results-and-maintenance/topics/09-exists-query/README.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 09

## هدف این درس
در این مبحث، Exists Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Exists query وجود indexed value را می‌سنجد، نه اینکه property حتماً در JSON اولیه وجود داشته باشد. مقدار null و آرایهٔ خالی معمولاً وجود محسوب نمی‌شوند؛ بعضی mappingها null_value را به term قابل‌جست‌وجو تبدیل می‌کنند. `ignore_above` و parse ناموفق هم می‌توانند source را داشته باشند ولی term قابل استفاده نسازند.

~~~http
POST /products-v1/_search
{"query":{"bool":{"must_not":[{"exists":{"field":"description"}}]}}}
~~~
این query سندهایی را می‌یابد که description indexed ندارند. تمرین: فیلد را حذف، null و رشتهٔ خالی کن و نتیجه را با mapping بررسی کن؛ source و index semantics را یکسان فرض نکن.

## خودآزمایی
1. exists چه چیزی می‌سنجد؟ پاسخ: آیا سند برای آن field مقدار indexشده دارد.
2. مقدار null چه نتیجه دارد؟ پاسخ: معمولاً به‌تنهایی value indexشده نیست؛ null_value mapping و آرایهٔ خالی رفتار خاص ایجاد می‌کنند.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Exists%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


