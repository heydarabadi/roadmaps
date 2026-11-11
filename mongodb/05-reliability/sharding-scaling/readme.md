# Sharding، Scaling و Tuning

> **English edition:** [Read this lesson in English](../../en/05-reliability/sharding-scaling/readme.md).

> **هدف یادگیری:** shard key را از روی query و توزیع انتخاب و scale را اندازه‌گیری کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: Sharding و رشد

Sharding یک collection را افقی بین shardها تقسیم می‌کند. Shardها معمولاً replica set هستند؛ config serverها metadata را نگه می‌دارند؛ mongos router query را به shard مناسب می‌فرستد. کلاینت باید از router به cluster متصل شود.

### shard key تصمیم معماری است

یک shard key خوب باید:
- cardinality کافی داشته باشد.
- بین shardها توزیع متوازن بسازد.
- با queryهای پرتکرار هم‌راستا باشد تا query targeted شود.
- hotspot نوشتن یا دامنهٔ داده ایجاد نکند.
- تغییرات آینده و نیاز resharding را تحمل کند.

Ranged sharding با بازهٔ کلید هم‌مکانی می‌دهد، اما کلید صعودی می‌تواند همهٔ writeهای تازه را به یک chunk هدایت کند. Hashed distribution متوازن‌تر می‌شود، ولی range query ممکن است چند shard را درگیر کند. هیچ کلیدی برای همهٔ workloadها ایده‌آل نیست.

### پیش از sharding

1. Query slow را با explain اندازه بگیرید.
2. indexهای ناکارآمد را اصلاح کنید.
3. سندها و arrayها را از نظر رشد بررسی کنید.
4. cache, RAM, CPU, disk IOPS و network را بسنجید.
5. vertical scale و data archive را مقایسه کنید.
6. سپس بار و ظرفیت مورد انتظار را به مدل shard key تبدیل کنید.

Sharding پیچیدگی backup، deployment، routing، balancing و debugging را اضافه می‌کند. برای آیندهٔ نامشخص، sharding را زود انجام ندهید؛ اما وقتی dataset/throughput از یک shard فراتر می‌رود، کلید را بر اساس داده و query اندازه‌گیری کنید.

## آموزش
Sharding داده و بار collection را میان shardها تقسیم می‌کند. هر shard معمولاً replica set است؛ config server metadata دارد و mongos درخواست‌ها را route می‌کند. shard key توزیع سند و امکان targeted query را تعیین می‌کند. query بدون shard key می‌تواند چند shard را درگیر کند.

Ranged sharding locality دارد، ولی کلید افزایشی hotspot می‌سازد. Hashed توزیع را متعادل‌تر می‌کند اما range query را پخش می‌کند. cardinality، توزیع، query pattern و نرخ نوشتن را ارزیابی کنید. ابتدا مدل، index، query و scale عمودی را بهینه کنید؛ sharding پیچیدگی عملیاتی دارد.

Tuning را با baseline، فرضیه و rollback انجام دهید. CPU، memory، disk latency، connections، replication lag و p95/p99 را پایش کنید. تنظیمات Atlas و self-managed متفاوت‌اند؛ توصیه‌های قدیمی را با نسخهٔ جاری تطبیق دهید.

## مثال
~~~javascript
// نمونهٔ آموزشی؛ shard key را از workload انتخاب کنید
sh.shardCollection("shop.orders", { tenantId: 1, orderId: 1 })
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
در فروشگاه multi-tenant، tenantId شاید query را هدفمند کند؛ اما یک tenant بسیار بزرگ hotspot ایجاد می‌کند. بدترین توزیع واقعی را تست و fan-out را پایش کنید.

### مطالعهٔ موردی: Bazaarvoice و Coinbase

در مطالعهٔ منتشرشده توسط MongoDB، Bazaarvoice گزارش می‌کند که پس از تمام‌شدن راه‌های scale عمودی، catalog را shard کرد و دادهٔ هر retailer را کنار هم نگه داشت تا queryهای tenant تا حد امکان به یک shard هدف‌گیری شوند. درس طراحی این است که shard key باید هم توزیع قابل‌قبول بدهد و هم مسیر query را هدفمند کند؛ عددهای کارایی گزارش‌شده benchmark مستقل نیستند. [گزارش Bazaarvoice](https://www.mongodb.com/solutions/customer-case-studies/bazaarvoice)

Coinbase در مطالعهٔ MongoDB از کاهش زمان scale و پیش‌بینی جهش ترافیک با سیگنال بازار گزارش می‌دهد؛ در همان صفحه sharding را برای مرحلهٔ بعد و رفع محدودیت scale عمودی مطرح می‌کند. این نمونه یادآوری می‌کند که افزایش ظرفیت، پیش‌بینی بار و scale عمودی می‌تواند قبل از sharding بخشی از نیاز را پاسخ دهد. [گزارش Coinbase](https://www.mongodb.com/solutions/customer-case-studies/coinbase)

این گزارش‌ها از ناشر/فروشندهٔ محصول‌اند و تجربهٔ همان سازمان را روایت می‌کنند؛ آن‌ها را شواهد قطعی برای بار کاری یا هزینهٔ خودتان ندانید.

## خطاهای رایج
- شاردکردن پیش از اثبات نیاز.
- کلید کم‌کاردینالیتی یا نامتوازن.
- hash بدون توجه به range query.
- اتصال برنامه به خود shard.
- tuning چند setting هم‌زمان.

## تمرین
1. سه shard key را از نظر توزیع و query امتیاز دهید.
2. شاخص‌های تصمیم vertical scaling یا sharding را فهرست کنید.

## آزمون و پاسخ
1. **پرسش:** mongos چیست؟
   **پاسخ:** router درخواست‌ها به shardها.
2. **پرسش:** shard key چه اثری دارد؟
   **پاسخ:** توزیع داده و routing query.
3. **پرسش:** مزیت hashed چیست؟
   **پاسخ:** توزیع معمولاً متوازن‌تر.
4. **پرسش:** چرا باید از «شاردکردن پیش از اثبات نیاز.» پرهیز کرد؟
   **پاسخ:** کلید بد query را fan-out و داده را نامتوازن می‌کند؛ cardinality، skew و query pattern را ارزیابی کنید.
5. **مسئلهٔ کاربردی:** سه shard key را از نظر توزیع و query امتیاز دهید.
   **پاسخ نمونه:** shard key نامزد را با توزیع tenant و queryهای پرتکرار بسنجید؛ اول index/مدل/منابع را بهینه کنید و بعد sharding را در صورت bottleneck اثبات‌شده انتخاب کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** mongos چه می‌کند؟
   **پاسخ:** query را به shard مناسب یا مناسب‌ها route می‌کند.
7. **پرسش:** shard key چه اثری دارد؟
   **پاسخ:** توزیع سند و امکان targeted query را تعیین می‌کند.
8. **پرسش:** مزیت hashed key چیست؟
   **پاسخ:** توزیع کلیدها می‌تواند متوازن‌تر باشد.
9. **پرسش:** هزینهٔ hashed برای range query؟
   **پاسخ:** query ممکن است به shardهای بیشتری broadcast شود.
10. **پرسش:** چرا پیش از sharding index و schema را بررسی می‌کنیم؟
   **پاسخ:** ممکن است گلوگاه با پیچیدگی کمتر رفع شود.

## منابع فارسی
- [Sharding در MongoDB فارسی](https://www.urhoba.net/fa/post/sharding-mongodb)
- [مقیاس‌پذیری در فارسی](https://pars.host/blog/what-is-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Sharding Architecture](https://www.mongodb.com/docs/manual/sharding/)
- [Choose a Shard Key](https://www.mongodb.com/docs/manual/core/sharding-choose-a-shard-key/)
- [Production Notes](https://www.mongodb.com/docs/manual/administration/production-notes/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#reliability-sharding) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
