# MongoDB Connectors: Kafka، Spark و Elasticsearch

> **English edition:** [Read this lesson in English](../../../../en/mongodb/07-ecosystem/connectors-detail/README.md).

> **هدف یادگیری:** connectorها را از نظر مالکیت، semantics، retry و resync ارزیابی کنید.

## تدریس کامل: سه الگوی یکپارچه‌سازی

### MongoDB و Kafka

Connector رسمی Kafka می‌تواند source یا sink باشد. Source تغییرهای MongoDB را در topic منتشر می‌کند؛ sink message را به collection می‌نویسد. topic key، ordering partition، offset، retry و dead-letter باید طراحی شود. Consumer ممکن است event را دوباره ببیند؛ write مقصد را idempotent کنید.

### MongoDB و Spark

Spark Connector دسترسی به collection را از jobهای Spark ممکن می‌کند. برای تحلیل بزرگ، projection و partitioning را درست انتخاب کنید تا همهٔ بار روی یک node یا shard نیفتد. job batch باید checkpoint و retry داشته باشد و حجم read را روی operational workload ارزیابی کنید.

### MongoDB و Elasticsearch

Elastic دارای MongoDB connector برای sync داده به Elasticsearch است؛ این محصول را با MongoDB Connector for Kafka اشتباه نگیرید. منبع connector، روش native یا self-managed، نسخهٔ سازگار Elastic و MongoDB، mapping فیلدها و delete semantics را بررسی کنید. مستندات قدیمی ممکن است دیگر update نشوند؛ current docs را مبنا قرار دهید.

### قرارداد جریان

هر رویداد باید key پایدار، نوع operation، نسخهٔ schema و رفتار delete داشته باشد. برای هر pipeline، lag، failure count، throughput، checkpoint age و replay status را dashboard کنید. اگر stream قابل resume نیست، روش snapshot + rebuild مقصد را داشته باشید.

## آموزش
Kafka Connector رسمی MongoDB می‌تواند source یا sink جریان داده باشد. Spark Connector دسترسی تحلیلی به داده را فراهم می‌کند. Elasticsearch در فهرست connectorهای فعلی Elastic، connector خودش را برای MongoDB دارد؛ آن connector توسط Elastic ارائه می‌شود، نه MongoDB. نسخه و وضعیت پشتیبانی هر دو سمت را بررسی کنید.

Connector به‌تنهایی exactly-once کسب‌وکاری، ordering یا سازگاری schema را تضمین نمی‌کند. منبع حقیقت، duplicate، checkpoint، retry، dead-letter، حذف سند، schema evolution و resync را مشخص کنید. بار analytics را از workload عملیاتی جدا و lag را پایش کنید.

## مثال
~~~text
MongoDB → Kafka topic → consumer idempotent → Elasticsearch index
خطا → retry → dead-letter → alert → resync
~~~

## سناریوی عملی
فروشگاه می‌تواند search index را از MongoDB بازسازی کند؛ index جست‌وجو باید projection قابل بازسازی باشد. در راهنمای Elastic نسخه و روش connector را بررسی کنید، چون docs قدیمی ممکن است دیگر به‌روز نباشند.

## خطاهای رایج
- فرض exactly-once.
- نداشتن idempotency برای duplicate.
- resync نداشتن پس از retention.
- استفاده از connector نامتناسب با نسخه.

## تمرین
1. جریان MongoDB تا search را برای duplicate، update و delete طراحی کنید.
2. معیار lag و dead-letter را تعیین کنید.

## آزمون و پاسخ
1. **پرسش:** Kafka Connector چه نقشی دارد؟
   **پاسخ:** source/sink بین MongoDB و pipelineهای Kafka.
2. **پرسش:** Elasticsearch connector را چه کسی نگه می‌دارد؟
   **پاسخ:** Elastic؛ طبق مستندات فعلی Elastic.
3. **پرسش:** چرا index باید بازسازی‌پذیر باشد؟
   **پاسخ:** تا خطای sync منبع حقیقت را از بین نبرد.
4. **پرسش:** چرا باید از «فرض exactly-once.» پرهیز کرد؟
   **پاسخ:** exactly-once فرضی باعث duplicate یا از دست‌رفتن داده می‌شود؛ semantics واقعی و recovery را بررسی کنید.
5. **مسئلهٔ کاربردی:** جریان MongoDB تا search را برای duplicate، update و delete طراحی کنید.
   **پاسخ نمونه:** Kafka/Spark را با نسخهٔ سازگار به کار برید؛ برای Elastic connector مستندات Elastic را مبنا قرار دهید، duplicate را idempotent کنید و resync را تمرین کنید.

## آزمون تکمیلی — مفاهیم و تصمیم‌گیری

6. **پرسش:** Kafka connector چه دو نقش دارد؟
   **پاسخ:** Source و sink.
7. **پرسش:** Spark connector برای چیست؟
   **پاسخ:** خواندن/نوشتن داده از jobهای تحلیلی Spark.
8. **پرسش:** MongoDB connector Elasticsearch را چه کسی منتشر می‌کند؟
   **پاسخ:** Elastic؛ طبق منابع فعلی.
9. **پرسش:** Dead letter چه می‌کند؟
   **پاسخ:** پیام‌های ناموفق را برای رسیدگی جدا نگه می‌دارد.
10. **پرسش:** چرا rebuild destination لازم است؟
   **پاسخ:** برای بازیابی پس از از دست‌رفتن offset/resume یا خرابی index.

## منابع فارسی
- [مسیر فارسی MongoDB و یکپارچه‌سازی](https://www.urhoba.net/fa/series/mongodb-rehberi)
- [معرفی MongoDB به فارسی](https://pars.host/blog/what-is-mongodb/)

> منابع فارسی ممکن است از نسخهٔ جاری عقب باشند؛ جزئیات را با مستندات رسمی انگلیسی تطبیق دهید.

## منابع انگلیسی و رسمی
- [MongoDB Kafka Connector](https://www.mongodb.com/docs/kafka-connector/current/)
- [MongoDB Spark Connector](https://www.mongodb.com/docs/spark-connector/current/)
- [Elastic MongoDB Connector](https://www.elastic.co/docs/reference/search-connectors/)
- [MongoDB Connectors overview](https://www.mongodb.com/products/integrations/connectors)

---
## منابع و مقاله‌های بیشتر
[کتابخانهٔ رفرنس‌های موضوعی](../../reference-library.md#ecosystem-streams) — مستندات رسمی، راهنماهای عملی، مقاله‌ها و تجربه‌های مرتبط.

بازبینی منابع: 2026-11-10
