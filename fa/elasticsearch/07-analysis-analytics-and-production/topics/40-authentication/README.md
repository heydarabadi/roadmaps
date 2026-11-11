# Authentication

[English version](../../../../../en/elasticsearch/07-analysis-analytics-and-production/topics/40-authentication/README.md)


> فصل 07: تحلیل، تجمیع و عملیات تولید · درس 40

## هدف این درس
در این مبحث، Authentication را با سازوکار، مثال عملی، محدودیت و تمرین همان موضوع یاد می‌گیری. پاسخ‌های آزمونک پس از درس آمده‌اند.

## تدریس کامل
Authentication پاسخ می‌دهد «چه کسی هستی؟» و با native realm، OIDC/LDAP/SAML یا روش deployment پشتیبانی‌شده انجام می‌شود. Authorization پاسخ می‌دهد «چه کاری مجاز است؟» و به role/privilege وابسته است. TLS هویت کانال و محرمانگی را نیز حفاظت می‌کند.

~~~http
GET /_security/_authenticate
~~~
در پاسخ هویت effective request را بررسی کن. تمرین: درخواست بدون credentials و با user کم‌دسترسی را مقایسه کن. Security را در production خاموش نکن، endpoint را عمومی نگذار و credential را در log یا client ناامن قرار نده.

## خودآزمایی
1. authentication و authorization چه تفاوتی دارند؟ پاسخ: اولی هویت را تأیید می‌کند؛ دومی مجوز عمل/داده را تعیین می‌کند.
2. cluster ناامن روی اینترنت چه ریسکی دارد؟ پاسخ: هر دسترسی شبکه‌ای ممکن است داده را بخواند، تغییر دهد یا حذف کند.

## منابع
- انگلیسی: [مرجع رسمی Elasticsearch](https://www.elastic.co/docs/deploy-manage/users-roles/cluster-or-deployment-auth/user-authentication)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Authentication)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)

## معیار تسلط
مفهوم را با یک مثال از همین درس توضیح بده، یک کاربرد یا محدودیت را نام ببر و آزمونک را بدون نگاه به پاسخ حل کن.


