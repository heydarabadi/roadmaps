# پروژه‌ی پایانی: جست‌وجوی کاتالوگ فروشگاه

[English version](README.en.md)


دیتابیس برنامه منبع حقیقت بماند؛ Elasticsearch projection جست‌وجویی و قابل بازسازی است.

## مراحل
1. نیاز جست‌وجو را مشخص کن: فارسی، SKU، فیلتر، sort، faceting و freshness.
2. products-v1 را با mapping صریح بساز؛ title را text و نسخه‌ی exact را multi-field keyword کن.
3. حداقل ۲۰ کالا با قیمت عددی، دسته، موجودی، زمان و متن فارسی/لاتین وارد کن.
4. Bulk API را با batch محدود اجرا و خطای هر item را ثبت کن.
5. match، filter، highlight، source filtering و aggregation بنویس.
6. برای صفحه‌ی عمیق search_after و sort پایدار طراحی کن.
7. mapping را در products-v2 تغییر بده، reindex و صحت/شمارش را کنترل و alias را عوض کن.
8. relevance را با queryهای ارزیابی و NDCG@k یا Recall@k بسنج.
9. runbook تولید شامل alert، disk/heap، role محدود، ILM، snapshot و restore بنویس.

## معیار تکمیل
Retry سند تکراری نمی‌سازد؛ قیمت و تاریخ type مناسب دارند؛ filter بی‌جهت score نمی‌سازد؛ migration و rollback روشن‌اند؛ متن فارسی با نیم‌فاصله، اعداد و شکل حروف ارزیابی شده است. benchmark فرضی را نتیجه‌ی واقعی معرفی نکن.

