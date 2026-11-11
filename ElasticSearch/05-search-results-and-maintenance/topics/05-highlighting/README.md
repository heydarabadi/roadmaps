# Highlighting

[English version](README.en.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 05

## هدف این درس
در این مبحث، Highlighting را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Highlighting اطراف termهای مطابق‌شده fragment می‌سازد تا UI محل match را برجسته کند. انتخاب type و field به analyzer، اندازهٔ محتوا و نیاز بستگی دارد؛ highlight ممکن است خود متن ذخیره‌شده را بازسازی کند و تمام واژه‌های معادل را نیابد.

~~~http
POST /products-v1/_search
{"query":{"match":{"description":"صدای شفاف"}},"highlight":{"fields":{"description":{"fragment_size":120,"number_of_fragments":2}}}}
~~~
تمرین: query فارسی و متن دارای نیم‌فاصله اجرا و snippet را ارزیابی کن. Fragment را برای HTML ناامن فرض کن؛ خروجی را escape کن و هزینهٔ highlight را روی سندهای بلند بسنج.

## خودآزمایی
1. Highlighting چه اطلاعاتی می‌دهد؟ پاسخ: fragmentهای مرتبط با query را علامت‌گذاری می‌کند.
2. آیا highlight proof ارتباط یا HTML امن است؟ پاسخ: نه؛ snippet ممکن است کامل نباشد و ورودی باید هنگام render escape شود.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Highlighting)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


