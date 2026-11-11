# Driverها و Connectorها: Kafka، Spark، Elasticsearch

> **English edition:** [Read this lesson in English](../../../../en/mongodb/07-ecosystem/drivers-connectors/README.md).

> **هدف یادگیری:** اتصال برنامه و جریان داده را با pool، retry و idempotency طراحی کنید.

## جایگاه در مسیر
این درس بخشی از فصل مربوط است. مثال‌ها برای محیط آزمایشی‌اند؛ نسخه و قابلیت deployment خود را در مستندات رسمی بررسی کنید.

## تدریس کامل: connection pool و connector semantics

یک Driver اتصال برنامه را مدیریت می‌کند؛ connector جریان داده را بین سامانه‌ها جابه‌جا می‌کند. این دو را یکی نگیرید. Client driver در service معمولاً reuse می‌شود؛ connector ممکن است process مستقل با offset/checkpoint و consumer group باشد.

در pipeline داده سؤال‌ها را جواب دهید:
- منبع حقیقت کدام سامانه است؟
- event duplicate یا out-of-order شود چه می‌کنیم؟
- حذف سند چگونه منتقل می‌شود؟
- schema change چه اثری بر مقصد دارد؟
- cursor/offset آخر کجا ثبت می‌شود؟
- outage طولانی‌تر از retention چگونه recover می‌شود؟
- چه metricی lag و خطا را هشدار می‌دهد؟

MongoDB Connector for Apache Kafka source/sink می‌تواند change data و نوشتن را به Kafka متصل کند. Spark Connector داده را برای محاسبات Spark می‌دهد. برای Elasticsearch، Elastic connector فعلی MongoDB را خود Elastic نگه می‌دارد؛ نسخه و وضعیت native/self-managed را از مستندات همان نسخه بخوانید. Connector جای طراحی idempotency و resync را نمی‌گیرد.

برای workload تحلیلی حجیم، فشار خواندن connector را بر production اندازه بگیرید. batch size، parallelism و consistency را بدون آزمایش افزایش ندهید.

## آموزش
Driver کتابخانهٔ ارتباط application با MongoDB است؛ mongosh ابزار تعاملی است. client/pool را معمولاً یک بار بسازید و reuse کنید. timeout، connection limit، retry، type mapping و shutdown را تعریف کنید؛ URI در secret بماند.

Connector داده را به Kafka، Spark یا موتور search منتقل می‌کند، اما خودش semantics کسب‌وکار یا exactly-once را تضمین نمی‌کند. منبع حقیقت، ordering، duplicate، checkpoint، dead-letter، schema evolution و resync را مشخص کنید. outage طولانی ممکن است از oplog retention بیشتر شود.

## مثال
~~~text
MongoDB event → Kafka → consumer idempotent → search index
failure → retry → dead-letter → alert → resync
~~~

## تجربهٔ واقعی یا سناریوی کاربردی
در معماری فروشگاه، search index می‌تواند از MongoDB بازسازی شود؛ بنابراین خرابی sync از دست‌رفتن source data ایجاد نمی‌کند. lag و duplicateها را اندازه‌گیری کنید.

## خطاهای رایج
- ساخت client برای هر درخواست.
- فرض exactly-once از connector.
- نداشتن idempotency و resync.
- credential در log.

## تمرین
1. جریان MongoDB تا search را برای duplicate و delete طراحی کنید.
2. مدیریت pool و graceful shutdown را توصیف کنید.

## آزمون و پاسخ
1. **پرسش:** Driver چیست؟
   **پاسخ:** کتابخانهٔ اتصال برنامه به MongoDB.
2. **پرسش:** چرا pool reuse شود؟
   **پاسخ:** برای جلوگیری از اتصال‌سازی و فشار مکرر.
3. **پرسش:** connector exactly-once را تضمین می‌کند؟
   **پاسخ:** نه؛ semantics باید جدا بررسی شوند.
4. **پرسش:** چرا باید از «ساخت client برای هر درخواست.» پرهیز کرد؟
   **پاسخ:** clientهای متعدد poolهای جداگانه می‌سازند، handshake و connection churn را زیاد می‌کنند و منابع server را مصرف می‌کنند. یک client مناسب lifecycle سرویس را reuse کنید؛ اندازهٔ pool و timeout را بر مبنای بار تنظیم کنید.
5. **مسئلهٔ کاربردی:** جریان MongoDB تا search را برای duplicate و delete طراحی کنید.
   **پاسخ نمونه:** یک client مشترک در lifecycle برنامه بسازید؛ برای connector source of truth، checkpoint، retry، dead-letter و resync را مستند کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Driver با connector چه تفاوتی دارد؟
   **پاسخ:** Driver API برنامه است؛ connector جریان/داده را بین سامانه‌ها منتقل می‌کند.
7. **پرسش:** چرا client pool reuse می‌شود؟
   **پاسخ:** برای جلوگیری از اتصال‌سازی مکرر و استفاده از pool.
8. **پرسش:** connector exactly-once را تضمین می‌کند؟
   **پاسخ:** نه؛ قرارداد و idempotency باید طراحی شوند.
9. **پرسش:** منبع حقیقت در pipeline چیست؟
   **پاسخ:** سامانه‌ای که مالک دادهٔ اصلی است و باید صریح تعیین شود.
10. **پرسش:** چرا connector version مهم است؟
   **پاسخ:** Compatibility و schema behavior به نسخهٔ دو طرف وابسته است.

## منابع فارسی
- [MongoDB با Node.js به فارسی](https://www.urhoba.net/fa/post/node-js-mongodb)
- [مسیر فارسی MongoDB](https://www.urhoba.net/fa/series/mongodb-rehberi)

> برای قابلیت‌های تخصصی ممکن است منبع فارسی مستقل و به‌روز محدود باشد؛ جزئیات فنی را با منابع رسمی انگلیسی تطبیق دهید.

نکتهٔ مالکیت: Connectorهای Kafka و Spark در منابع MongoDB مستند شده‌اند؛ MongoDB connector فعلی Elasticsearch در فهرست Elastic نگهداری می‌شود و نسخهٔ همان مستندات را کنترل کنید.

## منابع انگلیسی و رسمی
- [Elastic MongoDB connector](https://www.elastic.co/docs/reference/search-connectors/)
- [راهنمای Elastic برای MongoDB connector](https://www.elastic.co/docs/reference/search-connectors/)
- [MongoDB Drivers](https://www.mongodb.com/docs/drivers/)
- [Kafka Connector](https://www.mongodb.com/docs/kafka-connector/current/)
- [Spark Connector](https://www.mongodb.com/docs/spark-connector/current/)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#ecosystem-drivers) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
