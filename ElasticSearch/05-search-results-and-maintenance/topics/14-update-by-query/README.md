# Update by Query

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 14

## هدف این درس
در این مبحث، Update by Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Update by Query query را اجرا و هر سند مطابق را بازنویسی می‌کند؛ می‌تواند partial doc یا script داشته باشد. عملیات گسترده است، پس ابتدا search preview و count را بررسی، batch/throttle و conflicts را مدیریت و task async را پایش کن.

~~~http
POST /products-v1/_update_by_query?wait_for_completion=false&conflicts=proceed
{"query":{"term":{"status":"legacy"}},"script":{"source":"ctx._source.status = params.s","params":{"s":"archived"}}}
~~~
`conflicts=proceed` خطاها را بی‌اهمیت نمی‌کند؛ response را ببین. تمرین: query را ابتدا در Search اجرا و تعداد را ثبت کن، سپس update آزمایشی انجام بده. Script تکرارپذیر و idempotent بنویس؛ تغییرات concurrent را در نظر بگیر.

## خودآزمایی
1. update_by_query بر چه مجموعه‌ای کار می‌کند؟ پاسخ: snapshot اولیهٔ hitهای query را می‌خواند و اسناد مطابق را update می‌کند.
2. version conflict را نادیده می‌گیریم؟ پاسخ: نه؛ باید count، conflicts و امکان retry محدود را بر اساس semantics بسنجیم.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/update-by-query-api)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Update%20by%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


