# Flattened

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 09

## هدف این درس
در این مبحث، Flattened را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
flattened یک object بزرگ و متغیر را با field mapping محدود index می‌کند؛ برای metadata دلخواه که عمدتاً exact lookup می‌شود مفید است. در عوض قابلیت نوعی و تحلیل پیشرفتهٔ هر subfield محدود است و جای mapping واضح برای عدد/تاریخ‌های مهم را نمی‌گیرد.

~~~json
{"properties":{"labels":{"type":"flattened"}}}
~~~
تمرین: هزار کلید metadata آزمایشی وارد کن و آن را با dynamic mapping مقایسه کن؛ تعداد mapped fields را ببین. فیلدهای پرتکرار و کلیدی را جداگانه explicit تعریف کن تا range و aggregation قابل‌اتکا داشته باشند.

## خودآزمایی
1. flattened چه مشکلی را حل می‌کند؟ پاسخ: از ساخت mapping field جداگانه برای هزاران کلید نامعلوم جلوگیری می‌کند.
2. محدودیت چیست؟ پاسخ: leafها نوع اختصاصی و قابلیت کامل text/number/date ندارند؛ برای فیلدهای مهم mapping صریح بهتر است.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Flattened)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


