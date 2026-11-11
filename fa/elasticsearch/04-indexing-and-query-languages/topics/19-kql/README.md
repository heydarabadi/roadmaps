# KQL

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/19-kql/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 19

## هدف این درس
در این مبحث، KQL را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
KQL زبان concise فیلتر در Kibana است؛ عبارت‌هایی مثل status:200 یا bytes > 1000 را می‌نویسی و Kibana به query مناسب تبدیل می‌کند. KQL برای جست‌وجوی متن آزاد و filter UI طراحی شده، نه aggregation و همهٔ قابلیت‌های Search API.

~~~text
status: 200 and response: "success"
~~~
نام field و نوعش مهم است: keyword برای exact، numeric/date برای مقایسه. تمرین: filter Kibana را با Query DSL bool.filter هم‌ارز کن. عبارت KQL را در body API نفرست؛ ابتدا بفهم Kibana query را چگونه می‌سازد.

## خودآزمایی
1. KQL کجا استفاده می‌شود؟ پاسخ: در Kibana برای filter کردن سندها در Discover/visualization.
2. KQL همان Query DSL است؟ پاسخ: خیر؛ KQL عبارت فیلتر UI است و JSON Query DSL API جداگانه‌ای دارد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/kql)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20KQL)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


