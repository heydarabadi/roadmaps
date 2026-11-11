# REST API Basics

[English version](README.en.md)


> فصل 01: مبانی و شناخت · درس 03

## هدف این درس
HTTP method، مسیر resource، body و status code را با Console اجرا کن و پاسخ را برای کنترل خطا بخوان.
## تدریس کامل: REST API را چطور بخوانیم؟

درخواست HTTP از method، path، query parameter، header و گاهی body تشکیل می‌شود. Elasticsearch endpointهایی برای ساخت index، نوشتن و خواندن سند، جست‌وجو، bulk و مدیریت cluster دارد. بیشتر bodyها JSON هستند. در Kibana Console خط نخست method و path است و خطوط بعدی بدنه‌ی درخواست را می‌سازند.

### ساخت و خواندن سند

~~~http

PUT /products-v1/_doc/sku-100

{"title":"کیبورد مکانیکی","price":4200000}

~~~

Path می‌گوید سندی با ID برابر sku-100 در index محصولات نوشته شود. پاسخ JSON معمولاً نام index، شناسه، نوع نتیجه و اطلاعات نسخه را برمی‌گرداند. ID ثابت باعث می‌شود retry همان سند را هدف بگیرد. PUT با سند کامل می‌تواند مقدارهای قبلی را جایگزین کند؛ update جزئی معنای دیگری دارد.

~~~http

GET /products-v1/_doc/sku-100

~~~

GET مستقیم سند شناخته‌شده را می‌خواند و به جست‌وجوی full-text وابسته نیست. Search API برعکس، شرط را روی index اجرا می‌کند و سندهای مطابق را برمی‌گرداند.

### متدها و پاسخ

GET معمولاً برای خواندن، PUT برای ساخت/جایگزینی، POST برای search و bulk و DELETE برای حذف به‌کار می‌رود. بعضی endpointها چند method را می‌پذیرند؛ برای query دارای body معمولاً POST سازگاری بیشتری با client و proxy دارد. هم status code و هم JSON پاسخ را بخوان. در Bulk API خود درخواست ممکن است HTTP موفق باشد، درحالی‌که برخی itemها خطا دارند.

### خطایابی درخواست

1. Method، URL، نام index و ID را کنترل کن.
2. Status و error.type و error.reason را بخوان.
3. Mapping و نوع فیلدهای query را بررسی کن.
4. خطای itemهای bulk را جداگانه ثبت کن.
5. timeout را از خطای permission یا mapping جدا کن.
6. درخواست کوچک را در Console اجرا کن تا خطای برنامه از خطای API جدا شود.

در برنامه‌ی واقعی TLS، authentication، timeout و retry هم مهم‌اند. Credential را در source code یا log قرار نده. Retry روی عملیات نوشتن امن‌تر است اگر ID ثابت و عملیات idempotent باشد؛ وگرنه هر retry ممکن است سند تازه‌ای بسازد.

### تمرین

یک سند بساز، با ID بخوان، فیلد قیمت را جزئی تغییر بده و سپس با search پیدایش کن. پاسخ هر مرحله را نگه دار و توضیح بده چرا Get و Search دو عملیات متفاوت‌اند.

### آزمون تشریحی با پاسخ

1. **درخواست HTTP از چه اجزایی تشکیل می‌شود؟** Method، path، query/header و گاهی body.
2. **چرا Bulk را item به item بررسی می‌کنیم؟** بعضی عملیات‌های درون درخواست ممکن است شکست بخورند.
3. **چرا ID پایدار retry را امن‌تر می‌کند؟** تکرار درخواست همان سند را هدف می‌گیرد و ID تازه‌ی تصادفی duplicate نمی‌سازد.


## خودآزمایی
1. PUT و POST در APIهای سند چه تفاوت رایجی دارند؟ پاسخ: PUT با ID معلوم سند کامل را index می‌کند؛ POST می‌تواند ID تولید کند یا update endpoint باشد.
2. چرا فقط status HTTP کافی نیست؟ پاسخ: پاسخ bulk هر item را جدا گزارش می‌کند و باید body/errorها بررسی شود.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/solutions/search/get-started)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20REST%20API%20Basics)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



