# Object

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/07-object/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 07

## هدف این درس
در این مبحث، Object را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
object فیلدهای تو‌در‌تو را در مسیرهایی مانند seller.city نگاشت می‌کند. در آرایهٔ object، ساختار پیش‌فرض معمولاً flattened است؛ name یک عضو و color عضو دیگر ممکن است همزمان match شوند. اگر هم‌عضوی برای نتیجه مهم نیست، object سبک‌تر و کافی است.

~~~json
{"properties":{"seller":{"properties":{"name":{"type":"keyword"},"city":{"type":"keyword"}}}}}
~~~
تمرین: دو object در یک آرایه بساز و query مرکب بنویس؛ مشخص کن آیا شرط‌ها باید به همان عنصر تعلق داشته باشند. اگر باید، mapping nested و nested query لازم است.

## خودآزمایی
1. object array چه مسئله‌ای دارد؟ پاسخ: relation میان fieldهای هر عضو معمولاً flattened می‌شود و query ممکن است fieldهای دو عضو را به‌اشتباه کنار هم بگذارد.
2. object چه وقت کافی است؟ پاسخ: وقتی query نیاز ندارد اثبات کند چند شرط روی همان عضو آرایه برقرارند.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Object)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


