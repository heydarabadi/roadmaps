# Autoscaling

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 27

## هدف این درس
در این مبحث، Autoscaling را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Autoscaling ظرفیت node/tier را بر اساس تقاضا و constraints پلتفرم تنظیم می‌کند. باید معلوم باشد metric، حداقل/حداکثر ظرفیت، زمان scale-up/down و deployment پشتیبانی‌شده چیست. هنگام scale، relocation، warm-up cache و rebalance می‌تواند موقتاً بار اضافه کند.

~~~http
GET /_cluster/allocation/explain
~~~
این درخواست دلیل تخصیص نشدن shard را برای عیب‌یابی می‌سنجد. تمرین: رشد ناگهانی storage و query CPU را جداگانه شبیه‌سازی و بررسی کن autoscaling کدام مشکل را پوشش می‌دهد. روی managed/self-managed بودن و قابلیت نسخه تکیهٔ دقیق داشته باش؛ universal setting فرض نکن.

## خودآزمایی
1. autoscaling چه چیزی را حل می‌کند؟ پاسخ: افزایش/کاهش ظرفیت متناسب با بار و policyهای پلتفرم.
2. آیا مشکل query یا shard نامناسب را درمان می‌کند؟ پاسخ: نه؛ ظرفیت ناکارآمد را ممکن است فقط گران‌تر کند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/autoscaling)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Autoscaling)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


