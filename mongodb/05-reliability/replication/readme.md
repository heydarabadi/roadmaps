# Replica Set و failover

> **English edition:** [Read this lesson in English](../../en/05-reliability/replication/readme.md).

> **هدف یادگیری:** نقش primary/secondary و اثر election و replication lag را بشناسید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: ساختار و failover Replica Set

Replica set گروهی از processهای MongoDB است که یک dataset را تکثیر می‌کنند. Primary writeهای عادی را می‌پذیرد و عملیات موفق را در oplog ثبت می‌کند. Secondaryها oplog را می‌خوانند و اعمال می‌کنند. اگر primary unreachable شود، اعضای واجد شرایط election انجام می‌دهند تا primary تازه انتخاب شود.

### Election چه معنایی برای برنامه دارد؟

زمان election ممکن است چند ثانیه write شکست بخورد یا timeout شود. Driver باید URI replica set یا SRV داشته باشد تا topology را بشناسد و primary جدید را کشف کند. اتصال مستقیم ثابت به یک node رفتار failover را مختل می‌کند. برنامه باید timeout، retry و خطاهای پاسخ را مدیریت کند.

### Secondary read

read preference می‌تواند بعضی readها را به secondary بفرستد و بار primary را کم کند، اما ممکن است داده عقب‌مانده باشد. برای صفحه‌ای که کاربر بلافاصله پس از خرید به‌روزرسانی می‌بیند، read-your-writes مهم است. برای گزارش‌های کم‌حساسیت، خواندن از secondary شاید پذیرفتنی باشد.

### Memberها، رأی و شبکه

Primary election به رأی اعضا و connectivity وابسته است. همگی را در یک ماشین یا failure domain گذاشتن از قطع کل ناحیه محافظت نمی‌کند. اعضای دوردست latency و lag دارند. Priority، votes، arbiter و region placement را از مستندات topology خودتان طراحی کنید؛ تنظیم نمونه را کورکورانه کپی نکنید.

### Monitor و Recovery

پایش کنید:
- member state و election count.
- replication lag و oplog window.
- connection failures و primary availability.
- storage, CPU, disk latency.
- backup success و restore drill.

Replication availability فراهم می‌کند؛ حذف اشتباه هم replicate می‌شود. Backup مستقل و آزمون restore لازم است.

## آموزش
Replica set اعضایی دارد که یک داده را نگه می‌دارند. primary write می‌پذیرد و secondaryها تغییرهای oplog را دنبال می‌کنند. اگر primary از دسترس خارج شود، election می‌تواند عضو جدیدی انتخاب کند؛ هنگام جابه‌جایی ممکن است write موقتاً خطا دهد. Driver با topology-aware URI می‌تواند عضو سالم انتخاب کند.

خواندن از secondary ممکن است stale باشد. read preference و read concern را با نیاز برنامه هماهنگ کنید. replication، backup نیست؛ حذف اشتباه را نیز تکثیر می‌کند. replication lag و failover را پایش و در محیط کنترل‌شده تمرین کنید.

## مثال
~~~javascript
rs.status()
rs.conf()
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
طراحی چندمنطقه‌ای باید latency، failure domain، RPO/RTO و رفتار election را در نظر بگیرد. عضو دوردست می‌تواند lag را افزایش دهد؛ یک region دوم صرفاً با اضافه‌کردن node طراحی نمی‌شود.

## خطاهای رایج
- ثانویه را backup فرض کنید.
- خواندن stale را بدون آگاهی بپذیرید.
- همهٔ رأی‌دهندگان در یک failure domain.
- نبود هشدار lag.

## تمرین
1. نمودار سه‌عضوی replica set را رسم کنید.
2. برای فهرست محصول و موجودی پرداخت read policy جدا پیشنهاد دهید.

## آزمون و پاسخ
1. **پرسش:** primary چه می‌کند؟
   **پاسخ:** writeها را می‌پذیرد.
2. **پرسش:** secondary از چه چیزی پیروی می‌کند؟
   **پاسخ:** oplog.
3. **پرسش:** replication جای backup است؟
   **پاسخ:** خیر؛ تغییر نامطلوب هم تکثیر می‌شود.
4. **پرسش:** چرا باید از «ثانویه را backup فرض کنید.» پرهیز کرد؟
   **پاسخ:** replication تغییر نامطلوب را نیز تکثیر می‌کند؛ نسخهٔ پشتیبان مستقل و restore test لازم است.
5. **مسئلهٔ کاربردی:** نمودار سه‌عضوی replica set را رسم کنید.
   **پاسخ نمونه:** primary write را می‌پذیرد و secondary oplog را دنبال می‌کند؛ failover را با driver topology-aware تمرین کنید و backup را جدا نگه دارید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Primary چه کار می‌کند؟
   **پاسخ:** writeهای عادی را می‌پذیرد.
7. **پرسش:** Secondary چگونه تغییرها را می‌گیرد؟
   **پاسخ:** oplog را دنبال و اعمال می‌کند.
8. **پرسش:** Election چه وقت می‌شود؟
   **پاسخ:** وقتی primary از دسترس خارج شود یا وضعیت topology نیاز به انتخاب داشته باشد.
9. **پرسش:** Secondary read چه ریسکی دارد؟
   **پاسخ:** ممکن است دادهٔ عقب‌مانده بخواند.
10. **پرسش:** Replication backup است؟
   **پاسخ:** خیر؛ حذف بد نیز تکثیر می‌شود.

## منابع فارسی
- [Replica Set به فارسی](https://www.urhoba.net/fa/post/mongodb-6)
- [Replication در مقالهٔ فارسی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Replication](https://www.mongodb.com/docs/manual/replication/)
- [Replica Set Elections](https://www.mongodb.com/docs/manual/core/replica-set-elections/)
- [Read and Write Semantics](https://www.mongodb.com/docs/manual/applications/replication/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#reliability-replication) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
