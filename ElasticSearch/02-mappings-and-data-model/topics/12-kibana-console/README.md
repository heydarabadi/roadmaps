# Kibana Console

[English version](README.en.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 12

## هدف این درس
Console درخواست‌های REST را در UI اجرا می‌کند و برای یادگیری، دیدن پاسخ و عیب‌یابی سریع مناسب است.
## Kibana Console برای یادگیری و عیب‌یابی

### Kibana Console برای یادگیری و عیب‌یابی
Kibana Console ویرایشگر تعاملی درخواست‌های REST است. هر درخواست با method و path شروع می‌شود و body JSON بعد از آن می‌آید. Console پاسخ، status و خطای API را کنار درخواست نشان می‌دهد. برای آموزش، یک درخواست را اجرا و پاسخ را قبل از تغییر query ذخیره کن.
Console مناسب آزمایش و triage است، اما درخواست‌های production را معمولاً برنامه‌ی version-controlled، client رسمی یا automation اجرا می‌کند. Console دسترسی کاربر Kibana را به cluster می‌دهد، پس role و محیط را بررسی کن.
تمرین: GET /_cluster/health را اجرا کن، سپس mapping یک index آزمایشی بخوان، بعد search ساده اجرا کن. پیش از DELETE یا تغییر template نام cluster و index را تأیید کن. خطای رایج، اجرای فرمان مخرب در tab یا deployment اشتباه است.


## خودآزمایی
1. Console به‌جای چه ابزاری نیست؟ پاسخ: automation قابل‌نسخه‌بندی و client برنامه‌ای.
2. چرا ابتدا روی sandbox اجرا می‌کنی؟ پاسخ: تا حذف/تغییر index تولیدی ناخواسته رخ ندهد.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Kibana%20Console)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



