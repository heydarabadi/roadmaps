# BM25 algorithm

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 22

## هدف این درس
در این مبحث، BM25 algorithm را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
BM25 خانواده‌ای از رتبه‌بندی lexical است. واژهٔ query باید match شود؛ تکرار واژه در سند می‌تواند score را بالا ببرد ولی با اشباع، تکرار بی‌پایان رشد خطی ندارد. واژهٔ نادر معمولاً اطلاعات بیشتری دارد و سند خیلی بلند نسبت به متن کوتاه نرمال می‌شود. پارامترهای k1 و b میزان اشباع و length normalization را کنترل می‌کنند.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":"ضد آب سبک"}},"explain":true}
~~~
Explain فقط برای تحلیل موردی است. تمرین: دو query و چند سند کوتاه/بلند بساز و ترتیب را بررسی کن. BM25 را با labeled query set بسنج؛ score احتمال کیفیت یا معیار مقایسهٔ queryهای متفاوت نیست.

## خودآزمایی
1. BM25 به چه signalهایی توجه می‌کند؟ پاسخ: تطبیق واژه، frequency با اشباع، کمیابی term در corpus و نرمال‌سازی طول سند.
2. `_score=8` یعنی ۸۰٪ احتمال؟ پاسخ: خیر؛ امتیاز نسبی و وابسته به query/index است.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/elasticsearch/index-settings/similarity)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20BM25%20algorithm)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


