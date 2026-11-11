# Histogram

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 14

## هدف این درس
در این مبحث، Histogram را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Histogram aggregation دادهٔ عددی را در bucketهایی با فاصلهٔ ثابت دسته‌بندی می‌کند؛ date_histogram برای زمان و calendar interval/fixed interval فرق دارد. مقدار مرزی و bucketهای خالی باید با نیاز نمودار سازگار باشند.

~~~http
POST /orders-v1/_search
{"size":0,"aggs":{"price_hist":{"histogram":{"field":"total","interval":1000000,"min_doc_count":0}}}}
~~~
عدد interval باید با واحد پول خوانا باشد. تمرین: نمودار را با فاصلهٔ 100هزار و 1میلیون بساز و تعداد bucket و تفسیر business را مقایسه کن. min_doc_count=0 می‌تواند bucket خالی بسازد و پاسخ را بزرگ کند.

## خودآزمایی
1. histogram چه می‌کند؟ پاسخ: bucketهای عددی با interval یکنواخت می‌سازد.
2. interval را چطور انتخاب می‌کنی؟ پاسخ: بر اساس واحد کسب‌وکار و تعداد bucket قابل‌خواندن؛ interval خیلی ریز نتیجهٔ پرنویز و پرحجم می‌دهد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/reference/aggregations/search-aggregations-bucket-histogram-aggregation)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Histogram)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


