# Indexها: single، compound، TTL و geospatial

> **English edition:** [Read this lesson in English](../../../../en/mongodb/04-performance/indexes/README.md).

> **هدف یادگیری:** ایندکس را از query واقعی استخراج و هزینهٔ آن را بسنجید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: چرا و چگونه index بسازیم؟

بدون index مناسب MongoDB ممکن است سندهای زیادی را بررسی کند. Index راهنمای مرتب‌شده‌ای از keyهاست که server را به سندهای کاندید هدایت می‌کند. Index خواندن را ارزان‌تر می‌کند، اما فضا می‌گیرد و در هر insert/update/delete باید نگهداری شود. پس index رایگان نیست.

### نوع‌های اصلی

- Single-field: جست‌وجوی یک field یا sort ساده.
- Compound: چند field؛ ترتیب keyها مهم است و prefixهای ابتدایی استفاده‌های متفاوت دارند.
- Multikey: field آرایه‌ای را index می‌کند؛ تعداد keyها ممکن است از تعداد سندها بیشتر شود.
- Unique: uniqueness را در database enforce می‌کند؛ دادهٔ تکراری قبلی جلوی ساختش را می‌گیرد.
- TTL: پاکسازی سندهای دارای تاریخ انقضا؛ زمان حذف دقیقاً سر ثانیه تضمین نیست و TTL index تک‌فیلدی است.
- Geospatial: query روی GeoJSON یا مختصات.
- Text index کلاسیک: جست‌وجوی متنی ساده‌تر؛ قابلیت‌های Atlas Search متفاوت‌اند.

### Compound index و روش ESR

برای query دارای equality، sort و range، قاعدهٔ شروع Equality → Sort → Range است: equalityها اول، sort بعد، range بعدتر. این heuristic است؛ cardinality، query واقعی، index prefix و explain را نیز بسنجید.

~~~javascript
db.orders.createIndex({ customerId: 1, status: 1, createdAt: -1, _id: -1 })
~~~

این index ممکن است query مشتری و وضعیت را با sort زمان پشتیبانی کند؛ اگر status اختیاری است یا query دیگری دارید، index متفاوتی ممکن است بهتر باشد.

### Partial و پوشش‌دهی

Partial index فقط اسناد مطابق filter تعریف‌شده را index می‌کند، پس اندازه کمتر می‌شود اما query باید با شرط آن سازگار باشد. Covered query تمام دادهٔ لازم را از index می‌خواند و به FETCH سند نیاز ندارد؛ طراحی projection و index روی آن اثر دارد. هر دو را با explain بررسی کنید.

### روش امن ساخت

1. Query shape پرتکرار را ثبت کنید.
2. Filter، sort و projection را از درخواست واقعی بردارید.
3. index نامزد را بسازید.
4. executionStats و latency را مقایسه کنید.
5. write throughput، اندازهٔ index و cache را نیز بسنجید.
6. indexهای بلااستفاده را با احتیاط و شواهد حذف کنید.

Index برای همهٔ fieldها نسازید؛ هر index هزینهٔ دائم در write و نگهداری ایجاد می‌کند.

## آموزش
Index ساختار کمکی برای یافتن سند است. single-field برای یک فیلد، compound برای چند فیلد و sort، multikey برای آرایه، unique برای یکتایی، TTL برای پاکسازی زمان‌دار و geospatial برای دادهٔ مکانی‌اند. ترتیب compound مهم است؛ prefixها و الگوی filter/sort را بسنجید.

TTL تک‌فیلدی است و حذف دقیقاً در لحظه تضمین نمی‌شود. text index کلاسیک با Atlas Search یکسان نیست. هر index فضا می‌گیرد و write را پرهزینه‌تر می‌کند؛ index روی هر فیلد نسازید. از slow query و explain شروع کنید و خواندن و نوشتن را با دادهٔ نماینده اندازه بگیرید.

## مثال
~~~javascript
db.orders.createIndex({ customerId: 1, createdAt: -1, _id: -1 })
db.sessions.createIndex({ expiresAt: 1 }, { expireAfterSeconds: 0 })
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
فروشگاهی که روی تمام fieldها index می‌سازد ممکن است حافظه و هزینهٔ write را زیاد کند. indexهای هدفمند را با queryهای واقعی انتخاب کنید.

## خطاهای رایج
- ساخت index برای هر فیلد.
- فراموشی ترتیب compound.
- انتظار حذف TTL در همان ثانیه.
- یکی گرفتن text index با search engine.
- نادیده‌گرفتن write cost.

## تمرین
1. برای filter روی customerId و sort زمان یک index پیشنهاد دهید.
2. TTL را با پاکسازی دوره‌ای cron مقایسه کنید.

## آزمون و پاسخ
1. **پرسش:** index چه trade-off دارد؟
   **پاسخ:** سرعت read در برابر فضا و هزینهٔ write.
2. **پرسش:** ترتیب compound مهم است؟
   **پاسخ:** بله، برای prefix و sort.
3. **پرسش:** TTL لحظه‌ای حذف می‌کند؟
   **پاسخ:** خیر؛ پاکسازی background است.
4. **پرسش:** چرا باید از «ساخت index برای هر فیلد.» پرهیز کرد؟
   **پاسخ:** indexهای بی‌هدف فضای ذخیره و هزینهٔ هر write را بالا می‌برند؛ فقط index مرتبط با query واقعی بسازید و explain را بررسی کنید.
5. **مسئلهٔ کاربردی:** برای filter روی customerId و sort زمان یک index پیشنهاد دهید.
   **پاسخ نمونه:** برای filter بر customerId و sort نزولی زمان، index compound با customerId اول و createdAt بعدی را آزمایش کنید؛ اثر sort و write را با explain/load بسنجید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** ترتیب compound index مهم است؟
   **پاسخ:** بله؛ prefixها و پوشش filter/sort به ترتیب بستگی دارند.
7. **پرسش:** TTL حذف را دقیقاً در زمان expiration تضمین می‌کند؟
   **پاسخ:** خیر؛ پاکسازی background است.
8. **پرسش:** Unique index چه می‌کند؟
   **پاسخ:** یکتایی key را enforce می‌کند.
9. **پرسش:** Multikey index معمولاً برای چیست؟
   **پاسخ:** Fieldهای آرایه‌ای.
10. **پرسش:** چرا index هزینهٔ write دارد؟
   **پاسخ:** هر تغییر سند ممکن است index keyها را هم به‌روز کند.

## منابع فارسی
- [ایندکس MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-5)
- [راهنمای فارسی index و کارایی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Indexes](https://www.mongodb.com/docs/manual/indexes/)
- [Index Types](https://www.mongodb.com/docs/manual/core/indexes/index-types/)
- [TTL Indexes](https://www.mongodb.com/docs/manual/core/index-ttl/)
- [Geospatial Queries](https://www.mongodb.com/docs/manual/geospatial-queries/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#performance-indexes) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
