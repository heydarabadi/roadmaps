# Elastic Cloud

[English version](README.en.md)


> فصل 02: Mapping و مدل‌سازی داده · درس 11

## هدف این درس
Elastic Cloud مدیریت زیرساخت Elasticsearch را ارائه می‌دهد؛ هزینه، region، security، نسخه و topology را قبل از ایجاد deployment بسنج.
## Elastic Cloud و سرویس مدیریت‌شده

### Elastic Cloud و سرویس مدیریت‌شده
Elastic Cloud محیط مدیریت‌شده برای deploymentهای Elastic است. مدیریت زیرساخت را ساده می‌کند اما طراحی index، mapping، query، دسترسی، ظرفیت، هزینه و recovery همچنان بر عهده‌ی تیم محصول است.
پیش از ساخت deployment منطقه، نیاز شبکه، identity، TLS، data tier، snapshot، ظرفیت و رشد را مشخص کن. هزینه را با بار واقعی و retention بسنج؛ cluster بزرگ‌تر فقط برای حل query بد همیشه پاسخ مناسبی نیست. برنامه‌ی upgrade و compatibility client را هم بررسی کن.
برای اتصال برنامه secret را در secret manager نگه دار و API key اختصاصی با دسترسی محدود بساز. endpoint ابری و credential را در فایل public یا frontend قرار نده. خطای رایج، فرض این است که managed service خودبه‌خود backup، disaster recovery و least privilege را تضمین می‌کند.


## خودآزمایی
1. سرویس مدیریت‌شده چه مسئولیتی را کم می‌کند؟ پاسخ: بخشی از provisioning/maintenance، نه مسئولیت schema، هزینه و backup validation.
2. قبل از production چه چیزی را راستی‌آزمایی می‌کنی؟ پاسخ: region، access, network, snapshots, sizing, feature/license و SLO.
## منابع
- انگلیسی: [مستندات رسمی فصل](https://www.elastic.co/docs/manage-data/data-store/mapping)
- فارسی: [جست‌وجوی موضوعی مقاله‌های فارسی](https://www.google.com/search?q=%D8%A2%D9%85%D9%88%D8%B2%D8%B4%20%D9%81%D8%A7%D8%B1%D8%B3%DB%8C%20Elasticsearch%20Elastic%20Cloud)
- [مقاله‌ی مقدماتی نصب Elasticsearch](https://nadinsoft.com/راهکار-نصب-الستیک-سرچ-elasticsearch-و-4-مزیت-آن/)
- [کتابخانهٔ منابع فارسی](../../../references/README.md)
- [ParsiAnalyzer؛ تحلیل فارسی](https://github.com/NarimanN2/ParsiAnalyzer)



