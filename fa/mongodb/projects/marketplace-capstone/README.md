# پروژهٔ پایانی — فروشگاه آنلاین

> **نسخهٔ انگلیسی:** [English edition](../../../../en/mongodb/projects/marketplace-capstone/README.md).

این پروژه چند فصل را در یک مسئلهٔ واحد جمع می‌کند. دادهٔ تمرینی بسازید و از دیتابیس محلی با نام learning استفاده کنید. مثال‌های حذف/بازنویسی را روی production اجرا نکنید.

## نیازهای سامانه

- فهرست و جست‌وجوی محصول.
- مشاهدهٔ مشتری و سفارش‌هایش.
- ثبت سفارش همراه snapshot قیمت و آدرس زمان خرید.
- جلوگیری از فروش موجودی منفی.
- گزارش فروش روزانه و ۱۰ محصول پرفروش.
- به‌روزرسانی search index پس از تغییر محصول.
- حفظ داده و امکان بازیابی پس از خرابی.

## مرحلهٔ ۱: access pattern

پیش از ساخت collection، queryها را بنویسید:

| درخواست | Filter | Sort | Projection |
|---|---|---|---|
| صفحهٔ محصول | sku یا active/category | مشخص بر اساس محصول | title/price/attributes |
| سفارش مشتری | customerId | createdAt نزولی, _id نزولی | id/status/total/date |
| وضعیت سفارش | _id | ندارد | status/items/total |
| محصولات کم‌موجودی | stock و active | stock صعودی | sku/title/stock |
| گزارش روزانه | createdAt بازه و status | روز/revenue | مجموع‌ها |

از این جدول برای مدل داده و index استفاده کنید.

## مرحلهٔ ۲: مدل documentها

### products

- sku یکتا.
- title، price از نوع Decimal128، stock عددی و active boolean.
- attributes برای ویژگی‌های محدود و متغیر همان محصول.
- tags آرایهٔ کوتاه و کنترل‌شده.

### customers

- customerId یکتا، name، email و address فعلی.
- orders را به صورت آرایهٔ نامحدود داخل customer ذخیره نکنید.

### orders

- customerId به عنوان reference.
- createdAt از نوع Date.
- status از فهرست کنترل‌شده.
- items آرایهٔ محدود با sku، titleAtPurchase، qty، unitPrice.
- shippingAddressAtPurchase به صورت snapshot.
- total با Decimal128 و currency مشخص.

قیمت و عنوان داخل order تاریخچه‌اند؛ منبع محصول جاری نیستند.

## مرحلهٔ ۳: validator

برای orders وجود status، createdAt، customerId و items را enforce کنید. total باید decimal و createdAt باید date باشد. ابتدا داده‌های موجود و writerها را بررسی کنید؛ بعد validation را سخت‌گیرانه فعال کنید. اگر شکل قدیمی وجود دارد، expand-migrate-contract اجرا کنید.

## مرحلهٔ ۴: index از روی query

نمونهٔ آغازین، نه نسخهٔ قطعی:

~~~javascript
db.products.createIndex({ sku: 1 }, { unique: true })
db.products.createIndex({ active: 1, category: 1, price: 1 })
db.orders.createIndex({ customerId: 1, createdAt: -1, _id: -1 })
db.orders.createIndex({ status: 1, createdAt: -1 })
~~~

برای هر index explain اجرا کنید. index روی fieldی که query استفاده نمی‌کند فقط هزینه اضافه می‌کند. Compound index و ترتیب آن را با واقعی‌ترین query بسنجید.

## مرحلهٔ ۵: عملیات CRUD

موجودی را با شرط در filter کم کنید:

~~~javascript
db.products.updateOne(
  { sku: "KB-01", stock: { $gte: 1 }, active: true },
  { $inc: { stock: -1 } }
)
~~~

اگر matchedCount صفر است، محصول موجود نیست/فعال نیست/موجودی ندارد. response را با پیغام مناسب مدیریت کنید. کاهش موجودی را با read جدا و سپس write غیرشرطی انجام ندهید؛ ممکن است هم‌زمان درخواست دیگری آخرین واحد را بخرد.

## مرحلهٔ ۶: Aggregation

۱۰ SKU پرفروش را از سفارش‌های paid/shipped استخراج کنید:

~~~javascript
db.orders.aggregate([
  { $match: { status: { $in: ["paid", "shipped"] } } },
  { $unwind: "$items" },
  { $group: {
      _id: "$items.sku",
      units: { $sum: "$items.qty" },
      revenue: { $sum: { $multiply: ["$items.qty", "$items.unitPrice"] } }
  } },
  { $sort: { revenue: -1 } },
  { $limit: 10 }
])
~~~

بازهٔ زمانی را به $match اضافه کنید. explain و تعداد سندهای بعد از unwind را بررسی کنید. اگر گزارش هر ثانیه روی کل سفارش‌ها اجرا می‌شود، pre-aggregation و تازگی عدد را ارزیابی کنید.

## مرحلهٔ ۷: تراکنش و side effect

یک طرح پیشنهادی:
1. اعتبار موجودی و شرط status را بررسی کنید.
2. کاهش stock، ایجاد order و ثبت event را با مرز consistency روشن انجام دهید.
3. تماس با درگاه خارجی را داخل transaction نگذارید.
4. idempotency key برای درخواست checkout ثبت کنید.
5. event outbox را worker منتشر کند.
6. نتیجهٔ نامعلوم از پرداخت با query وضعیت و reconciliation حل شود.

در جلسهٔ طراحی مشخص کنید آیا multi-document transaction لازم است یا می‌توان با reservation/state machine نیاز را کم کرد. هیچ‌کدام از این دو راهکار بدون تعریف failure mode کامل نیست.

## مرحلهٔ ۸: Change Stream و search

Change Stream محصولات را دنبال و Search index را به‌روز کند. event ممکن است تکراری باشد، پس consumer را idempotent بسازید. resume token را پس از durable شدن side effect ذخیره کنید. اگر token از oplog window خارج شد، index را از source بازسازی کنید.

## مرحلهٔ ۹: امنیت و عملیات

- app user فقط به collectionهای لازم دسترسی داشته باشد.
- secret از محیط امن خوانده شود.
- TLS و network restriction فعال باشند.
- audit/log بدون credential یا payload حساس نگهداری شود.
- RPO/RTO تعریف و backup restore test اجرا شود.
- alertهای disk، p95/p99، connection، replication lag و backup failure تنظیم شوند.

## تحویل پروژه

یک فایل design بنویسید که access pattern، schema، indexها، concernها، failure mode، recovery، امنیت و نتیجهٔ explain را شرح دهد. اعداد performance باید از اجرای خودتان بیایند؛ عدد نمونه را به عنوان نتیجهٔ واقعی گزارش نکنید.

## پاسخ‌نامهٔ طراحی

- orders جدا از customers، به دلیل رشد و pagination مستقل.
- آدرس و قیمت snapshot داخل order برای حفظ تاریخچه.
- کاهش stock شرطی با $gte:1.
- index unique روی SKU و indexهای queryهای ثبت‌شده.
- transaction فقط برای invariantهایی که چند write دیتابیس را به هم وابسته می‌کنند.
- payment API با idempotency و reconciliation مدیریت می‌شود.
- backup با restore test اعتبار می‌گیرد؛ replica set جایگزین backup نیست.
- Search index قابل بازسازی و consumer idempotent است.
