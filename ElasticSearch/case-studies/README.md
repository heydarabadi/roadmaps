# مطالعات موردی و تجربه‌های واقعی

[English version](README.en.md)


بخش نخست شامل صفحه‌های منتشرشده‌ی Elastic درباره‌ی مشتریان است؛ اعداد گزارش vendor هستند و تضمین عملکرد workload دیگر نیستند. در ادامه چند تجربهٔ فنی فارسی از تیم‌ها و نویسندگان جامعه آمده که مستند رسمی یا benchmark مستقل نیستند.

## Anyone.com: ۲۱۰ میلیون رکورد
[صفحه‌ی مشتری Anyone.com](https://www.elastic.co/customers/anyone) می‌گوید backend جست‌وجوی PostgreSQL پس از رشد نیاز کنار گذاشته شد و حدود ۲۱۰ میلیون رکورد طی تقریباً یک‌ونیم هفته به یک index منتقل شد. mapping، صحت داده، ظرفیت، بازسازی، cutover و راه برگشت باید طراحی شوند.

## Canals: retrieval ترکیبی
[صفحه‌ی مشتری Canals](https://www.elastic.co/customers/canals) از افزایش top-3 accuracy گزارش‌شده از ۶۳٪ به ۹۶٪ با ترکیب keyword، dense vector و sparse vector و رتبه‌بندی بعدی می‌گوید. hybrid را روی queryهای قضاوت‌شده ارزیابی و metricهایی مثل NDCG@k، MRR یا Recall@k را ثابت نگه دارید.

## failure modeهای پرتکرار
- mapping پویا و نامحدود باعث mapping explosion می‌شود.
- shard زیاد و کوچک overhead دارد؛ shard خیلی بزرگ recovery را کند می‌کند.
- deep pagination، wildcard گسترده و aggregation پرکاردینال منابع مصرف می‌کنند.
- replica، snapshot و CCR نقش‌های متفاوت دارند.
- میانگین latency به‌تنهایی tail، rejected request و queue را نمی‌بیند.
- boost بدون query و judgment set می‌تواند relevance را بدتر کند.

## تجربه‌های فنی فارسی

این نوشته‌ها تجربهٔ نویسنده یا تیم‌اند، نه مستند رسمی و نه benchmark مستقل.

- [باسلام: محاسبهٔ پویای کمیسیون با Percolate](https://virgool.io/%D8%B1%D8%A7%D9%87%DA%A9%D8%A7%D8%B1-%D9%81%D9%86%DB%8C-%D9%85%D9%82%DB%8C%D8%A7%D8%B3-%D9%BE%D8%B0%DB%8C%D8%B1-%D8%A8%D8%B1%D8%A7%DB%8C-%D9%BE%D8%B4%D8%AA%DB%8C%D8%A8%D8%A7%D9%86%DB%8C-%D8%A7%D8%B2-%D9%BE%D9%88%DB%8C%D8%A7%DB%8C%DB%8C-%DA%AF%D8%B3%D8%AA%D8%B1%D8%AF%D9%87-%DB%8C-%D8%B3%DB%8C%D8%B3%D8%AA%D9%85-%DA%A9%D9%85%DB%8C%D8%B3%DB%8C%D9%88%D9%86-%D8%A8%D8%A7%D8%B3%D9%84%D8%A7%D9%85-percolate-%D8%AF%D8%B1-elasticsearch-flsw9db3da3l) — کاربرد queryهای ذخیره‌شده برای بررسی رویداد سفارش؛ جزئیات API را با مستند جاری Percolator بسنج.
- [مقالهٔ پیاده‌سازی Analyzer برای کاتالوگ فارسی](https://virgool.io/@technotesai/%DA%86%D8%B1%D8%A7-%D8%AC%D8%B3%D8%AA%D8%AC%D9%88%DB%8C-%D9%81%D8%A7%D8%B1%D8%B3%DB%8C-%D8%AF%D8%B1-elasticsearch-%D8%AF%D8%B1%D8%B3%D8%AA-%DA%A9%D8%A7%D8%B1-%D9%86%D9%85%DB%8C-%DA%A9%D9%86%D8%AF-%D9%88-%DA%86%D8%B7%D9%88%D8%B1-%D8%AF%D8%B1%D8%B3%D8%AA%D8%B4-%DA%A9%D9%86%DB%8C%D9%85-dfsaaev7zebh) — نمونهٔ normalization و retrieval فارسی؛ پیکربندی ادعاشده را مستقل و روی queryهای برچسب‌خورده آزمایش کن.
- [روایت مهاجرت آمار ویرگول از MySQL به Elasticsearch](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B2-%D8%A2%D9%85%D8%A7%D8%B1-bzx5mj16lcqb) — نوشتهٔ قدیمی‌تر تیم ویرگول دربارهٔ داده‌های آماری؛ برای ایدهٔ تصمیم‌گیری بخوان، نه نسخهٔ فنی امروز.
- [ادامهٔ تجربهٔ ویرگول دربارهٔ backup](https://virgool.io/virgool/%D8%A7%D8%B2-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-mysql%D8%A7%DB%8C-%D8%A8%D9%87-%D9%88%DB%8C%D8%B1%DA%AF%D9%88%D9%84-elasticsearch%D8%A7%DB%8C-%D9%82%D8%B3%D9%85%D8%AA-%DB%B3-%D8%A2%D8%AE%D8%B1%D8%A7%DB%8C-%D8%AF%D8%A7%D8%B3%D8%AA%D8%A7%D9%86-y9ioyntxpjue) — مفاهیم را با snapshot و restore جاری و یک تمرین بازیابی تطبیق بده.

## منابع مهندسی
- [Index fundamentals](https://www.elastic.co/docs/manage-data/data-store/index-basics)
- [Search tuning](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-search-speed.html)
- [Indexing tuning](https://www.elastic.co/guide/en/elasticsearch/reference/current/tune-for-indexing-speed.html)
- [Cluster troubleshooting](https://www.elastic.co/guide/en/elasticsearch/reference/current/fix-common-cluster-issues.html)
- [Percolator](https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/percolator)

