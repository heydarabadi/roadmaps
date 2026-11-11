# ES|QL

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 16

## هدف این درس
در این مبحث، ES|QL را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
ES|QL داده را مرحله‌به‌مرحله از منبع می‌خواند، فیلتر، محاسبه، گروه‌بندی و مرتب می‌کند؛ برای کاوش و تحلیل tabular ذهنیت SQL+pipe می‌دهد. هر مرحله ورودی/خروجی مرحلهٔ قبل را تغییر می‌دهد، پس ترتیب WHERE، EVAL، STATS و SORT مهم است.

~~~text
FROM products-v1 | WHERE available == true AND price < 5000000 | STATS avg(price) BY brand | SORT avg(price) DESC
~~~
نام فیلد و syntax را با نسخهٔ نصب‌شده تطبیق بده. تمرین: همین تحلیل را با Query DSL aggregation بنویس و تفاوت خوانایی، قابلیت‌ها و مصرف را مقایسه کن. ES|QL و Query DSL دو سطح یکسان و کاملاً جایگزین نیستند.

## خودآزمایی
1. ES|QL چه مدل نوشتاری دارد؟ پاسخ: pipeline با مراحل متصل‌شده به `|` مانند FROM، WHERE، STATS و SORT.
2. آیا جایگزین تمام APIهای Query DSL است؟ پاسخ: نه؛ قابلیت و نسخه را بررسی کن و برای APIهای جست‌وجوی اپلیکیشن ممکن است DSL مناسب‌تر باشد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/esql)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20ES%7CQL)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


