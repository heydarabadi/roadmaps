# Document (Row)

[English version](../../../../../en/elasticsearch/02-mappings-and-data-model/topics/08-document-row/README.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 08

## هدف این درس
Document یک رکورد JSON مستقل است و می‌تواند تو‌در‌تو/آرایه‌ای باشد؛ mapping نحوهٔ indexکردن propertyها را تعیین می‌کند.
## Document و شکل رکورد

### Document و شکل رکورد
Document یک object JSON است که داده‌ی یک موجودیت یا رخداد را توصیف می‌کند. هر سند در index یک _id دارد و fieldهای آن مطابق mapping index می‌شوند. سند را براساس queryهای موردنیاز مدل کن: فیلدهای نمایش نتیجه، فیلتر، sort، aggregation و relevance.
Documentها معمولاً denormalized هستند؛ برای نمایش کارت کالا ممکن است نام برند و دسته را در سند کپی کنی تا search query به join نیاز نداشته باشد. در عوض، وقتی برند تغییر می‌کند باید سندهای متاثر را به‌روزرسانی یا index را بازسازی کنی. سندهای بسیار بزرگ، آرایه‌های بی‌نهایت یا nestedهای عمیق به هزینه‌ی query و storage می‌افزایند.
~~~http
PUT /products-v1/_doc/sku-100
{"sku":"sku-100","title":"کیبورد مکانیکی","brand":"نمونه","price":4200000}
~~~
_source معمولاً محتوای ورودی قابل‌بازگشت را نگه می‌دارد؛ inverted index ساختار جداگانه‌ی جست‌وجو است. این دو را یکی ندان. خطای رایج آن است که schema سند را صرفاً mirror دیتابیس بگیرند و نیاز search را مدل نکنند.

## خودآزمایی
1. آیا document باید ثابت و schema-less بماند؟ پاسخ: نه؛ mapping typeهای field را تعیین و ناسازگاری را کنترل می‌کند.
2. document کامل با partial update چه فرقی دارد؟ پاسخ: index سند کامل را جایگزین می‌کند؛ update فقط field/script مشخص را اعمال می‌کند.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Document%20(Row))
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



