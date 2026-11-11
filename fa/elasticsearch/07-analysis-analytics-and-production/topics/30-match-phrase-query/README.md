# Match Phrase Query

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/30-match-phrase-query/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 30

## هدف این درس
در این مبحث، Match Phrase Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Match phrase ورودی را تحلیل می‌کند و sequence tokenهای پیاپی را در فیلد جست‌وجو می‌یابد. positionهای analyzer برای این کار لازم‌اند. `slop` اجازهٔ فاصله/جابجایی محدود می‌دهد؛ صفر تطبیق دقیق‌تری می‌خواهد.

~~~http
POST /products-v1/_search
{"query":{"match_phrase":{"title":{"query":"هدفون بی‌سیم","slop":1}}}}
~~~
تمرین: «هدفون بی‌سیم»، «هدفون خیلی بی‌سیم» و واژه‌های جابه‌جا را بررسی کن. synonym چندواژه‌ای analyzer بر position اثر می‌گذارد؛ synonym graph را در lesson مربوط ببین.

## خودآزمایی
1. match_phrase چه می‌خواهد؟ پاسخ: tokenهای query با همان ترتیب و فاصلهٔ مجاز در متن حاضر باشند.
2. slop بیشتر چه trade-offی دارد؟ پاسخ: phraseهای دورتر بیشتری را match می‌کند؛ recall بالا می‌رود ولی precision می‌تواند کم شود.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/query-languages/query-dsl/query-dsl-match-query-phrase)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Match%20Phrase%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


