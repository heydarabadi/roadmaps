# Controlling Search Results

[English version](../../../../../en/elasticsearch/05-search-results-and-maintenance/topics/01-controlling-search-results/README.md)


> فصل 05: کنترل نتایج و نگهداری داده · درس 01

## هدف این درس
در این مبحث، Controlling Search Results را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
پاسخ Search ترکیبی از انتخاب سند، رتبه، صفحه‌بندی، sort، فیلدهای خروجی و highlight است. پیش از افزودن optionها مشخص کن چه نتیجه‌ای باید دیده شود، چه ترتیب پایداری لازم است و آیا شمارش دقیق مهم است. هر feature payload یا هزینه دارد.

~~~http
POST /products-v1/_search
{"size":10,"track_total_hits":1000,"query":{"bool":{"must":[{"match":{"title":"هدفون"}}],"filter":[{"term":{"available":true}}]}},"_source":["product_id","title","price"],"sort":[{"_score":"desc"},{"product_id":"asc"}]}
~~~
تعداد کل می‌تواند کران‌دار گزارش شود؛ UI را بر اساس دقیق/حداکثر طراحی کن. تمرین: یک پاسخ برای autocomplete و یک export بساز و توضیح بده چرا تنظیماتشان یکسان نیست.

## خودآزمایی
1. کدام بخش نتیجه را محدود و کدام رتبه را می‌سازد؟ پاسخ: filter eligibility را محدود می‌کند؛ query context relevance را امتیازدهی می‌کند.
2. چرا total hitها همیشه دقیق نیست؟ پاسخ: محاسبهٔ دقیق هزینه دارد و tracking می‌تواند محدود شود؛ relation را بخوان.

## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/reference/elasticsearch/rest-apis/search)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Controlling%20Search%20Results)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


