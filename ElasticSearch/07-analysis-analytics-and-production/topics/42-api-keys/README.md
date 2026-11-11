# API Keys

[English version](README.en.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 42

## هدف این درس
در این مبحث، API Keys را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
API key هویت/مجوز برنامه‌ای را برای درخواست‌ها فراهم می‌کند و می‌تواند privilegeهای مشخص و expiration داشته باشد. secret فقط هنگام ساخت آشکار می‌شود؛ آن را در secret manager ذخیره، به مخزن یا log نبر، expiry و rotation تنظیم و در زمان خروج revoke کن.

~~~http
POST /_security/api_key
{"name":"catalog-reader","expiration":"30d","role_descriptors":{"reader":{"indices":[{"names":["products-*"],"privileges":["read"]}]}}}
~~~
پاسخ encoded key را محرمانه نگه‌دار. تمرین: دو key بساز، مصرف‌کننده را به key تازه منتقل و قدیمی را با پایش revoke کن. API keyها همهٔ انواع credentials در Elastic را پوشش نمی‌دهند؛ نوع deployment و مجوز لازم را چک کن.

## خودآزمایی
1. API key چه کاربردی دارد؟ پاسخ: credential برنامه‌ای برای احراز/اعطای دسترسی محدود به Elasticsearch.
2. چرا expiration و rotation مهم‌اند؟ پاسخ: پنجرهٔ سوءاستفاده از secret افشاشده را کم می‌کنند؛ جایگزینی را بدون downtime تمرین کن.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/api-keys/elasticsearch-api-keys)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20API%20Keys)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


