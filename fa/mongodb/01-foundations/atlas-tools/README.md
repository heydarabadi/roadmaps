# Atlas، نصب و محیط کاری

> **English edition:** [Read this lesson in English](../../../../en/mongodb/01-foundations/atlas-tools/README.md).

> **هدف یادگیری:** سرور، mongosh، Compass، driver و Atlas را از هم جدا کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## آموزش
MongoDB Server داده را نگه می‌دارد و درخواست را اجرا می‌کند. mongosh پوستهٔ تعاملی است؛ Compass ابزار GUI برای مشاهده و ساخت query؛ driver کتابخانهٔ برنامه؛ Atlas سرویس مدیریت‌شدهٔ ابری است. Compass به تنهایی server اجرا نمی‌کند.

برای تمرین، سرور محلی، container یا cluster آزمایشی مناسب است. URI اتصال را secret بدانید، شبکه را محدود کنید و user کم‌دسترسی بسازید. dev/test/prod باید جدا باشند. نسخهٔ server و driver را ثبت و compatibility را بررسی کنید.

## تدریس کامل از صفر: راه‌اندازی محیط

### چهار ابزار را قاطی نکنید

- MongoDB Server داده را نگه می‌دارد.
- mongosh ابزار command-line برای اجرای MQL و script است.
- Compass برنامهٔ گرافیکی برای مشاهدهٔ document، index، aggregation و explain است.
- Driver کتابخانهٔ داخل برنامه است؛ برای هر زبان مستندات خودش را دارد.
- Atlas deployment مدیریت‌شدهٔ ابری است، نه جایگزین مفهوم database یا document.

### اتصال محلی

اگر Community Server روی همین دستگاه اجراست، نشانی رایج محلی به port 27017 وصل می‌شود. پس از نصب سرور و shell:

~~~bash
mongosh "mongodb://localhost:27017"
~~~

سپس در shell:

~~~javascript
use learning
db.runCommand({ ping: 1 })
db.createCollection("notes")
db.notes.insertOne({ text: "اولین سند", createdAt: new Date() })
db.notes.find()
~~~

نام دیتابیس را use انتخاب می‌کند؛ دیتابیس خالی معمولاً تا وقتی اولین داده نوشته نشود در فهرست دیتابیس‌ها دیده نمی‌شود.

### اتصال Atlas به‌صورت امن

در Atlas باید project/cluster بسازید، database user تعریف کنید، IP/network access را محدود کنید و connection string را از پنل بگیرید. در connection string واقعی password وجود دارد؛ آن را در README، screenshot، terminal log یا Git commit قرار ندهید. در برنامه آن را از environment/secret manager بخوانید. برای محیط آزمایشی از user مجزا و دسترسی محدود استفاده کنید.

### تفاوت dev، test و prod

داده و credential محیط‌ها را جدا کنید. در توسعه، دیتابیس قابل پاک‌سازی باشد. تست integration از نام دیتابیس مشخصی استفاده کند. در production، مجوز admin را به application ندهید، backup و alert را فعال کنید و تغییر schema را مرحله‌ای منتشر کنید. قبل از حذف یا update انبوه، مقصد و filter را دوباره بخوانید.

### عیب‌یابی اتصال

1. آیا server اجراست و port درست است؟
2. آیا hostname/DNS resolve می‌شود؟
3. آیا firewall یا IP access list اتصال را رد می‌کند؟
4. آیا user در authentication database درست ساخته شده؟
5. آیا password در URI به‌درستی URL-encode شده؟
6. آیا نسخهٔ driver با server سازگار است؟
7. آیا TLS certificate مورد اعتماد است؟
8. آیا خطا از authentication است یا network timeout؟

خطای اتصال را با فعال‌کردن دسترسی عمومی یا خاموش‌کردن بررسی TLS حل نکنید؛ ابتدا علت را بخوانید.

## مثال
~~~bash
mongosh "mongodb://localhost:27017"
~~~
~~~javascript
use learning
db.products.insertOne({ name: "کیبورد", active: true })
db.products.find()
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
DBaaS نگهداری زیرساخت را کم می‌کند، اما انتخاب region، دسترسی شبکه، backup و هزینه همچنان باید طراحی شوند. گزارش Forbes نمونهٔ مهاجرت به Atlas است، نه تضمین نتیجه برای همه.

## خطاهای رایج
- URI حاوی password در Git یا log.
- دسترسی شبکهٔ باز در production.
- اشتباه گرفتن Compass با server.
- دادن مجوز admin به برنامه.

## تمرین
1. نقشهٔ dev/test/prod و محل secret را مشخص کنید.
2. یک سند آزمایشی بسازید و نسخهٔ ابزارها را ثبت کنید.

## آزمون و پاسخ
1. **پرسش:** mongosh چیست؟
   **پاسخ:** پوستهٔ اجرای دستور، نه server.
2. **پرسش:** Compass چیست؟
   **پاسخ:** ابزار GUI برای اتصال و بررسی داده.
3. **پرسش:** Atlas چیست؟
   **پاسخ:** سرویس ابری مدیریت‌شدهٔ MongoDB.
4. **پرسش:** چرا باید از «URI حاوی password در Git یا log.» پرهیز کرد؟
   **پاسخ:** URI لو رفته به دسترسی غیرمجاز منجر می‌شود؛ secret manager، کاربر حداقل‌دسترسی و network restriction به کار ببرید.
5. **مسئلهٔ کاربردی:** نقشهٔ dev/test/prod و محل secret را مشخص کنید.
   **پاسخ نمونه:** سرور، shell، GUI و driver را جدا کنید؛ یک محیط dev جدا بسازید، URI را به شکل secret نگه دارید و اتصال را با mongosh آزمایش کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Compass خودش server است؟
   **پاسخ:** خیر؛ به deployment محلی یا دوردست وصل می‌شود.
7. **پرسش:** mongosh جای driver برنامه است؟
   **پاسخ:** خیر؛ mongosh ابزار تعامل است و driver در application اجرا می‌شود.
8. **پرسش:** چه چیزی باید در secret manager بماند؟
   **پاسخ:** URI و credential پایگاه‌داده.
9. **پرسش:** چرا محیط dev و prod جدا هستند؟
   **پاسخ:** برای جلوگیری از تغییر اشتباه، دسترسی بیش از حد و آلودگی داده.
10. **پرسش:** اولین بررسی در خطای اتصال چیست؟
   **پاسخ:** server/host/port، network، TLS، user و database authSource.

## منابع فارسی
- [نصب و محیط کاری MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-8)
- [MongoDB و Compass به فارسی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Install MongoDB](https://www.mongodb.com/docs/manual/installation/)
- [Atlas Get Started](https://www.mongodb.com/docs/atlas/getting-started/)
- [MongoDB Shell](https://www.mongodb.com/docs/mongodb-shell/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#foundations-tools) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
