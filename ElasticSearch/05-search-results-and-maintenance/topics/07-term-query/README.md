# Term Query

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 07

## هدف این درس
در این مبحث، Term Query را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Term query مقدار دقیقی را با termهای indexشده مقایسه می‌کند و query input را full-text analyze نمی‌کند. برای category keyword، status، ID و Boolean مفید است؛ برای متن جست‌وجوی طبیعی از match استفاده کن.

~~~http
POST /products-v1/_search
{"query":{"term":{"status":"active"}}}
~~~
اگر keyword normalizer دارد، مقدار ورودی باید با رفتار normalization سازگار شود. تمرین: همین query را روی title=text و title.keyword اجرا و نتیجه‌ها را توضیح بده. خطای رایج استفاده از term با جملهٔ کامل روی فیلد تحلیل‌شده است.

## خودآزمایی
1. term روی چه fieldی مناسب است؟ پاسخ: keyword، عدد، Boolean و date با مقدار دقیق/نرمال‌شده.
2. چرا term روی text خطاست؟ پاسخ: متن تحلیل و به token شکسته می‌شود؛ مقایسه با کل رشته آنچه انتظار می‌رفت نیست.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Term%20Query)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


