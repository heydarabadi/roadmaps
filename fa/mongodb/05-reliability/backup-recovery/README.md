# Backup و Recovery

> **English edition:** [Read this lesson in English](../../../../en/mongodb/05-reliability/backup-recovery/README.md).

> **هدف یادگیری:** RPO/RTO تعیین کنید و restore را واقعاً آزمایش کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: برنامهٔ Backup قابل‌بازیابی

Backup وقتی مفید است که بتوانید در زمان هدف سرویس را برگردانید. ابتدا دو هدف را تعریف کنید:
- RPO: چه مقدار داده یا چه بازه‌ای را می‌توان از دست داد؟
- RTO: چند دقیقه/ساعت برای بازگشت سرویس فرصت داریم؟

### روش‌ها

mongodump خروجی منطقی BSON تولید می‌کند و برای انتقال/پشتیبان‌گیری اندازهٔ مناسب کاربردی است. mongorestore آن را وارد می‌کند. برای حجم بزرگ، شاردینگ، point-in-time recovery یا هدف RPO کوچک‌تر ممکن است snapshot مدیریت‌شده، continuous backup یا راهکار دیگری لازم باشد. replication جای backup نیست؛ حذف اشتباه هم replicate می‌شود.

### Backup policy

سند سیاست باید مشخص کند:
- تناوب و نگهداری نسخه.
- محل جدا از failure domain اصلی.
- رمزگذاری و دسترسی محدود.
- مالک job و alert شکست.
- زمان مورد انتظار restore.
- اثر عملیات backup بر load.
- روش بازیابی collection، database یا کل deployment.

### Restore drill

1. نسخهٔ backup را از محل نگهداری دریافت کنید.
2. به محیط جدا restore کنید.
3. تعداد سند و index را مقایسه کنید.
4. برنامه را روی دادهٔ بازیابی‌شده بالا بیاورید.
5. queryهای حیاتی را اجرا کنید.
6. زمان واقعی و هر مشکل را ثبت کنید.
7. runbook و RPO/RTO را اصلاح کنید.

### mongodump و خطرات

URI را از secret بگیرید؛ password را در shell history نگذارید. Database Tools را با server version سازگار کنید. dump از deployment فعال و مخصوصاً cluster شاردشده نیازمند آگاهی از consistency است. در production از مستندات version-specific و backup policy سازمان پیروی کنید.

## آموزش
RPO حداکثر دادهٔ قابل‌قبول برای از دست‌رفتن و RTO زمان هدف بازگرداندن سرویس است. mongodump/mongorestore برای dump منطقی کاربرد دارند؛ cluster بزرگ یا sharded ممکن است به snapshot هماهنگ یا backup مدیریت‌شده نیاز داشته باشد.

Backup باید زمان‌بندی، encryption، دسترسی محدود، محل جدا، retention، پایش شکست و آزمون restore داشته باشد. موفقیت backup job اثبات بازیابی نیست. پس از restore تعداد سند، user، index، نسخه و رفتار برنامه را بررسی کنید. سازگاری Database Tools و server را کنترل کنید.

## مثال
~~~bash
mongodump --uri="$MONGODB_URI" --out=./backup
mongorestore --uri="$RESTORE_URI" ./backup
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
مطالعهٔ موردی Victoria’s Secret از خودکارسازی backup در Atlas یاد می‌کند. این تجربه مربوط به همان شرکت و زمان انتشار است؛ restore test مطابق RPO/RTO شما معیار عملی است.

## خطاهای رایج
- تکیه بر replication به عنوان تنها backup.
- نسخه در همان server بدون حفاظت.
- نداشتن restore test.
- افشای URI در shell history.

## تمرین
1. RPO/RTO یک فروشگاه را مشخص و روش backup انتخاب کنید.
2. چک‌لیست restore با validation داده و تست API بنویسید.

## آزمون و پاسخ
1. **پرسش:** RPO چیست؟
   **پاسخ:** حداکثر داده‌ای که می‌توان پذیرفت از دست برود.
2. **پرسش:** RTO چیست؟
   **پاسخ:** حداکثر زمان هدف بازگرداندن سرویس.
3. **پرسش:** چرا restore test لازم است؟
   **پاسخ:** خرابی backup، مجوز و وابستگی را آشکار می‌کند.
4. **پرسش:** چرا باید از «تکیه بر replication به عنوان تنها backup.» پرهیز کرد؟
   **پاسخ:** backup بی‌آزمون ممکن است قابل restore نباشد؛ فقط restore test نشان می‌دهد هدف بازیابی برآورده شده است.
5. **مسئلهٔ کاربردی:** RPO/RTO یک فروشگاه را مشخص و روش backup انتخاب کنید.
   **پاسخ نمونه:** RPO/RTO را تعریف کنید، dump یا backup مناسب توپولوژی بگیرید، سپس در محیط جدا restore و تعداد سند، index و مسیر برنامه را بررسی کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** RPO چیست؟
   **پاسخ:** حداکثر داده/زمان قابل‌قبول برای از دست‌رفتن.
7. **پرسش:** RTO چیست؟
   **پاسخ:** زمان هدف برای بازگرداندن سرویس.
8. **پرسش:** چرا restore drill مهم است؟
   **پاسخ:** فقط بازیابی واقعی process و وابستگی‌هایش را ثابت می‌کند.
9. **پرسش:** Backup کجا باید نگهداری شود؟
   **پاسخ:** با حفاظت و failure domain جدا از دادهٔ اصلی.
10. **پرسش:** mongodump همیشه مناسب شارد بزرگ است؟
   **پاسخ:** نه لزوماً؛ consistency، حجم و topology را بررسی کنید.

## منابع فارسی
- [Backup و Restore در دورهٔ فارسی](https://darsman.com/course/aggregation-operations-in-mongodb/)
- [مسیر فارسی MongoDB](https://www.urhoba.net/fa/series/mongodb-rehberi)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [مطالعهٔ موردی Victoria’s Secret](https://www.mongodb.com/solutions/customer-case-studies/victorias-secret)
- [mongodump](https://www.mongodb.com/docs/database-tools/mongodump/)
- [mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/)
- [Backup Methods](https://www.mongodb.com/docs/manual/core/backups/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#reliability-replication) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
