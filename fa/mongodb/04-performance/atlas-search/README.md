# Atlas Search

> **English edition:** [Read this lesson in English](../../../../en/mongodb/04-performance/atlas-search/README.md).

> **هدف یادگیری:** جست‌وجوی ساده را از موتور Search کامل جدا کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: ساخت تجربهٔ جست‌وجو

Search برابری/بازه با index معمولی یک نیاز است؛ جست‌وجوی متن آزاد، رتبه‌بندی relevance، autocomplete و typo tolerance نیاز دیگری‌اند. Atlas Search در Atlas index جداگانه با mapping و analyzer می‌سازد و $search در pipeline query اجرا می‌کند.

### Mapping و analyzer

Mapping تعیین می‌کند کدام fieldها چگونه index شوند: text، keyword، autocomplete، number، date یا nested. Analyzer متن را به token تبدیل می‌کند. برای فارسی باید شکل‌های ی/ک، نیم‌فاصله، پسوندها، ترکیب فارسی/لاتین و typoهای رایج را با query واقعی بسنجید. تست با چند عبارت کافی نیست؛ مجموعه‌ای از queryهای موفق و ناموفق بسازید و نتایج مورد انتظار را ثبت کنید.

### Score و صفحهٔ نتیجه

Search score میزان relevance را برای ranking به کار می‌گیرد، اما score به معنی درست‌بودن پاسخ نیست. فیلترهای قطعی مثل active:true و tenantId را نیز در query بگذارید. خروجی را limit و fieldهای لازم را project کنید. relevance sort و sort دامنه‌ای ممکن است نیازمند طراحی جدا باشند.

### مراحل پروژه

1. تعریف تجربه: exact SKU، جست‌وجوی عنوان، autocomplete یا facet؟
2. نوشتن queryهای نمونه و نتیجهٔ مطلوب.
3. ساخت Search index مطابق mapping.
4. اجرای query و بررسی score.
5. بررسی زبان، pagination، مجوز tenant و latency.
6. پایش index freshness و هزینه.

Atlas Search به deployment و قابلیت Atlas وابسته است. اگر search engine خارجی دارید، هزینهٔ sync، consistency و بازسازی index را با وابستگی به Atlas مقایسه کنید.

## آموزش
Index عادی برای equality، range و sort است؛ text index کلاسیک امکانات محدودتری دارد. Atlas Search در Atlas بر پایهٔ Lucene، analyzer و mapping دارد و قابلیت‌هایی مانند autocomplete، fuzzy search، facet و relevance scoring فراهم می‌کند.

برای فارسی، نرمال‌سازی ی/ک، نیم‌فاصله و tokenizer را با متن واقعی ارزیابی کنید؛ analyzer انگلیسی را مناسب فرض نکنید. سرویس و قابلیت‌ها به deployment وابسته‌اند. هزینهٔ موتور جدا و sync داده را با وابستگی Atlas مقایسه کنید.

## مثال
~~~javascript
db.products.aggregate([
  { $search: { text: { query: "صفحه کلید بی‌سیم", path: "title" } } },
  { $limit: 10 },
  { $project: { title: 1, score: { $meta: "searchScore" } } }
])
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
Forbes در زمان انتشار case study اعلام کرده بود قصد دارد از Solr به Atlas Search برود. این گزارش برنامهٔ همان زمان است و وضعیت فعلی را اثبات نمی‌کند.

## خطاهای رایج
- فرض سازگاری analyzer انگلیسی با فارسی.
- fuzzy روی هر فیلد.
- یکی گرفتن text index و Atlas Search.
- تعمیم مطالعهٔ قدیمی به وضعیت امروز.

## تمرین
1. برای جست‌وجوی فارسی محصول queryهای آزمون بسازید.
2. autocomplete و جست‌وجوی دقیق SKU را جدا طراحی کنید.

## آزمون و پاسخ
1. **پرسش:** Atlas Search چیست؟
   **پاسخ:** موتور search در Atlas با index و query مختص خود.
2. **پرسش:** با index عادی یکی است؟
   **پاسخ:** خیر.
3. **پرسش:** چرا analyzer فارسی آزمایش شود؟
   **پاسخ:** توکن‌سازی نتیجه را تغییر می‌دهد.
4. **پرسش:** چرا باید از «فرض سازگاری analyzer انگلیسی با فارسی.» پرهیز کرد؟
   **پاسخ:** تنظیم نامتناسب نتیجهٔ جست‌وجوی ضعیف یا هزینهٔ بالا می‌دهد؛ analyzer و mapping را با متن واقعی و نیاز relevance آزمایش کنید.
5. **مسئلهٔ کاربردی:** برای جست‌وجوی فارسی محصول queryهای آزمون بسازید.
   **پاسخ نمونه:** در Atlas برای fieldهای فارسی analyzer مناسب را ارزیابی کنید؛ SKU را دقیق و title را متنی index کنید و نتیجه را با queryهای واقعی بسنجید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Atlas Search با B-tree index یکی است؟
   **پاسخ:** خیر؛ index و query engine جداگانه دارد.
7. **پرسش:** Analyzer چه می‌کند؟
   **پاسخ:** متن را برای indexing و matching به token تبدیل می‌کند.
8. **پرسش:** Search score چه چیزی را تضمین نمی‌کند؟
   **پاسخ:** درستی business نتیجه را؛ score فقط relevance تخمینی است.
9. **پرسش:** چرا analyzer فارسی را می‌آزماییم؟
   **پاسخ:** نیم‌فاصله، حروف و tokenization بر نتیجه اثر دارند.
10. **پرسش:** چرا tenantId را فیلتر می‌کنیم؟
   **پاسخ:** برای رعایت مرز دسترسی و محدودسازی نتایج tenant.

## منابع فارسی
- [Atlas و search در راهنمای فارسی](https://www.urhoba.net/fa/post/mongodb-atlas)
- [مقالهٔ MongoDB فارسی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Atlas Search](https://www.mongodb.com/docs/atlas/atlas-search/)
- [Search Tutorials](https://www.mongodb.com/docs/atlas/atlas-search/tutorial/)
- [Text Index](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-text/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#performance-search) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
