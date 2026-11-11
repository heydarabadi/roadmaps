# Delete Index

[English version](README.en.md)


> فصل 04: عملیات سند و زبان‌های Query · درس 11

## هدف این درس
در این مبحث، Delete Index را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Delete Index با حذف یک سند یا alias تفاوت دارد و کل resource را پاک می‌کند. نام دقیق بده، wildcard گسترده را رد کن، alias/data stream و مصرف‌کنندگان را بشناس و دادهٔ لازم را پیش از کار backup کن. destructive_requires_name guard مفیدی است اما جای runbook نیست.

~~~http
DELETE /products-sandbox-v1
~~~
فقط محیط آزمایشی و نام تأییدشده. تمرین: اگر برنامه از products-read می‌خواند، بررسی کن حذف backing index چه اثری دارد. در production مالک داده، retention و restore آزموده را مشخص کن؛ صرف وجود snapshot بدون تست restore کافی نیست.

## خودآزمایی
1. Delete Index چه چیزی حذف می‌کند؟ پاسخ: کل index و سندهایش؛ حذف فوری برگشت‌پذیر نیست.
2. پیش از آن چه کنترل‌هایی داری؟ پاسخ: نام دقیق، alias وابسته، مالکیت، retention و snapshot قابل‌بازیابی را بررسی می‌کنم.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/query-languages/query-dsl)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Delete%20Index)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


