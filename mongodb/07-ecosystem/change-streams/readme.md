# Change Streams و معماری رویدادمحور

> **English edition:** [Read this lesson in English](../../en/07-ecosystem/change-streams/readme.md).

> **هدف یادگیری:** تغییرها را با resume token و handler تکرارپذیر مصرف کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: مصرف درست Change Stream

Change Stream رابط event-driven برای دیدن تغییرهای collection/database/cluster است؛ لازم نیست application مستقیم oplog را بخواند. به topology سازگار مثل replica set یا sharded cluster نیاز دارد. برای هر subscriber filter و projection را محدود کنید تا event اضافی مصرف نشود.

### event چه اطلاعاتی دارد؟

معمولاً operationType، documentKey، namespace و بسته به operation تغییرها یا fullDocument وجود دارد. updateLookup سند فعلی را lookup می‌کند؛ لزوماً سند کامل دقیقاً در لحظهٔ تغییر نیست. اگر audit تاریخی لازم است، event log یا audit مناسب را جدا طراحی کنید.

### Resume token و checkpoint

هر event token دارد که ادامهٔ stream را ممکن می‌کند. مصرف‌کننده باید side effect را durable بنویسد و سپس checkpoint token را ثبت کند؛ اگر اول token ذخیره شود و بعد پردازش شکست بخورد، ممکن است تغییر جا بیفتد. اگر ابتدا side effect و بعد token ثبت شود، duplicate محتمل است؛ بنابراین handler idempotent بسازید.

### Recovery

Resume به باقی‌ماندن oplog لازم وابسته است. اگر outage از window بیشتر شود، token قابل استفاده نیست و snapshot/reconciliation لازم می‌شود. بازگشایی stream با token کهنه را به عنوان recovery کامل فرض نکنید.

### طراحی subscriber

- کلید idempotency: namespace + documentKey + event identity.
- update/delete semantics واضح.
- backpressure و batch handling.
- alert روی lag و reconnect loop.
- checkpoint پایدار.
- resync runbook برای token نامعتبر یا outage طولانی.

## آموزش
Change Streams رابط پشتیبانی‌شده برای دنبال‌کردن تغییرهای collection/database/cluster است و نیاز به tail کردن مستقیم oplog را برطرف می‌کند. معمولاً replica set یا sharded cluster لازم است. eventها را filter کنید. fullDocument:updateLookup ممکن است سند فعلی زمان lookup را بدهد، نه snapshot تاریخی تغییر.

نتیجهٔ side effect را durable کنید و بعد resume token را checkpoint کنید. duplicate event را ممکن بدانید و handler idempotent بسازید. اگر downtime از oplog retention عبور کند، resume شکست می‌خورد و resync لازم است. Change Stream جایگزین audit کامل نیست.

## مثال
~~~javascript
const stream = db.orders.watch(
  [{ $match: { operationType: { $in: ["insert", "update", "replace"] } } }],
  { fullDocument: "updateLookup" }
)
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
برای sync کردن cache محصول، insert/update/delete و duplicate را پوشش دهید. resume token را پس از ثبت موفق نتیجه ذخیره کنید و برای outage طولانی resync داشته باشید.

### تجربهٔ منتشرشده: Ada

در مطالعهٔ موردی MongoDB، شرکت Ada گفته است از Change Streams برای تازه نگه‌داشتن data lake و جریان پردازش رخدادها برای آموزش/تحلیل استفاده می‌کند. درس معماری این است که stream تغییری از منبع حقیقت است؛ مصرف‌کننده باید checkpoint، duplicate، backfill و بازسازی را مدیریت کند. این شرح، روایت رسمی MongoDB از یک مشتری است، نه مقایسهٔ مستقل محصولات. [مطالعهٔ موردی Ada](https://www.mongodb.com/solutions/customer-case-studies/ada)

## خطاهای رایج
- checkpoint پیش از موفقیت side effect.
- فرض snapshot تاریخی.
- نبود resync.
- استفاده به‌جای audit log.

## تمرین
1. handler idempotent برای بروزرسانی cache طراحی کنید.
2. برای توقف یک‌روزه مسیر resume یا resync را تعیین کنید.

## آزمون و پاسخ
1. **پرسش:** Change Stream چیست؟
   **پاسخ:** رابط دنبال‌کردن تغییرهای داده.
2. **پرسش:** چرا handler idempotent باشد؟
   **پاسخ:** رویداد تکراری ممکن است.
3. **پرسش:** resume چه محدودیتی دارد؟
   **پاسخ:** حفظ oplog و اعتبار token.
4. **پرسش:** چرا باید از «checkpoint پیش از موفقیت side effect.» پرهیز کرد؟
   **پاسخ:** checkpoint زودهنگام می‌تواند event را از دست بدهد؛ token را بعد از side effect موفق ذخیره و handler را idempotent کنید.
5. **مسئلهٔ کاربردی:** handler idempotent برای بروزرسانی cache طراحی کنید.
   **پاسخ نمونه:** پردازش را به upsert بر اساس document key تبدیل کنید، پس از ثبت موفق نتیجه resume token را ذخیره کنید و در صورت پایان retention resync کامل داشته باشید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Change Stream از چه چیزی abstraction می‌دهد؟
   **پاسخ:** دنبال‌کردن مستقیم oplog.
7. **پرسش:** Resume token را چه وقت ذخیره می‌کنیم؟
   **پاسخ:** پس از durable شدن side effect.
8. **پرسش:** چرا duplicate ممکن است؟
   **پاسخ:** پردازش side effect و checkpoint اتمیک مشترک نیستند.
9. **پرسش:** updateLookup چه چیزی را می‌دهد؟
   **پاسخ:** سند کامل جاری در lookup، نه لزوماً snapshot تاریخی.
10. **پرسش:** Outage طولانی چه خطری دارد؟
   **پاسخ:** resume token ممکن است از oplog window خارج شود و resync لازم شود.

## منابع فارسی
- [Change Streams به فارسی](https://www.urhoba.net/fa/post/change-streams-mongodb)
- [راهنمای MongoDB فارسی](https://www.urhoba.net/fa/series/mongodb-rehberi)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Change Streams](https://www.mongodb.com/docs/manual/changeStreams/)
- [Resume a Change Stream](https://www.mongodb.com/docs/manual/changeStreams/#resume-a-change-stream)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#ecosystem-streams) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
