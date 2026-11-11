# Delete by Query

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 15

## هدف این درس
در این مبحث، Delete by Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Delete by Query همهٔ سندهای مطابق predicate را حذف می‌کند و می‌تواند تعداد زیادی write/tombstone و merge ایجاد کند. ابتدا query را با Search اجرا، نمونه‌ها و count را تأیید، مجوز و retention را بررسی و عملیات را throttle/poll کن. اگر اشتباه شود restore ممکن است لازم باشد.

~~~http
POST /events-v1/_delete_by_query?wait_for_completion=false&requests_per_second=200
{"query":{"range":{"@timestamp":{"lt":"2025-01-01T00:00:00Z"}}}}
~~~
نمونه فقط بعد از تأیید سیاست نگهداری اجرا شود. تمرین: حذف مورد انتظار را با count مستقل مقایسه و task failures را ثبت کن. wildcard index یا تاریخ اشتباه عامل رایج حذف ناخواسته است.

## خودآزمایی
1. چرا قبل از delete_by_query باید search کنیم؟ پاسخ: تا predicate و تعداد سندهای هدف را بازبینی کنیم؛ حذف گروهی به‌سادگی برگشت ندارد.
2. این API synchronous است؟ پاسخ: می‌تواند task async اجرا شود؛ status، failures و deleted count را پایش کن.

## منابع
- انگلیسی: [مرجع رسمی REST APIها](https://www.elastic.co/docs/reference/elasticsearch/rest-apis)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Delete%20by%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


