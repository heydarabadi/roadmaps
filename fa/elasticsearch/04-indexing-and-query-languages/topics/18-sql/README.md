# SQL

[English version](../../../../../en/elasticsearch/04-indexing-and-query-languages/topics/18-sql/README.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 18

## هدف این درس
در این مبحث، SQL را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Elasticsearch SQL به کاربر اجازه می‌دهد queryهای SELECT آشنا را روی index اجرا کند و در بعضی کلاینت‌ها از JDBC/ODBC بهره ببرد. این syntax روی search engine توزیع‌شده ترجمه می‌شود؛ join و تراکنش رابطه‌ای عمومی را فرض نکن. پیش از مهاجرت queryهای گزارش، سازگاری functionها و محدودیت نسخه را بررسی کن.

~~~text
SELECT brand, AVG(price) FROM products-v1 WHERE available = true GROUP BY brand ORDER BY AVG(price) DESC
~~~
تمرین: خروجی را با یک terms+avg aggregation مقایسه کن. SQL interface تجربهٔ نوشتن را تغییر می‌دهد، نه ماهیت mapping، shard یا refresh را.

## خودآزمایی
1. Elasticsearch SQL چیست؟ پاسخ: interface با syntax شبیه SQL برای query/تحلیل برخی داده‌های Elasticsearch.
2. چرا معادل پایگاه رابطه‌ای کامل نیست؟ پاسخ: semantics، type، عملیات و مدل توزیع‌شده متفاوت است و بعضی قابلیت‌های SQL محدود/ترجمه می‌شوند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/sql)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20SQL)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


