# Aggregation Pipeline

> **English edition:** [Read this lesson in English](../../en/04-performance/aggregation/readme.md).

> **هدف یادگیری:** داده را با stageهای pipeline فیلتر و تحلیل کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: Aggregation مرحله‌به‌مرحله

Aggregation جریان سندها را از stageهای پیاپی عبور می‌دهد. ابتدا ورودی را محدود کنید؛ بعد ساختار را تبدیل کنید؛ سپس گروه‌بندی و مرتب‌سازی انجام دهید.

### stageهای پرکاربرد

- $match: filter؛ در بسیاری موارد می‌تواند از index بهره ببرد.
- $project: انتخاب و محاسبهٔ فیلدها.
- $set/$addFields: افزودن یا تغییر field محاسباتی.
- $unwind: هر عضو آرایه را به سند مستقل تبدیل می‌کند.
- $group: گروه‌بندی و accumulatorهایی مثل $sum، $avg، $min، $max و $push.
- $sort، $skip و $limit: ترتیب و صفحه.
- $lookup: join با collection دیگر؛ باید index سمت foreign و cardinality را بررسی کنید.
- $count: شمارش خروجی مرحله.
- $facet: چند تحلیل موازی روی همان ورودی.

### محاسبهٔ فروش

~~~javascript
db.orders.aggregate([
  { $match: { status: { $in: ["paid", "shipped"] } } },
  { $unwind: "$items" },
  { $group: {
      _id: "$items.sku",
      units: { $sum: "$items.qty" },
      revenue: { $sum: {
        $multiply: ["$items.qty", "$items.unitPrice"]
      } }
  } },
  { $sort: { revenue: -1 } },
  { $limit: 10 }
])
~~~

$unwind تعداد سندها را افزایش می‌دهد. اگر یک order ده item داشته باشد، بعد از unwind ممکن است ده ورودی برای group بسازد. دقت کنید $sum روی نوع‌های ناسازگار نتیجهٔ قابل اتکا نمی‌دهد.

### Expression و accumulator

Expression معمولاً یک سند را تبدیل می‌کند؛ accumulator در $group مقدارهای چند سند را تجمیع می‌کند. جایگاه operator را از syntax و مستندات چک کنید. Pipeline می‌تواند null، آرایهٔ خالی و سند ناقص را متفاوت رفتار دهد؛ این حالت‌ها را هم در آزمایش بگنجانید.

### بهینه‌سازی

$match و $project را هرجا معنای query حفظ می‌شود نزدیک ورودی قرار دهید. $lookup را بعد از کاهش مجموعهٔ اصلی انجام دهید. explain و حدود حافظه را بررسی کنید. گزارش پرتکرار و پرهزینه شاید با computed pattern یا collection مشتق‌شده بهتر باشد؛ در آن صورت تازگی داده و روش بازسازی را تعریف کنید.

## آموزش
Pipeline زنجیره‌ای از stageهاست. $match فیلتر، $project شکل‌دهی، $group گروه‌بندی، $sort مرتب‌سازی، $unwind بازکردن آرایه، $lookup اتصال collection و $sum جمع‌زدن را انجام می‌دهند. مرحله‌های محدودکننده را زود قرار دهید، اگر معنای خروجی تغییر نمی‌کند.

$unwind تعداد اسناد را بالا می‌برد؛ $lookup و $group می‌توانند هزینه داشته باشند. pipeline را با دادهٔ نماینده و explain ارزیابی کنید. گزارش سنگین پرتکرار را می‌توان با computed field یا collection پیش‌محاسبه‌شده بررسی کرد.

## مثال
~~~javascript
db.orders.aggregate([
  { $match: { status: "paid" } },
  { $unwind: "$items" },
  { $group: { _id: "$items.sku", units: { $sum: "$items.qty" } } },
  { $sort: { units: -1 } },
  { $limit: 10 }
])
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
گزارش فروش روزانه با $match روی زمان، $unwind اقلام و $group بر اساس روز/محصول قابل ساخت است. اگر هر بازدید میلیون‌ها سند را تکراراً تحلیل می‌کند، پیش‌محاسبه و تازگی داده را بررسی کنید.

## خطاهای رایج
- فراموش‌کردن $match.
- نادیده‌گرفتن cardinality در $unwind.
- $lookup زیاد بدون explain.
- فرض ترتیب خروجی $group.
- گزارش سنگین بدون پایش.

## تمرین
1. فروش را بر اساس وضعیت سفارش گروه‌بندی کنید.
2. اثر unwind روی آرایهٔ سه‌عضوی را توضیح دهید.

## آزمون و پاسخ
1. **پرسش:** $match چه می‌کند؟
   **پاسخ:** اسناد را فیلتر می‌کند.
2. **پرسش:** $group چه می‌کند؟
   **پاسخ:** سندها را بر اساس کلید گروه می‌کند.
3. **پرسش:** $unwind چه می‌کند؟
   **پاسخ:** هر عضو آرایه را به سند جدا تبدیل می‌کند.
4. **پرسش:** چرا باید از «فراموش‌کردن $match.» پرهیز کرد؟
   **پاسخ:** بدون فیلتر زودهنگام pipeline ممکن است دادهٔ زیادی بخواند؛ cardinality و منابع مصرفی را بسنجید.
5. **مسئلهٔ کاربردی:** فروش را بر اساس وضعیت سفارش گروه‌بندی کنید.
   **پاسخ نمونه:** ابتدا $match، سپس $unwind روی items، بعد $group با $sum و در پایان $sort/$limit؛ خروجی و explain را روی دادهٔ بزرگ‌تر بررسی کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** $unwind چه اثری دارد؟
   **پاسخ:** هر عضو آرایه را به ورودی/سند جداگانه تبدیل می‌کند.
7. **پرسش:** $group به چه چیزی نیاز دارد؟
   **پاسخ:** کلید گروه‌بندی و accumulatorها.
8. **پرسش:** $lookup چه کاری می‌کند؟
   **پاسخ:** دادهٔ collection دیگر را به pipeline متصل می‌کند.
9. **پرسش:** چرا $match را زود می‌گذاریم؟
   **پاسخ:** برای کم‌کردن حجم سندهای پردازش‌شده, اگر معنی pipeline حفظ شود.
10. **پرسش:** computed pattern چه وقت مفید است؟
   **پاسخ:** وقتی محاسبهٔ پرتکرار هزینه‌بر است و نگهداری مقدار مشتق‌شده پذیرفتنی است.

## منابع فارسی
- [Aggregation MongoDB به فارسی](https://www.urhoba.net/fa/post/mongodb-aggregation-framework)
- [آموزش فارسی aggregation](https://darsman.com/course/aggregation-operations-in-mongodb/)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [Aggregation Pipeline](https://www.mongodb.com/docs/manual/aggregation/)
- [Aggregation Stages](https://www.mongodb.com/docs/manual/reference/operator/aggregation-pipeline/)
- [Pipeline Optimization](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-optimization/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#performance-aggregation) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
