# Match Query

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 06

## هدف این درس
در این مبحث، Match Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Match query ورودی را با search analyzer تحلیل می‌کند و tokenها را بر اساس operator/minimum_should_match ترکیب می‌کند. برای title/description متن طبیعی استفاده کن. وقتی query شامل چند واژه است، operator=or ممکن است سندی با یک واژه هم برگرداند؛ operator=and سخت‌گیرتر است.

~~~http
POST /products-v1/_search
{"query":{"match":{"title":{"query":"کیبورد مکانیکی بی‌صدا","operator":"and"}}}}
~~~
تمرین: همان عبارت را با or، and و minimum_should_match مقایسه کن. نتیجه به analyzer وابسته است؛ اگر خروجی غیرمنتظره بود Analyze API را ببین و match را به‌جای term روی text قرار بده.

## خودآزمایی
1. match چه تفاوتی با term دارد؟ پاسخ: match ورودی را تحلیل می‌کند و برای full text است؛ term مقدار دقیق را مقایسه می‌کند.
2. operator=and چه تغییری می‌دهد؟ پاسخ: همهٔ tokenهای query باید حاضر باشند؛ recall کمتر و شرط سخت‌تر می‌شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Match%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


