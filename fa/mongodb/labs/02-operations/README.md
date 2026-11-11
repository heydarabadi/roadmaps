# آزمایشگاه فصل عملیات

> **نسخهٔ انگلیسی:** [English edition](../../../../en/mongodb/labs/02-operations/README.md).

این داده‌ها فقط برای پایگاه تمرینی learning است. script collectionهای products، customers و orders را پاک و از نمونه‌ها دوباره پر می‌کند. آن را به production وصل نکنید.

## اجرا

~~~bash
mongosh "mongodb://localhost:27017" labs/02-operations/seed.mongosh.js
~~~

## تمرین

1. محصولات فعال را با قیمت و عنوان فهرست کنید.
2. محصول stock=0 را بیابید و دلیل عرضه‌نشدنش را بررسی کنید.
3. سفارش‌های paid یا shipped را با sort زمان بگیرید.
4. سفارش‌هایی را پیدا کنید که note ندارند؛ آن را با note:null مقایسه کنید.
5. سفارش O-100 را با $set به وضعیت shipped ببرید و matchedCount را بخوانید.
6. stock محصول KB-01 را تنها اگر حداقل یک عدد دارد یک واحد کم کنید.
7. شمار سفارش‌های open را با countDocuments محاسبه کنید.
8. برای مشتری C-200 صفحه‌بندی بر اساس createdAt و _id طراحی کنید.

## پاسخ‌های راهنما

1. filter برابر active:true و projection شامل title/price است.
2. MS-01 موجودی صفر و OLD-01 غیرفعال است؛ شرط فیلتر باید هر دو مفهوم را جدا کند.
3. از $in یا $or روی status و sort نزولی استفاده کنید.
4. نبودن note با {note:{$exists:false}}؛ مقدار null با {note:null} سنجیده می‌شود.
5. filter روی _id یکتا است؛ اگر سفارش وجود دارد matchedCount برابر 1 می‌شود.
6. filter شامل sku و stock:{$gte:1} و update شامل $inc:{stock:-1} است.
7. countDocuments({status:"open"}) دقیقاً مطابق filter می‌شمارد.
8. sort پایدار {createdAt:-1,_id:-1} و شرط بعدی بر اساس زوج آخرین کلید نوشته می‌شود.
