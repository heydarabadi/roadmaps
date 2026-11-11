# Roles & Users

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 41

## هدف این درس
در این مبحث، Roles & Users را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
User هویت انسان یا سرویس است؛ role مجموعهٔ مجوزهاست و با mapping به user داده می‌شود. privilege را به cluster action و index pattern لازم محدود کن؛ read-only service نباید write/delete یا manage_security داشته باشد. تغییر role و rotation را با owner و audit مدیریت کن.

~~~http
PUT /_security/role/catalog_reader
{"indices":[{"names":["products-*"],"privileges":["read","view_index_metadata"]}]}
~~~
این نمونه فقط خواندن indexهای محصول را می‌دهد. تمرین: نقش indexer با write محدود و role dashboard با read بساز؛ عملیات مجاز/ردشده را تست کن. password را در secret manager نگه‌دار و از حساب انسانی مشترک استفاده نکن.

## خودآزمایی
1. role چه تعریف می‌کند؟ پاسخ: privilegeهای cluster/index و در صورت تنظیم محدودیت document/field برای user/service.
2. چرا superuser برنامه خطرناک است؟ پاسخ: compromise سرویس به کنترل کل داده و عملیات تبدیل می‌شود؛ privilege حداقلی blast radius را کم می‌کند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/user-roles)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Roles%20%26%20Users)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


