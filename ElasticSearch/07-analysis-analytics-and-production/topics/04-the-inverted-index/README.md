# The Inverted Index

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 04

## هدف این درس
در این مبحث، The Inverted Index را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
وقتی سند index می‌شود، analyzer tokenهایی می‌سازد؛ inverted index برای هر term فهرست سندهای حاوی آن را نگه می‌دارد. جست‌وجوی واژه به‌جای پیمایش همهٔ متن‌ها، postingهای term را ترکیب می‌کند. term frequency، position و metadata لازم می‌توانند برای query و relevance استفاده شوند.

~~~text
سند 1: elastic search  → elastic:[1], search:[1]
سند 2: elastic cluster → elastic:[2], cluster:[2]
~~~
برای query دو term، سیستم postingها را با منطق query ترکیب می‌کند. تمرین: کلمات جملهٔ نمونه را دستی token و posting کن. حذف سندها ابتدا tombstone است و فضای segment بعداً با merge آزاد می‌شود.

## خودآزمایی
1. inverted index از چه به چه می‌رود؟ پاسخ: از term به posting list اسنادی که آن term را دارند، گاهی همراه موقعیت/اطلاعات کمکی.
2. چرا متن اصلی از روی آن به‌سادگی بازسازی نمی‌شود؟ پاسخ: تحلیل‌گر ممکن است حروف/ترتیب/stopword را حذف یا normalize کرده باشد.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/manage-data/data-store/text-analysis)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20The%20Inverted%20Index)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


